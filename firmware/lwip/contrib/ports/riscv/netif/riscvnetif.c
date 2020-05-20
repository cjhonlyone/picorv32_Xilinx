/**
 * @file
 * Ethernet Interface Skeleton
 *
 */

/*
 * Copyright (c) 2001-2004 Swedish Institute of Computer Science.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 * This file is part of the lwIP TCP/IP stack.
 *
 * Author: Adam Dunkels <adam@sics.se>
 *
 */

/*
 * This file is a skeleton for developing Ethernet network interface
 * drivers for lwIP. Add code to the low_level functions and do a
 * search-and-replace for the word "ethernetif" to replace it with
 * something that better describes your network interface.
 */

// #include "lwip/opt.h"

#if 1 /* don't build, this is only a skeleton, see previous comment */

#include "lwip/opt.h"
#include "lwip/mem.h"
#include "lwip/memp.h"
#include "lwip/netif.h"

// #include "lwip/timeouts.h"

// #include "netif/etharp.h"
// #include "lwip/ethip6.h"
#include "riscvnetif.h"
#include "riscvdma.h"

#include "pqueue.h"
/* Define those to better describe your network interface. */
#define IFNAME0 's'
#define IFNAME1 't'

volatile u32_t *tx_BD_sta_ptr = 0x800000CC;;




// struct ethernetif {
//   struct eth_addr *ethaddr;
//    Add whatever per-interface state that is needed here. 
// };

/**
 * Helper struct to hold private data used to operate your ethernet interface.
 * Keeping the ethernet address of the MAC in this struct is not necessary
 * as it is already kept in the struct netif.
 * But this is only an example, anyway...
 */

/* Forward declarations. */
// static void  ethernetif_input(struct netif *netif);

/**
 * In this function, the hardware should be initialized.
 * Called from ethernetif_init().
 *
 * @param netif the already initialized lwip network interface structure
 *        for this ethernetif
 */
static void
low_level_init(struct netif *netif)
{
  mymac *mymac_s = netif->state;
  /* set MAC hardware address length */
  netif->hwaddr_len = NETIF_MAX_HWADDR_LEN;

  /* set MAC hardware address */
  netif->hwaddr[0] = 0xaa;
  netif->hwaddr[1] = 0xbb;
  netif->hwaddr[2] = 0xcc;
  netif->hwaddr[3] = 0xdd;
  netif->hwaddr[4] = 0xee;
  netif->hwaddr[5] = 0xff;

  /* maximum transfer unit */
  netif->mtu = 1024;

  /* device capabilities */
  /* don't set NETIF_FLAG_ETHARP if this device is not an ethernet one */
  netif->flags = NETIF_FLAG_BROADCAST  | NETIF_FLAG_ETHARP|NETIF_FLAG_LINK_UP;// NETIF_FLAG_ETHARP
  
  mymac_s->send_q = NULL;
  mymac_s->recv_q = pq_create_queue();

  netif->state = (void *)mymac_s;  
  dma_init();

  return ERR_OK;
}

/**
 * This function should do the actual transmission of the packet. The packet is
 * contained in the pbuf that is passed to the function. This pbuf
 * might be chained.
 *
 * @param netif the lwip network interface structure for this ethernetif
 * @param p the MAC packet to send (e.g. IP packet including MAC addresses and type)
 * @return ERR_OK if the packet could be sent
 *         an err_t value if the packet couldn't be sent
 *
 * @note Returning ERR_MEM here if a DMA queue of your MAC is full can lead to
 *       strange results. You might consider waiting for space in the DMA queue
 *       to become available since the stack doesn't retry to send a packet
 *       dropped because of memory failure (except for the TCP timers).
 */

static err_t
low_level_output(struct netif *netif, struct pbuf *p)
{
  struct pbuf *q;

  for (q = p; q != NULL; q = q->next) {
    /* Send the data from the pbuf to the interface, one pbuf at a
       time. The size of the data in each pbuf is kept in the ->len
       variable. */
    tx_BD_adr_0 = (u32_t *)q->payload;
    tx_BD_len_0 = q->len;

    *(u32_t*)tx_BD_sta_ptr = 1;
    asm volatile("nop");
    while(*(u32_t*)tx_BD_sta_ptr == 1);
    }

  return ERR_OK;
}

