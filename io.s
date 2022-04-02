; Apple-1 I/O routines for Applesoft Lite
; Last modified 10-May-2008

.setcpu "6502"
.segment "BASIC"

.export KEYBOARD, GETLN, RDKEY, CLS, OUTDO, CRDO, OUTQUES, OUTSP
.import INPUTBUFFER

.include "zeropage.s"

; ----------------------------------------------------------------------------
; I/O Locations
; ----------------------------------------------------------------------------
KEYBOARD        := $D010
KEYBOARDCR      := $D011


; ----------------------------------------------------------------------------
; Monitor Subroutines
; ----------------------------------------------------------------------------
MONECHO         := $FFEF


; ----------------------------------------------------------------------------
; Get keystroke from keyboard (RDKEY)
; ----------------------------------------------------------------------------
RDKEY:   
   inc   RNDL       ; increment random number
   bne   @1         ;   mimics AppleII ROM routine at $FD1B 
   inc   RNDH       ;
@1:
	lda	KEYBOARDCR	; Key ready?
	bpl	RDKEY		; Loop until ready
	lda	KEYBOARD	; Load character
	and	#$7F		; Clear hi bit
	rts

; ----------------------------------------------------------------------------
; Get line of input (GETLN)
; adapted from Apple II monitor
; ----------------------------------------------------------------------------
NOTCR:
	cmp	#$1b		; Escape (was $18 CTRL-X?)
	beq	CANCEL		; Cancel line if so
	cmp	#8		;  backspace?
	beq	BCKSPC		; Yes, do backspace...
	jsr	MONECHO		; Output using monitor ECHO routine
NOTCR1:	inx
	bne	NXTCHAR		; Wasn't backspace or CTRL+X, get next key
CANCEL:	jsr	OUTSLASH	; Output a "\" to indicate cancelled line
GETLNZ:	jsr	CRDO		; new line
GETLN:	jsr	OUTPROMPT	; Display the prompt
	ldx	#$01		; Set cursor at 1, it gets decremented later
;BCKSPC:	txa
;	beq	GETLNZ		; Backspace with nothing on the line? start new line
	dex			; Move "cursor" back one space
NXTCHAR:
	jsr	RDKEY		; Read key from keyboard
ADDINP:	sta	INPUTBUFFER,x	; Put it in the input buffer
	cmp	#$0D		; CR?
	bne	NOTCR		; No, keep looping
	jsr	CRDO		; Output CR
	rts

BCKSPC:
	txa
	beq	NXTCHAR   ; Backspace with nothing on the line, does nothing
	jsr	CRDO		 ; Outputs CR for reprinting of the line
	jsr   OUTPROMPT ; Outputs the prompt
	dex             ; Trims 1 character back
	stx   TEMP2     ; Use temporary variables to save length of line
	beq   NXTCHAR   ; If after trim the line is empty do nothing
	ldy   #0        ; Start from first character in the input buffer
BCKSPC1:
	lda   INPUTBUFFER,y  ; Prints character
	jsr   OUTDO          ;
	iny                  ; Point to next character
	dec   TEMP2          ; Decrement line lentgh counter
	bne   BCKSPC1        ; End of line reached? No, continue printing
	beq   NXTCHAR        ; Yes, returns to input line

; ----------------------------------------------------------------------------
; These moved here from the main Applesoft code to save a few bytes
; ----------------------------------------------------------------------------
OUTSLASH:
	lda	#'\'
	.byte	$2C	; Fake BIT instruction to skip next 2 bytes
OUTPROMPT:
	lda	PROMPT
	.byte	$2C	
OUTSP:	lda	#' '
	.byte	$2C   
OUTQUES:
	lda	#'?'
	.byte	$2C
CRDO:	lda	#$0D    
OUTDO:	ora	#$80    ; Set hi bit
	jsr	MONECHO	; Send character to monitor ECHO
	and	#$7F	; clear hi bit
	rts


; ----------------------------------------------------------------------------
; Corny method of clearing the screen by sending a bunch of CR's.
; ----------------------------------------------------------------------------
CLS:
	ldy	#24	; loop 24 times
@1:	jsr	CRDO	; ouput CR
	dey
	bpl	@1	; ... do it again
	rts
