/*
 * Copyright (c) 2001-2003 Swedish Institute of Computer Science.
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
#ifndef LWIP_LWIPOPTS_H
#define LWIP_LWIPOPTS_H
#if 1

#define NO_SYS 1
#define LWIP_CALLBACK_API 1
#define LWIP_SOCKET 0
#define LWIP_COMPAT_SOCKETS 0
#define LWIP_NETCONN 0

#define NO_SYS_NO_TIMERS 1

#define LWIP_TCP_KEEPALIVE 0

#define MEM_ALIGNMENT 4
#define MEM_SIZE (16*1024)

#define MEMP_NUM_PBUF 64
#define MEMP_NUM_UDP_PCB 4
#define MEMP_NUM_TCP_PCB 5
#define MEMP_NUM_TCP_PCB_LISTEN 2
#define MEMP_NUM_TCP_SEG 64


#define MEMP_NUM_NETBUF 0
#define MEMP_NUM_NETCONN 0
// #define MEMP_NUM_TCPIP_MSG_API 16
// #define MEMP_NUM_TCPIP_MSG_INPKT 64
#define MEMP_NUM_SYS_TIMEOUT 0

#define PBUF_POOL_SIZE 48
#define PBUF_POOL_BUFSIZE 1700

#define ETH_PAD_SIZE 0
#define PBUF_LINK_HLEN 14

#define LWIP_ARP                1
#define ARP_TABLE_SIZE 10
#define ARP_QUEUEING 1

#define ICMP_TTL 255

#define IP_OPTIONS 1
#define IP_FORWARD 0
#define IP_REASSEMBLY 1
#define IP_FRAG 1
#define IP_REASS_MAX_PBUFS 128
#define IP_FRAG_MAX_MTU 1500
#define IP_DEFAULT_TTL 255
#define LWIP_CHKSUM_ALGORITHM 3

#define LWIP_UDP 1
#define UDP_TTL 255

#define LWIP_TCP 1
#define TCP_MSS 536
#define TCP_SND_BUF (8*TCP_MSS)
#define TCP_WND (4*TCP_MSS)
#define TCP_TTL 255
#define TCP_MAXRTX 12
#define TCP_SYNMAXRTX 4
#define TCP_QUEUE_OOSEQ 1
#define TCP_SND_QUEUELEN   (4 * TCP_SND_BUF/TCP_MSS)

#define CHECKSUM_GEN_IP                      1                   //IP校验和生成
#define CHECKSUM_GEN_UDP                     1                   //UDP校验和生成
#define CHECKSUM_GEN_TCP                     1                   //TCP校验和生成
// #define CHECKSUM_CHECK_IP                    1                   //IP校验和校验
// #define CHECKSUM_CHECK_UDP                   1                   //UDP校验和校验
// #define CHECKSUM_CHECK_TCP                   1                   //TCP校验和校验
#define LWIP_FULL_CSUM_OFFLOAD_RX  1
#define LWIP_FULL_CSUM_OFFLOAD_TX  1

#define MEMP_SEPARATE_POOLS 0
#define MEMP_NUM_FRAG_PBUF 8
#define IP_OPTIONS_ALLOWED 1
#define TCP_OVERSIZE TCP_MSS

#define LWIP_DHCP 0
#define DHCP_DOES_ARP_CHECK 0

#define CONFIG_LINKSPEED_AUTODETECT 0

#define LWIP_IPV4                  1


#define LWIP_IGMP                  0
#define LWIP_ICMP                  LWIP_IPV4


// #define LWIP_TCP_TIMESTAMPS  1

#define TCP_LISTEN_BACKLOG         1


#define LWIP_DEBUG 1

#ifdef LWIP_DEBUG

#define ETHARP_DEBUG               LWIP_DBG_OFF//     LWIP_DBG_ON

#define LWIP_DBG_MIN_LEVEL         0
#define PPP_DEBUG                  LWIP_DBG_OFF
#define MEM_DEBUG                  LWIP_DBG_OFF // LWIP_DBG_ON
#define MEMP_DEBUG                 LWIP_DBG_OFF // LWIP_DBG_ON
#define PBUF_DEBUG                 LWIP_DBG_OFF // LWIP_DBG_ON
#define API_LIB_DEBUG              LWIP_DBG_OFF
#define API_MSG_DEBUG              LWIP_DBG_OFF
#define TCPIP_DEBUG                LWIP_DBG_OFF
#define NETIF_DEBUG                LWIP_DBG_OFF // LWIP_DBG_ON
#define SOCKETS_DEBUG              LWIP_DBG_OFF
#define DNS_DEBUG                  LWIP_DBG_OFF
#define AUTOIP_DEBUG               LWIP_DBG_OFF
#define DHCP_DEBUG                 LWIP_DBG_OFF
#define IP_DEBUG                   LWIP_DBG_OFF
#define IP_REASS_DEBUG             LWIP_DBG_OFF
#define ICMP_DEBUG                 LWIP_DBG_OFF
#define IGMP_DEBUG                 LWIP_DBG_OFF
#define UDP_DEBUG                  LWIP_DBG_OFF
#define TCP_DEBUG                  LWIP_DBG_OFF
#define TCP_INPUT_DEBUG            LWIP_DBG_OFF
#define TCP_OUTPUT_DEBUG           LWIP_DBG_OFF
#define TCP_RTO_DEBUG              LWIP_DBG_OFF
#define TCP_CWND_DEBUG             LWIP_DBG_OFF
#define TCP_WND_DEBUG              LWIP_DBG_OFF
#define TCP_FR_DEBUG               LWIP_DBG_OFF
#define TCP_QLEN_DEBUG             LWIP_DBG_OFF
#define TCP_RST_DEBUG              LWIP_DBG_OFF
#endif

#define LWIP_DBG_TYPES_ON         (LWIP_DBG_ON|LWIP_DBG_TRACE|LWIP_DBG_STATE|LWIP_DBG_FRESH)

#define CHECKSUM_GEN_IP                      1                   //IP校验和生成
#define CHECKSUM_GEN_UDP                     1                   //UDP校验和生成
#define CHECKSUM_GEN_TCP                     1                   //TCP校验和生成
// #define CHECKSUM_CHECK_IP                    1                   //IP校验和校验
// #define CHECKSUM_CHECK_UDP                   1                   //UDP校验和校验
// #define CHECKSUM_CHECK_TCP                   1                   //TCP校验和校验

#else

#define NO_SYS 1
#define SYS_LIGHTWEIGHT_PROT 0
// #define LWIP_CALLBACK_API 1
#define LWIP_SOCKET 0
#define LWIP_COMPAT_SOCKETS 0
#define LWIP_NETCONN 0

#define NO_SYS_NO_TIMERS 1

#define LWIP_TCP_KEEPALIVE 0

/* ---------- Memory options ---------- */
/* MEM_ALIGNMENT: should be set to the alignment of the CPU for which
   lwIP is compiled. 4 byte alignment -> define MEM_ALIGNMENT to 4, 2
   byte alignment -> define MEM_ALIGNMENT to 2. */
