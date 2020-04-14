
firmware.elf：     文件格式 elf32-littleriscv


Disassembly of section .memory:

00000000 <reset_vec>:
   0:	0600600b          	0x600600b
   4:	aef1                	j	3e0 <irq_stack>
   6:	00000013          	nop
   a:	00000013          	nop
   e:	0001                	nop

00000010 <irq_vec>:
  10:	0200a10b          	0x200a10b
  14:	0201218b          	0x201218b
  18:	000000b7          	lui	ra,0x0
  1c:	16008093          	addi	ra,ra,352 # 160 <irq_regs>
  20:	0000410b          	0x410b
  24:	0020a023          	sw	sp,0(ra)
  28:	0001410b          	0x1410b
  2c:	0020a223          	sw	sp,4(ra)
  30:	0001c10b          	0x1c10b
  34:	0020a423          	sw	sp,8(ra)
  38:	0030a623          	sw	gp,12(ra)
  3c:	0040a823          	sw	tp,16(ra)
  40:	0050aa23          	sw	t0,20(ra)
  44:	0060ac23          	sw	t1,24(ra)
  48:	0070ae23          	sw	t2,28(ra)
  4c:	0280a023          	sw	s0,32(ra)
  50:	0290a223          	sw	s1,36(ra)
  54:	02a0a423          	sw	a0,40(ra)
  58:	02b0a623          	sw	a1,44(ra)
  5c:	02c0a823          	sw	a2,48(ra)
  60:	02d0aa23          	sw	a3,52(ra)
  64:	02e0ac23          	sw	a4,56(ra)
  68:	02f0ae23          	sw	a5,60(ra)
  6c:	0500a023          	sw	a6,64(ra)
  70:	0510a223          	sw	a7,68(ra)
  74:	0520a423          	sw	s2,72(ra)
  78:	0530a623          	sw	s3,76(ra)
  7c:	0540a823          	sw	s4,80(ra)
  80:	0550aa23          	sw	s5,84(ra)
  84:	0560ac23          	sw	s6,88(ra)
  88:	0570ae23          	sw	s7,92(ra)
  8c:	0780a023          	sw	s8,96(ra)
  90:	0790a223          	sw	s9,100(ra)
  94:	07a0a423          	sw	s10,104(ra)
  98:	07b0a623          	sw	s11,108(ra)
  9c:	07c0a823          	sw	t3,112(ra)
  a0:	07d0aa23          	sw	t4,116(ra)
  a4:	07e0ac23          	sw	t5,120(ra)
  a8:	07f0ae23          	sw	t6,124(ra)
  ac:	00000137          	lui	sp,0x0
  b0:	3e010113          	addi	sp,sp,992 # 3e0 <irq_stack>
  b4:	00000537          	lui	a0,0x0
  b8:	16050513          	addi	a0,a0,352 # 160 <irq_regs>
  bc:	0000c58b          	0xc58b
  c0:	400000ef          	jal	ra,4c0 <irq>
  c4:	00050093          	mv	ra,a0
  c8:	0000a103          	lw	sp,0(ra)
  cc:	0201200b          	0x201200b
  d0:	0040a103          	lw	sp,4(ra)
  d4:	0201208b          	0x201208b
  d8:	0080a103          	lw	sp,8(ra)
  dc:	0201210b          	0x201210b
  e0:	00c0a183          	lw	gp,12(ra)
  e4:	0100a203          	lw	tp,16(ra)
  e8:	0140a283          	lw	t0,20(ra)
  ec:	0180a303          	lw	t1,24(ra)
  f0:	01c0a383          	lw	t2,28(ra)
  f4:	0200a403          	lw	s0,32(ra)
  f8:	0240a483          	lw	s1,36(ra)
  fc:	0280a503          	lw	a0,40(ra)
 100:	02c0a583          	lw	a1,44(ra)
 104:	0300a603          	lw	a2,48(ra)
 108:	0340a683          	lw	a3,52(ra)
 10c:	0380a703          	lw	a4,56(ra)
 110:	03c0a783          	lw	a5,60(ra)
 114:	0400a803          	lw	a6,64(ra)
 118:	0440a883          	lw	a7,68(ra)
 11c:	0480a903          	lw	s2,72(ra)
 120:	04c0a983          	lw	s3,76(ra)
 124:	0500aa03          	lw	s4,80(ra)
 128:	0540aa83          	lw	s5,84(ra)
 12c:	0580ab03          	lw	s6,88(ra)
 130:	05c0ab83          	lw	s7,92(ra)
 134:	0600ac03          	lw	s8,96(ra)
 138:	0640ac83          	lw	s9,100(ra)
 13c:	0680ad03          	lw	s10,104(ra)
 140:	06c0ad83          	lw	s11,108(ra)
 144:	0700ae03          	lw	t3,112(ra)
 148:	0740ae83          	lw	t4,116(ra)
 14c:	0780af03          	lw	t5,120(ra)
 150:	07c0af83          	lw	t6,124(ra)
 154:	0000c08b          	0xc08b
 158:	0001410b          	0x1410b
 15c:	0400000b          	0x400000b

00000160 <irq_regs>:
	...

