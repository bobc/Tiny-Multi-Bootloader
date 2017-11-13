	radix DEC
	LIST  F=INHX8M

	; change these lines accordingly to your application	
#include "p16f872.inc"
IdTypePIC = 0x3F		; must exists in "piccodes.ini"			
#define max_flash 0x0800	; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)

xtal EQU 8000000		; you may also want to change: _HS_OSC _XT_OSC
baud EQU 9600			; standard TinyBld baud rates: 115200 or 19200

        #define TXP     3	         ; PIC TX Data port (1:A,2:B,3:C), Please refer to the table below
        #define TX	6		 ; PIC TX Data output pin (i.e. 2=RA2 or RB2, it depends on "PIC TX Data port")
        #define RXP     3	         ; PIC RX Data port (1:A,2:B,3:C), Please refer to the table below
        #define RX      7	         ; PIC RX Data input pin  (i.e. 3=RA3 or RB3, it depends on "PIC RX Data port")
;        #define Direct_TX               ; RS-232C TX Direct Connection(No use MAX232)
;        #define Direct_RX               ; RS-232C RX Direct Connection(No use MAX232)

; The above 11 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+------------+--------+-----------+--------+
; |IcTypePIC| Device | Erase_Page | Write_Page |  PORT  | max_flash | EEPROM |
; +---------+--------+------------+------------+--------+-----------+--------+
; |   0x3F  |16F872  |  1 words   |   1 words  | A/B/C  |  0x0800   |  64    |
; +---------+--------+------------+------------+--------+-----------+--------+

; +----------+------+----------+------+ +----------+--------+
; | register | BANK | register | BANK | |subroutine|  BANK  |
; +----------+------+----------+------+ +----------+--------+
; | EECON1/2 |  3   |EEADRL/DAT|  2   | | Receive  | ->0->2 |
; +----------+------+----------+------+ +----------+--------+

 #if (TXP==1)
	#define TXPORT     PORTA
 #endif
 #if (TXP==2)
	#define TXPORT     PORTB
 #endif
 #if (TXP==3)
	#define TXPORT     PORTC
 #endif
 #if (RXP==1)
	#define RXPORT     PORTA
 #endif
 #if (RXP==2)
	#define RXPORT     PORTB
 #endif
 #if (RXP==3)
	#define RXPORT     PORTC
 #endif

    	;********************************************************************
	;	Tiny Bootloader		16F872			Size=100words
	;
	;	claudiu.chiculita@ugal.ro
	;	http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	(2014.06.10 Revision 5)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	Please add the following line to piccodes.ini
	;	$3F, B, 16F 872,              $1000, $40,  default, 2,
	;
        ;********************************************************************

	#define first_address max_flash-100 ; 100 word in size

	__CONFIG  _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _CP_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_ENABLE_ON & _DEBUG_OFF

	errorlevel 1, -305		; suppress warning msg that takes f as default

	cblock 0x79
	crc
	cnt1
	cnt2
	cnt3
	flag
	cn
	rxd
	endc
	
;0000000000000000000000000 RESET 00000000000000000000000000

		ORG     0x0000
		PAGESEL IntrareBootloader
		GOTO    IntrareBootloader

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;
;PC_flash:    C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
;PC_EEPROM:   C1h          EEADRH  EEADRL  2  EEDATL  EEDATH(=0)    crc
;PIC_response:   id   K                                                 K
	
	ORG first_address
;	nop
;	nop
;	nop
;	nop

	org first_address+4
IntrareBootloader:
                                        ;init serial port
	bsf	STATUS,RP0		;bank  1

 #if ((TXP==1) | (RXP==1))
	movlw	B'00000111'		;PortA=Digital
	movwf	ADCON1
 #endif
     					;Set TX Port
 #if (TXP==1)
        bcf     TRISA,TX
 #endif
 #if (TXP==2)
        bcf     TRISB,TX
 #endif
 #if (TXP==3)
        bcf     TRISC,TX
 #endif

	call	Receive			;wait for computer
	clrf	STATUS			;BANK  2->0
	sublw	0xC1			;Expect C1
	skpz
	goto	way_to_exit

	movlw	IdTypePIC		;PIC type
	call	SendL
	;SendL	IdSoftVer		;firmware ver x

MainLoop:
	movlw	'B'
