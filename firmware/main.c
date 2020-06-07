#include "mylib.h"
#include "pqueue.h"
#include "riscvdma.h"
#include "riscvnetif.h"

#include "lwip/tcp.h"

// #include "ping.h"
// #include "lwip/udp.h"

// int start_tcp_application();
// void tcp_fasttmr(void);
// void tcp_slowtmr(void);

// void lwip_init();
#if 0
static struct udp_pcb *udpecho_raw_pcb;
void udpecho_raw_init(void);
#endif 

static volatile unsigned int timer_irq_count = 0;

// struct netif echo_netif_t;
// struct mymac mymac_s_t;
static struct netif server_netif;
struct netif *echo_netif;
struct mymac *mymac_s;

void delay(int m)
{ int i;
  for (i=0; i<m; i++) {
    asm volatile("nop"); } }
	
struct ip_addr ipaddr, netmask, gw;

int main()
{ 

	// err_t udpsenderr;
	// ENABLE_DMA = 1; 
	// rx_BD_adr_0 = 0x00018368; 

	// *((u32_t *)(0x00015368))=0xe000ffff; //2
	// *((u32_t *)(0x0001536C))=0xbda1684c; 
	// *((u32_t *)(0x00015370))=0x00350a00; 
	// *((u32_t *)(0x00015374))=0x00080201; 
	// *((u32_t *)(0x00015378))=0x2c000045; 
	// *((u32_t *)(0x0001537C))=0x00000000; 
	// *((u32_t *)(0x00015380))=0xf03706ff; 
	// *((u32_t *)(0x00015384))=0x0a01a8c0; 
	// *((u32_t *)(0x00015388))=0x8101a8c0; 
	// *((u32_t *)(0x0001538C))=0xb0630700; 
	// *((u32_t *)(0x00015390))=0x7c190000; 
	// *((u32_t *)(0x00015394))=0xfd5b86c6; 
	// *((u32_t *)(0x00015398))=0x60081260; 
	// *((u32_t *)(0x0001539C))=0x0000e76f; 
	// *((u32_t *)(0x000153a0))=0xf0010402; 
 	
 // 	*((u32_t *)(0x000153a4))=0xf03706ff; 

 //    tx_BD_adr_0 = 0x00015368; 
 //    tx_BD_len_0 = 58; 
 
 //    tx_BD_sta = 1; 
 //    while(tx_BD_sta ==  1); 

 //    tx_BD_adr_0 = 0x00015369; 
 //    tx_BD_len_0 = 58; 
 
 //    tx_BD_sta = 1; 
 //    while(tx_BD_sta ==  1); 

 //    tx_BD_adr_0 = 0x0001536a; 
 //    tx_BD_len_0 = 58; 
 
 //    tx_BD_sta = 1; 
 //    while(tx_BD_sta ==  1); 

 //    tx_BD_adr_0 = 0x0001536b; 
 //    tx_BD_len_0 = 58; 
 
 //    tx_BD_sta = 1; 
 //    while(tx_BD_sta ==  1); 
 //    while(1);

	printf("system booting .......................\n");

	// for (int j = 0;j < 8000;j++)
	// {
	// 	delay(4000);
	// }


	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
	/* initliaze IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   1, 10);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);

	lwip_init();

	echo_netif = &server_netif;
	if (netif_add(echo_netif, &ipaddr, &netmask, &gw,
						(void*)mymac_s,
						ethernetif_init,
						ethernet_input
						) == NULL)
	{
		printf("init error\n");
		return 0;
	}

	netif_set_default(echo_netif);
	/* specify that the network if is up */
	netif_set_up(echo_netif);



	/* start the application (web server, rxtest, txtest, etc..) */
	// start_tcp_application();
	// start_udp_application();
	// udpecho_raw_init();

	printf("system boot finished\n");
	
	/* receive and process packets */
	echo_init();
	printf("tcp bind port 7\n");
	// ping_init();



	long time_ = time();
	enable_timer(50000000);
	
	uint32_t kk = 0;

	while (1) {
		if (timer_irq_count >= 1)
		{
			timer_irq_count = 0;
			// SendResults ++;
			tcp_tmr();
			// printf("tcp_tmr\n");

		}
		ethernetif_input(echo_netif);
		// kk++;
	}
  
}


// // udp
// static void
// udpecho_raw_recv(void *arg, struct udp_pcb *upcb, struct pbuf *p,
//                  const ip_addr_t *addr, u16_t port)
// {
//   LWIP_UNUSED_ARG(arg);
//   if (p != NULL) {
//     /* send received packet back to sender */
//     udp_sendto(upcb, p, addr, port);
//     /* free the pbuf */
//     pbuf_free(p);
//   }
// }

// void
// udpecho_raw_init(void)
// {
//   // udpecho_raw_pcb = udp_new_ip_type(IPADDR_ANY);
//   udpecho_raw_pcb = udp_new();
//   if (udpecho_raw_pcb != NULL) {
//     err_t err;

//     err = udp_bind(udpecho_raw_pcb, IP_ADDR_ANY, 7);
//     if (err == ERR_OK) {
//       udp_recv(udpecho_raw_pcb, udpecho_raw_recv, NULL);
//     } else {
//       /* abort? output diagnostic? */
//     }
//   } else {
//     /* abort? output diagnostic? */
//   }
// }
extern void
ping_timeout(void *arg);

uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	// static unsigned int ext_irq_4_count = 0;
	// static unsigned int ext_irq_5_count = 0;

	// uint32_t pc = (regs[0] & 1) ? regs[0] - 3 : regs[0] - 4;
	// printf("irqs 0x%08x pc 0x%08x\n",irqs, pc);
	if ((irqs & (1<<5)) != 0) {
		dma_rx_irq(echo_netif);
		// printf("dma_rx_irq\n");
		// printf("[EXT-IRQ-5]");
	}

	if ((irqs & 1) != 0) {
		// tcp_tmr();
		enable_timer(50000000);
		// printf("timer %d\n",timer_/irq_count);
		timer_irq_count++;
	}
	return regs;
}