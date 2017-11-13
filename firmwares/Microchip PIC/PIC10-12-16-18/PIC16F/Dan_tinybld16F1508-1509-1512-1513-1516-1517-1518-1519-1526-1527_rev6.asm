	radix 	DEC
        
	; change these lines accordingly to your application	
#include "p16f1508.inc"
IdTypePIC = 0x27		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x1000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below

#define PDIP    20		; PIN Count of Device (20/28/40/64), Please refer to the table below
	
xtal 	EQU 	16000000	; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

 #if (PDIP==64)
;	#define	USE_TXRX2	; TX,RX Bit Change from default (16F1527/28), Please refer to the table
 #endif
;   The above 9 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+--------+--------+-------+-------+-----------+--------+------+
; |IdTypePIC| Device | Erase_Page | TX/TX1 | RX/RX1 |  TX2  |  RX2  | max_flash | EEPROM | PDIP |
; +---------+--------+------------+--------+--------+-------+-------+-----------+--------+------+
; |   0x27  |16F1508 |  32 words  | B7(7)  | B5(9)  |       |       |  0x1000   |    0   |  20  |
; |   0x29  |16F1509 |  32 words  | B7(7)  | B5(9)  |       |       |  0x2000   |    0   |  20  |
; |   0x25  |16F1512 |  32 words  | C6(17) | C7(18) |       |       |  0x0800   |    0   |  28  |
; |   0x27  |16F1513 |  32 words  | C6(17) | C7(18) |       |       |  0x1000   |    0   |  28  |
; |   0x29  |16F1516 |  32 words  | C6(17) | C7(18) |       |       |  0x2000   |    0   |  28  |
; |   0x29  |16F1517 |  32 words  | C6(25) | C7(26) |       |       |  0x2000   |    0   |  40  |
; |   0x2B  |16F1518 |  32 words  | C6(17) | C7(18) |       |       |  0x4000   |    0   |  28  |
; |   0x2B  |16F1519 |  32 words  | C6(25) | C7(26) |       |       |  0x4000   |    0   |  40  |
; |   0x29  |16F1526 |  32 words  | C6(31) | C7(32) | G1(4) | G2(5) |  0x2000   |    0   |  64  |
; |   0x2B  |16F1527 |  32 words  | C6(31) | C7(32) | G1(4) | G2(5) |  0x4000   |    0   |  64  |
; +---------+--------+------------+--------+--------+-------+-------+-----------+--------+------+

; +----------+------+----------+------+----------+------+
; | register | BANK | register | BANK | register | BANK |
; +----------+------+----------+------+----------+------+
; | PMCON1/2 |  3   |PMADRL/DAT|  3   | ANSELA   |  3   |
; +----------+------+----------+------+----------+------+

        ;********************************************************************
	;	Tiny Bootloader		16F15xx series		Size=100words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;
	;	(2014.06.09  Revision 6)
	;
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
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
;PC_flash:    	C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
;PIC_response:  id   K                                                 K

	org 	first_address
;	nop
;	nop
;	nop
;	nop

	org 	first_address+4
IntrareBootloader:
	movlp	(max_flash>>8)-1
                                        ;init int clock & serial port

 #ifdef USE_TXRX2
	movlw	PIR1+3			;FSR0=0x0014(PIR4)
	movwf	FSR0L
	bsf	FSR1H,2			;FSR1=0x0491(RC2REG)
	movlw	0x91
	movwf	FSR1L
 #else
	movlw	PIR1			;FSR0=0x0011(PIR1)
	movwf	FSR0L
	bsf	FSR1H,0			;FSR1=0x0199(RC1REG)
	movlw	0x99
	movwf	FSR1L
 #endif
					;init int clock & serial port
	movlb	0x01			;BANK1
	bsf	OSCCON,6		;internal clock 16MHz

	movlb	0x03			;BANK3

 #if (PDIP==20)
	clrf	ANSELB
 #else
	clrf	ANSELC
 #endif

	movlw	b'00100100'
	movwi	5[INDF1]		;TX1STA.or.TX2STA
	movlw	spbrg_value
	movwi	2[INDF1]		;SP1BRGL.or.SP1BRGL
	movlw	b'10010000'
	movwi	4[INDF1]		;RC1STA.or.RC2STA
					;wait for computer
	call	Receive
	sublw	0xC1			;Expect C1
	skpz
	bra	way_to_exit

	movlw 	IdTypePIC		;PIC type
	movwi	1[INDF1]		;TX1REG.or.TX2REG
;	SendL	IdSoftVer		;firmware ver x

MainLoop:
	movlw 	'B'
mainl:
	movwi	1[INDF1]		;TX1REG.or.TX2REG
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
	btfss 	INDF0,5			;test RX
	bra 	$+4			;not recive
	moviw 	0[INDF1]		;read RCREG,return in w
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