mainl:
	clrf	STATUS			;BANK  0
	call	SendL
	clrf	crc
	call	Receive			;Address H
	movwf	EEADRH
	movwf	flag			;used to detect if is eeprom
	call	Receive			;Address L
	movwf	EEADR
	call	Receive			;count

        call    Receive
        movwf   EEDATA			;data L
	call    Receive
        movwf   EEDATH			;data H
	bsf	STATUS,RP0		;BANK 2->3
	btfss	flag,6			;skip if EEPROM
	bsf	EECON1,EEPGD
	bsf	EECON1,WREN
	call	wr
	bcf	STATUS,RP0		;BANK 3->2

	call	Receive			;checksum
ziieroare:
	movlw	'N'
	skpz				;check checksum
	goto	mainl
	goto	MainLoop


; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
	clrf	STATUS			;BANK 0
	movlw   xtal/2000000+1  	;for 20MHz => 11 => 1second
        movwf   cnt1
rpt2:
	clrf    cnt2
rpt3:
	clrf    cnt3
rptc:
 #ifdef  Direct_RX
        btfss   RXPORT,RX
 #else
        btfsc   RXPORT,RX
 #endif
	goto 	$+5			; check Start bit

	call    RcvL1	          	; get data
	addwf	crc,f			; compute checksum
	bsf	STATUS,RP1		;BANK  0->2
	return

        decfsz  cnt3,f
        goto    rptc
        decfsz  cnt2,f
        goto    rpt3
        decfsz  cnt1,f
        goto    rpt2
					;timeout:
way_to_exit:				;exit in all other cases; must be BANK0
	goto	first_address

; ********************************************************************
;
;		RS-232C Recieve 1byte
;
;		Return in W and rxd
;
; ********************************************************************

RcvL:
 #ifdef  Direct_RX
        btfss   RXPORT,RX		; Check Start bit
 #else
        btfsc   RXPORT,RX
 #endif
	goto 	RcvL
RcvL1:
	call    bwait2          	; wait 1/2 bit and W=9
        movwf   cn			; cn=9
        rrf     rxd,f			; get bit data
	call    bwait   	        ; wait 1 bit and set Carry=1

 #ifdef  Direct_RX
        btfsc   RXPORT,RX
 #else
        btfss   RXPORT,RX
 #endif

        bcf     STATUS,C
	decfsz	cn,f			; cn=0?
        goto    $-5			; loop
        movf    rxd,w          		; return in w
	return

; ********************************************************************
;
;		Program Flash/EEPROM
;
; ********************************************************************

wr:
	movlw	0x55
	movwf	EECON2
	movlw	0xaa
	movwf	EECON2
	bsf	EECON1,WR
	nop
	nop
	clrf	EECON1
	return

; ********************************************************************
;
;		RS-232C Send 1byte
;
;		Set W and Call (Return:W=0x09,Carry=1,Zero=1)
;
; ********************************************************************

SendL:

   #ifdef Direct_TX
		bcf	TXPORT,TX ; TX port Initialization
   #else
		bsf	TXPORT,TX
   #endif
		movwf   rxd	; rxd=w
		call	bout+3	; send start bit
		movwf	cn	; cn=9
		rrf     rxd,f	; set Carry		; 1
                call    bout	; wait 1bit and Carry=1	; 2+1+1+1+1+8N+6=8N+12
                decfsz  cn,f	; send 10bits?		; 1
                goto    $-3	; loop			; 2(1) total:1+8N+12+1+2=8N+16

bout:

        #ifdef  Direct_TX
                btfsc   STATUS,C			; 1
                bcf     TXPORT,TX			; 1
                btfss   STATUS,C			; 1
                bsf     TXPORT,TX			; 1
        #else
                btfsc   STATUS,C
                bsf     TXPORT,TX
                btfss   STATUS,C
                bcf     TXPORT,TX
        #endif

bwait:				; wait 1 bit
		call	bwait2				; 2+(4N+2)+(4N+2)=8N+6
bwait2:				; wait 1/2bit and Set Carry=1
		movlw   .256-((xtal/.4)/baud-.15)/.8	; 1
                addlw   0x01           			; 1
                btfss	STATUS,Z        		; 1
                goto    $-2             		; 2(1)
		retlw	0x09				; 2 total:1+(1+1+2)*N-1+2=4N+2

;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

        END