000003e0 <irq_stack>:
 3e0:	00000093          	li	ra,0
 3e4:	00000113          	li	sp,0
 3e8:	00000193          	li	gp,0
 3ec:	00000213          	li	tp,0
 3f0:	00000293          	li	t0,0
 3f4:	00000313          	li	t1,0
 3f8:	00000393          	li	t2,0
 3fc:	00000413          	li	s0,0
 400:	00000493          	li	s1,0
 404:	00000513          	li	a0,0
 408:	00000593          	li	a1,0
 40c:	00000613          	li	a2,0
 410:	00000693          	li	a3,0
 414:	00000713          	li	a4,0
 418:	00000793          	li	a5,0
 41c:	00000813          	li	a6,0
 420:	00000893          	li	a7,0
 424:	00000913          	li	s2,0
 428:	00000993          	li	s3,0
 42c:	00000a13          	li	s4,0
 430:	00000a93          	li	s5,0
 434:	00000b13          	li	s6,0
 438:	00000b93          	li	s7,0
 43c:	00000c13          	li	s8,0
 440:	00000c93          	li	s9,0
 444:	00000d13          	li	s10,0
 448:	00000d93          	li	s11,0
 44c:	00000e13          	li	t3,0
 450:	00000e93          	li	t4,0
 454:	00000f13          	li	t5,0
 458:	00000f93          	li	t6,0
 45c:	00002137          	lui	sp,0x2
 460:	538000ef          	jal	ra,998 <main>

00000464 <hard_mul>:
 464:	02b50533          	mul	a0,a0,a1
 468:	8082                	ret

0000046a <hard_mulh>:
 46a:	02b51533          	mulh	a0,a0,a1
 46e:	8082                	ret

00000470 <hard_mulhsu>:
 470:	02b52533          	mulhsu	a0,a0,a1
 474:	8082                	ret

00000476 <hard_mulhu>:
 476:	02b53533          	mulhu	a0,a0,a1
 47a:	8082                	ret

0000047c <hard_div>:
 47c:	02b54533          	div	a0,a0,a1
 480:	8082                	ret

00000482 <hard_divu>:
 482:	02b55533          	divu	a0,a0,a1
 486:	8082                	ret

00000488 <hard_rem>:
 488:	02b56533          	rem	a0,a0,a1
 48c:	8082                	ret

0000048e <hard_remu>:
 48e:	02b57533          	remu	a0,a0,a1
 492:	8082                	ret
	...

0000049c <bcd2bin>:
 49c:	00455793          	srli	a5,a0,0x4
 4a0:	4729                	li	a4,10
 4a2:	02e787b3          	mul	a5,a5,a4
 4a6:	893d                	andi	a0,a0,15
 4a8:	953e                	add	a0,a0,a5
 4aa:	8082                	ret

000004ac <bin2bcd>:
 4ac:	4729                	li	a4,10
 4ae:	02e557b3          	divu	a5,a0,a4
 4b2:	02e57533          	remu	a0,a0,a4
 4b6:	0792                	slli	a5,a5,0x4
 4b8:	953e                	add	a0,a0,a5
 4ba:	0ff57513          	andi	a0,a0,255
 4be:	8082                	ret

