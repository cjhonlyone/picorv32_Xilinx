#include "mylib.h"
#include "pqueue.h"
#include "riscvdma.h"
#include "riscvnetif.h"

// #include "lwip/tcp.h"
#include "lwip/udp.h"

// int start_tcp_application();
// int start_udp_application();
// void tcp_fasttmr(void);
// void tcp_slowtmr(void);

// void lwip_init();
// Define port to listen on
#define FF_UDP_PORT 7

// TIMEOUT FOR DMA AND GMM WAIT
#define RESET_TIMEOUT_COUNTER	10000

// DEFINES
#define WAVE_SIZE_BYTES    512  // Number of samples in waveform
#define INDARR_SIZE_BYTES  1024 // Number of bytes required to hold 512 fixed point floats

//HARDWARE DEFINES
#define NUMCHANNELS 		2	// Number of parallel operations done on input stream (1 OR 2)
#define BW   				32	// Total number of bits in fixed point data type
#define IW    				24	// Number of bits left of decimal point in fixed point data type
#define BITDIV			 256.0 	// Divisor to shift fixed point to int and back to float

int			Centroid;

// Global variables for data flow
volatile u8_t      IndArrDone;
volatile u32_t	EthBytesReceived;
int*			IndArrPtr;
volatile u8_t	SendResults;
volatile u8_t   	DMA_TX_Busy;
volatile u8_t	Error;

// Global Variables for Ethernet handling
u16_t    	RemotePort;
struct ip_addr  	RemoteAddr;
struct udp_pcb 	send_pcb;

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

volatile u32_t *tx_BD_sta_ptr_t = 0x800000CC;
	struct pbuf * psnd;
		struct ip_addr ipaddr, netmask, gw;
		static struct udp_pcb *udpecho_raw_pcb;
		void udpecho_raw_init(void);
int main()
{ 

	err_t udpsenderr;
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
	udpecho_raw_init();
	
	/* receive and process packets */

	long time_ = time();
	enable_timer(31200000);
	
	uint32_t kk = 0;

	while (1) {
		if (timer_irq_count == 1)
		{
			timer_irq_count = 0;
			// SendResults ++;
			// tcp_tmr();
		}
		// for (int j = 0;j < 1000;j++)
		// {
		// 	delay(1000);
		// }
		ethernetif_input(echo_netif);

		// if (SendResults == 1){

		// 	SendResults = 0;
		// 	// Read the results from the FPGA
		// 	Centroid = 0xA5;

		// 	// Send out the centroid result over UDP
		// 	psnd = pbuf_alloc(PBUF_TRANSPORT, sizeof(int), PBUF_REF);
		// 	psnd->payload = &Centroid;
		// 	udpsenderr = udp_sendto(&send_pcb, psnd, &RemoteAddr, RemotePort);
		// 	// printf(".");
		// 	if (udpsenderr != ERR_OK){
		// 		printf("UDP Send failed with Error %d\n\r", udpsenderr);
		// 		// goto ErrorOrDone;
		// 	}
		// 	pbuf_free(psnd);
		// }
	}
  
}

// err_t tcp_recv_callback(void *arg, struct tcp_pcb *tpcb,
//                                struct pbuf *p, err_t err)
// {
// 	/* do not read the packet if we are not in ESTABLISHED state */
// 	if (!p) {
// 		tcp_close(tpcb);
// 		tcp_recv(tpcb, NULL);
// 		return ERR_OK;
// 	}

// 	/* indicate that the packet has been received */
// 	tcp_recved(tpcb, p->len);

// 	/* echo back the payload */
// 	/* in this case, we assume that the payload is < TCP_SND_BUF */
// 	if (tcp_sndbuf(tpcb) > p->len) {
// 		err = tcp_write(tpcb, p->payload, p->len, 1);
// 	} else
// 		printf("no space in tcp_sndbuf\n\r");

// 	/* free the received pbuf */
// 	pbuf_free(p);

// 	return ERR_OK;
// }

// err_t tcp_accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
// {
// 	static int connection = 1;

// 	/* set the receive callback for this connection */
// 	tcp_recv(newpcb, tcp_recv_callback);
// 	printf("accept_callback tcp_recv");

// 	 // just use an integer number indicating the connection id as the
// 	 //   callback argument 
// 	tcp_arg(newpcb, (void*)connection);

// 	printf("accept_callback tcp_arg");

// 	/* increment for subsequent accepted connections */
// 	connection++;

