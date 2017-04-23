toString:
 ld		a,(hl)
con1:
 call		memAssert
 cp		tadd
 jp		z,conA
 cp		tsub
 jp		z,conS
con2:
 call		memAssert
 cp		tmul
 jp		z,conM
 cp		tdiv
 jp		z,conD
 cp		0b0h
 jr		z,conneg
con3:
 call		memAssert
 cp		tpower
 jp		z,conE
con4:
 call		memAssert
 or		a
 jr		z,conNum    ;add negate
 cp		128
 jr		z,conNum
 cp		1
 jr		z,conVar
 call		isOpenParen
 jr		z,paren2
 ld		de,(freeRam)
 ld		a,tlparen
 ld		(de),a
 inc		de
 ld		(freeRam),de
paren1:
 call		memAssert
 call		toString
 ld		de,(freeRam)
 ld		a,trparen
 ld		(de),a
 inc		de
 ld		(freeRam),de
 ret
conneg:
 ld		de,(freeRam)
 ld		(de),a
 inc		de
 ld		(freeRam),de
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 ld		a,(hl)
 jr		con2
paren2:
 ld		a,(hl)
 ld		de,(freeRam)
 cp		0CFh
 jr		c,tostring1byte
 push		af
 ld		a,0BBh
 ld		(de),a
 inc		de
 pop		af
tostring1byte:
 ld		(de),a
 inc		de
 ld		(freeRam),de
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 ld		a,(hl)
 jr		paren1
conVar:
 inc		hl
 ld		a,(hl)
 ld		de,(freeRam)
 cp		tFakeExp
 jr		nz,conVar2
 ld		a,0BBh
 ld		(de),a
 inc		de
 ld		a,31h
conVar2:
 ld		(de),a
 inc		de
 ld		(freeRam),de
 ret

conNum:
 rst		rmov9toop1
 ld		a,(iy+fmtFlags)
 ld		(iy+fmtOverride),a
 B_CALL	formbase
 ld		de,(freeRam)
 push		de
 push		bc
 ld		hl,op3
 ldir
 ld		(freeRam),de
 pop		bc
 pop		hl
;need to tokenize these number just converted
conNum20:
 dec		hl
 inc		c
conNum2:
 inc		hl
 dec		c
 ret		z
 ld		a,(hl)
 cp		02eh
 jr		nz,nextcom
 ld		(hl),tdecpt
nextcom:
 cp		01ah
 jr		nz,lstcom
 ld		(hl),0b0h
lstcom:
 cp		01Bh
 jr		nz,conNum3
 ld		(hl),tee
conNum3:
 cp		lneg
 jr		nz,conNum2
 ld		(hl),0B0h
 jr		conNum2

conA:
 call		precon
 call		con1
 call		memAssert
 ld		a,tadd
 call		postcon
 jp		con1

conM:
 call		precon
 call		con2
 call		memAssert
 ld		a,tmul
 jr		conM2
; call		postcon
; jp		con2
conS:
 call		precon
 call		con2
 call		memAssert
 ld		a,tsub
conM2:
 call		postcon
 jp		con2

conD:
 call		precon
 call		con2
 call		memAssert
 ld		a,tdiv
 call		postcon
 jp		con3

conE:
 call		precon
 call		con4
 call		memAssert
 ld		a,tpower
 call		postcon
 jp		con4
precon:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 pop		bc
 push		hl
 push		bc
 ex		de,hl
 ld		a,(hl)
 ret
postcon:
 ld		de,(freeRam)
 ld		(de),a
 inc		de
 ld		(freeRam),de
 pop		bc
 pop		hl
 push		bc
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 ld		a,(hl)
 ret
findEONest:
 push		de
 dec		bc       ;to catch up with hl
 ld		a,b
 or		c
 jp		z,syntaxErr
 ld		d,1     ;open paren count so we don't get thrown off by nested ones
findEONest2:
 ld		a,(hl)
 cp		trparen
 jr		z,endParenFound
 call		isOpenParen
 jr		nz,moreParen2go
 inc		d
