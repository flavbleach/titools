simplify:
simp2:
;*
 call		memAssert
;*
 push   hl
 pop    ix
 ld     a,(ix)
 or     a
 jp     z,simNum
 cp     1
 jp     z,simNum2
 cp     080h
 jp     z,simNum3
 ld     l,(ix+1)
 ld     h,(ix+2)
 inc    ix
 push   ix
 call   simp2
 pop    ix
 ld     b,0
 ld     l,(ix+2)
 ld     h,(ix+3)        ;hl = the node that is not 1 or 0
 ld     e,(ix)
 ld     d,(ix+1)        ;de = the node that is 1 or 0
 or     a
 push   ix
 call     z,simpZero
 cp     1
 call     z,simpOne
 pop    ix
 cp		254
 ret		z
 ld     l,(ix+2)
 ld     h,(ix+3)
 ld     a,(ix-1)
 cp     tsqrt             ;radical
 jp     z,reduceRad
 cp     tln
 jp     z,reduceLn
 cp     tlog
 jp     z,reduceLog
; cp     0b0h
; jp     z,simNum2
 cp     0b0h
 jp     z,operNeg
 call   isOpenParen
; or     a
 jp     z,simNum2       ;has only one child, and we want to make sure the prog knows this is not a number (a=0) 
 inc    ix
 inc    ix
 push   ix
 call   simp2
 pop    ix
 ld     b,1
 ld     l,(ix-2)
 ld     h,(ix-1)        ;hl = the node that is not 1 or 0
 ld     e,(ix)
 ld     d,(ix+1)        ;de = the node that is 1 or 0
 or     a
 push   ix              ;necessary for the routines that read from the stack
 call     z,simpZero
 cp     1
 call     z,simpOne
 pop    ix

 cp     254
 ret    z
 ld     a,(ix-3)
 cp     tdiv
 jp     z,operDiv
 cp     tmul
 jp     z,operMult
 cp     tadd
 jp     z,operAdd
 cp     tsub
 jp     z,operSub
 cp     tpower
 jp     z,operExp
 jp     simNum2
operExp1Sqrt:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		(ix-2),e
 ld		(ix-1),d
 call		makeTwo
 ld		hl,(freeRam)
 ld		c,(ix)
 ld		b,(ix+1)
 ld		(ix),l
 ld		(ix+1),h
 ld		(hl),tdiv
 inc		hl
 ld		(hl),c
 inc		hl
 ld		(hl),b
 inc		hl
 ld		(hl),e
 inc		hl
 ld		(hl),d
 inc		hl
 ld		(freeRam),hl
 jp		setMod
operExp:
 ld     l,(ix-2)
 ld     h,(ix-1)
 ld     a,(hl)
 or     a
 jp     z,operExp1Num
 cp     tpower
 jp     z,operExp1Exp
 cp     tmul
 jp     z,operExp1Mult
 cp		tsqrt
 jr		z,operExp1Sqrt
 cp		tdiv
 jr		nz,operExp2
 push		hl
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		hl
 ld		a,(de)
 or		a
 jr		z,operExp1Div
 cp		tsqrt
 jr		z,operExp1Div2
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		a,(de)
 or		a
 jr		z,operExp1Div
 cp		tsqrt
 jr		z,operExp1Div2
operExp20:
 pop		hl
operExp2:
 ex		de,hl
 ld		l,(ix)
 ld		h,(ix+1)
 ld		a,(hl)
 cp		0B0h
 jr		z,operExp2Neg ;is power negative?
 jp     simNum2
operExp2Neg:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		(ix),e
 ld		(ix+1),d
 ld		e,(ix-2)
 ld		d,(ix-1)
 push		de
 call		makeOne
 ld		hl,(freeRam)
 ld		(ix-2),l
 ld		(ix-1),h
 ld		(hl),tdiv
 inc		hl
 ld		(hl),e
 inc		hl
 ld		(hl),d
 inc		hl
 pop		de
 ld		(hl),e
 inc		hl
 ld		(hl),d
 inc		hl
 ld		(freeRam),hl
 jp		setmod
; inc		hl
; ld		e,(hl)
; inc		hl
; ld		d,(hl)
; ld		(ix),e
; ld		(ix+1),d			;get rid of negative
; call		makeOne
; ld		hl,(freeRam)
; push		hl
; ld		(hl),tdiv
; inc		hl
; ld		(hl),e
; inc		hl
; ld		(hl),d
; inc		hl
; push		ix
; pop		de
; dec		de
; dec		de
; dec		de
; ld		(hl),e
; inc		hl
; ld		(hl),d
; inc		hl
; ld		(freeRam),hl
; pop		de
; pop		bc
; pop		hl
; push		hl
; push		bc
; ld		(hl),e
; inc		hl
; ld		(hl),d
; jp		setMod
operExp1Div:
 ld		e,(ix)
 ld		d,(ix+1)
 ld		a,(de)
 or		a
 jr		nz,operExp20
operExp1Div2:
 ld		e,(ix)
 ld		d,(ix+1)
 ld		(ix-3),tdiv
 pop		hl
 ld		(hl),tpower
 inc		hl
 inc		hl
 inc		hl
 ld		c,(hl)
 ld		(hl),e
 inc		hl
 ld		b,(hl)
 ld		(hl),d
 push		bc
 push		ix
 call		copySub
 pop		ix
 pop		bc
 ld		hl,(freeRam)
 ld		(ix),l
 ld		(ix+1),h
 ld		(hl),tpower
 inc		hl
 ld		(hl),c
 inc		hl
 ld		(hl),b
 inc		hl
 ld		(hl),e
 inc		hl
 ld		(hl),d
 inc		hl
 ld		(freeRam),hl
 jp		setMod
operExp1Num:
 ex     de,hl
 ld     l,(ix)
 ld     h,(ix+1)
 ld     a,(hl)
 or     a
 jp     nz,operExp2
 push     hl
 push     de
 B_CALL	mov9toop2
 pop      hl
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	ytox
 pop      de
 push     de
 B_CALL	movfrop1
 pop      bc
 pop      de
 pop      hl
 push     hl
 push     de
 ld      (hl),c
 inc      hl
 ld      (hl),b
 jp      setMod
