	; change these lines accordingly to your application	

FamilyC8501	equ 	0x35		; C8501 Family="5"
IdTypeC8501	equ	0x51		; must exists in "piccodes.ini"	
max_flash	equ	0x1E00		; in bytes not Words!!! (= 'max flash memory' from "piccodes.ini")
xtal		equ	3062500/100 	; 24500000/8(Hz)
baud		equ	9600/100    	; standard TinyBld baud rates: 115200 or 19200

TX		equ	4		; C8501 TX Data output pin (i.e. 2 = P0.2)
RX		equ	5		; C8501 RX Data input  pin (i.e. 3 = P0.3)
;Direct_TX       set	0	        ; RS-232C TX Direct Connection(No use MAX232)
;Direct_RX       set	0	        ; RS-232C RX Direct Connection(No use MAX232)

;   The above 9 lines can be changed and buid a bootloader for the desired frequency

; +---------+---------+------------+------------+------------+-----------+
; |  Family |  IdType |   Device   | Erase_Page | Write_Page | max_flash |
; +---------+---------+------------+------------+------------+-----------+
; |   0x35  |   0x11  |  C8051F300 |  512 bytes |  256 bytes |  0x01E00  |
; +---------+---------+------------+------------+------------+-----------+

;buffer_map(Bootloader)
;0x00                        0x07(SP)  0x40           0xFF
;[R0][R1][R2][R3][R4][R5][R6][R7]......[buffer0]......[buffer191]
;
;buffer_map(UserProgram)
;0x00                        0x07(SP)  0xE0           0xFF
;[R0][R1][R2][R3][R4][R5][R6][R7]......[buffer0]......[buffer31]

;max_flash-1024	+---------------+			    +---------------+	  +---------------+  +---------------+
;		|		|  1.Copy Bootloader to RAM |               |	  |               |  |               |
;		|		|  2.Erase upper Flash Page |     0xFF      |	  |     0xFF      |  |     0xFF      |
;		|		|  3.Copy RAM to Flash	    |	            |	  |               |  |               |
;		| User Program1	|  4.Move PC to upper Flash |	            |	  |               |  |               |
;		|		|  5.Erase lower Flash Page |               |	  |               |  |               |
;		|		|  6.Copy RAM to Flash	    |	            |	  |		  |  |               |
;max_flash-704	|		|  7.Move PC to lower Flash +---------------+	  +---------------+  |               |
;		|		|  8.Erase Page 0 to last-1 |   Bootloader  |<-PC |   Bootloader  |  |               |
;max_flash-512	+---------------+  9.Write User Program	    +---------------+ 	  +---------------+  |               |
;		|		|    and User Vector  	    |	            |	  |               |  |               |
;		| User Program2	| 			    | User Program2 |	  |     0xFF      |  |               |
;		|    		| <RAM>			    |               |	  |               |  |               |
;max_flash-196	+---------------+ 0x000	+---------------+   +---------------+	  |               |  |               |
;		|    Vector	|	|               |   |    Vector     |	  |               |  |               |
;max_flash-192	+---------------+ 0x020	+---------------+   +---------------+	  +---------------+  +---------------+
;		|   Bootloader	|	|   Bootloader	|   |   Bootloader  | PC->|   Bootloader  |  |   Bootloader  |
;max_flash	+---------------+ 0x100	+---------------+   +---------------+	  +---------------+  +---------------+


    	;********************************************************************
    	;       Tiny Bootloader            C8051F300            Size=196bytes
	;
	;	(2014.08.11 Revision 2)
	;
	;	This program is only available in Tiny PIC Bootloader +.
	;
	;	Tiny PIC Bootloader +
	;	https://sourceforge.net/projects/tinypicbootload/
	;
	;	Please add the following line to piccodes.ini
	;
	;	$51, 5, C8051 F300, 		$1E00, 0, 196, 32,
	;
	;********************************************************************


first_address	equ	max_flash - 196 ; 196 bytes in size

;crc		equ	R1
;cnt1		equ	R2
;cnt2		equ	R3
;cnt3		equ	R4
;cn		equ	R2
;rs		equ	R3

PSCTL		equ	0x8F
P0MDOUT		equ	0xA4
FLKEY		equ	0xB7
PCA0MD		equ	0xD9
XBR0		equ	0xE1
XBR1		equ	0xE2
XBR2		equ	0xE3

;-----------------------------------------------------------------------------
; RESET and INTERRUPT VECTORS
;-----------------------------------------------------------------------------

		ORG	0x0000
            	LJMP 	IntrareBootloader       ; Locate a jump to the start of code at the reset vector.
;
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;
;PC_flash:      C1h          AddrH  AddrL  nr  ...(DataLo DataHi)...  crc
;PIC_response:  id   K

;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------

		ORG	first_address
                NOP
                NOP
                NOP
                NOP

		ORG	first_address+4
IntrareBootloader:
		MOV	PCA0MD,#0	        	; disable Watchdog

            	MOV   	XBR0,#((1 SHL TX)|(1 SHL RX))   ; skip TX,RX pin in crossbar
            	MOV   	XBR2,#0x40			; assignments
            	MOV   	P0MDOUT,#(1 SHL TX)           	; make TX pin output push-pull

                ACALL	Receive				; wait for computer
		CJNE	A,#0xC1,first_address		; connection errer or timeout

		MOV	R0,#LOW(IntrareBootloader)	; R0 = buffer top
		MOV	DPTR,#(max_flash-256)		; DPTR = IntrareBootloader - 0x20
