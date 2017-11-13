        radix   DEC
        
	; change these lines accordingly to your application	
#include "p12f752.inc"
IdTypePIC = 0x1C		; Please refer at the table below, must exists in "piccodes.ini"	
#define max_flash 0x400		; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer at the table below
        
xtal    EQU     8000000         ; you may also want to change: _HS_OSC _XT_OSC
baud    EQU     9600            ; standard TinyBld baud rates: 115200 or 19200

        #define TXP     1	         ; PIC TX Data port (1:A,2:C), Please refer to the table below
        #define TX	0	 	 ; PIC TX Data output pin (i.e. 2=RA2 or RC2, it depends on "PIC TX Data port")
        #define RXP     1	         ; PIC RX Data port (1:A,2:C), Please refer to the table below
        #define RX      1	         ; PIC RX Data input pin  (i.e. 3=RA3 or RC3, it depends on "PIC RX Data port")
;        #define Direct_TX               ; RS-232C TX Direct Connection(No use MAX232)
;        #define Direct_RX               ; RS-232C RX Direct Connection(No use MAX232)
;   The above 11 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+-----------+------+--------+------+
; |IdTypePIC| Device | Erase_Page | max_flash | PORT | EEPROM | PDIP |
; +---------+--------+------------+-----------+------+--------+------+
; |   0x1C  | 12F752 |  16 words  |  0x0400   | A    |  0     |   8  |
; |   0x39  | 16F753 |  16 words  |  0x0800   | A C  |  0     |  14  |
; +---------+--------+------------+-----------+------+--------+------+

; +----------+------+----------+------+ +----------+------+
; | register | BANK | register | BANK | |subroutine| BANK |
; +----------+------+----------+------+ +----------+------+
; | PMCON1/2 |  3   |PMADRL/DAT|  3   | | Receive  |->0->3|
; +----------+------+----------+------+ +----------+------+
; | ANSEL    |  3   |          |      |
; +----------+------+----------+------+

 #if (TXP==1)
	#define TXPORT     PORTA
 #endif
 #if (TXP==2)
	#define TXPORT     PORTA+2	;PORTC
 #endif
 #if (RXP==1)
	#define RXPORT     PORTA
 #endif
 #if (RXP==2)
	#define RXPORT     PORTA+2	;PORTC
 #endif

    	;********************************************************************
    	;       Tiny Bootloader         12F752 16F753		Size=100words
	;	(2014.06.10 Revision 10)
	;
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;
	;	Please add the following line to piccodes.ini
	;
	;
	;	$1C, B, 12F 752, $800, 0, default, 8,
	;	$39, B, 16F 753, $1000,0, default, 8,
	;
        ;********************************************************************


        #define first_address max_flash-100 ; 100 word in size

	   __CONFIG    _FOSC0_INT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _BOREN_DIS & _WRT_OFF & _CLKOUTEN_OFF

;       errorlevel 1, -305              ; suppress warning msg that takes f as default

        cblock 0x7A
	crc		;0x7A
	cnt1		;0x7B
	cnt2		;0x7C
	cnt3		;0x7D
	cn		;0x7E
	rxd		;0x7F
        endc

;0000000000000000000000000 RESET 00000000000000000000000000

                org     0x0000
		pagesel	IntrareBootloader
                goto    IntrareBootloader

                                        ;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;               
                ;PC_flash:      C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
                ;PIC_response:  id   K                                                 K

                org     first_address
;               nop
;               nop
;               nop
;               nop

                org     first_address+4
IntrareBootloader:
                                        ;init int clock & serial port
		bsf	STATUS,RP0	;BANK1
		bsf	OSCCON,5	;internal clock 8MHz

 #if (TXP==1)
                bcf     TRISA,TX        ;Set TX Port
 #endif
 #if (TXP==2)
                bcf     TRISA+2,TX      ;Set TX Port (TRISC)
 #endif

		bsf	STATUS,RP1	;BANK3

 #if ((TXP==1) | (RXP==1))
		clrf	ANSELA		;ANSELA
 #endif
 #if ((TXP==2) | (RXP==2))
		clrf	ANSELA+2	;ANSELC
 #endif
                                        ;wait for computer
                call    Receive
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
		clrf	STATUS		;BANK0
		call	SendL
                clrf    crc             ;clear checksum
                call    Receive         ;get PMADRH
                movwf   PMADRH
                call    Receive         ;get PMADRL
                movwf   PMADR
                call    Receive         ;get count (Only Receive)
		decf	PMADRL,f	;PMADRL = PMADRL - 1

                call    wr_d		;write buffer
                call    wr_d		;write buffer
                call    wr_d		;write buffer
                call    set_PMdata	;set PMDATH:PMDATL,PMADRL

                call    Receive         ;get checksum
ziieroare:
		movlw   'N'
                skpz
                goto    mainl

		call	write		;erase and write
                goto    MainLoop

; ********************************************************************
;
;		Set PMDATH:PMDATL and PMADRL
;
; ********************************************************************

set_PMdata:
                incf    PMADRL,f	;PMADRL = PMADRL + 1
                call    Receive         ;Data L
                movwf   PMDATL
                call    Receive         ;Data H
                movwf   PMDATH
		return

; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
		clrf	STATUS		;BANK0
		movlw   xtal/2000000+2  ;for 20MHz => 11 => 1second
                movwf   cnt1
rpt2:
;	        clrf    cnt2
rpt3:
;	        clrf    cnt3
rptc:
        #ifdef  Direct_RX
                btfss   RXPORT,RX
        #else
                btfsc   RXPORT,RX
        #endif
                goto	$+6

		call    RcvL1		;get data
                addwf   crc,f           ;compute checksum
		bsf	STATUS,RP1	;BANK3
		bsf	STATUS,RP0
                return

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
;		RS-232C Recieve 1byte
;
;		Return in W and rxd
;
; ********************************************************************

RcvL:
        #ifdef  Direct_RX
                btfss   RXPORT,RX
        #else
                btfsc   RXPORT,RX
        #endif
                goto	RcvL		; check Start bit
RcvL1:
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
                return

; ********************************************************************
;
;		Program Flash
;
; ********************************************************************

wr_d:
		call	set_PMdata
write:
		bsf	PMCON1,WREN
                movlw   0x55
                movwf   PMCON2
                movlw   0xaa
                movwf   PMCON2
                bsf     PMCON1,WR	;WR=1
                nop
                nop
;		clrf	PMCON1
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

                end