#define MEM_ALIGNMENT           4

/* MEM_SIZE: the size of the heap memory. If the application will send
a lot of data that needs to be copied, this should be set high. */
#define MEM_SIZE                16 * 1024

/* MEMP_NUM_PBUF: the number of memp struct pbufs. If the application
   sends a lot of data out of ROM (or other static memory), this
   should be set high. */
#define MEMP_NUM_PBUF           32
/* MEMP_NUM_UDP_PCB: the number of UDP protocol control blocks. One
   per active UDP "connection". */
#define MEMP_NUM_UDP_PCB        4
/* MEMP_NUM_TCP_PCB: the number of simulatenously active TCP
   connections. */
#define MEMP_NUM_TCP_PCB        4
/* MEMP_NUM_TCP_PCB_LISTEN: the number of listening TCP
   connections. */
#define MEMP_NUM_TCP_PCB_LISTEN 8
/* MEMP_NUM_TCP_SEG: the number of simultaneously queued TCP
   segments. */
#define MEMP_NUM_TCP_SEG        63 //#

/* The following four are used only with the sequential API and can be
   set to 0 if the application only will use the raw API. */
/* MEMP_NUM_NETBUF: the number of struct netbufs. */
#define MEMP_NUM_NETBUF         0
/* MEMP_NUM_NETCONN: the number of struct netconns. */
#define MEMP_NUM_NETCONN        0
/* MEMP_NUM_APIMSG: the number of struct api_msg, used for
   communication between the TCP/IP stack and the sequential
   programs. */
// #define MEMP_NUM_API_MSG        0
/* MEMP_NUM_TCPIPMSG: the number of struct tcpip_msg, which is used
   for sequential API communication and incoming packets. Used in
   src/api/tcpip.c. */
