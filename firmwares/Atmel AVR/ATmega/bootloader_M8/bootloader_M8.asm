
	; change these lines accordingly to your application	
.include "m8def.inc"
.equ	FamilyAVR=0x32		; AVR Family ("1":ATtiny, "2":ATmega)
.equ	IdTypeAVR=0x22		; must exists in "piccodes.ini"	
#define	max_flash 0x1000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)
        
.equ	xtal	=	8000000	; you may also want to change: _HS_OSC _XT_OSC
.equ	baud    =	19200	; standard TinyBld baud rates: 115200 or 19200

.equ	Calib   =	0x9A	; 8MHz Calibration value

;   The above 8 lines can be changed and buid a bootloader for the desired frequency

; +---------+---------+--------+------------+------------+-----------+--------+------+
; |AVRFamily|IdTypeAVR| Device | Erase_Page | Write_Page | max_flash | EEPROM | PDIP |
; +---------+---------+--------+------------+------------+-----------+--------+------+
; |   0x32  |   0x22  |  M8    |  32 words  |  32 words  |  0x1000   |  512   |  28  |
; +---------+---------+--------+------------+------------+-----------+--------+------+

    	;********************************************************************
    	;       Tiny Bootloader         ATMEGA8                 Size=100words
	;
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	!!!!! Set Fuse Bit SUT_CKSEL Int.RC Osc 8MHz: Start-up time 6CK + 64ms !!!!!
	;
	;	Please add the following line to piccodes.ini
	;
	;	$32, 2, ATMEGA 8, $2000, 512, 200, 64,
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
		LDI 	rxd,low(RAMEND)	; SP = RAMEND
		OUT	SPL,rxd
		LDI	rxd,high(RAMEND)
		OUT	SPH,rxd
		LDI	rxd,Calib	; set 8MHz Calibration value
		OUT	OSCCAL,rxd
		LDI	rxd,(xtal / (16 * baud) - 1)
		OUT	UBRRL,rxd
		LDI	rxd,((1<<RXEN) | (1<<TXEN)) ; RX on,TX on
		OUT	UCSRB,rxd

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
		OUT	EEARH,rxd	; set EEARH
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
		LDI	rxd,(1<<SPMEN)	; write buffer
		RCALL	ctrl_flash
		SUBI	count,2		; count=count-2
                BRNE	rcvoct		; loop

                RCALL	Receive		; get Checksum
		BRNE	ziieroare	; Checksum error ?

		SBRC	flag,6		; is flash ?
		RJMP	eeprom
flash:
		LDI	rxd,((1<<PGERS)+(1<<SPMEN))	; erase Flash Page
		RCALL	ctrl_flash
		LDI	rxd,((1<<PGWRT)+(1<<SPMEN))	; write Flash Page
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
		SBIC 	EECR,EEWE
		RJMP	w_eeprom
		SBI	EECR,EEMWE
		SBI	EECR,EEWE
		RET

; ********************************************************************
;
;		Write and Erace flash/buffer
;
;		Set R30:R31/R0:R1/rxd and call
;
; ********************************************************************

ctrl_flash:
 		IN 	temp,SPMCR
		SBRC 	temp,SPMEN
		RJMP 	ctrl_flash
		OUT	SPMCR,rxd
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
		SBIS	UCSRA,UDRE	; check buffer empty
	 	RJMP	rs1tx
	 	OUT	UDR,rxd		; Send 1 byte
		RET

; ********************************************************************
;
;		RS-232C Recive 1byte
;
;		return in rxd
;
; ********************************************************************

rs1rx:
		SBIS	UCSRA,RXC	; check Recive done
		RJMP	rs1rx		;
r1rx11:
		IN	rxd,UDR		; Recive 1 byte
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
		SBIS	UCSRA,RXC
                RJMP	PC+4
		RCALL	r1rx11		; get 1 byte
                ADD	crc,rxd		; compute checksum
                RET

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

