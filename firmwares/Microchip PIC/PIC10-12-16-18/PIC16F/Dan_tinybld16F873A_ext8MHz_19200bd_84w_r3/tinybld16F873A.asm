	radix DEC
	LIST  F=INHX8M

	; change these lines accordingly to your application	
#include "p16f873A.inc"
IdTypePIC = 0x3D		; must exists in "piccodes.ini"			
#define max_flash 0x1000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)

xtal EQU 8000000		; you may also want to change: _HS_OSC _XT_OSC
baud EQU 19200			; standard TinyBld baud rates: 115200 or 19200
	; The above 5 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+------------+------+------+-----------+--------+
; |IcTypePIC| Device | Erase_Page | Write_Page |  TX  |  RX  | max_flash | EEPROM |
; +---------+--------+------------+------------+------+------+-----------+--------+
; |   0x3D  |16F873A |  4 words   |   4 words  |C6(17)|C7(18)|  0x1000   |  128   |
; |   0x3D  |16F874A |  4 words   |   4 words  |C6(25)|C7(26)|  0x1000   |  128   |
; |   0x3C  |16F876A |  4 words   |   4 words  |C6(17)|C7(18)|  0x2000   |  256   |
; |   0x3C  |16F877A |  4 words   |   4 words  |C6(25)|C7(26)|  0x2000   |  256   |
; +---------+--------+------------+------------+------+------+-----------+--------+

; +----------+------+----------+------+ +----------+--------+
; | register | BANK | register | BANK | |subroutine|  BANK  |
; +----------+------+----------+------+ +----------+--------+
; | EECON1/2 |  3   |EEADRL/DAT|  2   | | Receive  | ->0->2 |
; +----------+------+----------+------+ +----------+--------+

    	;********************************************************************
	;	Tiny Bootloader		16F87XA series		Size=84words
	;
	;	claudiu.chiculita@ugal.ro
	;	http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	(2014.02.07 Revision 3)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	Please add the following line to piccodes.ini
	;	$3D, B, 16F 873A/874A(84w),         $2000, $80,  168, 32,
	;	$3C, B, 16F 886/887/876A/877A(84w), $4000, $100, 168, 32,
	;
        ;********************************************************************

	#include "../spbrgselect.inc"
	#define first_address max_flash-84 ; 84 word in size

	__CONFIG  _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _DEBUG_OFF & _CP_OFF

	errorlevel 1, -305		; suppress warning msg that takes f as default

	
	cblock 0x20
	buffer:80
	endc
	
	cblock 0x78
	crc
	contor
	i
	cnt1
	cnt2
	cnt3
	flag
	endc
	
;0000000000000000000000000 RESET 00000000000000000000000000

		ORG     0x0000
		PAGESEL IntrareBootloader
		GOTO    IntrareBootloader

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;
;PC_flash:    C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
;PC_EEPROM:   C1h          EEADRH  EEADRL  2  EEDATL  EEDATH(=0)    crc
;PIC_response:   id   K                                                 K
	
	ORG first_address
;	nop
;	nop
;	nop
;	nop

	org first_address+4
IntrareBootloader:
					;init serial port
	movlw	b'10010000'
	movwf	RCSTA
	bsf	STATUS,RP0		;bank  0->1
	movlw	b'00100100'
	movwf	TXSTA
	movlw	spbrg_value
	movwf	SPBRG
					;wait for computer
	call	Receive
	clrf	STATUS			;bank  2->0
	sublw	0xC1			;Expect C1
	skpz
	goto	way_to_exit

	movlw	IdTypePIC		;PIC type
	movwf	TXREG
	;SendL	IdSoftVer		;firmware ver x
MainLoop:
	movlw	'B'
mainl:
	clrf	STATUS			;bank  0
	movwf	TXREG
	clrf	crc
	call	Receive			;H
	movwf	EEADRH
	movwf	flag			;used to detect if is eeprom
	call	Receive			;L
	movwf	EEADR

	call	FSReceive		;count
	movwf	contor
	movwf	i
;	movlw	buffer
;	movwf	FSR
rcvoct:
	call	Receive
	movwf	INDF
	incf	FSR,f
	decfsz	i,f
	goto	rcvoct

	call	FSReceive		;checksum
ziieroare:
	movlw	'N'
	skpz				;check checksum
	goto	mainl
					;write
;	movlw	buffer
;	movwf	FSR
writeloop:				;write 2 bytes = 1 instruction
	movf	INDF,w
	movwf	EEDATA
	incf	FSR,f
	movf	INDF,w
	movwf	EEDATH
	incf	FSR,f
	movlw	(1<<WREN)
	btfss	flag,6			;is EEPROM (or flash)
	addlw	(1<<EEPGD)
	bsf	STATUS,RP0		;bank  2->3
	movwf	EECON1
	goto	$+1
	movlw	0x55
	movwf	EECON2
	movlw	0xaa
	movwf	EECON2
	bsf	EECON1,WR
	nop
	nop
;	clrf	EECON1
	bcf	STATUS,RP0		;bank  3->2
	incf	EEADR,f			;does not cross zones
	decf	contor,f
	decfsz	contor,f
	goto	writeloop

	goto	MainLoop

FSReceive:
	movlw	buffer
	movwf	FSR
Receive:
	movlw   xtal/2000000+2  	;for 20MHz => 11 => 1second
        movwf   cnt1
rpt2:
;	clrf    cnt2
rpt3:
;	clrf    cnt3
rptc:					;Check Start bit
	clrf	STATUS			;bank 0
	btfss	PIR1,RCIF		;test RX
	goto 	$+5
	movf 	RCREG,w			;return in W
	addwf	crc,f			;compute checksum
	bsf	STATUS,RP1		;bank  0->2
	return

        decfsz  cnt3,f
        goto    rptc
        decfsz  cnt2,f
        goto    rpt3
        decfsz  cnt1,f
        goto    rpt2
					;timeout:
way_to_exit:				;exit in all other cases; must be BANK0
	bcf	RCSTA,SPEN		;deactivate UART
	goto	first_address
;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

        END