copy_flash_to_RAM:
		MOV	A,R0
		MOVC	A,@A+DPTR
		MOV	@R0,A
		INC	R0
		CJNE	R0,#0x00,copy_flash_to_RAM	; loop

wr_BL1:
		MOV	DPTR,#(IntrareBootloader-512)	; erase previous page
		ACALL	esequence			; erase page
write_BL:
		ACALL	wsequence			; write bootloader
		INC	DPTR
		CJNE	R0,#0xFF,write_BL		; loop
		AJMP	wr_BL2-512			; goto previous page

wr_BL2:
		MOV	DPTR,#IntrareBootloader		; erase last page
		ACALL	esequence-512			; erase page
rewrite_BL:
		ACALL	wsequence-512			; rewrite bootloader
		INC	DPTR
		CJNE	R0,#0xFF,rewrite_BL		; loop
		AJMP	erase_all_flash			; goto last page, DPL = 0x00

erase_all_flash:
		MOV	R0,#HIGH(max_flash-1024)	; R0 = High(max_flash-1024)
e_loop:
		MOV	DPH,R0				; set DPTR
		ACALL	esequence			; erase page
		DEC	R0				; R0 = R0 -2
		DJNZ	R0,e_loop			; loop
		ACALL	esequence			; erase page 0

send_IdType:
                MOV	A,#IdTypeC8501		; send IdType
        	ACALL	SendL

MainLoop:
		MOV	A,#FamilyC8501		; send Family ID
mainl:
		ACALL	SendL
		MOV	R1,#0			; clear Checksum
                ACALL	Receive			; get ADR_H
		MOV	DPH,A
                ACALL	Receive			; get ADR_L
		MOV	DPL,A
;		MOV	R0,#0xE0
                ACALL	FSReceive		; get count (Only Receive)
rcvoct:
	        ACALL	Receive			; get Data
		MOV	@R0,A			; set Data
		INC	R0
		CJNE	R0,#0x00,rcvoct		; loop

;		MOV	R0,#0xE0
                ACALL	FSReceive		; get Checksum
ziieroare:
		MOV	A,#'N'			; send "N"
		CJNE	R1,#0x00,mainl		; retry
write_flash:
		ACALL	wsequence1
		INC	DPTR
		INC	R0
		CJNE	R0,#0x00,write_flash
		SJMP	MainLoop



FSReceive:
		MOV	R0,#0xE0

; ********************************************************************
;
;		RS-232C Recieve 1byte with Timeout and Check Sum
;
; ********************************************************************

Receive:
		MOV	R2,#(xtal/(500000/100)+2)	; for 20MHz => 11 => 1second
rpt2:
;		MOV	R3,#0
rpt3:
;		MOV	R4,#0
rptc:
					; check Start bit
	IFDEF  Direct_RX
		JNB	P0.RX,no_data
	ELSE
		JB	P0.RX,no_data
	ENDIF

		ACALL	bwait2		; wait 1/2 bit
        	MOV     R2,#(1+8)	; 9-bit Data

		RRC	A		; set Data			[1] 1+6N+20+2+3=6N+26
		ACALL	bwait		; wait 1 bit and Carry='1'	[6N+20]
		MOV	C,P0.RX		;				[2]
		DJNZ    R2,$-5		;				[3]

	IFDEF  Direct_RX
                CPL	A
	ELSE
                NOP
	ENDIF
		MOV	R2,A		; A = Data
                ADD	A,R1		; compute checksum
		MOV	R1,A
		MOV	A,R2
		RET

no_data:
                DJNZ	R4,rptc
                DJNZ	R3,rpt3
                DJNZ	R2,rpt2
way_to_exit:
                AJMP	first_address	; timeout:exit in all other cases

; ********************************************************************
;
;		RS-232C Transmit 1byte
;
; ********************************************************************

SendL:
	IFDEF  Direct_TX
		CLR	P0.TX
	ELSE
		SETB	P0.TX
	ENDIF

        	MOV     R2,(1+8+1)	; 10-bit Data
		SJMP	$+9		; Start bit

        	RRC     A		; Rotate Right through Carry	[1] 1+7+6N+20+3=6N+31
	IFDEF  Direct_TX
        	JNC	$+4
		CLR	P0.TX		; set TX='0' if Carry='1'
        	JC	$+4
        	SETB	P0.TX		; set TX='1' if Carry='0'
	ELSE
        	JNC	$+4
        	SETB	P0.TX		; set TX='1' if Carry='1'
        	JC	$+4
        	CLR	P0.TX		; set TX='0' if Carry='0'
	ENDIF
        	ACALL	bwait		; wait 1 bit and Carry='1'	[3+3+3N+7+3N+7]
		DJNZ    R2,$-11		;				[3]
bwait:					; wait 1 bit
		ACALL	bwait2
bwait2:					; wait 1/2bit
		MOV	R3,#(xtal/baud-29)/6		;[2] 2+3*N-1+1+5=3N+7
        	DJNZ	R3,$				;[3/2]
		SETB	C				;[1]
		RET					;[5]

; ********************************************************************
;
;		Write Flash Write sequence
;
; ********************************************************************

esequence:
		MOV	PSCTL,#3
		SJMP	sequence

wsequence:
		MOV	R0,DPL
wsequence1:
		MOV	A,@R0
		MOV	PSCTL,#1
sequence:
		MOV	FLKEY,#0xA5
		MOV	FLKEY,#0xF1
		MOVX	@DPTR,A
		RET

		END
