#include <stdarg.h>
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
// #include <string.h>
// #define size_t u32_t
// #define NULL ((void *)0)

// typedef unsigned   char    uint8_t;
// typedef signed     char    sint8_t;
// typedef unsigned   short   uint16_t;
// typedef signed     short   sint16_t;
// typedef unsigned   int    uint32_t;
// typedef signed     int    sint32_t;
// typedef unsigned   long long    uint64_t;
// typedef signed     long long    sint64_t;

#define heap_size 64*1024

#define heap_base_adr 64*1024

#define UART_DIV   0x80000004
#define UART_DATA  0x80000008

uint32_t *irq(uint32_t *regs, uint32_t irqs);

void uart_tx_data(int x);
int uart_rx_data();
int putchar(int ch);

static void sprintf_putch(int ch, void** data);
static unsigned long long getuint(va_list *ap, int lflag);
static long long getint(va_list *ap, int lflag);
static inline void printnum(void (*putch)(int, void**), void **putdat,
                    unsigned long long num, unsigned base, int width, int padc);
static inline void print_double(void (*putch)(int, void**), void **putdat,
                                double num, int width, int prec);
static void vprintfmt(void (*putch)(int, void**), void **putdat, const char *fmt, va_list ap);
extern int printf(const char* fmt, ...);
extern int sprintf(char* str, const char* fmt, ...);

// extern char *malloc();
// extern void rand();
extern void *memcpy(void *dest, const void *src, long n);
extern void* memset(void* dst,int val, size_t count);
extern int memcmp(const void *buffer1,const void *buffer2,int count);
extern size_t strnlen(const char *str, size_t maxsize);
extern size_t strlen (const char * str);
extern char *strcpy(char *dest, const char *src);
extern int strcmp(const char *s1, const char *s2);