varFront		equ		savesscreen
varTail		equ		savesscreen+2

parseRoutine:
 add		a,e
 or		a
 jr		z,preparse
 cp		1
 jr		nz,retZ
 ld		a,b
 cp		8ah
 jr		nz,retZ
 ld		a,h
 or		a
 jr		nz,morethan1arg	;ok same sick minded person might actually enter this many args
 ld		a,l
 cp		1
 ret		z
 or		a
 ret		z
morethan1arg:
 push		hl
; ld		hl,op1
 B_CALL	pushrealo1
 pop		hl
 push		hl
 
 push		hl
 pop		de
 add		hl,hl
 add		hl,hl
 add		hl,hl
 add		hl,de	;*9
 push		hl
 pop		de
 ld		hl,(fps)
 or		a
 sbc		hl,de
 push		hl
 push		de
; ld		de,op1
; ld		bc,9
; ldir
 rst		rmov9toop1
 pop		bc
 pop		de
 ldir			;remove custom # from fps
 ex		de,hl
 ld		de,9
 or		a
 sbc		hl,de
 ld		(fps),hl
 B_CALL	ckposint
 jr		z,properarg1
 pop		hl
argerr:
 B_JUMP	ErrArgument
properarg1:
 B_CALL	convop1
 ld		a,d
 or		a
 jr		nz,argerr
 ld		a,e
 cp		21
 jr		nc,argerr
 ld		hl,parsejumptable
 add		hl,de
 add		hl,de	;hl=de*2+hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 jp		(hl)
alreadyrecursed:
 xor		a
 ld		(parserHookPtr+3),a ;ok we're in the preparse for the second time, we don't need to do any more altering
retZ:
 cp		a
 ret
preparse:
 ld		a,(parserHookPtr+3)
 dec		a
 jr		z,alreadyrecursed
 B_CALL	chkfindsym
; rst		rfindsym
 jr		c,retZ						;file does not exist... this happens at time in the basic files?
 B_CALL	editprog
;now search for tokens needing replacing and count up the ram to be inserted
 ld		hl,(imathptr1)
 ld		a,(hl)
 inc		hl			;skip length
 or		(hl)
 jp		z,preparseExit
 inc		hl
 ld		de,(imathptr2)
ramRequired:
 ld		a,(hl)
 cp		0bbh
 jr		nz,notCustomTok
 inc		hl
 ld		a,(hl)
 cp		0cfh
 jr		c,notCustomTok
;ok we got a custom token here 
 inc		de
 inc		de
 inc		de
 jr		onebytetoken
notCustomTok:
 call		quoteskipper
 jr		z,nobytetoken
 B_CALL	IsA2ByteTok
 jr		nz,onebytetoken
 inc		hl
onebytetoken:
 inc		hl
nobytetoken:
 ld		bc,(imathptr2)
 push		hl
 or		a
 sbc		hl,bc
 pop		hl
 jr		nz,ramRequired
 ld		hl,(imathptr3)
 or		a
 sbc		hl,de
 jp		c,notenoughram

