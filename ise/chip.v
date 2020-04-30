module chip(
  input clk,
  input reset_async,
  output [3:0] led,
  output [7:0] SEG_o,
  output [1:0] COM_o,
  input [1:0] buttons_i,
  input rs232_dce_rxd,
  output rs232_dce_txd
);
 
  wire resetn;
  
  reset_gen _reset_gen(clk, reset_async, resetn);

  top _top(clk,resetn,led,SEG_o,COM_o,buttons_i,rs232_dce_rxd,rs232_dce_txd);

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

`include "../rtl/top.v"
`include "../rtl/picorv32.v"
`include "../rtl/uart.v"
