module chip #
(
  parameter UART_BAUD       = 32'd1085
)(
  input CLK100MHZ,CPU_RESETN,

  input [15:0] SW,
  output [15:0] LED,
  output LED16_B,LED16_G,LED16_R,
  output LED17_B,LED17_G,LED17_R,
  output CA,CB,CC,CD,CE,CF,CG,DP,
  output [7:0]AN,

  output UART_RXD_OUT,
  input UART_TXD_IN
);

  wire mmcm_locked_out; // sfp sync;
  wire resetdone;

  wire LOCKED;

  wire clk_125mhz_int;
  wire clk_200mhz_int;

  (*MAX_FANOUT = 15 *) wire rst_125mhz_int;
  (*MAX_FANOUT = 15 *) wire rst_200mhz_int;

  dcm inst_dcm
    (
      .CLK_IN1  (CLK100MHZ),
      .CLK_OUT1 (clk_125mhz_int),
      .CLK_OUT2 (clk_200mhz_int),
      .RESET    (1'b0),
      .LOCKED   (LOCKED)
    );

  reset_gen _reset_gen_125mhz
    (
    .clk(clk_125mhz_int), 
    .reset_async(CPU_RESETN & LOCKED), 
    .resetn(rst_125mhz_int)
    );

  reset_gen _reset_gen_200mhz
    (
    .clk(clk_200mhz_int), 
    .reset_async(CPU_RESETN & LOCKED),
    .resetn(rst_200mhz_int)
    );

    wire [127:0] io_o;
    wire [127:0] io_i;
    wire [63:0] seg_disp;

    assign LED = io_o[15:0];
    assign {LED16_B,LED16_G,LED16_R} = io_o[33:32];
    assign {LED17_B,LED17_G,LED17_R} = io_o[50:48];
    assign seg_disp = io_o[127:64];

    assign io_i = {96'd0, SW};

  top #
    (
      .UART_BAUD       (UART_BAUD)
    )
  _top
    (
      // .test        (test),
//      .clk_125mhz         (clk_125mhz_int),
//      .resetn_125mhz      (resetn_125mhz_int),

      .clk_200mhz         (clk_125mhz_int),
      .resetn_200mhz      (rst_125mhz_int),

      .io_i        (io_i),
      .io_o        (io_o),
      .rxd         (UART_TXD_IN),
      .txd         (UART_RXD_OUT)
    );

    Seg_disp_decode
    _Seg_disp_decode
    (
      .clk    (clk_125mhz_int),
      .resetn (rst_125mhz_int),

      .seg_disp      (seg_disp),
      .CA            (CA),
      .CB            (CB),
      .CC            (CC),
      .CD            (CD),
      .CE            (CE),
      .CF            (CF),
      .CG            (CG),
      .DP            (DP),
      .AN            (AN)
      );
endmodule

module Seg_disp_decode(
  input clk,
  input resetn,

  input [127:0] seg_disp,
  output CA,CB,CC,CD,CE,CF,CG,DP,
  output reg [7:0]AN

);
  reg [3:0] segdata=4'd0; 
  reg [16:0] cnt = 0;
   reg [7:0]SEG;
  always@(posedge clk)
  begin
    case(cnt[16:14])
          3'b000:begin
              segdata <= seg_disp[3:0];AN <= 8'b11111110;
          end
          3'b001:begin
              segdata <= seg_disp[11:8];AN <= 8'b11111101;
          end
          3'b010:begin
              segdata <= seg_disp[19:16];AN <= 8'b11111011;
          end
          3'b011:begin
              segdata <= seg_disp[27:24];AN <= 8'b11110111;
          end
          3'b100:begin
              segdata <= seg_disp[35:32];AN <= 8'b11101111;
          end
          3'b101:begin
              segdata <= seg_disp[43:40];AN <= 8'b11011111;
          end
          3'b110:begin
              segdata <= seg_disp[51:48];AN <= 8'b10111111;
          end
          3'b111:begin
              segdata <= seg_disp[59:56]; AN <= 8'b01111111;
          end 
          default: begin segdata <= 0; AN <= 8'b11111111; end
    endcase
  end

  always@(posedge clk)
      cnt <= cnt + 1'b1;

always@(segdata)
  case(segdata)
    //g f e d c b a
    0 : SEG = 8'b00111111;//0
    1 : SEG = 8'b00000110;//1
    2 : SEG = 8'b01011011;//2
    3 : SEG = 8'b01001111;//3
    4 : SEG = 8'b01100110;//4
    5 : SEG = 8'b01101101;//5
    6 : SEG = 8'b01111101;//6
    7 : SEG = 8'b00000111;//7
    8 : SEG = 8'b01111111;//8
    9 : SEG = 8'b01101111;//9
    10: SEG = 8'b01110111;//A
    11: SEG = 8'b01111100;//b
    12: SEG = 8'b00111001;//C
    13: SEG = 8'b01011110;//d
    14: SEG = 8'b01111001;//E
    15: SEG = 8'b00000000;//F
  endcase
  
    assign CA = ~SEG[0];
    assign CB = ~SEG[1];
    assign CC = ~SEG[2];
    assign CD = ~SEG[3];
    assign CE = ~SEG[4];
    assign CF = ~SEG[5];
    assign CG = ~SEG[6];
    assign DP = ~SEG[7];
    
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
    .CLKFBOUT_MULT_F      (10.000),
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

    .CLKIN1_PERIOD        (10.000),
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


//`include "top.v"
//`include "picorv32.v"
// `include "simpleuart.v"
// `include "DMAC.v"

// `include "./eth/axis_adapter.v"
// `include "./eth/axis_async_fifo.v"
// `include "./eth/axis_async_fifo_adapter.v"
// `include "./eth/axis_gmii_rx.v"
// `include "./eth/axis_gmii_tx.v"
// `include "./eth/eth_mac_1g.v"
// `include "./eth/eth_mac_1g_gmii.v"
// `include "./eth/eth_mac_1g_gmii_fifo.v"
// `include "./eth/gmii_phy_if.v"
// `include "./eth/lfsr.v"
// `include "./eth/oddr.v"
// `include "./eth/ssio_sdr_in.v"
// `include "./eth/ssio_sdr_out.v"

//`include "./uart/uart.v"
//`include "./uart/uart_fifo.v"
//`include "./uart/uart_top.v"
//`include "./uart/fifo.v"