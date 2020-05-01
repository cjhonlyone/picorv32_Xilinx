	.section .text
	.global start
	.global main

start:
	/* print "START\n" */
	addi a0,zero,'S'
	jal  ra,putc
	addi a0,zero,'T'
	jal  ra,putc
	addi a0,zero,'A'
	jal  ra,putc
	addi a0,zero,'R'
	jal  ra,putc
	addi a0,zero,'\n'
	jal  ra,putc

	/* execute some insns for "make timing" */
	lui a0,0
	auipc a0,0
	slli a0,a0,0
	slli a0,a0,31
	addi a1,zero,0
	sll a0,a0,a1
	addi a1,zero,31
	sll a0,a0,a1

	/* set stack pointer */
	lui sp,(64*1024)>>12

	/* jump to main C code */
	jal ra,main

	/* print "DONE\n" */
	addi a0,zero,'D'
	jal  ra,putc
	addi a0,zero,'O'
	jal  ra,putc
	addi a0,zero,'N'
	jal  ra,putc
	addi a0,zero,'E'
	jal  ra,putc
	addi a0,zero,'\n'
	jal  ra,putc

	/* trap */
	ebreak