// 	return ERR_OK;
// }


// int start_tcp_application()
// {
// 	struct tcp_pcb *pcb;
// 	err_t err;
// 	unsigned port = 7;

// 	/* create new TCP PCB structure */
// 	pcb = tcp_new();
// 	if (!pcb) {
// 		printf("Error creating PCB. Out of Memory\n\r");
// 		return -1;
// 	}

// 	/* bind to specified @port */
// 	err = tcp_bind(pcb, IP_ADDR_ANY, port);
// 	if (err != ERR_OK) {
// 		printf("Unable to bind to port %d: err = %d\n\r", port, err);
// 		return -2;
// 	}

// 	/* we do not need any arguments to callback functions */
// 	tcp_arg(pcb, NULL);

// 	/* listen for connections */
// 	pcb = tcp_listen(pcb);
// 	if (!pcb) {
// 		printf("Out of memory while tcp_listen\n\r");
// 		return -3;
// 	}

// 	/* specify callback to use for incoming connections */
// 	tcp_accept(pcb, tcp_accept_callback);

// 	printf("TCP echo server started @ port %d\n\r", port);

// 	return 0;
// }



// void udp_recv_callback(void *arg, struct udp_pcb *upcb,
//                               struct pbuf *p, struct ip_addr *addr, u16_t port)
// {

// 	// Set up a timeout counter and a status variable
// 	//int TimeOutCntr = 0;
// 	//int status = 0;

// 	/* Do not read the packet if we are not in ESTABLISHED state */
// 	if (!p) {
// 		udp_disconnect(upcb);
// 		return;
// 	}

// 	/* Assign the Remote IP:port from the callback on each first pulse */
// 	RemotePort = port;
// 	RemoteAddr = *addr;

// 	/* Keep track of the control block so we can send data back in the main while loop */
// 	send_pcb = *upcb;

// 	/********************** WAVE ARRAY ********************************/
// 	// Determine the number of bytes received and copy this segment to the temp array
// 	EthBytesReceived = p->len;
// 	printf("port %d Data len = %d 0x%0x\n",port,  p->len , *(u32_t *)p->payload);
// 	//memcpy(&WaveformArr[0], (u32*)p->payload, EthBytesReceived);

// 	psnd = pbuf_alloc(PBUF_TRANSPORT, p->len, PBUF_REF);
// 	psnd->payload = p->payload;
// 	psnd->len = p->len;
// 	udp_sendto(upcb, psnd, addr, port);
// 	pbuf_free(psnd);
// 	// SendResults = 1;
// 	/* free the received pbuf */
// 	pbuf_free(p);
// 	return;

// }

// int start_udp_application()
// {
// 	struct udp_pcb *pcb;
// 	err_t err;
// 	unsigned port = FF_UDP_PORT;

// 	/* create new UDP PCB structure */
// 	pcb = udp_new();
// 	if (!pcb) {
// 		printf("Error creating PCB. Out of Memory\n\r");
// 		return -1;
// 	}

// 	/* bind to specified @port */
// 	err = udp_bind(pcb, &ipaddr, port);
// 	if (err != ERR_OK) {
// 		printf("Unable to bind to port %d: err = %d\n\r", port, err);
// 		return -2;
// 	}

// 	/* specify callback to use for incoming connections */
// 	udp_recv(pcb, udp_recv_callback, NULL);

// 	printf("UDP echo server started @ port %d\n\r", port);

// 	return 0;
// }


static void
udpecho_raw_recv(void *arg, struct udp_pcb *upcb, struct pbuf *p,
                 const ip_addr_t *addr, u16_t port)
{
  LWIP_UNUSED_ARG(arg);
  if (p != NULL) {
    /* send received packet back to sender */
    udp_sendto(upcb, p, addr, port);
    /* free the pbuf */
    pbuf_free(p);
  }
}

void
udpecho_raw_init(void)
{
  // udpecho_raw_pcb = udp_new_ip_type(IPADDR_ANY);
  udpecho_raw_pcb = udp_new();
  if (udpecho_raw_pcb != NULL) {
    err_t err;

    err = udp_bind(udpecho_raw_pcb, IP_ADDR_ANY, 7);
    if (err == ERR_OK) {
      udp_recv(udpecho_raw_pcb, udpecho_raw_recv, NULL);
    } else {
      /* abort? output diagnostic? */
    }
  } else {
    /* abort? output diagnostic? */
  }
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