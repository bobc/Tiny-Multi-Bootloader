	LIST P=PIC10F322
	#INCLUDE <P10F322.INC>

	__CONFIG _FOSC_INTOSC & _BOREN_OFF & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _LVP_OFF & _LPBOR_OFF & _BORV_HI & _WRT_OFF

	#DEFINE		TX	2	;PIC TX Data output pin (i.e. 2 = RA2)
	#DEFINE		RX	3	;PIC RX Data input pin (i.e. 3 = RA3)
	#DEFINE		Direct_RX	;RS-232C TX Direct Connection(No use MAX232)
	#DEFINE		Direct_TX	;RS-232C RX Direct Connection(No use MAX232)

;****************************************************************************************
;*											*
;*	Note (Important)								*
;*											*
;*	Rewrite the bootloader of PIC10F322 in this demonstration program.		*
;*											*
;*	TREATERM is required for use.							*
;*	Communication conditionsF 9600bps, 8bits, 1stop-bit No parity			*
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
;			Constant definition
; ********************************************************************

bl_adr	equ	0x0180		;Start address of the bootloader

; ********************************************************************
;			Registers (RAM) definition
; ********************************************************************

LC	EQU	0x70		;Loop counter
ADRH	EQU	0x71		;Flash address (H) temporary
SUM	EQU	0x72		;Checksum
temp	EQU	0x73		;Temporary

rxd	EQU	0x7F		;Send and receive data buffer

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

; ********************************************************************
;
;			Main
;
; ********************************************************************

INIT:
;	BCF	OPTION_REG,T0CS		;set RA2 I/O
;	CLRF    ANSELA          	;all digital I/O
;	CLRF	TRISA			;RA0=OUTP RA1=SYNC RA2=TX RA3=RX

; #ifdef Direct_TX			;Set TX
;	bcf	LATA,TX
; #else
;	bsf	LATA,TX
; #endif
;
;	BSF	OSCCON,IRCF0		;Clock 16MHz


STAMSG:
	MOVLW	MES001			;***  Bootloader Rewrite V1.00 ***
	CALL	PUT2			;
                                        ;Send Bootloader Hex >>
Read:
	call	GETC			;receive a ':' ?
	movlw	':'
	subwf	rxd,w
	skpz
	goto	Read

	clrf	SUM			;SUM=0
	call	GET2SUM			;Get the number of data
	movwf	LC
	skpnz
	goto	Exit			;Loop_Counter=0 -> End code

	call	GET2SUM			;Get the address high
	movwf	ADRH
	call	GET2SUM			;Get the address low
	movwf	PMADRL

	bcf	STATUS,C		;Set the address
	rrf	ADRH,w
	movwf	PMADRH
	rrf	PMADRL,f

	movlw	((bl_adr>>8) & 0xFF)	;PMADRH-bl_adr(H)=0 ?
	subwf	PMADRH,w
	skpz
	goto	Read			;No get next line
	movlw	(bl_adr & 0xFF)		;PMADRL-bl_adr(L)>=0 ?
	subwf	PMADRL,w
	skpc
	goto	Read			;No get next line

	call	GET2SUM			;Get the separator '00'

	decf	PMADRH,f		;PMADR=PMADR-0x100
	decf	PMADRL,f		;PMADR=PMADR-1
r_loop:
	call	GET2SUM			;Get the data (L)
	movwf	PMDATL
	decf	LC,f			;LC=LC-1
	call	GET2SUM			;Get the data (H)
	movwf	PMDATH
	incf	PMADRL,f		;PMADRL=PMADRL+1
	call	wr_l			;latch write
	decfsz	LC,f
	goto	r_loop

	call	GET2SUM			;Get checksum
	skpz
	goto	Err

	call	wr_w			;Flash write
	goto	Read


	org	0x0080

 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF
 DW 0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF,0x3FFF


	org	0x0100

