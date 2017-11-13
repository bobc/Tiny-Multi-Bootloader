
	LIST P=PIC12F617
	#INCLUDE <P12F617.INC>

;	#define	EE			;PMADR/PMDAT/PMCON not exist
	#define	EPSIZE	0x10		;Erase Page size(16/32)(word)
	#define	bl_adr	0x07A0		;Start address of the bootloader

        #define TXP     1	        ; PIC TX Data port (1:A,2:B,3:C), Please refer to the table below
        #define RXP     1	        ; PIC RX Data port (1:A,2:B,3:C), Please refer to the table below
        #define TX	4		; PIC TX Data output pin (Port pin No.)
        #define RX      5	        ; PIC RX Data input pin (Port pin No.)
;        #define Direct_TX               ; RS-232C TX Direct Connection(No use MAX232)
;        #define Direct_RX               ; RS-232C RX Direct Connection(No use MAX232)

; !!!  Modified to fit the device above 5 lines  !!!

; +--------+------------+-----------+-------+------+-------+
; | Device | Erase_Page | max_flash | PORT  | PDIP | EE/PM |
; +--------+------------+-----------+-------+------+-------+
; | 12F617 |  16 words  |  0x0800   | A     |   8  |  PM   |
; +--------+------------+-----------+-------+------+-------+
; | 12F752 |  16 words  |  0x0400   | A     |   8  |  PM   |
; +--------+------------+-----------+-------+------+-------+
; | 16F753 |  16 words  |  0x0800   | A   C |  14  |  PM   |
; +--------+------------+-----------+-------+------+-------+
; | 16F818 |  32 words  |  0x0400   | A B   |  18  |  EE   |
; +--------+------------+-----------+-------+------+-------+
; | 16F819 |  32 words  |  0x0800   | A B   |  18  |  EE   |
; +--------+------------+-----------+-------+------+-------+
; |12F1501 |  16 words  |  0x0400   | A     |   8  |  PM   |
; +--------+------------+-----------+-------+------+-------+
; |16F1503 |  16 words  |  0x0800   | A   C |  14  |  PM   |
; +--------+------------+-----------+-------+------+-------+
; |16F1507 |  16 words  |  0x0800   | A B C |  20  |  PM   |
; +--------+------------+-----------+-------+------+-------+

#ifdef	EE
PMADRH	equ	EEADRH
PMADRL	equ	EEADR
PMDATH	equ	EEDATH
PMDATL	equ	EEDAT
PMCON1	equ	EECON1
PMCON2	equ	EECON2
#endif

#if (TXP==1)
TXPORT	equ	PORTA
#endif
#if (TXP==2)
TXPORT	equ	PORTB
#endif
#if (TXP==3)
TXPORT	equ	PORTC
#endif

#if (RXP==1)
RXPORT	equ	PORTA
#endif
#if (RXP==2)
RXPORT	equ	PORTB
#endif
#if (RXP==3)
RXPORT	equ	PORTC
#endif

;****************************************************************************************
;*											*
;*	Note (Important)								*
;*											*
;*	Rewrite the bootloader of PIC12F/16F without UART in this demonstration program.*
;*											*
;*	TREATERM is required for use.							*
;*											*
;*	How to use									*
;*											*
;*		‡@Write this program in Tiny PIC/AVR Bootloader+.			*
;*											*
;*		‡ATurn off the power of the board, to start the Teraterm.		*
;*											*
;*		‡BTurn on the power of the board					*
;*											*
;*		‡CThe drag-and-drop to TREATERM the HEX file that you want to rewrite.	*
;*											*
;*		‡DComplete rewrite, "Rewrite Done" message is displayed.		*
;*											*
;****************************************************************************************

; ********************************************************************
;			Registers (RAM) definition
; ********************************************************************

LC	EQU	0x70		;Loop counter
ADRH	EQU	0x71		;Flash address (H) temporary
SUM	EQU	0x72		;Checksum
temp	EQU	0x73		;Temporary
rxd	EQU	0x74		;Data buffer

; ********************************************************************
;			Codes
; ********************************************************************

	ORG	0x0000
	CLRF	PCLATH
	GOTO	INIT

; ********************************************************************
;			Data area
; ********************************************************************

	ORG	0x0004