000004c0 <irq>:
 4c0:	715d                	addi	sp,sp,-80
 4c2:	c4a2                	sw	s0,72(sp)
 4c4:	c0ca                	sw	s2,64(sp)
 4c6:	dc52                	sw	s4,56(sp)
 4c8:	c686                	sw	ra,76(sp)
 4ca:	c2a6                	sw	s1,68(sp)
 4cc:	de4e                	sw	s3,60(sp)
 4ce:	da56                	sw	s5,52(sp)
 4d0:	d85a                	sw	s6,48(sp)
 4d2:	d65e                	sw	s7,44(sp)
 4d4:	d462                	sw	s8,40(sp)
 4d6:	d266                	sw	s9,36(sp)
 4d8:	d06a                	sw	s10,32(sp)
 4da:	ce6e                	sw	s11,28(sp)
 4dc:	0065f413          	andi	s0,a1,6
 4e0:	892a                	mv	s2,a0
 4e2:	8a2e                	mv	s4,a1
 4e4:	cc31                	beqz	s0,540 <irq+0x80>
 4e6:	411c                	lw	a5,0(a0)
 4e8:	0017f693          	andi	a3,a5,1
 4ec:	ffc78713          	addi	a4,a5,-4
 4f0:	c299                	beqz	a3,4f6 <irq+0x36>
 4f2:	ffd78713          	addi	a4,a5,-3
 4f6:	00074783          	lbu	a5,0(a4)
 4fa:	460d                	li	a2,3
 4fc:	0037f593          	andi	a1,a5,3
 500:	00c59663          	bne	a1,a2,50c <irq+0x4c>
 504:	00274703          	lbu	a4,2(a4)
 508:	0742                	slli	a4,a4,0x10
 50a:	8fd9                	or	a5,a5,a4
 50c:	8b8d                	andi	a5,a5,3
 50e:	17f5                	addi	a5,a5,-3
 510:	00f037b3          	snez	a5,a5
 514:	02d78663          	beq	a5,a3,540 <irq+0x80>
 518:	00001537          	lui	a0,0x1
 51c:	a3050513          	addi	a0,a0,-1488 # a30 <main+0x98>
 520:	2901                	jal	930 <print_str>
 522:	00092503          	lw	a0,0(s2)
 526:	45a1                	li	a1,8
 528:	2901                	jal	938 <print_hex>
 52a:	00001537          	lui	a0,0x1
 52e:	a6c50513          	addi	a0,a0,-1428 # a6c <main+0xd4>
 532:	2efd                	jal	930 <print_str>
 534:	00001537          	lui	a0,0x1
 538:	ad850513          	addi	a0,a0,-1320 # ad8 <main+0x140>
 53c:	2ed5                	jal	930 <print_str>
 53e:	9002                	ebreak
 540:	010a7793          	andi	a5,s4,16
 544:	cf81                	beqz	a5,55c <irq+0x9c>
 546:	6705                	lui	a4,0x1
 548:	bbc72783          	lw	a5,-1092(a4) # bbc <ext_irq_4_count.1006>
 54c:	00001537          	lui	a0,0x1
 550:	a7850513          	addi	a0,a0,-1416 # a78 <main+0xe0>
 554:	0785                	addi	a5,a5,1
 556:	baf72e23          	sw	a5,-1092(a4)
 55a:	2ed9                	jal	930 <print_str>
 55c:	020a7793          	andi	a5,s4,32
 560:	cf81                	beqz	a5,578 <irq+0xb8>
 562:	6705                	lui	a4,0x1
 564:	bb872783          	lw	a5,-1096(a4) # bb8 <ext_irq_5_count.1007>
 568:	00001537          	lui	a0,0x1
 56c:	a8450513          	addi	a0,a0,-1404 # a84 <main+0xec>
 570:	0785                	addi	a5,a5,1
 572:	baf72c23          	sw	a5,-1096(a4)
 576:	2e6d                	jal	930 <print_str>
 578:	001a7793          	andi	a5,s4,1
 57c:	cf81                	beqz	a5,594 <irq+0xd4>
 57e:	6705                	lui	a4,0x1
 580:	bb472783          	lw	a5,-1100(a4) # bb4 <timer_irq_count.1008>
 584:	00001537          	lui	a0,0x1
 588:	a9050513          	addi	a0,a0,-1392 # a90 <main+0xf8>
 58c:	0785                	addi	a5,a5,1
 58e:	baf72a23          	sw	a5,-1100(a4)
 592:	2e79                	jal	930 <print_str>
 594:	14040263          	beqz	s0,6d8 <irq+0x218>
 598:	00092783          	lw	a5,0(s2)
 59c:	0017f713          	andi	a4,a5,1
 5a0:	ffc78a93          	addi	s5,a5,-4
 5a4:	c319                	beqz	a4,5aa <irq+0xea>
 5a6:	ffd78a93          	addi	s5,a5,-3
 5aa:	000ac403          	lbu	s0,0(s5)
 5ae:	478d                	li	a5,3
 5b0:	00347713          	andi	a4,s0,3
 5b4:	00f71663          	bne	a4,a5,5c0 <irq+0x100>
 5b8:	002ac783          	lbu	a5,2(s5)
 5bc:	07c2                	slli	a5,a5,0x10
 5be:	8c5d                	or	s0,s0,a5
 5c0:	000014b7          	lui	s1,0x1
 5c4:	ad848513          	addi	a0,s1,-1320 # ad8 <main+0x140>
 5c8:	26a5                	jal	930 <print_str>
 5ca:	000019b7          	lui	s3,0x1
 5ce:	a9c98513          	addi	a0,s3,-1380 # a9c <main+0x104>
 5d2:	2eb9                	jal	930 <print_str>
 5d4:	002a7793          	andi	a5,s4,2
 5d8:	c395                	beqz	a5,5fc <irq+0x13c>
 5da:	001007b7          	lui	a5,0x100
 5de:	07378793          	addi	a5,a5,115 # 100073 <end+0xff48b>
 5e2:	10f41b63          	bne	s0,a5,6f8 <irq+0x238>
 5e6:	00001537          	lui	a0,0x1
 5ea:	adc50513          	addi	a0,a0,-1316 # adc <main+0x144>
 5ee:	2689                	jal	930 <print_str>
 5f0:	45a1                	li	a1,8
 5f2:	8556                	mv	a0,s5
 5f4:	2691                	jal	938 <print_hex>
 5f6:	ad848513          	addi	a0,s1,-1320
 5fa:	2e1d                	jal	930 <print_str>
 5fc:	004a7a13          	andi	s4,s4,4
 600:	020a0b63          	beqz	s4,636 <irq+0x176>
 604:	00001537          	lui	a0,0x1
 608:	b1c50513          	addi	a0,a0,-1252 # b1c <main+0x184>
 60c:	2615                	jal	930 <print_str>
 60e:	45a1                	li	a1,8
 610:	8556                	mv	a0,s5
 612:	261d                	jal	938 <print_hex>
 614:	00001537          	lui	a0,0x1
 618:	b1450513          	addi	a0,a0,-1260 # b14 <main+0x17c>
 61c:	2e11                	jal	930 <print_str>
 61e:	00347793          	andi	a5,s0,3
 622:	470d                	li	a4,3
 624:	45a1                	li	a1,8
 626:	00e78363          	beq	a5,a4,62c <irq+0x16c>
 62a:	4591                	li	a1,4
 62c:	8522                	mv	a0,s0
 62e:	2629                	jal	938 <print_hex>
 630:	ad848513          	addi	a0,s1,-1320
 634:	2cf5                	jal	930 <print_str>
 636:	00001b37          	lui	s6,0x1
 63a:	4a81                	li	s5,0
 63c:	4ca5                	li	s9,9
 63e:	4d4d                	li	s10,19
 640:	00001db7          	lui	s11,0x1
 644:	a28b0b13          	addi	s6,s6,-1496 # a28 <main+0x90>
 648:	ad848793          	addi	a5,s1,-1320
 64c:	8456                	mv	s0,s5
 64e:	4a01                	li	s4,0
 650:	4c75                	li	s8,29
 652:	4b8d                	li	s7,3
 654:	c63e                	sw	a5,12(sp)
 656:	0c041763          	bnez	s0,724 <irq+0x264>
 65a:	b3cd8513          	addi	a0,s11,-1220 # b3c <main+0x1a4>
 65e:	2cc9                	jal	930 <print_str>
 660:	00241793          	slli	a5,s0,0x2
 664:	97ca                	add	a5,a5,s2
 666:	4388                	lw	a0,0(a5)
 668:	45a1                	li	a1,8
 66a:	24f9                	jal	938 <print_hex>
 66c:	4532                	lw	a0,12(sp)
 66e:	017a0363          	beq	s4,s7,674 <irq+0x1b4>
 672:	855a                	mv	a0,s6
 674:	2c75                	jal	930 <print_str>
 676:	0a05                	addi	s4,s4,1
 678:	4791                	li	a5,4
 67a:	0421                	addi	s0,s0,8
 67c:	fcfa1de3          	bne	s4,a5,656 <irq+0x196>
 680:	0a85                	addi	s5,s5,1
 682:	47a1                	li	a5,8
 684:	fcfa92e3          	bne	s5,a5,648 <irq+0x188>
 688:	a9c98513          	addi	a0,s3,-1380
 68c:	2455                	jal	930 <print_str>
 68e:	00001537          	lui	a0,0x1
 692:	b4450513          	addi	a0,a0,-1212 # b44 <main+0x1ac>
 696:	2c69                	jal	930 <print_str>
 698:	6785                	lui	a5,0x1
 69a:	bbc7a503          	lw	a0,-1092(a5) # bbc <ext_irq_4_count.1006>
 69e:	2c59                	jal	934 <print_dec>
 6a0:	ad848513          	addi	a0,s1,-1320
 6a4:	2471                	jal	930 <print_str>
 6a6:	00001537          	lui	a0,0x1
 6aa:	b6c50513          	addi	a0,a0,-1172 # b6c <main+0x1d4>
 6ae:	2449                	jal	930 <print_str>
 6b0:	6785                	lui	a5,0x1
 6b2:	bb87a503          	lw	a0,-1096(a5) # bb8 <ext_irq_5_count.1007>
 6b6:	2cbd                	jal	934 <print_dec>
 6b8:	ad848513          	addi	a0,s1,-1320
 6bc:	2c95                	jal	930 <print_str>
 6be:	00001537          	lui	a0,0x1
 6c2:	b9450513          	addi	a0,a0,-1132 # b94 <main+0x1fc>
 6c6:	24ad                	jal	930 <print_str>
 6c8:	6785                	lui	a5,0x1
 6ca:	bb47a503          	lw	a0,-1100(a5) # bb4 <timer_irq_count.1008>
 6ce:	249d                	jal	934 <print_dec>
 6d0:	ad848513          	addi	a0,s1,-1320
 6d4:	2cb1                	jal	930 <print_str>
 6d6:	9002                	ebreak
 6d8:	40b6                	lw	ra,76(sp)
 6da:	4426                	lw	s0,72(sp)
 6dc:	854a                	mv	a0,s2
 6de:	4496                	lw	s1,68(sp)
 6e0:	4906                	lw	s2,64(sp)
 6e2:	59f2                	lw	s3,60(sp)
 6e4:	5a62                	lw	s4,56(sp)
 6e6:	5ad2                	lw	s5,52(sp)
 6e8:	5b42                	lw	s6,48(sp)
 6ea:	5bb2                	lw	s7,44(sp)
 6ec:	5c22                	lw	s8,40(sp)
 6ee:	5c92                	lw	s9,36(sp)
 6f0:	5d02                	lw	s10,32(sp)
 6f2:	4df2                	lw	s11,28(sp)
 6f4:	6161                	addi	sp,sp,80
 6f6:	8082                	ret
 6f8:	00001537          	lui	a0,0x1
 6fc:	af850513          	addi	a0,a0,-1288 # af8 <main+0x160>
 700:	2c05                	jal	930 <print_str>
 702:	45a1                	li	a1,8
 704:	8556                	mv	a0,s5
 706:	2c0d                	jal	938 <print_hex>
 708:	00001537          	lui	a0,0x1
 70c:	b1450513          	addi	a0,a0,-1260 # b14 <main+0x17c>
 710:	2405                	jal	930 <print_str>
 712:	00347793          	andi	a5,s0,3
 716:	470d                	li	a4,3
 718:	45a1                	li	a1,8
 71a:	00e78363          	beq	a5,a4,720 <irq+0x260>
 71e:	4591                	li	a1,4
 720:	8522                	mv	a0,s0
 722:	bdc9                	j	5f4 <irq+0x134>
 724:	07800513          	li	a0,120
 728:	008ccf63          	blt	s9,s0,746 <irq+0x286>
 72c:	2401                	jal	92c <print_chr>
 72e:	03040513          	addi	a0,s0,48
 732:	0ff57513          	andi	a0,a0,255
 736:	2add                	jal	92c <print_chr>
 738:	02000513          	li	a0,32
 73c:	2ac5                	jal	92c <print_chr>
 73e:	02000513          	li	a0,32
 742:	22ed                	jal	92c <print_chr>
 744:	bf31                	j	660 <irq+0x1a0>
 746:	008d4b63          	blt	s10,s0,75c <irq+0x29c>
 74a:	22cd                	jal	92c <print_chr>
 74c:	03100513          	li	a0,49
 750:	2af1                	jal	92c <print_chr>
 752:	02640513          	addi	a0,s0,38
 756:	0ff57513          	andi	a0,a0,255
 75a:	b7cd                	j	73c <irq+0x27c>
 75c:	008c4963          	blt	s8,s0,76e <irq+0x2ae>
 760:	22f1                	jal	92c <print_chr>
 762:	03200513          	li	a0,50
 766:	22d9                	jal	92c <print_chr>
 768:	01c40513          	addi	a0,s0,28
 76c:	b7ed                	j	756 <irq+0x296>
 76e:	2a7d                	jal	92c <print_chr>
 770:	03300513          	li	a0,51
 774:	2a65                	jal	92c <print_chr>
 776:	01240513          	addi	a0,s0,18
 77a:	bff1                	j	756 <irq+0x296>

