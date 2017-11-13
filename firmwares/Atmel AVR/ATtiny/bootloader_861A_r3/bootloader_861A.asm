
	; change these lines accordingly to your application	
.include "tn861adef.inc"
.equ	FamilyAVR=0x31		; AVR Family ("1":ATtiny, "2":ATmega)
.equ	IdTypeAVR=0x16		; must exists in "piccodes.ini"	
#define	max_flash 0x1000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)
        
.equ	xtal	=	8000000 ; you may also want to change: _HS_OSC _XT_OSC
.equ	baud    =	9600    ; standard TinyBld baud rates: 115200 or 19200

.equ	Calib   =	0x8D    ; 8MHz Calibration value

        #define EEPSZ   512	        ; EEPROM Size(128/256/512)
        #define TXP     2	        ; PIC TX Data port (1:A,2:B), Please refer to the table below
        #define TX	2		; ATTINY13A RX Data input pin (i.e. 3 = TXP,3)
        #define RXP     2	        ; PIC RX Data port (1:A,2:B), Please refer to the table below
        #define RX      1               ; ATTINY13A RX Data input pin (i.e. 3 = RXP,3)
;        #define Direct_TX               ; RS-232C TX Direct Connection(No use MAX232)
;        #define Direct_RX               ; RS-232C RX Direct Connection(No use MAX232)

;   The above 14 lines can be changed and buid a bootloader for the desired frequency

; +---------+---------+--------+------------+------------+-----------+------+--------+------+
; |AVRFamily|IdTypePIC| Device | Erase_Page | Write_Page | max_flash | PORT | EEPROM | PDIP |
; +---------+---------+--------+------------+------------+-----------+------+--------+------+
; |   0x31  |   0x14  | TN261A |  16 words  |  16 words  |  0x0400   | A B  |  128   |  20  |
; |   0x31  |   0x15  | TN461A |  32 words  |  32 words  |  0x0800   | A B  |  256   |  20  |
; |   0x31  |   0x16  | TN861A |  32 words  |  32 words  |  0x1000   | A B  |  512   |  20  |
; +---------+---------+--------+------------+------------+-----------+------+--------+------+

 #if (TXP==1)
	#define TXPORT     PORTA
	#define TXDDR      DDRA
 #endif
 #if (TXP==2)
	#define TXPORT     PORTB
	#define TXDDR      DDRB
 #endif
 #if (RXP==1)
	#define RXPORT     PINA
 #endif
 #if (RXP==2)
	#define RXPORT     PINB
 #endif

    	;********************************************************************
    	;       Tiny Bootloader         ATTINY261A/461A/861A    Size=100words
	;
	;	(2014.08.11 Revision 3)
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	!!!!! Set Fuse Bit SELFPRGEN=0,CKDIV8=1 and 8MHz Calibration value !!!!!
	;
	;	Please add the following line to piccodes.ini
	;
	;	$14, 1, ATTINY 24A/25/261A, 		$800, 128, 200, 32,
	;	$15, 1, ATTINY 44A/45/461A, 		$1000, 256, 200, 64,
	;	$16, 1, ATTINY 84A/85/861A, 		$2000, 512, 200, 64,
	;
	;********************************************************************



        #define first_address max_flash-100 ; 100 word in size

#define 	crc	r19
#define 	cnt1	r20
#define 	flag	r21
#define 	count	r22
#define 	rs	r23
#define 	cn	r24
#define 	rxd	r25

.cseg
;0000000000000000000000000 RESET 00000000000000000000000000

                .org    0x0000		;;Reset vector
;		RJMP	IntrareBootloader
		.dw	0xcf9f		;RJMP	PC-0x60

;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;               
                ;PC_flash:      C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
                ;PIC_response:  id   K                                                 K

                .org     first_address
;               nop
;               nop
;               nop
;               nop

                .org     first_address+4
IntrareBootloader:
		SBI	TXDDR,TX	; set TX Port
		LDI	rxd,Calib	; set 8MHz Calibration value
		OUT	OSCCAL,rxd

		RCALL	Receive		; wait for computer
                SUBI	rxd,0xC1	; Expect C1
                BREQ	PC+2		; skip if C1
                RJMP	way_to_exit	; connection errer or timeout
                LDI	rxd,IdTypeAVR	; send IdType
        	RCALL	SendL
MainLoop:
		LDI	rxd,FamilyAVR	; send ATtiny Family ID
mainl:
		RCALL	SendL
		CLR	crc		; clear Checksum
                RCALL	Receive		; get ADR_H
		MOV	r31,rxd		; set r31
		MOV	flag,rxd	; set flag
 #if (EEPSZ == 512)
		OUT	EEARH,rxd	; set EEARH
 #else
		NOP
 #endif
                RCALL	Receive		; get ADR_L
		MOV	r30,rxd		; set r30
		OUT	EEARL,rxd	; set EEARL
		LSL	r30		; set PCPAGE:PCWORD
		ROL	r31
		SBIW 	r30,2 		; PCPAGE:PCWORD=PCPAGE:PCWORD-2
                RCALL	Receive		; get count
		MOV	count,rxd	; set count