MES001:					;Opening message
 DW	0x0D*0x80+0x0A			;New line
 DW	'*'*0x80+'*'			;***  Bootloader Rewrite V1.00 ***
 DW	'*'*0x80+' '			;
 DW	' '*0x80+'B'			;
 DW	'o'*0x80+'o'			;
 DW	't'*0x80+'l'			;
 DW	'o'*0x80+'a'			;
 DW	'd'*0x80+'e'			;
 DW	'r'*0x80+' '			;
 DW	'R'*0x80+'e'			;
 DW	'w'*0x80+'r'			;
 DW	'i'*0x80+'t'			;
 DW	'e'*0x80+' '			;
 DW 	'V'*0x80+'1'			;
 DW 	'.'*0x80+'0'			;
 DW 	'0'*0x80+' '			;
 DW 	' '*0x80+'*'			;
 DW	'*'*0x80+'*'			;
 DW	0x0D*0x80+0x0A			;New line
 DW	0x0D*0x80+0x0A			;New line
 DW	'D'*0x80+'r'			;Drag-and-Drop Bootloader Hex >>
 DW	'a'*0x80+'g'			;
 DW	'-'*0x80+'a'			;
 DW	'n'*0x80+'d'			;
 DW	'-'*0x80+'D'			;
 DW	'r'*0x80+'o'			;
 DW	'p'*0x80+' '			;
 DW	'B'*0x80+'o'			;
 DW	'o'*0x80+'t'			;
 DW	'l'*0x80+'o'			;
 DW	'a'*0x80+'d'			;
 DW	'e'*0x80+'r'			;
 DW	' '*0x80+'H'			;
 DW	'e'*0x80+'x'			;
 DW	' '*0x80+'>'			;
 DW	'>'*0x80			;

MES002:					;The completion of data reception
 DW	'>'*0x80+'>'			;>> Rcv OK
 DW	' '*0x80+'R'			;
 DW	'c'*0x80+'v'			;
 DW	' '*0x80+'O'			;
 DW	'K'*0x80			;

MES003:					;Data reception error
 DW	'!'*0x80+'!'			;!!! Read Error !!!
 DW	'!'*0x80+' '			;
 DW	'R'*0x80+'e'			;
 DW	'a'*0x80+'d'			;
 DW	' '*0x80+'E'			;
 DW	'r'*0x80+'r'			;
 DW	'o'*0x80+'r'			;
 DW	' '*0x80+'!'			;
 DW	'!'*0x80+'!'			;
 DW	0

MES004:					;Rewriting completion
 DW	'R'*0x80+'e'			;Rewrite Done
 DW	'w'*0x80+'r'			;
 DW	'i'*0x80+'t'			;
 DW	'e'*0x80+' '			;
 DW	'D'*0x80+'o'			;
 DW	'n'*0x80+'e'			;
 DW	0

	org	0x0100

 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF

; ********************************************************************
;
;			Main
;
; ********************************************************************

	org	0x0200

INIT:
	MOVLW	MES001			;***  Bootloader Rewrite V1.00 ***
	CALL	PUT2			;
                                        ;Send Bootloader Hex >>
Read_HEX:
	call	GETC			;receive a ':' ?
	movlw	':'
	subwf	rxd,w
	skpz
	goto	Read_HEX

	clrf	SUM			;SUM=0
	call	GET2SUM			;Get the number of data
	movwf	LC
	skpnz
	goto	Exit			;Loop_Counter=0 -> End code

	call	GET2SUM			;Get the address high
	movwf	ADRH
	call	GET2SUM			;Get the address low
       BANKSEL	PMADRL			 ;bank XX
	movwf	PMADRL
       BANKSEL	PIR1			 ;bank 0

       BANKSEL	PMADRH			 ;bank XX
	bcf	STATUS,C		;Set the address
	rrf	ADRH,w
	movwf	PMADRH
	rrf	PMADRL,f
       BANKSEL	PIR1			 ;bank 0
	sublw	((bl_adr>>8) & 0xFF)	;bl_adr(H)-PMADRH=0 ?
	skpz
	goto	Read_HEX		;No get next line

       BANKSEL	PMADRL			 ;bank XX
	movf	PMADRL,w
	movwf	temp
       BANKSEL	PIR1			 ;bank 0
	movlw	(bl_adr & 0xFF)		;PMADRL-bl_adr(L)>=0 ?
	subwf	temp,w
	skpc
	goto	Read_HEX		;No get next line

	call	GET2SUM			;Get the separator '00'

       BANKSEL	PMADRH			 ;bank XX
	movlw	0x01			;PMADRH=0x01
	movwf	PMADRH
	decf	PMADRL,f		;PMADRL=PMADRL-1
       BANKSEL	PIR1			 ;bank 0

