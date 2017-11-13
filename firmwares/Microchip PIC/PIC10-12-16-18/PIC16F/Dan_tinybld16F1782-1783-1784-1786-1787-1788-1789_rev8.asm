	radix 	DEC
        
	; change these lines accordingly to your application	
#include "p16f1782.inc"
IdTypePIC = 0x26		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x0800	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below
	
xtal 	EQU 	16000000	; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

;	#define	CHANGE_TX	;TX Bit Change from default, Please refer to the table
;	#define	CHANGE_RX	;RX Bit Change from default, Please refer to the table

;   The above 7 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+-------------+-------------+-----------+-----------+--------+-----------+------+
; |IdTypePIC| Device | Erase_Page |   TX bit    :   RX bit    |   TXSEL   |   RXSEL   | EEPROM | max_flash | PDIP |
; |         |        |            | default(Pin)/changed(Pin) |           |           |        |           |      |
; +---------+--------+------------+-------------+-------------+-----------+-----------+--------+-----------+------+
; |   0x26  |16F1782 |  32 words  |C6(17)/B6(27)|C7(18)/B7(28)| APFCON ,2 | APFCON ,1 |   256  |  0x0800   |  28  |
; |   0x28  |16F1783 |  32 words  |C6(17)/B6(27)|C7(18)/B7(28)| APFCON ,2 | APFCON ,1 |   256  |  0x1000   |  28  |
; |   0x28  |16F1784 |  32 words  |C6(25)/B6(39)|C7(26)/B7(40)| APFCON1,2 | APFCON1,1 |   256  |  0x1000   |  40  |
; |   0x2A  |16F1786 |  32 words  |C6(17)/B6(27)|C7(18)/B7(28)| APFCON1,2 | APFCON1,1 |   256  |  0x2000   |  28  |
; |   0x2A  |16F1787 |  32 words  |C6(25)/B6(39)|C7(26)/B7(40)| APFCON1,2 | APFCON1,1 |   256  |  0x2000   |  40  |
; |   0x2C  |16F1788 |  32 words  |C6(17)/B6(27)|C7(18)/B7(28)| APFCON1,2 | APFCON1,1 |   256  |  0x4000   |  28  |
; |   0x2C  |16F1789 |  32 words  |C6(25)/B6(39)|C7(26)/B7(40)| APFCON1,2 | APFCON1,1 |   256  |  0x4000   |  40  |
; +---------+--------+------------+-------------+-------------+-----------+-----------+--------+-----------+------+

        ;********************************************************************
	;	Tiny Bootloader		16F17xx series		Size=100words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;
	;	(2015.11.24 Revision 8)
	;
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
        ;********************************************************************

	#include "../spbrgselect.inc"

	#define first_address max_flash-100 ; 100 word in size

	   __CONFIG    _CONFIG1, _FOSC_INTOSC & _BOREN_OFF & _WDTE_OFF & _CP_OFF & _PWRTE_ON & _CPD_OFF & _MCLRE_ON  	
	   __CONFIG    _CONFIG2, _LVP_OFF &_STVREN_OFF &_BORV_LO &_PLLEN_OFF


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
	

#if (IdTypePIC==0x2C)
 RCREG	 EQU	RC1REG
 TXREG	 EQU	TX1REG
 SPBRGL	 EQU	SP1BRGL
 SPBRGH	 EQU	SP1BRGH
 RCSTA	 EQU	RC1STA
 TXSTA	 EQU	TX1STA
 BAUDCON EQU	BAUD1CON
#endif

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
;PC_EEPROM:   C1h          EEADRH  EEADRL  2  EEDATL  EEDATH(=0)    crc
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

	movlb	0x02			;BANK2

 #ifdef CHANGE_TX
	bsf	FVRCON+6,TXSEL		;APFCON.or.APFCON1
 #else
	bcf	FVRCON+6,TXSEL
 #endif

 #ifdef CHANGE_RX
	bsf	FVRCON+6,RXSEL		;APFCON.or.APFCON1
 #else
	bcf	FVRCON+6,RXSEL
 #endif

	movlb	0x03			;BANK3
	clrf	ANSELB
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
	movwf	EEADR

	call	FSReceive		;count
	movwf	contor
	movwf	i
;	movlw	buffer
;	movwf	FSR0L

rcvoct:
	call	Receive			;data
	movwi	INDF0++
	decfsz	i,f
	bra	rcvoct

	call	FSReceive		;crc
ziieroare:
	movlw 	'N'
	skpz
	bra	mainl
					;write
;	movlw	buffer
;	movwf	FSR0L

writeloop:				;write 2 bytes = 1 instruction
	moviw	INDF0++
	movwf	EEDATL
	moviw	INDF0++
	movwf	EEDATH

	btfsc	contor,6		;if writing to EEPROM, skip erase operation.
	call	wr_e 			;erase operation
	call	wr_w			;write operation
	incf	EEADRL,f		;does not cross zones
	decf	contor,f
	decfsz	contor,f
	bra	writeloop
	bra	MainLoop


FSReceive
	movlw	buffer
	movwf	FSR0L
Receive
	movlw	xtal/2000000+1		;for 20MHz => 11 => 1second
	movwf	cnt1
rpt2
	clrf	cnt2
rpt3
	clrf	cnt3
rptc
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
way_to_exit				;exit in all other cases; must be BANK3
	bcf	RCSTA,SPEN		;deactivate UART
	movlb	0x00			;BANK0
	clrf	PCLATH
	bra	first_address		; PCLATH=0, Please do not change the GOTO instruction.

wr_e
	bsf 	EECON1,FREE
wr_w
;	bcf 	EECON1,CFGS 		;Deselect Config space
;	bcf	EECON1,EEPGD
	btfss	flag,6			;is eeprom (or flash)
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

         end