rcvoct:
	        RCALL	Receive		; get Data(L)
		MOV	r0,rxd		; set Data(L)
		OUT	EEDR,rxd	; set EEDR
                RCALL	Receive		; get Data(H)
		MOV	r1,rxd		; set Data(H)
		ADIW	r30,2		; PCPAGE:PCWORD=PCPAGE:PCWORD+2
		LDI	rxd,0x01	; write buffer
		RCALL	ctrl_flash

		SUBI	count,2		; count=count-2
                BRNE	rcvoct		; loop

                RCALL	Receive		; get Checksum
		BRNE	ziieroare	; Checksum error ?

		SBRC	flag,6		; is flash ?
		RJMP	eeprom
flash:
		LDI	rxd,0x03	; erase Flash Page
		RCALL	ctrl_flash
		LDI	rxd,0x05	; write Flash Page
		RCALL	ctrl_flash
                RJMP	MainLoop	; loop
eeprom:
		RCALL	w_eeprom	; write EEPROM
		RJMP	MainLoop	; loop
ziieroare:
		LDI	rxd,'N'		; send "N"
                RJMP	mainl		; retry

; ********************************************************************
;
;		Write EEPROM
;
;		Set EEARH:EEARL/EEDR and call
;
; ********************************************************************

w_eeprom:
		SBI	EECR,EEMPE
		SBI	EECR,EEPE
		RET

; ********************************************************************
;
;		Write and Erace flash/buffer
;
;		Set R30:R31/R0:R1/rxd and call
;
;		rxd:1 write buffer
;		rxd:3 erase Flash Page
;		rxd:5 write Flash Page
;
; ********************************************************************

ctrl_flash:
		OUT	SPMCSR,rxd
		SPM
		RET

; ********************************************************************
;
;		RS-232C Send 1byte
;
;		Set rxd and call
;
; ********************************************************************

SendL:
        #ifdef  Direct_TX
		CBI	PORTB,TX	; initial level
	#else
		SBI	PORTB,TX
	#endif
        	LDI     cn,2*(1+8+1)	; 10-bit Data
		RJMP	PC+5		; Start bit

        	ROR     rxd		; Rotate Right through Carry	[1] 1+5+6N+16+2=6N+24

 	#ifdef	Direct_TX
        	brcc	PC+2		;				[5]
        	cbi     PORTB,TX	; set TX='0' if Carry='1'
        	brcs	PC+2		;
        	sbi     PORTB,TX	; set TX='1' if Carry='0'
 	#else
        	brcc	PC+2
        	sbi     PORTB,TX	; set TX='1' if Carry='1'
        	brcs	PC+2
        	cbi     PORTB,TX	; set TX='0' if Carry='0'
 	#endif

        	rcall	bwait		; wait 1 bit and Carry='1'	[3+3+3N+5+3N+5]
        	brne    PC-6		; loop				[2]
bwait:					; wait 1 bit
		rcall	bwait2
bwait2:					; wait 1/2bit
		ldi	rs,(xtal/baud-22)/6-1		;[1] 1+(1+2)*N-1+1+4=3N+5
        	subi	rs,1				;[1]
        	brcc	PC-1				;[2/1]
		dec     cn				;[1]
		ret					;[4]

; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
		LDI	cnt1,xtal/500000+1	; for 20MHz => 11 => 1second
rpt2:
		CLR	r28
		CLR	r29
rptc:					; check Start bit
        #ifdef  Direct_RX
                SBIS	RXPORT,RX
        #else
                SBIC	RXPORT,RX
        #endif
                RJMP	PC+4
		RCALL	RcvL1		; get 1 byte
                ADD	crc,rxd		; compute checksum
                RET

                SBIW	r28,1
                BRNE	rptc
                DEC	cnt1
                BRNE	rpt2
way_to_exit:
                RJMP	first_address	; timeout:exit in all other cases

; ********************************************************************
;
;		RS-232C Recieve 1byte
;
;		Return in rxd
;
; ********************************************************************

RcvL:
        #ifdef  Direct_RX
                SBIS	RXPORT,RX
        #else
                SBIC	RXPORT,RX
        #endif
                RJMP	PC-1		; wait Start bit
RcvL1:
		RCALL	bwait2		; wait 1/2 bit
        	LDI     cn,2*(1+8)	; 9-bit Data

		ROR	rxd		; set Data			[1] 1+6N+16+2+2=6N+21
		RCALL	bwait		; wait 1 bit and Carry='1'	[6N+16]

        #ifdef  Direct_RX
                SBIC	PINB,RX		; Carry reversal		[2]
        #else
                SBIS	PINB,RX
        #endif
                CLC
		BRNE	PC-4		; loop				[2]
		RET

; ********************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

