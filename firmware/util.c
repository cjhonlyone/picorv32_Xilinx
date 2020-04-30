#include "util.h"

#define LED            0x80000000
#define UART_TX_DATA   0x80000004
#define UART_TX_READY  0x80000008
#define UART_RX_DATA   0x8000000c
#define UART_RX_READY  0x80000010

void led(int x)
{ *(volatile unsigned int*)LED = x; }

void uart_tx_data(int x)
{ *(volatile unsigned int*)UART_TX_DATA = x; }

int uart_tx_ready()
{ return *(volatile unsigned int*)UART_TX_READY; }

int uart_rx_data()
{ return *(volatile unsigned int*)UART_RX_DATA; }

int uart_rx_ready()
{ return *(volatile unsigned int*)UART_RX_READY; }

void delay(int m)
{ int i;
  for (i=0; i<m; i++) {
    asm volatile("nop"); } }

void putc(char c)
{ while (!uart_tx_ready()) ;
  uart_tx_data(c); }

void puts(char* s)
{ char c;
  while (c=*s++)
    putc(c); }

char getc()
{ while (!uart_rx_ready()) ;
  return uart_rx_data(); }

void put_nib(unsigned int x)
{ putc(x<10 ? '0'+x : 'a'+(x-10)); }

void put_hex(unsigned int x)
{ int i;
  for (i=0; i<8; i++)
    put_nib((x>>(32-4*(i+1)))&0xf); }

void put_dec(unsigned int x)
{ int i;
  int n;
  int leading = 0;
  if (x==0)
    put_nib(0);
  else
  for (i=1000000000; i>=1; i=i/10) {
    n = x/i;
    if (leading || (n!=0))
      put_nib(n);
    leading = leading || (n!=0);
    x -= i*n; } }

void print_chr(char ch){putc(ch);}
void print_str(const char *p){puts(p);}
void print_dec(unsigned int val){put_dec(val);}
void print_hex(unsigned int val, int digits)
{
    for (int i = (4*digits)-4; i >= 0; i -= 4)
        putc("0123456789ABCDEF"[(val >> i) % 16]);
}