#include "mylib.h"

char heap_memory[heap_size];
int heap_memory_used = 0;

void uart_tx_data(int x)
{ *(volatile unsigned int*)UART_DATA = x; }


int uart_rx_data()
{ return *(volatile unsigned int*)UART_DATA; }

int putchar(int ch)
{
  *(volatile unsigned int*)UART_DATA = ch;
  return 1;
}

size_t strnlen(const char *str, size_t maxsize)
{
    size_t n;
    for (n = 0; n < maxsize && *str; n++, str++)
        ;
    return n;
}

static void sprintf_putch(int ch, void** data)
{
  char** pstr = (char**)data;
  **pstr = ch;
  (*pstr)++;
}

static unsigned long getuint(va_list *ap, int lflag)
{
  if (lflag)
    return va_arg(*ap, unsigned long);
  else
    return va_arg(*ap, unsigned int);
}

static long getint(va_list *ap, int lflag)
{
  if (lflag)
    return va_arg(*ap, long);
  else
    return va_arg(*ap, int);
}

static inline void printnum(void (*putch)(int, void**), void **putdat,
                    unsigned long num, unsigned base, int width, int padc)
{
  unsigned digs[sizeof(num)*8];
  int pos = 0;

  while (1)
  {
    digs[pos++] = num % base;
    if (num < base)
      break;
    num /= base;
  }

  while (width-- > pos)
    putch(padc, putdat);

  while (pos-- > 0)
    putch(digs[pos] + (digs[pos] >= 10 ? 'a' - 10 : '0'), putdat);
}

static inline void print_double(void (*putch)(int, void**), void **putdat,
                                double num, int width, int prec)
{
  union {
    double d;
    uint64_t u;
  } u;
  u.d = num;

  if (u.u & (1ULL << 63)) {
    putch('-', putdat);
    u.u &= ~(1ULL << 63);
  }

  for (int i = 0; i < prec; i++)
    u.d *= 10;

  char buf[32], *pbuf = buf;
  printnum(sprintf_putch, (void**)&pbuf, (unsigned long)u.d, 10, 0, 0);
  if (prec > 0) {
    for (int i = 0; i < prec; i++) {
      pbuf[-i] = pbuf[-i-1];
    }
    pbuf[-prec] = '.';
    pbuf++;
  }

  for (char* p = buf; p < pbuf; p++)
    putch(*p, putdat);
}

static void vprintfmt(void (*putch)(int, void**), void **putdat, const char *fmt, va_list ap)
{
  register const char* p;
  const char* last_fmt;
  register int ch, err;
  unsigned long num;
  int base, lflag, width, precision, altflag;
  char padc;

  while (1) {
    while ((ch = *(unsigned char *) fmt) != '%') {
      if (ch == '\0')
        return;
      fmt++;
      putch(ch, putdat);
    }
    fmt++;

    // Process a %-escape sequence
    last_fmt = fmt;
    padc = ' ';
    width = -1;
    precision = -1;
    lflag = 0;
    altflag = 0;
  reswitch:
    switch (ch = *(unsigned char *) fmt++) {

    // flag to pad on the right
    case '-':
      padc = '-';
      goto reswitch;
      
    // flag to pad with 0's instead of spaces
    case '0':
      padc = '0';
      goto reswitch;

    // width field
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
      for (precision = 0; ; ++fmt) {
        precision = precision * 10 + ch - '0';
        ch = *fmt;
        if (ch < '0' || ch > '9')
          break;
      }
      goto process_precision;

    case '*':
      precision = va_arg(ap, int);
      goto process_precision;

    case '.':
      if (width < 0)
        width = 0;
      goto reswitch;

    case '#':
      altflag = 1;
      goto reswitch;

    process_precision:
      if (width < 0)
        width = precision, precision = -1;
      goto reswitch;

    // long flag
    case 'l':
      if (lflag)
        goto bad;
      goto reswitch;

    // character
    case 'c':
      putch(va_arg(ap, int), putdat);
      break;

    // double
    case 'f':
      print_double(putch, putdat, va_arg(ap, double), width, precision);
      break;

    // string
    case 's':
      if ((p = va_arg(ap, char *)) == NULL)
        p = "(null)";
      if (width > 0 && padc != '-')
        for (width -= strnlen(p, precision); width > 0; width--)
          putch(padc, putdat);
      for (; (ch = *p) != '\0' && (precision < 0 || --precision >= 0); width--) {
        putch(ch, putdat);
        p++;
      }
      for (; width > 0; width--)
        putch(' ', putdat);
      break;

    // (signed) decimal
    case 'd':
      num = getint(&ap, lflag);
      if ((long) num < 0) {
        putch('-', putdat);
        num = -(long) num;
      }
      base = 10;
      goto signed_number;

    // unsigned decimal
    case 'u':
      base = 10;
      goto unsigned_number;

    // (unsigned) octal
    case 'o':
      // should do something with padding so it's always 3 octits
      base = 8;
      goto unsigned_number;

    // pointer
    case 'p':
      lflag = 1;
      putch('0', putdat);
      putch('x', putdat);
      /* fall through to 'x' */

    // (unsigned) hexadecimal
    case 'x':
      base = 16;
    unsigned_number:
      num = getuint(&ap, lflag);
    signed_number:
      printnum(putch, putdat, num, base, width, padc);
      break;

    // escaped '%' character
    case '%':
      putch(ch, putdat);
      break;
      
    // unrecognized escape sequence - just print it literally
    default:
    bad:
      putch('%', putdat);
      fmt = last_fmt;
      break;
    }
  }
}