operExp1Exp:
 ld     e,(ix)
 ld     d,(ix+1)
 ld     (ix),l
 ld     (ix+1),h
 ld     (hl),tmul
 inc    hl
 ld     c,(hl)
 ld     (hl),e
 inc    hl
 ld     b,(hl)
 ld     (hl),d
 ld     (ix-2),c
 ld     (ix-1),b
 jp     setMod
operNeg:
 ld     l,(ix)
 ld     h,(ix+1)
 ld     a,(hl)
 cp     0b0h
 jr     z,operNegNeg
 cp		tsub
 jp		nz,simNum2
 inc		hl
 ld		c,(hl)
 inc		hl
 push		hl
 ld		b,(hl)
 inc		hl
 ld		e,(hl)
 ld		(hl),c
 inc		hl
 ld		d,(hl)
 ld		(hl),b
 pop		hl
 ld		(hl),d
 dec		hl
 ld		(hl),e
 dec		hl
;hl = new node... ix is bad node
 pop		bc
 pop		de
 push		de
 push		bc
 ex		de,hl
 ld		(hl),e
 inc		hl
 ld		(hl),d
 jp		setmod
operNegNeg:
;--(u)=u
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 pop    bc
 pop    hl
 push   hl
 push   bc
 ld     (hl),e
 inc    hl
 ld     (hl),d
 jp     setmod
operAdd:
 ld     l,(ix-2)
 ld     h,(ix-1)
 ld     a,(hl)
 cp     0b0h
 jp     z,operAdd1Neg
 cp     tsub
 jp     z,operAdd1Sub
 cp     tadd
 jp     z,operAdd1Add
 ex     de,hl
 ld     l,(ix)
 ld     h,(ix+1)
 ld     a,(hl)
 cp     0b0h
 jp     z,operAdd2Neg
 cp     tsub
 jp     z,operAdd2Sub

 ld     a,(mod2Flag)
 or     a
 jp     nz,simNum2
;we can now see if terms can be combined
 ld     (tempHL),ix
 ld     (tempBC),hl
 ld     (pro1Parent),de
 push   hl
 pop    de                  
 ld     a,(hl)
 cp     tadd
 jp     nz,skipSome
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
skipSome:
 ld     (pro2Parent),de
 ld     hl,(pro1Parent)
 ld     a,(hl)
 cp     tdiv
 jp     z,operAdd1Div
 ex     de,hl
 ld     a,(hl)
 cp     tdiv
 jp     z,operAdd1NoDiv2Div
;here we have (!/) and (!/)
 call   cmpIgCoeff
 jp     nz,simNum2
;yes! combine terms!
 ld     hl,(pro1Parent)
 call   getCoeff
; ld     de,op1
; ld     bc,9
; ldir
 rst		rmov9toop1
 ld     hl,(pro2Parent)
 call   getCoeff
; ld     de,op2
; ld     bc,9
; ldir
 B_CALL	mov9toop2
; B_CALL	fpadd
 rst		rfpadd
 ld     hl,(pro1Parent)
 call   insertCoeff
 ld     ix,(tempBC)
 ld     a,(ix)
 cp     tadd
 jp     nz,pull2Top
 ld     l,(ix+3)
 ld     h,(ix+4)
 ld     ix,(tempHL)
 ld     (ix-2),l
 ld     (ix-1),h
 ld     (ix),c
 ld     (ix+1),b
 jp     setMod
;input: bc node to pull to the top
pull2Top:
 pop    de
 pop    hl
 push   hl
 push   de
 ld     (hl),c
 inc    hl
 ld     (hl),b
 jp     setMod

 
operAdd1NoDiv2Div:
;here we have (!/) and ?/?
 push   hl
 pop    ix
 ld     l,(ix+3)
 ld     h,(ix+4)
 ld     a,(hl)
 or     a
 jp     nz,simNum2          ;must be a number if both are not /
