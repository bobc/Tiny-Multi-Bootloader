	LIST P=PIC18F14K50
	#include "p18f14k50.inc"

#define	bl_adr	0x3F00		;Start address of the bootloader
#define	EPSIZE	0x40		;The size of the erase page (bytes), See the User's Manual.
#define	WPSIZE	0x10		;The size of the write page (bytes), See the User's Manual.

; !!!  Modified to fit the device above 5 lines  !!!


;****************************************************************************************
;*											*
;*	Note (Important)								*
;*											*
;*	Rewrite the bootloader of PIC18F in this demonstration program.			*
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

LC	EQU	FSR1L		;Loop counter
SUM	EQU	FSR2L		;Checksum
temp	EQU	TBLPTRL		;Temporary

;bank0---
;buffer	256bytes

; ********************************************************************
;			Codes
; ********************************************************************

	ORG	0x0000

	GOTO	INIT

; ********************************************************************
;			Data area
; ********************************************************************

	ORG	0x0008

MES001:					;Opening message
 DW	0x0A0D				;New line
 DW	"***  Bootloader Rewrite V1.00  ***"
 DW	0x0A0D				;New line
 DW	0x0A0D				;New line
 DW	"Drag-and-Drop Bootloader Hex >>"
 DW	0

MES002:					;The completion of data reception
 DW	">> Rcv OK "
 DW	0

MES003:					;Data reception error
 DW	"!!! Read Error !!!"
 DW	0

MES004:					;Rewriting completion
 DW	"Rewrite Done"
 DW	0

; ********************************************************************
;
;			Main
;
; ********************************************************************

INIT:
;	bsf	OSCCON,IRCF2			;int clock 16MHz
;	clrf	ANSELH	 			; setup digital I/O
;	movlw 	((1<<TXEN) | (1<<BRGH))		;init serial port
;	movwf 	TXSTA
;	movlw	spbrg_value
;	movwf	SPBRG
	movlw	((1<<SPEN) | (1<<CREN))
	movwf	RCSTA

clr_ram:				;buffer ram clear
	clrf	FSR0H
	clrf	FSR0L
	movlw	0xFF
clr_loop:
	movwf	POSTINC0
	tstfsz	FSR0L
	bra	clr_loop

STAMSG:
	movlw	MES001			;***  Bootloader Rewrite V1.00 ***
	rcall	PUTM			;
                                        ;Send Bootloader Hex >>
Read:
	rcall	GETC			;receive a ':' ?
	movlw	':'
	cpfseq	RCREG
	bra	Read

	clrf	SUM			;SUM=0
	rcall	GET2SUM			;Get the number of data
	movwf	LC
	bz	Exit			;Loop_Counter=0 -> End code

	rcall	GET2SUM			;Get the address high
	movwf	TBLPTRH
	rcall	GET2SUM			;Get the address low
	movwf	FSR0L

	movlw	((bl_adr>>8) & 0xFF)	;TBLPTRH-bl_adr(H)=0 ?
	cpfseq	TBLPTRH
	bra	Read			;No get next line
	movlw	(bl_adr & 0xFF)		;FSR0L-bl_adr(L)>=0 ?
	subwf	FSR0L,w
	bnc	Read			;No get next line

	rcall	GET2SUM			;Get the separator '00'

	clrf	FSR0H

r_loop:
	rcall	GET2SUM			;Get the data
	movwf	POSTINC0
	decfsz	LC,f
	bra	r_loop

	rcall	GET2SUM			;Get checksum
	bz	Read
Err:
	movlw	MES003			;!!! Read Error !!!
	rcall	PUTM
	bra	$			;stop


Exit:
	movlw	MES002			;>> Rcv OK
	rcall	PUTM
	rcall	CRLF
	rcall	CRLF

erase_botloader:			;erase bootloader
	rcall	set_tblptr		;TBLPTR=bl_adr
	movlw	.256/EPSIZE		;set LC
	movwf	LC

