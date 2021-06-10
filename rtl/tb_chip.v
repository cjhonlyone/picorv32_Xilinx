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
`define DEBUGREGS
module testbench;

	// Inputs
	reg clk = 1;
	reg reset_async = 0;
	reg rs232_dce_rxd = 0;
	reg [1:0] buttons_i = 0;

	// Outputs
	wire [3:0] led;
	wire rs232_dce_txd;

   reg [31:0] test;


   localparam ser_period = 10;
   localparam ser_half_period = ser_period*2;//*5/8;

	// Instantiate the Unit Under Test (UUT)

  chip #(
      .UART_BAUD(ser_period)
    ) uut (
      .CLK100MHZ    (clk),
      .CPU_RESETN   (reset_async),
      .SW           (SW),
      .LED          (LED),
      .LED16_B      (LED16_B),
      .LED16_G      (LED16_G),
      .LED16_R      (LED16_R),
      .LED17_B      (LED17_B),
      .LED17_G      (LED17_G),
      .LED17_R      (LED17_R),
      .CA           (CA),
      .CB           (CB),
      .CC           (CC),
      .CD           (CD),
      .CE           (CE),
      .CF           (CF),
      .CG           (CG),
      .DP           (DP),
      .AN           (AN),
      .UART_RXD_OUT (1'b1),
      .UART_TXD_IN  (UART_TXD_IN)
    );


   glbl glbl();

	always #5 clk = ~clk;
	
   initial begin
      $dumpfile("./rtl/testbench.vcd");
      $dumpvars(0, testbench.uut._top);
      test = 32'd0;
      repeat (2) @(posedge clk);
      reset_async = 1;
      $write("reset finished\n");

      repeat (500000) @(posedge clk);
      // repeat (500000) @(posedge clk);
      
      // repeat (1000) @(posedge clk);

      $finish;
   end

   wire ser_rx = 0;
   wire ser_tx = UART_TXD_IN;

   
   event ser_sample;
   reg [7:0] buffer;

   always begin
      @(negedge ser_tx);

      repeat (ser_half_period) @(posedge clk);
      -> ser_sample; // start bit

      repeat (8) begin
         repeat (ser_half_period) @(posedge clk);
         repeat (ser_half_period) @(posedge clk);
         buffer = {ser_tx, buffer[7:1]};
         -> ser_sample; // data bit
      end

      repeat (ser_half_period) @(posedge clk);
      repeat (ser_half_period) @(posedge clk);
      -> ser_sample; // stop bit

      // if (buffer < 32 || buffer >= 127)
      //    if (buffer == 10)
      //       $display(" ");
      //    else begin
      //       $display("Serial data: %d", buffer);
      //    end
      // else
         $write("%c", buffer);
   end

   initial begin
      $readmemh("firmware/hex/firmwareram00.hex", uut._top._text_RAM._ram_4k_32_0._bram0.mem);
      $readmemh("firmware/hex/firmwareram01.hex", uut._top._text_RAM._ram_4k_32_0._bram1.mem);
      $readmemh("firmware/hex/firmwareram02.hex", uut._top._text_RAM._ram_4k_32_0._bram2.mem);
      $readmemh("firmware/hex/firmwareram03.hex", uut._top._text_RAM._ram_4k_32_0._bram3.mem);
      $readmemh("firmware/hex/firmwareram04.hex", uut._top._text_RAM._ram_4k_32_1._bram0.mem);
      $readmemh("firmware/hex/firmwareram05.hex", uut._top._text_RAM._ram_4k_32_1._bram1.mem);
      $readmemh("firmware/hex/firmwareram06.hex", uut._top._text_RAM._ram_4k_32_1._bram2.mem);
      $readmemh("firmware/hex/firmwareram07.hex", uut._top._text_RAM._ram_4k_32_1._bram3.mem);
      $readmemh("firmware/hex/firmwareram08.hex", uut._top._text_RAM._ram_4k_32_2._bram0.mem);
      $readmemh("firmware/hex/firmwareram09.hex", uut._top._text_RAM._ram_4k_32_2._bram1.mem);
      $readmemh("firmware/hex/firmwareram10.hex", uut._top._text_RAM._ram_4k_32_2._bram2.mem);
      $readmemh("firmware/hex/firmwareram11.hex", uut._top._text_RAM._ram_4k_32_2._bram3.mem);
      $readmemh("firmware/hex/firmwareram12.hex", uut._top._text_RAM._ram_4k_32_3._bram0.mem);
      $readmemh("firmware/hex/firmwareram13.hex", uut._top._text_RAM._ram_4k_32_3._bram1.mem);
      $readmemh("firmware/hex/firmwareram14.hex", uut._top._text_RAM._ram_4k_32_3._bram2.mem);
      $readmemh("firmware/hex/firmwareram15.hex", uut._top._text_RAM._ram_4k_32_3._bram3.mem);
      // $readmemh("firmware/hex/firmwareram16.hex", uut._top._text_RAM._ram_4k_32_4._bram0.mem);
      // $readmemh("firmware/hex/firmwareram17.hex", uut._top._text_RAM._ram_4k_32_4._bram1.mem);
      // $readmemh("firmware/hex/firmwareram18.hex", uut._top._text_RAM._ram_4k_32_4._bram2.mem);
      // $readmemh("firmware/hex/firmwareram19.hex", uut._top._text_RAM._ram_4k_32_4._bram3.mem);
      // $readmemh("firmware/hex/firmwareram20.hex", uut._top._text_RAM._ram_4k_32_5._bram0.mem);
      // $readmemh("firmware/hex/firmwareram21.hex", uut._top._text_RAM._ram_4k_32_5._bram1.mem);
      // $readmemh("firmware/hex/firmwareram22.hex", uut._top._text_RAM._ram_4k_32_5._bram2.mem);
      // $readmemh("firmware/hex/firmwareram23.hex", uut._top._text_RAM._ram_4k_32_5._bram3.mem);
      // $readmemh("firmware/hex/firmwareram24.hex", uut._top._text_RAM._ram_4k_32_6._bram0.mem);
      // $readmemh("firmware/hex/firmwareram25.hex", uut._top._text_RAM._ram_4k_32_6._bram1.mem);
      // $readmemh("firmware/hex/firmwareram26.hex", uut._top._text_RAM._ram_4k_32_6._bram2.mem);
      // $readmemh("firmware/hex/firmwareram27.hex", uut._top._text_RAM._ram_4k_32_6._bram3.mem);
      // $readmemh("firmware/hex/firmwareram28.hex", uut._top._text_RAM._ram_4k_32_7._bram0.mem);
      // $readmemh("firmware/hex/firmwareram29.hex", uut._top._text_RAM._ram_4k_32_7._bram1.mem);
      // $readmemh("firmware/hex/firmwareram30.hex", uut._top._text_RAM._ram_4k_32_7._bram2.mem);
      // $readmemh("firmware/hex/firmwareram31.hex", uut._top._text_RAM._ram_4k_32_7._bram3.mem);

      $readmemh("firmware/hex/firmwareram16.hex", uut._top._heap_RAM._ram_4k_32_0._bram0.mem);
      $readmemh("firmware/hex/firmwareram17.hex", uut._top._heap_RAM._ram_4k_32_0._bram1.mem);
      $readmemh("firmware/hex/firmwareram18.hex", uut._top._heap_RAM._ram_4k_32_0._bram2.mem);
      $readmemh("firmware/hex/firmwareram19.hex", uut._top._heap_RAM._ram_4k_32_0._bram3.mem);
      $readmemh("firmware/hex/firmwareram20.hex", uut._top._heap_RAM._ram_4k_32_1._bram0.mem);
      $readmemh("firmware/hex/firmwareram21.hex", uut._top._heap_RAM._ram_4k_32_1._bram1.mem);
      $readmemh("firmware/hex/firmwareram22.hex", uut._top._heap_RAM._ram_4k_32_1._bram2.mem);
      $readmemh("firmware/hex/firmwareram23.hex", uut._top._heap_RAM._ram_4k_32_1._bram3.mem);
      $readmemh("firmware/hex/firmwareram24.hex", uut._top._heap_RAM._ram_4k_32_2._bram0.mem);
      $readmemh("firmware/hex/firmwareram25.hex", uut._top._heap_RAM._ram_4k_32_2._bram1.mem);
      $readmemh("firmware/hex/firmwareram26.hex", uut._top._heap_RAM._ram_4k_32_2._bram2.mem);
      $readmemh("firmware/hex/firmwareram27.hex", uut._top._heap_RAM._ram_4k_32_2._bram3.mem);
      $readmemh("firmware/hex/firmwareram28.hex", uut._top._heap_RAM._ram_4k_32_3._bram0.mem);
      $readmemh("firmware/hex/firmwareram29.hex", uut._top._heap_RAM._ram_4k_32_3._bram1.mem);
      $readmemh("firmware/hex/firmwareram30.hex", uut._top._heap_RAM._ram_4k_32_3._bram2.mem);
      $readmemh("firmware/hex/firmwareram31.hex", uut._top._heap_RAM._ram_4k_32_3._bram3.mem);
      
      // $readmemh("firmware/hex/firmwareram32.hex", uut._top._heap_RAM._ram_4k_32_0._bram0.mem);
      // $readmemh("firmware/hex/firmwareram33.hex", uut._top._heap_RAM._ram_4k_32_0._bram1.mem);
      // $readmemh("firmware/hex/firmwareram34.hex", uut._top._heap_RAM._ram_4k_32_0._bram2.mem);
      // $readmemh("firmware/hex/firmwareram35.hex", uut._top._heap_RAM._ram_4k_32_0._bram3.mem);
      // $readmemh("firmware/hex/firmwareram36.hex", uut._top._heap_RAM._ram_4k_32_1._bram0.mem);
      // $readmemh("firmware/hex/firmwareram37.hex", uut._top._heap_RAM._ram_4k_32_1._bram1.mem);
      // $readmemh("firmware/hex/firmwareram38.hex", uut._top._heap_RAM._ram_4k_32_1._bram2.mem);
      // $readmemh("firmware/hex/firmwareram39.hex", uut._top._heap_RAM._ram_4k_32_1._bram3.mem);
      // $readmemh("firmware/hex/firmwareram40.hex", uut._top._heap_RAM._ram_4k_32_2._bram0.mem);
      // $readmemh("firmware/hex/firmwareram41.hex", uut._top._heap_RAM._ram_4k_32_2._bram1.mem);
      // $readmemh("firmware/hex/firmwareram42.hex", uut._top._heap_RAM._ram_4k_32_2._bram2.mem);
      // $readmemh("firmware/hex/firmwareram43.hex", uut._top._heap_RAM._ram_4k_32_2._bram3.mem);
      // $readmemh("firmware/hex/firmwareram44.hex", uut._top._heap_RAM._ram_4k_32_3._bram0.mem);
      // $readmemh("firmware/hex/firmwareram45.hex", uut._top._heap_RAM._ram_4k_32_3._bram1.mem);
      // $readmemh("firmware/hex/firmwareram46.hex", uut._top._heap_RAM._ram_4k_32_3._bram2.mem);
      // $readmemh("firmware/hex/firmwareram47.hex", uut._top._heap_RAM._ram_4k_32_3._bram3.mem);
      // $readmemh("firmware/hex/firmwareram48.hex", uut._top._heap_RAM._ram_4k_32_4._bram0.mem);
      // $readmemh("firmware/hex/firmwareram49.hex", uut._top._heap_RAM._ram_4k_32_4._bram1.mem);
      // $readmemh("firmware/hex/firmwareram50.hex", uut._top._heap_RAM._ram_4k_32_4._bram2.mem);
      // $readmemh("firmware/hex/firmwareram51.hex", uut._top._heap_RAM._ram_4k_32_4._bram3.mem);
      // $readmemh("firmware/hex/firmwareram52.hex", uut._top._heap_RAM._ram_4k_32_5._bram0.mem);
      // $readmemh("firmware/hex/firmwareram53.hex", uut._top._heap_RAM._ram_4k_32_5._bram1.mem);
      // $readmemh("firmware/hex/firmwareram54.hex", uut._top._heap_RAM._ram_4k_32_5._bram2.mem);
      // $readmemh("firmware/hex/firmwareram55.hex", uut._top._heap_RAM._ram_4k_32_5._bram3.mem);
      // $readmemh("firmware/hex/firmwareram56.hex", uut._top._heap_RAM._ram_4k_32_6._bram0.mem);
      // $readmemh("firmware/hex/firmwareram57.hex", uut._top._heap_RAM._ram_4k_32_6._bram1.mem);
      // $readmemh("firmware/hex/firmwareram58.hex", uut._top._heap_RAM._ram_4k_32_6._bram2.mem);
      // $readmemh("firmware/hex/firmwareram59.hex", uut._top._heap_RAM._ram_4k_32_6._bram3.mem);
      // $readmemh("firmware/hex/firmwareram60.hex", uut._top._heap_RAM._ram_4k_32_7._bram0.mem);
      // $readmemh("firmware/hex/firmwareram61.hex", uut._top._heap_RAM._ram_4k_32_7._bram1.mem);
      // $readmemh("firmware/hex/firmwareram62.hex", uut._top._heap_RAM._ram_4k_32_7._bram2.mem);
      // $readmemh("firmware/hex/firmwareram63.hex", uut._top._heap_RAM._ram_4k_32_7._bram3.mem);
   end	

endmodule