0000077c <led>:
 77c:	800007b7          	lui	a5,0x80000
 780:	00a7a023          	sw	a0,0(a5) # 80000000 <end+0x7ffff418>
 784:	00008067          	ret

00000788 <uart_tx_data>:
 788:	800007b7          	lui	a5,0x80000
 78c:	00a7a223          	sw	a0,4(a5) # 80000004 <end+0x7ffff41c>
 790:	00008067          	ret

00000794 <uart_tx_ready>:
 794:	800007b7          	lui	a5,0x80000
 798:	0087a503          	lw	a0,8(a5) # 80000008 <end+0x7ffff420>
 79c:	00008067          	ret

000007a0 <uart_rx_data>:
 7a0:	800007b7          	lui	a5,0x80000
 7a4:	00c7a503          	lw	a0,12(a5) # 8000000c <end+0x7ffff424>
 7a8:	00008067          	ret

000007ac <uart_rx_ready>:
 7ac:	800007b7          	lui	a5,0x80000
 7b0:	0107a503          	lw	a0,16(a5) # 80000010 <end+0x7ffff428>
 7b4:	00008067          	ret

000007b8 <delay>:
 7b8:	00000793          	li	a5,0
 7bc:	00a7c463          	blt	a5,a0,7c4 <delay+0xc>
 7c0:	00008067          	ret
 7c4:	00000013          	nop
 7c8:	00178793          	addi	a5,a5,1
 7cc:	ff1ff06f          	j	7bc <delay+0x4>