int printf(const char* fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);

  vprintfmt((void*)putchar, 0, fmt, ap);

  va_end(ap);
  return 0; // incorrect return value, but who cares, anyway?
}

int sprintf(char* str, const char* fmt, ...)
{
  va_list ap;
  char* str0 = str;
  va_start(ap, fmt);

  vprintfmt(sprintf_putch, (void**)&str, fmt, ap);
  *str = 0;

  va_end(ap);
  return str - str0;
}

long time()
{
  int cycles;
  asm volatile ("rdcycle %0" : "=r"(cycles));
  // printf("[time() -> %d]", cycles);
  return cycles;
}

long insn()
{
  int insns;
  asm volatile ("rdinstret %0" : "=r"(insns));
  // printf("[insn() -> %d]", insns);
  return insns;
}

char *malloc(int size)
{
  char *p = heap_memory + heap_memory_used;
  // printf("[malloc(%d) -> %d (%d..%d)]", size, (int)p, heap_memory_used, heap_memory_used + size);
  heap_memory_used += size;
  if (heap_memory_used > heap_size)
    asm volatile ("ebreak");
  return p;
}

void *memcpy(void *aa, const void *bb, long n)
{
  // printf("**MEMCPY**\n");
  char *a = aa;
  const char *b = bb;
  while (n--) *(a++) = *(b++);
  return aa;
}

char *strcpy(char* dst, const char* src)
{
  char *r = dst;

  while ((((uint32_t)dst | (uint32_t)src) & 3) != 0)
  {
    char c = *(src++);
    *(dst++) = c;
    if (!c) return r;
  }

  while (1)
  {
    uint32_t v = *(uint32_t*)src;

    if (__builtin_expect((((v) - 0x01010101UL) & ~(v) & 0x80808080UL), 0))
    {
      dst[0] = v & 0xff;
      if ((v & 0xff) == 0)
        return r;
      v = v >> 8;

      dst[1] = v & 0xff;
      if ((v & 0xff) == 0)
        return r;
      v = v >> 8;

      dst[2] = v & 0xff;
      if ((v & 0xff) == 0)
        return r;
      v = v >> 8;

      dst[3] = v & 0xff;
      return r;
    }

    *(uint32_t*)dst = v;
    src += 4;
    dst += 4;
  }
}

int strcmp(const char *s1, const char *s2)
{
  while ((((uint32_t)s1 | (uint32_t)s2) & 3) != 0)
  {
    char c1 = *(s1++);
    char c2 = *(s2++);

    if (c1 != c2)
      return c1 < c2 ? -1 : +1;
    else if (!c1)
      return 0;
  }

  while (1)
  {
    uint32_t v1 = *(uint32_t*)s1;
    uint32_t v2 = *(uint32_t*)s2;

    if (__builtin_expect(v1 != v2, 0))
    {
      char c1, c2;

      c1 = v1 & 0xff, c2 = v2 & 0xff;
      if (c1 != c2) return c1 < c2 ? -1 : +1;
      if (!c1) return 0;
      v1 = v1 >> 8, v2 = v2 >> 8;

      c1 = v1 & 0xff, c2 = v2 & 0xff;
      if (c1 != c2) return c1 < c2 ? -1 : +1;
      if (!c1) return 0;
      v1 = v1 >> 8, v2 = v2 >> 8;

      c1 = v1 & 0xff, c2 = v2 & 0xff;
      if (c1 != c2) return c1 < c2 ? -1 : +1;
      if (!c1) return 0;
      v1 = v1 >> 8, v2 = v2 >> 8;

      c1 = v1 & 0xff, c2 = v2 & 0xff;
      if (c1 != c2) return c1 < c2 ? -1 : +1;
      return 0;
    }

    if (__builtin_expect((((v1) - 0x01010101UL) & ~(v1) & 0x80808080UL), 0))
      return 0;

    s1 += 4;
    s2 += 4;
  }
}