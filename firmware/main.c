#include "mylib.h"

//BCD码转为二进制 
unsigned bcd2bin(unsigned char val)
{
	return (val & 0x0f) + (val >> 4) * 10;
}

//二进制转为BCD码 
unsigned char bin2bcd(unsigned val)
{
	return ((val / 10) << 4) + val % 10;
}

void delay(int m)
{ int i;
  for (i=0; i<m; i++) {
    asm volatile("nop"); } }

int a[8] = {1,2,3,4};
int b[8];

static int c;
static int d = 0x55;

int main()
{ 
	int e[8] = {1,2,3,4};
	int f[8];

	static int g;
	static int h = 0x55;


	char char_va;
	short  short_va;
	int int_va;
	long long_va;
	long long longlong_va;
	void*  void_va;
	float  float_va;
	double double_va;
	long double longdouble_va;

	printf("size of char : %d\n",sizeof(char_va));
	printf("size of short  : %d\n",sizeof(short_va));
	printf("size of int : %d\n",sizeof(int_va));
	printf("size of long : %d\n",sizeof(long_va));
	printf("size of long long  : %d\n",sizeof(longlong_va));
	printf("size of void* : %d\n",sizeof(void_va));
	printf("size of float  : %d\n",sizeof(float_va));
	printf("size of double : %d\n",sizeof(double_va));
	printf("size of long double : %d\n",sizeof(longdouble_va));

	int_va = 0x11223344;

	printf("int_va = %08x\n",int_va);
	printf("&int_va = %08x\n",&int_va);
	printf("*%08x = %02x\n",(((char *)(&int_va))+0),*(((char *)(&int_va))+0));
	printf("*%08x = %02x\n",(((char *)(&int_va))+1),*(((char *)(&int_va))+1));
	printf("*%08x = %02x\n",(((char *)(&int_va))+2),*(((char *)(&int_va))+2));
	printf("*%08x = %02x\n",(((char *)(&int_va))+3),*(((char *)(&int_va))+3));
	if ((*(char *)&int_va) == 0x11)
		printf("Big Endian\n");
	else if ((*(char *)&int_va) == 0x44)
		printf("Small Endian\n");


	/*size of char : 1
	size of short  : 2
	size of int : 4
	size of long : 4
	size of long long  : 8
	size of void* : 4
	size of float  : 4
	size of double : 8
	size of long double : 16
	int_va = 11223344
	&int_va = 0001ffec
	*0001ffec = 44
	*0001ffed = 33
	*0001ffee = 22
	*0001ffef = 11
	Small Endian*/

	printf("&a[8] = %08x\n",a);
	printf("&b[8] = %08x\n",b);
	printf("&c = %08x\n",&c);
	printf("&d = %08x\n",&d);

	printf("&e[8] = %08x\n",e);
	printf("&f[8] = %08x\n",f);
	printf("&g = %08x\n",&g);
	printf("&h = %08x\n",&h);

	while(1)
	{
		for (int i = 0;i<8000;i++) // 1600ms
			delay(1000); // 400us

		//led(1);
		// *(volatile unsigned int*)0x80000000 = i;
		// i++;
		printf("picorv32_v6\n");
	}
	return 0; 

}