// #define MEMP_NUM_TCPIP_MSG      0
/* MEMP_NUM_SYS_TIMEOUT: the number of simulateously active
   timeouts. */
// #define MEMP_NUM_SYS_TIMEOUT    0

/* ---------- Pbuf options ---------- */
/* PBUF_POOL_SIZE: the number of buffers in the pbuf pool. */
#define PBUF_POOL_SIZE          48

/* PBUF_POOL_BUFSIZE: the size of each pbuf in the pbuf pool. */
#define PBUF_POOL_BUFSIZE       1600

/* PBUF_LINK_HLEN: the number of bytes that should be allocated for a
   link level header. */
#define PBUF_LINK_HLEN          14

/* ---------- TCP options ---------- */
#define LWIP_TCP                1
#define TCP_TTL                 255

/* Controls if TCP should queue segments that arrive out of
   order. Define to 0 if your device is low on memory. */
#define TCP_QUEUE_OOSEQ         1

/* TCP Maximum segment size. */
#define TCP_MSS                 1460

/* TCP sender buffer space (bytes). */
#define TCP_SND_BUF             (8 * TCP_MSS)

/* TCP sender buffer space (pbufs). This must be at least = 2 *
   TCP_SND_BUF/TCP_MSS for things to work. */
#define TCP_SND_QUEUELEN        (2 * TCP_SND_BUF / TCP_MSS)

/* TCP receive window. */
#define TCP_WND                 (4 * TCP_MSS)

/* Maximum number of retransmissions of data segments. */
#define TCP_MAXRTX              12

/* Maximum number of retransmissions of SYN segments. */
#define TCP_SYNMAXRTX           4

/* ---------- ARP options ---------- */
#define ARP_TABLE_SIZE 10
#define ARP_QUEUEING 1

/* ---------- IP options ---------- */
/* Define IP_FORWARD to 1 if you wish to have the ability to forward
   IP packets across network interfaces. If you are going to run lwIP
   on a device with only one network interface, define this to 0. */
#define IP_FORWARD              0

/* If defined to 1, IP options are allowed (but not parsed). If
   defined to 0, all packets with IP options are dropped. */
#define IP_OPTIONS              1

/* ---------- ICMP options ---------- */
#define ICMP_TTL                255


/* ---------- DHCP options ---------- */
/* Define LWIP_DHCP to 1 if you want DHCP configuration of
   interfaces. DHCP is not implemented in lwIP 0.5.1, however, so
   turning this on does currently not work. */
#define LWIP_DHCP               0

/* 1 if you want to do an ARP check on the offered address
   (recommended). */
#define DHCP_DOES_ARP_CHECK     0

/* ---------- UDP options ---------- */
#define LWIP_UDP                1
#define UDP_TTL                 255

/* ---------- Statistics options ---------- */
//#define STATS

#ifdef STATS
#define LINK_STATS 	1
#define IP_STATS	1
#define ICMP_STATS	1
#define UDP_STATS	1
#define TCP_STATS	1
#define MEM_STATS	1
#define MEMP_STATS	1
#define PBUF_STATS	1
#define SYS_STATS	1
#define LWIP_STATS_DISPLAY 1
#endif /* STATS */

//#define IP_DEBUG (DBG_LEVEL_WARNING | DBG_ON)
//#define TCP_DEBUG (DBG_LEVEL_WARNING | DBG_ON)
//#define TCP_INPUT_DEBUG  (DBG_LEVEL_WARNING | DBG_ON)
//#define TCP_OUTPUT_DEBUG  (DBG_LEVEL_WARNING | DBG_ON)
//#define TCP_WND_DEBUG (DBG_LEVEL_WARNING | DBG_ON)
//#define TCP_CWND_DEBUG (DBG_LEVEL_WARNING | DBG_ON)
//#define MEM_DEBUG (DBG_LEVEL_SEVERE | DBG_ON)
//#define MEMP_DEBUG (DBG_LEVEL_SEVERE | DBG_ON)
//#define PBUF_DEBUG (DBG_LEVEL_SEVERE | DBG_ON)
//#define LWIP_DEBUG 1
#define DBG_TYPES_ON DBG_LEVEL_WARNING

#define CHECKSUM_GEN_IP                 1
#define CHECKSUM_GEN_TCP                1
#define CHECKSUM_CHECK_IP               1
#define CHECKSUM_CHECK_TCP              1



#endif

#endif /* LWIP_LWIPOPTS_H */
