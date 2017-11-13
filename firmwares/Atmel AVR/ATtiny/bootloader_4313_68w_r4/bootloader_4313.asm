
	; change these lines accordingly to your application	
.include "tn4313def.inc"
.equ	FamilyAVR=0x31		; AVR Family ("1":ATtiny, "2":ATmega)
.equ	IdTypeAVR=0x19		; must exists in "piccodes.ini"	
#define	max_flash 0x800		; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)
        
.equ	xtal	=	8000000	; you may also want to change: _HS_OSC _XT_OSC
.equ	baud    =	19200	; standard TinyBld baud rates: 115200 or 19200

.equ	Calib   =	0x40	; 8MHz Calibration value

;   The above 8 lines can be changed and buid a bootloader for the desired frequency

; +---------+---------+-------------+------------+------------+-----------+--------+------+
; |AVRFamily|IdTypePIC|   Device    | Erase_Page | Write_Page | max_flash | EEPROM | PDIP |
; +---------+---------+-------------+------------+------------+-----------+--------+------+
; |   0x31  |   0x19  | TN4313(68W) |  32 words  |  32 words  |  0x0800   |  256   |  20  |
; +---------+---------+-------------+------------+------------+-----------+--------+------+

    	;********************************************************************
    	;       Tiny Bootloader         ATTINY4313              Size=68words
	;
	;	(2014.06.02 Revision 4)
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	!!!!! Set Fuse Bit SELFPRGEN=0,CKDIV8=1 and 8MHz Calibration value !!!!!
	;
	;	Please add the following line to piccodes.ini
	;
	;	$19, 1, ATTINY 4313 , $1000, 256, 136, 64,
	;
	;********************************************************************


        #define first_address max_flash-68 ; 68 word in size

#define 	crc	r22
#define 	cnt1	r23
#define 	count	r24
#define 	rxd	r25

.cseg
;0000000000000000000000000 RESET 00000000000000000000000000

                .org    0x0000		;;Reset vector
;		RJMP	IntrareBootloader
		.dw	0xcfbf		;RJMP PC-0x40

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
		LDI	rxd,Calib	; set 8MHz Calibration value
		OUT	OSCCAL,rxd
		LDI	rxd,(xtal / (16 * baud) - 1)
		OUT	UBRRL,rxd
		LDI	rxd,((1<<RXEN) | (1<<TXEN)) ; RX on,TX on
		OUT	UCSRB,rxd

		RCALL	Receive		; wait for computer
                SUBI	rxd,0xC1	; Expect C1
                BRNE	way_to_exit	; connection errer or timeout
                LDI	rxd,IdTypeAVR	; send IdType
	 	OUT	UDR,rxd		;
MainLoop:
		LDI	rxd,FamilyAVR	; send ATtiny Family ID
mainl:
		SBIS	UCSRA,UDRE	; check buffer empty
	 	RJMP	PC-1
	 	OUT	UDR,rxd		; Send 1 byte
		CLR	crc		; clear Checksum
                RCALL	Receive		; get ADR_H
		MOV	r31,rxd		; set r31
		BST	rxd,6		; if EEPROM set temp_flag
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
		RCALL	Flash_Sequence
		SUBI	count,2		; count=count-2
                BRNE	rcvoct		; loop

                RCALL	Receive		; get Checksum
ziieroare:
		LDI	rxd,'N'		; send "N"
		BRNE	mainl		; retry

		SBI	EECR,EEMPE	; EEMPE will be cleared after 4 cycle
		BRTS	eeprom		; is EEPROM ?
flash:
		LDI	rxd,0x03	; erase Flash Page
		RCALL	Flash_Sequence
		LDI	rxd,0x05	; write Flash Page
		RCALL	Flash_Sequence
eeprom:
		SBI	EECR,EEPE
                RJMP	MainLoop	; loop

; ********************************************************************
;
;		Flash read/write Sequence
;
;		Set rxd and call
;
; ********************************************************************

Flash_Sequence:
		OUT	SPMCSR,rxd
		SPM
		RET

; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
		LDI	cnt1,xtal/500000+2	; for 20MHz => 11 => 1second
;rpt2:
;		CLR	r28
;		CLR	r29
rptc:					; check Recive done
		SBIS	UCSRA,RXC
                RJMP	PC+4
		IN	rxd,UDR		; Recive 1 byte
                ADD	crc,rxd		; compute checksum
                RET

                SBIW	r28,1
                BRNE	rptc
                DEC	cnt1
                BRNE	rptc
way_to_exit:
		CLR	rxd		; Disable RX,TX
		OUT	UCSRB,rxd
                RJMP	first_address	; timeout:exit in all other cases

; ********************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

