/* File: startup_ARMCM7.S
 * Purpose: startup file for Cortex-M7 devices. Should use with
 *   GCC for ARM Embedded Processors
 * Version: V2.0
 * Date: 01 August 2014
 *
 * Copyright (c) 2011 - 2014 ARM LIMITED

   All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:
   - Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
   - Neither the name of ARM nor the names of its contributors may be used
     to endorse or promote products derived from this software without
     specific prior written permission.
   *
   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
   ---------------------------------------------------------------------------*/
	.syntax	unified
	.arch	armv7e-m

	.section .stack
	.align	3
#ifdef __STACK_SIZE
	.equ	Stack_Size, __STACK_SIZE
#else
	.equ	Stack_Size, 0x800
#endif
	.globl	__StackTop
	.globl	__StackLimit
__StackLimit:
	.space	Stack_Size
	.size	__StackLimit, . - __StackLimit
__StackTop:
	.size	__StackTop, . - __StackTop

	.section .heap
	.align	3
#ifdef __HEAP_SIZE
	.equ	Heap_Size, __HEAP_SIZE
#else
	.equ	Heap_Size, 0x800
#endif
	.globl	__HeapBase
	.globl	__HeapLimit
__HeapBase:
	.if	Heap_Size
	.space	Heap_Size
	.endif
	.size	__HeapBase, . - __HeapBase
__HeapLimit:
	.size	__HeapLimit, . - __HeapLimit

	.section .isr_vector
	.align	2
	.globl	__isr_vector
__isr_vector:
	.long	__StackTop            /* Top of Stack */
	.long	Reset_Handler         /* Reset Handler */
	.long	NMI_Handler           /* NMI Handler */
	.long	HardFault_Handler     /* Hard Fault Handler */
	.long	MemManage_Handler     /* MPU Fault Handler */
	.long	BusFault_Handler      /* Bus Fault Handler */
	.long	UsageFault_Handler    /* Usage Fault Handler */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	SVC_Handler           /* SVCall Handler */
	.long	DebugMon_Handler      /* Debug Monitor Handler */
	.long	0                     /* Reserved */
	.long	PendSV_Handler        /* PendSV Handler */
	.long	SysTick_Handler       /* SysTick Handler */

	/* External interrupts */
	.long     SUPC_Handler              /*  0 Supply Controller */
	.long     RSTC_Handler              /*  1 Reset Controller */
	.long     RTC_Handler               /*  2 Real Time Clock */
	.long     RTT_Handler               /*  3 Real Time Timer */
	.long     WDT_Handler               /*  4 Watchdog Timer */
	.long     PMC_Handler               /*  5 Power Management Controller */
	.long     EFC_Handler               /*  6 Enhanced Embedded Flash Controller */
	.long     UART0_Handler             /*  7 UART 0 */
	.long     UART1_Handler             /*  8 UART 1 */
	.long     0                         /*  9 Reserved */
	.long     PIOA_Handler              /* 10 Parallel I/O Controller A */
	.long     PIOB_Handler              /* 11 Parallel I/O Controller B */
	.long     PIOC_Handler              /* 12 Parallel I/O Controller C */
	.long     USART0_Handler            /* 13 USART 0 */
	.long     USART1_Handler            /* 14 USART 1 */
	.long     USART2_Handler            /* 15 USART 2 */
	.long     PIOD_Handler              /* 16 Parallel I/O Controller D */
	.long     PIOE_Handler              /* 17 Parallel I/O Controller E */
	.long     HSMCI_Handler             /* 18 Multimedia Card Interface */
	.long     TWIHS0_Handler            /* 19 Two Wire Interface 0 HS */
	.long     TWIHS1_Handler            /* 20 Two Wire Interface 1 HS */
	.long     SPI0_Handler              /* 21 Serial Peripheral Interface 0 */
	.long     SSC_Handler               /* 22 Synchronous Serial Controller */
	.long     TC0_Handler               /* 23 Timer/Counter 0 */
	.long     TC1_Handler               /* 24 Timer/Counter 1 */
	.long     TC2_Handler               /* 25 Timer/Counter 2 */
	.long     TC3_Handler               /* 26 Timer/Counter 3 */
	.long     TC4_Handler               /* 27 Timer/Counter 4 */
	.long     TC5_Handler               /* 28 Timer/Counter 5 */
	.long     AFEC0_Handler             /* 29 Analog Front End 0 */
	.long     DACC_Handler              /* 30 Digital To Analog Converter */
	.long     PWM0_Handler              /* 31 Pulse Width Modulation 0 */
	.long     ICM_Handler               /* 32 Integrity Check Monitor */
	.long     ACC_Handler               /* 33 Analog Comparator */
	.long     USBHS_Handler             /* 34 USB Host / Device Controller */
	.long     MCAN0_Handler             /* 35 MCAN Controller 0 */
	.long     0                         /* 36 Reserved */
	.long     MCAN1_Handler             /* 37 MCAN Controller 1 */
	.long     0                         /* 38 Reserved */
	.long     GMAC_Handler              /* 39 Ethernet MAC */
	.long     AFEC1_Handler             /* 40 Analog Front End 1 */
	.long     TWIHS2_Handler            /* 41 Two Wire Interface 2 HS */
	.long     SPI1_Handler              /* 42 Serial Peripheral Interface 1 */
	.long     QSPI_Handler              /* 43 Quad I/O Serial Peripheral Interface */
	.long     UART2_Handler             /* 44 UART 2 */
	.long     UART3_Handler             /* 45 UART 3 */
	.long     UART4_Handler             /* 46 UART 4 */
	.long     TC6_Handler               /* 47 Timer/Counter 6 */
	.long     TC7_Handler               /* 48 Timer/Counter 7 */
	.long     TC8_Handler               /* 49 Timer/Counter 8 */
	.long     TC9_Handler               /* 50 Timer/Counter 9 */
	.long     TC10_Handler              /* 51 Timer/Counter 10 */
	.long     TC11_Handler              /* 52 Timer/Counter 11 */
	.long     0                         /* 53 Reserved */
	.long     0                         /* 54 Reserved */
	.long     0                         /* 55 Reserved */
	.long     AES_Handler               /* 56 AES */
	.long     TRNG_Handler              /* 57 True Random Generator */
	.long     XDMAC_Handler             /* 58 DMA */
	.long     ISI_Handler               /* 59 Camera Interface */
	.long     PWM1_Handler              /* 60 Pulse Width Modulation 1 */
	.long     0                         /* 61 Reserved */
	.long     SDRAMC_Handler            /* 62 SDRAM Controller */
	.long     RSWDT_Handler             /* 63 Reinforced Secure Watchdog Timer */

	.size	__isr_vector, . - __isr_vector

	.text
	.thumb
	.thumb_func
	.align	2
	.globl	Reset_Handler
	.type	Reset_Handler, %function
