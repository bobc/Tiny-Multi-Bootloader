	radix DEC
	
	; change these lines in accordance to your application	
#include "p18f24k50.inc"
IdTypePIC = 0x62		; must exists in "piccodes.ini"
#define max_flash 0x4000	; in BYTES!!! (= 'max flash memory' from "piccodes.ini")

xtal EQU 16000000		; 'xtal' here is resulted frequency (is no longer quartz frequency)
baud EQU 19200			; the desired baud rate
	; The above 5 lines can be changed and buid a bootloader for the desired frequency and PIC type
	
	;********************************************************************
	;	Tiny Bootloader	    18F24K50 18F25K50 18F45K50  Size=100words
	;	claudiu.chiculita@ugal.ro
	;	http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;********************************************************************

; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+
; |IdTypePIC| Device | Write_Page | Erase_Page |   TX bit    |   RX bit    | max_flash | EEPROM | PDIP |
; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+
; |   0x62  |18F24K50|  32 words  |  32 words  |    C6(17)   |    C7(18)   |   0x4000  |   256  |  28  |
; |   0x64  |18F25K50|  32 words  |  32 words  |    C6(17)   |    C7(18)   |   0x8000  |   256  |  28  |
; |   0x64  |18F45K50|  32 words  |  32 words  |    C6(25)   |    C7(26)   |   0x8000  |   256  |  40  |
; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+

	#include "../../spbrgselect.inc"	; RoundResult and baud_rate

		#define first_address max_flash-200		;=100 words

    		CONFIG	PLLSEL = PLL4X		;4x clock multiplier
    		CONFIG	CFGPLLEN = OFF		;PLL Disabled (firmware controlled)
    		CONFIG	CPUDIV = NOCLKDIV	;CPU uses system clock (no divide)
    		CONFIG	LS48MHZ = SYS24X4	;System clock at 24 MHz, USB clock divider is set to 4
    		CONFIG	FOSC = INTOSCIO		;Internal oscillator
    		CONFIG	PCLKEN = ON		;Primary oscillator enabled
    		CONFIG	FCMEN = OFF		;Fail-Safe Clock Monitor disabled
    		CONFIG	IESO = OFF		;Oscillator Switchover mode disabled
    		CONFIG	nPWRTEN = ON		;Power up timer enabled
    		CONFIG	BOREN = OFF		;BOR disabled in hardware (SBOREN is ignored)
		CONFIG	BORV = 190		;BOR set to 1.9V nominal
		CONFIG	nLPBOR = OFF		;Low-Power Brown-out Reset disabled
		CONFIG	WDTEN = OFF		;WDT disabled in hardware (SWDTEN ignored)
		CONFIG	WDTPS = 1            	;1:1
		CONFIG	CCP2MX = RC1		;CCP2 input/output is multiplexed with RC1
		CONFIG	PBADEN = OFF		;PORTB<5:0> pins are configured as digital I/O on Reset
		CONFIG	T3CMX = RC0		;T3CKI function is on RC0
		CONFIG	SDOMX = RB3		;SDO function is on RB3
		CONFIG	MCLRE = ON		;MCLR pin enabled RE3 input pin disabled
		CONFIG	STVREN = OFF		;Stack full/underflow will not cause Reset
		CONFIG	LVP = OFF		;Single-Supply ICSP disabled
		CONFIG	ICPRT = OFF		;ICPORT disabled
		CONFIG	XINST = OFF		;Instruction set extension and Indexed Addressing mode disabled
		CONFIG	DEBUG = OFF		;Background debugger disabled, RB6 and RB7 configured as general purpose I/O pins
		CONFIG	CP0 = OFF		;Block 0 (000800-001FFFh) or (001000-001FFFh) is not code-protected
		CONFIG	CP1 = OFF		;Block 1 (002000-003FFFh) is not code-protected
		CONFIG	CPB = OFF		;Boot block (000000-0007FFh) or (000000-000FFFh) is not code-protected
		CONFIG	WRT0 = OFF		;Block 0 (000800-001FFFh) or (001000-001FFFh) is not write-protected
		CONFIG	WRT1 = OFF		;Block 1 (002000-003FFFh) is not write-protected
		CONFIG	WRTC = OFF		;Configuration registers (300000-3000FFh) are not write-protected
		CONFIG	WRTB = OFF		;Boot block (000000-0007FFh) or (000000-000FFFh) is not write-protected
		CONFIG	EBTR0 = OFF		;Block 0 (000800-001FFFh) or (001000-001FFFh) is not protected from table reads executed in other blocks
		CONFIG	EBTR1 = OFF		;Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks
		CONFIG	EBTRB = OFF		;Boot block (000000-0007FFh) or (000000-000FFFh) is not protected from table reads executed in other blocks

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
	
	ORG first_address		;space to deposit first 4 instr. of user prog.
	nop
	nop
	nop
	nop

	org first_address+8
