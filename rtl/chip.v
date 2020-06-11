module chip #
(
  parameter DMA_RX_INTERVAL = 32'd3329999,
  parameter UART_BAUD       = 32'd723
)(
  // input [31:0] test,
  input        PL_CLK,
  input        PL_RESET,
  output [3:0] F_LED,

  input        phy_sgmii_rx_p,
  input        phy_sgmii_rx_n,
  output       phy_sgmii_tx_p,
  output       phy_sgmii_tx_n,

  input        phy_sgmii_clk_p,
  input        phy_sgmii_clk_n,

  output       phy_reset_n
);

  wire mmcm_locked_out; // sfp sync;
  wire resetdone;

	wire LOCKED;

  wire clk_125mhz_int;
  wire clk_200mhz_int;
  wire clk_250mhz_int;

  (*MAX_FANOUT = 15 *) wire rst_125mhz_int;
  (*MAX_FANOUT = 15 *) wire rst_200mhz_int;
  (*MAX_FANOUT = 15 *) wire rst_250mhz_int;

  dcm inst_dcm
    (
      .CLK_IN1  (PL_CLK),
      .CLK_OUT1 (clk_125mhz_int),
      .CLK_OUT2 (clk_200mhz_int),
      .CLK_OUT3 (clk_250mhz_int),
      .RESET    (1'b0),
      .LOCKED   (LOCKED)
    );

  reset_gen _reset_gen_125mhz
    (
    .clk(clk_125mhz_int), 
    .reset_async(PL_RESET & LOCKED), 
    .resetn(rst_125mhz_int)
    );

  reset_gen _reset_gen_200mhz
    (
    .clk(clk_200mhz_int), 
    .reset_async(PL_RESET & LOCKED),  //delay 3ms in main.c for sgmii sync
    .resetn(rst_200mhz_int)
    );

  reset_gen _reset_gen_250mhz
    (
    .clk(clk_250mhz_int), 
    .reset_async(PL_RESET & LOCKED),  //delay 3ms in main.c for sgmii sync
    .resetn(rst_250mhz_int)
    );

  // SGMII interface to PHY
  wire         phy_gmii_clk_int;
  wire         phy_gmii_rst_int;
  wire         phy_gmii_clk_en_int = phy_gmii_rst_int;
  wire [7:0]   phy_gmii_txd_int;
  wire         phy_gmii_tx_en_int;
  wire         phy_gmii_tx_er_int;
  wire [7:0]   phy_gmii_rxd_int;
  wire         phy_gmii_rx_dv_int;
  wire         phy_gmii_rx_er_int;

  wire         phy_sgmii_mgtrefclk;
  wire         phy_sgmii_txoutclk;
  wire         phy_sgmii_userclk2;

  // IBUFDS_GTE2
  // phy_sgmii_ibufds_mgtrefclk (
  //     .CEB   (1'b0),
  //     .I     (phy_sgmii_clk_p),
  //     .IB    (phy_sgmii_clk_n),
  //     .O     (phy_sgmii_mgtrefclk),
  //     .ODIV2 ()
  // );

  // BUFG
  // phy_sgmii_bufg_userclk2 (
  //     .I     (phy_sgmii_txoutclk),
  //     .O     (phy_sgmii_userclk2)
  // );

  assign phy_gmii_clk_int = phy_sgmii_userclk2;

  reset_gen _reset_gen_sgmii
    (
    .clk            (phy_gmii_clk_int), 
    .reset_async    (PL_RESET & LOCKED), 
    .resetn         (phy_gmii_rst_int)
    );

  reg phy_gmii_rstn_int;
  always @(posedge clk_125mhz_int) begin
    phy_gmii_rstn_int <= ~phy_gmii_rst_int;
  end

  wire [15:0] pcspma_status_vector;

  wire pcspma_status_link_status              = pcspma_status_vector[0];
  wire pcspma_status_link_synchronization     = pcspma_status_vector[1];
  wire pcspma_status_rudi_c                   = pcspma_status_vector[2];
  wire pcspma_status_rudi_i                   = pcspma_status_vector[3];
  wire pcspma_status_rudi_invalid             = pcspma_status_vector[4];
  wire pcspma_status_rxdisperr                = pcspma_status_vector[5];
  wire pcspma_status_rxnotintable             = pcspma_status_vector[6];
  wire pcspma_status_phy_link_status          = pcspma_status_vector[7];
  wire [1:0] pcspma_status_remote_fault_encdg = pcspma_status_vector[9:8];
  wire [1:0] pcspma_status_speed              = pcspma_status_vector[11:10];
  wire pcspma_status_duplex                   = pcspma_status_vector[12];
  wire pcspma_status_remote_fault             = pcspma_status_vector[13];
  wire [1:0] pcspma_status_pause              = pcspma_status_vector[15:14];

  wire [4:0] pcspma_config_vector;

  assign pcspma_config_vector[4] = 1'b0; // autonegotiation enable
  assign pcspma_config_vector[3] = 1'b0; // isolate
  assign pcspma_config_vector[2] = 1'b0; // power down
  assign pcspma_config_vector[1] = 1'b0; // loopback enable
  assign pcspma_config_vector[0] = 1'b0; // unidirectional enable

  wire [15:0] pcspma_an_config_vector;

  assign pcspma_an_config_vector[15]    = 1'b1;    // SGMII link status
  assign pcspma_an_config_vector[14]    = 1'b1;    // SGMII Acknowledge
  assign pcspma_an_config_vector[13:12] = 2'b01;   // full duplex
  assign pcspma_an_config_vector[11:10] = 2'b10;   // SGMII speed
  assign pcspma_an_config_vector[9]     = 1'b0;    // reserved
  assign pcspma_an_config_vector[8:7]   = 2'b00;   // pause frames - SGMII reserved
  assign pcspma_an_config_vector[6]     = 1'b0;    // reserved
  assign pcspma_an_config_vector[5]     = 1'b0;    // full duplex - SGMII reserved
  assign pcspma_an_config_vector[4:1]   = 4'b0000; // reserved
  assign pcspma_an_config_vector[0]     = 1'b1;    // SGMII

  wire         independent_clock = clk_200mhz_int;
  //----------------------------------------------------------------------------
  // internal signals used in this top level example design.
  //----------------------------------------------------------------------------

   // clock generation signals for tranceiver
   wire         gtrefclk_bufg_out;
   wire         txoutclk;                 // txoutclk from GT transceiver.
   // wire         resetdone;                // To indicate that the GT transceiver has completed its reset cycle
   wire         userclk;                  
   wire         userclk2;                 


   // An independent clock source used as the reference clock for an
   // IDELAYCTRL (if present) and for the main GT transceiver reset logic.
   wire         independent_clock_bufg;

   // GMII signals
   wire         gmii_isolate;             // internal gmii_isolate signal.
   reg   [7:0]  gmii_txd_int;             // internal gmii_txd signal.
   reg          gmii_tx_en_int;           // internal gmii_tx_en signal.
   reg          gmii_tx_er_int;           // internal gmii_tx_er signal.
   wire  [7:0]  gmii_rxd_int;             // internal gmii_rxd signal.
   wire         gmii_rx_dv_int;           // internal gmii_rx_dv signal.
   wire         gmii_rx_er_int;           // internal gmii_rx_er signal.
   wire sgmii_clk_r , sgmii_clk_f;

   
   // Route independent_clock input through a BUFG
   BUFG  bufg_independent_clock (
      .I         (independent_clock),
      .O         (independent_clock_bufg)
   );

  //----------------------------------------------------------------------------
  // Instantiate the Core Block (core wrapper).
  //----------------------------------------------------------------------------
 gig_ethernet_pcs_pma_0  
   core_wrapper_i
   (

      .gtrefclk_p              (phy_sgmii_clk_p),
      .gtrefclk_n              (phy_sgmii_clk_n),
      .gtrefclk_out            (),
      .gtrefclk_bufg_out       (gtrefclk_bufg_out),
      
      .txp                     (phy_sgmii_tx_p),
      .txn                     (phy_sgmii_tx_n),
      .rxp                     (phy_sgmii_rx_p),
      .rxn                     (phy_sgmii_rx_n),
      .mmcm_locked_out         (mmcm_locked_out),
      .userclk_out             (phy_sgmii_userclk),
      .userclk2_out            (phy_sgmii_userclk2),
      .rxuserclk_out           (),
      .rxuserclk2_out          (phy_sgmii_rxuserclk2),
      .independent_clock_bufg  (independent_clock_bufg),
      .pma_reset_out           (),
      .resetdone               (resetdone),
      
      .sgmii_clk_r             (sgmii_clk_r),
      .sgmii_clk_f             (sgmii_clk_f),
      .sgmii_clk_en            (),
      .gmii_txd                (phy_gmii_txd_int),
      .gmii_tx_en              (phy_gmii_tx_en_int),
      .gmii_tx_er              (phy_gmii_tx_er_int),
      .gmii_rxd                (phy_gmii_rxd_int),
      .gmii_rx_dv              (phy_gmii_rx_dv_int),
      .gmii_rx_er              (phy_gmii_rx_er_int),
      .gmii_isolate            (),
      .configuration_vector    (pcspma_config_vector),
      .speed_is_10_100         (1'b0),
      .speed_is_100            (1'b0),
      .status_vector           (pcspma_status_vector),
      .reset                   (phy_gmii_rstn_int),
   

      .signal_detect           (1'b1),
      .gt0_qplloutclk_out      (),
      .gt0_qplloutrefclk_out   ()
      );


  wire [1:0] led;
  wire _tx;
  top #
    (
      .DMA_RX_INTERVAL (DMA_RX_INTERVAL),
      .UART_BAUD       (UART_BAUD)
    )
  _top
    (
      // .test        (test),
      .clk_125mhz      (clk_125mhz_int),
      .rst_125mhz      (rst_125mhz_int),

      .clk_200mhz      (clk_250mhz_int),
      .rst_200mhz      (rst_250mhz_int),

      .led         ({led, F_LED[1:0]}),
      .rxd         (1'b1),
      .txd         (_tx),

      .phy_gmii_clk    (phy_gmii_clk_int),
      .phy_gmii_rst    (phy_gmii_rst_int),
      .phy_gmii_clk_en (phy_gmii_clk_en_int),
      .phy_gmii_rxd    (phy_gmii_rxd_int),
      .phy_gmii_rx_dv  (phy_gmii_rx_dv_int),
      .phy_gmii_rx_er  (phy_gmii_rx_er_int),
      .phy_gmii_txd    (phy_gmii_txd_int),
      .phy_gmii_tx_en  (phy_gmii_tx_en_int),
      .phy_gmii_tx_er  (phy_gmii_tx_er_int),

      .phy_reset_n     (phy_reset_n)
    );

  assign F_LED[3] = _tx;
  assign F_LED[2] = 0;
  
endmodule

module reset_gen(
  input clk,
  input reset_async,
  output resetn
);

  reg [7:0] x = 8'hff;

  always @(posedge clk) begin
    if (!reset_async)
      x <= 8'hff;
    else
      x <= {x[6:0], 1'b0};
  end
    
  assign resetn = !x[7];

endmodule

//(* CORE_GENERATION_INFO = "dcm,clk_wiz_v3_6,{component_name=dcm,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,feedback_source=FDBK_AUTO,primtype_sel=MMCM_ADV,num_out_clk=1,clkin1_period=8.000,clkin2_period=10.000,use_power_down=false,use_reset=true,use_locked=true,use_inclk_stopped=false,use_status=false,use_freeze=false,use_clk_valid=false,feedback_type=SINGLE,clock_mgr_type=MANUAL,manual_override=false}" *)
module dcm
 (// Clock in ports
  input         CLK_IN1,
  // Clock out ports
  output        CLK_OUT1,
  output        CLK_OUT2,
  output        CLK_OUT3,
  // Status and control signals
  input         RESET,
  output        LOCKED
 );
 
 wire clkin1;
 wire clkout0;
 wire clkout1;
 wire clkout2;
 // Input buffering
  //------------------------------------
  IBUFG clkin1_buf
   (.O (clkin1),
    .I (CLK_IN1));


  // Clocking primitive
  //------------------------------------
  // Instantiation of the MMCM primitive
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused
  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        clkfbout;
  wire        clkfbout_buf;
  wire        clkfboutb_unused;
  wire        clkout0b_unused;
  wire        clkout1b_unused;
  wire        clkout2b_unused;
  wire        clkout3_unused;
  wire        clkout3b_unused;
  wire        clkout4_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (20.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),

    .CLKOUT0_DIVIDE_F     (8.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),

    .CLKOUT1_DIVIDE       (5),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),

    .CLKOUT2_DIVIDE       (3),
    .CLKOUT2_PHASE        (0.000),
    .CLKOUT2_DUTY_CYCLE   (0.500),
    .CLKOUT2_USE_FINE_PS  ("FALSE"),

    .CLKIN1_PERIOD        (20.000),
    .REF_JITTER1          (0.010))
  mmcm_adv_inst
    // Output clocks
   (.CLKFBOUT            (clkfbout),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (clkout0),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clkout1),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clkout2),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf),
    .CLKIN1              (clkin1),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (LOCKED),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (RESET));

  // Output buffering
  //-----------------------------------
  BUFG clkf_buf
   (.O (clkfbout_buf),
    .I (clkfbout));

  BUFG clkout1_buf
   (.O   (CLK_OUT1),
    .I   (clkout0));

  BUFG clkout2_buf
   (.O   (CLK_OUT2),
    .I   (clkout1));

  BUFG clkout3_buf
   (.O   (CLK_OUT3),
    .I   (clkout2));

endmodule

`include "top.v"
`include "picorv32.v"
// `include "simpleuart.v"
`include "DMAC.v"

`include "./eth/axis_adapter.v"
`include "./eth/axis_async_fifo.v"
`include "./eth/axis_async_fifo_adapter.v"
`include "./eth/axis_gmii_rx.v"
`include "./eth/axis_gmii_tx.v"
`include "./eth/eth_mac_1g.v"
`include "./eth/eth_mac_1g_gmii.v"
`include "./eth/eth_mac_1g_gmii_fifo.v"
`include "./eth/gmii_phy_if.v"
`include "./eth/lfsr.v"
`include "./eth/oddr.v"
`include "./eth/ssio_sdr_in.v"
`include "./eth/ssio_sdr_out.v"
`include "./eth/eth_mac_1g_fifo.v"

`include "./uart/uart.v"
`include "./uart/uart_fifo.v"
`include "./uart/uart_top.v"
`include "./uart/fifo.v"