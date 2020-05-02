module top(
  input clk,
  input resetn,
  output [3:0] led,
  input rxd,
  output txd
);

  wire trap;
  wire mem_valid;
  wire mem_instr;
  wire mem_ready;
  wire [31:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [3:0] mem_wstrb;
  wire [31:0] mem_rdata;
  reg [31:0] irq;
  
  picorv32 #(
    .ENABLE_REGS_DUALPORT(1),
    .COMPRESSED_ISA(1),
    .ENABLE_MUL(1),
    .ENABLE_DIV(1),
    .ENABLE_IRQ(1),
    .STACKADDR(32'h 0000_3fff)) 
  _picorv32(
    .clk(clk),
    .resetn(resetn),
    .trap(trap),
    .mem_valid(mem_valid),
    .mem_instr(mem_instr),
    .mem_ready(mem_ready),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .mem_rdata(mem_rdata),
   .irq(irq)
  );
  
  always @(posedge clk) begin
    irq <= 0;
    irq[4] <= 0;//buttons_i[0];
    irq[5] <= 0;//buttons_i[1];
  end
  
  wire [31:0] ram_rdata_0;
  wire [31:0] ram_rdata_1;
  wire [31:0] ram_rdata_2;
  wire [31:0] ram_rdata_3;
  wire [31:0] ram_rdata_4;
  wire [31:0] ram_rdata_5;
  wire [31:0] ram_rdata_6;
  wire [31:0] ram_rdata_7;
  wire [31:0] io_rdata;
  reg [31:0] mem_addr1;

  wire        ram_sel = mem_valid && (mem_addr < 32'h 0002_0000);

  wire        simpleuart_reg_div_sel = mem_valid && (mem_addr == 32'h 8000_0004);
  wire [31:0] simpleuart_reg_div_do;

  wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h 8000_0008);
  wire [31:0] simpleuart_reg_dat_do;
  wire        simpleuart_reg_dat_wait;

  wire        led_sel = mem_valid && (mem_addr == 32'h 8000_0000);

  reg ram_ready;

  ram_4k_32 _ram_4k_32_0(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_0, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b000)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_1(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_1, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b001)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_2(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_2, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b010)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_3(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_3, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b011)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_4(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_4, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b100)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_5(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_5, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b101)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_6(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_6, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b110)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_7(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_7, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b111)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);

  always @(posedge clk) begin
    ram_ready <= ram_sel  && !ram_ready;
  end

  simpleuart #(.DEFAULT_DIV(32'd1085))
  uart (
    .clk         (clk         ),
    .resetn      (resetn      ),

    .ser_tx      (txd      ),
    .ser_rx      (rxd      ),

    .reg_div_we  (simpleuart_reg_div_sel ? mem_wstrb : 4'b 0000),
    .reg_div_di  (mem_wdata),
    .reg_div_do  (simpleuart_reg_div_do),

    .reg_dat_we  (simpleuart_reg_dat_sel ? mem_wstrb[0] : 1'b 0),
    .reg_dat_re  (simpleuart_reg_dat_sel && !mem_wstrb),
    .reg_dat_di  (mem_wdata),
    .reg_dat_do  (simpleuart_reg_dat_do),
    .reg_dat_wait(simpleuart_reg_dat_wait)
  );

  reg led_ready;
  reg [3:0] led_int;
  always @(posedge clk) begin
    if (!resetn)
      led_int[3:0] <= {trap,3'b011};
    else if (led_sel)
      led_int[3:0] <= mem_wdata[3:0];
  end

  always @(posedge clk) begin
    led_ready <= led_sel  && !led_ready;
  end

  assign mem_rdata = simpleuart_reg_div_sel ? simpleuart_reg_div_do : 
               simpleuart_reg_dat_sel ? simpleuart_reg_dat_do :
              (ram_sel && (mem_addr[16:14] == 3'b000)) ? ram_rdata_0 : 
              (ram_sel && (mem_addr[16:14] == 3'b001)) ? ram_rdata_1 : 
              (ram_sel && (mem_addr[16:14] == 3'b010)) ? ram_rdata_2 : 
              (ram_sel && (mem_addr[16:14] == 3'b011)) ? ram_rdata_3 : 
              (ram_sel && (mem_addr[16:14] == 3'b100)) ? ram_rdata_4 : 
              (ram_sel && (mem_addr[16:14] == 3'b101)) ? ram_rdata_5 : 
              (ram_sel && (mem_addr[16:14] == 3'b110)) ? ram_rdata_6 : 
              (ram_sel && (mem_addr[16:14] == 3'b111)) ? ram_rdata_7 : 32'h 0000_0000 ;

  assign mem_ready = ram_ready || led_ready || simpleuart_reg_div_sel || 
      (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait);

  assign led = led_int;
  
endmodule

module ram_4k_32(
  input clk,
  input [11:0] addr,
  input [31:0] din,
  output [31:0] dout,
  input [3:0] we,
  input en
);

  bram_4k_8 _bram0(clk, addr, din[7:0], dout[7:0], we[0], en);
  bram_4k_8 _bram1(clk, addr, din[15:8], dout[15:8], we[1], en);
  bram_4k_8 _bram2(clk, addr, din[23:16], dout[23:16], we[2], en);
  bram_4k_8 _bram3(clk, addr, din[31:24], dout[31:24], we[3], en);

endmodule

module bram_4k_8(
  input clk,
  input [11:0] addr,
  input [7:0] din,
  output [7:0] dout,
  input we,
  input en
);

  reg [7:0] mem[0:4095];
  reg [11:0] addr1;

  always @(posedge clk)
    if (en) begin
      addr1 <= addr;
      if (we)
        mem[addr] <= din;
    end      

  assign dout = mem[addr1];

endmodule
