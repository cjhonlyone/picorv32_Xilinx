#include "mylib.h"
#include "pqueue.h"
#include "riscvdma.h"
#include "riscvnetif.h"

#include "lwip/tcp.h"

#include "echo.h"
// #include "lwip/udp.h"

// int start_tcp_application();
// void tcp_fasttmr(void);
// void tcp_slowtmr(void);

// void lwip_init();
#if 0
static struct udp_pcb *udpecho_raw_pcb;
void udpecho_raw_init(void);
#endif 

static unsigned int timer_irq_count = 0;

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
	printf("system booting .......................\n");

	for (int j = 0;j < 8000;j++)
	{
		delay(4000);
	}


	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
	/* initliaze IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   1, 10);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);

	lwip_init();

	echo_netif = &server_netif;
	netif_add(echo_netif, &ipaddr, &netmask, &gw,
						(void*)mymac_s,
						ethernetif_init,
						ethernet_input
						);

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



	long time_ = time();
	enable_timer(31200000);
	
	uint32_t kk = 0;

	while (1) {
		if (timer_irq_count == 1)
		{
			timer_irq_count = 0;
			// SendResults ++;
			tcp_tmr();
		}
		ethernetif_input(echo_netif);
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

uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	// static unsigned int ext_irq_4_count = 0;
	// static unsigned int ext_irq_5_count = 0;
	
	// printf("irq\n");

	if ((irqs & (1<<5)) != 0) {
		dma_rx_irq(echo_netif);
		// printf("[EXT-IRQ-5]");
	}

	if ((irqs & 1) != 0) {
		// tcp_tmr();
		enable_timer(31250000);
		timer_irq_count++;
		// printf("[TIMER-IRQ]");
		// *(volatile unsigned int*)0x80000000 = i;
		// i++;
		// enable_timer(125000000);
	}

	// if ((irqs & 6) != 0)
	// {
	// 	uint32_t pc = (regs[0] & 1) ? regs[0] - 3 : regs[0] - 4;
	// 	uint32_t instr = *(uint16_t*)pc;

	// 	if ((instr & 3) == 3)
	// 		instr = instr | (*(uint16_t*)(pc + 2)) << 16;

	// 	printf("\n------------------------------------------------------------\n");

	// 	if ((irqs & 2) != 0) {
	// 		if (instr == 0x00100073 || instr == 0x9002) {
	// 			printf("EBREAK instruction at 0x%0x\n",pc);
	// 		} else {
	// 			printf("Illegal Instruction at 0x%0x: 0x%0x\n",pc, instr);
	// 		}
	// 	}

	// 	if ((irqs & 4) != 0) {
	// 		printf("Bus error in Instruction at 0x%0x: 0x%0x\n",pc, instr);
	// 	}

	// 	for (int i = 0; i < 8; i++)
	// 	for (int k = 0; k < 4; k++)
	// 	{
	// 		int r = i + k*8;

	// 		printf("regs[%02d] = %0x",r, regs[r]);
	// 		if (k == 3)
	// 			printf("\n");
	// 		else
	// 			printf(" ");
	// 	}

	// 	printf("------------------------------------------------------------\n");

	// 	// printf("Number of fast external IRQs counted: ");
	// 	// printf(ext_irq_4_count);
	// 	// printf("\n");

	// 	// printf("Number of slow external IRQs counted: ");
	// 	// printf(ext_irq_5_count);
	// 	// printf("\n");

	// 	// printf("Number of timer IRQs counted: ");
	// 	// printf(timer_irq_count);
	// 	// printf("\n");

	// 	__asm__ volatile ("ebreak");
	// }

	return regs;
}