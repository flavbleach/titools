diffabs:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		hl,(freeRam)
 push		hl
 push		hl
 pop		ix
 ld		(ix),tmul
 ld		(ix+5),tsign
 ld		bc,5
 add		hl,bc
 ld		(ix+1),l
 ld		(ix+2),h
 inc		hl
 inc		hl
 inc		hl
 ld		(freeRam),hl
 jp		pushdeixcopyde67pophldiffsav34
; push		de
; push		ix
; call		copySub
; pop		ix
; ld		(ix+6),e
; ld		(ix+7),d
; pop		hl
; push		ix
; call		differentiate
; pop		ix
; ld		(ix+3),l
; ld		(ix+4),h
; pop		hl
; ret

diffcoti:
 call		diffcothi
 jp		negateTree
diffcothi:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		hl,(freeRam)
 push		hl
 push		hl
 pop		ix
 ld		(ix),tdiv
 cp		tcoti
 jr		nz,diffcoti2
 ld		(ix+5),tadd
 jr		diffcoti3
diffcoti2:
 ld		(ix+5),tsub
diffcoti3:
 ld		(ix+10),tpower
 ld		bc,5
 add		hl,bc
 ld		(ix+3),l
 ld		(ix+4),h
 add		hl,bc
 ld		(ix+8),l
 ld		(ix+9),h
 add		hl,bc
 ld		(freeRam),hl
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+11),e
 ld		(ix+12),d
 pop		hl
 push		ix
 call		differentiate
 pop		ix
 ld		(ix+1),l
 ld		(ix+2),h 
 call		makeTwo
 ld		(ix+13),e
 ld		(ix+14),d
 call		makeOne
 ld		(ix+6),e
 ld		(ix+7),d
 pop		hl
 ret

diffsechi:
 call		diffseci
 ld		e,(ix+14)
 ld		d,(ix+16)
 ld		(ix+14),d
 ld		(ix+16),e
 ld		e,(ix+15)
 ld		d,(ix+17)
 ld		(ix+15),d
 ld		(ix+17),e
negateTree:
 ex		de,hl
 ld		hl,(freeRam)
 push		hl
 ld		(hl),0B0h
 inc		hl
 ld		(hl),e
 inc		hl
 ld		(hl),d
 inc		hl
 ld		(freeRam),hl
 pop		hl
 ret
diffseci:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		hl,(freeRam)
 push		hl
 push		hl
 pop		ix
 ld		(ix),tdiv
 ld		(ix+5),tmul
 ld		(ix+10),tsqrt
 ld		(ix+13),tsub
 ld		(ix+18),tpower
 ld		bc,5
 add		hl,bc
 ld		(ix+3),l
 ld		(ix+4),h
 add		hl,bc
 ld		(ix+8),l
 ld		(ix+9),h
 inc		hl
 inc		hl
 inc		hl
 ld		(ix+11),l
 ld		(ix+12),h
 add		hl,bc
 ld		(ix+14),l
 ld		(ix+15),h
 add		hl,bc
 ld		(freeRam),hl
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+19),e
 ld		(ix+20),d
 pop		de
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+6),e
 ld		(ix+7),d
 pop		hl
 push		ix
 call		differentiate
 pop		ix
 ld		(ix+1),l
 ld		(ix+2),h
 call		makeOne
 ld		(ix+16),e
 ld		(ix+17),d
 call		makeTwo
 ld		(ix+21),e
 ld		(ix+22),d
 pop		hl
 ret
diffcschi:
 call		diffcsci
 push		hl
 ld		hl,(freeRam)
 ld		a,(ix+9)
 ld		(ix+9),l
 ld		b,(ix+10)
 ld		(ix+10),h
 ld		(hl),tabs
 inc		hl
 ld		(hl),a
 inc		hl
 ld		(hl),b
 inc		hl
 ld		(freeRam),hl
 pop		hl
 ret

diffcsci:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		hl,(freeRam)
 push		hl
 push		hl
 pop		ix
 ld		(ix),0B0h
 ld		(ix+3),tdiv
 ld		(ix+8),tmul
 ld		(ix+13),tsqrt
 cp		tcsci
 jr		z,diffcsci2
 ld		(ix+16),tadd
 jr		diffcsci3
