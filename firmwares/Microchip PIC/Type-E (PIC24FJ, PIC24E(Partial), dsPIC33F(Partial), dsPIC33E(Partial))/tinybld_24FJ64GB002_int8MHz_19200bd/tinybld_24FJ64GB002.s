	; change these lines accordingly to your application	
.equ __24FJ64GB002, 1
.include "p24FJ64GB002.inc"
.equ IdTypePIC, 0xA3		; Please refer to the table below, must exists in "piccodes.ini"	
.equ max_flash, 0xAC00		; 24FJ max address, not bytes!!! (= 'max flash memory' from "piccodes.ini" divided by 2), Please refer to the table below

.equ Fcy, 8000000/2	; you may also want to change: _HS_OSC _XT_OSC
.equ baud, 19200	; standard TinyBld baud rates: 115200 or 19200
.equ cfg_l, 4		; Configure length(instr.)
.equ UART_CH, 1		; select UART(1/2)
.equ RX, 9		; RX Pin = PRn Pin
.equ TX, 8		; TX Pin = PRn Pin


;   The above 10 lines can be changed and buid a bootloader for the desired frequency (and PIC type)

; +---------+-------------+------------+------------+-------------+--------------+-----------+--------+-------+
; |IdTypePIC|    Device   | Write_Page | Erase_Page |   TX port   |    RX port   | max_flash | EEPROM | cfg_l |
; +---------+-------------+------------+------------+-------------+--------------+-----------+--------+-------+
; |   0xA1  | 24FJ32GB002 |  64 instr. | 512 instr. |  RP0~RP15   | RP0~RP15,Vss |   0x5800  |   0    |   4   |
; |   0xA1  | 24FJ32GB004 |  64 instr. | 512 instr. |  RP0~RP25   | RP0~RP25,Vss |   0x5800  |   0    |   4   |
; |   0xA3  | 24FJ64GB002 |  64 instr. | 512 instr. |  RP0~RP15   | RP0~RP15,Vss |   0xAC00  |   0    |   4   |
; |   0xA3  | 24FJ64GB004 |  64 instr. | 512 instr. |  RP0~RP25   | RP0~RP25,Vss |   0xAC00  |   0    |   4   |
; +---------+-------------+------------+------------+-------------+--------------+-----------+--------+-------+

;max_flash-2048	+---------------+    1.Copy Flash to RAM	+---------------+	+---------------+
;		|		|    2.Rewrite Config or not	|     		|	|      		|
;		| 		|    3.Erase upper Flash Page	|    0xFFFF	|	|    0xFFFF	|
;		| User Program1	|    4.Copy RAM to Flash	|		|	|		|
;		|		|    5.Move PC to upper	Flash	|   		|	|     		|
;max_flash-1280	|		|    6.Erase lower Flash Page	+---------------+	+---------------+
;		|		|    7.Copy RAM to Flash	|   Bootloader	|<-PC	|  Bootloader	|
;max_flash-1028	|		|    8.Move PC to lower	Flash 	+---------------+	+---------------+
;		|   		|    9.Write User Program	|   Configure1	|	|   Configure1	|
;max_flash-1024	+---------------+      and Vector		+---------------+	+---------------+
;		|		|      				|		|	|		|
;		| User Program2	|				| User Program2	|	|    0xFFFF	|
;max_flash-264	+---------------+				+---------------+	|		|
;		|    Vector	| <RAM>				|    Vector	|	|     		|
;max_flash-256	+---------------+ buffer+---------------+	+---------------+	+---------------+
;		|   Bootloader	|	|   Bootloader	|	|   Bootloader	|	|   Bootloader	|<-PC
;max_flash-4	+---------------+ 	+---------------+	+---------------+	+---------------+
;		|   Configure0	|	|   Configure1	|	|   Configure0	|	|   Configure1	|
;max_flash	+---------------+ 	+---------------+	+---------------+	+---------------+


