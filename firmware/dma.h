#define rx_BD_adr_0 0x80000040
#define rx_BD_adr_1 0x80000044
#define rx_BD_adr_2 0x80000048
#define rx_BD_adr_3 0x8000004C
#define rx_BD_adr_4 0x80000050
#define rx_BD_adr_5 0x80000054
#define rx_BD_adr_6 0x80000058
#define rx_BD_adr_7 0x8000005C

#define rx_BD_len_0 0x80000060
#define rx_BD_len_1 0x80000064
#define rx_BD_len_2 0x80000068
#define rx_BD_len_3 0x8000006C
#define rx_BD_len_4 0x80000070
#define rx_BD_len_5 0x80000074
#define rx_BD_len_6 0x80000078
#define rx_BD_len_7 0x8000007C

#define tx_BD_len_0 0x80000080
#define tx_BD_len_1 0x80000084
#define tx_BD_len_2 0x80000088
#define tx_BD_len_3 0x8000008C
#define tx_BD_len_4 0x80000090
#define tx_BD_len_5 0x80000094
#define tx_BD_len_6 0x80000098
#define tx_BD_len_7 0x8000009C

#define tx_BD_len_0 0x800000A0
#define tx_BD_len_1 0x800000A4
#define tx_BD_len_2 0x800000A8
#define tx_BD_len_3 0x800000AC
#define tx_BD_len_4 0x800000B0
#define tx_BD_len_5 0x800000B4
#define tx_BD_len_6 0x800000B8
#define tx_BD_len_7 0x800000BC

#define ENABLE_DMA  0x800000C0
#define rx_BD_sta   0x800000C4
#define rx_BD_clr   0x800000C8
#define tx_BD_sta   0x800000CC


int dma_init();
int dma_