diffcsci2:
 ld		(ix+16),tsub
diffcsci3:
 ld		(ix+21),tpower
 inc		hl
 inc		hl
 inc		hl
 ld		(ix+1),l
 ld		(ix+2),h
 ld		bc,5
 add		hl,bc
 ld		(ix+6),l
 ld		(ix+7),h
 add		hl,bc
 ld		(ix+11),l
 ld		(ix+12),h
 inc		hl
 inc		hl
 inc		hl
 ld		(ix+14),l
 ld		(ix+15),h
 add		hl,bc
 ld		(ix+17),l
 ld		(ix+18),h
 add		hl,bc
 ld		(freeRam),hl
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+22),e
 ld		(ix+23),d
 pop		de
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+9),e
 ld		(ix+10),d
 pop		hl
 push		ix
 call		differentiate
 pop		ix
 ld		(ix+4),l
 ld		(ix+5),h
 call		makeTwo
 ld		(ix+24),e
 ld		(ix+25),d
 call		makeOne
 ld		(ix+19),e
 ld		(ix+20),d
 pop		hl
 ret

diffcoth:
diffcot:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		hl,(freeRam)
 push		hl
 push		de
 push		hl
 pop		ix
 ld		(ix),0B0h
 ld		(ix+3),tmul
 ld		(ix+8),tpower
 sub		4
 ld		(ix+13),a
 inc		hl
 inc		hl
 inc		hl
 ld		(ix+1),l
 ld		(ix+2),h
 ld		bc,5
 add		hl,bc
 ld		(ix+6),l
 ld		(ix+7),h
 add		hl,bc
 ld		(ix+9),l
 ld		(ix+10),h
 inc		hl
 inc		hl
 inc		hl
 ld		(freeRam),hl
 call		makeTwo
 ld		(ix+11),e
 ld		(ix+12),d
 pop		de
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+14),e
 ld		(ix+15),d
 pop		hl
 push		ix
 call		differentiate
 pop		ix
 ld		(ix+4),l
 ld		(ix+5),h
 pop		hl
 ret
 

diffsech:
 call		diffsec
 jp		negateTree
; ex		de,hl
; ld		hl,(freeRam)
; push		hl
; ld		(hl),0B0h
; inc		hl
; ld		(hl),e
; inc		hl
; ld		(hl),d
; inc		hl
; ld		(freeRam),hl
; pop		hl
; ret

diffsec:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		hl,(freeRam)
 push		hl
 push		hl
 pop		ix
 ld		(ix),tmul
 ld		(ix+5),tmul
 ld		(ix+10),a
 sub		11
 ld		(ix+13),a
 ld		bc,5
 add		hl,bc
 ld		(ix+3),l
 ld		(ix+4),h
 add		hl,bc
 ld		(ix+6),l
 ld		(ix+7),h
 inc		hl
 inc		hl
 inc		hl
 ld		(ix+8),l
 ld		(ix+9),h
 inc		hl
 inc		hl
 inc		hl
 ld		(freeRam),hl
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+11),e
 ld		(ix+12),d
 pop		de
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+14),e
 ld		(ix+15),d
 pop		hl
 jp		pushixdiffsave12ret
; push		ix
; call		differentiate
; pop		ix
; ld		(ix+1),l
; ld		(ix+2),h
; pop		hl
; ret
diffcsch:
diffcsc:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		hl,(freeRam)
 push		hl
 push		de
 push		hl
 pop		ix
 ld		(ix),0B0h
 ld		de,3
 add		hl,de
 ld		(ix+1),l
 ld		(ix+2),h
 ld		bc,5
 add		hl,bc
 ld		(ix+3),tmul
 ld		(ix+6),l
 ld		(ix+7),h
 add		hl,bc
 ld		(ix+8),tmul
 ld		(ix+9),l
 ld		(ix+10),h
 add		hl,de
 ld		(ix+11),l
 ld		(ix+12),h
 ld		(ix+13),a
 add		a,4
 ld		(ix+16),a
 add		hl,de
 ld		(freeRam),hl
 pop		de
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+14),e
 ld		(ix+15),d
 pop		de
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+17),e
 ld		(ix+18),d
 pop		hl
 push		ix
 call		differentiate
 pop		ix
 ld		(ix+4),l
 ld		(ix+5),h
 pop		hl
 ret
