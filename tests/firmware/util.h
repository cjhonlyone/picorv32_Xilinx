void led(int x);
void uart_tx_data(int x);
int uart_tx_ready();
int uart_rx_data();
int uart_rx_ready();
void delay(int m);
void putc(char c);
void puts(char* s);
char getc();
void put_hex(unsigned int x);
void put_dec(unsigned int x);
// int fputc(int ch,FILE* f);
// int fgetc(FILE* f);

void print_chr(char ch);
void print_str(const char *p);
void print_dec(unsigned int val);
void print_hex(unsigned int val, int digits);

