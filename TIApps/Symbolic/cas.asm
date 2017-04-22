;better simplifying of logs, square roots
;nth dirivative
;maybe you shouldn't distribute?

myFlags		equ asm_Flag1
nodeZ			equ 0
node1			equ 1
decimal		equ 2
differen		equ 3

freeRam		equ iMathPtr2

saferam1		equ 9872h ;768 appBackUpScreen

stack			equ saferam1
oldstack		equ saferam1+2
treeTop		equ saferam1+4

saferam2		equ treeTop+2

tempHL		equ saferam2
tempBC		equ saferam2+2
divFlag		equ saferam2+4
treeTop2		equ saferam2+5
modFlag		equ saferam2+7
mod2Flag		equ saferam2+8
pro1Parent	equ saferam2+9  ; 2 bytes... they will point to the pointers which need to be altered to point to 1
pro2Parent  equ saferam2+11 ; in cancelTerms
firstFlag	equ saferam2+13
lastFlag		equ saferam2+14
op7			equ saferam2+15
op8			equ saferam2+24
respect2		equ saferam2+33

numcaststr:
 pop		hl
 dec		hl
 dec		hl
 ld		a,h
 or		l
 jp		nz,argerr
 call		memAssert
 B_CALL	poprealo1
 ld		a,(iy+fmtFlags)
 ld		(iy+fmtOverride),a
 B_CALL	formbase
 ld		hl,op3
 push		hl
 call		conNum20
 pop		de
 or		a
 sbc		hl,de
 push		hl
; B_CALL	pushrealo3
 B_CALL	pushrealo4 
 call		makeTempStr
 push		de
 B_CALL	poprealo1
 B_CALL	poprealo4
; B_CALL	poprealo3
 pop		hl
 pop		bc
 ld		(hl),c
 inc		hl
 ld		(hl),b
 inc		hl
 ld		de,op3
 ex		de,hl
 ldir
 B_CALL	pushrealo1
 jp		popandreturn

letRoutine:
 pop		hl
 ld		de,3
 or		a
 sbc		hl,de
 jp		nz,argerr
 B_CALL	cpyto1fps1
 call		op1toop7
 ld		a,(op1)
 cp		4
 jp		nz,typeErr
 B_CALL	CpyTo1FPST
 ld		a,(op1)
 cp		4
 jp		nz,typeErr
 ld		hl,5
 B_CALL	allocfps
 ld		de,(fps)
 dec		de
 ld		hl,saferam1+44
 ld		bc,45
 lddr
 call		deMess
;
 B_CALL	closeprog
 B_CALL	pushrealo1
 call		op7toop1
 call		deMess
 B_CALL	closeprog
 B_CALL	poprealo1
 rst		rfindsym
 B_CALL	editprog
;
 di
 ld		(oldstack),sp
 ld		sp,(imathptr3)
 dec		sp
 ei
 ld		hl,(imathptr1)
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 inc		hl
 call		parse
 ld		(treeTop),hl
 call		op7toop1
 ld		a,(op1)
 cp		4
 jp		nz,typeErr
 rst		rfindsym
 ex		de,hl
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 inc		hl
 dec		bc
 ld		a,b
 or		c
 jp		z,argerr
 dec		bc
 ld		a,b
 or		c
 jp		z,argerr
 ld		a,(hl)
 inc		hl
 cp		tA
 jp		c,argerr
 cp		tTheta+1
 jp		nc,argerr
 ld		(respect2),a
 ld		a,(hl)
 cp		teq
 jp		nz,argerr
 inc		hl
 call		parse
 ld		(treeTop2),hl
;do tree search for all (respect2) variables, replace with pointer to (treeTop2)
 ld		hl,treeTop+1
 push		hl
 ld		hl,(treeTop)
 call		replaceVar
 ld		hl,(treeTop)
 ld		de,(freeRam)
 push		de
 call		toString		;this routine will need to be modified to use freeRam and update the pointer at (imathptr1)
;fix the length word
 pop		de
 ld		hl,(imathptr2)
 or		a
 sbc		hl,de
 ld		c,l
 ld		b,h
 ld		hl,(imathptr1)
 ld		(hl),c
 inc		hl
 ld		(hl),b
 inc		hl
 ex		de,hl
 ldir
 ld		(freeRam),de
 di
 ld		sp,(oldstack)
 ei
 B_CALL	closeprog
 call		replacesaferam
 B_CALL	poprealo1
 B_CALL	poprealo2
 B_CALL	pushrealo1
 jp		simpNoPop

