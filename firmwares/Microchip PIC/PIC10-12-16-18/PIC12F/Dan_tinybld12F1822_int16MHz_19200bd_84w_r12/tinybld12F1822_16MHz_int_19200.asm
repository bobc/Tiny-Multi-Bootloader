	radix 	DEC
        
	; change these lines accordingly to your application	
#include "p12f1822.inc"
IdTypePIC = 0x19		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x800	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below

	
xtal 	EQU 	16000000	; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

;	#define	CHANGE_TX	;TX Bit Change from default, Please refer to the table below
;	#define	CHANGE_RX	;RX Bit Change from default, Please refer to the table below

;   The above 7 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+-------------+-------------+-----------+-----------+-----------+--------+------+
; |IdTypePIC| Device | Erase_Page |   TX bit    :   RX bit    |  TXCKSEL  |  RXDTSEL  | max_flash | EEPROM | PDIP |
; |         |        |            | default(Pin)/changed(Pin) |           |           |           |        |      |
; +---------+--------+------------+-------------+-------------+-----------+-----------+-----------+--------+------+
; |   0x19  |12F1822 |  16 words  | A0(7)/A4(3) | A1(6)/A5(2) | APFCON ,2 | APFCON ,7 |  0x0800   |   256  |   8  |
; |   0x37  |16F1823 |  16 words  | C4(6)/A0(13)| C5(5)/A1(12)| APFCON ,2 | APFCON ,7 |  0x0800   |   256  |  14  |
; +---------+--------+------------+-------------+-------------+-----------+-----------+-----------+--------+------+

        ;********************************************************************
	;	Tiny Bootloader		12F1822 16F1823 	Size=84words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;
	;	(2015.11.24 Revision 12)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	$19, B, 12F 1822(84W), 		$1000, 256, 168, 32,
	;	$37, B, 16F 1823(84W), 		$1000, 256, 168, 32,
	;
        ;********************************************************************

	#include "../spbrgselect.inc"

	#define first_address max_flash-84 ; 84 word in size

	   __CONFIG    _CONFIG1, _FOSC_INTOSC & _BOREN_OFF & _WDTE_OFF & _CP_OFF & _PWRTE_ON & _CPD_OFF & _MCLRE_ON  	
	   __CONFIG    _CONFIG2, _LVP_OFF &_STVREN_OFF &_BORV_LO &_PLLEN_OFF


	errorlevel 1, -305		; suppress warning msg that takes f as default

	
	cblock 0x7A
	crc
	i
	cnt1
	cnt2
	cnt3
	flag
	endc
	

;0000000000000000000000000 RESET 00000000000000000000000000

	org	0x0000
;	pagesel	IntrareBootloader
;	goto	IntrareBootloader
	DW	0x33AF		;bra $-0x50

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;
;PC_flash:    C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
;PC_EEPROM:   C1h          EEADRH  EEADRL  2  EEDATL  EEDATH(=0)    crc
;PIC_response:   id   K                                                 K

	org 	first_address
;	nop
;	nop
;	nop
;	nop

	org 	first_address+4
IntrareBootloader:
	movlp	(max_flash>>8)-1	;set PAGE

	movlb	0x01			;BANK1
	bsf	OSCCON,6		;internal clock 16MHz

	movlb	0x02			;BANK2					;init int clock & serial port
 #ifdef CHANGE_TX
	bsf	APFCON0,2
 #else
	bcf	APFCON0,2
 #endif

 #ifdef CHANGE_RX
	bsf	APFCON0,RXDTSEL
 #else
	bcf	APFCON0,RXDTSEL
 #endif

	movlb	0x03			;BANK3
	clrf	ANSELA
	movlw	b'00100100'
	movwf	TXSTA
	movlw	spbrg_value
	movwf	SPBRG
	movlw	b'10010000'
	movwf	RCSTA
					;wait for computer
	call	Receive
	sublw	0xC1			;Expect C1
	skpz
	bra	way_to_exit
	movlw 	IdTypePIC		;PIC type
	movwf	TXREG
;	SendL	IdSoftVer		;firmware ver x

MainLoop:
	movlw 	'B'
mainl:
	movwf	TXREG
	clrf	crc
	call	Receive			;H
	movwf	EEADRH
	movwf	flag
	call	Receive			;L
	movwf	EEADRL
	call	Receive			;count
	movwf	i

rcvoct:
	call	Receive			;data L
	movwf	EEDATL
	decf	i,f
	call	Receive			;data H
	movwf	EEDATH
	movlw 	((1<<EEPGD) | (1<<LWLO) | (1<<WREN))
	call	wr_w			;write Latches
	incf	EEADRL,f
	decfsz	i,f
	bra	rcvoct

	call	Receive			;get SUM
ziieroare:
	movlw 	'N'
	skpz 				;check SUM
	bra	mainl

	decf	EEADRL,f		;EEADRL=EEADRL-1
	movlw 	(1<<WREN)		;set eeprom
	btfss	flag,6			;if writing to EEPROM, skip adjust operation.
	call	wr_e 			;erase operation
	call	wr_w			;write operation
	bra	MainLoop

Receive:
	movlw	xtal/2000000+2		;for 20MHz => 11 => 1second
	movwf	cnt1
rpt2:
;	clrf	cnt2
rpt3:
;	clrf	cnt3
rptc:
	movlb	0x00			;BANK0
	btfss	PIR1,RCIF		;recive done ?
	bra 	$+5			;not recive

	movlb	0x03			;BANK3
	movf 	RCREG,w			;return in w
	addwf 	crc,f			;compute checksum
	return

	decfsz	cnt3,f
	bra	rptc
	decfsz	cnt2,f
	bra	rpt3
	decfsz	cnt1,f
	bra	rpt2

way_to_exit:				;communication error; must be BANK3
	clrf	EECON1
	bcf	RCSTA,SPEN		;deactivate UART
	movlb	0x00			;BANK0
	movlp	0x00			;PAGE0
	bra	first_address		;PAGE=0, Please do not change the GOTO instruction.

wr_e:
	movlw 	((1<<EEPGD) | (1<<FREE) | (1<<WREN))
wr_w:
	movwf	EECON1
	movlw	0x55
	movwf	EECON2
	movlw	0xaa
	movwf	EECON2	
	bsf	EECON1,WR
	nop
	nop
	retlw	((1<<EEPGD) | (1<<WREN))

;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

         end
