        radix   DEC
        
	; change these lines accordingly to your application	
#include "p16f818.inc"
IdTypePIC = 0x34		; Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash 0x400		; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), please refer to the table below
        
xtal    EQU     8000000         ; you may also want to change: _HS_OSC _XT_OSC
baud    EQU     9600            ; standard TinyBld baud rates: 115200 or 19200

        #define TXP     2	         ; PIC TX Data port (1:A,2:B), Please refer to the table below
        #define TX	5		 ; PIC TX Data output pin (i.e. 2=RA2 or RB2, it depends on "PIC TX Data port")
        #define RXP     2	         ; PIC RX Data port (1:A,2:B), Please refer to the table below
        #define RX      2	         ; PIC RX Data input pin  (i.e. 3=RA3 or RB3, it depends on "PIC RX Data port")
;        #define Direct_TX               ; RS-232C TX Direct Connection(No use MAX232)
;        #define Direct_RX               ; RS-232C RX Direct Connection(No use MAX232)
;   The above 11 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+-----------+------+--------+------+
; |IcTypePIC| Device | Erase_Page | max_flash | PORT | EEPROM | PDIP |
; +---------+--------+------------+-----------+------+--------+------+
; |   0x34  |16F818  |  32 words  |  0x0400   | A B  |  128   |  18  |
; |   0x35  |16F819  |  32 words  |  0x0800   | A B  |  256   |  18  |
; +---------+--------+------------+-----------+------+--------+------+

; +----------+------+----------+------+ +----------+------+
; | register | BANK | register | BANK | |subroutine| BANK |
; +----------+------+----------+------+ +----------+------+
; | EECON1/2 |  3   |EEADRL/DAT|  2   | | Receive  |->0->2|
; +----------+------+----------+------+ +----------+------+
; | ADCON1   |  1   |          |      |
; +----------+------+----------+------+

 #if (TXP==1)
	#define TXPORT     PORTA
 #endif
 #if (TXP==2)
	#define TXPORT     PORTB
 #endif
 #if (RXP==1)
	#define RXPORT     PORTA
 #endif
 #if (RXP==2)
	#define RXPORT     PORTB
 #endif

    	;********************************************************************
    	;       Tiny Bootloader         16F818 16F819		Size=100words
	;
	;	(2014.06.10 Revision 10)
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;
	;	Please add the following line to piccodes.ini
	;
	;
	;	$34, B, 16F 818, $800, $080, default, 64,
	;	$35, B, 16F 819, $1000, $080, default, 64,
	;
        ;********************************************************************


        #define first_address max_flash-100 ; 100 word in size

	__CONFIG   _INTRC_IO & _WDT_OFF & _PWRTE_ON  & _MCLR_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _DEBUG_OFF & _CCP1_RB2 & _CP_OFF

;       errorlevel 1, -305              ; suppress warning msg that takes f as default

        cblock 0x78
	crc		;0x78
	i		;0x79
	cnt1		;0x7A
	cnt2		;0x7B
	cnt3		;0x7C
	flag		;0x7D
	cn		;0x7E
	rxd		;0x7F
        endc

;0000000000000000000000000 RESET 00000000000000000000000000

                org     0x0000
                goto    IntrareBootloader

                                        ;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;
;PC_flash:    C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
;PC_EEPROM:   C1h          EEADRH  EEADRL  2  EEDATL  EEDATH(=0)    crc
;PIC_response:   id   K                                                 K

                org     first_address
;               nop
;               nop
;               nop
;               nop

                org     first_address+4
IntrareBootloader:
                                        ;init int clock & serial port
		bsf	STATUS,RP0	;BANK 1
;		movlw	B'01110000'	;internal clock 8MHz
;		movwf	OSCCON
		comf	OSCCON,f	;internal clock 8MHz

 #if (TXP==1)
		movlw	B'00000111'	;PortA=Digital
		movwf	ADCON1
                bcf     TRISA,TX        ;TRISA
 #else
                bcf     TRISA+1,TX      ;TRISB
		nop
		nop
 #endif
                call    Receive		;wait for computer
		clrf	STATUS		;BANK0
                sublw   0xC1            ;Expect C1
                skpz
                goto    way_to_exit
                movlw   IdTypePIC       ;PIC type
		call	SendL
;               SendL   IdSoftVer       ;firmware ver x

MainLoop:
                movlw   'B'
mainl:
		clrf	STATUS		;BANK 0
		call	SendL
                clrf    crc             ;clear checksum
                call    Receive         ;get EEADRH
                movwf   EEADRH
		movwf	flag		;set bit6 if EEPROM
                call    Receive         ;get EEADR
                movwf   EEADR
                call    Receive         ;get count
		movwf	i

		movlw	((1<<EEPGD) | (1<<FREE) | (1<<WREN))
		btfss	flag,6		;skip if EEPROM
		call	wr_w		;erase flash
rcvoct:
                call    Receive
                movwf   EEDATA		;data L
		call    Receive
                movwf   EEDATH		;data H
		movlw	(1<<WREN)
		btfss	flag,6		;skip if EEPROM
		addlw	(1<<EEPGD)
		call	wr_w
                incf    EEADR,f		;EEADR = EEADR + 1
		decf	i,f
		decfsz	i,f
		goto	rcvoct

                call    Receive         ;get checksum
ziieroare:
		movlw   'N'
                skpz
                goto    mainl
                goto    MainLoop

;*************************************************************
;
;		Program Flash/EEPROM
;
;		Set W and Call
;
; ************************************************************

wr_w:
		bsf	STATUS,RP0	;BANK 2->3
		movwf	EECON1
                movlw   0x55
                movwf   EECON2
                movlw   0xaa
                movwf   EECON2
                bsf     EECON1,WR	;WR=1
                nop
                nop
		bcf	STATUS,RP0	;BANK 3->2
		return

; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
		clrf	STATUS		;BANK 0

		movlw   xtal/2000000+2  ;for 20MHz => 11 => 1second
                movwf   cnt1
rpt2:
;	        clrf    cnt2
rpt3:
;	        clrf    cnt3
rptc:					;Check Start bit
        #ifdef  Direct_RX
                btfss   RXPORT,RX
        #else
                btfsc   RXPORT,RX
        #endif
                goto	loop

		call    bwait2          ; wait 1/2 bit and W=9
                movwf   cn		; cn=9
                rrf     rxd,f		; get bit data
		call    bwait           ; wait 1 bit and set Carry=1

        #ifdef  Direct_RX
                btfsc   RXPORT,RX
        #else
                btfss   RXPORT,RX
        #endif

                bcf     STATUS,C

		decfsz	cn,f		; cn=0?
                goto    $-5		; loop
                movf    rxd,w           ; return in w
                addwf   crc,f           ;compute checksum

		bsf	STATUS,RP1	;BANK 2
                return
loop:
                decfsz  cnt3,f
                goto    rptc
                decfsz  cnt2,f
                goto    rpt3
                decfsz  cnt1,f
                goto    rpt2
way_to_exit:
                goto    first_address	;timeout:exit in all other cases

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

                end
