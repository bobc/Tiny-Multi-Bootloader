 	.syntax unified
 	.cpu cortex-m0
 	.align	2
 	.thumb
 	.thumb_func

	.section .isr_vector		@Vector table definition

	.long	0x10000400		@ 0000:StackTop
	.long	1+IntrareBootloader	@ 0004:Reset_Handler
	.long	1+IntrareBootloader	@ 0008:NMI_Handler
	.long	1+IntrareBootloader	@ 000C:HardFault_Handler
	.long	0			@ 0010:Reserved
	.long	0			@ 0014:Reserved
	.long	0			@ 0018:Reserved
	.long	0			@ 001C:Reserved
	.long	0			@ 0020:Reserved
	.long	0			@ 0024:Reserved
	.long	0			@ 0028:Reserved
	.long	1+IntrareBootloader	@ 002C:SVC_Handler
	.long	0			@ 0030:Reserved
	.long	0			@ 0034:Reserved
	.long	1+IntrareBootloader	@ 0038:PendSV_Handler
	.long	1+IntrareBootloader	@ 003C:SysTick_Handler
	.long	1+IntrareBootloader	@ 0040:SPI0_IRQHandler
	.long	1+IntrareBootloader	@ 0044:SPI1_IRQHandler
	.long	0			@ 0048:Reserved
    	.long	1+IntrareBootloader	@ 004C:UART0_IRQHandler
    	.long	1+IntrareBootloader	@ 0050:UART1_IRQHandler
    	.long	1+IntrareBootloader	@ 0054:UART2_IRQHandler
	.long	0			@ 0058:Reserved
	.long	0			@ 005C:Reserved
       	.long	1+IntrareBootloader	@ 0060:I2C_IRQHandler
       	.long	1+IntrareBootloader	@ 0064:SCT_IRQHandler
       	.long	1+IntrareBootloader	@ 0068:MRT_IRQHandler
       	.long	1+IntrareBootloader	@ 006C:CMP_IRQHandler
       	.long	1+IntrareBootloader	@ 0070:WDT_IRQHandler
       	.long	1+IntrareBootloader	@ 0074:BOD_IRQHandler
	.long	0			@ 0078:Reserved
       	.long	1+IntrareBootloader	@ 007C:WKT_IRQHandler
	.long	0			@ 0080:Reserved
	.long	0			@ 0084:Reserved
	.long	0			@ 0088:Reserved
	.long	0			@ 008C:Reserved
	.long	0			@ 0090:Reserved
	.long	0			@ 0094:Reserved
	.long	0			@ 0098:Reserved
	.long	0			@ 009C:Reserved
       	.long	1+IntrareBootloader	@ 00A0:PININT0_IRQHandler
       	.long	1+IntrareBootloader	@ 00A4:PININT1_IRQHandler
       	.long	1+IntrareBootloader	@ 00A8:PININT2_IRQHandler
       	.long	1+IntrareBootloader	@ 00AC:PININT3_IRQHandler
       	.long	1+IntrareBootloader	@ 00B0:PININT4_IRQHandler
       	.long	1+IntrareBootloader	@ 00B4:PININT5_IRQHandler
       	.long	1+IntrareBootloader	@ 00B8:PININT6_IRQHandler
       	.long	1+IntrareBootloader	@ 00BC:PININT7_IRQHandler

.text

	@ change these lines accordingly to your application
.equ	IdTypeLPC	,0x31	    @ must exists in "piccodes.ini"
.equ	FamilyLPC	,0x33	    @ LPC Family "3"

.equ	max_flash	,0x1000	    @ in bytes, not WORDS!!!
.equ	bufsize		,64         @ data buffer size
.equ	N		,6          @ bufsize = 2^N

.equ	xtal		,12000000   @ you may also want to change
.equ	baud		,19200      @ standard TinyBld baud rates: 115200 or 19200

.equ	TXBIT      	,1	    @ LPC TX Data output pin (i.e. 2 = PIN0_2)
.equ	RXBIT		,0	    @ LPC RX Data input pin (i.e. 3 = PIN0_3)

@   The above 9 lines can be changed and buid a bootloader for the desired frequency (and PIC type)


    	@********************************************************************
    	@       Tiny Bootloader         LPC810         Size=256bytes
	@
	@	This program is only available in Tiny PIC/AVR Bootloader +.
	@	(2014.03.31 Revision 1)
	@
	@	Tiny PIC/AVR Bootloader +
	@	https://sourceforge.net/projects/tinypicbootload/
	@
	@
	@	Please add the following line to piccodes.ini
	@
	@	$31, 3, LPC 810,   $1000,   0,     264, 64,
	@
	@********************************************************************


