
	; change these lines accordingly to your application	
.include "m88def.inc"
.equ	FamilyAVR=0x32		; AVR Family ("1":ATtiny, "2":ATmega)
.equ	IdTypeAVR=0x21		; must exists in "piccodes.ini"	
#define	max_flash 0x0800	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)
        
.equ	xtal	=	8000000	; you may also want to change: _HS_OSC _XT_OSC
.equ	baud    =	19200	; standard TinyBld baud rates: 115200 or 19200

.equ	Calib   =	0x85	; 8MHz Calibration value

;   The above 8 lines can be changed and buid a bootloader for the desired frequency

; +---------+---------+--------+------------+------------+-----------+--------+------+
; |AVRFamily|IdTypeAVR| Device | Erase_Page | Write_Page | max_flash | EEPROM | PDIP |
; +---------+---------+--------+------------+------------+-----------+--------+------+
; |   0x32  |   0x21  |  M48   |  32 words  |  32 words  |  0x0800   |  256   |  28  |
; +---------+---------+--------+------------+------------+-----------+--------+------+

    	;********************************************************************
    	;       Tiny Bootloader         ATMEGA48                Size=100words
	;
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	!!!!! Set Fuse Bit SELFPRGEN=0,CKDIV8=1 and 8MHz Calibration value !!!!!
	;
	;	Please add the following line to piccodes.ini
	;
	;	$21, 2, ATMEGA 48, $1000, 256, 200, 64,
	;
	;********************************************************************

        #define first_address max_flash-100 ; 100 word in size

;reg
#define 	crc	r20
#define 	cnt1	r21
#define 	flag	r22
#define 	count	r23
#define 	temp	r24
#define 	rxd	r25

;I/Oreg
#define 	UBRRL	UBRR0L
#define 	UCSRB	UCSR0B
#define 	UDR	UDR0
#define 	UCSRA	UCSR0A

;bit
#define 	RXEN	RXEN0
#define 	TXEN	TXEN0
#define 	UDRE	UDRE0
#define 	RXC	RXC0

;macro
.macro OUTI
		LDI	xh,high(@0)
		LDI	xl,low(@0)
		ST	x,@1
.endm

.macro INI
		LDI	xh,high(@1)
		LDI	xl,low(@1)
		LD	@0,x
.endm

.macro SBISI
		LDI	xh,high(@0)
		LDI	xl,low(@0)
		LD	temp,x
		SBRS	temp,@1
.endm

.cseg
;0000000000000000000000000 RESET 00000000000000000000000000

                .org    0x0000		;;Reset vector
;		RJMP	IntrareBootloader
		.dw	0xcf9f		;RJMP PC-0x60

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
		OUTI	OSCCAL,rxd
		LDI	rxd,(xtal / (16 * baud) - 1)
		OUTI	UBRRL,rxd
		LDI	rxd,((1<<RXEN) | (1<<TXEN)) ; RX on,TX on
		OUTI	UCSRB,rxd

		RCALL	Receive		; wait for computer
                SUBI	rxd,0xC1	; Expect C1
                BREQ	PC+2		; skip if C1
                RJMP	way_to_exit	; connection errer or timeout
                LDI	rxd,IdTypeAVR	; send IdType
        	RCALL	rs1tx
MainLoop:
		LDI	rxd,FamilyAVR	; send ATmega Family ID
mainl:
		RCALL	rs1tx
		CLR	crc		; clear Checksum
                RCALL	Receive		; get ADR_H
		MOV	r31,rxd		; set r31
		MOV	flag,rxd	; set flag
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
		LDI	rxd,(1<<SELFPRGEN)	; write buffer
		RCALL	ctrl_flash
		SUBI	count,2		; count=count-2
                BRNE	rcvoct		; loop

                RCALL	Receive		; get Checksum
		BRNE	ziieroare	; Checksum error ?

		SBRC	flag,6		; is flash ?
		RJMP	eeprom
flash:
		LDI	rxd,((1<<PGERS)+(1<<SELFPRGEN))	; erase Flash Page
		RCALL	ctrl_flash
		LDI	rxd,((1<<PGWRT)+(1<<SELFPRGEN))	; write Flash Page
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
;		Set EEARL/EEDR and call
;
; ********************************************************************

w_eeprom:
		SBIC 	EECR,EEPE
		RJMP	w_eeprom
		SBI	EECR,EEMPE
		SBI	EECR,EEPE
		RET

; ********************************************************************
;
;		Write and Erace flash/buffer
;
;		Set R30:R31/R0:R1/rxd and call
;
; ********************************************************************

ctrl_flash:
 		IN 	temp,SPMCSR
		SBRC 	temp,SELFPRGEN
		RJMP 	ctrl_flash
		OUT	SPMCSR,rxd
		SPM
		RET

; ********************************************************************
;
;		RS-232C Send 1byte
;
;		set rxd and call
;
; ********************************************************************

rs1tx:
		SBISI	UCSRA,UDRE	; check buffer empty
	 	RJMP	rs1tx
	 	OUTI	UDR,rxd		; Send 1 byte
		RET

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
rptc:					; check Recive done
		SBISI	UCSRA,RXC
                RJMP	loop
		INI	rxd,UDR		; recive 1 byte
                ADD	crc,rxd		; compute checksum
                RET
loop:
                SBIW	r28,1
                BRNE	rptc
                DEC	cnt1
                BRNE	rpt2
way_to_exit:
;		CLR	rxd		; Disable RX,TX
;		OUT	UCSRB, rxd
                RJMP	first_address	; timeout:exit in all other cases

; ********************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