difflog:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ld		hl,(freeRam)
 push		hl
 push		de
 push		hl
 pop		ix
 ld		(ix),tdiv
 ld		(ix+5),tmul
 ld		(ix+10),tln
 ld		bc,5
 add		hl,bc
 ld		(ix+3),l
 ld		(ix+4),h
 add		hl,bc
 ld		(ix+8),l
 ld		(ix+9),h
 inc		hl
 inc		hl
 inc		hl
 ld		(freeRam),hl
 pop		de
 push		de
 push		ix
 call		copySub
 pop		ix
 ld		(ix+6),e
 ld		(ix+7),d
 pop		hl
 push		ix
 call		differentiate
 pop		ix
 ld		(ix+1),l
 ld		(ix+2),h
 call		makeOne
 ex		de,hl
 ld		(ix+11),l
 ld		(ix+12),h
 inc		hl
 inc		(hl)
 pop		hl
 ret
;comment these out soon
;diffcbrt:
; push       hl
; pop        de
; ld     hl,(freeRam)
; push       hl
; push       de
; push       hl
; pop        ix
; ld     (ix),tdiv
; ld     (ix+5),tmul
; ld     (ix+10),tpower
; ld     bc,5
; add        hl,bc
; ld     (ix+3),l
; ld     (ix+4),h
; add        hl,bc
; ld     (ix+8),l
; ld     (ix+9),h
; add        hl,bc
; ld     (freeRam),hl
;makeThree:
;;*
; call		memAssert
;;*
; ld     de,(freeRam)
; push   de
; ld		hl,aThree
; ld     bc,9
; ldir
; ld     (freeRam),de
; pop    de
;
; ld     (ix+6),e
; ld     (ix+7),d
; call       makeTwo
; ld     (ix+13),e
; ld     (ix+14),d
; pop        de
; push       de
; push       ix
; call       copySub
; pop        ix
; ld     (ix+11),e
; ld     (ix+12),d

;more these to reduce need to a call instruction - optimizable
pophldiffsubix12ret:
 pop        hl
 inc        hl
 ld     a,(hl)
 inc        hl
 ld     h,(hl)
 ld     l,a
pushixdiffsave12ret:
 push       ix
 call       differentiate
 pop        ix
 ld     (ix+1),l
 ld     (ix+2),h
 pop        hl
 ret

diffsqrt:
 push       hl
 pop        de
 ld     hl,(freeRam)
 push       hl
 push       de
 push       hl
 pop        ix
 ld     (ix),tdiv
 ld     (ix+5),tmul
 ld     bc,5
 add        hl,bc
 ld     (ix+3),l
 ld     (ix+4),h
 add        hl,bc
 ld     (freeRam),hl
 call       makeTwo
 ld     (ix+6),e
 ld     (ix+7),d
 pop        de
 push       de
 push       ix
 call       copySub
 pop        ix
 ld     (ix+8),e
 ld     (ix+9),d
 jp		pophldiffsubix12ret
; pop        hl
; inc        hl
; ld     a,(hl)
; inc        hl
; ld     h,(hl)
; ld     l,a
; push       ix
; call       differentiate
; pop        ix
; ld     (ix+1),l
; ld     (ix+2),h
; pop        hl
; ret

diffcoshi:
diffsinhi:
 inc        hl
 ld     e,(hl)
 inc        hl
 ld     d,(hl)
 ld     hl,(freeRam)
 push       hl
 push       de
 push       hl
 pop        ix
 ld     (ix),tdiv
 ld     (ix+5),tadd
 cp     tasinh
 jr     z,diffsinhi2
 ld     (ix+5),tsub
