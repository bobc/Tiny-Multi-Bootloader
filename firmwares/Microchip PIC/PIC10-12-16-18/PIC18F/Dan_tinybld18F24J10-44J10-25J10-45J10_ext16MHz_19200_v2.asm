	radix DEC
	
	; change these lines accordingly to your application	
#include "p18f24j10.inc"
IdTypePIC = 0x30		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash  0x4000	; in bytes, not WORDS!!! Please refer to the table below
	
xtal 	EQU 	16000000	; you may also want to change: _HS_OSC _XT_OSC
baud 	EQU 	19200		; standard TinyBld baud rates: 115200 or 19200

;   The above 5 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+
; |IdTypePIC| Device | Write_Page | Erase_Page |   TX bit    |   RX bit    | max_flash | EEPROM | PDIP |
; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+
; |   0x30  |18F24J10|  32 words  |  512 words |    C6(17)   |    C7(18)   |   0x4000  |   0    |  28  |
; |   0x30  |18F44J10|  32 words  |  512 words |    C6(25)   |    C7(26)   |   0x4000  |   0    |  40  |
; |   0x31  |18F25J10|  32 words  |  512 words |    C6(17)   |    C7(18)   |   0x8000  |   0    |  28  |
; |   0x31  |18F45J10|  32 words  |  512 words |    C6(25)   |    C7(26)   |   0x8000  |   0    |  40  |
; +---------+--------+------------+------------+-------------+-------------+-----------+--------+------+

;max_flash-1024	+---------------+				+---------------+	+---------------+
;		|		|    1.Copy Flash to RAM	|		|	|		|
;		|		|    2.Rewrite Config or not	|     0xFF	|	|      0xFF	|
;		|		|    3.Erase upper Flash Page	|		|	|		|
;		| User Program1	|    4.Copy RAM to Flash	|		|	|		|
;max_flash-640	|		|    5.Move PC to upper	Flash	+---------------+	+---------------+
;		|		|    6.Erase lower Flash Page	|   Bootloader	|<-PC	|   Bootloader  |
;max_flash-516	|		|    7.Copy RAM to Flash	+---------------+	+---------------+
;		|		|    8.Move PC to lower	Flash	|    Config1	|	|    Config1	|
;max_flash-512	+---------------+    9.Write User Program	+---------------+ 	+---------------+
;		|		|      and Vector		|		|	|		|
;		| User Program2	|				| User Program2	|	|      0xFF	|
;max_flash-132	+---------------+				+---------------+	|		|
;		|    Vector	| <RAM>				|    Vector	|	|     		|
;max_flash-128	+---------------+ 0x100	+---------------+	+---------------+	+---------------+
;		|   Bootloader	|	|   Bootloader	|	|   Bootloader	|	|   Bootloader	|<-PC
;max_flash-4	+---------------+ 0x1F8	+---------------+	+---------------+	+---------------+
;		|    Config0	|	|     Config1	|	|    Config0	|	|     Config1	|
;max_flash	+---------------+ 0x200	+---------------+	+---------------+	+---------------+

        ;********************************************************************
	;	Tiny Bootloader		18F2XJ10/18F4XJ10 	Size=132words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	(2013.11.18 Revision 4)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	$30, J, 18F(J) w/16KB flash & 0B EEPROM, $4000, 0, default, default,
	;	$31, J, 18F(J) w/32KB flash & 0B EEPROM, $8000, 0, default, default,
	;
        ;********************************************************************

	#include "../spbrgselect.inc"	; RoundResult and baud_rate

		#define first_address max_flash-264		;132 words

			config WDTEN = OFF		;WDT is controlled by SWDTEN bit of the WDTCON register
			config STVREN = OFF		;Stack full/underflow will not cause Reset
			config XINST = OFF		;Instruction set extension and Indexed Addressing mode disabled (Legacy mode)
			config DEBUG = OFF		;Background debugger disabled; RB6 and RB7 configured as general purpose I/O pins
			config CP0 = OFF		;Program memory is not code-protected
			config FOSC = HS		;HS oscillator
			config FOSC2 = ON		;Clock selected by FOSC as system clock is enabled when OSCCON<1:0> = 00
			config FCMEN = OFF		;Fail-Safe Clock Monitor disabled
			config IESO = OFF		;Oscillator Switchover mode disabled
			config WDTPS = 1		;Watchdog Timer Postscale Select bits 1:1
			config CCP2MX = DEFAULT		;CCP2 is multiplexed with RC1

;----------------------------- PROGRAM ---------------------------------
	cblock 0
	crc
	cnt1
	cnt2
	cnt3
;;	flagU
	flagH
	flagL
	endc
	
	cblock 0x0100
	buffer:256
	endc

count	equ	crc

;0000000000000000000000000 RESET 00000000000000000000000000

		ORG     0x0000
		GOTO    IntrareBootloader

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;PC_flash:		C1h		U		H		L		64  ...  <64 bytes>   ...  crc
;PC_cfg:		C1h		U OR 80h	H		L		 8  ...  < 8 bytes>   ...  crc
;PC_cfg_unnecessary:	C1h		0		crc
;PIC_response:	   type `J`

	ORG first_address			;space to deposit first 4 instr. of user prog.
	nop
	nop
	nop
	nop

	org first_address+8
