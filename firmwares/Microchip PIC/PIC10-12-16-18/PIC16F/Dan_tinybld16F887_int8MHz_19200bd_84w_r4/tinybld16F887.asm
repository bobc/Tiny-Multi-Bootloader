	radix DEC
	LIST  F=INHX8M

	; change these lines accordingly to your application	
#include "p16f887.inc"
IdTypePIC = 0x3C		; must exists in "piccodes.ini"			
#define max_flash 0x2000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)

xtal EQU 8000000		; you may also want to change: _HS_OSC _XT_OSC
baud EQU 19200			; standard TinyBld baud rates: 115200 or 19200
	; The above 5 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+------------+------+------+-----------+--------+
; |IcTypePIC| Device | Erase_Page | Write_Page |  TX  |  RX  | max_flash | EEPROM |
; +---------+--------+------------+------------+------+------+-----------+--------+
; |   0x3A  | 16F882 |  16 words  |   4 words  |C6(17)|C7(18)|  0x0800   |  128   |
; |   0x3B  | 16F883 |  16 words  |   4 words  |C6(17)|C7(18)|  0x1000   |  256   |
; |   0x3B  | 16F884 |  16 words  |   4 words  |C6(25)|C7(26)|  0x1000   |  256   |
; |   0x3C  | 16F886 |  16 words  |   8 words  |C6(17)|C7(18)|  0x2000   |  256   |
; |   0x3C  | 16F887 |  16 words  |   8 words  |C6(25)|C7(26)|  0x2000   |  256   |
; +---------+--------+------------+------------+------+------+-----------+--------+

; +----------+------+----------+------+ +----------+---------+
; | register | BANK | register | BANK | |subroutine|  BANK   |
; +----------+------+----------+------+ +----------+---------+
; | EECON1/2 |  3   |EEADRL/DAT|  2   | | Receive  | ->0->2  |
; +----------+------+----------+------+ +----------+---------+

    	;********************************************************************
	;	Tiny Bootloader		16F88X series		Size=84words
	;
	;	claudiu.chiculita@ugal.ro
	;	http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	(2014.06.27 Revision 4)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	Please add the following line to piccodes.ini
	;
	;	$3A, B, 16F 882(84w),     $1000, $80,  168, 32,
	;	$3B, B, 16F 883/884(84w), $2000, $100, 168, 32,
	;	$3C, B, 16F 886/887(84w), $4000, $100, 168, 32,
	;
        ;********************************************************************

	#include "../spbrgselect.inc"
	#define first_address max_flash-84 ; 84 word in size

	__CONFIG    _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF & _DEBUG_OFF
	__CONFIG    _CONFIG2, _BOR21V &  _WRT_OFF

	errorlevel 1, -305		; suppress warning msg that takes f as default
	
	cblock 0x7A
	crc
	contor
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
	bsf	STATUS,RP0		;BANK  0->1
	bsf	OSCCON,IRCF0		;Oscillator 8MHz
	movlw	b'00100100'
	movwf	TXSTA
	movlw	spbrg_value
	movwf	SPBRG
	bcf	STATUS,RP0		;BANK  1->0
	movlw	b'10010000'
	movwf	RCSTA

	call	Receive			;wait for computer
	clrf	STATUS			;BANK  2->0
	sublw	0xC1			;Expect C1
	skpz
	goto	way_to_exit

	movlw	IdTypePIC		;PIC type
	movwf	TXREG
	;SendL	IdSoftVer		;firmware ver x

MainLoop:
	movlw	'B'
mainl:
	clrf	STATUS			;BANK  0
	movwf	TXREG
	clrf	crc
	call	Receive			;Address H
	movwf	EEADRH
	movwf	flag			;used to detect if is eeprom
	call	Receive			;Address L
	movwf	EEADR
	call	Receive			;count
	movwf	contor

rcvoct:
        call    Receive
        movwf   EEDATA			;data L
	call    Receive
        movwf   EEDATH			;data H
	bsf	STATUS,RP0		;BANK 2->3
	call	wr
	bcf	STATUS,RP0		;BANK 3->2
	incf	EEADR,f
	decf	contor,f
	decfsz	contor,f
	goto	rcvoct

	call	Receive			;checksum
ziieroare:
	movlw	'N'
	skpz
	goto	mainl
	goto	MainLoop


; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
	clrf	STATUS			;BANK 0
	movlw   xtal/2000000+1  	;for 20MHz => 11 => 1second
        movwf   cnt1
rpt2:
	clrf    cnt2
rpt3:
	clrf    cnt3
rptc:
	btfss	PIR1,RCIF		; check Data Receive
	goto 	$+5

	movf 	RCREG,w			;return in W
	addwf	crc,f			;compute checksum
	bsf	STATUS,RP1		;BANK  0->2
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


; ********************************************************************
;
;		Program Flash/EEPROM
;
; ********************************************************************

wr:
	btfss	flag,6			;skip if EEPROM
	bsf	EECON1,EEPGD
	bsf	EECON1,WREN
	movlw	0x55
	movwf	EECON2
	movlw	0xaa
	movwf	EECON2
	bsf	EECON1,WR
	nop
	nop
	clrf	EECON1
	return

;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

        END
