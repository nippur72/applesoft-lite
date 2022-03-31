; Zero Page locations used by Applesoft Lite

; the following locations have been moved to avoid conflict with SDCARD
; (SDCARD uses uses all locations below $4A)
; free zone is $CE-$D5, $F0-$F1, $F9 

CHARAC		:= $00CE; Alternate string terminator
ENDCHR		:= $00CF; String terminator
TKNCNTR		:= $00D0; Used in PARSE
EOLPNTR		:= $00D0; Used in NXLIN
NUMDIM		:= $00D0; Used in array routines
DIMFLG		:= $00D1;
VALTYP		:= $00D2; $: VALTYP=$FF; %: VALTYP+1=$80
DATAFLG		:= $00D4; Used in PARSE
GARFLG		:= $00D4; Used in GARBAG
SUBFLG		:= $00D5;
INPUTFLG	   := $00F0; = $40 for GET, $98 for READ
CPRMASK		:= $00F1; Receives CPRTYP in FRMEVL
PROMPT		:= $00F9;

; original allocation as per Applesoft Lite upstream
;GOWARM		:= $0000; Gets "jmp RESTART"
;GOSTROUTZ	:= $0003; Gets "jmp STROUT"
;CHARAC		:= $000D; Alternate string terminator
;ENDCHR		:= $000E; String terminator
;TKNCNTR		:= $000F; Used in PARSE
;EOLPNTR		:= $000F; Used in NXLIN
;NUMDIM		:= $000F; Used in array routines
;DIMFLG		:= $0010;
;VALTYP		:= $0011; $: VALTYP=$FF; %: VALTYP+1=$80
;DATAFLG		:= $0013; Used in PARSE
;GARFLG		:= $0013; Used in GARBAG
;SUBFLG		:= $0014;
;INPUTFLG	   := $0015; = $40 for GET, $98 for READ
;CPRMASK		:= $0016; Receives CPRTYP in FRMEVL
;PROMPT		:= $0033;

; non relocated ZP locations

LINNUM		:= $0050	; Converted line #
TEMPPT		:= $0052	; Last used temp string desc
LASTPT		:= $0053	; Last used temp string pntr
TEMPST		:= $0055	; Holds up to 3 descriptors
INDEX		:= $005E
DEST		:= $0060
RESULT		:= $0062	; Result of last * or /
TXTTAB		:= $0067	; Start of program text
VARTAB		:= $0069	; Start of variable storage
ARYTAB		:= $006B	; Start of array storage
STREND		:= $006D	; End of array storage
FRETOP		:= $006F	; Start of string storage
FRESPC		:= $0071	; Temp pntr, string routines
MEMSIZ		:= $0073	; End of string space (HIMEM)
CURLIN		:= $0075	; Current line number
OLDLIN		:= $0077	; Addr. of last line executed
OLDTEXT		:= $0079
DATLIN		:= $007B	; Line # of current data stt.
DATPTR		:= $007D	; Addr of current data stt.
INPTR		:= $007F
VARNAM		:= $0081	; Name of variable
VARPNT		:= $0083	; Addr of variable
FORPNT		:= $0085
TXPSV		:= $0087	; Used in INPUT
LASTOP		:= $0087	; Scratch flag used in FRMEVL
CPRTYP		:= $0089	; >,=,< flag in FRMEVL
TEMP3		:= $008A
FNCNAM		:= $008A
DSCPTR		:= $008C
DSCLEN		:= $008F	; used in GARBAG
JMPADRS		:= $0090	; gets "jmp ...."
LENGTH		:= $0091	; used in GARBAG
ARGEXTENSION	:= $0092	; FP extra precision
TEMP1		:= $0093	; save areas for FAC
ARYPNT		:= $0094	; used in GARBAG
HIGHDS		:= $0094	; pntr for BLTU
HIGHTR		:= $0096	; pntr for BLTU
TEMP2		:= $0098
TMPEXP		:= $0099	; used in FIN (EVAL)
INDX		:= $0099	; used by array rtns
EXPON		:= $009A	;   "
DPFLG		:= $009B	; flags dec pnt in FIN
LOWTR		:= $009B
EXPSGN		:= $009C
FAC		:= $009D	; main floating point accumulator
VPNT		:= $00A0	; temp var ptr
FACSIGN		:= $00A2	; holds unpacked sign
SERLEN		:= $00A3	; holds length of series - 1
SHIFTSIGNEXT	:= $00A4	; sign extension, right shifts
ARG		:= $00A5	; secondary FP accumulator
ARGSIGN		:= $00AA
SGNCPR		:= $00AB	; flags opp sign in FP routines
FACEXTENSION	:= $00AC	; FAC extension byte
SERPNT		:= $00AD	; pntr to series data in FP
STRNG1		:= $00AB
STRNG2		:= $00AD
PRGEND		:= $00AF
;B0-CD CHRGET+RANDOM SEED AREA
CHRGET		:= $00B1
CHRGOT		:= $00B7
TXTPTR		:= $00B8
RNDSEED		:= $00C9
LOCK		:= $00D6	; no user access if > 127
ERRFLG		:= $00D8	; $80 if ON ERR active
ERRLIN		:= $00DA	; line # where error occurred
ERRPOS		:= $00DC	; TXTPTR save for HANDLERR
ERRNUM		:= $00DE	; which error occurrred
ERRSTK		:= $00DF	; stack pntr before error
TRCFLG		:= $00F2
TXTPSV		:= $00F4
CURLSV		:= $00F6	
REMSTK		:= $00F8	; stack pntr before each stt.
