	radix 	DEC
        
	; change these lines accordingly to your application	
#include "p16f1827.inc"
IdTypePIC = 0x28		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x1000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below

#define PDIP       18		; PIN Count of Device (8/14/18/20), Please refer to the table below
	
xtal 	EQU 	16000000	; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

;	#define	CHANGE_TX	;TX Bit Change from default, Please refer to the table below
;	#define	CHANGE_RX	;RX Bit Change from default, Please refer to the table below

;   The above 9 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+-------------+-------------+-----------+-----------+-----------+--------+------+
; |IdTypePIC| Device | Erase_Page |   TX bit    :   RX bit    |  TXCKSEL  |  RXDTSEL  | max_flash | EEPROM | PDIP |
; |         |        |            | default(Pin)/changed(Pin) |           |           |           |        |      |
; +---------+--------+------------+-------------+-------------+-----------+-----------+-----------+--------+------+
; |   0x28  |16F1824 |  32 words  | C4(6)/A0(13)| C5(5)/A1(12)| APFCON0,2 | APFCON0,7 |  0x1000   |   256  |  14  |
; |   0x2A  |16F1825 |  32 words  | C4(6)/A0(13)| C5(5)/A1(12)| APFCON0,2 | APFCON0,7 |  0x2000   |   256  |  14  |
; |   0x26  |16F1826 |  32 words  | B2(8)/B5(11)| B1(7)/B2(8) | APFCON1,0 | APFCON0,7 |  0x0800   |   256  |  18  |
; |   0x28  |16F1827 |  32 words  | B2(8)/B5(11)| B1(7)/B2(8) | APFCON1,0 | APFCON0,7 |  0x1000   |   256  |  18  |
; |   0x28  |16F1828 |  32 words  |B7(10)/C4(6) |B5(12)/C5(5) | APFCON0,2 | APFCON0,7 |  0x1000   |   256  |  20  |
; |   0x2A  |16F1829 |  32 words  |B7(10)/C4(6) |B5(12)/C5(5) | APFCON0,2 | APFCON0,7 |  0x2000   |   256  |  20  |
; |   0x15  |12F1840 |  32 words  | A0(7)/A4(3) | A1(6)/A5(2) | APFCON ,2 | APFCON ,7 |  0x1000   |   256  |   8  |
; |   0x2A  |16F1847 |  32 words  | B2(8)/B5(11)| B1(7)/B2(8) | APFCON1,0 | APFCON0,7 |  0x2000   |   256  |  18  |
; +---------+--------+------------+-------------+-------------+-----------+-----------+-----------+--------+------+

        ;********************************************************************
	;	Tiny Bootloader		12F18xx 16F18xx series	Size=100words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;
	;	(2015.11.24 Revision 11)
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

 #if (PDIP==18)
  #ifdef CHANGE_TX
	bsf	APFCON0+1,0		;APFCON1(0x011E)
  #else
	bcf	APFCON0+1,0
  #endif
 #else
  #ifdef CHANGE_TX
	bsf	APFCON0,2
  #else
	bcf	APFCON0,2
  #endif
 #endif

 #ifdef CHANGE_RX
	bsf	APFCON0,RXDTSEL
 #else
	bcf	APFCON0,RXDTSEL
 #endif

	movlb	0x03			;BANK3

 #if ((PDIP==18) | (PDIP==20))
	clrf	ANSELA+1		;ANSELB(0x018D)
 #else
	clrf	ANSELA
 #endif

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


FSReceive:
	movlw	buffer
	movwf	FSR0L
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
	bcf	RCSTA,SPEN		;deactivate UART
	movlb	0x00			;BANK0
	clrf	PCLATH
	bra	first_address		; PCLATH=0, Please do not change the GOTO instruction.

wr_e:
	bsf 	EECON1,FREE
wr_w:
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