;PC_flash:	L       H       U      192      ...  [DataL DataH DataU]*64    ...         crc
;PC_cfg:        L       H       U      30       ...  [CFGDataL CFGDataH 0]*10  ...         crc
;PC_cfg_unnecessary:	0	crc
;PIC_response:	type `E`

;;;;;;  PC_cfg Data:[CFGDataL CFGDataH 0]*10 (Type E) ;;;;;
;max_flash-10instr.*2                                        max_flash
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;|  X  |  X  |  X  |  X  |  X  |  X  |  X  |  X  |  O  |  O  | for PIC24FJXXXMCXXX, PIC24FJXXXGA0XX
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;|  X  |  X  |  X  |  X  |  X  |  X  |  X  |  O  |  O  |  O  | for PIC24FJ(64/128/192/256)(GA/GB)106/108/110
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;|  X  |  X  |  X  |  X  |  X  |  X  |  O  |  O  |  O  |  O  | for other PIC24FJ
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;|  O  |  O  |  O  |  O  |  O  |  O  |  O  |  O  |  O  |  O  | for PIC24EPXXX(GP/MC)20X
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;|  X  |  X  |  O  |  O  |  O  |  O  |  O  |  O  |  O  |  O  | for dsPIC33FJ06GS001/101A/102A/202A/302
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;|  X  |  X  |  X  |  X  |  X  |  X  |  X  |  X  |  O  |  O  | for dsPIC33FJ16(GP/MC)101/102,
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+     dsPIC33FJ32(GP/MC)101/102/104
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;|  O  |  O  |  O  |  O  |  O  |  O  |  O  |  O  |  O  |  O  | for dsPIC33EPXXXGP50X, dsPIC33EPXXXMC20X/50X,
;+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+     dsPIC33EPXXXGM3XX/6XX/7XX
;X:Invalid(recive only), O:Effectiveness, rewrite Config

.IF (UART_CH == 1)
 .equ UxMODE, U1MODE
 .equ UxSTA, U1STA
 .equ UxBRG, U1BRG
 .equ UxTXREG, U1TXREG
 .equ UxRXREG, U1RXREG
 .equ UxPINR, RPINR18
 .equ UxTX, #3			;U1TX = #3
.ELSE
 .equ UxMODE, U2MODE
 .equ UxSTA, U2STA
 .equ UxBRG, U2BRG
 .equ UxTXREG, U2TXREG
 .equ UxRXREG, U2RXREG
 .equ UxPINR, RPINR19
 .equ UxTX, #5			;U2TX = #5
.ENDIF

        ;********************************************************************
	;	Tiny Bootloader	    24FJ32GB002/4 24FJ64GB002/4 Size=132words
        ;       claudiu.chiculita@ugal.ro
        ;       http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;
	;	This program is only available in Tiny AVR/PIC Bootloader +.
	;
	;	Tiny AVR/PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	$A1, E, PIC24FJ w/32KB flash,      $B000, 0, default, default,
	;	$A3, E, PIC24FJ w/64KB flash,     $15800, 0, default, default,
	;
        ;********************************************************************

config          __CONFIG4, DSWDTPS_DSWDTPS0 & DSWDTOSC_SOSC & RTCOSC_LPRC & DSBOREN_OFF & DSWDTEN_OFF
config          __CONFIG3, WPFP_WPFP0 & SOSCSEL_IO & WUTSEL_LEG & WPDIS_WPDIS & WPCFG_WPCFGDIS & WPEND_WPSTARTMEM
config          __CONFIG2, POSCMOD_NONE & I2C1SEL_PRI & IOL1WAY_OFF & OSCIOFNC_ON & FCKSM_CSDCMD & FNOSC_FRC & PLL96MHZ_OFF & PLLDIV_NODIV & IESO_OFF
config          __CONFIG1, WDTPS_PS1 & FWPSA_PR32 & WINDIS_OFF & FWDTEN_OFF & ICS_PGx1 & GWRP_OFF & GCP_OFF & JTAGEN_OFF

