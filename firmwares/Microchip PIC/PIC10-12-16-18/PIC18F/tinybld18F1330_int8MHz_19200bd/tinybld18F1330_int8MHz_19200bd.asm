	radix DEC
	
	; change these lines accordingly to your application	
#include <p18f1330.inc>
IdTypePIC = 0x6B			; must exists in "piccodes.ini"

#define USE_INTOSC	; change frequency at line 85. If you use an external crystal, comment this line!
#define max_flash 0x2000	; in BYTES!!! (= 'max flash memory' from "piccodes.ini")
xtal EQU 8000000		; you may want to change:
	;oscil:	_HS_OSC_1H	HS extern
	;	_INTIO1_OSC_1H  Internal RC, OSC1 as RA7, OSC2 as Fosc/4
	;	_INTIO2_OSC_1H	Internal RC, OSC1 as RA7, OSC2 as RA6
baud EQU 19200			; standard TinyBld baud rates: 115200 or 19200
	; The above 5 lines can be changed and buid a bootloader for the desired frequency and PIC type
	
	;********************************************************************
	;	Tiny Bootloader		for 18F series		Size=100words
	;	claudiu.chiculita@ugal.ro
	;	http://www.ac.ugal.ro/staff/ckiku/software/picbootloader.htm
	; 
	; modified by Edorul:
	; EEPROM write is only compatible with "Tiny PIC Bootloader+"
	; http://sourceforge.net/projects/tinypicbootload/
	;********************************************************************
	

	#include "../../spbrgselect.inc"	; RoundResult and baud_rate

		#define first_address max_flash-200		;100 words

	config OSC = INTIO2	; Internal RC oscillator, port function on RA6 and port function on RA7  
	config FCMEN = OFF
	config IESO = OFF	; Oscillator Switchover mode disabled  
	config PWRT = ON	; PWRT enabled  
	config BOR = BOACTIVE	; Brown-out Reset enabled in hardware only and disabled in Sleep mode (SBOREN is disabled)  
	config BORV = 2
	config WDT = OFF
	config PWMPIN = OFF	; PWM outputs disabled upon Reset  
	config LPOL = HIGH	; PWM0, PWM2 and PWM4 are active-high (default) 
	config HPOL = HIGH	; PWM1, PWM3 and PWM5 are active-high (default) 
;	config FLTAMX = RA7	; FLTA input is muxed onto RA7 
;	config T1OSCMX = LOW	; T1OSO/T1CKI pin resides on RB2  
	config MCLRE = ON	; MCLR pin enabled, RA5 input pin disabled  
	config STVREN = ON	; Reset on stack overflow/underflow enabled  
	config BBSIZ = BB256	; 256 Words (512 Bytes) Boot Block size 
	config XINST = OFF	; Instruction set extension and Indexed Addressing mode disabled  
	config CP0 = OFF
	config CP1 = OFF
	config CPB = OFF
	config CPD = OFF
	config WRT0 = OFF
	config WRT1 = OFF
	config WRTB = OFF
	config WRTC = OFF
	config WRTD = OFF
	config EBTR0 = OFF
	config EBTR1 = OFF
	config EBTRB = OFF
                                               

;----------------------------- PROGRAM ---------------------------------
	cblock 0
	crc
	i
	cnt1
	cnt2
	cnt3
	counter_hi
	counter_lo
	flag
	endc
	cblock 10
	buffer:64
	endc
	
SendL macro car
	movlw car
	movwf TXREG
	endm
	
;0000000000000000000000000 RESET 00000000000000000000000000

		ORG     0x0000
		GOTO    IntrareBootloader

;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;PC_flash:		C1h				U		H		L		x  ...  <64 bytes>   ...  crc	
;PC_eeprom:		C1h			   	40h   EEADRH  EEADR     1       EEDATA	crc					
;PC_cfg			C1h			U OR 80h	H		L		1		byte	crc
;PIC_response:	   type `K`
	
	ORG first_address		;space to deposit first 4 instr. of user prog.
	nop
	nop
	nop
	nop
	org first_address+8
