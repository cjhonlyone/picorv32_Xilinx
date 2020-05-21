#include "mylib.h"
#include "pqueue.h"
#include "riscvdma.h"
#include "riscvnetif.h"

#include "lwip/tcp.h"


int start_application();
// void tcp_fasttmr(void);
// void tcp_slowtmr(void);

// void lwip_init();

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

volatile u32_t *tx_BD_sta_ptr_t = 0x800000CC;;
int main()
{ 

	// for (int j = 0;j < 8000;j++)
	// {
	// 	delay(1000);
	// }
	// printf("\n\n\nsystem boot.......................\n\n\n");
	// ENABLE_DMA = 1;

	// *(uint32_t*)(0x20220) =    0xffffffff;
	// *(uint32_t*)(0x20220+4) =  0x0a00ffff;
	// *(uint32_t*)(0x20220+8) =  0x02010035;
	// *(uint32_t*)(0x20220+12) = 0x01000608;
	// *(uint32_t*)(0x20220+16) = 0x04060008;
	// *(uint32_t*)(0x20220+20) = 0x0a000100;
	// *(uint32_t*)(0x20220+24) = 0x02010035;
	// *(uint32_t*)(0x20220+28) = 0x0a01a8c0;
	// *(uint32_t*)(0x20220+32) = 0x00000000;
	// *(uint32_t*)(0x20220+36) = 0xa8c00000;
	// *(uint32_t*)(0x20220+40) = 0x00000a01;

	// *(uint32_t*)(0x20220+44) = 0xbda16844;
	// *(uint32_t*)(0x20220+48) = 0xbda16848;
	// *(uint32_t*)(0x20220+52) = 0xbda16852;
	// *(uint32_t*)(0x20220+56) = 0xbda16856;

 //    tx_BD_adr_0 = 0x20220;
 //    tx_BD_len_0 = 96;

	for (int j = 0;j < 8000;j++)
	{
		delay(4000);
	}

//     *((u32_t volatile *)0x800000CC) = 1;
//     asm volatile("nop");
//     while(*((u32_t volatile *)0x800000CC) == 1);
//     asm volatile("nop");
//     printf("first send %d\n", *((u32_t*)0x800000CC));


//     *((u32_t volatile *)0x800000CC) = 1;
//     asm volatile("nop");
//     while(*((u32_t volatile *)0x800000CC) == 1);
// printf("s send %d\n", *((u32_t volatile *)0x800000CC));

//     while(1);

 //    tx_BD_adr_0 = 0x20221;
 //    tx_BD_len_0 = 58;

 //    *(u32_t*)tx_BD_sta_ptr_t = 1;
 //    asm volatile("nop");
 //    while(*(u32_t*)tx_BD_sta_ptr_t == 1);

 //    tx_BD_adr_0 = 0x20222;
 //    tx_BD_len_0 = 58;

 //    *(u32_t*)tx_BD_sta_ptr_t = 1;
 //    asm volatile("nop");
 //    while(*(u32_t*)tx_BD_sta_ptr_t == 1);

 //    tx_BD_adr_0 = 0x20223;
 //    tx_BD_len_0 = 58;

 //    *(u32_t*)tx_BD_sta_ptr_t = 1;
 //    asm volatile("nop");
 //    while(*(u32_t*)tx_BD_sta_ptr_t == 1);




	struct ip_addr ipaddr, netmask, gw;

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
	start_application();

	
	/* receive and process packets */

	long time_ = time();
	enable_timer(31200000);
	
	uint32_t kk = 0;

	while (1) {
		if (timer_irq_count == 1)
		{
			timer_irq_count = 0;
			tcp_tmr();
		}
		// for (int j = 0;j < 1000;j++)
		// {
		// 	delay(1000);
		// }
		ethernetif_input(echo_netif);
		// printf("time_ %d\n\n",time());
	}
  
}

err_t recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{
	/* do not read the packet if we are not in ESTABLISHED state */
	if (!p) {
		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
		return ERR_OK;
	}

	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);

	/* echo back the payload */
	/* in this case, we assume that the payload is < TCP_SND_BUF */
	if (tcp_sndbuf(tpcb) > p->len) {
		err = tcp_write(tpcb, p->payload, p->len, 1);
	} else
		printf("no space in tcp_sndbuf\n\r");

	/* free the received pbuf */
	pbuf_free(p);

	return ERR_OK;
}

err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
	static int connection = 1;

	/* set the receive callback for this connection */
	tcp_recv(newpcb, recv_callback);

	/* just use an integer number indicating the connection id as the
	   callback argument */
	tcp_arg(newpcb, (void*)connection);

	/* increment for subsequent accepted connections */
	connection++;

	return ERR_OK;
}


int start_application()
{
	struct tcp_pcb *pcb;
	err_t err;
	unsigned port = 7;

	/* create new TCP PCB structure */
	pcb = tcp_new();
	if (!pcb) {
		printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}

	/* bind to specified @port */
	err = tcp_bind(pcb, IP_ADDR_ANY, port);
	if (err != ERR_OK) {
		printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}

	/* we do not need any arguments to callback functions */
	tcp_arg(pcb, NULL);

	/* listen for connections */
	pcb = tcp_listen(pcb);
	if (!pcb) {
		printf("Out of memory while tcp_listen\n\r");
		return -3;
	}

	/* specify callback to use for incoming connections */
	tcp_accept(pcb, accept_callback);

	printf("TCP echo server started @ port %d\n\r", port);

	return 0;
}




// #include "mylib.h"
// // #include "dma.h"

// void delay(int m)
// { int i;
//   for (i=0; i<m; i++) {
//     asm volatile("nop"); } }

// int main()
// {
// 	// int i = 10000;
// 	// printf("10000, %d",i);
// 	// dma_init();
// 	while(1)
// 	{
// 		for (int j = 0;j < 8000;j++)
// 			delay(1000);
// 		// printf("while\n");
// 	}
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