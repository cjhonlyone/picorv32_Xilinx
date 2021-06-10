#include "mylib.h"


static volatile unsigned int timer_irq_count = 0;

void delay(int m)
{ int i;
  for (i=0; i<m; i++) {
    asm volatile("nop"); } }

void disp_seg_dig(uint8_t *arr)
{
	uint32_t tmp = 0;
	tmp = arr[0] | 
		(arr[1] << 8) | 
		(arr[2] << 16) | 
		(arr[3] << 24) ;
	*(uint32_t*)0x80010048 = tmp;
	tmp = arr[4] | 
		(arr[5] << 8) | 
		(arr[6] << 16) | 
		(arr[7] << 24) ;
	*(uint32_t*)0x8001004C = tmp;
}

/**
 * Swap two values by using pointer
 * @param first first pointer of first number
 * @param second second pointer of second number
 */
void swap(uint8_t *first, uint8_t *second)
{
    uint8_t temp = *first;
    *first = *second;
    *second = temp;
}

/**
 * Bubble sort algorithm implementation
 * @param arr array to be sorted
 * @param size size of array
 */
void bubbleSort(uint8_t *arr, int size)
{
    for (int i = 0; i < size - 1; i++)
    {                         /* for each array index */
        bool swapped = false; /* flag to check if any changes had to be made */
        /* perform iterations until no more changes were made or outer loop
            executed for all array indices */
        for (int j = 0; j < size - 1 - i; j++)
        { /* for each element in the array */
            if (arr[j] > arr[j + 1])
            { /* if the order of successive elements needs update */
                swap(&arr[j], &arr[j + 1]);
                swapped = true; /* set flag */
            }
            delay(1000000);
            disp_seg_dig(arr);
        }
        if (!swapped)
        {
            /* since no more updates we made, the array is already sorted
                this is an optimization for early termination */
            break;
        }
    }
}

uint8_t array[8] = {7,6,5,4,3,2,1,0};



int main()
{ 

	printf("system booting .......................\n");

	array[0] = 7;
	array[1] = 6;
	array[2] = 5;
	array[3] = 4;
	array[4] = 3;
	array[5] = 2;
	array[6] = 1;
	array[7] = 0;
	disp_seg_dig(array);

	bubbleSort(array, 8);

	

	long time_ = time();
	enable_timer(125000000);
	
	uint32_t kk = 0;

	while (1) {
// printf("system booting .......................\n");
  }
}

uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	// static unsigned int ext_irq_4_count = 0;
	// static unsigned int ext_irq_5_count = 0;

	// uint32_t pc = (regs[0] & 1) ? regs[0] - 3 : regs[0] - 4;
	// printf("irqs 0x%08x pc 0x%08x\n",irqs, pc);
	// if ((irqs & (1<<5)) != 0) {
	// 	// printf("dma_rx_irq\n");
	// 	// printf("[EXT-IRQ-5]");
	// }

	if ((irqs & 1) != 0) {
		// tcp_tmr();
		enable_timer(50000000);
		printf("timer %d\n",timer_irq_count);
		timer_irq_count++;
	}
	return regs;
}
