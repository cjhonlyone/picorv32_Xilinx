`define dbg_hex
module top#
(
  parameter UART_BAUD       = 32'd1736
)
(
    input        clk_200mhz,
    input        resetn_200mhz,

    input [127:0] io_i,
    output [127:0] io_o,

    input        rxd,
    output       txd

);

  wire trap;
  wire mem_valid;
  wire mem_instr;
  wire [31:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [3:0] mem_wstrb;

  reg  mem_ready;
  reg  [31:0] mem_rdata;

  wire mem_ready_o;
  wire [31:0] mem_rdata_o;

  reg [31:0] irq;
  
  picorv32 #(
    // .TWO_CYCLE_ALU(1),
    .ENABLE_REGS_DUALPORT(1),
    .COMPRESSED_ISA(0),
    .ENABLE_MUL(1),
    .ENABLE_DIV(1),
    .ENABLE_IRQ(1),
    .STACKADDR(32'h 0003_ffff)) 
  _picorv32(
    .clk(clk_200mhz),
    .resetn(resetn_200mhz),
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

	always @(posedge clk_200mhz) begin
		irq <= 0;
		irq[4] <= io_i[0];
		irq[5] <= io_i[1];
	end
	
  reg  [31:0] text_addr;
  reg  [31:0] text_wdata;
  reg  [ 3:0] text_wstrb;
  reg         text_valid;
  wire        text_ready;
  wire [31:0] text_rdata;

  reg  [31:0] heap_addr;
  reg  [31:0] heap_wdata;
  reg  [ 3:0] heap_wstrb;
  reg         heap_valid;
  wire        heap_ready;
  wire [31:0] heap_rdata;

  reg  [31:0] io_addr;
  reg  [31:0] io_wdata;
  reg  [ 3:0] io_wstrb;
  reg         io_valid;
  wire        io_ready;
  wire [31:0] io_rdata;

  reg  [31:0] uart_addr;
  reg  [31:0] uart_wdata;
  reg  [ 3:0] uart_wstrb;
  reg         uart_valid;
  wire        uart_ready;
  wire [31:0] uart_rdata;

  always @(posedge clk_200mhz) begin
    text_addr  <= mem_addr;
    text_wdata <= mem_wdata;
    text_wstrb <= mem_wstrb;
    text_valid <= mem_valid && (mem_addr[31:16] == 16'h0000);

    heap_addr  <= mem_addr;
    heap_wdata <= mem_wdata;
    heap_wstrb <= mem_wstrb;
    heap_valid <= mem_valid && (mem_addr[31:16] == 16'h0001);

    io_addr  <= mem_addr;
    io_wdata <= mem_wdata;
    io_wstrb <= mem_wstrb;
    io_valid <= mem_valid && (mem_addr[31:16] == 16'h8001);

    uart_addr  <= mem_addr;
    uart_wdata <= mem_wdata;
    uart_wstrb <= mem_wstrb;
    uart_valid <= mem_valid && (mem_addr[31:16] == 16'h8002);
  end

  RAM_64KB _text_RAM
    (
      .clk       (clk_200mhz),
      .resetn    (resetn_200mhz),
      .mem_valid (text_valid),
      .mem_ready (text_ready),
      .mem_addr  (text_addr),
      .mem_wdata (text_wdata),
      .mem_wstrb (text_wstrb),
      .mem_rdata (text_rdata)
    );

  RAM_64KB _heap_RAM
    (
      .clk       (clk_200mhz),
      .resetn    (resetn_200mhz),
      .mem_valid (heap_valid),
      .mem_ready (heap_ready),
      .mem_addr  (heap_addr),
      .mem_wdata (heap_wdata),
      .mem_wstrb (heap_wstrb),
      .mem_rdata (heap_rdata)
    );

  IO _IO
    (
      .clk       (clk_200mhz),
      .resetn    (resetn_200mhz),
      .mem_valid (io_valid),
      .mem_ready (io_ready),
      .mem_addr  (io_addr),
      .mem_wdata (io_wdata),
      .mem_wstrb (io_wstrb),
      .mem_rdata (io_rdata),
      .io_i      (io_i),
      .io_o      (io_o)
    );

// baud 115200
// 250MHz 2170
// 200MHz 1736
// 125MHz 1085
//localparam uart_clk_devide = 16'd1;

  uart_top #(
      .CLOCK_DIVIDE(16'd271)
    ) 
  _uart_top (
      .clk       (clk_200mhz),
      .resetn    (resetn_200mhz),
      .mem_valid (uart_valid),
      .mem_ready (uart_ready),
      .mem_addr  (uart_addr),
      .mem_wdata (uart_wdata),
      .mem_wstrb (uart_wstrb),
      .mem_rdata (uart_rdata),
      .tx        (txd),
      .rx        (rxd)
    );

  assign mem_rdata_o = uart_valid ? uart_rdata :
               text_valid ? text_rdata : 
               io_valid ? io_rdata :
               heap_valid ? heap_rdata: 32'h 0000_0000 ;

  assign mem_ready_o = (text_valid && text_ready) || 
                    (heap_valid && heap_ready) || 
                     (io_valid && io_ready) || 
                     (uart_valid && uart_ready) ;

  always @(posedge clk_200mhz) begin
    mem_rdata <= mem_rdata_o;
    mem_ready <= mem_ready_o;
  end

//ila_0 ILA (
//    .clk(clk_200mhz), // IN
//    .probe0(mem_valid), // IN BUS [0:0]
//    .probe1(resetn_200mhz), // IN BUS [0:0]
//    .probe2(mem_ready), // IN BUS [0:0]
//    .probe3(mem_addr), // IN BUS [31:0]
//    .probe4(mem_wdata), // IN BUS [31:0]
//    .probe5(mem_wstrb), // IN BUS [3:0]
//    .probe6(mem_rdata) // IN BUS [31:0]
//);

endmodule

module RAM_128KB(
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

  reg ram_ready1, ram_ready2;
  reg mem_valid_reg;
  reg [31:0] mem_addr_reg0;
  reg [31:0] mem_addr_reg1;

  always @(posedge clk) begin
      if (!resetn) begin
        ram_ready2 <= 0;
        ram_ready1 <= 0;
        mem_valid_reg <= 0;
        mem_addr_reg0 <= 0;
        mem_addr_reg1 <= 0;
      end else begin
        if ((mem_valid == 1) && (mem_valid_reg == 0))
          ram_ready1 <= 1;
        if (ram_ready1)
          ram_ready1 <= 0;

        mem_valid_reg <= mem_valid;
        ram_ready2 <= ram_ready1;
        mem_addr_reg0 <= mem_addr;
        mem_addr_reg1 <= mem_addr_reg0;
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
              (mem_valid && (mem_addr_reg1[16:14] == 3'b000)) ? ram_rdata_0_reg0 : 
              (mem_valid && (mem_addr_reg1[16:14] == 3'b001)) ? ram_rdata_1_reg0 : 
              (mem_valid && (mem_addr_reg1[16:14] == 3'b010)) ? ram_rdata_2_reg0 : 
              (mem_valid && (mem_addr_reg1[16:14] == 3'b011)) ? ram_rdata_3_reg0 : 
              (mem_valid && (mem_addr_reg1[16:14] == 3'b100)) ? ram_rdata_4_reg0 : 
              (mem_valid && (mem_addr_reg1[16:14] == 3'b101)) ? ram_rdata_5_reg0 : 
              (mem_valid && (mem_addr_reg1[16:14] == 3'b110)) ? ram_rdata_6_reg0 : 
              (mem_valid && (mem_addr_reg1[16:14] == 3'b111)) ? ram_rdata_7_reg0 : 32'h 0000_0000 ;

endmodule

module RAM_64KB(
  input clk, resetn,

  input            mem_valid,
  output reg          mem_ready,

  input     [31:0] mem_addr,
  input     [31:0] mem_wdata,
  input     [ 3:0] mem_wstrb,
  output reg   [31:0] mem_rdata
);

  wire [31:0] ram_rdata_0;
  wire [31:0] ram_rdata_1;
  wire [31:0] ram_rdata_2;
  wire [31:0] ram_rdata_3;

  wire [ 3:0] ram_wstrb0_w = (mem_addr[15:14] == 2'b00) ? mem_wstrb : 4'b0;
  wire [ 3:0] ram_wstrb1_w = (mem_addr[15:14] == 2'b01) ? mem_wstrb : 4'b0;
  wire [ 3:0] ram_wstrb2_w = (mem_addr[15:14] == 2'b10) ? mem_wstrb : 4'b0;
  wire [ 3:0] ram_wstrb3_w = (mem_addr[15:14] == 2'b11) ? mem_wstrb : 4'b0;

  reg  [ 3:0] ram_wstrb0;
  reg  [ 3:0] ram_wstrb1;
  reg  [ 3:0] ram_wstrb2;
  reg  [ 3:0] ram_wstrb3;

  reg  [ 3:0] ram_wstrb0_r;
  reg  [ 3:0] ram_wstrb1_r;
  reg  [ 3:0] ram_wstrb2_r;
  reg  [ 3:0] ram_wstrb3_r;

  reg ram_ready1, ram_ready2;
  reg mem_valid_reg;
  reg [31:0] mem_addr_reg0;
  reg [31:0] mem_addr_reg1;

  always @(posedge clk) begin
    ram_wstrb0_r <= ram_wstrb0_w ;
    ram_wstrb1_r <= ram_wstrb1_w ;
    ram_wstrb2_r <= ram_wstrb2_w ;
    ram_wstrb3_r <= ram_wstrb3_w ;
    ram_wstrb0 <= mem_valid_reg ? ram_wstrb0_r : 4'b0000;
    ram_wstrb1 <= mem_valid_reg ? ram_wstrb1_r : 4'b0000;
    ram_wstrb2 <= mem_valid_reg ? ram_wstrb2_r : 4'b0000;
    ram_wstrb3 <= mem_valid_reg ? ram_wstrb3_r : 4'b0000;
  end

  ram_4k_32 _ram_4k_32_0(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_0, 
    ram_wstrb0,
    mem_valid);
  ram_4k_32 _ram_4k_32_1(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_1, 
    ram_wstrb1,
    mem_valid);
  ram_4k_32 _ram_4k_32_2(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_2, 
    ram_wstrb2,
    mem_valid);
  ram_4k_32 _ram_4k_32_3(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_3, 
    ram_wstrb3,
    mem_valid);

  always @(posedge clk) begin
      if (!resetn) begin
        ram_ready2 <= 0;
        ram_ready1 <= 0;
        mem_valid_reg <= 0;
        mem_addr_reg0 <= 0;
        mem_addr_reg1 <= 0;
      end else begin
        if ((mem_valid == 1) && (mem_valid_reg == 0))
          ram_ready1 <= 1;
        if (ram_ready1)
          ram_ready1 <= 0;

        mem_valid_reg <= mem_valid;
        ram_ready2 <= ram_ready1;
        mem_addr_reg0 <= mem_addr;
        mem_addr_reg1 <= mem_addr_reg0;
      end
  end

  wire        mem_ready_w;
  wire [31:0] mem_rdata_w;

  assign mem_ready_w = (|mem_wstrb == 1) ? ram_ready1 : ram_ready2;

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

  assign mem_rdata_w =
              (mem_addr_reg1[15:14] == 2'b00) ? ram_rdata_0_reg0 : 
              (mem_addr_reg1[15:14] == 2'b01) ? ram_rdata_1_reg0 : 
              (mem_addr_reg1[15:14] == 2'b10) ? ram_rdata_2_reg0 : 
              (mem_addr_reg1[15:14] == 2'b11) ? ram_rdata_3_reg0 : 32'h 0000_0000 ;

  always @(posedge clk) begin
    mem_rdata <= mem_rdata_w;
    mem_ready <= mem_ready_w;
  end

endmodule

module IO(
  input clk, resetn,

  input            mem_valid,
  output reg       mem_ready,

  input     [31:0] mem_addr,
  input     [31:0] mem_wdata,
  input     [ 3:0] mem_wstrb,
  output reg   [31:0] mem_rdata,
  input    [127:0] io_i,
  output    [127:0] io_o
);

  
  reg [127:0] io_o_int;
  reg       mem_valid_reg;
  
  assign io_o = io_o_int[127:0];
  
  always @(posedge clk) begin
    if (!resetn) begin
      io_o_int <= 128'd0;
      mem_ready <= 0;
      mem_rdata <= 0;
      mem_valid_reg <= 0;
    end else begin
      if ((mem_valid == 1) && (mem_valid_reg == 0))
        mem_ready <= 1;
      if (mem_ready)
        mem_ready <= 0;

      mem_valid_reg <= mem_valid;

      if ((mem_valid == 1) && (mem_valid_reg == 0)) begin
        // rx_BD_adr
        if (mem_addr[7:2] == 6'h10) begin
          mem_rdata <= io_o[31:0];
          if (mem_wstrb==4'hF) io_o_int[31:0] <= mem_wdata;
        end else if (mem_addr[7:2] == 6'h11) begin
          mem_rdata <= io_o[63:32];
          if (mem_wstrb==4'hF) io_o_int[63:32] <= mem_wdata;
        end else if (mem_addr[7:2] == 6'h12) begin
          mem_rdata <= io_o[95:64];
          if (mem_wstrb==4'hF) io_o_int[95:64] <= mem_wdata;
        end else if (mem_addr[7:2] == 6'h13) begin
          mem_rdata <= io_o[127:96];
          if (mem_wstrb==4'hF) io_o_int[127:96] <= mem_wdata;

        end else if (mem_addr[7:2] == 6'h14) begin
          mem_rdata <= io_i[31:0];
          // if (mem_wstrb==4'hF) io_o_int[159:128] <= mem_wdata;
        end else if (mem_addr[7:2] == 6'h15) begin
          mem_rdata <= io_i[63:32];
          // if (mem_wstrb==4'hF) io_int[191:160] <= mem_wdata;
        end else if (mem_addr[7:2] == 6'h16) begin
          mem_rdata <= io_i[95:64];
          // if (mem_wstrb==4'hF) io_int[223:192] <= mem_wdata;
        end else if (mem_addr[7:2] == 6'h17) begin
          mem_rdata <= io_i[127:96];
          // if (mem_wstrb==4'hF) io_int[255:224] <= mem_wdata;
        end

      end
    end
  end

endmodule

//module io(
//  input clk,
//  input reset,
//  input valid,
//  input [2:0] addr,
//  input [31:0] wdata,
//  input wstrb,
//  output reg [31:0] rdata,
//  output reg [2:0] led,
  
//  output reg [7:0] SEG_o,
//  output reg [1:0] COM_o,
  
//  input rxd,
//  output txd
//);

//// peripheral memory map
////
//// 80000000 out, LED [0], write
//// 80000004 UART TX, data [7:0], write
//// 80000008 UART TX, ready [0], read
//// 8000000c UART RX, data [7:0], read
//// 80000010 UART RX, ready [0], read

//  wire led_write_strobe =        valid && (addr==3'd0) && wstrb;
//  wire uart_tx_write_strobe =    valid && (addr==3'd1) && wstrb;
//  // reg uart_tx_write_strobe;
//  wire uart_rx_read_strobe =     valid && (addr==3'd3) && !wstrb;
//  // reg uart_rx_read_strobe;
//  wire lcd_write_strobe =        valid && (addr==3'd5) && wstrb;
//  wire lcd_enable_strobe =        valid && (addr==3'd6) && wstrb;
	
//  wire uart_tx_ready;
//  wire [7:0] uart_rx_data;
//  wire uart_rx_ready;
  
//  always @(posedge clk)
//    case (addr)
//      3'd2: rdata <= {31'd0, uart_tx_ready};
//      3'd3: rdata <= {24'd0, uart_rx_data};
//      3'd4: rdata <= {31'd0, uart_rx_ready};
//      default: rdata <= 32'd0;
//    endcase

//  wire baudclk16;

//  uart_baud_clock_16x _uart_baud_clock_16x(clk, baudclk16);

//  reg [7:0] uart_tx_data;
//  uart_tx _uart_tx(clk, reset, baudclk16, txd, wdata[7:0], uart_tx_ready, uart_tx_write_strobe);
//  // uart_tx _uart_tx(clk, reset, baudclk16, txd, uart_tx_data, uart_tx_ready, uart_tx_write_strobe);
//  uart_rx _uart_rx(clk, reset, baudclk16, rxd, uart_rx_data, uart_rx_ready, uart_rx_read_strobe);

//  // always @(posedge clk) begin
//  //   uart_rx_read_strobe <= 1;
//  //   if (uart_rx_ready)begin
//  //     uart_tx_data <= uart_rx_data;
//  //     uart_tx_write_strobe <= 1;
//  //   end else begin
//  //     uart_tx_data <= 8'h41;
//  //     uart_tx_write_strobe <= 0;      
//  //   end
//  // end

//  // uart_tx _uart_tx0(clk, reset, baudclk16, txd_1, 8'h41, uart_tx_ready, uart_tx_write_strobe);
//  // uart_rx _uart_rx0(clk, reset, baudclk16, rxd_1, uart_rx_data, uart_rx_ready, uart_rx_read_strobe);

//  always @(posedge clk) begin
//    // led[6] <= uart_tx_ready;
//    // led[5] <= uart_rx_ready;
//    // led[4] <= !txd;
//    // led[3] <= !rxd;
//    // if (led_write_strobe)
//	 if (reset)
//      led[2:0] <= 3'b011;//wdata[3:0];
//	 else if (led_write_strobe)
//		led[2:0] <= wdata[2:0];
//  end
  
//    (* ram_style = "distributed" *)
//    reg [7:0] lcd_table[0:15];
//    reg [3:0] lcd0,lcd1;
//    reg lcd_enable;
    
//    always @(posedge clk) begin
//        if (reset) begin
//            lcd0 <= 0;
//            lcd1 <= 0;
//            lcd_enable <= 0;
//        end else if (lcd_write_strobe) begin
//            lcd0 <= wdata[3:0];
//            lcd1 <= wdata[7:4];
//        end else if (lcd_enable_strobe) begin
//            lcd_enable <= wdata[0];
//        end
//        lcd_table[0]  <= 8'b00111111;//0
//        lcd_table[1]  <= 8'b00000110;//1
//        lcd_table[2]  <= 8'b01011011;//2
//        lcd_table[3]  <= 8'b01001111;//3
//        lcd_table[4]  <= 8'b01100110;//4
//        lcd_table[5]  <= 8'b01101101;//5
//        lcd_table[6]  <= 8'b01111101;//6
//        lcd_table[7]  <= 8'b00000111;//7
//        lcd_table[8]  <= 8'b01111111;//8
//        lcd_table[9]  <= 8'b01101111;//9
//        lcd_table[10] <= 8'b01110111;//A
//        lcd_table[11] <= 8'b01111100;//b
//        lcd_table[12] <= 8'b00111001;//C
//        lcd_table[13] <= 8'b01011110;//d
//        lcd_table[14] <= 8'b01111001;//E
//        lcd_table[15] <= 8'b00000000;//F
//    end
  
//    reg [16:0] lcd_state;

//  always @(posedge clk) begin
//	 if (reset) begin
//      lcd_state <= 0;
//      COM_o <= 2'b00;
//		SEG_o <= 8'd0;
//	 end else begin
//		if (lcd_state[16]) begin
//		  SEG_o <= lcd_table[lcd0];
//		  COM_o <= lcd_enable ? 2'b10 : 2'b00;
//		end else begin
//		  SEG_o <= lcd_table[lcd1];
//		  COM_o <= lcd_enable ? 2'b01 : 2'b00;
//		end
//		lcd_state <= lcd_state + 1;
//	 end
//  end  
  
//endmodule

//module ram_2k_32(
//  input clk,
//  input [10:0] addr,
//  input [31:0] din,
//  output [31:0] dout,
//  input [3:0] we,
//  input en
//);

//  bram_2k_8 _bram0(clk, addr, din[7:0], dout[7:0], we[0], en);
//  bram_2k_8 _bram1(clk, addr, din[15:8], dout[15:8], we[1], en);
//  bram_2k_8 _bram2(clk, addr, din[23:16], dout[23:16], we[2], en);
//  bram_2k_8 _bram3(clk, addr, din[31:24], dout[31:24], we[3], en);

////`ifdef tb_chip
////   initial begin
////     $readmemh("../firmware/firmware_B0.hex", _bram0.mem);
////     $readmemh("../firmware/firmware_B1.hex", _bram1.mem);
////     $readmemh("../firmware/firmware_B2.hex", _bram2.mem);
////     $readmemh("../firmware/firmware_B3.hex", _bram3.mem);
////   end
////`endif

//endmodule

//module bram_2k_8(
//  input clk,
//  input [10:0] addr,
//  input [7:0] din,
//  output [7:0] dout,
//  input we,
//  input en
//);

//  reg [7:0] mem[0:2047];
//  reg [10:0] addr1;

//  always @(posedge clk)
//    if (en) begin
//      addr1 <= addr;
//      if (we)
//        mem[addr] <= din;
//    end      

//  assign dout = mem[addr1];

//endmodule

// module uart_baud_clock_16x(
//   input clk,
//   output baudclk16
// );

//   reg [8:0] c;
//   wire m = (c==9'd325);    // 50000000/(16*9600) ~= 326

//   always @(posedge clk)
//     c <= m ? 0 : c+1;

//   assign baudclk16 = m;

// endmodule

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
  output reg [7:0] dout,
  input we,
  input en
);
  (* ram_style = "block" *)
  reg [7:0] mem[0:4095];
    always @(posedge clk)
    begin
        if (en)
        begin
            if (we)
            begin
                mem[addr] <= din;
                dout <= din;
            end
            else
                dout <= mem[addr];
        end
    end

endmodule