diffsinhi2:
 ld     (ix+10),tpower
 ld     (ix+15),tsqrt
 ld     bc,5
 add        hl,bc
 ld     (ix+16),l
 ld     (ix+17),h
 add        hl,bc
 ld     (ix+6),l
 ld     (ix+7),h
 add        hl,bc
 ld     (ix+3),l
 ld     (ix+4),h
 inc        hl
 inc        hl
 inc        hl
 ld     (freeRam),hl
 call       makeOne
 ld     (ix+8),e
 ld     (ix+9),d
 call       makeTwo
 ld     (ix+13),e
 ld     (ix+14),d
 jp		copydiffandsaveix12
; pop        de
; push       de
; push       ix
; call       copySub
; pop        ix
; ld     (ix+11),e
; ld     (ix+12),d
; pop        hl
; push       ix
; call       differentiate
; pop        ix
; ld     (ix+1),l
; ld     (ix+2),h
; pop        hl
; ret

difftanhi:
difftani:
 inc        hl
 ld     e,(hl)
 inc        hl
 ld     d,(hl)
 ld     hl,(freeRam)
 push       hl
 push       de
 push       hl
 pop        ix
 ld     (ix),tdiv
 ld     (ix+5),tadd
 cp     tatan
 jr     z,difftani2
 ld     (ix+5),tsub
difftani2:
 ld     (ix+10),tpower
 ld     bc,5
 add        hl,bc
 ld     (ix+3),l
 ld     (ix+4),h
 add        hl,bc
 ld     (ix+8),l
 ld     (ix+9),h
 add        hl,bc
 ld     (freeRam),hl
 call       makeTwo
 ld     (ix+13),e
 ld     (ix+14),d
 call       makeOne
 ld     (ix+6),e
 ld     (ix+7),d
 jp		copydiffandsaveix12
; pop        de
; push       de
; push       ix
; call       copySub
; pop        ix
; ld     (ix+11),e
; ld     (ix+12),d
; pop    hl
; push   ix
; call   differentiate
; pop    ix
; ld     (ix+1),l
; ld     (ix+2),h
; pop    hl
; ret
diffcosi:
 push       hl
 ld     hl,(freeRam)
 push       hl
 ld     (hl),0b0h
 inc        hl
 ld     e,l
 ld     d,h
 inc        de
 inc        de
 ld     (hl),e
 inc        hl
 ld     (hl),d
 ld     (freeRam),de
 pop        bc
 pop        hl
 push       bc
 inc        hl
 ld     e,(hl)
 inc        hl
 ld     d,(hl)
 ld     hl,(freeRam)
 jr     diffsini2
diffsini:
 inc        hl
 ld     e,(hl)
 inc        hl
 ld     d,(hl)
 ld     hl,(freeRam)
 push       hl
diffsini2:
 push       de
 push       hl
 pop        ix
 ld     (ix),tdiv
 ld     (ix+15),tsqrt
 ld     (ix+5),tsub
 ld     (ix+10),tpower
 ld     bc,5
 add        hl,bc
 ld     (ix+16),l
 ld     (ix+17),h
 add        hl,bc
 ld     (ix+8),l
 ld     (ix+9),h
 add        hl,bc
 ld     (ix+3),l
 ld     (ix+4),h
 inc        hl
 inc        hl
 inc        hl
 ld     (freeRam),hl
 call       makeOne
 ld     (ix+6),e
 ld     (ix+7),d
 pop        de
 push       de
 push       ix
 call       copySub
 pop        ix
 ld     (ix+11),e
 ld     (ix+12),d
 pop        hl
 push       ix
 call       differentiate
 pop        ix
 ld     (ix+1),l
 ld     (ix+2),h
 call       makeTwo
 ld     (ix+13),e
 ld     (ix+14),d
 pop        hl
 ret
 
