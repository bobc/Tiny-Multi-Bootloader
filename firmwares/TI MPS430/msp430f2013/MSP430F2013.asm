	; change these lines accordingly to your application
		.cdecls C,LIST,"msp430.h"
IdTypeMSP430	.equ	0x42		; must exists in "piccodes.ini"
FamilyMSP430	.equ	0x34		; LPC Family "4"

max_flash	.equ	0x800		; in bytes, not WORDS!!!

xtal		.equ	1000000		; you may also want to change
baud		.equ	9600		; standard TinyBld baud rates: 115200 or 19200

TX		.equ	4		; MSP430 TX Data output pin (i.e. 2 = P1.2)
RX		.equ	5		; MSP430 RX Data input  pin (i.e. 3 = P1.3)
;Direct_TX	.equ	0               ; RS-232C TX Direct Connection(No use MAX232)
;Direct_RX	.equ	0               ; RS-232C RX Direct Connection(No use MAX232)

;   The above 10 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

_bwait2		.equ	R4
_SendL		.equ	R5
_Receive	.equ	R6
_wr		.equ	R7
_TX		.equ	R8
_RX		.equ	R9
count		.equ	R10
Address		.equ	R11
crc		.equ	R12
cnt1		.equ	R13
cnt2		.equ	R14
cn		.equ	cnt1
rs		.equ	cnt2
rxd		.equ	R15

    	;********************************************************************
    	;       Tiny Bootloader             MSP430F2XX      Size=136+192bytes
	;
	;	(2013.08.02 Revision 1)
	;	This program is only available in Tiny PIC/AVR Bootloader +.
	;
	;	Tiny PIC/AVR Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;
	;	Please add the following line to piccodes.ini
	;
	;	$41, 4, MSP430 F2001,   $400,   0,     136, 64,
	;	$42, 4, MSP430 F2011,   $800,   0,     136, 64,
	;	$41, 4, MSP430 F2002,   $400,   0,     136, 64,
	;	$42, 4, MSP430 F2012,   $800,   0,     136, 64,
	;	$41, 4, MSP430 F2003,   $400,   0,     136, 64,
	;	$42, 4, MSP430 F2013,   $800,   0,     136, 64,
	;
	;********************************************************************

first_address	.equ	max_flash - 136 	; 68 word in size
STACK		.equ	0x0280 			; Stack start address
BUFTOP		.equ	0x0200			; Buffer
BUFEND		.equ	0x0260
BLDTOP		.equ	0x10000 - 136 + 8	; Bootloader
BLDEND		.equ	0xFFE0

;------------------------------------------------------------------------------
             .sect   ".text2"
;------------------------------------------------------------------------------

IntrareBootloader2:
		MOV.W 	#bwait2,_bwait2			; _bwait2
		MOV.W 	#SendL,_SendL			; _SendL
		MOV.W 	#Receive,_Receive		; _Receive
		MOV.W 	#wr,_wr				; _wr
		MOV.B	#(1<<TX),_TX			; _TX
		MOV.B	#(1<<RX),_RX			; _RX
		MOV.W   #STACK,SP               	; Initialize stackpointer
		MOV.W   #WDTPW+WDTHOLD,&WDTCTL  	; Stop WDT
		MOV.B 	&CALBC1_1MHZ,&BCSCTL1 		; Clock Calibration
		MOV.B 	&CALDCO_1MHZ,&DCOCTL 		; 1MHz
		MOV.W	#FWKEY+FSSEL1+FN0,&FCTL2	; Flash Clock = SMCLK/2
		MOV.W 	#FWKEY,&FCTL3 			; Flash UNLOCK
		BIS.B   _TX,&P1DIR			; set TX Port

		CALL	_Receive			; wait for computer
                SUB.B	#0xC1,rxd			; Expect C1
		JEQ	copy_to_RAM_48W			; Receive C1
		MOV.W	#User_Vector,PC			; connection errer or timeout

copy_to_RAM_48W:					; copy Flash to RAM 48 words
		MOV.W	#BLDTOP,R15			; R15 = #BLDTOP
		MOV.W	R15,Address			; Address = #BLDTOP
$1		MOV.W	@R15+,BUFTOP-BLDTOP-2(R15)	; [0xFF80,0xFFDF] --> [0x0200,0x025F]
		CMP.W	#BLDEND,R15			; 
		JNE	$1				; loop
erase_All_Segments:					; erase All Segments
		MOV.W 	#FWKEY+MERAS,&FCTL1 		; enable erase
		CLR.B 	0(R15)				; dummy write