@       0x1000000              0x1000000+bufsize                                   0x1000000+bufsize+4*4
@       +----------------------+------------+------------+------------+------------+------------+
@       | Data buffer[bufsize] | IAP command| IAP Param0 | IAP Param1 | IAP Param2 | IAP Param3 |
@       +----------------------+------------+------------+------------+------------+------------+
@                              | IAP Result |            |            |            |            |
@                              +------------+------------+------------+------------+------------+


.equ	first_address	,max_flash-64*(4+3)-8

.equ 	cUARTCLKDIV	,1

.equ 	RXRDY		,0		@STAT
.equ 	TXRDY		,2

.equ 	GPIO		,6		@SYSAHBCLKCTRL
.equ 	SWM		,7
.equ 	UART0		,14
.equ 	IOCON		,18

.equ 	ENABLE		,0		@CFG

.equ	UARTCLKDIV	,0x40048094
.equ	SYSAHBCLKCTRL	,0x40048080
.equ	vSYSAHBCLKCTRL	,(0x0000001F | (1<<UART0) | (1<<GPIO) | (1<<SWM) | (1<<IOCON))
.equ	BRG		,0x40064020
.equ	CFG		,0x40064000
.equ	PINASSIGN0	,0x4000C000
.equ	STAT		,0x40064008
.equ	RXDAT		,0x40064014
.equ	TXDAT		,0x4006401C

.equ	IAP		,0x1FFF1FF1


@&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
@----------------------  Bootloader  ----------------------
@
@PC_flash:      C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
@PC_response:   id   K                                                 K
@
	.org     first_address
UserVector:
	.long	IntrareBootloader+1
	.long	0xFFFFFFFF

	.org     first_address+8