replaceVar:
 call		memAssert
 ld		a,(hl)
 cp		1
 jr		z,varCheck
 or		a
 ret		z
 push		af
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 push		hl
 ex		de,hl
 call		replaceVar
 pop		hl
 pop		af
 call		isOpenParen
 ret		z
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 push		hl
 ex		de,hl
 call		replaceVar
 pop		hl
 ret
varCheck:
 inc		hl
 ld		b,(hl)
 ld		a,(respect2)
 cp		b
 ret		nz
 pop		de
 pop		hl
 push		hl
 push		de
 ld		de,(treeTop2)
 ld		(hl),d
 dec		hl
 ld		(hl),e
 ret

arclength:
 pop		hl
 ld		de,5
 or		a
 sbc		hl,de
 jp		nz,argerr
 B_CALL	poprealo1
 B_CALL	ckop1real
 jp		nz,typeErr
 B_CALL	op1toop6
 B_CALL	poprealo1
 B_CALL	ckop1real
 jp		nz,typeErr
 B_CALL	op1toop5
 B_CALL	poprealo1	;variable str
;need to push real var of the character in this string
 rst		rfindsym
 inc		de
 inc		de
 ld		a,(de)
 ld		hl,op2
 ld		(hl),0
 inc		hl
 ld		(hl),a
 inc		hl
 ld		(hl),0
 inc		hl
 ld		(hl),0
 B_CALL	pushrealo2	;real variable
 B_CALL	pushrealo5
 B_CALL	pushrealo6
 B_CALL	cpyto2fps3	;equation str
 B_CALL	pushrealo2
 B_CALL	pushrealo1	;variable str
; ld		hl,3
 call		diffNoPop
 rst		rfindsym
 dec		(hl)
 ld		hl,op1
 dec		(hl)
 ex		de,hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 ld		bc,11
 add		hl,bc
 ex		de,hl
 ld		(hl),d
 dec		hl
 ld		(hl),e
 push		de
 push		hl
 inc		hl
 inc		hl
 ex		de,hl
 ld		hl,9
 B_CALL	insertmem
 ld		hl,arcequ
; ld		bc,9
; ldir
 B_CALL	mov9b
 pop		de
 pop		hl
 add		hl,de
 ex		de,hl
 ld		hl,2
 B_CALL	insertmem
 ex		de,hl
 ld		(hl),trparen
 inc		hl
 ld		(hl),tsqr
 B_CALL	cpyo1tofps3
 B_CALL	poprealo1
 ld		a,tfnint
 B_CALL	fourexec
 xor		a
 inc		a
 ret
arcequ:
 db		05h,01h,023h,01h,00h,tsqrt,t1,tadd,tlparen

;jump2diffR:
; push		hl
; jr		diffRoutine

simpRoutine:
 pop		hl
 ld		de,2
 or		a
 sbc		hl,de
 jp		nz,argerr
simpNoPop:
 res		differen,(iy+myFlags)
 jr		notDiff
diffRoutine:
 pop		hl
 ld		de,3
 or		a
 sbc		hl,de
 jp		nz,argerr
; ld		de,op1
diffNoPop:
 set		differen,(iy+myFlags)
 B_CALL	poprealo1
 ld		a,(op1)
 cp		4
 jp		nz,typeErr
; B_CALL	chkfindsym
 rst		rfindsym
 ex		de,hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		hl
 ld		a,(hl)
 ex		de,hl
 ld		de,1
 or		a
 sbc		hl,de
 jp		nz,argerr
 cp		tA
 jp		c,argerr
 cp		tTheta+1
 jp		nc,argerr
notDiff:
 push		af
 ld		de,(ptempcnt)
 B_CALL	fixtempcnt
 B_CALL	CpyTo1FPST
 ld		hl,op1
 ld		a,(hl)
 cp		4
 jp		nz,typeErr
 inc		hl
 ld		a,(hl)
 cp		24h
 jr		z,gotTemp
 rst		rfindsym
 ex		de,hl
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 push		bc
 call		makeTempStr
 push		de
 B_CALL	poprealo2
 B_CALL	poprealo1
 B_CALL	pushrealo2
 rst		rfindsym
 ex		de,hl
 pop		de
 pop		bc
 inc		bc
 inc		bc
 ldir
 B_CALL	cpyto1fpst
