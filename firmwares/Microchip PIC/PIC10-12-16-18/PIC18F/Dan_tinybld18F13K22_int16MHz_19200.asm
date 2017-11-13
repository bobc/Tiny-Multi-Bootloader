	radix DEC
	
	; change these lines accordingly to your application	
#include "p18f13k22.inc"
IdTypePIC = 0x61		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x2000	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below
#define	Write_Page 4	        ; Write Page          (4/8), Please refer to the table below
	
xtal 	EQU 	16000000	; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

;   The above 6 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+
; |IdTypePIC| Device | Write_Page | Erase_Page |   TX bit    |   RX bit    | max_flash | EEPROM | PDIP |
; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+
; |   0x61  |18F13K22|   4 words  |  32 words  |    B7(10)   |    B5(12)   |  0x2000   |   256  |  20  |
; |   0x62  |18F14K22|   8 words  |  32 words  |    B7(10)   |    B5(12)   |  0x4000   |   256  |  20  |
; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+

        ;********************************************************************
	;	Tiny Bootloader		18F13K22/18F14K22 	Size=100words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	(2013.08.28 Revision 1)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
        ;********************************************************************

	#include "../spbrgselect.inc"	; RoundResult and baud_rate

		#define first_address max_flash-200		;100 words

			config FOSC = IRC		;Internal RC oscillator
			config PLLEN = OFF		;PLL is under software control
			config PCLKEN = OFF		;Primary clock is under software control
			config FCMEN = OFF		;Fail-Safe Clock Monitor disabled
			config IESO = OFF		;Oscillator Switchover mode disabled
			config PWRTEN = ON		;PWRT enabled
			config BOREN = OFF		;Brown-out Reset disabled in hardware and software
			config BORV = 19		;VBOR set to 1.9 V nominal
			config WDTEN = OFF		;WDT is controlled by SWDTEN bit of the WDTCON register
			config WDTPS = 1		;Watchdog Timer Postscale Select bits 1:1
			config HFOFST = OFF		;The system clock is held off until the HFINTOSC is stable.
			config MCLRE = ON		;MCLR pin enabled RA3 input pin disabled
			config STVREN = OFF		;Stack full/underflow will not cause Reset
			config LVP = OFF		;Single-Supply ICSP disabled
			config BBSIZ = OFF		;1kW boot block size
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
	clrf	ANSEL	  			; setup digital I/O

	movlw 	((1<<TXEN) | (1<<BRGH))		;init serial port
	movwf 	TXSTA
	;use only SPBRG (8 bit mode default) not using BAUDCON
	movlw	spbrg_value
	movwf	SPBRG
	movlw	((1<<SPEN) | (1<<CREN))
	movwf	RCSTA
	movlw 0x07 ;clear Analog port 11 bit, rest (8,9,10) as after hard reset
	movwf ANSELH ; configure as expected.
						;wait for computer
	rcall 	Receive
	sublw 	0xC1				;Expect C1h
	bnz 	way_to_exit
	movlw   IdTypePIC			;send PIC type
	movwf   TXREG

MainLoop:
	movlw 	'C'				; "-Everything OK, ready and waiting."
mainl:
	movwf   TXREG
	clrf 	crc
	rcall 	Receive				;Upper
	movwf 	TBLPTRU
	movwf 	flag				;(for EEPROM and CFG cases)
	rcall 	Receive				;Hi
	movwf 	TBLPTRH
;;	movwf 	EEADRH				;(for EEPROM case)
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
 #IF (Write_Page == 8)
	bsf 	i,4				; 16bytes
 #ELSE
	bsf 	i,3				; 8bytes
 #ENDIF
writebyte:
	rcall	put1byte
	decfsz 	i
	bra 	writebyte
	
	movlw	((1<<EEPGD) | (1<<WREN))	; Setup writes
	rcall 	Write
	btfss	FSR0L,6				; FSR0=64?
	bra 	writesloop

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
	btfss 	PIR1,RCIF			;test RX
	bra 	notrcv
	movf 	RCREG,w				;return read data in W
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
	bcf	RCSTA,SPEN			; deactivate UART
	bra	first_address
;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

            END