moreParen2go:
 inc		hl
 dec		bc
 ld		e,a
 ld		a,b
 or		c
 ld		a,e
 jp		z,syntaxErr
 jr		findEONest2
endParenFound:
 dec		d
 jr		nz,moreParen2go
 pop		de
 inc		hl
 ret

;checks to see if the token is part of a number
;input:
;   a = token we're comparing
isNum:						;optiminze... don't return a=0 or 1, just a flag
 ld     b,12
isNumNoB:
 ex     de,hl
 ld     hl,num_vals-1
 ld     c,0
isNum2:
 inc    hl
 cp     (hl)
 jr     z,isNum3
 cp     03ah
 jr     z,decFound
isNum4:
 dec    b
 jr     nz,isNum2
 inc    c
isNum3:
 ld     a,c
 ex     de,hl
 ret
decFound:
 set    decimal,(IY+myFlags)
 jr     isNum4
 
;checks for open parentheses so we can skip that expression
;input:
;   a = token we're comparing
isOpenParen:
 push		hl
 push		bc
 ld		hl,OpenParen
; ld		bc,19
 ld		bc,33
 cpir
 pop    bc
 pop    hl
 ret


stringtonum:
 B_CALL zeroop1
 ld     ix,op1+2
 ld     a,07fh
 ld     (ix-1),a
 pop        bc
 pop        hl
;make sure it doesn't start with an e
 ld     a,(hl)
 cp     tee
 jp     z,syntaxErr
 ld     e,0 ;0 if no decimal yet.
;need to ignore any zeros preceeding the number
 dec        hl
 inc        bc
ignorezeros:
 dec        bc
 inc        hl
 ld     a,(hl)
 cp     t0
 jr     z,ignorezeros2
 cp     tdecpt
 jr     nz,stringtonum0
;it is a decpnt
 ld     a,e
 or     a
 jp     nz,syntaxErr
 ld     e,1
 jr     ignorezeros
ignorezeros2:
 ld     a,e
 or     a
 jr     z,ignorezeros
;decrement mantissa
 push       hl
 ld     hl,op1+1
 dec        (hl)
 pop        hl
 jr     ignorezeros
stringtonum0:
 ld     d,7 ;number of bytes to copy to op1
stringtonum2:
 ld		a,b
 or		c
 jr     z,numStringDone
 ld     a,(hl)
 inc        hl
 dec        bc
 cp     t0
 jr     c,notANum
 cp     t9+1
 jr     nc,notANum
 sub        t0
 rl     a
 rl     a
 rl     a
 rl     a
 ld     (ix),a
 xor        a
 or     e
 call       z,incrementmantissa
stringtonum3:
 ld		a,b
 or     c
 jr     z,numStringDone
 ld     a,(hl)
 inc        hl
 dec        bc
 cp     t0
 jr     c,notANum2
 cp     t9+1
 jr     nc,notANum2
 sub        t0
 or     (ix)
 ld     (ix),a
 inc        ix
 xor        a
 cp     e
 call       z,incrementmantissa
 dec        d
 jr     nz,stringtonum2
;well op1 is full now but we might not have reached the end of the number
iteratenum:
 ld		a,b
 or		c
 jr     z,numStringDone
 ld     a,(hl)
 inc        hl
 dec        bc
 cp     t0
 jr     c,notANum3
 cp     t9+1
 jr     nc,notANum3
 xor        a
 cp     e
 call       z,incrementmantissa
 jr     iteratenum
notANum3:
 cp     tdecpt
 jr     z,isaDecPt3
 cp     tee
 jp     nz,syntaxErr
 jr     getexponent
isaDecPt3:
 xor        a
 cp     e
 jp     nz,syntaxErr
 ld     e,1
 jr     iteratenum
numStringDone:

 ld     de,(freeRam)
 push       de
; ld     hl,op1
; ld     bc,9
; ldir
 B_CALL	movfrop1
 ld     (freeRam),de
 pop        hl
 ret
