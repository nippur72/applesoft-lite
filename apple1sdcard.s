.setcpu "6502"
.segment "BASIC"

.include "zeropage.s"

.importzp ERR_SYNTAX, ERR_NOSDCARD
.import ERROR, FIX_LINKS, OUTDO, GETSTR, FRMEVL
.export SDCardLoad, SDCardSave, SDCardMenu

SDCARD_FILENAME := $0200    ; SD card buffer for filename (label "filename" from sdcard.sym)

; values for SD OS 1.1 firmware EPROM
; SDCARD_MONITOR  := $8000    ; EPROM entry point for SD card OS
; SDCARD_LOAD     := $8d11    ; label "comando_load_bas" from sdcard.sym
; SDCARD_SAVE     := $8a75    ; label "comando_asave" from sdcard.sym
; SDCARD_EPROM_ID := $95e9    ; label "chksum_table" from sdcard.sym

; values for SD OS 1.2 firmware EPROM
SDCARD_MONITOR  := $8000    ; EPROM entry point for SD card OS
SDCARD_LOAD     := $8d1a    ; label "comando_load_bas" from sdcard.sym
SDCARD_SAVE     := $8a7e    ; label "comando_asave" from sdcard.sym
SDCARD_EPROM_ID := $95f2    ; label "chksum_table" from sdcard.sym

; ----------------------------------------------------------------------------
; See if Apple-1 SD card is present and display error if not
; ----------------------------------------------------------------------------
CheckSDCard:
	ldy	SDCARD_EPROM_ID
	cpy	#$80
	bne	SDCardErr
	ldy	SDCARD_EPROM_ID + 1
	cpy	#$80
	bne	SDCardErr
	ldy	SDCARD_EPROM_ID + 2
	cpy	#$80
	bne	SDCardErr
	ldy	SDCARD_EPROM_ID + 3
	cpy	#$8A
	bne	SDCardErr
	rts

SDCardErr:
    ldx	#ERR_NOSDCARD
    .byte	$2C		; Bogus BIT instruction
SynErr:
    ldx	#ERR_SYNTAX
    jmp	ERROR		; Jump to Applesoft ERROR routine

; ----------------------------------------------------------------------------
; Copies the file name from input line to the SD filename buffer
; ----------------------------------------------------------------------------
GetFileName:
	jsr FRMEVL                ; evaluate expression
	jsr	GETSTR                ; gets the string; Y=length, (INDEX)=string content
    lda #0                    ; string terminator
	sta SDCARD_FILENAME,y     ; write string terminator first
@1:	dey                       ; decrement write position
	cpy #255                  ; reached -1 ?
	beq @2                    ; yes, end
	lda (INDEX), y            ; copy from string
	sta SDCARD_FILENAME,y     ; to sd filename buffer
	jmp @1                    ; loops
@2: rts                       ; end, filename + 0 is at SDCARD_FILENAME

; ----------------------------------------------------------------------------
; Bring up the Apple-1 Serial Interface menu
; ----------------------------------------------------------------------------
SDCardMenu:
    jsr CheckSDCard
	jmp SDCARD_MONITOR

; ----------------------------------------------------------------------------
; Save program via the Apple-1 SD Card Interface
; ----------------------------------------------------------------------------
SDCardSave:
	jsr	CheckSDCard          ; check that SD card interface is plugged
    jsr GetFileName          ; gets the string file name
    jsr SDCARD_SAVE          ; do the actual save

	; clears the filename buffer because it's also the basic input in immediate mode
	ldy #$7f                 ; $200-$27F
	lda #00                  ; 0 = END of program, causes the parsing to stop
@3: sta $200,y               ; writes into buffer
	dey                      ; decrement position
	bpl @3                   ; if not -1 continue
    rts                      ; finished, return to BASIC

; ----------------------------------------------------------------------------
; Read program from Apple-1 SD Card Interface
; ----------------------------------------------------------------------------
SDCardLoad:
    jsr	CheckSDCard          ; check that SD card interface is plugged
    jsr GetFileName          ; gets the string file name
    jsr SDCARD_LOAD          ; do the actual load
	jmp	FIX_LINKS            ; ajdust the links (not necessary but doesn't do harm)