;REGISTRY:
;W0	imediat
;W1	crc
;W2	EA Write
;W3	memory buffer pointer
;W4
;W5
;W6
;W7
;W8
;W9
;W10	delay1
;W11	delay2
;W12	for/do
;W13
;W14	void(black hole)
;W15	stack

        .global __reset
	.section RAM,bss
stack:	.space 64		;stack
buffer:	.space (64*3)+(64*3)+30	;Data

	.text
.equ	bl_size	,64*2*2		;size of bootloader:64*2+4 = 132instr.

	.org	max_flash - 0x200 - bl_size - 4*2
first_address:
	NOP
	NOP
	NOP
	NOP
__reset:			;Start of main code label, initial stack pointer = 0x800
;	BSET	PMD1,#ADC1MD	;A/D module disable
	COM	AD1PCFG		;All Degital Port
	MOV	#OSCCON,W1	;OSCCON (low byte) Unlock Sequence
	MOV	#0x46,W2
	MOV     #0x57,W3

	MOV.B 	W2,[W1] 	; Write 0x46
	MOV.B 	W3,[W1] 	; Write 0x57
	BCLR.B	OSCCON,#IOLOCK	; Unlock

	MOV	#RX,W0		;Set RX port	;assign TX and RX port
	MOV.B	WREG,UxPINR

	MOV	#UxTX,W0	;Set TX port
	MOV.B	WREG,(RPOR0+TX)

	MOV.B 	W2,[W1] 	; Write 0x46
	MOV.B 	W3,[W1] 	; Write 0x57
	BSET.B	OSCCON,#IOLOCK	; Relock

init_uart:					;Initialize and Enable UART for Tx and Rx
	bset	UxMODE,#UARTEN
	bset	UxSTA,#UTXEN
        mov     #(((Fcy/baud) / 16) - 1),W0  	;?Initialize Baud rate (divide INSTRUCTION Cycle)
        mov     W0,UxBRG			;to 115200 Kbaud #(((7372800/115200) / 16) - 1)

	rcall	Receive				;wait for computer
	sub.b	#0xC1,W0			;Expect C1h
	bra	NZ,way_to_exit
	mov.b	#IdTypePIC,W0			;send PIC type
	mov	W0,UxTXREG
	mov.b 	#'E',W0				; "-Everything OK, ready and waiting."
	mov 	W0,UxTXREG

	mov	#(((max_flash - bl_size)>>16)&0xFFFF),W0	;set TBLPAG
	mov	W0,TBLPAG
	mov	#((max_flash - bl_size)&0xFFFF),W2		;W2 = EA
	mov	#buffer,W3					;W3 = Data buffer TOP
	mov	#128,W12					;W12 = loop counter
cp_bl:								;copy bootloader to RAM
	TBLRDL.B [W2++],[W3++]
	TBLRDL.B [W2--],[W3++]
	TBLRDH.B [W2],[W3++]
	inc2	W2,W2
	dec	W12,W12
	bra 	NZ,cp_bl

rcv_cfg:
	clr 	W1				;clear chksum
	rcall 	Receive
	bra	Z,chk_crc			;branch if not CFG_Address(L)
	mov	#(3+(10-cfg_l)*3),W12		;W12 = count
	rcall 	dorcv				;recive Config H,U,C and (10-cfg_l)*3bytes (dummy write)
rewrite_cfg:
	mov	#buffer+(bl_size/2-cfg_l)*3,W3	;W3 = Config location in the buffer
	mov	#cfg_l*3,W12			;W12 = count
	rcall 	dorcv				;recive Config data and rewrite buffer
chk_crc:
	rcall 	Receive				;get crc
	bra	NZ,way_to_exit			;crc error

wr_bl1:
	mov	#((max_flash - bl_size - 512*2)&0xFFFF),W2	;set EA
	rcall 	wr_bld						;write bootloader
	bra 	(wr_bl2 - 512*2)				;move PC