Reset_Handler:
/*  Firstly it copies data from read only memory to RAM. There are two schemes
 *  to copy. One can copy more than one sections. Another can only copy
 *  one section.  The former scheme needs more instructions and read-only
 *  data to implement than the latter.
 *  Macro __STARTUP_COPY_MULTIPLE is used to choose between two schemes.  */

#ifdef __STARTUP_COPY_MULTIPLE
/*  Multiple sections scheme.
 *
 *  Between symbol address __copy_table_start__ and __copy_table_end__,
 *  there are array of triplets, each of which specify:
 *    offset 0: LMA of start of a section to copy from
 *    offset 4: VMA of start of a section to copy to
 *    offset 8: size of the section to copy. Must be multiply of 4
 *
 *  All addresses must be aligned to 4 bytes boundary.
 */
	ldr	r4, =__copy_table_start__
	ldr	r5, =__copy_table_end__

.L_loop0:
	cmp	r4, r5
	bge	.L_loop0_done
	ldr	r1, [r4]
	ldr	r2, [r4, #4]
	ldr	r3, [r4, #8]

.L_loop0_0:
	subs	r3, #4
	ittt	ge
	ldrge	r0, [r1, r3]
	strge	r0, [r2, r3]
	bge	.L_loop0_0

	adds	r4, #12
	b	.L_loop0

.L_loop0_done:
#else
/*  Single section scheme.
 *
 *  The ranges of copy from/to are specified by following symbols
 *    __etext: LMA of start of the section to copy from. Usually end of text
 *    __data_start__: VMA of start of the section to copy to
 *    __data_end__: VMA of end of the section to copy to
 *
 *  All addresses must be aligned to 4 bytes boundary.
 */
	ldr	r1, =__etext
	ldr	r2, =__data_start__
	ldr	r3, =__data_end__

.L_loop1:
	cmp	r2, r3
	ittt	lt
	ldrlt	r0, [r1], #4
	strlt	r0, [r2], #4
	blt	.L_loop1
#endif /*__STARTUP_COPY_MULTIPLE */

/*  This part of work usually is done in C library startup code. Otherwise,
 *  define this macro to enable it in this startup.
 *
 *  There are two schemes too. One can clear multiple BSS sections. Another
 *  can only clear one section. The former is more size expensive than the
 *  latter.
 *
 *  Define macro __STARTUP_CLEAR_BSS_MULTIPLE to choose the former.
 *  Otherwise efine macro __STARTUP_CLEAR_BSS to choose the later.
 */
#ifdef __STARTUP_CLEAR_BSS_MULTIPLE
/*  Multiple sections scheme.
 *
 *  Between symbol address __copy_table_start__ and __copy_table_end__,
 *  there are array of tuples specifying:
 *    offset 0: Start of a BSS section
 *    offset 4: Size of this BSS section. Must be multiply of 4
 */
	ldr	r3, =__zero_table_start__
	ldr	r4, =__zero_table_end__

.L_loop2:
	cmp	r3, r4
	bge	.L_loop2_done
	ldr	r1, [r3]
	ldr	r2, [r3, #4]
	movs	r0, 0

.L_loop2_0:
	subs	r2, #4
	itt	ge
	strge	r0, [r1, r2]
	bge	.L_loop2_0

	adds	r3, #8
	b	.L_loop2
.L_loop2_done:
#elif defined (__STARTUP_CLEAR_BSS)
/*  Single BSS section scheme.
 *
 *  The BSS section is specified by following symbols
 *    __bss_start__: start of the BSS section.
 *    __bss_end__: end of the BSS section.
 *
 *  Both addresses must be aligned to 4 bytes boundary.
 */
	ldr	r1, =__bss_start__
	ldr	r2, =__bss_end__

	movs	r0, 0
.L_loop3:
	cmp	r1, r2
	itt	lt
	strlt	r0, [r1], #4
	blt	.L_loop3
#endif /* __STARTUP_CLEAR_BSS_MULTIPLE || __STARTUP_CLEAR_BSS */

#ifndef __NO_SYSTEM_INIT
	bl	SystemInit
#endif

#ifndef __START
#define __START _start
#endif
	bl	__START

	.pool
	.size	Reset_Handler, . - Reset_Handler

	.align	1
	.thumb_func
	.weak	Default_Handler
	.type	Default_Handler, %function
Default_Handler:
	b	.
	.size	Default_Handler, . - Default_Handler

/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
	.macro	def_irq_handler	handler_name
	.weak	\handler_name
	.set	\handler_name, Default_Handler
	.endm

	def_irq_handler	NMI_Handler
	def_irq_handler	HardFault_Handler
	def_irq_handler	MemManage_Handler
	def_irq_handler	BusFault_Handler
	def_irq_handler	UsageFault_Handler
	def_irq_handler	SVC_Handler
	def_irq_handler	DebugMon_Handler
	def_irq_handler	PendSV_Handler
	def_irq_handler	SysTick_Handler
	def_irq_handler	DEF_IRQHandler

	def_irq_handler SUPC_Handler
	def_irq_handler RSTC_Handler
	def_irq_handler RTC_Handler
	def_irq_handler RTT_Handler
	def_irq_handler WDT_Handler
	def_irq_handler PMC_Handler
	def_irq_handler EFC_Handler
	def_irq_handler UART0_Handler
	def_irq_handler UART1_Handler
	def_irq_handler PIOA_Handler
	def_irq_handler PIOB_Handler
	def_irq_handler PIOC_Handler
	def_irq_handler USART0_Handler
	def_irq_handler USART1_Handler
	def_irq_handler USART2_Handler
	def_irq_handler PIOD_Handler
	def_irq_handler PIOE_Handler
	def_irq_handler HSMCI_Handler
	def_irq_handler TWIHS0_Handler
	def_irq_handler TWIHS1_Handler
	def_irq_handler SPI0_Handler
	def_irq_handler SSC_Handler
	def_irq_handler TC0_Handler
	def_irq_handler TC1_Handler
	def_irq_handler TC2_Handler
	def_irq_handler TC3_Handler
	def_irq_handler TC4_Handler
	def_irq_handler TC5_Handler
	def_irq_handler AFEC0_Handler
	def_irq_handler DACC_Handler
	def_irq_handler PWM0_Handler
	def_irq_handler ICM_Handler
	def_irq_handler ACC_Handler
	def_irq_handler USBHS_Handler
	def_irq_handler MCAN0_Handler
	def_irq_handler MCAN1_Handler
	def_irq_handler GMAC_Handler
	def_irq_handler AFEC1_Handler
	def_irq_handler TWIHS2_Handler
	def_irq_handler SPI1_Handler
	def_irq_handler QSPI_Handler
	def_irq_handler UART2_Handler
	def_irq_handler UART3_Handler
	def_irq_handler UART4_Handler
	def_irq_handler TC6_Handler
	def_irq_handler TC7_Handler
	def_irq_handler TC8_Handler
	def_irq_handler TC9_Handler
	def_irq_handler TC10_Handler
	def_irq_handler TC11_Handler
	def_irq_handler AES_Handler
	def_irq_handler TRNG_Handler
	def_irq_handler XDMAC_Handler
	def_irq_handler ISI_Handler
	def_irq_handler PWM1_Handler
	def_irq_handler SDRAMC_Handler
	def_irq_handler RSWDT_Handler

	.end