IntrareBootloader:
						;skip TRIS to 0 C6
	movlw 	((1<<TXEN) | (1<<BRGH))		;init serial port
	movwf 	TXSTA
	;use only SPBRG (8 bit mode default) not using BAUDCON
	movlw	spbrg_value
	movwf	SPBRG
	movlw	((1<<SPEN) | (1<<CREN))
	movwf	RCSTA
						;wait for computer
	rcall 	Receive
	sublw 	0xC1				;Expect C1h
	bnz 	way_to_exit

	movlw   IdTypePIC			;send PIC type
	movwf   TXREG
	movlw 	'J'				; "-Everything OK, ready and waiting."
	movwf   TXREG

;;	movlw	((IntrareBootloader>>16)&0xFF)	;TBLPTR = IntrareBootloader
;;	movwf 	TBLPTRU
	movlw	((IntrareBootloader>>8)&0xFF)
	movwf 	TBLPTRH
;;	movlw	(IntrareBootloader&0xFF)
;;	movwf 	TBLPTRL
	clrf 	crc				;crc = 0
	incf	FSR0H				;FSR0 = buffer TOP (0x0100)
	TBLRD*-
cp_bl:						;copy Bootloader and Config to RAM
	TBLRD+*
	movff 	TABLAT,POSTINC0
	tstfsz	FSR0L				;FSR0 = 0x0200? (copy 256 bytes?)
	bra 	cp_bl				;

	rcall 	Receive				;Config Upper
	btfss 	WREG,7				;is Config?
	bra	chk_crc
	rcall 	Receive				;Config Hi (Recive only)
	rcall 	Receive				;Config Lo
	decf	FSR0H				;FSR0 = 0x0100
	movwf	FSR0L				;FSR0 = 0x01F8
	rcall 	Receive				;count (Recive only)

rcv_cfg:					;recive Config data
	rcall 	Receive
	movwf 	POSTINC0
	tstfsz	FSR0L				;FSR0 = 0x0200? (recive 8 bytes?)
	bra 	rcv_cfg

chk_crc:
	rcall 	Receive				;get crc
	bnz	way_to_exit			;crc error

wr_bl1:						;TBLPTR = 0x003B00-1(18F24/44J10)
	rcall 	wr_bld				;TBLPTR = 0x007B00-1(18F25/45J10)
	bra	(wr_bl2 - 1024)
wr_bl2:						;TBLPTR = 0x003F00-1(18F24/44J10)
	rcall 	wr_bld				;TBLPTR = 0x007F00-1(18F25/45J10)
	bra	(set_FSR + 1024)
set_FSR:
	decf	FSR0H				;FSR0 = 0x0100

MainLoop:
	movlw 	'J'				; "-Everything OK, ready and waiting."
mainl:
	movwf   TXREG
	clrf 	crc				;crc = 0
	rcall 	Receive				;Upper
	movwf 	TBLPTRU
;;	movwf 	flagU				;(for ERASE)
	rcall 	Receive				;Hi
	movwf 	TBLPTRH
	movwf 	flagH				;(for ERASE)
	rcall 	Receive				;Lo
	movwf 	TBLPTRL
	movwf 	flagL				;(for ERASE)
	rcall 	Receive				;count (Recive only)
	clrf	FSR0L				;FSR0 = 0x0100
rcvoct:						;read 64 bytes
	rcall 	Receive
	movwf 	POSTINC0
	btfss 	FSR0L,6				;FSR0 = 0x0140?
	bra 	rcvoct

	clrf	FSR0L				;FSR0 = 0x0100
	rcall 	Receive				;get crc
ziieroare:					;CRC failed
	movlw	'N'
	bnz	mainl
						;write
eraseloop:
;	bcf	STATUS,C			;Carry=0
;;	rrcf	flagU				;flagU:flagH:flagL=(flagU:flagH:flagL>>2)
	rrcf	flagH
	rrcf	flagL
;	bcf	STATUS,C			;Carry=0
;;	rrcf	flagU
	rrcf	flagH
	rrcf	flagL
	bnz	noerase				;Each 1024bytes?
	movlw	((IntrareBootloader>>10)&0xFF)	;0x0F=0x3C00>>10,0x1F=0x7C00>>10
	subwf	flagH,w
	bz	noerase				;Last Erase Page?
	bsf	EECON1,FREE			;Erase
	rcall	Write

noerase:
	TBLRD*-					;point to adr-1
	rcall 	write64bytes

waitwre:
	;btfsc 	EECON1,WR			;for eeprom writes (wait to finish write)
	;bra 	waitwre				;no need: round trip time with PC bigger than 4ms
	
	bra 	MainLoop

;******** procedures ******************

wr_bld:
	btg	TBLPTRH,2			;TBLPTR-1024.orTBLPTR+1024
	bsf	EECON1,FREE			;Erase
	rcall	Write
	clrf 	TBLPTRL
	TBLRD*-					;point to adr-1
	decf	FSR0H				;FSR0 = 0x0100
wr_bld_lp:
	rcall 	write64bytes
	tstfsz	FSR0L				;FSR0 = 0x0200? (write 256 bytes?)
	bra 	wr_bld_lp
	return


write64bytes:
	bsf	count,6				;count = 64
write64_lp:
	movff	POSTINC0,TABLAT			;put 1 byte
	tblwt+*
	decfsz	count				;count = 0?
	bra 	write64_lp
Write:
	bsf	EECON1,WREN
	movlw	0x55
	movwf 	EECON2
	movlw 	0xAA
	movwf 	EECON2
	bsf 	EECON1,WR			;WRITE
	nop
	clrf 	EECON1
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
	addwf 	crc				;compute crc
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