notANum:
 cp     tdecpt
 jr     nz,notdecpt
 xor        a
 cp     e
 jp     nz,syntaxErr
 ld     e,1
 jp     stringtonum2
notdecpt:
 cp     tee
 jr     z,getexponent
notANum2:
 cp     tdecpt
 jr     nz,notdecpt			;this poses a small problem.  its an infinite loop!
 xor        a
 cp     e
 jp     nz,syntaxErr
 ld     e,1
 jr     stringtonum3
getexponent:
 ld     d,0
 ld     a,(hl)
 cp     0b0h
 jr     nz,notnegexponent
 inc        hl
 inc        d
 dec        bc
notnegexponent:
 ld		a,b
 or		a
 jp		nz,syntaxErr
 ld     e,0
 ld     a,c
 cp     3
 jp     nc,syntaxErr
 cp     1
 jp     c,syntaxErr
 dec        c
 jr     z,onlydigitee
 ld     a,(hl)
 cp     t0
 jp     c,syntaxErr
 cp     t9+1
 jp     nc,syntaxErr
 sub        t0
 add        a,a
 ld     e,a
 add        a,a
 add        a,a
 add        a,e
 ld     e,a
 inc        hl
onlydigitee:
 ld     a,(hl)
 cp     t0
 jp     c,syntaxErr
 cp     t9+1
 jp     nc,syntaxErr
 sub        t0
 add        a,e
 ld     e,a
 xor        a
 cp     d
 jr     z,posee
 ld     a,(op1+1)
 sub        e
 jr     eedone  
posee:
 ld     a,(op1+1)
 add        a,e
eedone:
 ld     (op1+1),a
 jp     numStringDone

incrementmantissa:
 push       hl
 ld     hl,op1+1
 inc        (hl)
 pop        hl
 ret



;input:
;   de = loc of subtree to copy
;output:
;   de = loc of new tree
copySub:
;*
 call		memAssert
;*
 ld hl,(freeRam)
 push   hl
 push   hl
 ex de,hl
 ld a,(hl)
 call   isOpenParen
; or a
 jr z,copyFunc
 ld a,(hl)
 cp 0b0h
 jr z,copyFunc
 or a
 jr z,copyNum
 cp 1
 jr z,copyVar
 ex de,hl
 inc    hl
 inc    hl
 inc    hl
 inc    hl
 inc    hl
 ld (freeRam),hl
 pop    hl
 ld (hl),a
 inc    hl
 push   hl      ;freeRAm+1
 ex de,hl
 inc    hl
 ld e,(hl)
 inc    hl
 ld d,(hl)
 push   hl      ;node+2
 call   copySub
 pop    ix      ;ix=node+2
 pop    hl      ;hl=freeRam+1
 ld (hl),e      
 inc    hl 
 ld (hl),d
 inc    hl
 push   hl      ;freeRAm+3
 ld e,(ix+1)    
 ld d,(ix+2)
 call   copySub
 pop    hl
 ld (hl),e
 inc    hl
 ld (hl),d
 pop    de
 ret
copyFunc:
 ld a,(hl)
 ex de,hl
 inc    hl
 inc    hl
 inc    hl
 ld (freeRam),hl
 pop    hl
 ld (hl),a
 inc    hl
 push   hl
 ex de,hl
 inc    hl
 ld e,(hl)
 inc    hl
 ld d,(hl)
 call   copySub
 pop    hl
 ld (hl),e
 inc    hl 
 ld (hl),d
 pop    de
 ret
copyNum:
 pop    de
; ld bc,9
; ldir
 B_CALL	mov9b
 ld (freeRam),de
 pop    de
 ret 
copyVar:
; pop    de
; ld bc,2
; jr copyLittle
 ex de,hl
 pop    af
 pop    af
 ret
 
;input: hl= start of tree to invert
invASTree:
;*
 call		memAssert
