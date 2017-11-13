        radix   DEC
        
	; change these lines accordingly to your application	
#include "p10f322.inc"
IdTypePIC = 0x12		; must exists in "piccodes.ini"	
#define max_flash 0x200		; in WORDS, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2)
        
xtal    EQU     8000000         ; you may also want to change: _HS_OSC _XT_OSC
baud    EQU     9600            ; standard TinyBld baud rates: 115200 or 19200

        #define TX      2               ;PIC TX Data output pin (i.e. 2 = RA2)
        #define RX      3               ;PIC RX Data input pin (i.e. 3 = RA3)
        #define Direct_TX               ;RS-232C TX Direct Connection(No use MAX232)
        #define Direct_RX               ;RS-232C RX Direct Connection(No use MAX232)

;   The above 9 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

    	;********************************************************************
    	;       Tiny Bootloader         10F322         Size=84words
    	;       Dan
    	;       http://www3.hp-ez.com/hp/bequest333/
	;	(2014.06.04 Revision 9)
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	Please add the following line to piccodes.ini
	;
	;	$12, B, 10F 322, $400, $000, 168, 32,
	;
	;********************************************************************


        #define first_address max_flash-84 ; 84 word in size

        __CONFIG        _FOSC_INTOSC & _BOREN_OFF & _WDTE_SWDTEN & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _LVP_OFF & _LPBOR_OFF & _BORV_HI & _WRT_OFF

;       errorlevel 1, -305              ; suppress warning msg that takes f as default

        cblock 0x7D
	crc		;0x7D
	cn		;0x7E
	rxd		;0x7F
        endc

;0000000000000000000000000 RESET 00000000000000000000000000

                org     0x0000
                movlw   0x01
                movwf   PCLATH
                goto    IntrareBootloader

                                        ;view with TabSize=8
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
		btfss	STATUS,NOT_TO
                goto    first_address	; connection errer or timeout

		clrf    ANSELA          ; digital I/O
                bcf     TRISA,TX        ; set TX Port
		call    Receive		; init int clock & serial port
					; wait for computer
                sublw   0xC1            ; Expect C1
                skpz
                goto    first_address	; connection errer or timeout
                movlw   IdTypePIC	; send IdTypePIC
        	call    SendL
MainLoop:
	        movlw   'B'
mainl:
		call	SendL
		clrf    crc             ; clear Checksum
                call    Receive         ; get PMADRH
                movwf   PMADRH
                call    Receive         ; get PMADRL
                movwf   PMADRL
                call    Receive         ; get count (Only Receive)
rcvoct:
	        call    Receive         ; get Data(L)
                movwf   PMDATL
                call    Receive         ; get Data(H)
                movwf   PMDATH
		call	wr_l		; write Latches
;		movlw	0x01		; PMADRL=PMADRL+1
		addwf	PMADRL,f
		skpdc			; skip if PMADRL=B'XXXX0000'
                goto    rcvoct		; loop

                call    Receive		; get Checksum
ziieroare:
		movlw   'N'		; send "N"
                skpz			; test Checksum
                goto    mainl		; retry

		decf	PMADRL,f	; adjust PMADRL
                call    wr_e            ; erase Flash Page
                call	wr_w            ; write Flash Page
                goto    MainLoop	; loop

; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
		bsf	WDTCON,SWDTEN
RcvL:
        #ifdef  Direct_RX
                btfss   PORTA,RX
        #else
                btfsc   PORTA,RX
        #endif
                goto	RcvL

		call    bwait2	; wait 1/2 bit and W=9
                movwf   cn	; cn=9
                rrf     rxd,f	; get bit data		; 1
		call    bwait   ; wait 1bit and Carry=1	; 2+8N+6=8N+8

        #ifdef  Direct_RX
                btfsc   PORTA,RX			; 1
        #else
                btfss   PORTA,RX
        #endif
                bcf     STATUS,C			; 1

		decfsz	cn,f		; cn=0?		; 1
                goto    $-5		; loop		; 2 total:1+8N+8+1+1+1+2=8N+14
                movf    rxd,w           ; return in w
		btfsc	WDTCON,SWDTEN	; return without checksum if not a Bootloder mode
                addwf   crc,f           ; compute checksum
		bcf	WDTCON,SWDTEN
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
		bcf	LATA,TX ; TX port Initialization
   #else
		bsf	LATA,TX
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
                bcf     LATA,TX				; 1
                btfss   STATUS,C			; 1
                bsf     LATA,TX				; 1
        #else
                btfsc   STATUS,C
                bsf     LATA,TX
                btfss   STATUS,C
                bcf     LATA,TX
        #endif

bwait:				; wait 1 bit
		call	bwait2				; 2+(4N+2)+(4N+2)=8N+6
bwait2:				; wait 1/2bit and Set Carry=1
		movlw   .256-((xtal/.4)/baud-.15)/.8	; 1
                addlw   0x01           			; 1
                btfss	STATUS,Z        		; 1
                goto    $-2             		; 2(1)
		retlw	0x09				; 2 total:1+(1+1+2)*N-1+2=4N+2

; ********************************************************************
;
;		Program Flash
;
;		Set PMADRH/L,PMDATH/L and Call (Return:W=1)
;
; ********************************************************************

wr_e:					; erase Page
		bsf	PMCON1,FREE
wr_l:					; write Latches
		bsf	PMCON1,LWLO
wr_w:					; write Page or byte
		bsf	PMCON1,WREN
		movlw   0x55
                movwf   PMCON2
                movlw   0xaa
                movwf   PMCON2
		bsf	PMCON1,WR
                nop
                nop
		clrf	PMCON1
		retlw	0x01

; ********************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

                end
