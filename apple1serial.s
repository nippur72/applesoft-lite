.setcpu "6502"
.segment "BASIC"

.include "zeropage.s"

.importzp ERR_SYNTAX, ERR_NOSERIAL
.import ERROR, FIX_LINKS, OUTDO
.export SerialLoad, SerialSave, SerialMenu

SERIAL_MONITOR := $C100
SERIAL_READY := $C000
SERIAL_ID := $C0FC
SERIAL_API_READ := $C1EC
SERIAL_API_WRITE := $C213

; ZP locations get backed up here
ZPTemp		:= $0380

;End address of dump block
END_ADDR_L := $34
END_ADDR_H := $35

;Begin address of dump block
BEG_ADDR_L := $36
BEG_ADDR_H := $37

;String to int ZP variables
STR2INT_BUF := $38
STR2INT_INT := $3E

STR2INT_END := $0A

; ----------------------------------------------------------------------------
; See if Apple-1 Serial Interface card is present and display error if not
; ----------------------------------------------------------------------------
CheckSerial:
	ldy	SERIAL_ID
	cpy	#'A'
	bne	SerialErr
	ldy	SERIAL_ID + 1
	cpy	#'1'
	bne	SerialErr
	ldy	SERIAL_ID + 2
	cpy	#'S'
	bne	SerialErr
	ldy	SERIAL_ID + 3
	cpy	#'I'
	bne	SerialErr
	rts

SerialErr:
  ldx	#ERR_NOSERIAL
  .byte	$2C		; Bogus BIT instruction
SynErr:
  ldx	#ERR_SYNTAX
  jmp	ERROR		; Jump to Applesoft ERROR routine


; ----------------------------------------------------------------------------
; Bring up the Apple-1 Serial Interface menu
; ----------------------------------------------------------------------------
SerialMenu:
  jsr	CheckSerial
	jsr SERIAL_MONITOR


; ----------------------------------------------------------------------------
; Save program via the Apple-1 Serial Interface
; ----------------------------------------------------------------------------
SerialSave:
	jsr	CheckSerial

	ldy	#0
@1:
	lda	END_ADDR_L,y	; Back up 4 affected bytes of the ZP
	sta	ZPTemp,y
	iny
	cpy	#4
	bne	@1

	lda	PRGEND		; Set up end address
	sta END_ADDR_L
	lda	PRGEND+1
	sta END_ADDR_H
	lda	TXTTAB		; Set up start address
	sta BEG_ADDR_L
	lda	TXTTAB+1
	sta BEG_ADDR_H

	jsr SERIAL_API_WRITE
	jsr	RestoreZPForSave	; Put the zero page back
  rts

; ----------------------------------------------------------------------------
; Restores the 4 bytes of the ZP which were saved during SerialSave
; ----------------------------------------------------------------------------
RestoreZPForSave:
	ldy	#0
@1:
  lda	ZPTemp,y	; Load byte from temporary storage
	sta	END_ADDR_L,y	; put it back in its original location
	iny
	cpy	#4		; Repeat for next 11 bytes
	bne	@1
	rts


; ----------------------------------------------------------------------------
; Read program from Apple-1 Serial Interface
; ----------------------------------------------------------------------------
SerialLoad:
  jsr	CheckSerial

	ldy	#0
@1:
  lda	END_ADDR_L,y	; Back up first 12 bytes of the ZP
	sta	ZPTemp,y
	iny
	cpy	#12
	bne	@1

GetLength:	; Get file name from input line
	dec	TXTPTR
	ldy	#0
@1:
  jsr	CHRGET		; Get next character from the input line
	beq	@2		    ; Is it null (EOL)?
	cmp #$30
	bmi LengthValidationErr
	cmp #$3A
	bpl LengthValidationErr
	and #$0F      ; Convert ASCII to hex value $00-$09
	sta	STR2INT_BUF,y	; Not EOL, store it in program length string
	iny
	cpy	#5			; 6 chars yet?
	bne	@1			; no

@2:
	cpy	#0			; Read 6 chars or EOL, did we get anything?
	beq	SynErr

	lda #STR2INT_END    ; append integer string end marker
	sta STR2INT_BUF,y
	jsr String2Int
	lda STR2INT_INT
	bne @3
	dec STR2INT_INT+1
@3:
	dec STR2INT_INT
	clc
SetLoadAddresses:
	lda	TXTTAB		; Compute program end address
	adc	STR2INT_INT	  ; (Add file size to program start)
	sta	VARTAB		; Store end address
	sta END_ADDR_L
	lda	TXTTAB+1
	adc	STR2INT_INT+1
	sta	VARTAB+1
	sta END_ADDR_H

	;jsr SerialAPISetup
	lda	TXTTAB		; Set up start address
	sta BEG_ADDR_L
	lda	TXTTAB+1
	sta BEG_ADDR_H

	jsr SERIAL_API_READ
	jsr	RestoreZPForLoad	; Put the zero page back

	jmp	FIX_LINKS
LengthValidationErr:
	jsr RestoreZPForLoad
	jmp SynErr
; ----------------------------------------------------------------------------
; Restores the affected 12 bytes of the ZP which were saved during SerialLoad
; ----------------------------------------------------------------------------
RestoreZPForLoad:
	ldy	#0
@1:
  lda	ZPTemp,y	; Load byte from temporary storage
	sta	END_ADDR_L,y	; put it back in its original location
	iny
	cpy	#12		; Repeat for next 11 bytes
	bne	@1
	rts

; ----------------------------------------------------------------------------
; Converts the integer string to 2 byte integer
; ----------------------------------------------------------------------------
String2Int:
  lda #0
  sta STR2INT_INT+1
  lda STR2INT_BUF
  sta STR2INT_INT
  ldx #1
  lda STR2INT_BUF,X
  cmp #STR2INT_END
  bne String2IntNext
  clc
  rts
String2IntNext:
  jsr String2IntMult10
  bcs String2IntEnd
  inx
  lda STR2INT_BUF,X
  cmp #$0A
  bne String2IntNext
  clc
String2IntEnd:
	rts

String2IntMult10:
  lda STR2INT_INT+1
  pha
  lda STR2INT_INT
  asl STR2INT_INT
  rol STR2INT_INT+1
  asl STR2INT_INT
  rol STR2INT_INT+1
  adc STR2INT_INT
  sta STR2INT_INT
  pla
  adc STR2INT_INT+1
  sta STR2INT_INT+1
  asl STR2INT_INT
  rol STR2INT_INT+1
  lda STR2INT_BUF,X
  adc STR2INT_INT
  sta STR2INT_INT
  lda #0
  adc STR2INT_INT+1
  sta STR2INT_INT+1
  rts