000007d0 <putc>:
 7d0:	800007b7          	lui	a5,0x80000
 7d4:	0087a703          	lw	a4,8(a5) # 80000008 <end+0x7ffff420>
 7d8:	fe070ee3          	beqz	a4,7d4 <putc+0x4>
 7dc:	00a7a223          	sw	a0,4(a5)
 7e0:	00008067          	ret

000007e4 <puts>:
 7e4:	ff010113          	addi	sp,sp,-16 # 1ff0 <end+0x1408>
 7e8:	00812423          	sw	s0,8(sp)
 7ec:	00112623          	sw	ra,12(sp)
 7f0:	00050413          	mv	s0,a0
 7f4:	00140413          	addi	s0,s0,1
 7f8:	fff44503          	lbu	a0,-1(s0)
 7fc:	00051a63          	bnez	a0,810 <puts+0x2c>
 800:	00c12083          	lw	ra,12(sp)
 804:	00812403          	lw	s0,8(sp)
 808:	01010113          	addi	sp,sp,16
 80c:	00008067          	ret
 810:	fc1ff0ef          	jal	ra,7d0 <putc>
 814:	fe1ff06f          	j	7f4 <puts+0x10>

00000818 <getc>:
 818:	800007b7          	lui	a5,0x80000
 81c:	0107a703          	lw	a4,16(a5) # 80000010 <end+0x7ffff428>
 820:	fe070ee3          	beqz	a4,81c <getc+0x4>
 824:	00c7a503          	lw	a0,12(a5)
 828:	0ff57513          	andi	a0,a0,255
 82c:	00008067          	ret

00000830 <put_nib>:
 830:	00900713          	li	a4,9
 834:	0ff57793          	andi	a5,a0,255
 838:	00a76863          	bltu	a4,a0,848 <put_nib+0x18>
 83c:	03078793          	addi	a5,a5,48
 840:	0ff7f513          	andi	a0,a5,255
 844:	f8dff06f          	j	7d0 <putc>
 848:	05778793          	addi	a5,a5,87
 84c:	ff5ff06f          	j	840 <put_nib+0x10>

00000850 <put_hex>:
 850:	ff010113          	addi	sp,sp,-16
 854:	00812423          	sw	s0,8(sp)
 858:	00912223          	sw	s1,4(sp)
 85c:	01212023          	sw	s2,0(sp)
 860:	00112623          	sw	ra,12(sp)
 864:	00050913          	mv	s2,a0
 868:	01c00413          	li	s0,28
 86c:	ffc00493          	li	s1,-4
 870:	00895533          	srl	a0,s2,s0
 874:	00f57513          	andi	a0,a0,15
 878:	ffc40413          	addi	s0,s0,-4
 87c:	fb5ff0ef          	jal	ra,830 <put_nib>
 880:	fe9418e3          	bne	s0,s1,870 <put_hex+0x20>
 884:	00c12083          	lw	ra,12(sp)
 888:	00812403          	lw	s0,8(sp)
 88c:	00412483          	lw	s1,4(sp)
 890:	00012903          	lw	s2,0(sp)
 894:	01010113          	addi	sp,sp,16
 898:	00008067          	ret