Exit:
	MOVLW	MES002		;>> Rcv OK
	CALL	PUT2
	CALL	CRLF
	CALL	CRLF

er_bl:				;erase 0x0180_0x01FF
	CALL	set_pmadr
er:
	CALL	wr_e
	MOVLW	0x10
	ADDWF	PMADRL,F
	DECFSZ	LC,f
	GOTO	er

cp_bl:				;copy 0x0080 -> 0x0180
	CALL	set_pmadr
	decf	PMADRL,f	;PMADRL = PMADRL - 1
cp1:
	MOVLW	0x10		;temp = 0x10
	MOVWF	temp
cp2:
	bcf	PMADRH,0	;PMADR=0
	incf	PMADRL,f	;PMADRL = PMADRL + 1
	CALL	rd
	CALL	wr_l
	DECFSZ	temp,f
	GOTO	cp2

	bsf	PMADRH,0	;PMADRH=1
	call	wr_w		;write
	DECFSZ	LC,f
	GOTO	cp1

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
	MOVLW	((bl_adr>>8) & 0xFF)
	MOVWF	PMADRH
	MOVLW	(bl_adr & 0xFF)
	MOVWF	PMADRL
	MOVLW	.8			;8=0x80/0x10
	MOVWF	LC
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
	MOVWF	PMADRL			;Set PMADR
	CLRF	PMADRH
LOOP_P:
	call	rd
	INCF	PMADRL,F		;PMADRL = PMADRL + 1
	RLF	PMDATL,F		;Carry=a, PMDATL=bcdefghX
	RLF	PMDATH,W		;Carry=0, W=0ABCDEFa
	RRF	PMDATL,F		;Carry=X, PMDATL=0bcdefgh
	CALL	PUTC			;display the first char
	MOVF	PMDATL,W		;W=PMDATL
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
                bsf     PORTA,TX	;Send START bit:TX=1
                call    bwait           ;Wait 1bit and Set Carry=1
		rrf     rxd,f		;Bit Output
                btfss   STATUS,C	;rxd_0=B'ABCDEFGH'
                bsf     PORTA,TX	;rxd_1=B'1ABCDEFG'>1
                btfsc   STATUS,C	;rxd_2=B'01ABCDEF'>1
                bcf     PORTA,TX        ;rxd_8=B'00000001'=1
                call    bwait           ;Wait 1bit
		bcf	STATUS,C	;Carry=0
		decfsz	rxd,W		;Send 8bits?
                goto    $-8             ;loop
                bcf     PORTA,TX	;Send STOP bit:TX=0
        #else
                bcf     PORTA,TX	;Send START bit:TX=0
                call    bwait           ;Wait 1bit and Set Carry=1
		rrf     rxd,f		;Bit Output
                btfss   STATUS,C	;rxd_0=B'ABCDEFGH'
                bcf     PORTA,TX        ;rxd_1=B'1ABCDEFG'>1
                btfsc   STATUS,C	;rxd_2=B'01ABCDEF'>1
                bsf     PORTA,TX	;rxd_8=B'00000001'=1
                call    bwait           ;Wait 1bit
		bcf	STATUS,C	;Carry=0
                decfsz  rxd,W           ;Send 8bits?
                goto    $-8             ;loop
                bsf     PORTA,TX	;Send STOP bit:TX=1
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
                btfss   PORTA,RX
        #else
                btfsc   PORTA,RX
        #endif
                goto	$-1		; wait Start bit

		call    bwait2          ; wait 1/2 bit and W=B'10000000'
                movwf   rxd		; rxd = B'10000000'

		call    bwait           ; wait 1 bit and set Carry=1
        #ifdef  Direct_RX               ; set Carry
                btfsc   PORTA,RX
        #else
                btfss   PORTA,RX
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
;		read/Program Flash
;
;		Set PMADRH:PMADRHL,PMDATH:PMDATL and Call
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
rd:
		bsf	PMCON1,RD
                nop
                nop
		clrf	PMCON1
		return

	END


