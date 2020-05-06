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
    .COMPRESSED_ISA(0),
    .ENABLE_MUL(1),
    .ENABLE_DIV(1),
    .ENABLE_IRQ(1),
    .STACKADDR(32'h 0001_ffff)) 
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

  wire        ram_sel = mem_valid && (mem_addr < 32'h 0002_0000);
  wire        ram_rady;
  wire [31:0] ram_rdata;

  wire        io_sel = mem_valid && (mem_addr == 32'h 8000_0000);
  wire        io_rady;
  wire [31:0] io_rdata;
   
  wire        simpleuart_reg_div_sel = mem_valid && (mem_addr == 32'h 8000_0004);
  wire [31:0] simpleuart_reg_div_do;

  wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h 8000_0008);
  wire [31:0] simpleuart_reg_dat_do;
  wire        simpleuart_reg_dat_wait;

  RAM _RAM
    (
      .clk       (clk),
      .resetn    (resetn),
      .mem_valid (ram_sel),
      .mem_ready (ram_ready),
      .mem_addr  (mem_addr),
      .mem_wdata (mem_wdata),
      .mem_wstrb (mem_wstrb),
      .mem_rdata (ram_rdata)
    );

  IO _IO
    (
      .clk       (clk),
      .resetn    (resetn),
      .mem_valid (io_sel),
      .mem_ready (io_ready),
      .mem_addr  (mem_addr),
      .mem_wdata (mem_wdata),
      .mem_wstrb (mem_wstrb),
      .mem_rdata (io_rdata),
      .io        (led)
    );

// baud 115200
// 250MHz 2170
// 200MHz 1736
// 125MHz 1085
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

  assign mem_rdata = simpleuart_reg_div_sel ? simpleuart_reg_div_do : 
               simpleuart_reg_dat_sel ? simpleuart_reg_dat_do :
               ram_sel ? ram_rdata : 32'h 0000_0000 ;

  assign mem_ready = ram_ready || io_ready || simpleuart_reg_div_sel || 
      (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait);
  
endmodule

module RAM(
  input clk, resetn,

  input            mem_valid,
  output           mem_ready,

  input     [31:0] mem_addr,
  input     [31:0] mem_wdata,
  input     [ 3:0] mem_wstrb,
  output    [31:0] mem_rdata
);
  wire [31:0] ram_rdata_0;
  wire [31:0] ram_rdata_1;
  wire [31:0] ram_rdata_2;
  wire [31:0] ram_rdata_3;
  wire [31:0] ram_rdata_4;
  wire [31:0] ram_rdata_5;
  wire [31:0] ram_rdata_6;
  wire [31:0] ram_rdata_7;

  ram_4k_32 _ram_4k_32_0(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_0, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b000)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_1(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_1, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b001)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_2(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_2, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b010)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_3(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_3, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b011)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_4(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_4, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b100)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_5(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_5, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b101)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_6(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_6, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b110)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_7(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_7, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b111)) ? mem_wstrb : 4'b0,
    mem_valid);

  reg ram_ready1, ram_ready2;
  reg mem_valid_reg;

  always @(posedge clk) begin
      if (!resetn) begin
        ram_ready2 <= 0;
        ram_ready1 <= 0;
        mem_valid_reg <= 0;
      end else begin
        if ((mem_valid == 1) && (mem_valid_reg == 0))
          ram_ready1 <= 1;
        if (ram_ready1)
          ram_ready1 <= 0;

        mem_valid_reg <= mem_valid;
        ram_ready2 <= ram_ready1;
      end
  end

  assign mem_ready = (|mem_wstrb == 1) ? ram_ready1 : ram_ready2;

  reg [31:0] ram_rdata_0_reg0;
  reg [31:0] ram_rdata_1_reg0;
  reg [31:0] ram_rdata_2_reg0;
  reg [31:0] ram_rdata_3_reg0;
  reg [31:0] ram_rdata_4_reg0;
  reg [31:0] ram_rdata_5_reg0;
  reg [31:0] ram_rdata_6_reg0;
  reg [31:0] ram_rdata_7_reg0;

  always @(posedge clk) begin
    ram_rdata_0_reg0 <= ram_rdata_0;
    ram_rdata_1_reg0 <= ram_rdata_1;
    ram_rdata_2_reg0 <= ram_rdata_2;
    ram_rdata_3_reg0 <= ram_rdata_3;
    ram_rdata_4_reg0 <= ram_rdata_4;
    ram_rdata_5_reg0 <= ram_rdata_5;
    ram_rdata_6_reg0 <= ram_rdata_6;
    ram_rdata_7_reg0 <= ram_rdata_7;
  end

  assign mem_rdata = 
        (mem_valid && (mem_addr[16:14] == 3'b000)) ? ram_rdata_0_reg0 : 
        (mem_valid && (mem_addr[16:14] == 3'b001)) ? ram_rdata_1_reg0 : 
        (mem_valid && (mem_addr[16:14] == 3'b010)) ? ram_rdata_2_reg0 : 
        (mem_valid && (mem_addr[16:14] == 3'b011)) ? ram_rdata_3_reg0 : 
        (mem_valid && (mem_addr[16:14] == 3'b100)) ? ram_rdata_4_reg0 : 
        (mem_valid && (mem_addr[16:14] == 3'b101)) ? ram_rdata_5_reg0 : 
        (mem_valid && (mem_addr[16:14] == 3'b110)) ? ram_rdata_6_reg0 : 
        (mem_valid && (mem_addr[16:14] == 3'b111)) ? ram_rdata_7_reg0 : 32'h 0000_0000 ;

endmodule

module IO(
  input clk, resetn,

  input            mem_valid,
  output reg       mem_ready,

  input     [31:0] mem_addr,
  input     [31:0] mem_wdata,
  input     [ 3:0] mem_wstrb,
  output reg   [31:0] mem_rdata,
  output    [ 3:0] io
);
  assign io = io_int;
  
  reg [3:0] io_int;
  always @(posedge clk) begin
    if (!resetn) begin
      io_int[3:0] <= 0;
      mem_rdata <= 0;
    end else if (mem_valid && !mem_ready)
      if (|mem_wstrb == 1)
        io_int[3:0] <= mem_wdata[3:0];
      else begin
        mem_rdata <= {24'd0, io_int};
      end
  end

  always @(posedge clk) begin
    mem_ready <= mem_valid  && !mem_ready;
  end

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

module dbram_4k_8 (clka,clkb,ena,enb,wea,web,addra,addrb,dia,dib,doa,dob);

    input  clka,clkb,ena,enb,wea,web;
    input  [5:0] addra,addrb;
    input  [7:0] dia,dib;
    output [7:0] doa,dob;
    reg    [7:0] ram [4095:0];
    reg    [7:0] doa,dob;

     
    always @(posedge clka) begin
        if (ena)    
        begin
            if (wea)
                ram[addra] <= dia;
            doa <= ram[addra];
        end
    end

    always @(posedge clkb) begin
        if (enb)
        begin
            if (web)
                ram[addrb] <= dib;
            dob <= ram[addrb];
        end
    end

endmodule