;here we have (!/) and (?/#)
 ld     l,(ix+1)
 ld     h,(ix+2)
 ld     de,(pro1Parent)
 call   cmpIgCoeff
 jp     nz,simNum2
;yes! combine terms!
 ld     hl,(pro1Parent)
 call   getCoeff
; ld     de,op1
; ld     bc,9
; ldir
 rst		rmov9toop1
 ld     ix,(pro2Parent)
 ld     l,(ix+3)
 ld     h,(ix+4)
; ld     de,op2
; ld     bc,9
; ldir
 B_CALL	mov9toop2
 B_CALL	fpmult
 ld     hl,(pro2Parent)
 ld     l,(ix+1)
 ld     h,(ix+2)
 call   getCoeff
; ld     de,op2
; ld     bc,9
; ldir
 B_CALL	mov9toop2
; B_CALL	fpadd
 rst		rfpadd
 ld     ix,(pro2Parent)
 ld     l,(ix+1)
 ld     h,(ix+2)
 push   ix
 call   insertCoeff
 pop    ix
 ld     (ix+1),c
 ld     (ix+2),b
 ld     bc,(tempBC)
 jp     pull2Top

operAdd1Div:
 ex     de,hl
 ld     a,(hl)
 cp		tdiv
 jp     z,operAdd1Div2Div
 push   de
 pop    ix
 ex     de,hl
 ld     l,(ix+3)
 ld     h,(ix+4)
 ld     a,(hl)
 or     a
 jp     nz,simNum2          ;must be a number if both are not /
;here we have ?/# and (!/)
 ld     l,(ix+1)
 ld     h,(ix+2)
 call   cmpIgCoeff
 jp     nz,simNum2
;yes! combine terms!
 ld     hl,(pro2Parent)
 call   getCoeff
; ld     de,op1
; ld     bc,9
; ldir
 rst		rmov9toop1
 ld     ix,(pro1Parent)
 ld     l,(ix+3)
 ld     h,(ix+4)
; ld     de,op2
; ld     bc,9
; ldir
 B_CALL	mov9toop2
 B_CALL fpmult
 ld     hl,(pro1Parent)
 ld     l,(ix+1)
 ld     h,(ix+2)
 call   getCoeff
; ld     de,op2
; ld     bc,9
; ldir
 B_CALL	mov9toop2
; B_CALL	fpadd
 rst		rfpadd
 ld     ix,(pro1Parent)
 ld     l,(ix+1)
 ld     h,(ix+2)
 push   ix
 call   insertCoeff
 pop    hl
 push   hl
 inc    hl
 ld     (hl),c
 inc    hl
 ld     (hl),b
 pop    bc
 ld     ix,(tempBC)
 ld     a,(ix)
 cp     tadd
 jp     nz,pull2Top
 ld     c,(ix+3)
 ld     b,(ix+4)
 ld     hl,(tempHL)
 ld     (hl),c
 inc    hl
 ld     (hl),b
 jp     setMod
 
operAdd1Div2Div:    ;hl=pro2parent
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 inc    hl
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
 ld     ix,(pro1Parent)
 ld     l,(ix+1)
 ld     h,(ix+2)
 push   bc
 push   ix
 call   cmpIgCoeff
 pop    ix
 pop    de
 jp     nz,simNum2
 ld     l,(ix+3)
 ld     h,(ix+4)
 push   ix
 push   hl
 push   de
 call   cmpIgCoeff
 pop    hl          ;pro2parent divisor
 pop    de          ;pro1parent divisor
 pop    ix
 jp     nz,simNum2
 push   hl
 push		de
 call   getCoeff
 pop		de
 push   hl
 push   de
; ld     de,op1
; ld     bc,9
; ldir               ;op1 = coeff of denominator of pro2parent
 rst		rmov9toop1
 ld     l,(ix+1)
 ld     h,(ix+2)
 call   getCoeff
; ld     de,op2      ;op2 = coeff of numerator of pro1parent
; ld     bc,9
; ldir
 B_CALL	mov9toop2
 B_CALL	fpmult
; ld     hl,op1
; ld     de,op4
; ld     bc,9
; ldir               ;op4 = c of d of p2 * c of n of p1
 B_CALL	op1toop4		
 pop    hl          ;pro1parent denominator
 call   getCoeff
 push   hl
; ld     de,op1
; ld     bc,9
; ldir               ;op1 = coeff of p1 denominator 
 rst		rmov9toop1
 ld     hl,(pro2Parent)
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ex     de,hl
 push   hl
 call   getCoeff
; ld     de,op2
; ld     bc,9
; ldir               ;op2 = coeff of p2 numerator
 B_CALL	mov9toop2
 B_CALL	fpmult
; ld     hl,op4
; ld     de,op2
; ld     bc,9
; ldir
 B_CALL	op4toop2
; B_CALL	fpadd
 rst		rfpadd
 pop    hl
 call   insertCoeff
 ld     hl,(pro2Parent)
 inc    hl
 ld     (hl),c
 inc    hl
 ld     (hl),b
 pop    hl
; ld     de,op1
; ld     bc,9
; ldir
 rst		rmov9toop1
 pop    hl
; ld     de,op2
; ld     bc,9
; ldir
 B_CALL	mov9toop2
 B_CALL fpmult
 pop    hl
 call   insertCoeff
 ld     ix,(pro2Parent)
 ld     (ix+3),c
 ld     (ix+4),b
 ld     bc,(tempBC)
 jp     pull2Top
 
operMult1Mult:
operAdd1Add:
 ld     e,(ix)
 ld     d,(ix+1)
 ld     (ix),l
 ld     (ix+1),h
 inc    hl
 ld     c,(hl)
 ld     (hl),e
 inc    hl
 ld     b,(hl)
 ld     (hl),d
 ld     (ix-2),c
 ld     (ix-1),b
 jp     setMod
operMult1Div:
operAdd1Sub:
 ld     (ix-3),a
 ld     e,(ix)
 ld     d,(ix+1)
 dec    (hl)
 inc    hl
 inc    hl
 inc    hl
 ld     c,(hl)
 ld     (hl),e
 inc    hl
 ld     b,(hl)
 ld     (hl),d
 ld     (ix),c
 ld     (ix+1),b
 jp     setMod
operMult2Div
operAdd2Sub:
 ld     (ix-3),a
 ld     (ix-2),l
 ld     (ix-1),h
 dec    (hl)
 inc    hl
 inc    hl
 inc    hl
 ld     c,(hl)
 ld     (hl),e
 inc    hl
 ld     b,(hl)
 ld     (hl),d
 ld     (ix),c
 ld     (ix+1),b
 jp     setMod

operAdd1Neg:
 ld     e,(ix)
 ld     d,(ix+1)
 ld     (ix-2),e
 ld     (ix-1),d
 ld     (ix),l
 ld     (ix+1),h
operAdd2Neg:       
 ld     (ix-3),tsub
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ld     (ix),e
 ld     (ix+1),d
 jp     setmod
operSub:
 ld     l,(ix-2)
 ld     h,(ix-1)
 ld     a,(hl)
 cp     tsub                                         ;do you want to put those operAdd1Add thingies back?
 jp     z,operSub1Sub
 ld		a,(mod2Flag)
 or		a
 jr		nz,operSub2			;there are simpler things to do if there are positive terms
 ld		a,(hl)
 cp		0b0h
 jp		z,operSub1Neg
operSub2:
 ex     de,hl                                       ;also finish doing fixing the swapped nodes bug
 ld     l,(ix)
 ld     h,(ix+1)
 ld     a,(hl)
 cp     tsub
 jp     z,operSub2Sub
 cp     0b0h
 jp     z,operSub2Neg
 
 ld     a,(mod2Flag)
 or     a
 jp     nz,simNum2
;now check for matches

 ld     (pro1Parent),ix
 dec    ix
 dec    ix
 ld     (pro2Parent),ix
subCancel:
 push   de
subCancel2:
 push   hl
 push   de
 ld     a,(hl)
 cp     tadd
 jr     nz,subCancel3
 inc    hl
 ld     (pro1Parent),hl
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
subCancel3:
 ld     (tempHL),hl
 ex     de,hl
 ld     a,(hl)
 cp     tadd
 jr     nz,subCancel4
 inc    hl
 ld     (pro2Parent),hl
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
subCancel4:
 ld     (tempBC),hl
; call   cmpIgCoeff
; jr     z,subCancelMatch
 ld		a,(hl)
 cp		tdiv
 jp		z,subCancel1Div
 ld		a,(de)
 cp		tdiv
 jr		z,subCancel2Div
;!/ and !/
 call		cmpIgCoeff
 jp		z,subCancelMatch
 jp		subnotequal		

;!/ and ?/?
subCancel2Div:
 push		hl
 ex		de,hl
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 pop		hl
 call		cmpIgCoeff
 jp		nz,subnotequal
 ld		hl,(tempHL)		;neg node	
 inc		hl
 inc		hl
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 ld		a,(hl)
 or		a
 jp		nz,subnotequal
 B_CALL	mov9toop2
 ld		hl,(tempBC)
 call		getCoeff
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	fpmult
 ld		hl,(tempHL)
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		getCoeff
 B_CALL	mov9toop2
 B_CALL	fpsub
 pop		af
 pop		af
 pop		af
 ld		a,(op1)
 cp		80h
 jr		z,subCancel2DivNeg
subCancelSwapper:
 ld		hl,(tempHL)
 inc		hl
 ld		e,(hl)
 inc		hl
 push		hl
 ld		d,(hl)
 ex		de,hl
 call		insertCoeff
 pop		hl
 ld     (hl),b
 dec    hl
 ld     (hl),c
 dec		hl
 ex		de,hl
 ld		hl,(pro2Parent)
 ld		(hl),e
 inc		hl
 ld		(hl),d
 B_CALL	op1set0
 ld     hl,(tempHL)
 call   insertCoeff
 ld     hl,(pro1Parent)
 ld     (hl),c
 inc    hl
 ld     (hl),b
 jp     setMod
subCancel2DivNeg:
 xor		a
 ld		(op1),a
 ld		hl,(tempHL)
 inc		hl
 push		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		insertCoeff
 pop		hl
 jp		subNeg2

;?/? and 
subCancel1Div:
 ld		a,(de)
 cp		tdiv
 jr		z,subCancel1Div2Div
;?/? and !/
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		hl
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 ld		a,(bc)
 or		a
 jp		nz,subnotequal
 ld		hl,(tempHL)
 push		hl
 push		bc
 push		de
 call		cmpIgCoeff
 pop		de
 pop		bc
 pop		hl
 jp		nz,subnotequal
 push		de
 push		bc
 call		getCoeff
; B_CALL	mov9toop1
 rst		rmov9toop1
 pop		hl
 B_CALL	mov9toop2
 B_CALL	fpmult
 pop		hl
 call		getCoeff
 B_CALL	mov9toop2
 B_CALL	fpsub
 pop		af
 pop		af
 pop		af
 ld		a,(op1)
 cp		80h
 jr		z,subCancel1DivNeg
 ld		hl,(tempHL)
 ld		bc,(tempBC)
 ld		(tempHL),bc
 ld		(tempBC),hl
 ld		hl,(pro1Parent)
 ld		bc,(pro2Parent)
 ld		(pro1Parent),bc
 ld		(pro2Parent),hl
 jp		subCancelSwapper
subCancel1DivNeg:
 xor		a
 ld		(op1),a
 ld		hl,(tempBC)
 inc		hl
 push		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		insertCoeff
 pop		hl
 jp		subPos2

;?/? and ?/?
subCancel1Div2Div:
 inc		hl
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 inc		hl
 push		hl
 ex		de,hl
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		hl
 push		hl
 ld		h,b
 ld		l,c
 call		cmpIgCoeff
 pop		de
 pop		hl
 jp		nz,subnotequal
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 ex		de,hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		h,b
 ld		l,c
 push		hl
 push		de
 call		cmpIgCoeff
 pop		de
 pop		hl
 jp		nz,subnotequal
 push		de
; B_CALL	mov9toop1
 call		getCoeff
 rst		rmov9toop1
 pop		hl
 call		getCoeff
 B_CALL	mov9toop2
 B_CALL	cpop1op2
 jr		z,likedenoms
 B_CALL	op1toop4
 B_CALL	fpmult
 B_CALL	op1toop6
 ld		hl,(tempBC)
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		getCoeff
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	fpmult
 B_CALL	op1toop5
 ld		hl,(tempHL)
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		getCoeff
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	op4toop2
 B_CALL	fpmult
 B_CALL	op5toop2
 jr		subCancel1Div2DivFinish
likedenoms:
 B_CALL	op1toop6
 ld		hl,(tempBC)
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		getCoeff
 B_CALL	mov9toop2
 ld		hl,(tempHL)
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		getCoeff
; B_CALL	mov9toop1 
 rst		rmov9toop1
subCancel1Div2DivFinish:
 B_CALL	op1exop2
 B_CALL	fpsub
 B_CALL	op2set0
 ld		a,(op1)
 or		a
 jr		z,properops
 xor		a
 ld		(op1),a
 B_CALL	op1exop2
properops:
 ld		hl,(tempBC)
 call		makefractions
 B_CALL	op2toop1
 ld		hl,(tempHL)
 call		makefractions
 pop		af
 pop		af
 pop		af
 jp		setMod
makefractions:
 inc		hl
 push		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		insertCoeff
 pop		hl
 ld		(hl),c
 inc		hl
 ld		(hl),b
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 push		hl
 push		de
 B_CALL	op6toop1
 pop		hl
 call		insertCoeff
 pop		hl
 ld		(hl),b
 dec		hl
 ld		(hl),c
 ret
subnotequal:
 pop    hl
 ld     a,(hl)
 cp     tadd
 jr     nz,subCancel5
 inc    hl
 inc    hl
 inc    hl
 ld     (pro2Parent),hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 pop    hl
;i don't think pro1Parent will be different in this case
 jp		subCancel2
subCancel5:
 pop    hl
 pop    de
 ld     a,(hl)
 cp     tadd
 jp     nz,simNum2
 inc    hl
 inc    hl
 inc    hl
 ld     (pro1Parent),hl
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
 jp     subCancel
subCancelMatch:  ;(sp) = pos node (sp-2) = neg node ;pro parents = like terms
 pop    af
 pop    af
 pop    af
 ld     hl,(tempHL)
 call   getCoeff
; ld     de,op2
; ld     bc,9
; ldir
 B_CALL	mov9toop2
 ld     hl,(tempBC)
 call   getCoeff
; ld     de,op1
; ld     bc,9
; ldir
 rst		rmov9toop1
 B_CALL	fpsub
 B_CALL	ckop1fp0
 jr     z,subCancelBoth
 B_CALL	ckop1pos
 jr     z,subPos
subNeg:
 xor    a
 ld     (op1),a
 ld     hl,(tempHL)
 call   insertCoeff
 ld     hl,(pro1Parent)
subNeg2:
 ld     (hl),c
 inc    hl
 ld     (hl),b
 B_CALL	op1set0
 jr		subcommon
; ld     hl,(tempBC)
; call   insertCoeff
; ld     hl,(pro2Parent)
; ld     (hl),c
; inc    hl
; ld     (hl),b
; jp     setMod
subPos 
 ld     hl,(tempBC)
 call   insertCoeff
 ld     hl,(pro2Parent)
subPos2:
 ld     (hl),c
 inc    hl
 ld     (hl),b
 B_CALL	op1set0
 ld     hl,(tempHL)
 call   insertCoeff
 ld     hl,(pro1Parent)
; ld     (hl),c
; inc    hl
; ld     (hl),b
; jp     setMod
 jr		ldbcinhlsetmod
subCancelBoth:
 ld     hl,(tempHL)
 call   insertCoeff
 ld     hl,(pro1Parent)
 ld     (hl),c
 inc    hl
 ld     (hl),b
subcommon:
 ld     hl,(tempBC)
 call   insertCoeff
 ld     hl,(pro2Parent)
ldbcinhlsetmod:
 ld     (hl),c
 inc    hl
 ld     (hl),b
 jr		setmod_sub
; jp     setMod
operSub1Neg:
 dec		ix
 dec		ix
 dec		ix
 inc		hl
 ld		c,(hl)
 inc		hl
 ld		b,(hl)
 push		ix
 pop		de
 ld		(hl),d
 dec		hl
 ld		(hl),e
 dec		hl
 ld		(ix),tadd
 ld		(ix+1),c
 ld		(ix+2),b
 ex		de,hl
 pop		bc
 pop		hl
 push		hl
 push		bc
 ld		(hl),e
 inc		hl
 ld		(hl),d
setmod_sub:
 jp		setmod
operSub2Neg:
 ld     (ix-3),tadd
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ld     (ix),e
 ld     (ix+1),d
; jp     setmod
 jr		setmod_sub
operDiv1Div:
operSub1Sub:
 ld     e,(ix)
 ld     d,(ix+1)
 ld     (ix),l
 ld     (ix+1),h
 dec    (hl)
 inc    hl
 ld     c,(hl)
 ld     (hl),e
 inc    hl
 ld     b,(hl)
 ld     (hl),d
 ld     (ix-2),c
 ld     (ix-1),b
; jp     setmod
 jr		setmod_sub
operDiv2Div:
operSub2Sub:
 ld     (ix-2),l
 ld     (ix-1),h
 dec    (hl)
 inc    hl
 ld     c,(hl)
 ld     (hl),e
 inc    hl
 ld     b,(hl)
 ld     (hl),d
 ld     (ix),c
 ld     (ix+1),b
; jp     setmod
 jr		setmod_sub
operMult:
 ld     l,(ix-2)
 ld     h,(ix-1)
 ld     a,(hl)
 cp     tmul
 jp     z,operMult1Mult
 cp     tdiv
 jp     z,operMult1Div
 cp     tadd
 jp     z,operMult1Add
 cp     tsub
 jp     z,operMult1Sub
 cp     0b0h
 jp     z,operMult1Neg
 or     a
 jp     z,operMult1Num
 ex     de,hl
operMult2:
 ld     l,(ix)
 ld     h,(ix+1)
 ld     a,(hl)
 cp     tdiv
 jp     z,operMult2Div
 cp     0b0h
 jp     z,operMult2Neg
 cp     tadd
 jp     z,operMult2Add
 cp     tsub
 jp     z,operMult2Sub

 ld     a,(mod2Flag)
 or     a
 jp     nz,simNum2
;now see if terms can be combined

 ld     (tempBC),hl
 ld     (pro1Parent),de
 push   ix
 pop    bc
 dec    bc
 dec    bc
 dec    bc
 ld     (tempHL),bc
 ld     ix,tempBC
 jp     iterateMult3
iterateMult:
 ld     hl,(tempHL)
 ld     a,(hl)
 cp     tmul
 jp     nz,simNum2
 inc    hl
 inc    hl
 inc    hl
 push   hl
 pop    ix
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
 ld     (tempHL),hl
iterateMult3:
 ld     a,(hl)
 cp     tmul
 jp     nz,iterateMult2
 inc    hl
 push   hl
 pop    ix
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
iterateMult2:
 ld     (pro2Parent),hl
 ld     de,(pro1Parent)
 push   ix
 call   cmpIgPow
 pop    ix
 jp     nz,iterateMult
 ld     hl,(pro2Parent)
 push   hl
 call   getPower
 ld     hl,(freeRam)
 push   hl
 ld     (hl),tadd
 inc    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 push   hl
 inc    hl
 inc    hl
 ld     (freeRam),hl
 ld     hl,(pro1Parent)
 call   getPower
 pop    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 pop    de
 pop    hl
 call   insertExp
 ld     (ix),l
 ld     (ix+1),h
 ld     bc,(tempBC)
 jp     pull2Top
operExp1Mult:
 ld     c,a
 ld     b,tpower
 jr     operExpMult2
operMult1Sub:
operMult1Add:
;i need to give the divide routine time to cancel terms, then i can expand.
;the symbolic divide will catch what the canceler does not
 ld     b,tmul
 ld     c,a
 ld     a,(lastFlag)
 or     a
 jp     z,simNum2
operExpMult2:
 ld     (ix-3),c
 ld     e,(ix)
 ld     d,(ix+1)
 push   ix
 push   de
 push   hl
 push   bc
 call   copySub
 pop    bc
 pop    ix
 ld     (ix),b
 ld     l,(ix+3)
 ld     (ix+3),e
 ld     h,(ix+4)
 ld     (ix+4),d
 ex     de,hl
 ld     hl,(freeRam)
 ld     (hl),b
 push   hl
 pop    bc
 inc    hl
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
 pop    hl
 ld     (hl),c
 inc    hl
 ld     (hl),b
 jp     setMod
operMult2Sub:
operMult2Add:
 ld     c,a
 ld     a,(lastFlag)
 or     a
 jp     z,simNum2
 ld     (ix-3),c
 push   de
 push   hl
 push   ix
 call   copySub
 pop    ix
 pop    hl
 ld     (ix-2),l
 ld     (ix-1),h
 ld     (hl),tmul
 inc    hl
 inc    hl
 inc    hl
 ld     c,(hl)
 ld     (hl),e
 inc    hl
 ld     b,(hl)
 ld     (hl),d
 ld     hl,(freeRam)
 push   hl
 ld     (hl),tmul
 inc    hl
 ld     (hl),c
 inc    hl
 ld     (hl),b
 inc    hl
 pop    bc
 pop    de
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 ld     (freeRam),hl
 ld     (ix),c
 ld     (ix+1),b
 jp     setMod
operMult1Num:
 ex   de,hl
 ld   l,(ix)
 ld   h,(ix+1)
 ld   a,(hl)
 or   a
 jp   z,operMult1Num2Num
 cp   tmul
 jp   nz,operMult2
operMult1Num2:
 push     hl
 inc      hl
 ld   c,(hl)
 inc      hl        ;   *
 ld   b,(hl)        ;  / \
 push     bc        ;#a   *   <- bc = this location; de = #a
 pop      hl        ;    / \
 pop      bc        ;   ?b ?c <- hl = ?b
 ld   a,(hl)
 or   a
 jp   nz,operMult2
operMult1Num22:     ;optimizable... use pull2top method
 push     bc
 push     hl
 push     de
; B_CALL	mov9toop1
 rst		rmov9toop1
 pop      hl
 B_CALL	mov9toop2
 B_CALL	fpmult
 pop      de
operMult1Num2NumCommon:
 B_CALL	movfrop1
 pop      bc
 pop      de
 pop      hl
 push     hl
 push     de
 ld   (hl),c
 inc      hl
 ld   (hl),b
 jp   simNum2
operMult1Num2Num:
 push     de
; B_CALL	mov9toop1
 rst		rmov9toop1
 pop      hl
 push     hl
 B_CALL	mov9toop2
 B_CALL	fpmult
 pop      de
 push     de
 jr		operMult1Num2NumCommon
; B_CALL	movfrop1
; pop      bc
; pop      de
; pop      hl
; push     hl
; push     de
; ld   (hl),c
; inc      hl
; ld   (hl),b
; jp   simNum2
operDiv2Neg:
operMult2Neg:
 dec    ix
 dec    ix
 dec    ix
 push   ix
 pop    bc
 push   hl
 inc    hl
 ld     e,(hl)
 ld     (hl),c
 inc    hl
 ld     d,(hl)
 ld     (hl),b
 ld     (ix+3),e
 ld     (ix+4),d
 pop    de
 jr     operMultNeg
operDiv1Neg:
operMult1Neg:
 dec    ix
 dec    ix
 dec    ix              ;optimize!!!!!!!!!
 push   ix
 pop    bc
 push   hl
 inc    hl
 ld     e,(hl)
 ld     (hl),c
 inc    hl
 ld     d,(hl)
 ld     (hl),b
 ld     (ix+1),e
 ld     (ix+2),d
 pop    de
operMultNeg:
 pop    bc
 pop    hl
 push   hl
 push   bc
 ld     (hl),e
 inc    hl
 ld     (hl),d
 jp     setmod
operDiv:
 ld     l,(ix-2)
 ld     h,(ix-1)
 ld     a,(hl)
 cp     tdiv
 jp     z,operDiv1Div
 cp     0b0h
 jp     z,operDiv1Neg
 ex     de,hl
 ld     l,(ix)
 ld     h,(ix+1)
 ld     a,(hl)
 cp     tdiv
 jp     z,operDiv2Div
 cp     0b0h
 jp     z,operDiv2Neg
 
;we can now attempt to cancel some terms in the numerator and denominator
 ld     a,(mod2Flag)
 or     a
 jp     nz,simNum2

;this need some kind of final flag or something so that it is only executed once
;look to see if there are any
 push   ix
 push   hl
 push   de
 call   getCoeff
 B_CALL	mov9toop2
 B_CALL	op1set1
 B_CALL	cpop1op2
 jp     z,nothing2Cancel
 pop    hl
 push   hl
 call   getCoeff
; B_CALL	mov9toop1
 rst		rmov9toop1
 bit    decimal,(iy+myFlags)
 jp     z,symbolicDiv
 B_CALL	fpdiv
 pop    hl
 pop    ix
 push   hl
 ld     a,(ix)
 or     a
 jp     z,denIsNum
 ld     e,(ix+3)
 ld     d,(ix+4)
 pop    hl
 pop    ix
 ld     (ix),e
 ld     (ix+1),d
 push   de
 call   insertCoeff
 ld     (ix-2),c
 ld     (ix-1),b
 pop    hl
 push   bc
 pop    de
 jp     startCancel
denIsNum:
 pop    hl
 pop    af
 call   insertCoeff
 jp     pull2Top
symbolicDiv:
;need to check to see if num is one, if it is then don't go through with this
 B_CALL	op2toop3
 B_CALL	op2set1
 B_CALL	cpop1op2          ;maybe you should make your own functions that do the same as these romcalls
 jp     z,nothing2Cancel
 B_CALL	op3toop2

; ld     hl,op2
; B_CALL	pushreal
 ld		hl,op2
 ld		de,op7
 B_CALL	mov9b
; ld     hl,op1
; B_CALL	pushreal
 ld		de,op8
 B_CALL	movfrop1
 B_CALL	cpop1op2
 jr     nc,opsStay
 B_CALL	op1exop2
opsStay:
gcdLoop:
 B_CALL	op1toop5
 B_CALL	op2toop6
 B_CALL	fpdiv
 B_CALL	frac      ;need to write a modulo routine for speed
 B_CALL	op6toop2
 B_CALL	fpmult
 ld     d,0
 B_CALL	round
 B_CALL	op2set0
 B_CALL	cpop1op2
 jr     z,gcdFound
 B_CALL	op2set1
 B_CALL	cpop1op2
 jr     z,relPrime
 rst		rop1toop2
 B_CALL	op6toop1
 jr		gcdLoop
gcdFound:
; ld     de,op1
; B_CALL	popreal
 ld		hl,op8
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	op6toop2
 B_CALL	fpdiv
 pop    hl
 pop    de
 push   hl
 push   de
 call   insertCoeff
; ld     de,op1
; B_CALL	popreal           
 ld		hl,op7
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	op6toop2
 B_CALL	fpdiv
 pop    hl
 push   hl
 call   insertCoeff
 pop    hl
 pop    de
 pop    ix
 ld     a,255
 ld     (modFlag),a
 jr     startCancel
relPrime:
; ld     de,op1
; B_CALL	popreal
; ld     de,op1
; B_CALL	popreal
nothing2Cancel:
 pop    de
 pop    hl
 pop    ix
startCancel:
;hl = numerator
;de = denominator
 ld     (pro2Parent),ix
 dec    ix
 dec    ix
 ld     (pro1Parent),ix ;de's
cancelTerms:
 push   hl
cancelTerms2:
 push   de
 push   hl
 
 ld     a,(hl)
 cp     tmul
 jr     nz,skipAFew
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 inc    ix
 ld     (pro2Parent),ix
skipAFew:
 ex     de,hl
 ld     a,(hl)
 cp     tmul
 jr     nz,skipAFew2
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 inc    ix
 ld     (pro1Parent),ix
skipAFew2:
 ld     a,(hl)
 cp     0b0h
 jr     nz,skipAFew5
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 inc    ix
 ld     (pro1Parent),ix
skipAFew5:
 ex     de,hl
 ld     a,(hl)
 cp     0b0h
 jr     nz,skipAFew6
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 inc    ix
 ld     (pro2Parent),ix
skipAFew6:
 ex     de,hl               ;fix the hl - de screw up
 ld     a,(hl)
 cp     tpower
 jr     nz,cancelNoEx
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
cancelNoEx:
 ex     de,hl
 ld     a,(hl)
 cp     tpower
 jr     nz,cancelNoEx2
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
cancelNoEx2:
 call   cmpTree
 jr     z,cancelMatch
 pop    hl
 ld     a,(hl)
 cp     tmul
 jr     nz,iterateDE
 push   hl
 pop    ix
 ld     l,(ix+3)
 ld     h,(ix+4)
 inc    ix
 inc    ix
 inc    ix
 ld     (pro2Parent),ix
 pop    de
 jp     cancelTerms2
iterateDE:
 pop    ix
 ld     a,(ix)
 cp     tmul
 jr     nz,cancelQuit
 ld     e,(ix+3)
 ld     d,(ix+4)
 inc    ix
 inc    ix
 inc    ix
 ld     (pro1Parent),ix
 pop    hl
 jp     cancelTerms
cancelQuit
 pop    af
 jp     simNum2
cancelMatch:
 pop    hl
 pop    de
 pop    af              

 ld     a,(hl)
 cp     tmul
 jr     nz,skipAFew3
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
skipAFew3:
 ex     de,hl
 ld     a,(hl)
 cp     tmul
 jr     nz,skipAFew4
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
skipAFew4:
 ld     a,(hl)
 cp     tpower
 jr     z,cHasExp
 ex     de,hl
 ld     a,(hl)
 cp     tpower
 jp     z,cHasExp2    ;in these cases do the subtract thingy
 
 call   makeOne
 ld     ix,(pro1Parent)
 ld     (ix),e
 ld     (ix+1),d
 call   makeOne
 ld     ix,(pro2Parent)
 ld     (ix),e
 ld     (ix+1),d

 jp     setmod
cHasExp:
 ld     c,0 
 ex     de,hl
 ld     a,(hl)
 cp     tpower
 jr     z,cHas2Exp
 jr     cHasExp3
cHasExp4:
 push   hl
 call   makeOne
 ld     hl,(pro1Parent)
 jr     cHasExp5
cHasExp2:
 ld     c,1
 ex     de,hl
 ld     a,(hl)
 cp     tpower
 ex     de,hl
 jr     z,cHas2Exp
cHasExp3:           ;if c=0 then (de)=$f0
 ld     a,c
 or     a
 jr     nz,cHasExp4
 push   de
 call   makeOne
 ld     hl,(pro2Parent)
cHasExp5:
 ld     (hl),e
 inc    hl
 ld     (hl),d
 pop    ix
 ld     hl,(freeRam)
 ld     e,(ix+3)
 ld     d,(ix+4)
 ld     (ix+3),l
 ld     (ix+4),h
 ld     (hl),tsub
 inc    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 push   hl
 inc    hl
 inc    hl
 ld     (freeRam),hl
 call   makeOne
 pop    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 jp     setmod
cHas2Exp:
 inc    hl
 inc    hl
 inc    hl
; push   hl              ;1
 ld     c,(hl)
 inc    hl
 ld     b,(hl)
; push   bc              ;2
 ex     de,hl
 inc    hl
 inc    hl
 inc    hl
 ;
 push   hl
 push   bc
 ;
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 push   de              ;3
 call   makeOne
 ld     hl,(pro2Parent)
 ld     (hl),e
 inc    hl
 ld     (hl),d
 pop    de              ;2
 ld     hl,(freeRam)
 push   hl              ;3
 pop    bc              ;2
 ld     (hl),tsub
 inc    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 pop    de              ;1
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 ld     (freeRam),hl
 pop    hl              ;0
 ld     (hl),c
 inc    hl
 ld     (hl),b
 jp     setmod
simNum1:
 ld     a,1
 ret
simNum0:
 ld     a,0
 ret
simNum:
 push   ix
 pop    hl
simNum4:
 B_CALL	mov9toop2
 B_CALL	op1set0
 B_CALL	cpop1op2
 jr     z,simNum0
 B_CALL	op1set1       ;why the hell can't i use _plus1 here?
 B_CALL	cpop1op2
 jr     z,simNum1
simNum2:
 ld     a,255
 ret

;IS THIS ROUTINE REALLY NEEDED?
simNum3:        ;need to convert to positive with neg sign
 xor		a
 ld		(hl),a		;for the longest time, this dumbass author forgot to convert this to a positive number
 ex     de,hl
 ld     hl,(freeRam)
 ld     (hl),0b0h
 push   hl
 inc    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 inc    hl
 ld     (freeRam),hl
 pop    de
 pop    bc
 pop    hl
 push   hl
 push   bc
 ld     (hl),e
 inc    hl
 ld     (hl),d
 jr     simNum2
 

simpOne:
 ld     a,b
 or     a
 jr     z,simpOne2
 dec    ix
 dec    ix
simpOne2:
 dec    ix
 ld     a,(ix)      ;a=operator
 cp     tmul
 jr     z,simp1M
 cp     tdiv
 jr     z,simp1D
 cp     tpower
 jr     z,simp1E
 ret
simp1E:
 call		getfromstack
 ld     a,b
 or     a
 jr     nz,simp1E2
ldixdemod:
 ex		de,hl
; ld     (ix),e
; ld     (ix+1),d
; jr     setMod
simp1E2:
ldixhlmod:
 ld     (ix),l
 ld     (ix+1),h
setMod:
setmod:
 ld     a,254
 ld     (modFlag),a
 ret 
simp1D
 ld     a,b
 or     a
 jr     z,simNum2
simp0A:
simp1M:
ldixhlmod_get:
 call		getfromstack
 jr		ldixhlmod
simpZero:
 ld     a,b
 or     a
 jr     z,simpZero2
 dec    ix
 dec    ix
simpZero2:
 dec    ix
 ld     a,(ix)
 cp     tmul
 jr     z,simp0M
 cp     tdiv
 jr     z,simp0Div
 cp     tadd
 jr     z,simp0A
 cp     tsub
 jr     z,simp0S
 cp     tpower
 jr     z,simp0E
 cp		0b0h
 jr		z,simp0Neg
 ret
simp0E:
 ld     a,b
 or     a
 jr     z,simp0E2
 push   hl
 push   bc
 call		makeOne
 pop    bc
 pop    hl
simp0M:
simp0Neg:
simp0E2:
 call	getfromstack
simp0E3:
 jr		ldixdemod
; ld     (ix),e
; ld     (ix+1),d
; jp		setmod
simp0Div:
 ld     a,b
 or     a
 jp     nz,divZerErr
 jr		simp0M
simp0S:
 ld     a,b
 or     a
 jr     z,simp0S0
 jr		ldixhlmod_get
; call	getfromstack
; ld     (ix),l
; ld     (ix+1),h
; jp		setmod
simp0S0:
 ld     (ix),0b0h
 ld     (ix+1),l
 ld     (ix+2),h
 jr		setmod
getfromstack:
 di
 inc    sp
 inc    sp
 inc    sp
 inc    sp
 inc    sp
 inc    sp
 inc		sp
 inc		sp
 pop    ix
 push   ix
 dec		sp
 dec		sp
 dec    sp
 dec    sp
 dec    sp
 dec    sp
 dec    sp
 dec    sp
 ei
 ret
reduceLn:
 ld     l,(ix)
 ld     h,(ix+1)
 ld     a,(hl)
 cp		1
 jr		nz,reduceLog
 inc		hl
 ld		a,(hl)
 cp		tFakeExp
 jp		nz,simNum2
;really cheap dude... reducing ln(3e)... just don't know how to do this effectively for now
 call		makeOne
 pop		hl
 pop		ix
 push		ix
 push		hl
 ld		(ix),e
 ld		(ix+1),d
 jp		z,simNum2
reduceLog:
 ld     a,(lastFlag)    ;this will need to check the decimal flag
 or     a               ; and will also need to throw and error if neg
 jp     z,simNum2
 ld     l,(ix)
 ld     h,(ix+1)
 ld     a,(hl)
 or     a
 jp     nz,simNum2      ;i'm not sure if i should be converting ln(x^2) to 2*ln(x)
 push   ix
 push   hl
 B_CALL	op1set2
 B_CALL	lnx
 call   OP1ToOP7
 pop    hl
 push   hl
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	op1toop6
 B_CALL	lnx
 bit    decimal,(IY+myFlags)
 jp     nz,decRadical
 call   OP7ToOP2
 B_CALL	fpdiv
 B_CALL	trunc     ;op1 = highest root to check
 call   OP6ToOP7
 call   OP1ToOP8
reduceLnNum2:
 bit		oninterrupt,(iy+onflags)
 jp		nz,breakErr
 call   OP8ToOP1
 call   OP7ToOP2
 B_CALL	xrooty
 xor    a
 ld     (op1+8),a
 B_CALL	ckposint
 jr     z,rootFound
 call   OP8ToOP1
 B_CALL	minus1
 call   OP1ToOP8
 jr     reduceLnNum2
rootFound:
 call   OP7ToOP2
 B_CALL	cpop1op2
 pop    de
 pop    hl
 jp     z,simNum2
 push   hl
 B_CALL	movfrop1
 call   OP8ToOP1
 pop    hl
 dec    hl
 call   insertCoeff
 jp     pull2Top
reduceRad:          ;i'm sure i can find a faster way to do this
;*
 ld     l,(ix)
 ld     h,(ix+1)
 ld		a,(hl)
 or		a
 jp		nz,simNum2
;*
 push   hl
 call   simNum4     ;i think ix is safe
 pop    hl
 push   hl
 pop    bc
 inc    a
 jp     nz,pull2Top
 ld     a,(lastFlag) ;also need to do check of the decimal flag
 or     a           ;needs to throw non real result
 jp     z,simNum2
 ld     a,(hl)
 or     a
 jp     z,reduceRadNum
;needs to check exponents
 jp     simNum2
reduceRadNum:
 push   hl
 push   ix
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	op1toop6
 B_CALL	sqroot
 bit    decimal,(IY+myFlags)
 jr     nz,decRadical
 B_CALL	trunc
 b_call  OP1ToOP5
 B_CALL	fpsquare
 b_call   OP1ToOP4
reduceLoop:
 bit		oninterrupt,(iy+onflags)
 jp		nz,breakErr
 b_call   OP6ToOP1
 b_call   OP4ToOP2
 B_CALL	fpdiv
 B_CALL	ckposint
 jr     z,beenReduced
 b_call   OP5ToOP1
 B_CALL	minus1
 b_call   OP5ToOP2
 b_call   OP1ToOP5
; B_CALL	fpadd
 rst		rfpadd
; call   OP1ToOP2
; call   OP4ToOP1
 ld     a,080h
 ld     (op1),a
 b_call   OP4ToOP2
; B_CALL(_fpSub)
; B_CALL	fpadd
 rst		rfpadd
 b_call   OP1ToOP4
 B_CALL	ckop1pos      ;wont this always be pos? cause once its one then beenReduced will take over
 jr     z,reduceLoop
 pop    hl
 pop    de
 jp     simNum2
beenReduced:
 B_CALL	op6toop2
 B_CALL	cpop1op2
 pop    hl
 pop    de
 jp     z,simNum2
 push   hl
 B_CALL	movfrop1
 B_CALL	op5toop1
 pop    hl
 dec    hl
 call   insertCoeff
 jp     pull2Top
decRadical:
 pop    hl
 pop    de
 push   de
 B_CALL	movfrop1
 pop    de
 pop    bc
 pop    hl
 push   hl
 push   bc
 ld     (hl),e
 inc    hl
 ld     (hl),d
 jp     setMod