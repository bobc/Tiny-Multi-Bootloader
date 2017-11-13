	radix 	DEC
        
	; change these lines accordingly to your application	
#include "p16f1455.inc"
IdTypePIC = 0x29		; , Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x2000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below

#define PDIP       14		; PIN Count of Device (14/20), Please refer to the table below
	
xtal 	EQU 	16000000	; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

;   The above 6 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+--------+--------+-----------+--------+------+
; |IdTypePIC| Device | Erase_Page | TX bit | RX bit | max_flash | EEPROM | PDIP |
; +---------+--------+------------+--------+--------+-----------+--------+------+
; |   0x29  |16F1454 |  32 words  |  C4(6) |  C5(5) |  0x2000   |    0   |  14  |
; |   0x29  |16F1455 |  32 words  |  C4(6) |  C5(5) |  0x2000   |    0   |  14  |
; |   0x29  |16F1459 |  32 words  |  B7(10)|  B5(12)|  0x2000   |    0   |  20  |
; +---------+--------+------------+--------+--------+-----------+--------+------+

; +----------+------+----------+------+
; | register | BANK | register | BANK |
; +----------+------+----------+------+
; | PMCON1/2 |  3   |PMADRL/DAT|  3   |
; +----------+------+----------+------+

        ;********************************************************************
	;	Tiny Bootloader		16F14xx series		Size=100words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;
	;	(2014.06.09 Revision 6)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
        ;********************************************************************

	#include "../spbrgselect.inc"

	#define first_address max_flash-100 ; 100 word in size

	   __CONFIG    _CONFIG1, _FOSC_INTOSC & _BOREN_OFF & _WDTE_OFF & _CP_OFF & _PWRTE_ON & _MCLRE_ON
	   __CONFIG    _CONFIG2, _LVP_OFF &_STVREN_OFF &_BORV_LO


	errorlevel 1, -305		; suppress warning msg that takes f as default

	cblock 0x7B
	crc
	i
	cnt1
	cnt2
	cnt3
	endc

;0000000000000000000000000 RESET 00000000000000000000000000

	org	0x0000
;	pagesel	IntrareBootloader
;	goto	IntrareBootloader
	DW	0x339F		;bra $-0x60

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;               
					;PC_flash:    C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
					;PIC_response:   id   K                                                 K

	org 	first_address
;	nop
;	nop
;	nop
;	nop
	org 	first_address+4
IntrareBootloader:
					;init int clock & serial port
	movlp	(max_flash>>8)-1
	movlw	PIR1			;FSR1=PIR1
	movwf	FSR1L
	movlb	0x01			;BANK1
	bsf	OSCCON,6		;internal clock 16MHz

	movlb	0x03			;BANK3

 #if (PDIP==20)
	clrf	PMADRL-4		;ANSELB(0x018D)
 #else
	clrf	PMADRL-3		;ANSELC(0x018E)
 #endif

	movlw	b'00100100'
	movwf	TXSTA
	movlw	spbrg_value
	movwf	SPBRGL
	movlw	b'10010000'
	movwf	RCSTA
					;wait for computer
	call	Receive			
	sublw	0xC1			;Expect C1
	skpz
	bra	way_to_exit
	movlw	IdTypePIC		;PIC type
	movwf	TXREG
;	SendL	IdSoftVer		;firmware ver x

MainLoop:
	movlw 	'B'
mainl:
	movwf	TXREG
	clrf	crc
	call	Receive			;H
	movwf	PMADRH
	call	Receive			;L
	movwf	PMADRL
	call	Receive			;count
	movwf	i

rcvoct:
	call	Receive			;data L
	movwf	PMDATL
	decf	i,f
	call	Receive			;data H
	movwf	PMDATH
	movlw 	((1<<LWLO) | (1<<WREN))
	call	wr_w			;write Latches
	incf	PMADRL,f
	decfsz	i,f
	bra	rcvoct

	call	Receive			;crc
ziieroare:
	movlw 	'N'
	skpz
	bra	mainl

	decf	PMADRL,f		;PMADRL=PMADRL-1
	call	wr_e 			;erase operation
	call	wr_w			;write operation
	bra	MainLoop

Receive:
	movlw	xtal/2000000+1		;for 20MHz => 11 => 1second
	movwf	cnt1
rpt2:
	clrf	cnt2
rpt3:
	clrf	cnt3
rptc:
	btfss 	INDF1,RCIF		;test RX
	bra 	$+4			;not recive
	movf 	RCREG,w			;return in w
	addwf 	crc,f			;compute checksum
	return

	decfsz	cnt3,f
	bra	rptc
	decfsz	cnt2,f
	bra	rpt3
	decfsz	cnt1,f
	bra	rpt2
					;timeout:
way_to_exit:				;exit in all other cases; must be BANK3
	clrf	PMCON1
	bcf	RCSTA,SPEN		;deactivate UART
	movlb	0x00			;BANK0
	clrf	PCLATH
	bra	first_address		; PCLATH=0, Please do not change the GOTO instruction.

wr_e:
	movlw 	((1<<FREE) | (1<<WREN))
wr_w:
	movwf	PMCON1
	movlw	0x55
	movwf	PMCON2
	movlw	0xaa
	movwf	PMCON2
	bsf	PMCON1,WR
	nop
	nop
	retlw	((1<<WREN))

;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

         end