/**
 * Should allocate a pbuf and transfer the bytes of the incoming
 * packet from the interface into the pbuf.
 *
 * @param netif the lwip network interface structure for this ethernetif
 * @return a pbuf filled with the received packet (including MAC header)
 *         NULL on memory error
 */
static struct pbuf *
low_level_input(struct netif *netif)
{
  mymac *mymac_s = (mymac *)(netif->state);
  struct pbuf *p;

  /* see if there is data to process */
  if (pq_qlength(mymac_s->recv_q) == 0)
    return NULL;

  /* return one packet from receive q */
  p = (struct pbuf *)pq_dequeue(mymac_s->recv_q);
  return p;
}

/**
 * This function should be called when a packet is ready to be read
 * from the interface. It uses the function low_level_input() that
 * should handle the actual reception of bytes from the network
 * interface. Then the type of the received packet is determined and
 * the appropriate input function is called.
 *
 * @param netif the lwip network interface structure for this ethernetif
 */
void
ethernetif_input(struct netif *netif)
{
  mymac *mymac_s = (mymac *)(netif->state);
  struct eth_hdr *ethhdr;
  struct pbuf *p;

  // while (1)
  // {
    /* move received packet into a new pbuf */

    p = low_level_input(netif);

    /* no packet could be read, silently ignore this */
    if (p == NULL) {
      return 0;
    }

    /* points to packet payload, which starts with an Ethernet header */
    // ethhdr = p->payload;

    // LWIP_DEBUGF(NETIF_DEBUG, ("ethernetif_input: IP input error\n"));

    // switch (htons(ethhdr->type)) {
      /* IP or ARP packet? */
      // case ETHTYPE_IP:
      // case ETHTYPE_ARP:
        /* full packet send to tcpip_thread to process */
        if (netif->input(p, netif) != ERR_OK) {
          LWIP_DEBUGF(NETIF_DEBUG, ("ethernetif_input: IP input error\n"));
          pbuf_free(p);
          p = NULL;
        }
        // break;

      // default:
        // pbuf_free(p);
        // p = NULL;
        // break;
    // }

    rx_BD_clr = pq_qindex(mymac_s->recv_q);
  // }

  return 1;
}

/**
 * Should be called at the beginning of the program to set up the
 * network interface. It calls the function low_level_init() to do the
 * actual setup of the hardware.
 *
 * This function should be passed as a parameter to netif_add().
 *
 * @param netif the lwip network interface structure for this ethernetif
 * @return ERR_OK if the loopif is initialized
 *         ERR_MEM if private data couldn't be allocated
 *         any other err_t on error
 */
err_t
ethernetif_init(struct netif *netif)
{
  struct mymac *mymac_s;

  // LWIP_ASSERT("netif != NULL", (netif != NULL));

  mymac_s = mem_malloc(sizeof(mymac));
  if (mymac_s == NULL) {
    LWIP_DEBUGF(NETIF_DEBUG, ("ethernetif_init: out of memory\n"));
    return ERR_MEM;
  }

#if LWIP_NETIF_HOSTNAME
  /* Initialize interface hostname */
  netif->hostname = "lwip";
#endif /* LWIP_NETIF_HOSTNAME */

  /*
   * Initialize the snmp variables and counters inside the struct netif.
   * The last argument should be replaced with your link speed, in units
   * of bits per second.
   */
  // MIB2_INIT_NETIF(netif, snmp_ifType_ethernet_csmacd, 1000000000);

  netif->state = mymac_s;
  netif->name[0] = IFNAME0;
  netif->name[1] = IFNAME1;
  /* We directly use etharp_output() here to save a function call.
   * You can instead declare your own function an call etharp_output()
   * from it if you have to do some checks before sending (e.g. if link
   * is available...) */
#if LWIP_IPV4
  netif->output = etharp_output;
#endif /* LWIP_IPV4 */
  netif->linkoutput = low_level_output;

  // ethernetif->ethaddr = (struct eth_addr *) & (netif->hwaddr[0]);

  /* initialize the hardware */
  low_level_init(netif);

  return ERR_OK;
}

#endif /* 0 */
