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
		.led(led)
		// .buttons_i(buttons_i),
		// .rs232_dce_rxd(rs232_dce_rxd), 
		// .rs232_dce_txd(rs232_dce_txd)
	);
	
	always #5 clk = ~clk;
	
	initial 
		# 555 reset_async = 1;
		
	reg [7:0] cnt = 0;
	// always @ (posedge clk) begin
	// 	cnt <= cnt + 1;
	// 	if ((cnt<8'hff) && (cnt>8'hfd))
	// 		buttons_i[0] <= 1;
	// 	else
	// 		buttons_i[0] <= 0;
	// end
   initial begin
   $readmemh("../firmware/firmwareram00.hex", uut._top._ram_4k_32_0._bram0.mem);
   $readmemh("../firmware/firmwareram01.hex", uut._top._ram_4k_32_0._bram1.mem);
   $readmemh("../firmware/firmwareram02.hex", uut._top._ram_4k_32_0._bram2.mem);
   $readmemh("../firmware/firmwareram03.hex", uut._top._ram_4k_32_0._bram3.mem);
   $readmemh("../firmware/firmwareram04.hex", uut._top._ram_4k_32_1._bram0.mem);
   $readmemh("../firmware/firmwareram05.hex", uut._top._ram_4k_32_1._bram1.mem);
   $readmemh("../firmware/firmwareram06.hex", uut._top._ram_4k_32_1._bram2.mem);
   $readmemh("../firmware/firmwareram07.hex", uut._top._ram_4k_32_1._bram3.mem);
   $readmemh("../firmware/firmwareram08.hex", uut._top._ram_4k_32_2._bram0.mem);
   $readmemh("../firmware/firmwareram09.hex", uut._top._ram_4k_32_2._bram1.mem);
   $readmemh("../firmware/firmwareram10.hex", uut._top._ram_4k_32_2._bram2.mem);
   $readmemh("../firmware/firmwareram11.hex", uut._top._ram_4k_32_2._bram3.mem);
   $readmemh("../firmware/firmwareram12.hex", uut._top._ram_4k_32_3._bram0.mem);
   $readmemh("../firmware/firmwareram13.hex", uut._top._ram_4k_32_3._bram1.mem);
   $readmemh("../firmware/firmwareram14.hex", uut._top._ram_4k_32_3._bram2.mem);
   $readmemh("../firmware/firmwareram15.hex", uut._top._ram_4k_32_3._bram3.mem);
   $readmemh("../firmware/firmwareram16.hex", uut._top._ram_4k_32_4._bram0.mem);
   $readmemh("../firmware/firmwareram17.hex", uut._top._ram_4k_32_4._bram1.mem);
   $readmemh("../firmware/firmwareram18.hex", uut._top._ram_4k_32_4._bram2.mem);
   $readmemh("../firmware/firmwareram19.hex", uut._top._ram_4k_32_4._bram3.mem);
   $readmemh("../firmware/firmwareram20.hex", uut._top._ram_4k_32_5._bram0.mem);
   $readmemh("../firmware/firmwareram21.hex", uut._top._ram_4k_32_5._bram1.mem);
   $readmemh("../firmware/firmwareram22.hex", uut._top._ram_4k_32_5._bram2.mem);
   $readmemh("../firmware/firmwareram23.hex", uut._top._ram_4k_32_5._bram3.mem);
   $readmemh("../firmware/firmwareram24.hex", uut._top._ram_4k_32_6._bram0.mem);
   $readmemh("../firmware/firmwareram25.hex", uut._top._ram_4k_32_6._bram1.mem);
   $readmemh("../firmware/firmwareram26.hex", uut._top._ram_4k_32_6._bram2.mem);
   $readmemh("../firmware/firmwareram27.hex", uut._top._ram_4k_32_6._bram3.mem);
   $readmemh("../firmware/firmwareram28.hex", uut._top._ram_4k_32_7._bram0.mem);
   $readmemh("../firmware/firmwareram29.hex", uut._top._ram_4k_32_7._bram1.mem);
   $readmemh("../firmware/firmwareram30.hex", uut._top._ram_4k_32_7._bram2.mem);
   $readmemh("../firmware/firmwareram31.hex", uut._top._ram_4k_32_7._bram3.mem);
   end	

endmodule

