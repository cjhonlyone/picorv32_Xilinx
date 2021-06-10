// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "firmware.h"

uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	// static unsigned int ext_irq_4_count = 0;
	// static unsigned int ext_irq_5_count = 0;
	static unsigned int timer_irq_count = 0;

	if ((irqs & (1<<5)) != 0) {
		dma_rx_irq(netif);
		// print_str("[EXT-IRQ-5]");
	}

	if ((irqs & 1) != 0) {
		timer_irq_count++;
		// print_str("[TIMER-IRQ]");
		// *(volatile unsigned int*)0x80000000 = i;
		// i++;
		// enable_timer(125000000);
	}

	return regs;
}