diffDiv:
 push       hl      ;1
 ld     hl,(freeRam)
 push       hl      ;2
 push       hl      ;3
 pop        ix      ;-1
 ld     bc,5
 add        hl,bc
 ld     (ix),tdiv
 ld     (ix+5),tpower
 ld     (ix+10),tsub
 ld     (ix+15),tmul
 ld     (ix+20),tmul
 ld     (ix+3),l
 ld     (ix+4),h
 add        hl,bc
 ld     (ix+1),l
 ld     (ix+2),h
 add        hl,bc
 ld     (ix+13),l
 ld     (ix+14),h
 add        hl,bc
 ld     (ix+11),l
 ld     (ix+12),h
 add        hl,bc
 ld     (freeRam),hl
 ld		(ix+8),l
 ld		(ix+9),h
 call		makeTwo
 pop        de      ;-2
 pop        hl      ;-3
 push       de      ;4
 inc        hl
 ld     e,(hl)
 inc        hl
 ld     d,(hl)
 inc        hl
 push       hl      ;5
 push       de      ;11
 push       ix      ;12
 call       copySub
 pop        ix      ;-10
 ld     (ix+16),e
 ld     (ix+17),d
 pop        hl      ;-11
 push       ix      ;13
 call       differentiate
 pop        ix      ;-12
 ld     (ix+21),l
 ld     (ix+22),h
 pop        hl      ;-9
 ld     e,(hl)
 inc        hl
 ld     d,(hl)
 push       de      ;6
 push       ix      ;7
 call       copySub
 pop        ix      ;-4
 ld     (ix+6),e
 ld     (ix+7),d
 pop        de      ;-5
 push       de      ;8
 push       ix      ;9
 call       copySub
 pop        ix      ;-6
 ld     (ix+23),e
 ld     (ix+24),d
pophldiffsav1819:
 pop        hl      ;-7
 push       ix      ;10
 call       differentiate
 pop        ix      ;-8
 ex     de,hl
 ld     (ix+18),e
 ld     (ix+19),d
 pop        hl      ;-14
 ret

diffMult:
 push   hl
 ld hl,(freeRam)
 push   hl
 push   hl
 pop    ix
 ld bc,5
 add    hl,bc
 ld (ix),tadd
 ld (ix+5),tmul
 ld (ix+1),l
 ld (ix+2),h
 add    hl,bc
 ld (ix+10),tmul
 ld (ix+3),l
 ld (ix+4),h
 add    hl,bc
 ld (freeRam),hl
 pop    de
 pop    hl
 push   de
 inc    hl
 ld e,(hl)
 inc    hl
 ld d,(hl)
 inc    hl
 push   hl
 push   de
 push   ix
 call   copySub
 pop    ix
 ld (ix+6),e
 ld (ix+7),d
 pop    hl
 push   ix
 call   differentiate
 pop    ix
 ex de,hl
 ld (ix+11),e
 ld (ix+12),d
 pop    hl      ;loc of loc of other node being multiplied
 ld e,(hl)
 inc    hl
 ld d,(hl)
 push   de
 push   ix
 call   copySub
 pop    ix
 ld (ix+13),e
 ld (ix+14),d
 pop    hl
 push   ix
 call   differentiate
 pop    ix
 ex de,hl
 ld (ix+8),e
 ld (ix+9),d
 pop    hl
 ret