erase_loop:
;	movlw	((1<<EEPGD) | (1<<FREE) | (1<<WREN))	; Setup erase
	movlw	((1<<7) | (1<<FREE) | (1<<WREN))	; Setup erase
	rcall 	Write			;erase
	movlw	EPSIZE			;TBLPTRL = TBLPTRL + EPSIZE
	addwf	TBLPTRL,f
	decfsz	LC,f
	bra	erase_loop

write_bootloader:
	rcall	set_tblptr		;TBLPTR=bl_adr-1
	TBLRD	*-
	clrf	FSR0H			;FSR0=0x0000
	clrf	FSR0L

write_bl:
 #IF (WPSIZE == 0x40)
	bsf 	LC,7			; 128bytes
 #ENDIF
 #IF (WPSIZE == 0x40)
	bsf 	LC,6			; 64bytes
 #ENDIF
 #IF (WPSIZE == 0x20)
	bsf 	LC,5			; 32bytes
 #ENDIF
 #IF (WPSIZE == 0x10)
	bsf 	LC,4			; 16bytes
 #ENDIF
 #IF (WPSIZE == 0x08)
	bsf 	LC,3			; 8bytes
 #ENDIF

write_byte:
	movff	POSTINC0,TABLAT		; write latch
	TBLWT+*
	decfsz 	LC,f
	bra 	write_byte
	
;	movlw	((1<<EEPGD) | (1<<WREN))	; Setup writes
	movlw	((1<<7) | (1<<WREN))	; Setup writes
	rcall 	Write
	tstfsz	FSR0L			; FSR0L=0 ?
	bra 	write_bl

	rcall	CRLF
	movlw	MES004			;Rewrite Done
	rcall	PUTM
	rcall	CRLF
	bra	$			;stop

; --------------------------------------------------------------------
;
;		Set TBLPTR
;
; --------------------------------------------------------------------

set_tblptr:
	movlw	((bl_adr>>16) & 0xFF)	;TBLPTR=bl_adr
	movwf	TBLPTRU
	movlw	((bl_adr>>8) & 0xFF)
	movwf	TBLPTRH
	movlw	(bl_adr & 0xFF)
	movwf	TBLPTRL
	return

; --------------------------------------------------------------------
;
;		Set to W received the letter HEX2, SUM addition
;
; --------------------------------------------------------------------

GET2SUM:
	rcall	GETC
	movlw	0xC9
	btfss	RCREG,6
	movlw	0xD0
	addwf	RCREG,w
	movwf	temp
	rcall	GETC
	movlw	0xC9
	btfss	RCREG,6
	movlw	0xD0
	addwf	RCREG,w
	swapf	temp,f
	addwf	temp,w
	addwf	SUM,f
	return

; --------------------------------------------------------------------
;		Put Messages
; --------------------------------------------------------------------

PUTM:
	MOVWF	TBLPTRL			;set TBLPTR
	CLRF	TBLPTRH
	CLRF	TBLPTRU
LOOP_P:
	TBLRD*+				;read flash
	MOVF	TABLAT,W		;W = TABLAT
	BTFSC	STATUS,Z		;W > 0
	RETURN				;exit

	RCALL	PUTC			;put char
	BRA	LOOP_P			;loop

; --------------------------------------------------------------------
;		New line
; --------------------------------------------------------------------

CRLF:
	MOVLW	0x0D
	RCALL	PUTC
	MOVLW	0x0A

; --------------------------------------------------------------------
;
;		RS-232C Send 1byte
;
;		set W and Call
;
; --------------------------------------------------------------------

PUTC:
	btfss 	TXSTA,TRMT		;ready check
	bra 	PUTC
	movwf   TXREG			;set TXREG
	return

; --------------------------------------------------------------------
;
;		RS-232C Recieve 1byte
;
; --------------------------------------------------------------------

GETC:
	btfss 	PIR1,RCIF		;ready check
	bra 	GETC
	return

; --------------------------------------------------------------------
;
;		write flash memory
;
;		Input: TBLPTRL, W
;
; --------------------------------------------------------------------

Write:
	movwf	EECON1
	movlw   0x55
        movwf   EECON2
        movlw   0xaa
        movwf   EECON2
	bsf	EECON1,WR
        nop
        nop
	return

	END


