prettyRoutine:
 ld  hl,prettyName
 rst rmov9toop1
 B_CALL findapp
 jp  c,syntaxErr2  ;or maybe we can find a better error if your app is not installed...
 ld  de,ramcode
 ld  hl,prettyRC
 ld  bc,prettyRC_end-prettyRC
 ldir
 jp  ramcode
prettyRC:
 out (6),a
 ld  de,(4082h)
 ld  hl, 7f7fh    ;can we assume this or some other numeric flag guarantees the pretty to plotsscreen routine exists?
 or a
 sbc hl, de
 pop	hl
 jp  z,4084h
verError:
 ld		a,e_version
 B_JUMP	jerror
prettyRC_end:
prettyName:
 db	appobj,"PrettyPt"
cscRoutine:
 call		trigcheck
 B_CALL	sin
 jr		recipretnz
csciRoutine:
 call		trigcheck
 B_CALL	fprecip
 B_CALL	asin
 jr		retnz
secRoutine:
 call		trigcheck
 B_CALL	cos
 jr		recipretnz
seciRoutine:
 call		trigcheck
 B_CALL	fprecip
 B_CALL	acos
 jr		retnz
cotRoutine:
 call		trigcheck
; B_CALL	tan
 B_CALL	sin	;op1=sin op2=cos
 B_CALL	op1exop2
 B_CALL	fpdiv
 jr		retnz
cotiRoutine:
 call		trigcheck
 B_CALL	fprecip
 B_CALL	atan
 jr		retnz
cschRoutine:
 call		trigcheck
 B_CALL	sinh
; jr		recipretnz
recipretnz:
 B_CALL	fprecip
retnz:
 xor		a
 inc		a
 ret
cschiRoutine:
 call		trigcheck
 B_CALL	fprecip
 B_CALL	asinh
 jr		retnz
sechRoutine:
 call		trigcheck
 B_CALL	cosh
 jr		recipretnz
sechiRoutine:
 call		trigcheck
 B_CALL	fprecip
 B_CALL	acosh
 jr		retnz
cothRoutine:
 call		trigcheck
 B_CALL	tanh
 jr		recipretnz
cothiRoutine:
 call		trigcheck
 B_CALL	fprecip
 B_CALL	atanh
 jr		retnz
signRoutine:
 call		trigcheck	;yeah i know its not a trig function but the routine is useful
 B_CALL	op1toop2
 xor		a
 ld		(op2),a
 B_CALL	fpdiv
 jr		retnz
getVersion:
 call		trigcheck
 ld		hl,versionNum
 B_CALL	mov9toop2
 B_CALL	op1exop2
 B_CALL	cpop1op2
 jp		c,verError
 jr		retnz
trigcheck:
 pop		ix
 pop		hl
 push		ix
 ld		de,2
 or		a
 sbc		hl,de
 jp		nz,argerr
; ld		de,op1
isfpsreal:
 B_CALL	poprealo1
 B_CALL	ckop1real
 jr		nz,datatypeErr
 ret
datatypeErr:
 B_CALL	ErrDataType
undefinedErr:
 B_CALL	ErrUndefined