diffExpo:               ;a^b
 ex de,hl
 ld     hl,(freeRam)
 push   hl
 push   hl
 pop    ix
 ld     (ix),tmul
 ld     bc,5
 add    hl,bc       ;hl=+5
 ld     (ix+3),l
 ld     (ix+4),h
 ld     (ix+5),tpower
 add    hl,bc       ;hl=+10
 ld     (ix+1),l
 ld     (ix+2),h
 ld     (ix+10),tadd
 add    hl,bc       ;hl=+15
 ld     (ix+11),l
 ld     (ix+12),h
 ld     (ix+15),tmul
 add    hl,bc       ;hl=+20
 ld     (ix+20),tln
 ld     (ix+16),l
 ld     (ix+17),h
 ld     bc,3
 add    hl,bc       ;hl=+23
 ld     (ix+23),tmul
 ld     (ix+13),l
 ld     (ix+14),h
 ld     bc,5
 add    hl,bc       ;hl=+28
 ld     (ix+28),tdiv
 ld     (ix+24),l
 ld     (ix+25),h
 add    hl,bc       ;hl=+33
 ld     (freeRam),hl
 ex     de,hl
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 inc    hl          ;de = loc of b
 push   hl          ;save loc of the ^ + [3]
 push   de
 push   ix
 call   copySub
 pop    ix
 ld     (ix+6),e
 ld     (ix+7),d
 pop    de
 push   de
 push   ix
 call   copySub
 pop    ix
 ld     (ix+21),e
 ld     (ix+22),d
 pop    de
 push   de
 push   ix
 call   copySub
 pop    ix
 ld     (ix+31),e
 ld     (ix+32),d
 pop    hl
 push   ix
 call   differentiate
 pop    ix
 ld     (ix+26),l
 ld     (ix+27),h
 pop    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 push   de
 push   ix
 call   copySub
 pop    ix
 ld     (ix+8),e
 ld     (ix+9),d
 pop    de
 push   de
 push   ix
 call   copySub
 pop    ix
 ld     (ix+29),e
 ld     (ix+30),d
 jp		pophldiffsav1819
; pop    hl
; push   ix
; call   differentiate
; pop    ix
; ld     (ix+18),l
; ld     (ix+19),h  
; pop    hl
; ret

diffCosh:
 sub    4
 jr     diffSin
diffCos:
 ex de,hl
 ld hl,(freeRam)
 ld (hl),0b0h
 push   hl
 inc    hl
 push   hl
 pop    ix
 inc    hl
 inc    hl
 ld     (ix),l
 ld     (ix+1),h
 sub    4
 jr     diffTrig
diffSin:
 ex de,hl
 ld hl,(freeRam)
 push   hl
diffTrig:
 push   hl
 pop    ix
 ld (ix),tmul
 add    a,2
 ld (ix+5),a
 ld bc,5
 add    hl,bc
 ld (ix+1),l
 ld (ix+2),h
 inc    hl
 inc    hl
 inc    hl
 ld (freeRam),hl
 ex de,hl
 inc    hl
 ld e,(hl)
 inc    hl
 ld d,(hl)
pushdeixcopyde67pophldiffsav34:
 push   de
 push   ix
 call   copySub
 pop    ix
 ld (ix+6),e
 ld (ix+7),d
 pop    hl
 push   ix
 call   differentiate
 pop    ix
 ld (ix+3),l
 ld (ix+4),h
 pop    hl
 ret
diffTan:
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ld     hl,(freeRam)
 push   hl
 push   de
 push   hl
 pop    ix
 ld     bc,5
 add    hl,bc
 ld     (ix+3),l
 ld     (ix+4),h
 add    hl,bc
 ld     (ix+6),l
 ld     (ix+7),h
 ld     bc,3
 add    hl,bc
 ld     (ix+8),l
 ld     (ix+9),h
 ld		(freeRam),hl
 call		makeTwo
 ld     (ix),tdiv
 ld     (ix+5),tpower
 sub    2
 ld     (ix+10),a       ;tan or tanh -> cos or cosh
copydiffandsaveix12:
 pop    de
 push   de
 push   ix
 call   copySub
 pop    ix
 ld     (ix+11),e
 ld     (ix+12),d
 jr		diffandsaveix12
; pop    hl
; push   ix
; call   differentiate
; pop    ix
; ld     (ix+1),l
; ld     (ix+2),h
; pop    hl
; ret
 
diffLn:
 inc    hl
 ld     e,(hl)
 inc    hl
 ld     d,(hl)
 ld     hl,(freeRam)
 push   hl
 push   hl
 pop    ix
 ld     bc,5
 add    hl,bc
 ld     (freeRam),hl
 ld     (ix),tdiv
 push   de
 push   ix
 call   copySub
 pop    ix
 ld     (ix+3),e
 ld     (ix+4),d
diffandsaveix12:
 pop    hl
 push   ix
 call   differentiate
 pop    ix
 ld     (ix+1),l
 ld     (ix+2),h
 pop    hl
 ret

differentiate:
;*
 call	memAssert