IntrareBootloader:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@	r0:
@	r1:SYSAHBCLKCTRL
@	r2:SYSAHBCLKCTRL initial value
@	r3:PINASSIGN0
@	r4:
@	r5:
@	r6:
@	r7:CFG
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
						@ init int clock & serial port
	movs	r0,#cUARTCLKDIV			@UARTCLKDIV = cUARTCLKDIV
	ldr	r1,=#SYSAHBCLKCTRL		@r1 = SYSAHBCLKCTRL
	str	r0,[r1,#(UARTCLKDIV-SYSAHBCLKCTRL)]

	ldr	r0,=#vSYSAHBCLKCTRL		@SYSAHBCLKCTRL = vSYSAHBCLKCTRL
	ldr	r2,[r1,#0]
	str	r0,[r1,#0]

	movs	r0,#(xtal/cUARTCLKDIV/16/baud-1) @BRG
	ldr	r7,=#CFG			@r7 = CFG
	str	r0,[r7,#(BRG-CFG)]

	movs	r0,#(0x04+(1<<ENABLE))		@CFG = 0x04 + (1<<ENABLE)
	str	r0,[r7,#0]

	movs	r4,#RXBIT			@PINASSIGN0[15:0] = 256*RXBIT + TXBIT
	lsls	r0,r4,#8
	adds	r0,r0,#TXBIT
	ldr	r3,=#PINASSIGN0			@r3 = PINASSIGN0
	strh	r0,[r3,#0]

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@	r0:
@	r1:cnt
@	r2:rxd
@	r3:Destination flash address
@	r4:buffer top
@	r5:crc
@	r6:Receive
@	r7:CFG
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	push	{r1-r3}
	ldr	r6,=#Receive+1			@ r6 = Receive

						@ wait for computer
	blx	r6				@ get 0xC1
	cmp	r2,#0xC1        		@ Expect C1
	bne    	way_to_exit			@ connection errer or timeout
	movs   	r2,#IdTypeLPC			@ send IdTypeLPC
        str	r2,[r7,#(TXDAT-CFG)]

	movs	r2,#(1<<TXRDY)			@ r2 = (1<<TXRDY)
lp:
	ldr	r0,[r7,#(STAT-CFG)]		@ check TX Status
	tst	r0,r2
	beq	lp

MainLoop:
	movs	r2,#FamilyLPC			@ send FamilyLPC
mainl:
	str	r2,[r7,#(TXDAT-CFG)]		@ send 1 byte
        movs    r5,#0		        	@ clear Checksum
        blx	r6				@ get Address(H)
	lsls	r3,r2,#8			@ r3 = Address(H) * 256
        blx	r6	         		@ get Address(L)
        adds	r3,r3,r2			@ r3 = Destination flash address
        blx	r6	         		@ get count
	lsls	r4,r2,#(28-N)			@ r4 = buffer_top = 0x10000000

rcvoct:
	blx	r6	         		@ get Data
        strb    r2,[r4,#0]			@ store buffer
        adds    r4,r4,#1			@ pointer += 1
        lsls	r2,r4,#(32-N)			@ r4 = buffer_top + bufsize ?
        bne     rcvoct				@ loop

ziieroare:
	blx     r6				@ get Checksum
	movs	r2,#'N				@ set Error code
	lsls	r5,r5,#24
	bne	mainl				@ Checksum error

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@	r0:IAP commnd address
@	r1:IAP result address
@	r2:
@	r3:Destination flash address
@	r4:Source RAM address
@	r5:IAP Entry address
@	r6:Receive
@	r7:CFG
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

erase_flash:
	bl	pswo	           		@ erase Flash Page
	str	r2,[r0,#12]			@   Command Param2: SystemClock(kHz)
	lsrs	r2,r3,#6			@   r2 = flash page number
	str	r2,[r0,#8]			@   Command Param1: End page number
	str	r2,[r0,#4]			@   Command Param0: Start page number
	movs	r2,#59				@   Command code: 59
	str	r2,[r0,#0]
	blx	r5

write_flash:
	bl	pswo				@ write Flash Page
	str	r2,[r0,#16]			@   Command Param3: SystemClock(kHz)
	movs	r2,#bufsize			@   r2 = bufsize
	str	r2,[r0,#12]			@   Command Param2: Number of bytes to be written
	subs	r4,r4,r2			@   r4 = Source RAM address
	str	r4,[r0,#8]			@   Command Param1: Source RAM address
	str	r3,[r0,#4]			@   Command Param0: Destination flash address
	movs	r2,#51				@   Command code: 51
	str	r2,[r0,#0]
	blx	r5

        b	MainLoop			@ loop

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@	Prepare sector(s) for write operation
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

pswo:
	movs	r0,r4				@ r0 = IAP command address
	movs	r1,r4				@ r1 = IAP result address
	ldr	r5,=#IAP			@ r5 = IAP Entry address

	push	{r0,r1,lr}
	lsrs	r2,r3,#10			@   r2 = flash sector number
	str	r2,[r0,#8]			@   Command Param1: End sector number
	str	r2,[r0,#4]			@   Command Param0: Start sector number
	movs	r2,#50				@   Command code: 50
	str	r2,[r0,#0]
	blx	r5
	ldr	r2,=#(xtal/1000)		@   r2 = SystemClock(kHz)
	pop	{r0,r1,pc}

@ ********************************************************************
@
@		RS-232C Recieve 1byte with Timeout and Check Sum
@
@ ********************************************************************

Receive:
	movs    r1,#(xtal/500000+1)  		@ for 20MHz => 11 => 1second
        lsls	r1,r1,#16

	movs	r2,#(1<<RXRDY)			@ r2 = (1<<RXRDY)
rptc:
	ldr	r0,[r7,#(STAT-CFG)]		@ check RX Status
	tst	r0,r2
	beq	nodata

	ldr	r2,[r7,#(RXDAT-CFG)]		@ r2 = Recieve_Data
	adds	r5,r5,r2			@ r5 = crc
	bx	lr

nodata:
        subs	r1,#1
        bne	rptc

way_to_exit:
	pop	{r1-r3}
	movs	r0,#0					@ USART Disable
	mvns	r4,r0					@ r4 = 0xFFFFFFFF
	str	r4,[r3,#0]				@ set PINASSIGN0
	str	r0,[r7,#0]				@ set CFG
	str	r0,[r7,#(BRG-CFG)]			@ set BRG
	str	r2,[r1,#0]				@ set SYSAHBCLKCTRL
	str	r0,[r1,#(UARTCLKDIV-SYSAHBCLKCTRL)]	@ set UARTCLKDIV

	ldr	r1,=#UserVector				@ timeout:exit in all other cases
	ldr	r0,[r1,#0]				@ r0 = [UserVector]
	blx	r0					@ goto User Program


@ ********************************************************************
@ After reset
@ Do not expect the memory to be zero,
@ Do not expect registers to be initialised like in catalog.

        .end