IntrareBootloader:
					;skip TRIS to 0 C6
	bsf	OSCCON,IRCF2		;int clock 16MHz
	clrf	ANSELC	  		; setup digital I/O
					;init serial port
	movlw 	((1<<TXEN) | (1<<BRGH))
	movwf	TXSTA
	;use only SPBRG (8 bit mode default) not using BAUDCON
	movlw	spbrg_value
	movwf	SPBRG
	movlw	((1<<SPEN) | (1<<CREN))
	movwf	RCSTA
					;wait for computer
	rcall	Receive
	sublw	0xC1			;Expect C1h
	bnz	way_to_exit
	movlw	IdTypePIC		;send PIC type
	movwf	TXREG

MainLoop:
	movlw	'C'			; "-Everything OK, ready and waiting."

mainl:
	movwf	TXREG
	clrf	crc
	rcall	Receive			;Upper
	movwf	TBLPTRU
	movwf	flag			;(for EEPROM and CFG cases)
	rcall	Receive			;Hi
	movwf	TBLPTRH
;;	movwf	EEADRH			;(for EEPROM case)
	rcall	Receive			;Lo
	movwf	TBLPTRL
	movwf	EEADR			;(for EEPROM case)

	rcall	Receive			;count
	movwf	i
	movwf	count
	clrf	FSR0L			;FSR0=buffer TOP
rcvoct:					;read 64 bytes
	rcall	Receive
	movwf	POSTINC0
	movwf	TABLAT			;prepare for cfg; => store byte before crc
	movwf	EEDATA			;...then store the data byte (and not the CRC!)
	decfsz	i
	bra	rcvoct

	rcall	Receive			;check crc
ziieroare:				;CRC failed
	movlw	'N'
	bnz	mainl

	btfss	flag,6			;is EEPROM data?
	bra	noeeprom
	movlw	(1<<WREN)		;Setup eeprom
	rcall	Write
	bra	waitwre

noeeprom:
	clrf	FSR0L			;FSR0=buffer TOP
	btfss	flag,7			;is CFG data?
	bra	noconfig
	TBLRD*-				; point to adr-1
lp_noeeprom:
	rcall	put1byte
	rcall	Write
	decfsz	count,f
	bra	lp_noeeprom
	bra	waitwre

noconfig:
					;write
eraseloop:
	movlw	((1<<EEPGD) | (1<<FREE) | (1<<WREN))	; Setup erase
	rcall	Write
	TBLRD*-				; point to adr-1
	
writebigloop:

writesloop:

writebyte:
	rcall	put1byte
	decfsz	count			; 64 bytes?
	bra	writebyte
	
	movlw	((1<<EEPGD) | (1<<WREN))	; Setup writes
	rcall	Write
	
waitwre:
	;btfsc	EECON1,WR		;for eeprom writes (wait to finish write)
	;bra	waitwre			;no need: round trip time with PC bigger than 4ms
	
	bcf	EECON1,WREN		;disable writes
	bra	MainLoop

;******** procedures ******************

put1byte:
	movf	POSTINC0,w		; put 1 byte
	movwf	TABLAT
	tblwt+*
	retlw	((1<<EEPGD) | (1<<CFGS) | (1<<WREN))	;Setup cfg


Write:
	movwf	EECON1
	movlw	0x55
	movwf	EECON2
	movlw	0xAA
	movwf	EECON2
	bsf	EECON1,WR		;WRITE
	nop
	;nop
	return

Receive:
	movlw	xtal/2000000+1		; for 20MHz => 11 => 1second delay
	movwf	cnt1
rpt2:
	clrf	cnt2
rpt3:
	clrf	cnt3
rptc:
	btfss	PIR1,RCIF		;test RX
	bra	notrcv
	movf	RCREG,w			;return read data in W
	addwf	crc,f			;compute crc
	return
notrcv:
	decfsz	cnt3
	bra	rptc
	decfsz	cnt2
	bra	rpt3
	decfsz	cnt1
	bra	rpt2
	;timeout:
way_to_exit:
	bcf	RCSTA,SPEN		; deactivate UART
	bra	first_address
;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

            END
