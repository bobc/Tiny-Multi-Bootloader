	radix DEC
	
	; change these lines accordingly to your application	
#include "p18f23k22.inc"
IdTypePIC = 0x61		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x2000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below
#define	SELECTEUSART 1		; EUSART(1/2), Please refer to the table below
#define	EEPROMSIZE 256		; Size of EEPROM (256/1024), Please refer to the table below
	
xtal 	EQU 	16000000	; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

;   The above 7 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+
; |IdTypePIC| Device | Write_Page | Erase_Page |   TX1/TX2   |   RX1/RX2   | max_flash | EEPROM | PDIP |
; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+
; |   0x61  |18F23K22|  32 words  |  32 words  |C6(17)/B6(27)|C7(18)/B7(28)|   0x2000  |   256  |  28  |
; |   0x61  |18F43K22|  32 words  |  32 words  |C6(25)/D6(29)|C7(26)/D7(30)|   0x2000  |   256  |  40  |
; |   0x62  |18F24K22|  32 words  |  32 words  |C6(17)/B6(27)|C7(18)/B7(28)|   0x4000  |   256  |  28  |
; |   0x62  |18F44K22|  32 words  |  32 words  |C6(25)/D6(29)|C7(26)/D7(30)|   0x4000  |   256  |  40  |
; |   0x64  |18F25K22|  32 words  |  32 words  |C6(17)/B6(27)|C7(18)/B7(28)|   0x8000  |   256  |  28  |
; |   0x64  |18F45K22|  32 words  |  32 words  |C6(25)/D6(29)|C7(26)/D7(30)|   0x8000  |   256  |  40  |
; |   0x66  |18F26K22|  32 words  |  32 words  |C6(17)/B6(27)|C7(18)/B7(28)|  0x10000  |  1024  |  28  |
; |   0x66  |18F46K22|  32 words  |  32 words  |C6(25)/D6(29)|C7(26)/D7(30)|  0x10000  |  1024  |  40  |
; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+

 #IF (SELECTEUSART == 1)
#define _TXSTA TXSTA1
#define _SPBRG SPBRG1
#define _RCSTA RCSTA1
#define _TXREG TXREG1
#define _RCREG RCREG1
#define _PIR PIR1
#define _RCIF RC1IF
 #ELSE
#define _TXSTA TXSTA2
#define _SPBRG SPBRG2
#define _RCSTA RCSTA2
#define _TXREG TXREG2
#define _RCREG RCREG2
#define _PIR PIR3
#define _RCIF RC2IF
 #ENDIF

        ;********************************************************************
	;	Tiny Bootloader		18F2XK22/18F4XK22 	Size=100words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	(2015.03.22 Revision 4)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
        ;********************************************************************

	#include "../spbrgselect.inc"	; RoundResult and baud_rate

		#define first_address max_flash-200		;100 words

			config FOSC = INTIO67		;Internal oscillator block, port function on RA6 and RA7
			config PLLCFG = OFF		;Oscillator used directly
			config PRICLKEN = ON		;Primary clock enabled
			config FCMEN = OFF		;Fail-Safe Clock Monitor disabled
			config IESO = OFF		;Oscillator Switchover mode disabled
			config PWRTEN = ON		;PWRT enabled
			config BOREN = OFF		;Brown-out Reset disabled in hardware and software
			config BORV = 190		;VBOR set to 1.90 V nominal
			config WDTEN = OFF		;WDT is controlled by SWDTEN bit of the WDTCON register
			config WDTPS = 1		;Watchdog Timer Postscale Select bits 1:1
			config CCP2MX = PORTC1		;CCP2 input/output is multiplexed with RC1
			config PBADEN = OFF		;PORTB<4:0> pins are configured as digital I/O on Reset
			config CCP3MX = PORTB5		;P3A/CCP3 input/output is multiplexed with RB5
			config P2BMX = PORTB5		;P2B is on RB5
			config MCLRE = EXTMCLR		;MCLR pin enabled RA3 input pin disabled
			config STVREN = OFF		;Stack full/underflow will not cause Reset
			config LVP = OFF		;Single-Supply ICSP disabled
			config XINST = OFF		;Instruction set extension and Indexed Addressing mode disabled (Legacy mode)
			config DEBUG = OFF		;Background debugger disabled, RA0 and RA1 configured as general purpose I/O pins
			config CP0 = OFF		;Block 0 not code-protected
			config CP1 = OFF		;Block 1 not code-protected
			config CPB = OFF		;Boot block not code-protected
			config CPD = OFF		;Data EEPROM not code-protected
			config WRT0 = OFF		;Block 0 not write-protected
			config WRT1 = OFF		;Block 1 not write-protected
			config WRTC = OFF		;Configuration registers not write-protected
			config WRTB = OFF		;Boot block not write-protected
			config WRTD = OFF		;Data EEPROM not write-protected
			config EBTR0 = OFF		;Block 0 not protected from table reads executed in other blocks
			config EBTR1 = OFF		;Block 1 not protected from table reads executed in other blocks
			config EBTRB = OFF		;Boot block not protected from table reads executed in other blocks

;----------------------------- PROGRAM ---------------------------------
	cblock 0
	buffer:64
	crc
	i
	cnt1
	cnt2
	cnt3
	flag
	count
	endc
	
