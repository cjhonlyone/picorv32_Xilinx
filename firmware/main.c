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
    
int main()
{ 
	int i=0;
	int j=0;
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

	//   char c;
	// unsigned int a,b,y;
	// float fa,fb,fy;
	// fa = 5788.345;
	// fb = 682.7713;
	// fy = fa*fb;
	// printf("%.6f * %.6f = %.6f\n",fa,fb,fy);
	// printf("%08x * %08x = %08x\n", *(uint32_t*)(&fa),*(uint32_t*)(&fb),*(uint32_t*)(&fy));
	// a = 12;
	// b = 2;
	while(1)
	{
		for (j = 0;j<8000;j++) // 1600ms
			delay(1000); // 400us

		//led(1);
		*(volatile unsigned int*)0x80000000 = i;
		i++;
		// y = a*b;
		// printf("xxxxxxxxxxxxxx\n");
		printf("picorv32_v6\n");
		// fa = fa +1;
		// fb = fb+1;
		// fy = fa*fb;
		// printf("%.6f * %.6f = %.6f\n",fa,fb,fy);
		// printf("%08x * %08x = %08x\n", *(uint32_t*)(&fa),*(uint32_t*)(&fb),*(uint32_t*)(&fy));
		// a ++;b++;
		// if (a == 20)
		// {
		// 	a =0;b=1;
		// }
	}
	return 0; 

}


// uint32_t *irq(uint32_t *regs, uint32_t irqs)
// {
// 	static unsigned int ext_irq_4_count = 0;
// 	static unsigned int ext_irq_5_count = 0;
// 	static unsigned int timer_irq_count = 0;

// 	// checking compressed isa q0 reg handling
// 	if ((irqs & 6) != 0) {
// 		uint32_t pc = (regs[0] & 1) ? regs[0] - 3 : regs[0] - 4;
// 		uint32_t instr = *(uint16_t*)pc;

// 		if ((instr & 3) == 3)
// 			instr = instr | (*(uint16_t*)(pc + 2)) << 16;

// 		if (((instr & 3) != 3) != (regs[0] & 1)) {
// 			print_str("Mismatch between q0 LSB and decoded instruction word! q0=0x");
// 			print_hex(regs[0], 8);
// 			print_str(", instr=0x");
// 			// if ((instr & 3) == 3)
// 			// 	print_hex(instr, 8);
// 			// else
// 			// 	print_hex(instr, 4);
// 			print_str("\n");
// 			__asm__ volatile ("ebreak");
// 		}
// 	}

// 	if ((irqs & (1<<4)) != 0) {
// 		ext_irq_4_count++;
// 		print_str("[EXT-IRQ-4]");
// 	}

// 	if ((irqs & (1<<5)) != 0) {
// 		ext_irq_5_count++;
// 		print_str("[EXT-IRQ-5]");
// 	}

// 	if ((irqs & 1) != 0) {
// 		timer_irq_count++;
// 		print_str("[TIMER-IRQ]");
// 	}

// 	if ((irqs & 6) != 0)
// 	{
// 		uint32_t pc = (regs[0] & 1) ? regs[0] - 3 : regs[0] - 4;
// 		uint32_t instr = *(uint16_t*)pc;

// 		if ((instr & 3) == 3)
// 			instr = instr | (*(uint16_t*)(pc + 2)) << 16;

// 		print_str("\n");
// 		print_str("------------------------------------------------------------\n");

// 		if ((irqs & 2) != 0) {
// 			if (instr == 0x00100073 || instr == 0x9002) {
// 				print_str("EBREAK instruction at 0x");
// 				print_hex(pc, 8);
// 				print_str("\n");
// 			} else {
// 				print_str("Illegal Instruction at 0x");
// 				print_hex(pc, 8);
// 				print_str(": 0x");
// 				print_hex(instr, ((instr & 3) == 3) ? 8 : 4);
// 				print_str("\n");
// 			}
// 		}

// 		if ((irqs & 4) != 0) {
// 			print_str("Bus error in Instruction at 0x");
// 			print_hex(pc, 8);
// 			print_str(": 0x");
// 			print_hex(instr, ((instr & 3) == 3) ? 8 : 4);
// 			print_str("\n");
// 		}

// 		for (int i = 0; i < 8; i++)
// 		for (int k = 0; k < 4; k++)
// 		{
// 			int r = i + k*8;

// 			if (r == 0) {
// 				print_str("pc  ");
// 			} else
// 			if (r < 10) {
// 				print_chr('x');
// 				print_chr('0' + r);
// 				print_chr(' ');
// 				print_chr(' ');
// 			} else
// 			if (r < 20) {
// 				print_chr('x');
// 				print_chr('1');
// 				print_chr('0' + r - 10);
// 				print_chr(' ');
// 			} else
// 			if (r < 30) {
// 				print_chr('x');
// 				print_chr('2');
// 				print_chr('0' + r - 20);
// 				print_chr(' ');
// 			} else {
// 				print_chr('x');
// 				print_chr('3');
// 				print_chr('0' + r - 30);
// 				print_chr(' ');
// 			}

// 			print_hex(regs[r], 8);
// 			print_str(k == 3 ? "\n" : "    ");
// 		}

// 		print_str("------------------------------------------------------------\n");

// 		print_str("Number of fast external IRQs counted: ");
// 		print_dec(ext_irq_4_count);
// 		print_str("\n");

// 		print_str("Number of slow external IRQs counted: ");
// 		print_dec(ext_irq_5_count);
// 		print_str("\n");

// 		print_str("Number of timer IRQs counted: ");
// 		print_dec(timer_irq_count);
// 		print_str("\n");

// 		__asm__ volatile ("ebreak");
// 	}

// 	return regs;
// }