IntrareBootloader
#ifdef USE_INTOSC							
	movlw 0x70	; internal 8MHz
	movwf OSCCON
	; the above 2 lines should be commented out for designs not using the internal oscilator
	; or for the chips without the internal oscilator
#endif
	movlw b'01100000'		
	movwf ADCON1			;disable analog on tx/rx 
							;init serial port
	movlw b'00100100'
	movwf TXSTA
	movlw spbrg_value
	movwf SPBRG
	movlw b'10010000'
	movwf RCSTA
							;wait for computer
	rcall Receive			
	sublw 0xC1				;Expect C1h
	bnz way_to_exit
	SendL IdTypePIC			;send PIC type
MainLoop
	SendL 'C'				; "-Everything OK, ready and waiting."
mainl
	clrf crc
	rcall Receive			;Upper
	movwf TBLPTRU
		movwf flag			;(for EEPROM and CFG cases)
	rcall Receive			;Hi
	movwf TBLPTRH
	rcall Receive			;Lo
	movwf TBLPTRL
		movwf EEADR			;(for EEPROM case)

	rcall Receive			;count
	movwf i
	incf i
	lfsr FSR0, (buffer-1)
rcvoct						;read 64+1 bytes
		movwf TABLAT		;prepare for cfg; => store byte before crc
	rcall Receive
	movwf PREINC0
	btfss i,0		;don't know for the moment but in case of EEPROM data presence...
		movwf EEDATA		;...then store the data byte (and not the CRC!)
	decfsz i
	bra rcvoct
	
	tstfsz crc				;check crc
	bra ziieroare
		btfss flag,6		;EEPROM data?
		bra noeeprom
		movlw b'00000100'	;Setup eeprom
		rcall Write
		bra waitwre

noeeprom
;----no CFG write in "Tiny PIC Bootloader+"
;		btfss flag,7		;is CFG data?
;		bra noconfig
;		tblwt*				;write TABLAT(byte before crc) to TBLPTR***
;		movlw b'11000100'	;Setup cfg
;		rcall Write
;		bra waitwre
;noconfig
;----
							;write
eraseloop
	movlw	b'10010100'		; Setup erase
	rcall Write
	TBLRD*-					; point to adr-1
	
writebigloop	
	movlw 8					; 8groups
	movwf counter_hi
	lfsr FSR0,buffer
writesloop
	movlw 8					; 8bytes = 4instr
	movwf counter_lo
writebyte
	movf POSTINC0,w			; put 1 byte
	movwf TABLAT
	tblwt+*
	decfsz counter_lo
	bra writebyte
	
	movlw	b'10000100'		; Setup writes
	rcall Write
	decfsz counter_hi
	bra writesloop
waitwre	
	;btfsc EECON1,WR		;for eeprom writes (wait to finish write)
	;bra waitwre			;no need: round trip time with PC bigger than 4ms
	
	bcf EECON1,WREN			;disable writes
	bra MainLoop
	
ziieroare					;CRC failed
	SendL 'N'
	bra mainl
	  
;******** procedures ******************

Write
	movwf EECON1
	movlw 0x55
	movwf EECON2
	movlw 0xAA
	movwf EECON2
	bsf EECON1,WR			;WRITE
	nop
	;nop
	return


Receive
	movlw xtal/2000000+1	; for 20MHz => 11 => 1second delay
	movwf cnt1
rpt2						
	clrf cnt2
rpt3
	clrf cnt3
rptc
		btfss PIR1,RCIF			;test RX
		bra notrcv
	    movf RCREG,w			;return read data in W
	    addwf crc,f				;compute crc
		return
notrcv
	decfsz cnt3
	bra rptc
	decfsz cnt2
	bra rpt3
	decfsz cnt1
	bra rpt2
	;timeout:
way_to_exit
	bcf	RCSTA,	SPEN			; deactivate UART
	bra first_address
;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

            END