gotTemp:

 ld		hl,5
 B_CALL	allocfps
 ld		de,(fps)
 dec		de
 ld		hl,saferam1+44
 ld		bc,45
 lddr
 pop		af
 ld		(respect2),a

 res     decimal,(iy+myFlags)

 call		deMess
;code to initiate parse
;*
 di
 ld		(oldstack),sp
 ld		sp,(imathptr3)
 dec		sp
 ei
;*
 ld		hl,(imathptr1)
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 inc		hl
 call		parse
 ld		(treeTop),hl
 bit		differen,(iy+myFlags)
 call		nz,differentiate 
 ld		(treeTop2),hl
 xor		a
 ld		(firstFlag),a
 ld		(lastFlag),a
 inc		a
 ld		(mod2Flag),a
simpLoop:
 xor    a
 ld     (modFlag),a
 ld     ix,treeTop2
 push   ix          ;this takes care of say x+1 where the treeTop changes location
 call   simplify
 pop    ix
 ld     hl,(treeTop2)
 ld     a,(modFlag)
 or     a
 jr     nz,simpLoop

 xor    a
 ld     (modFlag),a
 ld     (mod2Flag),a
 push   hl
 pop    ix
 push   hl
 call   sortTerms
 pop    hl
 ld     a,(firstFlag)
 ld     b,a
 ld     a,255
 ld     (firstFlag),a
 ld     a,(modFlag)
 or     a
 jr     nz,simpLoop
 ld     a,b
 or     a
 jp     z,simpLoop

 ld     (lastFlag),a
 ld     ix,treeTop2
 push   ix
 call   simplify
 pop    ix
 ld     hl,(treeTop2)
 xor    a
 ld     (lastFlag),a
 ld     a,(modFlag)
 or     a
 jp     nz,simpLoop
 ld		de,(freeRam)
 push		de
 call		toString		;this routine will need to be modified to use freeRam and update the pointer at (imathptr1)
;fix the length word
 pop		de
 ld		hl,(imathptr2)
 or		a
 sbc		hl,de
 ld		c,l
 ld		b,h
 ld		hl,(imathptr1)
 ld		(hl),c
 inc		hl
 ld		(hl),b
 inc		hl
 ex		de,hl
 ldir
 ld		(freeRam),de

;*
 di
 ld		sp,(oldstack)
 ei
;*

 B_CALL	closeprog
 call		replacesaferam
popandreturn:
 B_CALL	poprealo1
 xor			a
 inc			a ;reset z
 ret

replacesaferam:
 ld		hl,(fps)
 dec		hl
 ld		de,saferam1+44
 ld		bc,45
 lddr
 ld		hl,5
 B_CALL	deallocfps
 ret

deMess:
; B_CALL	chkfindsym
 rst		rfindsym
 B_CALL	editprog
;two byte token adjuster
;needs to check if any tokens not preceeded by a BBh are greater than CDh, if yes then throw error

;why was i doing this?!  aren't the size bytes helpful?
; ld		de,(imathptr1)
; ld		hl,(imathptr2)
; or		a
; sbc		hl,de
; ld		b,h
; ld		c,l
; ex		de,hl

;doing this instead:
 ld		hl,(imathptr1)
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 inc		hl
;hl = imathptr1[+2]
;bc = length
adjuster:
 ld		a,(hl)
 cp		tTrace
 jp		z,syntaxErr
 B_CALL	IsA2ByteTok
 jr		nz,nextToken
 cp		0BBh
 jp		nz,syntaxErr
 inc		hl
 dec		bc
 ld		a,(hl)
;if it is a e token, switch to a one byte fake token
 cp		31h
 jr		nz,adjuster2
tFakeExp equ tTrace
 ld		(hl),tFakeExp
 jr		adjuster3
adjuster2:
 cp		0CFh
 jp		c,syntaxErr
adjuster3:
 ld		e,l
 ld		d,h
 dec		de
 push		hl
 push		bc
 ldir
 pop		bc
 pop		hl
 jr		nextToken2
nextToken:
 inc		hl
nextToken2:
 dec		bc
 xor		a
 or		b
 jr		nz,adjuster
 or		c
 jr		nz,adjuster
 ld		(imathptr2),hl
 ld		de,(imathptr1)
 scf
 sbc		hl,de
 dec		hl
 ex		de,hl
 ld		hl,(imathptr1)
 ld		(hl),e
 inc		hl
 ld		(hl),d