r_loop:
	call	GET2SUM			;Get the data (L)
       BANKSEL	PMADRL			 ;bank XX
	incf	PMADRL,f		;PMADRL=PMADRL+1
	movwf	PMDATL
       BANKSEL	PIR1			 ;bank 0
	decf	LC,f			;LC=LC-1
	call	GET2SUM			;Get the data (H)
       BANKSEL	PMADRH			 ;bank XX
	movwf	PMDATH
       BANKSEL	PIR1			 ;bank 0
	movlw	((1<<7) | (1<<WREN))
	call	Write			;write
	decfsz	LC,f
	goto	r_loop

       BANKSEL	PMADRH			 ;bank XX
	movf	PMADRL,w
	movwf	temp
       BANKSEL	PIR1			 ;bank 0

Processing_of_the_end:
	movf	temp,w
	addlw	0x01
	skpndc
	goto	chk_sum

       BANKSEL	PMADRH			 ;bank XX
	movlw	0x3F
	movwf	PMDATH
	movlw	0xFF
	movwf	PMDATL
	incf	PMADRL,f		;PMADRL=PMADRL+1
       BANKSEL	PIR1			 ;bank 0
	movlw	((1<<7) | (1<<WREN))
	call	Write			;write
	incf	temp,f
	goto	Processing_of_the_end

chk_sum:
	call	GET2SUM			;Get checksum
	skpz
	goto	Err

	goto	Read_HEX


Exit:
	MOVLW	MES002		;>> Rcv OK
	CALL	PUT2
	CALL	CRLF
	CALL	CRLF

er_bl:				;erase bootloader
	CALL	set_pmadr
	MOVLW	.256/EPSIZE
	MOVWF	LC
er:
	movlw	((1<<7) | (1<<4) | (1<<WREN))
	CALL	Write
       BANKSEL	PMADRL		 ;bank XX
	MOVLW	EPSIZE
	ADDWF	PMADRL,F
       BANKSEL	PIR1		 ;bank 0
	DECFSZ	LC,f
	GOTO	er

cp_bl:				;copy
	CALL	set_pmadr
	clrf	LC
cp:
       BANKSEL	PMADRH		 ;bank XX
	movlw	0x01
	movwf	PMADRH		;PMADRH=0x01
       BANKSEL	PIR1		 ;bank 0
        call	Read
       BANKSEL	PMADRH		 ;bank XX
	movlw	((bl_adr>>8) & 0xFF)
	movwf	PMADRH		;PMADRH=rxd
       BANKSEL	PIR1		 ;bank 0
	movlw	((1<<7) | (1<<WREN))
	CALL	Write
       BANKSEL	PMADRL		 ;bank XX
	incf	PMADRL,f	;PMADRL = PMADRL + 1
       BANKSEL	PIR1		 ;bank 0
	DECFSZ	LC,f
	GOTO	cp

	CALL	CRLF
	MOVLW	MES004		;Rewrite Done
	CALL	PUT2
	CALL	CRLF
	GOTO	$		;stop


Err:
	MOVLW	MES003		;!!! Read Error !!!
	CALL	PUT2
	GOTO	$		;stop

; --------------------------------------------------------------------
;
;		Set PMADR and LC
;
; --------------------------------------------------------------------

set_pmadr:
       BANKSEL	PMADRH		 ;bank XX
	MOVLW	((bl_adr>>8) & 0xFF)
	MOVWF	PMADRH
	CLRF	PMADRL
       BANKSEL	PIR1		 ;bank 0
	RETURN

; --------------------------------------------------------------------
;
;		Set to W received the letter HEX2, SUM addition
;
; --------------------------------------------------------------------

GET2SUM:
	call	GETC
	movlw	0xC9
	btfss	rxd,6
	movlw	0xD0
	addwf	rxd,w
	movwf	temp
	call	GETC
	movlw	0xC9
	btfss	rxd,6
	movlw	0xD0
	addwf	rxd,w
	swapf	temp,f
	addwf	temp,w
	addwf	SUM,f
	return

; --------------------------------------------------------------------
;
;		It displays a message written to the flash
;
;		Input:W (Start address(L) of the message)
;
; --------------------------------------------------------------------

PUT2:
       BANKSEL	PMADRL			 ;bank XX
	MOVWF	PMADRL			;Set PMADR
	CLRF	PMADRH
       BANKSEL	PIR1			 ;bank 0
