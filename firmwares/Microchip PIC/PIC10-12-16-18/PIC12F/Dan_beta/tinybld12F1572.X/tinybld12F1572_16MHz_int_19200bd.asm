	radix 	DEC
        
	; change these lines accordingly to your application	

	#include "p12f1572_1.inc"
IdTypePIC = 0x1A		; Please refer to the table below, must exists in "piccodes.ini"	
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
; |   0x1A  |12F1572 |  16 words  | A0(7)/A4(3) | A1(6)/A5(2) | APFCON ,2 | APFCON ,7 |   0x0800  |    0   |   8  |
; +---------+--------+------------+-------------+-------------+-----------+-----------+-----------+--------+------+

; +----------+------+----------+------+
; | register | BANK | register | BANK |
; +----------+------+----------+------+
; | PMCON1/2 |  3   |PMADRL/DAT|  3   |
; +----------+------+----------+------+
; | ANSELA   |  3   |
; +----------+------+

        ;********************************************************************
	;	Tiny Bootloader		12F1572	 		Size=84words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	(2014.06.09 Revision 1)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	$1A, B, 12F 1572(84W), 		$1000, 0, 168, 32,
	;
        ;********************************************************************

	#include "spbrgselect.inc"

	#define first_address max_flash-84 ; 84 word in size

	   __CONFIG    _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _BOREN_OFF
	   __CONFIG    _CONFIG2, _WRT_OFF & _PLLEN_ON &_STVREN_OFF & _BORV_LO & _LPBOREN_OFF & _LVP_OFF


	errorlevel 1, -305		; suppress warning msg that takes f as default

	
	cblock 0x7C
	crc
	cnt1
	cnt2
	cnt3
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
;PIC_response:   id   K                                                 K

	org 	first_address
;	nop
;	nop
;	nop
;	nop

	org 	first_address+4
IntrareBootloader:

	movlp	(max_flash>>8)-1	;set PAGE
	movlw	PIR1			;FSR1=PIR1
	movwf	FSR1L
					;init int clock & serial port
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
	movwf	PMADRH
	call	Receive			;L
	movwf	PMADRL
	call	Receive			;count (Receive Only)

rcvoct:
	call	Receive			;data L
	movwf	PMDATL
	call	Receive			;data H
	movwf	PMDATH
	call	wr_l			;write Latches (Return w=0x01)
	addwf	PMADRL,f
	skpdc				;skip if PMADRL=B'XXXX0000'
	bra	rcvoct

	call	Receive			;get SUM
ziieroare:
	movlw 	'N'
	skpz 				;check SUM
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

way_to_exit:				;communication error; must be BANK3
	bcf	RCSTA,SPEN		;deactivate UART
	movlb	0x00			;BANK0
	movlp	0x00			;PAGE0
	bra	first_address		;PAGE=0, Please do not change the GOTO instruction.

wr_e:
	bsf 	PMCON1,FREE
wr_l:
	bsf 	PMCON1,LWLO
wr_w:
	bsf	PMCON1,WREN
	movlw	0x55
	movwf	PMCON2
	movlw	0xaa
	movwf	PMCON2	
	bsf	PMCON1,WR
	nop
	nop
	clrf	PMCON1
	retlw	0x01

;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

         end
