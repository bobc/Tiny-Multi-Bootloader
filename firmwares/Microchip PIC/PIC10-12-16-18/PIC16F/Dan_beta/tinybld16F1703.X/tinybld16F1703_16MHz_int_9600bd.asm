        radix   DEC
        
	; change these lines accordingly to your application	
#include "p16f1703.inc"
IdTypePIC = 0x25		; , Please refer to the table below, must exists in "piccodes.ini"	
#define max_flash 0x800		; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below
        
xtal    EQU     16000000        ; you may also want to change: _HS_OSC _XT_OSC
baud    EQU     9600            ; standard TinyBld baud rates: 115200 or 19200

        #define TXP     1	         ; PIC TX Data port (1:A,2:B,3:C), Please refer to the table below
        #define TX	4	 	 ; PIC TX Data output pin (i.e. 2=RA2 or RB2 or RC2, it depends on "PIC TX Data port")
        #define RXP     1	         ; PIC RX Data port (1:A,2:B,3:C), Please refer to the table below
        #define RX      5	         ; PIC RX Data input pin  (i.e. 3=RA3 or RB3 or RC3, it depends on "PIC RX Data port")
;        #define Direct_TX               ; RS-232C TX Direct Connection(No use MAX232)
;        #define Direct_RX               ; RS-232C RX Direct Connection(No use MAX232)
;   The above 11 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+--------+------------+-----------+--------+-------+------+
; |IdTypePIC| Device | Erase_Page | max_flash | EEPROM | PORT  | PDIP |
; +---------+--------+------------+-----------+--------+-------+------+
; |   0x25  |16F1703 |  32 words  |  0x0800   |    0   | A   C |  14  |
; |   0x25  |16F1707 |  32 words  |  0x0800   |    0   | A B C |  20  |
; +---------+--------+------------+-----------+--------+-------+------+

; +----------+------+----------+------+ +----------+------+
; | register | BANK | register | BANK | |subroutine| BANK |
; +----------+------+----------+------+ +----------+------+
; | PMCON1/2 |  3   |PMADRL/DAT|  3   | | Receive  |->0->3|
; +----------+------+----------+------+ +----------+------+
; | ANSELA   |  3   |          |      |
; +----------+------+----------+------+

 #if (TXP==1)
	#define TXPORT     PORTA	;PORTA
 #endif
 #if (TXP==2)
	#define TXPORT     PORTA+1	;PORTB
 #endif
 #if (TXP==3)
	#define TXPORT     PORTA+2	;PORTC
 #endif
 #if (RXP==1)
	#define RXPORT     PORTA	;PORTA
 #endif
 #if (RXP==2)
	#define RXPORT     PORTA+1	;PORTB
 #endif
 #if (RXP==3)
	#define RXPORT     PORTA+2	;PORTC
 #endif

    	;********************************************************************
    	;       Tiny Bootloader         16F1703/07              Size=100words
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
	;	$25, B, 16F w/2Kw flash & 0B EEPROM (Blk32),      $1000,     0, default, 64,
	;
        ;********************************************************************


        #define first_address max_flash-100 ; 100 word in size

    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _CLKOUTEN_OFF
    __CONFIG _CONFIG2, _WRT_OFF & _PPS1WAY_OFF & _ZCDDIS_OFF & _PLLEN_OFF & _STVREN_OFF & _BORV_LO & _LPBOR_OFF & _LVP_OFF

;       errorlevel 1, -305              ; suppress warning msg that takes f as default

        cblock 0x79
	crc
	i
	cnt1
	cnt2
	cnt3
	cn
	rxd
        endc

;0000000000000000000000000 RESET 00000000000000000000000000

                org     0x0000
;               goto    IntrareBootloader
		DW	0x339F		;bra $-0x60

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
		movlp	(max_flash>>8)-1
                                        ;init int clock & serial port
		movlb	0x01		;BANK1
		bsf	OSCCON,6	;internal clock 16MHz

 #if (TXP==1)
                bcf     TRISA,TX        ;Set TX Port
 #endif
 #if (TXP==2)
                bcf     TRISA+1,TX      ;Set TX Port (TRISB)
 #endif
 #if (TXP==3)
                bcf     TRISA+2,TX      ;Set TX Port (TRISC)
 #endif

		movlb	0x03		;BANK3

 #if ((TXP==1) | (RXP==1))
		clrf     ANSELA		;ANSELA
 #endif
 #if ((TXP==2) | (RXP==2))
		clrf     ANSELA+1       ;ANSELB
 #endif
 #if ((TXP==3) | (RXP==3))
		clrf     ANSELA+2       ;ANSELC
 #endif
                                        ;wait for computer
                call    Receive
		movlb	0x00		;BANK0
                sublw   0xC1            ;Expect C1
                skpz
                bra     way_to_exit
                movlw   IdTypePIC       ;PIC type
        	call    SendL
;               SendL   IdSoftVer       ;firmware ver x

MainLoop:
                movlw   'B'
mainl:
		movlb	0x00		;BANK0
        	call    SendL
                clrf    crc             ;clear checksum
                call    Receive         ;get PMADRH
                movwf   PMADRH
                call    Receive         ;get PMADRL
                movwf   PMADRL
                call    Receive         ;get count
		movwf	i
rcvoct:
	        call    Receive         ; get Data(L)
                movwf   PMDATL
                call    Receive         ; get Data(H)
                movwf   PMDATH
		movlw 	((1<<LWLO) | (1<<WREN))
		call	wr_w		;write Latches
		incf	PMADRL,f
		decfsz	i,f
                bra     rcvoct		; loop

                call    Receive		; get Checksum
ziieroare:
		movlw   'N'
                skpz			; test Checksum
                bra     mainl		; Checksum error

		decf	PMADRL,f	; adjust PMADRL
                call    wr_e            ; erase Flash Page
                call	wr_w            ; write Flash Page
                bra     MainLoop	; loop


; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
		movlb	0x00		;BANK0
		movlw   xtal/2000000+2  ;for 20MHz => 11 => 1second
                movwf   cnt1
rpt2:
;		clrf    cnt2
rpt3:
;            	clrf    cnt3
rptc:					;Check Start bit
        #ifdef  Direct_RX
                btfss   RXPORT,RX
        #else
                btfsc   RXPORT,RX
        #endif
                bra	loop		;loop
r1rx11:
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
                bra     $-5		; loop
                movf    rxd,w           ; return in w
                addwf   crc,f           ; compute checksum
		movlb	0x03		; BANK3
                return
loop:
                decfsz  cnt3,f
                bra     rptc
                decfsz  cnt2,f
                bra     rpt3
                decfsz  cnt1,f
                bra     rpt2
way_to_exit:
		clrf	PMCON1
		clrf	PCLATH
                bra	first_address	; timeout:exit in all other cases
					; PCLATH=0, Please do not change the GOTO instruction.

;*************************************************************
;
;		Program Flash
;
;		(Return:W=(1<<WREN))
;
; ************************************************************

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
	retlw	(1<<WREN)

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
                bra     $-3	; loop			; 2(1) total:1+8N+12+1+2=8N+16

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
                bra     $-2             		; 2(1)
		retlw	0x09				; 2 total:1+(1+1+2)*N-1+2=4N+2

;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

                end