;*
 ld     a,(hl)
 cp     tadd
 jr     z,invASTree2
 cp     tsub
 ret    nz
 dec    (hl)
 jr     invASTree3
invASTree2:
 inc    (hl)
invASTree3:
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 push   hl
 ex     de,hl
 call   invASTree
 pop    hl
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ex     de,hl
 jp     invASTree

;input: hl = tree
;       op1 = coeff
;output:    bc = top of tree
insertCoeff:
 push   hl
 ld     a,(hl)
 or     a
 jp     z,insertCoeff3
 cp     tmul
 jp     nz,insertCoeff2
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ex     de,hl
 ld     a,(hl)
 or     a
 jp     nz,insertCoeff2
insertCoeff3:
 ex     de,hl
; ld     hl,op1
; ld     bc,9
; ldir
 B_CALL	movfrop1
 pop    bc
 ret
insertCoeff2:
 ld     de,(freeRam)
 push   de
; ld     hl,op1
; ld     bc,9
; ldir
 B_CALL	movfrop1
 ex     de,hl
 ld     (hl),tmul
 push   hl
 pop    bc
 inc    hl
 pop    de
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 pop    de
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 ld     (freeRam),hl
 ret
;in: hl = pointer to term
;    de = pointer to exponent
;out:
;    hl = pointer to term w/ exp
insertExp:
 ld     a,(hl)
 cp     tpower
 jp     nz,insertExp2
 push   hl
 inc    hl
 inc    hl
 inc    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 pop    hl
 ret
insertExp2:
 push   hl
 pop    bc
 ld     hl,(freeRam)
 push   hl
 ld     (hl),tpower
 inc    hl
 ld     (hl),c
 inc    hl
 ld     (hl),b
 inc    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 ld     (freeRam),hl
 pop    hl
 ret
;in: hl = pointer to term
;out: hl = pointer to coeff
getCoeff:
 ld     a,(hl)
 or     a
 ret    z
 cp     tmul
 jp     nz,getCoeff2
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ex     de,hl
 ld     a,(hl)
 or     a
 ret    z
getCoeff2:
 ld     hl,aOne
 ret

;in:
;   hl and de both = terms
;out:
;   z if equal, nz if not
cmpIgPow:
 call   cmpIgPow2
 ex     de,hl
 call   cmpIgPow2
 jp     cmpTree
cmpIgPow2:
 ld     a,(hl)
 cp     tpower
 ret    nz
 inc    hl
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
 ret
;in: hl = term
;out de = power
getPower:
 ld     a,(hl)
 cp     tpower
 jp     nz,makeOne
 inc    hl
 inc    hl
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ret
 
cmpIgCoef:              ;stips off first coeff
 ld     a,(hl)
 or     a
 jp     z,getCoeff2
 cp     tmul
 ret    nz
 push   hl
 inc    hl
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
 ld     a,(hl)
 or     a
 jp     nz,cmpIgCoeff2
 pop    ix
 ld     l,(ix+3)
 ld     h,(ix+4)
 ret
cmpIgCoeff2:
 pop    hl
 ret
cmpIgCoeff:
 call   cmpIgCoef
 ex     de,hl
 call   cmpIgCoef
 
;input: 
;   hl = tree 1
;   de = tree 2
;ouput:
;   z   if equal
;   we'll see if i need to do a priority compare
cmpTree:
;*
 call		memAssert
;*
 ld     a,(hl)
 ld     b,a
 ex     de,hl
 ld     a,(hl)
 ex     de,hl
 cp     b
 ret    nz
 cp     080h
 jr     z,cmpTree20
 or     a
 jr     nz,cmpTree2       
cmpTree20:          ;need to check if numbers are the same.....
 ld     c,8
cmpTree21:
 inc    de
 inc    hl
 ld     a,(hl)
 ld     b,a
 ex     de,hl
 ld     a,(hl)
 ex     de,hl
 cp     b
 ret    nz
 dec    c
 jr     nz,cmpTree21
 ret