;0000000000000000000000000 RESET 00000000000000000000000000

		ORG     0x0000
		GOTO    IntrareBootloader

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;PC_flash:		C1h		U		H		L		64  ...  <64 bytes>   ...  crc
;PC_eeprom:		C1h		40h   		EEADRH  	EEADR     	1       EEDATA		crc
;PC_cfg			C1h		U OR 80h	H		L		14  ... <14 bytes>   ...  crc
;PIC_response:	   type `K`
	
	ORG first_address			;space to deposit first 4 instr. of user prog.
	nop
	nop
	nop
	nop

	org first_address+8
IntrareBootloader:
						;skip TRIS to 0 C6
	bsf	OSCCON,IRCF2			;int clock 16MHz
	movlb	.15				;bank0 -> bank15
	clrf	ANSELC,BANKED	  		; setup digital I/O
	clrf	(ANSELC+1),BANKED		; setup digital I/O (ANSELD)
	movlb	.0				;bank15 -> bank0
	movlw 	((1<<TXEN) | (1<<BRGH))		;init serial port
	movwf 	_TXSTA
	;use only SPBRG (8 bit mode default) not using BAUDCON
	movlw	spbrg_value
	movwf	_SPBRG
	movlw	((1<<SPEN) | (1<<CREN))
	movwf	_RCSTA
						;wait for computer
	rcall 	Receive
	sublw 	0xC1				;Expect C1h
	bnz 	way_to_exit
	movlw   IdTypePIC			;send PIC type
	movwf   _TXREG

MainLoop:
	movlw 	'C'				; "-Everything OK, ready and waiting."
mainl:
	movwf   _TXREG
	clrf 	crc
	rcall 	Receive				;Upper
	movwf 	TBLPTRU
	movwf 	flag				;(for EEPROM and CFG cases)
	rcall 	Receive				;Hi
	movwf 	TBLPTRH
 #IF (EEPROMSIZE == 1024)
	movwf 	EEADRH				;(for EEPROM case)
 #ENDIF
	rcall 	Receive				;Lo
	movwf 	TBLPTRL
	movwf 	EEADR				;(for EEPROM case)

	rcall 	Receive				;count
	movwf 	i
	movwf	count
	clrf	FSR0L				;FSR0=buffer TOP
rcvoct:						;read 64 bytes
	rcall 	Receive
	movwf 	POSTINC0
	movwf 	TABLAT				;prepare for cfg; => store byte before crc
	movwf 	EEDATA				;(for EEPROM case)
	decfsz 	i
	bra 	rcvoct
	
	rcall 	Receive				;get crc
ziieroare:					;CRC failed
	movlw	'N'
	bnz	mainl

	btfss 	flag,6				;is EEPROM data?
	bra 	noeeprom
	movlw 	(1<<WREN)			;Setup eeprom
	rcall 	Write
	bra 	waitwre

noeeprom:
	clrf	FSR0L				;FSR0=buffer TOP
	btfss 	flag,7				;is CFG data?
	bra 	noconfig
	TBLRD*-					; point to adr-1
lp_noeeprom:
	rcall	put1byte
	rcall 	Write
	decfsz	count,f
	bra	lp_noeeprom
	bra 	waitwre

noconfig:
						;write
eraseloop:
	movlw	((1<<EEPGD) | (1<<FREE) | (1<<WREN))	; Setup erase
	rcall 	Write
	TBLRD*-					; point to adr-1
	
writebigloop:

writesloop:

writebyte:
	rcall	put1byte
	decfsz 	count				; 64 bytes?
	bra 	writebyte
	
	movlw	((1<<EEPGD) | (1<<WREN))	; Setup writes
	rcall 	Write

waitwre:
	;btfsc 	EECON1,WR			;for eeprom writes (wait to finish write)
	;bra 	waitwre				;no need: round trip time with PC bigger than 4ms
	
	bcf 	EECON1,WREN			;disable writes
	bra 	MainLoop
	

;******** procedures ******************

put1byte:
	movf	POSTINC0,w		; put 1 byte
	movwf	TABLAT
	tblwt+*
	retlw	((1<<EEPGD) | (1<<CFGS) | (1<<WREN))	;Setup cfg


Write:
	movwf	EECON1
	movlw	0x55
	movwf 	EECON2
	movlw 	0xAA
	movwf 	EECON2
	bsf 	EECON1,WR			;WRITE
	nop
	;nop
	return


Receive:
	movlw 	(xtal/2000000+1)		; for 20MHz => 11 => 1second delay
	movwf 	cnt1
rpt2:
	clrf 	cnt2
rpt3:
	clrf 	cnt3
rptc:
	btfss 	_PIR,_RCIF			;test RX
	bra 	notrcv
	movf 	_RCREG,w			;return read data in W
	addwf 	crc,f				;compute crc
	return
notrcv:
	decfsz 	cnt3
	bra 	rptc
	decfsz 	cnt2
	bra 	rpt3
	decfsz 	cnt1
	bra 	rpt2
	;timeout:
way_to_exit:
	bcf	_RCSTA,SPEN			; deactivate UART
	bra	first_address
;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

            END