;now search for tokens needing replacing and replace them with real(#,args)
 ld		hl,(imathptr1)
 inc		hl
 inc		hl			;skip length
tokenReplacer:
 ld		a,(hl)
 cp		0bbh
 jr		nz,notCustomTok2
 inc		hl
 ld		a,(hl)
 cp		0cfh
 jr		c,notCustomTok2
;ok we got a custom token here 
 ld		(hl),treal
 push		hl
 ex		de,hl
 push		af
 ld		hl,(imathptr2)
 push		hl
 or		a
 sbc		hl,de
 ld		b,h
 ld		c,l
 pop		hl
 push		hl
 ld		de,3
 add		hl,de
 ld		(imathptr2),hl
 dec		hl
 ld		d,h
 ld		e,l
 pop		hl
 dec		hl
 lddr
 ld		hl,(imathptr1)
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		de
 inc		de
 inc		de
 ld		(hl),d
 dec		hl
 ld		(hl),e
 pop		af
 sub		0cfh
 ld		b,255
divby10:
 inc		b
 sub		10
 jr		nc,divby10
 add		10+30h
 ld		c,a
 ld		a,b
 add		30h
 pop		hl
 inc		hl
 ld		(hl),a
 inc		hl
 ld		(hl),c
 inc		hl
 ld		(hl),tcomma
 ld		a,1
 ld		(parserHookPtr+3),a ;not zero anymore
 jr		onebytetoken2
notCustomTok2:
 call		quoteskipper
 jr		z,nobytetoken2
 B_CALL	IsA2ByteTok
 jr		nz,onebytetoken2
 inc		hl
onebytetoken2:
 inc		hl
nobytetoken2:
 ld		bc,(imathptr2)
 push		hl
 or		a
 sbc		hl,bc
 pop		hl
 jr		nz,tokenReplacer
preparseExit:
 B_CALL	closeprog
;if any custom tokens were modified, then (parserHookPtr+3) != 0, so we'll use recursion here in order to change them back before
;exiting again to the tios to return answer
 ld		a,(parserHookPtr+3)
 or		a
 ret		z  ;speed things up if no custom tokens exist.  for example i won't need to check this for converting them all back
; ld		hl,op1
 B_CALL	pushrealo1
 AppOnErr	parseErr
 B_CALL	parseinp
 AppOffErr
 call		fixTokens
 xor		a
 inc		a	;don't go past this preparse
 ret
parseErr:
 push		af
 call		fixTokens
 pop		af
 B_JUMP	JError
fixTokens:
 ld		hl,(varFront)
 push		hl
 ld		hl,(varTail)
 push		hl
 B_CALL	pushrealo1
 ld		de,18
 ld		hl,(fps)
 or		a
 sbc		hl,de
 push		hl
 rst		rmov9toop1
 ld		bc,9
 pop		de
 ldir		;optimize
 ld		(fps),de
 B_CALL	chkfindsym

;now search for tokens needing replacing and replace them with real(#,args)
 ex		de,hl
 ld		(varFront),hl
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 inc		hl			;skip length
 push		hl
 add		hl,bc
 ld		(varTail),hl
 pop		hl
tokenFixer:
 ld		a,(hl)
 cp		0bbh
 jr		nz,notCustomTok3
 inc		hl
 ld		a,(hl)
 cp		treal
 jr		nz,notCustomTok3_2
 inc		hl
 ld		a,(hl)
 cp		t0
 jr		c,notCustomTok3
 cp		t9+1
 jr		nc,notCustomTok3
 inc		hl
 ld		a,(hl)
 cp		t0
 jr		c,notCustomTok3
 cp		t9+1
 jr		nc,notCustomTok3
 inc		hl
 ld		a,(hl)
 cp		tcomma
 jr		nz,notCustomTok3
;it is a custom token hiding as a real( token!
 dec		hl
 ld		a,(hl)
 sub		30h
 ld		b,a
 dec		hl
 ld		a,(hl)
 sub		30h
 add		a,a
 ld		e,a
 add		a,a
 add		a,a
 add		a,e
 add		a,b
 add		a,0cfh
 dec		hl
 ld		(hl),a
;remove the # and commas
 push		hl
 inc		hl
 ld		de,3
 push		hl
 ld		hl,(varTail)
 or		a
 sbc		hl,de
 ld		(varTail),hl
 pop		hl
 B_CALL	delmem
 ld		hl,(varFront)
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 dec		de
 dec		de
 dec		de						;adjust the size
 ld		(hl),d
 dec		hl
 ld		(hl),e
 pop		hl
 jr		onebytetoken3
notCustomTok3_2:
 dec		hl
 ld		a,(hl)
notCustomTok3:
 call		quoteskipperNE
 jr		z,nobytetoken3
 B_CALL	IsA2ByteTok
 jr		nz,onebytetoken3
 inc		hl
onebytetoken3:
 inc		hl
nobytetoken3:
 ld		bc,(varTail)
 push		hl
 or		a
 sbc		hl,bc
 pop		hl
 jr		nz,tokenFixer
 B_CALL	poprealo1
 pop		hl
 ld		(varTail),hl
 pop		hl
 ld		(varFront),hl
 ret

quoteskipper:
 cp		tstring
 ret		nz
 inc		hl
quoteskipper2:
 push		hl
 ld		bc,(imathptr2)
 or		a
 sbc		hl,bc
 pop		hl
 ret		z
 ld		a,(hl)
 inc		hl
 cp		tstring
 ret		z
 cp		tenter
 ret		z
 B_CALL	IsA2ByteTok
 jr		nz,quoteskipper2
 inc		hl
 jr		quoteskipper2


quoteskipperNE:
 cp		tstring
 ret		nz
 inc		hl
quoteskipperNE2:
 push		hl
 ld		bc,(varTail)
 or		a
 sbc		hl,bc
 pop		hl
 ret		z
 ld		a,(hl)
 inc		hl
 cp		tstring
 ret		z
 cp		tenter
 ret		z
 B_CALL	IsA2ByteTok
 jr		nz,quoteskipperNE2
 inc		hl
 jr		quoteskipperNE2




tcsc		equ 0CFh
tcsci		equ 0D0h
tsec		equ 0D1h
tseci		equ 0D2h
tcot		equ 0D3h
tcoti		equ 0D4h
tcsch		equ 0D5h
tcschi	equ 0D6h
tsech		equ 0D7h
tsechi	equ 0D8h
tcoth		equ 0D9h
tcothi	equ 0DAh
tdiff		equ 0DBh
tsimp		equ 0DCh
tsign		equ 0DDh