;impicit mult fix
 call		memAssert2
 ld		hl,(imathptr2)
 ld		(hl),0	;variable is now zero terminated
 ld		hl,(imathptr1)
 inc		hl		;gotta skip length-1
implicit:
 inc		hl
 ld		a,(hl)
 or		a
 jp		z,impl_done
 cp		0b0h
 jr		z,implicit
 ld		a,(hl)
 call    isNum
 or		a
 jr		nz,notNum
 inc		hl
 ld		a,(hl)
 call		isNum
 dec		hl
 or     a
 jr     z,implicit
 jr     checkOP
notNum:
 ld     a,(hl)
 cp		0BFh	;e^(
 jp		z,insertEpwr
 cp		tcubrt
 jp		z,insertxroot
 call       isOpenParen
 jr     z,implicit
checkOP:
 ld     a,(hl)
 inc        hl
 cp     tee
 jr     z,implicit
 ld     a,(hl)
 or		a
 jp		z,impl_done
 cp     trparen
 jr     z,checkop4
 ex     de,hl
 ld     hl,operators
 ld     bc,7
checkop2:
 cpir
 jr		z,checkop3
 cp		tRecip
 jr		z,implicitExp
 cp		tSqr
 jr		z,implicitExp
 cp		tCube
 jr		z,implicitExp
 call		memAssert2
 push		de
 ld		hl,(iMathPtr2)
 push		hl
 push		hl
 or		a
 sbc		hl,de
 push		hl
 pop		bc
 inc		bc
 pop		hl
 pop		de
 inc		de
 ld		(imathptr2),de
 lddr
 ld		hl,(imathptr1)
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		de
 ld		(hl),d
 dec		hl
 ld		(hl),e			;updated length word
 pop		hl
 ld		(hl),tmul
 jr		implicit
checkop3:
 ex		de,hl
 jr		implicit
checkop4:
 dec		hl
 jp		implicit
implicitExp:
 push		de
 ld		hl,(iMathPtr2)
 push		hl
 push		hl
 or		a
 sbc		hl,de
 push		hl
 pop		bc
 inc		bc
 pop		de
 inc		de
 pop		hl
 cp		tRecip
 jr		nz,notneg1
 inc		de
notneg1:
 call		memAssert2
 ld		(imathptr2),de
 lddr
 ld		hl,(iMathPtr1)
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		de
 cp		tRecip
 jr		nz,notneg1_2
 inc		de
notneg1_2:
 ld		(hl),d
 dec		hl
 ld		(hl),e
 pop		hl
 ld		(hl),tpower
 inc		hl
 cp		tRecip
 jr		nz,notneg1_4
 ld		(hl),0b0h
 inc		hl
 ld		(hl),t1
 dec		hl
 jp		implicit
notneg1_4:
 cp		tSqr
 jr		nz,notsquared
 ld		(hl),t2
 dec		hl
 jp		implicit
notsquared:
 ld		(hl),t3
 dec		hl
 jp		implicit
insertEpwr:
insertxroot:
 ex		de,hl
 push		de
 ld		hl,(iMathPtr2)
 push		hl
 push		hl
 scf
 sbc		hl,de
 push		hl
 pop		bc
 inc		bc
 pop		de
 inc		de
 pop		hl
 inc		de
 call		memAssert2
 ld		(iMathPtr2),de
 lddr
 ld		hl,(iMathPtr1)
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		de
 inc		de
 ld		(hl),d
 dec		hl
 ld		(hl),e
 pop		hl
 cp		tcubrt
 jr		z,insertxroot2
 ld		(hl),tFakeExp
 inc		hl
 ld		(hl),tPower
insertxroot3:
 inc		hl
 ld		(hl),tlparen
 dec		hl
 jp		implicit
insertxroot2:
 ld		(hl),t3
 inc		hl
 ld		(hl),txroot
 jr		insertxroot3
impl_done: ;optimizable return
 ret
;optimizable with an insermem internal routine

makeTempStr:
 ld		hl,op1
 ld		(hl),strngobj
 inc		hl
 ld		(hl),24h
 inc		hl
 ld		de,(ptempcnt)
 ld		(hl),e
 inc		hl
 ld		(hl),d
 inc		de
 ld		(ptempcnt),de
 B_CALL	pushrealo1
 pop		bc
 pop		hl
 push		hl
 push		bc
 B_CALL	CreateStrng
 ret
