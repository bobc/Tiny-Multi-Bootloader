
	; change these lines accordingly to your application	
.include "tn13adef.inc"
.equ	FamilyAVR=0x31		; AVR Family ("1":ATtiny, "2":ATmega)
.equ	IdTypeAVR=0x17		; must exists in "piccodes.ini"	
#define	max_flash 0x200		; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)
        
.equ	xtal	=	9600000 ; you may also want to change: _HS_OSC _XT_OSC
.equ	baud    =	9600    ; standard TinyBld baud rates: 115200 or 19200

.equ	Calib   =	0x68    ; 9.6MHz Calibration value

        #define TX      3               ; ATTINY13A TX Data output pin (i.e. 2 = PORTB,2)
        #define RX      4               ; ATTINY13A RX Data input pin (i.e. 3 = PORTB,3)
;        #define Direct_TX               ; RS-232C TX Direct Connection(No use MAX232)
;        #define Direct_RX               ; RS-232C RX Direct Connection(No use MAX232)

;   The above 11 lines can be changed and buid a bootloader for the desired frequency

; +---------+---------+------------+------------+------------+-----------+--------+------+
; |AVRFamily|IdTypeAVR|   Device   | Erase_Page | Write_Page | max_flash | EEPROM | PDIP |
; +---------+---------+------------+------------+------------+-----------+--------+------+
; |   0x31  |   0x17  | TN13A(84W) |  16 words  |  16 words  |  0x0200   |   64   |  8   |
; +---------+---------+------------+------------+------------+-----------+--------+------+

    	;********************************************************************
    	;       Tiny Bootloader         ATTINY13A         Size=84words
	;
	;	(2015.02.23 Revision 9)
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	!!!!! Set Fuse Bit SELFPRGEN=0,CKDIV8=1 and 9.6MHz Calibration value !!!!!
	;
	;	Please add the following line to piccodes.ini
	;
	;	$17, 1, ATTINY 13A(84w), 		$400, 64, 168, 32,
	;
	;********************************************************************


        #define first_address max_flash-84 ; 84 word in size

#define 	crc	r19
#define 	cnt1	r20
#define 	count	r21
#define 	fcmd	r22
#define 	rs	r23
#define 	cn	r24
#define 	txd	r25
#define 	rxd	r1

.cseg
;0000000000000000000000000 RESET 00000000000000000000000000

                .org    0x0000		;;Reset vector
;		RJMP	IntrareBootloader
		.dw	0xcfaf		;RJMP PC-0x50

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
		LDI	cn,Calib	; set 9.6MHz Calibration value
		OUT	OSCCAL,cn
		SBI	DDRB,TX		; set TX Port

		CLR	crc		; clear Checksum
                RCALL	Receive		; get C1
                SUBI	crc,0xC1	; Expect C1
                BRNE	first_address	; connection errer or timeout

                LDI	txd,IdTypeAVR	; send IdType
        	RCALL	SendL
MainLoop:
		LDI	txd,FamilyAVR	; send ATtiny Family ID
mainl:
		RCALL	SendL
                RCALL	Receive		; get ADR_H
		MOV	r31,rxd		; set r31
                RCALL	Receive		; get ADR_L
		MOV	r30,rxd		; set r30
		OUT	EEARL,rxd	; set EEARL
		LSL	r30		; set PCPAGE:PCWORD
		ROL	r31		; EEPROM Flag bit6 -> bit7
                RCALL	Receive		; get count
		MOV	count,rxd	; set count
rcvoct:
	        RCALL	Receive		; get Data(L)
		MOV	r0,rxd		; set Data(L)
		OUT	EEDR,rxd	; set EEDR
                RCALL	Receive		; get Data(H)
;		MOV	r1,rxd		; set Data(H)
		LDI	fcmd,0x01	; write buffer
		RCALL	Flash_Sequence
		ADIW	r30,2		; PCPAGE:PCWORD=PCPAGE:PCWORD+2
		SUBI	count,2		; count=count-2
                BRNE	rcvoct		; loop

                RCALL	Receive		; get Checksum
ziieroare:
		LDI	txd,'N'		; send "N"
                BRNE	mainl		; retry

		SBIW 	r30,2 		; PCPAGE:PCWORD adjust
		SBI	EECR,EEMPE	; EEMPE will be cleared 4 cycle after
		SBRS	r31,7		; Skip if EEPROM
flash:
		RCALL	Flash_Sequence2	; erase and write Flash Page
eeprom:
		SBI	EECR,EEPE	; write EEPROM if EEMPE=1
		RJMP	MainLoop	; loop

; ********************************************************************
;
;		Flash write Sequence
;
;		Set fcmd and call
;
; ********************************************************************

Flash_Sequence2:
		RCALL	Flash_Sequence1 ; erase page (fcmd=1->3)
Flash_Sequence1:
		SUBI	fcmd,0xFE	; write page (fcmd=3->5)
Flash_Sequence:
		OUT	SPMCSR,fcmd	; write buffer (fcmd=1)
		SPM
		RET

; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
		LDI	cnt1,xtal/500000+2	; for 20MHz => 11 => 1second
rpt:
;		CLR	r28
;		CLR	r29
					; check Start bit
        #ifdef  Direct_RX
                SBIS	PINB,RX
        #else
                SBIC	PINB,RX
        #endif
                RJMP	no_data
		RCALL	RcvL+2		; Recieve 1byte
                ADD	crc,rxd		; compute checksum
		RET
no_data:
                SBIW	r28,1
                BRNE	rpt
                DEC	cnt1
                BRNE	rpt
way_to_exit:
                RJMP	first_address	; timeout:exit in all other cases

; ********************************************************************
;
;		RS-232C Send 1byte
;
;		Set txd and call
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

        	ROR     txd		; Rotate Right through Carry	[1] 1+5+6N+16+2=6N+24

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
;		RS-232C Recieve 1byte
;
;		return in rxd
;
; ********************************************************************

RcvL:
        #ifdef  Direct_RX
                SBIS	PINB,RX
        #else
                SBIC	PINB,RX
        #endif
                RJMP	RcvL

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

