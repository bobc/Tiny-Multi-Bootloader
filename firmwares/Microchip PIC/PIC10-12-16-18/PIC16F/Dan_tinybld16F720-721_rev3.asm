	radix 	DEC
        
	; change these lines accordingly to your application	
#include "p16f721.inc"
IdTypePIC = 0x27		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x1000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below
	
xtal 	EQU 	8000000		; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

;   The above 5 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+--------+--------+-----------+--------+------+
; |IcTypePIC| Device | Erase_Page | TX bit | RX bit | max_flash | EEPROM | PDIP |
; +---------+--------+------------+--------+--------+-----------+--------+------+
; |   0x25  | 16F720 |  32 words  | B7(10) | B5(12) |  0x0800   |  0     |  20  |
; |   0x27  | 16F721 |  32 words  | B7(10) | B5(12) |  0x1000   |  0     |  20  |
; +---------+--------+------------+--------+--------+-----------+--------+------+

; +----------+------+----------+------+ +----------+------+----------+------+ +----------+------+
; | register | BANK | register | BANK | | register | BANK | register | BANK | |subroutine| BANK |
; +----------+------+----------+------+ +----------+------+----------+------+ +----------+------+
; | PMCON1/2 |  3   |PMADRL/DAT|  2   | | TXSTA    |  1   | SPBRG    |  1   | | Receive  |->0->2|
; +----------+------+----------+------+ +----------+------+----------+------+ +----------+------+
; | ANSELA   |  1   |          |      | | TXREG    |  0   | RCREG    |  0   |
; +----------+------+----------+------+ +----------+------+----------+------+
;					| RCSTA    |  0   |          |      |
; 					+----------+------+----------+------+

        ;********************************************************************
	;	Tiny Bootloader		16F720/721 		Size=100words
	;
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	(2014.02.05 Revision 4)
	;
	;
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
        ;********************************************************************

	#include "../spbrgselect.inc"

	#define first_address max_flash-100 ; 100 word in size

	 __CONFIG    _CONFIG1, _INTOSC_NOCLKOUT & _CP_OFF & _PWRTE_ON & _WDTE_OFF & _MCLRE_ON & _PLLEN_ON
	 __CONFIG    _CONFIG2, _WRTEN_OFF

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
	endc
	

;0000000000000000000000000 RESET 00000000000000000000000000

	org	0x0000
	pagesel	IntrareBootloader
	goto	IntrareBootloader

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

IntrareBootloader
					;init int clock & serial port
					;PLLEN,8MHz
	movlw	b'10010000'
	movwf	RCSTA

	bsf	STATUS,RP0		;BANK1
	movlw	b'00100100'
	movwf	TXSTA
	movlw	spbrg_value
	movwf	SPBRG

	bsf	STATUS,RP1		;BANK3
	clrf	ANSELB

	call	Receive			;wait for computer
	clrf	STATUS			;BANK0
	sublw	0xC1			;Expect C1
	skpz
	goto	way_to_exit
	movlw 	IdTypePIC		;PIC type
	movwf	TXREG
;	SendL	IdSoftVer		;firmware ver x

MainLoop:
	movlw 	'B'
mainl:
	clrf	STATUS			;BANK0
	movwf	TXREG
	clrf	crc
	call	Receive			;H
	movwf	PMADRH
	call	Receive			;L
	movwf	PMADRL
	call	FSReceive		;count
	movwf	contor
	movwf	i
;	movlw	buffer
;	movwf	FSR

rcvoct:
	call	Receive			;data
	movwf	INDF
	incf	FSR,f
	decfsz	i,f
	goto	rcvoct

	call	FSReceive		;crc
ziieroare:
	movlw 	'N'
	skpz
	goto	mainl
					;write
;	movlw	buffer
;	movwf	FSR

writeloop:				;write 2 bytes = 1 instruction
	movf	INDF,w
	movwf	PMDATL
	incf	FSR,f
	movf	INDF,w
	movwf	PMDATH
	incf	FSR,f

	bsf	STATUS,RP0		;BANK 2->3
	btfsc	contor,6		;erase if EEADRL=B'XXX00000'
	call	wr_e 			;erase operation
	call	wr_w			;write operation

	bcf	STATUS,RP0		;BANK 3->2
	incf	PMADRL,f		;does not cross zones
	decf	contor,f
	decfsz	contor,f
	goto	writeloop

	goto	MainLoop


FSReceive:
	movlw	buffer
	movwf	FSR
Receive:
	clrf	STATUS			;BANK0
	movlw	xtal/2000000+1		;for 20MHz => 11 => 1second
	movwf	cnt1
rpt2:
	clrf	cnt2
rpt3:
	clrf	cnt3
rptc:
	btfss	PIR1,RCIF		;test RX
	goto 	$+5			;not recive
	movf 	RCREG,w			;return in w
	addwf 	crc,f			;compute checksum
	bsf	STATUS,RP1		;BANK2
	return

	decfsz	cnt3,f
	goto	rptc
	decfsz	cnt2,f
	goto	rpt3
	decfsz	cnt1,f
	goto	rpt2
					;timeout:
way_to_exit:				;exit in all other cases; must be BANK0
	bcf	RCSTA,SPEN		;deactivate UART
	goto	first_address


wr_e:
	bsf 	PMCON1,FREE
wr_w:
;	bcf 	PMCON1,CFGS 		;Deselect Config space
	bsf	PMCON1,WREN
	movlw	0x55
	movwf	PMCON2
	movlw	0xaa
	movwf	PMCON2	
	bsf	PMCON1,WR
	nop
	nop
	clrf	PMCON1
	return

;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

         end
