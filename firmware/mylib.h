#include <stdarg.h>
#include <stdint.h>
#include <stdbool.h>

#define size_t uint32_t
#define NULL ((void *)0)

#define uint32_t unsigned int
#define uint16_t unsigned short
#define uint8_t unsigned char

#define sint32_t signed int
#define sint16_t signed short
#define sint8_t signed char

#define heap_size 1024

#define UART_DIV   0x80000004
#define UART_DATA  0x80000008

uint32_t *irq(uint32_t *regs, uint32_t irqs);

void uart_tx_data(int x);
int uart_rx_data();
int putchar(int ch);
size_t strnlen(const char *str, size_t maxsize);
static void sprintf_putch(int ch, void** data);
static unsigned long getuint(va_list *ap, int lflag);
static long getint(va_list *ap, int lflag);
static inline void printnum(void (*putch)(int, void**), void **putdat,
                    unsigned long long num, unsigned base, int width, int padc);
static inline void print_double(void (*putch)(int, void**), void **putdat,
                                double num, int width, int prec);
static void vprintfmt(void (*putch)(int, void**), void **putdat, const char *fmt, va_list ap);
extern int printf(const char* fmt, ...);
extern int sprintf(char* str, const char* fmt, ...);

extern char *malloc();

extern void *memcpy(void *dest, const void *src, long n);
extern char *strcpy(char *dest, const char *src);
extern int strcmp(const char *s1, const char *s2);