0000089c <put_dec>:
 89c:	00051663          	bnez	a0,8a8 <put_dec+0xc>
 8a0:	03000513          	li	a0,48
 8a4:	f2dff06f          	j	7d0 <putc>
 8a8:	fe010113          	addi	sp,sp,-32
 8ac:	00812c23          	sw	s0,24(sp)
 8b0:	3b9ad437          	lui	s0,0x3b9ad
 8b4:	01212823          	sw	s2,16(sp)
 8b8:	01312623          	sw	s3,12(sp)
 8bc:	01412423          	sw	s4,8(sp)
 8c0:	00112e23          	sw	ra,28(sp)
 8c4:	00912a23          	sw	s1,20(sp)
 8c8:	00050913          	mv	s2,a0
 8cc:	00a00993          	li	s3,10
 8d0:	00000793          	li	a5,0
 8d4:	a0040413          	addi	s0,s0,-1536 # 3b9aca00 <end+0x3b9abe18>
 8d8:	00a00a13          	li	s4,10
 8dc:	028954b3          	divu	s1,s2,s0
 8e0:	0097e733          	or	a4,a5,s1
 8e4:	00000793          	li	a5,0
 8e8:	00070863          	beqz	a4,8f8 <put_dec+0x5c>
 8ec:	00048513          	mv	a0,s1
 8f0:	f41ff0ef          	jal	ra,830 <put_nib>
 8f4:	00100793          	li	a5,1
 8f8:	028484b3          	mul	s1,s1,s0
 8fc:	fff98993          	addi	s3,s3,-1
 900:	40990933          	sub	s2,s2,s1
 904:	03444433          	div	s0,s0,s4
 908:	fc099ae3          	bnez	s3,8dc <put_dec+0x40>
 90c:	01c12083          	lw	ra,28(sp)
 910:	01812403          	lw	s0,24(sp)
 914:	01412483          	lw	s1,20(sp)
 918:	01012903          	lw	s2,16(sp)
 91c:	00c12983          	lw	s3,12(sp)
 920:	00812a03          	lw	s4,8(sp)
 924:	02010113          	addi	sp,sp,32
 928:	00008067          	ret

0000092c <print_chr>:
 92c:	ea5ff06f          	j	7d0 <putc>

00000930 <print_str>:
 930:	eb5ff06f          	j	7e4 <puts>

00000934 <print_dec>:
 934:	f69ff06f          	j	89c <put_dec>

00000938 <print_hex>:
 938:	ff010113          	addi	sp,sp,-16
 93c:	00912223          	sw	s1,4(sp)
 940:	fff58593          	addi	a1,a1,-1
 944:	000014b7          	lui	s1,0x1
 948:	00812423          	sw	s0,8(sp)
 94c:	01212023          	sw	s2,0(sp)
 950:	00112623          	sw	ra,12(sp)
 954:	00050913          	mv	s2,a0
 958:	00259413          	slli	s0,a1,0x2
 95c:	bd448493          	addi	s1,s1,-1068 # bd4 <ext_irq_4_count.1006+0x18>
 960:	00045e63          	bgez	s0,97c <print_hex+0x44>
 964:	00c12083          	lw	ra,12(sp)
 968:	00812403          	lw	s0,8(sp)
 96c:	00412483          	lw	s1,4(sp)
 970:	00012903          	lw	s2,0(sp)
 974:	01010113          	addi	sp,sp,16
 978:	00008067          	ret
 97c:	008957b3          	srl	a5,s2,s0
 980:	00f7f793          	andi	a5,a5,15
 984:	009787b3          	add	a5,a5,s1
 988:	0007c503          	lbu	a0,0(a5)
 98c:	ffc40413          	addi	s0,s0,-4
 990:	e41ff0ef          	jal	ra,7d0 <putc>
 994:	fcdff06f          	j	960 <print_hex+0x28>

