module chip(
  input clk,
  input reset_async,
  output [3:0] led
  // output [7:0] SEG_o,
  // output [1:0] COM_o,
  // input [1:0] buttons_i,
  // input rs232_dce_rxd,
  // output rs232_dce_txd
);
	wire LOCKED;
// PLLE2_ADV: Advanced Phase Locked Loop (PLL)
// 7 Series
// Xilinx HDL Libraries Guide, version 14.7

  wire resetn;
	pll _pll(.CLK_IN1(clk),.CLK_OUT1(CLK_OUT1), .RESET(1'b0), .LOCKED(LOCKED)); 
	 
  reset_gen _reset_gen(CLK_OUT1, reset_async & LOCKED
				, resetn);

  top _top(CLK_OUT1,resetn,led); //,SEG_o,COM_o,buttons_i,rs232_dce_rxd,rs232_dce_txd);

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
module pll
 (// Clock in ports
  input         CLK_IN1,
  // Clock out ports
  output        CLK_OUT1,
  // Status and control signals
  input         RESET,
  output        LOCKED
 );

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
  wire        clkout1_unused;
  wire        clkout1b_unused;
  wire        clkout2_unused;
  wire        clkout2b_unused;
  wire        clkout3_unused;
  wire        clkout3b_unused;
  wire        clkout4_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;

  PLLE2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .COMPENSATION         ("ZHOLD"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT        (8),
    .CLKFBOUT_PHASE       (0.000),
    .CLKOUT0_DIVIDE       (8),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKIN1_PERIOD        (10.0),
    .REF_JITTER1          (0.010))
  plle2_adv_inst
    // Output clocks
   (.CLKFBOUT            (clkfbout),
    .CLKOUT0             (clkout0),
    .CLKOUT1             (clkout1_unused),
    .CLKOUT2             (clkout2_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
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
    // Other control and status signals
    .LOCKED              (LOCKED),
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




endmodule

`include "../rtl/top.v"
`include "../rtl/picorv32.v"
`include "../rtl/uart.v"