cmpTree2:
 cp     1
 jr     nz,cmpTree3       ;not a variable
 inc    hl
 inc    de
 ld     a,(hl)
 ld     b,a
 ex     de,hl
 ld     a,(hl)
 cp     b
 ret
cmpTree3:
 push   af
 push   de
 pop    ix
 ld     e,(ix+1)
 ld     d,(ix+2)
 push   ix
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 push   ix
 call   cmpTree
 pop    hl
 pop    hl
 pop    hl
 ret    nz
 dec    sp
 dec    sp
 dec    sp
 dec    sp
 dec    sp
 dec    sp
 pop    ix
 ld     l,(ix+3)
 ld     h,(ix+4)
 pop    ix
 ld     e,(ix+3)
 ld     d,(ix+4)
 pop    af
 cp     0b0h         ;neg sign has only 1 arg
 ret    z
 call   isOpenParen
 ret    z
 call   cmpTree
 ret
;input: none
;output: de=pointer to 1
;destroys: hl,de,bc
makeOne:
;*
 call		memAssert
;*
 ld     de,(freeRam)
 push   de
 ld		hl,aOne
 ld		bc,9
 ldir
 ld     (freeRam),de
 pop    de
 ret
 
;input: none
;output: de=pointer to 0
;destroys: hl,de,bc
makeZero:
;*
 call		memAssert
;*
 ld     de,(freeRam)
 push   de
 ld		hl,aZero
 ld		bc,9
 ldir
 ld     (freeRam),de
 pop    de
 ret

;these could use some optimiazing... also there might be other routines that made their own 2's...
makeTwo:
;*
 call		memAssert
;*
 ld     de,(freeRam)
 push   de
 ld		hl,aTwo
 ld		bc,9
 ldir
 ld     (freeRam),de
 pop    de
 ret

;double check to see if all these are used
op1toop7:
OP1ToOP7:
 ld     hl,op1
toop7:
 ld     de,op7
opcall:
 ld		bc,9
 ldir
 ret
op7toop1:
OP7ToOP1:
 ld     de,op1
op7to:
 ld     hl,op7
 jr     opcall
OP7ToOP2:
 ld     de,op2
 jr     op7to
OP6ToOP7:
 ld     hl,op6
 jr     toop7
OP1ToOP8:
 ld     hl,op1
 ld     de,op8
 jr     opcall
OP8ToOP1:
 ld     hl,op8
 ld     de,op1
 jr     opcall

DispRLE:
    ld bc,768       ; we need to copy (768 for normal pics)
DispRLEL:
DispRLEL2:
    ld a,(hl)       ; get the next byte
    cp 91h      ; is it a run?
    jr z,DispRLERun2    ; then we need to decode the run
    ldi         ; copy the byte, and update counters
DispRLEC2:
    ret po      ; ret if bc hit 0
    jr DispRLEL2    ; otherwise do next byte
DispRLERun2:
    inc hl
    inc hl      ; move to the run count
    ld a,(hl)       ; get the run count
DispRLERunL2:
    dec hl      ; go back to run value
    dec a       ; decrease run counter
    ldi         ; copy byte, dec bc, inc de, inc hl
    jr nz,DispRLERunL2  ; if we're not done, then loop
    inc hl      ; advance the source pointer
    jr DispRLEC2    ; check to see if we should loop

memAssert:
 bit		oninterrupt,(iy+onflags)
 jp		nz,breakErr
 push		hl
 push		de
 ld		de,(imathptr2)
 ld		(stack),sp
 ld		hl,(stack)
memAssertCommon:
 or		a
 sbc		hl,de
 jp		z,notEnMemErr
 ld		de,100
 or		a
 sbc		hl,de
 jp		c,notEnMemErr
 pop		de
 pop		hl
 ret
;used only in demess cause the stack is still where the os intializes it to be and we don't
;want to overwrite the vat while placing new * where multiplication is implied
memAssert2:
 push		hl
 push		de
 ld		de,(imathptr2)
 ld		hl,(imathptr3)
 jr		memAssertCommon