LOOP_P:
	call	Read
       BANKSEL	PMADRL			 ;bank XX
	INCF	PMADRL,F		;PMADRL = PMADRL + 1
	RLF	PMDATL,F		;Carry=a, PMDATL=bcdefghX
	RLF	PMDATH,W		;Carry=0, W=0ABCDEFa
	RRF	PMDATL,F		;Carry=X, PMDATL=0bcdefgh
       BANKSEL	PIR1			 ;bank 0
	CALL	PUTC			;display the first char
       BANKSEL	PMDATL			 ;bank XX
	MOVF	PMDATL,W		;W=PMDATL
       BANKSEL	PIR1			 ;bank 0
	skpnz				;W>0
	RETURN

	CALL	PUTC			;display next char
	GOTO	LOOP_P			;loop

; --------------------------------------------------------------------
;		New line
; --------------------------------------------------------------------

CRLF:
	MOVLW	0x0D
	CALL	PUTC
	MOVLW	0x0A

; ********************************************************************
;
;		RS-232C Send 1byte
;
;		Set W and Call (Return:W=0x80,Carry=1,Zero=1)
;
; ********************************************************************

PUTC:
		movwf   rxd             ;rxd=W

        #ifdef  Direct_TX
                bsf     TXPORT,TX	;Send START bit:TX=1
                call    bwait           ;Wait 1bit and Set Carry=1
		rrf     rxd,f		;Bit Output
                btfss   STATUS,C	;rxd_0=B'ABCDEFGH'
                bsf     TXPORT,TX	;rxd_1=B'1ABCDEFG'>1
                btfsc   STATUS,C	;rxd_2=B'01ABCDEF'>1
                bcf     TXPORT,TX       ;rxd_8=B'00000001'=1
                call    bwait           ;Wait 1bit
		bcf	STATUS,C	;Carry=0
		decfsz	rxd,W		;Send 8bits?
                goto    $-8             ;loop
                bcf     TXPORT,TX	;Send STOP bit:TX=0
        #else
                bcf     TXPORT,TX	;Send START bit:TX=0
                call    bwait           ;Wait 1bit and Set Carry=1
		rrf     rxd,f		;Bit Output
                btfss   STATUS,C	;rxd_0=B'ABCDEFGH'
                bcf     TXPORT,TX       ;rxd_1=B'1ABCDEFG'>1
                btfsc   STATUS,C	;rxd_2=B'01ABCDEF'>1
                bsf     TXPORT,TX	;rxd_8=B'00000001'=1
                call    bwait           ;Wait 1bit
		bcf	STATUS,C	;Carry=0
                decfsz  rxd,W           ;Send 8bits?
                goto    $-8             ;loop
                bsf     TXPORT,TX	;Send STOP bit:TX=1
        #endif

bwait:					; wait 1 bit
		call	bwait2		; 1 us  total:1+49+49=99 us
bwait2:					; wait 1/2bit and Set Carry=1
		movlw   .256-.24	; 0.5 us
                addlw   0x01           	; 0.5 us
                btfss	STATUS,Z        ; 0.5 us
                goto    $-2             ; 1 us
		retlw	0x80		; 1 us  total:0.5+(0.5+0.5+1)*24-0.5+1=49 us

; ********************************************************************
;
;		RS-232C Recieve 1byte
;
;		Return in W
;
; ********************************************************************

GETC:
        #ifdef  Direct_RX
                btfss   RXPORT,RX
        #else
                btfsc   RXPORT,RX
        #endif
                goto	$-1		; wait Start bit

		call    bwait2          ; wait 1/2 bit and W=B'10000000'
                movwf   rxd		; rxd = B'10000000'

		call    bwait           ; wait 1 bit and set Carry=1
        #ifdef  Direct_RX               ; set Carry
                btfsc   RXPORT,RX
        #else
                btfss   RXPORT,RX
        #endif
                bcf     STATUS,C
                rrf     rxd,f		; get bit data
		skpc			; Carry=1 skip
                goto    $-5		; Carry=0 loop
		call    bwait           ; wait 1 bit
                movf    rxd,w           ; return in w
                return

; ********************************************************************
;
;		Program Flash
;
;		Set PMADRH:PMADRHL,PMDATH:PMDATL and Call
;
; ********************************************************************

Write:				; write byte
       BANKSEL	PMCON1		 ;bank XX
	movwf	PMCON1
	movlw   0x55
        movwf   PMCON2
        movlw   0xaa
        movwf   PMCON2
	bsf	PMCON1,WR
        nop
        nop
	clrf	PMCON1
       BANKSEL	PIR1		 ;bank 0
	return

Read:
       BANKSEL	PMCON1		 ;bank XX
	bsf	PMCON1,7
	bsf	PMCON1,RD
	nop
	nop
	clrf	PMCON1
       BANKSEL	PIR1		 ;bank 0
	return

	END