00000998 <main>:
 998:	7179                	addi	sp,sp,-48
 99a:	d422                	sw	s0,40(sp)
 99c:	d226                	sw	s1,36(sp)
 99e:	d04a                	sw	s2,32(sp)
 9a0:	cc52                	sw	s4,24(sp)
 9a2:	ca56                	sw	s5,20(sp)
 9a4:	c85a                	sw	s6,16(sp)
 9a6:	c65e                	sw	s7,12(sp)
 9a8:	c462                	sw	s8,8(sp)
 9aa:	d606                	sw	ra,44(sp)
 9ac:	ce4e                	sw	s3,28(sp)
 9ae:	4489                	li	s1,2
 9b0:	4431                	li	s0,12
 9b2:	4901                	li	s2,0
 9b4:	00001a37          	lui	s4,0x1
 9b8:	00001ab7          	lui	s5,0x1
 9bc:	00001b37          	lui	s6,0x1
 9c0:	00001bb7          	lui	s7,0x1
 9c4:	4c51                	li	s8,20
 9c6:	3e800993          	li	s3,1000
 9ca:	3e800513          	li	a0,1000
 9ce:	19fd                	addi	s3,s3,-1
 9d0:	33e5                	jal	7b8 <delay>
 9d2:	fe099ce3          	bnez	s3,9ca <main+0x32>
 9d6:	854a                	mv	a0,s2
 9d8:	029409b3          	mul	s3,s0,s1
 9dc:	3345                	jal	77c <led>
 9de:	8522                	mv	a0,s0
 9e0:	3f91                	jal	934 <print_dec>
 9e2:	a14a0513          	addi	a0,s4,-1516 # a14 <main+0x7c>
 9e6:	37a9                	jal	930 <print_str>
 9e8:	8526                	mv	a0,s1
 9ea:	37a9                	jal	934 <print_dec>
 9ec:	a18a8513          	addi	a0,s5,-1512 # a18 <main+0x80>
 9f0:	3781                	jal	930 <print_str>
 9f2:	854e                	mv	a0,s3
 9f4:	3781                	jal	934 <print_dec>
 9f6:	ad8b0513          	addi	a0,s6,-1320 # ad8 <main+0x140>
 9fa:	3f1d                	jal	930 <print_str>
 9fc:	a1cb8513          	addi	a0,s7,-1508 # a1c <main+0x84>
 a00:	0405                	addi	s0,s0,1
 a02:	0905                	addi	s2,s2,1
 a04:	3735                	jal	930 <print_str>
 a06:	0485                	addi	s1,s1,1
 a08:	fb841fe3          	bne	s0,s8,9c6 <main+0x2e>
 a0c:	4485                	li	s1,1
 a0e:	4401                	li	s0,0
 a10:	bf5d                	j	9c6 <main+0x2e>
 a12:	0000                	unimp
 a14:	2a20                	fld	fs0,80(a2)
 a16:	0020                	addi	s0,sp,8
 a18:	3d20                	fld	fs0,120(a0)
 a1a:	0020                	addi	s0,sp,8
 a1c:	6970                	flw	fa2,84(a0)
 a1e:	76726f63          	bltu	tp,t2,119c <end+0x5b4>
 a22:	000a3233          	sltu	tp,s4,zero
 a26:	0000                	unimp
 a28:	2020                	fld	fs0,64(s0)
 a2a:	2020                	fld	fs0,64(s0)
 a2c:	0000                	unimp
 a2e:	0000                	unimp
 a30:	694d                	lui	s2,0x13
 a32:	74616d73          	csrrsi	s10,0x746,2
 a36:	62206863          	bltu	zero,sp,1066 <end+0x47e>
 a3a:	7465                	lui	s0,0xffff9
 a3c:	6e656577          	0x6e656577
 a40:	7120                	flw	fs0,96(a0)
 a42:	2030                	fld	fa2,64(s0)
 a44:	534c                	lw	a1,36(a4)
 a46:	2042                	fld	ft0,16(sp)
 a48:	6e61                	lui	t3,0x18
 a4a:	2064                	fld	fs1,192(s0)
 a4c:	6564                	flw	fs1,76(a0)
 a4e:	65646f63          	bltu	s0,s6,10ac <end+0x4c4>
 a52:	2064                	fld	fs1,192(s0)
 a54:	6e69                	lui	t3,0x1a
 a56:	75727473          	csrrci	s0,0x757,4
 a5a:	6f697463          	bgeu	s2,s6,1142 <end+0x55a>
 a5e:	206e                	fld	ft0,216(sp)
 a60:	64726f77          	0x64726f77
 a64:	2021                	jal	a6c <main+0xd4>
 a66:	3071                	jal	2f2 <irq_regs+0x192>
 a68:	303d                	jal	296 <irq_regs+0x136>
 a6a:	0078                	addi	a4,sp,12
 a6c:	202c                	fld	fa1,64(s0)
 a6e:	6e69                	lui	t3,0x1a
 a70:	3d727473          	csrrci	s0,0x3d7,4
 a74:	7830                	flw	fa2,112(s0)
 a76:	0000                	unimp
 a78:	5458455b          	0x5458455b
 a7c:	492d                	li	s2,11
 a7e:	5152                	lw	sp,52(sp)
 a80:	342d                	jal	4aa <bcd2bin+0xe>
 a82:	005d                	c.nop	23
 a84:	5458455b          	0x5458455b
 a88:	492d                	li	s2,11
 a8a:	5152                	lw	sp,52(sp)
 a8c:	352d                	jal	8b6 <put_dec+0x1a>
 a8e:	005d                	c.nop	23
 a90:	4d49545b          	0x4d49545b
 a94:	5245                	li	tp,-15
 a96:	492d                	li	s2,11
 a98:	5152                	lw	sp,52(sp)
 a9a:	005d                	c.nop	23
 a9c:	2d2d                	jal	10d6 <end+0x4ee>
 a9e:	2d2d                	jal	10d8 <end+0x4f0>
 aa0:	2d2d                	jal	10da <end+0x4f2>
 aa2:	2d2d                	jal	10dc <end+0x4f4>
 aa4:	2d2d                	jal	10de <end+0x4f6>
 aa6:	2d2d                	jal	10e0 <end+0x4f8>
 aa8:	2d2d                	jal	10e2 <end+0x4fa>
 aaa:	2d2d                	jal	10e4 <end+0x4fc>
 aac:	2d2d                	jal	10e6 <end+0x4fe>
 aae:	2d2d                	jal	10e8 <end+0x500>
 ab0:	2d2d                	jal	10ea <end+0x502>
 ab2:	2d2d                	jal	10ec <end+0x504>
 ab4:	2d2d                	jal	10ee <end+0x506>
 ab6:	2d2d                	jal	10f0 <end+0x508>
 ab8:	2d2d                	jal	10f2 <end+0x50a>
 aba:	2d2d                	jal	10f4 <end+0x50c>
 abc:	2d2d                	jal	10f6 <end+0x50e>
 abe:	2d2d                	jal	10f8 <end+0x510>
 ac0:	2d2d                	jal	10fa <end+0x512>
 ac2:	2d2d                	jal	10fc <end+0x514>
 ac4:	2d2d                	jal	10fe <end+0x516>
 ac6:	2d2d                	jal	1100 <end+0x518>
 ac8:	2d2d                	jal	1102 <end+0x51a>
 aca:	2d2d                	jal	1104 <end+0x51c>
 acc:	2d2d                	jal	1106 <end+0x51e>
 ace:	2d2d                	jal	1108 <end+0x520>
 ad0:	2d2d                	jal	110a <end+0x522>
 ad2:	2d2d                	jal	110c <end+0x524>
 ad4:	2d2d                	jal	110e <end+0x526>
 ad6:	2d2d                	jal	1110 <end+0x528>
 ad8:	000a                	c.slli	zero,0x2
 ada:	0000                	unimp
 adc:	4245                	li	tp,17
 ade:	4552                	lw	a0,20(sp)
 ae0:	4b41                	li	s6,16
 ae2:	6920                	flw	fs0,80(a0)
 ae4:	736e                	flw	ft6,248(sp)
 ae6:	7274                	flw	fa3,100(a2)
 ae8:	6375                	lui	t1,0x1d
 aea:	6974                	flw	fa3,84(a0)
 aec:	61206e6f          	jal	t3,70fe <end+0x6516>
 af0:	2074                	fld	fa3,192(s0)
 af2:	7830                	flw	fa2,112(s0)
 af4:	0000                	unimp
 af6:	0000                	unimp
 af8:	6c49                	lui	s8,0x12
 afa:	656c                	flw	fa1,76(a0)
 afc:	206c6167          	0x206c6167
 b00:	6e49                	lui	t3,0x12
 b02:	75727473          	csrrci	s0,0x757,4
 b06:	6f697463          	bgeu	s2,s6,11ee <end+0x606>
 b0a:	206e                	fld	ft0,216(sp)
 b0c:	7461                	lui	s0,0xffff8
 b0e:	3020                	fld	fs0,96(s0)
 b10:	0078                	addi	a4,sp,12
 b12:	0000                	unimp
 b14:	203a                	fld	ft0,392(sp)
 b16:	7830                	flw	fa2,112(s0)
 b18:	0000                	unimp
 b1a:	0000                	unimp
 b1c:	7542                	flw	fa0,48(sp)
 b1e:	72652073          	csrs	0x726,a0
 b22:	6f72                	flw	ft10,28(sp)
 b24:	2072                	fld	ft0,280(sp)
 b26:	6e69                	lui	t3,0x1a
 b28:	4920                	lw	s0,80(a0)
 b2a:	736e                	flw	ft6,248(sp)
 b2c:	7274                	flw	fa3,100(a2)
 b2e:	6375                	lui	t1,0x1d
 b30:	6974                	flw	fa3,84(a0)
 b32:	61206e6f          	jal	t3,7144 <end+0x655c>
 b36:	2074                	fld	fa3,192(s0)
 b38:	7830                	flw	fa2,112(s0)
 b3a:	0000                	unimp
 b3c:	6370                	flw	fa2,68(a4)
 b3e:	2020                	fld	fs0,64(s0)
 b40:	0000                	unimp
 b42:	0000                	unimp
 b44:	754e                	flw	fa0,240(sp)
 b46:	626d                	lui	tp,0x1b
 b48:	7265                	lui	tp,0xffff9
 b4a:	6f20                	flw	fs0,88(a4)
 b4c:	2066                	fld	ft0,88(sp)
 b4e:	6166                	flw	ft2,88(sp)
 b50:	65207473          	csrrci	s0,0x652,0
 b54:	7478                	flw	fa4,108(s0)
 b56:	7265                	lui	tp,0xffff9
 b58:	616e                	flw	ft2,216(sp)
 b5a:	206c                	fld	fa1,192(s0)
 b5c:	5249                	li	tp,-14
 b5e:	7351                	lui	t1,0xffff4
 b60:	6320                	flw	fs0,64(a4)
 b62:	746e756f          	jal	a0,e82a8 <end+0xe76c0>
 b66:	6465                	lui	s0,0x19
 b68:	203a                	fld	ft0,392(sp)
 b6a:	0000                	unimp
 b6c:	754e                	flw	fa0,240(sp)
 b6e:	626d                	lui	tp,0x1b
 b70:	7265                	lui	tp,0xffff9
 b72:	6f20                	flw	fs0,88(a4)
 b74:	2066                	fld	ft0,88(sp)
 b76:	776f6c73          	csrrsi	s8,0x776,30
 b7a:	6520                	flw	fs0,72(a0)
 b7c:	7478                	flw	fa4,108(s0)
 b7e:	7265                	lui	tp,0xffff9
 b80:	616e                	flw	ft2,216(sp)
 b82:	206c                	fld	fa1,192(s0)
 b84:	5249                	li	tp,-14
 b86:	7351                	lui	t1,0xffff4
 b88:	6320                	flw	fs0,64(a4)
 b8a:	746e756f          	jal	a0,e82d0 <end+0xe76e8>
 b8e:	6465                	lui	s0,0x19
 b90:	203a                	fld	ft0,392(sp)
 b92:	0000                	unimp
 b94:	754e                	flw	fa0,240(sp)
 b96:	626d                	lui	tp,0x1b
 b98:	7265                	lui	tp,0xffff9
 b9a:	6f20                	flw	fs0,88(a4)
 b9c:	2066                	fld	ft0,88(sp)
 b9e:	6974                	flw	fa3,84(a0)
 ba0:	656d                	lui	a0,0x1b
 ba2:	2072                	fld	ft0,280(sp)
 ba4:	5249                	li	tp,-14
 ba6:	7351                	lui	t1,0xffff4
 ba8:	6320                	flw	fs0,64(a4)
 baa:	746e756f          	jal	a0,e82f0 <end+0xe7708>
 bae:	6465                	lui	s0,0x19
 bb0:	203a                	fld	ft0,392(sp)
	...

00000bb4 <timer_irq_count.1008>:
 bb4:	0000 0000                                   ....

00000bb8 <ext_irq_5_count.1007>:
 bb8:	0000 0000                                   ....

00000bbc <ext_irq_4_count.1006>:
 bbc:	0000 0000 4347 3a43 2820 4e47 2955 3820     ....GCC: (GNU) 8
 bcc:	322e 302e 0000 0000 3130 3332 3534 3736     .2.0....01234567
 bdc:	3938 4241 4443 4645 0000 0000               89ABCDEF....