;*
 ld a,(hl)
 cp tsin         ;sin
 jp z,diffSin
 cp tsinh         ;sinh
 jp z,diffSin
 cp tcos
 jp z,diffCos
 cp tcoshh
 jp z,diffCosh
 cp tln
 jr z,diffLn
 cp ttan
 jp z,diffTan
 cp ttanh
 jp z,diffTan
 cp tadd
 jp z,diffPlus
 cp tsub
 jp z,diffPlus
 or a
 jp z,diffZero
 cp 01h
 jp z,diffVar
 cp tmul
 jp z,diffMult
 cp tdiv
 jp z,diffDiv
 cp tpower
 jp z,diffExpo
 cp 0b0h
 jp z,diffneg
 cp tasin
 jp z,diffsini
 cp tacos
 jp z,diffcosi
 cp tatan
 jp z,difftani
 cp tasinh
 jp z,diffsinhi
 cp tacosh
 jp z,diffcoshi
 cp tatanh
 jp z,difftanhi
 cp tsqrt
 jp z,diffsqrt

; cuberoots are converted to "3[xroot](" in demess now 
; cp tcubrt
; jp z,diffcbrt

 cp tlog
 jp z,difflog

 cp tcsc
 jp z,diffcsc
 cp tcsch
 jp z,diffcsch

 cp tsec
 jp z,diffsec
 cp tsech
 jp z,diffsech
 cp tcot
 jp z,diffcot
 cp tcoth
 jp z,diffcoth

 cp tcsci
 jp z,diffcsci
 cp tcschi
 jp z,diffcschi

 cp tseci
 jp z,diffseci
 cp tsechi
 jp z,diffsechi

 cp tcoti
 jp z,diffcoti
 cp tcothi
 jp z,diffcothi
 cp tabs
 jp z,diffabs
 jp syntaxErr

diffneg:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 call		differentiate
 jp		negateTree
; ld		hl,(freeRam)
; ld		(hl),a
; inc		hl
; inc		hl
; push		hl
; inc		hl
; ld		(freeRam),hl
; ex		de,hl
; call		differentiate
; ex		de,hl
; pop		hl
; ld		(hl),d
; dec		hl
; ld		(hl),e
; dec		hl
; ret

diffPlus:
 inc		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		hl
 push		hl
 ex		de,hl
 push		af
 call		differentiate
 pop		af
 ex		de,hl
 ld		hl,(freeRam)
 ld		(hl),a
 inc		hl
 ld		(hl),e
 inc		hl
 ld		(hl),d
 inc		hl
 pop		de
 inc		hl
 push		hl
 inc		hl
 ld		(freeRam),hl
 ex		de,hl
 ld		(hl),e
 inc		hl
 ld		(hl),d
 inc		hl
 call		differentiate
 ex		de,hl
 pop		hl
 ld		(hl),d
 dec		hl
 ld		(hl),e
 dec		hl
 dec		hl
 dec		hl
 ret
; ex		de,hl
; ld		hl,(freeRam)
; ld		(hl),a
; push   hl  ;loc of this subtree
; inc    hl
; push   hl
; pop    ix  ;ix=place to store the children
; inc    hl
; inc    hl
; inc    hl
; inc    hl
; ld (freeRam),hl
; ex de,hl
; inc    hl
; ld e,(hl)
; inc    hl
; ld d,(hl)
; inc    hl
; ex de,hl
; push   de
; push   ix
; call   differentiate
; ex de,hl
; pop    hl
; ld (hl),e
; inc    hl
; ld (hl),d
; inc    hl
; ex de,hl
; pop    hl
; push   de
; ld e,(hl)
; inc    hl
; ld d,(hl)
; ex de,hl
; call   differentiate
; ex de,hl
; pop    hl
; ld (hl),e
; inc    hl
; ld (hl),d
; pop    hl
; ret
diffOne:
 call	makeOne
 ex	de,hl
 ret
diffVar:
 inc    hl
 ld		a,(respect2)
 cp		(hl)
 jr     z,diffOne
diffZero:
 call	makeZero
 ex	de,hl
 ret