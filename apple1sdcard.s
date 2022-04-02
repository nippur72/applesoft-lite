.setcpu "6502"
.segment "BASIC"

.include "zeropage.s"

.importzp ERR_SYNTAX, ERR_NOSDCARD
.import ERROR, FIX_LINKS, OUTDO
.export SDCardLoad, SDCardSave, SDCardMenu

SDCARD_FILENAME := $0200    ; SD card buffer for filename (label "filename" from sdcard.sym)
SDCARD_MONITOR  := $8000    ; EPROM entry point for SD card OS
SDCARD_LOAD     := $8d0e    ; label "comando_load_bas" from sdcard.sym 
SDCARD_SAVE     := $8a75    ; label "comando_asave" from sdcard.sym
SDCARD_DIR      := $90de    ; label "comando_dir" from sdcard.sym 
SDCARD_EPROM_ID := $95e3    ; label "chksum_table" from sdcard.sym

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
GetFileName:			; Get file name from input line
	dec	TXTPTR
	ldy	#0
@1: jsr	CHRGET		        ; Get next character from the input line
	beq	@2		            ; Is it null (EOL)?
	sta	SDCARD_FILENAME,y	; Not EOL, store it in filename string
	iny
    bne	@1			        ; no, go back for more
@2:    
    lda #0                  ; string terminator
    sta	SDCARD_FILENAME,y	; end string with terminator    
    rts

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
	jsr	CheckSDCard
    jsr GetFileName
    jsr SDCARD_SAVE
    rts

; ----------------------------------------------------------------------------
; Read program from Apple-1 SD Card Interface
; ----------------------------------------------------------------------------
SDCardLoad:
    jsr	CheckSDCard
    jsr GetFileName
    jsr SDCARD_LOAD
	jmp	FIX_LINKS

;; ----------------------------------------------------------------------------
;; Save program via the Apple-1 SD Card Interface
;; ----------------------------------------------------------------------------
;SDCardDir:
;	jsr	CheckSDCard
;    jsr GetFileName
;    jsr SDCARD_DIR
;    rts
