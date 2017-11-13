	radix DEC
	LIST  F=INHX8M 

	; change these lines accordingly to your application	
#include "p16f87.inc"
IdTypePIC = 0x33		; must exists in "piccodes.ini"			
#define max_flash 0x1000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)
xtal	EQU 8000000		; _INTRC_IO internal osc; can select other internal freq using OSCCON
baud	EQU 19200		; 
#define INTOSC			; Use Internal Oscillator
	; The above 6 lines can be changed and buid a bootloader for the desired frequency and PIC type

; +---------+--------+------------+------------+-----------+------+------+--------+------+
; |IcTypePIC| Device | Erase_Page | Write_Page | max_flash |  TX  |  RX  | EEPROM | PDIP |
; +---------+--------+------------+------------+-----------+------+------+--------+------+
; |   0x33  | 16F87  |  32 words  |  4 words   |  0x01000  |B5(11)| B2(8)|  256   |  18  |
; |   0x33  | 16F88  |  32 words  |  4 words   |  0x01000  |B5(11)| B2(8)|  256   |  18  |
; +---------+--------+------------+------------+-----------+------+------+--------+------+

; +----------+------+----------+------+ +----------+--------+
; | register | BANK | register | BANK | |subroutine|  BANK  |
; +----------+------+----------+------+ +----------+--------+
; | EECON1/2 |  3   |EEADRL/DAT|  2   | | Receive  | ->0->2 |
; +----------+------+----------+------+ +----------+--------+

	;********************************************************************
	;	Tiny Bootloader		16F87/88 series		Size=100words
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
	;********************************************************************

	#include "../spbrgselect.inc"
	#define first_address max_flash-100 ; 100 word in size

	__CONFIG    _CONFIG1, _INTRC_IO & _WDTE_OFF & _PWRTE_ON & _MCLR_OFF & _BODEN_OFF & _LVP_OFF & _CPD_OFF & _WRT_PROTECT_OFF & _DEBUG_OFF & _CCP1_RB0 & _CP_OFF
	__CONFIG    _CONFIG2, _FCMEN_OFF & _IESO_OFF

	errorlevel 1, -305
	
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

;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;
;PC_flash:    C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
;PC_EEPROM:   C1h          EEADRH  EEADRL  2  EEDATL  EEDATH(=0)    crc
;PIC_response:   id   K                                                 K
	
	ORG first_address
	nop
	nop
	nop
	nop

	org first_address+4
IntrareBootloader:
				;init serial port,Oscillator
	bsf	STATUS,RP0	;bank  0->1
	movlw	b'00100100'
	movwf	TXSTA
	movlw	spbrg_value
	movwf	SPBRG

 #ifdef INTOSC
	movlw	b'01111000'	;osc internal 8 Mhz
	movwf	OSCCON
	movlw	xtal/8000000+1	;uart is not started yet
	call	UARTDelay	;for _HS_OSC mode this delay is not necessary
 #endif

	clrf	STATUS		;bank  0
	movlw	b'10010000'
	movwf	RCSTA
				;wait for computer
	call	Receive
	clrf	STATUS		;bank  2->0
	sublw	0xC1		;Expect C1
	skpz
	goto	way_to_exit

	movlw	IdTypePIC	;PIC type
	movwf	TXREG
	;SendL	IdSoftVer	;firmware ver x

MainLoop:
	movlw	'B'
mainl:
	clrf	STATUS		;bank  0
	movwf	TXREG
	clrf	crc
	call	Receive		;H
	movwf	EEADRH
	movwf	flag
	call	Receive		;L
	movwf	EEADR

	call	FSReceive	;count
	movwf	contor		;=2,eeprom  =64,flash
	movwf	i
;	movlw	buffer
;	movwf	FSR
rcvoct:
	call	Receive
	movwf	INDF
	incf	FSR,f
	decfsz	i,f
	goto	rcvoct

	call	FSReceive
ziieroare:
	movlw	'N'
	skpz			;check checksum
	goto	mainl
				;write
;	movlw	buffer
;	movwf	FSR

writeloop:                      ;write 2 bytes = 1 instruction
        movf    INDF,w          ;L
        movwf   EEDATA
	incf	FSR,f
        movf    INDF,w          ;H
        movwf   EEDATH
	incf	FSR,f

	bsf	STATUS,RP0	;bank  2->3
	btfsc	contor,6	;erase if EEADRL=B'XXX00000'
        call    wr_e            ;erase operation
	nop
        call    wr_w            ;write operation
writel:
	bcf	STATUS,RP0	;bank  3->2
        incf    EEADR,f         ;does not cross zones
	decf	contor,f
	decfsz	contor,f
        goto    writeloop
        goto    MainLoop


wr_e:
	bsf	EECON1,FREE
wr_w:
	btfss	flag,6		;if writing to EEPROM, skip EEPGD set.
	bsf	EECON1,EEPGD
	goto	$+1
	bsf	EECON1,WREN
        movlw   0x55
        movwf   EECON2
        movlw   0xaa
        movwf   EECON2
        bsf     EECON1,WR	;WR=1
        nop
        nop
	clrf	EECON1
	return


FSReceive:
	movlw	buffer
	movwf	FSR
Receive:
	movlw	xtal/2000000+1	;for 20MHz => 11 => 1second
UARTDelay:
	clrf	STATUS		;bank  0
	movwf	cnt1
rpt2:
	clrf	cnt2
rpt3:
	clrf	cnt3
rptc:
	btfss 	PIR1,RCIF	;test RX
	goto 	$+5
	movf 	RCREG,w		;return in W
	addwf	crc,f		;compute crc
	bsf	STATUS,RP1	;bank  0->2
	return

	decfsz	cnt3,f
	goto	rptc
	decfsz	cnt2,f
	goto	rpt3
	decfsz	cnt1,f
	goto	rpt2

 #ifdef INTOSC
	btfss	RCSTA,SPEN
	return			;UARTDelay return
 #endif

way_to_exit:			;timeout:
	bcf	RCSTA,SPEN	;deactivate UART
        goto    first_address	;timeout:exit in all other cases

;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

            END
