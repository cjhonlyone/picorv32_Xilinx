#include "util.h"

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

int main()
{ 
	int i=0;
	int j=0;
	//   char c;
	unsigned int a,b,y;
	a = 12;
	b = 2;
	while(1)
	{
		for (j = 0;j<1000;j++) // 400ms
		delay(1000); // 400us

		led(i);
		// *(volatile unsigned int*)0x80000000 = i;
		i++;
		// if (i == 100)
		// i = 0;
		// *(volatile unsigned int*)0x80000018 = 1;
		// *(volatile unsigned int*)0x80000014 = bin2bcd(i);
		y = a*b;

		put_dec(a);puts(" * ");put_dec(b);puts(" = ");put_dec(y);putc('\n');
		puts("picorv32\n");
		// fa = 23.758;
		// fb = 682.7713;
		// fy = fa*fb;
		// puts("(int)(23.758 * 682.7713) = "); put_dec(fy); putc('\n');
		a ++;b++;
		if (a == 20)
		{
			a =0;b=1;
		}
	}
	return 0; 

}