back_to_Flash_48W:					; back to Flash 48 words
		MOV.W	#BUFTOP,R14			; R14 = #BUFTOP
$2		MOV.B 	@R14+,rxd			; [0x0200,0x025F] --> [0xFF80,0xFFDF]
		CALL	_wr				; write Data
		INC.W	Address				; Address = Address + 1
		CMP.W	#BUFEND,R14			; 
		JNE	$2				; loop
write_Reset_Vector:					; write Reset Vector
		MOV.W	#0xFFFE,Address			; (0xFFFE)=0xFF80
		MOV.B	#(IntrareBootloader & 0xFF),rxd	;
		CALL	_wr				; write Data

		MOV.B	#IdTypeMSP430,rxd		; send IdType
        	CALL	_SendL
MainLoop:
		MOV.B	#FamilyMSP430,rxd		; send Family ID
mainl:
        	CALL	_SendL				;
		CLR.B	crc				; clear Checksum
		CALL	_Receive			; Address_H
		MOV.W	rxd,Address			; set Address(H)
		CALL	_Receive			; Address_L
		SWPB	Address				; set Address(H:L)
		ADD.W	rxd,Address			;
		CALL	_Receive			; count
		MOV.B	rxd,count			; set count
write_Data:
		CALL	_Receive			; get Data
		CALL	_wr				; write Data
		INC.W	Address				; Address = Address + 1
		DEC.B	count				; count = 0 ?
		JNE	write_Data			; loop

		CALL	_Receive			; crc
ziieroare:
		MOV.B	#'N',rxd			; send "N"
                JNE	mainl				; retry
		JMP	MainLoop			; loop

wr:
		MOV.W 	#FWKEY+WRT,&FCTL1 		; enable Word/Byte Write
		MOV.B 	rxd,0(Address)			; write
		MOV.W	#FWKEY,&FCTL1			; clear WRT
		RET

;------------------------------------------------------------------------------
             .text
;------------------------------------------------------------------------------

		.space	first_address
User_Vector:
		NOP
		NOP
		NOP
		NOP

IntrareBootloader:
		MOV.W	#IntrareBootloader2,PC	;goto bootloader

SendL:
        	MOV.B   #(1+8+1)*2,cn		; 10-bit Data
	    .if $defined(Direct_TX)
		BIC.B	_TX,&P1OUT		; rs must be 0
		JMP	$11			; Start bit
	    .else
		BIS.B	_TX,&P1OUT		; rs must be 0
		JMP	$12			; Start bit
	    .endif
$10        	RRC.B   rxd			; Rotate Right through Carry	[1]
	    .if $defined(Direct_TX)
        	JC	$12			;
	    .else
        	JNC	$12			;				[2]
	    .endif
$11		INV.B	rs			; rs = 0b11111111		[1]
$12	       	MOV.B   rs,&P1OUT		; set TX='1' if Carry='1'	[2]
        	CALL	_bwait2			; wait 1/2 bit			[4+3N+7]
        	CALL	_bwait2			; wait 1/2 bit			[4+3N+7]
        	JNE     $10			; Carry='1' loop		[2]
bwait2:
		MOV.B	#(xtal/baud-31)/6,rs	;[2]
$20        	DEC.B	rs			;[1]
        	JNE	$20			;[2]
		DEC.B   cn			;[1]
		RET				;[4] 3N+7

Receive:
		MOV.W	#xtal/500000+2,cnt1
rpt2:
;		CLR.W	cnt2
rptc:						; check Start bit
                BIT.B	_RX,&P1IN
	    .if $defined(Direct_RX)
                JEQ	nodata
	    .else
                JNE	nodata
	    .endif
		CALL	_bwait2			; wait 1/2 bit
        	MOV.B   #(8+1)*2,cn		; 9-bit Data
$30             BIT.B	_RX,&P1IN		; get Bit Data
		RRC.B	rxd			; set Bit Data
		CALL	_bwait2			; wait 1/2 bit
		CALL	_bwait2			; wait 1/2 bit
		JNE	$30			; loop
	    .if $defined(Direct_RX)
                INV.B	rxd
	    .else
                MOV.B	rxd,rxd
	    .endif
                ADD.B	rxd,crc			; compute checksum
                RET
nodata:
                DEC.W	cnt2
                JNE	rptc
                DEC.W	cnt1
                JNE	rpt2
way_to_exit:
		MOV.W	#FWKEY+LOCK,&FCTL3	; Flash LOCK
                JMP	User_Vector		; timeout:exit in all other cases

;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  IntrareBootloader       ;
            .end
