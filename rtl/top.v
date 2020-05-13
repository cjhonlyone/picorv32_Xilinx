`timescale 1 ns / 1 ps
module top(
    // input [31:0] test,

    input        clk,
    input        resetn,
    output [3:0] led,
    input        rxd,
    output       txd,

    input        phy_rx_clk,
    input  [7:0] phy_rxd,
    input        phy_rx_dv,
    input        phy_rx_er,
    output       phy_gtx_clk,
    input        phy_tx_clk,
    output [7:0] phy_txd,
    output       phy_tx_en,
    output       phy_tx_er,
    output       phy_reset_n
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
  
  wire rx_DMA_int;
  always @(posedge clk) begin
    irq <= 0;
    irq[4] <= 0;//buttons_i[0];
    irq[5] <= rx_DMA_int;//buttons_i[1];
  end

  wire        text_valid = mem_valid && (mem_addr < 32'h 0001_0000);
  wire        text_ready;
  wire [31:0] text_rdata;

  wire        heap_valid = mem_valid && (mem_addr > 32'h 0000_FFFF) && (mem_addr < 32'h 0002_0000);
  wire        heap_ready;
  wire [31:0] heap_rdata;

  wire        io_valid = mem_valid && (mem_addr == 32'h 8000_0000);
  wire        io_ready;
  wire [31:0] io_rdata;

  wire        DMA_valid = mem_valid && (mem_addr >= 32'h 8000_0040) && (mem_addr < 32'h 8000_00D0);
  wire        DMA_ready;
  wire [31:0] DMA_rdata;
  // wire        simpleuart_reg_div_sel = mem_valid && (mem_addr == 32'h 8000_0004);
  // wire [31:0] simpleuart_reg_div_do;

  wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h 8000_0008);
  wire [31:0] simpleuart_reg_dat_do;
  wire        simpleuart_reg_dat_wait;


  wire        mux_heap_valid;
  wire [31:0] mux_heap_addr;
  wire [31:0] mux_heap_wdata;
  wire [ 3:0] mux_heap_wstrb;
  wire        mux_heap_ready;
  wire [31:0] mux_heap_rdata;

  wire        DMA_heap_valid;
  wire [31:0] DMA_heap_addr;
  wire [31:0] DMA_heap_wdata;
  wire [ 3:0] DMA_heap_wstrb;
  wire        DMA_heap_ready;
  wire [31:0] DMA_heap_rdata;
  
  wire        BUS_valid;
  wire        BUS_ready;

  RAM_64KB _text_RAM
    (
      .clk       (clk),
      .resetn    (resetn),
      .mem_valid (text_valid),
      .mem_ready (text_ready),
      .mem_addr  (mem_addr),
      .mem_wdata (mem_wdata),
      .mem_wstrb (mem_wstrb),
      .mem_rdata (text_rdata)
    );

  RAM_64KB _heap_RAM
    (
      .clk       (clk),
      .resetn    (resetn),
      .mem_valid (mux_heap_valid),
      .mem_ready (mux_heap_ready),
      .mem_addr  (mux_heap_addr),
      .mem_wdata (mux_heap_wdata),
      .mem_wstrb (mux_heap_wstrb),
      .mem_rdata (mux_heap_rdata)
    );

  IO _IO
    (
      .clk       (clk),
      .resetn    (resetn),
      .mem_valid (io_valid),
      .mem_ready (io_ready),
      .mem_addr  (mem_addr),
      .mem_wdata (mem_wdata),
      .mem_wstrb (mem_wstrb),
      .mem_rdata (io_rdata),
      .io        (led)
    );

   mux_heap _mux_heap
      (
         .clk            (clk),
         .resetn         (resetn),
         .mux_heap_valid (mux_heap_valid),
         .mux_heap_ready (mux_heap_ready),
         .mux_heap_addr  (mux_heap_addr),
         .mux_heap_wdata (mux_heap_wdata),
         .mux_heap_wstrb (mux_heap_wstrb),
         .mux_heap_rdata (mux_heap_rdata),
         .BUS_valid      (BUS_valid),
         .BUS_ready      (BUS_ready),
         .DMA_heap_valid (DMA_heap_valid),
         .DMA_heap_ready (DMA_heap_ready),
         .DMA_heap_addr  (DMA_heap_addr),
         .DMA_heap_wdata (DMA_heap_wdata),
         .DMA_heap_wstrb (DMA_heap_wstrb),
         .DMA_heap_rdata (DMA_heap_rdata),
         .CPU_heap_valid (heap_valid),
         .CPU_heap_ready (heap_ready),
         .CPU_heap_addr  (mem_addr),
         .CPU_heap_wdata (mem_wdata),
         .CPU_heap_wstrb (mem_wstrb),
         .CPU_heap_rdata (heap_rdata)
      );

    // AXI between MAC and Ethernet modules
    wire [31:0] rx_axis_tdata;
    wire rx_axis_tvalid;
    wire rx_axis_tready;
    wire [ 3:0] rx_axis_tkeep;
    wire rx_axis_tlast;
    wire rx_axis_tuser;

    wire [31:0] tx_axis_tdata;
    wire tx_axis_tvalid;
    wire tx_axis_tready;
    wire [ 3:0] tx_axis_tkeep;
    wire tx_axis_tlast;
    wire tx_axis_tuser;

   DMAC _DMAC
      (
         .clk            (clk),
         .resetn         (resetn),
         .mem_valid      (DMA_valid),
         .mem_ready      (DMA_ready),
         .mem_addr       (mem_addr),
         .mem_wdata      (mem_wdata),
         .mem_wstrb      (mem_wstrb),
         .mem_rdata      (DMA_rdata),
         .BUS_valid      (BUS_valid),
         .BUS_ready      (BUS_ready),
         .heap_valid     (DMA_heap_valid),
         .heap_ready     (DMA_heap_ready),
         .heap_addr      (DMA_heap_addr),
         .heap_wdata     (DMA_heap_wdata),
         .heap_wstrb     (DMA_heap_wstrb),
         .heap_rdata     (DMA_heap_rdata),
         .rx_axis_tdata  (rx_axis_tdata),
         .rx_axis_tkeep  (rx_axis_tkeep),
         .rx_axis_tvalid (rx_axis_tvalid),
         .rx_axis_tready (rx_axis_tready),
         .rx_axis_tlast  (rx_axis_tlast),
         .rx_axis_tuser  (rx_axis_tuser),
         .tx_axis_tdata  (tx_axis_tdata),
         .tx_axis_tkeep  (tx_axis_tkeep),
         .tx_axis_tvalid (tx_axis_tvalid),
         .tx_axis_tready (tx_axis_tready),
         .tx_axis_tlast  (tx_axis_tlast),
         .tx_axis_tuser  (tx_axis_tuser),
         .rx_DMA_int     (rx_DMA_int)
         // .tx_DMA_int     (tx_DMA_int)
      );

    eth_mac_1g_gmii_fifo #(
        .TARGET("XILINX"),
        .IODDR_STYLE("IODDR"),
        .CLOCK_INPUT_STYLE("BUFG"),
        .ENABLE_PADDING(1),
        .MIN_FRAME_LENGTH(64),
        .AXIS_DATA_WIDTH(32),
        .TX_FIFO_DEPTH(4096),
        .TX_FRAME_FIFO(1),
        .RX_FIFO_DEPTH(4096),
        .RX_FRAME_FIFO(1)
    )
    eth_mac_inst (
        .gtx_clk(clk),
        .gtx_rst(~resetn),
        .logic_clk(clk),
        .logic_rst(~resetn),

        .tx_axis_tdata(tx_axis_tdata),
        .tx_axis_tvalid(tx_axis_tvalid),
        .tx_axis_tready(tx_axis_tready),
        .tx_axis_tlast(tx_axis_tlast),
        .tx_axis_tuser(tx_axis_tuser),
        .tx_axis_tkeep(tx_axis_tkeep),

        .rx_axis_tdata(rx_axis_tdata),
        .rx_axis_tvalid(rx_axis_tvalid),
        .rx_axis_tready(rx_axis_tready),
        .rx_axis_tlast(rx_axis_tlast),
        .rx_axis_tuser(rx_axis_tuser),
        .rx_axis_tkeep(rx_axis_tkeep),

        .gmii_rx_clk(phy_rx_clk),
        .gmii_rxd(phy_rxd),
        .gmii_rx_dv(phy_rx_dv),
        .gmii_rx_er(phy_rx_er),
        .gmii_tx_clk(phy_gtx_clk),
        .mii_tx_clk(phy_tx_clk),
        .gmii_txd(phy_txd),
        .gmii_tx_en(phy_tx_en),
        .gmii_tx_er(phy_tx_er),

        .tx_fifo_overflow(),
        .tx_fifo_bad_frame(),
        .tx_fifo_good_frame(),
        .rx_error_bad_frame(),
        .rx_error_bad_fcs(),
        .rx_fifo_overflow(),
        .rx_fifo_bad_frame(),
        .rx_fifo_good_frame(),
        .speed(),

        .ifg_delay(12)
    );
// baud 115200
// 250MHz 2170
// 200MHz 1736
// 125MHz 1085
  simpleuart #(.DEFAULT_DIV(32'd50))
  uart (
    .clk         (clk         ),
    .resetn      (resetn      ),

    .ser_tx      (txd      ),
    .ser_rx      (rxd      ),

    .reg_div_we  (0),
    // .reg_div_di  (mem_wdata),
    // .reg_div_do  (simpleuart_reg_div_do),

    .reg_dat_we  (simpleuart_reg_dat_sel ? mem_wstrb[0] : 1'b 0),
    .reg_dat_re  (simpleuart_reg_dat_sel && !mem_wstrb),
    .reg_dat_di  (mem_wdata),
    .reg_dat_do  (simpleuart_reg_dat_do),
    .reg_dat_wait(simpleuart_reg_dat_wait)
  );

  assign mem_rdata = simpleuart_reg_dat_sel ? simpleuart_reg_dat_do :
               text_valid ? text_rdata : 
               mux_heap_valid ? mux_heap_rdata : 
               DMA_valid ? DMA_rdata : 32'h 0000_0000 ;

  assign mem_ready = (text_valid && text_ready) || 
                     (mux_heap_valid && mux_heap_ready) || 
                     (io_valid && io_ready) || 
                     (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait) ||
                     (DMA_valid && DMA_rdata) ;
  
endmodule

module RAM_64KB(
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

  ram_4k_32 _ram_4k_32_0(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_0, 
    (mem_valid && !mem_ready && (mem_addr[15:14] == 2'b00)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_1(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_1, 
    (mem_valid && !mem_ready && (mem_addr[15:14] == 2'b01)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_2(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_2, 
    (mem_valid && !mem_ready && (mem_addr[15:14] == 2'b10)) ? mem_wstrb : 4'b0,
    mem_valid);
  ram_4k_32 _ram_4k_32_3(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_3, 
    (mem_valid && !mem_ready && (mem_addr[15:14] == 2'b11)) ? mem_wstrb : 4'b0,
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

  always @(posedge clk) begin
    ram_rdata_0_reg0 <= ram_rdata_0;
    ram_rdata_1_reg0 <= ram_rdata_1;
    ram_rdata_2_reg0 <= ram_rdata_2;
    ram_rdata_3_reg0 <= ram_rdata_3;
  end

  assign mem_rdata = 
        (mem_valid && (mem_addr[15:14] == 2'b00)) ? ram_rdata_0_reg0 : 
        (mem_valid && (mem_addr[15:14] == 2'b01)) ? ram_rdata_1_reg0 : 
        (mem_valid && (mem_addr[15:14] == 2'b10)) ? ram_rdata_2_reg0 : 
        (mem_valid && (mem_addr[15:14] == 2'b11)) ? ram_rdata_3_reg0 : 32'h 0000_0000 ;

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
