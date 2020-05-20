
#include "riscvdma.h"
// #include "mylib.h"
#include "riscvnetif.h"
#include "pqueue.h"

#include "lwip/mem.h"
#include "lwip/memp.h"
#include "lwip/debug.h"

// #include "lwipopts.h"
// #include "lwip/stats.h"
// #include "lwip/sys.h"
// #include "lwip/inet_chksum.h"

void* dma_bd_pbuf[8];

// uint8_t heap_mem[8*1024];
// uint8_t char_mem[64];
// uint8_t *char_mem_ptr;

// volatile uint32_t *tx_BD_sta_ptr = 0x800000CC;

int dma_init()
{
	struct pbuf *p;
	int i;
	for (i = 0; i < 8; i++) {
		p = pbuf_alloc(PBUF_RAW, 1500, PBUF_POOL);
		if (p == NULL)
		{
			break;
		}
		dma_bd_pbuf[i] = (void *)p;
		*((u32_t *)rx_BD_adr + i) = (u32_t *)(p->payload);
	}
	ENABLE_DMA = 1;

	return 1;
}

int dma_rx_irq(struct netif *netif)
{
	u32_t bd_state = 0;
	mymac *mymac_s = (mymac *)(netif->state);

	struct pbuf *p;
	int i,j;
	bd_state = rx_BD_sta;
	j = pq_qlength(mymac_s->recv_q);

	for (i = 0; i < (8- j); i++) {
		if ((bd_state & 0x00000001) == 0x00000001)
		{
			// printf("realloc\n");
			p = (struct pbuf *)dma_bd_pbuf[i];
			pbuf_realloc(p, ((u16_t *)(rx_BD_len+(i << 2))));
			pq_enqueue(mymac_s->recv_q, (void*)p, 0x00000001 << i);

		}
		bd_state = bd_state >> 1;
	}
	
	return 1;
}