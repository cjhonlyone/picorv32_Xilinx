`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:24:36 04/11/2020
// Design Name:   chip
// Module Name:   D:/work/CPU/RISCV/picorv32-Xilinx-ISE/xilinx/tb_chip.v
// Project Name:  chip
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: chip
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`define tb_chip
module tb_chip;

	// Inputs
	reg clk = 1;
	reg reset_async = 0;
	reg rs232_dce_rxd = 0;
	reg [1:0] buttons_i = 0;

	// Outputs
	wire [3:0] led;
	wire rs232_dce_txd;

	// Instantiate the Unit Under Test (UUT)
	chip uut (
		.clk(clk), 
		.reset_async(reset_async),
		.led(led), 
		.buttons_i(buttons_i),
		.rs232_dce_rxd(rs232_dce_rxd), 
		.rs232_dce_txd(rs232_dce_txd)
	);
	
	always #5 clk = ~clk;
	
	initial 
		# 555 reset_async = 1;
		
	reg [7:0] cnt = 0;
	always @ (posedge clk) begin
		cnt <= cnt + 1;
		if ((cnt<8'hff) && (cnt>8'hfd))
			buttons_i[0] <= 1;
		else
			buttons_i[0] <= 0;
	end
      
endmodule