wr_bl2:
	mov	#((max_flash - bl_size)&0xFFFF),W2		;set EA
	rcall 	wr_bld						;write bootloader
	bra 	(MainLoop + 512*2)				;move PC

MainLoop:
	mov.b 	#'E',W0				; "-Everything OK, ready and waiting."
mainl:
	mov 	W0,UxTXREG
	clr 	W1				;clear chksum
	rcall 	Receive				;set EA,TBLPAG,Count
	mov.b 	WREG,WREG2L
	rcall 	Receive
	mov.b 	WREG,WREG2H			;W2 = EA
	rcall 	Receive
	mov 	W0,TBLPAG			;set TBLPAG
	rcall 	Receive
	mov	W0,W12				;W12 = count
	mov 	#buffer,W3			;W3 = Data buffer TOP
	rcall 	dorcv				;recive Data
	rcall 	Receive				;check CRC
ziieroare:
	mov.b 	#'N',W0
	bra 	NZ,mainl

	mov	#buffer,W3			;W3 = Data buffer TOP
	rrc 	TBLPAG,WREG			;W12=((TBLPAG:W2>>2)&0xFFFF)
	rrc 	W2,W12
	rrc 	W0,W0
	rrc	W12,W12
	cp0.b	W12				;W12=B'XXXXXXXX00000000'?
	bra 	NZ,noerase			;Each 512instr.?

.IF (max_flash == 0x5800)
	mov 	#0x1500,W0			;0x1500 = ((0x5800 - 512*2)>>2)&0xFFFF
.ENDIF
.IF (max_flash == 0xAC00)
	mov 	#0x2A00,W0			;0x2A00 = ((0xAC00 - 512*2)>>2)&0xFFFF
.ENDIF
	cpseq 	W12,W0				;skip if Last Erase Page
	rcall	Erase_Page
noerase:
	rcall	wr_64instr
	bra	MainLoop

	;-----------------------------------------------------	


dorcv:
	rcall 	Receive
	mov.b 	W0,[W3++]
	dec 	W12,W12
	bra 	NZ,dorcv
	return


wr_bld:
	MOV	#buffer,W3			;W3 = Data buffer TOP
	RCALL	Erase_Page
	RCALL	wr_64instr
wr_64instr:
	MOV	#64,W12				;W12 = loop counter
wr_lp:
	TBLWTL.B [W3++],[W2++] 			; Write PM low word into program latch
	TBLWTL.B [W3++],[W2--] 			; Write PM high byte into program latch
	TBLWTH.B [W3++],[W2] 			; Write PM middle word into program latch
	INC2 	W2,W2
	DEC	W12,W12
	BRA 	NZ,wr_lp
	MOV	#((1<<WREN)|(1<<NVMOP0)),W0	;Page Write:0x4001
	BRA	Key_Sequence


Erase_Page:
	TBLWTL	W0,[W2]					;dummy
	MOV 	#((1<<WREN)|(1<<ERASE)|(1<<NVMOP1)),W0	;Page Erase:0x4042
Key_Sequence:						; Expects a NVMCON value in W0
	MOV 	W0,NVMCON
	MOV 	#0x55,W0				; Write the key sequence
	MOV 	W0,NVMKEY
	MOV 	#0xAA,W0
	MOV 	W0,NVMKEY
	BSET 	NVMCON,#WR				; Start the write cycle
	NOP
	NOP
	RETURN


Receive:
	mov 	#(2*Fcy/2000000+2),W10	; ms to wait
rpt2:
;	clr 	W11
rpt1:
	btss 	UxSTA,#URXDA
	bra 	norcv
	mov 	UxRXREG,W0		;W0 = Data
	add.b 	W0,W1,W1		;compute crc
	return
norcv:
	dec 	W11,W11
	bra 	NZ,rpt1
	dec 	W10,W10
	bra 	NZ,rpt2
timeout:
way_to_exit:
	clr 	UxMODE			; deactivate UART
	bra 	first_address


.end



