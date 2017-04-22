;entry of the sort routines.  decides place to start
;input: ix - top of the (sub)tree
sortTerms:
 call		memAssert
 ld     a,(ix)
 cp     tmul ;*
 jp     z,sortMultLoop
 cp     tadd ;+
 jp     z,sortASLoop
 cp     tdiv
 jp     z,sortOper
 cp     tpower
 jp     z,sortOper
 cp     tsub
 jp     z,sortOper
 call   isOpenParen
 jp     z,sortParen
 ret
sortParen:
 ld     l,(ix+1)
 ld     h,(ix+2)
 push   hl
 pop    ix
 jp     sortTerms
sortOper:
 ld     l,(ix+1)
 ld     h,(ix+2)
 ld     e,(ix+3)
 ld     d,(ix+4)
 push   de
 push   hl
 pop    ix
 call   sortTerms
 pop    ix
 jp     sortTerms
sortMultLoop:
 xor    a
 push   ix
 push   af
 call   sortMult
 pop    af
 pop    ix
 or     a
 jr     nz,sortMultLoop
 ret

sortMult2:
 pop    ix
;input:   ix - top of the (sub)tree
sortMult:
;*
 call		memAssert
;*
 ld     a,(ix)
 cp     tmul
 ret    nz
 push   ix
 inc    ix
 ld     e,(ix)
 inc    ix
 ld     d,(ix)
 inc    ix
 push   ix
 ld     l,(ix)
 inc    ix
 ld     h,(ix)
 pop    bc
 pop    ix
 push   hl
 ld     a,(hl)
 cp     tmul
 jr     nz,sortMultSkipLeft

 inc    hl
 ld     c,(hl)
 push   hl
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
 pop    bc
sortMultSkipLeft:
 push   ix
 push   bc
 push   de
 pop    ix
 push   de
 push   hl
 call   sortTerms
 pop    ix
 push   ix
 call   sortTerms
 pop    hl
 pop    de
 pop    bc
 pop    ix
 ld     a,(hl)
 cp     tpower
 jp     z,sortMultHLExpon
 cp     tadd
 jp     z,sortMultHLAddSub
 cp     tsub
 jp     z,sortMultHLAddSub
 cp     1
 jp     z,sortMultHLVar
 or     a
 jp     z,sortMultHLNum
;must be a function
 ex     de,hl
 ld     a,(hl)
 or     a
 jp     z,sortMult2
 cp     tpower
 jp     z,sortMult2
 call   isOpenParen
; or     a
 jp     nz,sortMultExchange
;functions always come last( neg should surround the entire mult string)
 call		greaterNode_s
 bit    nodeZ,(iy+myFlags)
 jp     nz,sortMult2       
 bit    node1,(iy+myFlags)
 jp     z,sortMult2
 jp     sortMultExchange
sortMultHLExpon:
 ex     de,hl
 ld     a,(hl)
 or     a
 jp     z,sortMult2
 cp     tpower
 jp     nz,sortMultExchange
;need to decide which ^ comes first
 call		greaterNode_s
 bit    nodeZ,(iy+myFlags)
 jp     nz,sortMult2       
 bit    node1,(iy+myFlags)
 jp     z,sortMult2
 jp     sortMultExchange
greaterNode_s:
 push   hl
 push   ix
 push   de
 push   bc
 call   greaterNode
 pop    bc
 pop    de
 pop    ix
 pop    hl
 ret
sortMultHLAddSub:
 ex     de,hl
 ld     a,(hl)
 cp     1
 jp     z,sortMult2
 cp     tadd
 jp     z,sortMultHlAddSub2
 cp     tsub
 jp     nz,sortMult2
sortMultHlAddSub2
;need to decide which comes first
 call   greaterNode_s
 bit    nodeZ,(iy+myFlags)
 jp     nz,sortMult2       
 bit    node1,(iy+myFlags)
 jp     z,sortMult2
 jp     sortMultExchange
 
sortMultHLVar:
 ex     de,hl
 ld     a,(hl)
 or     a
 jp     z,sortMult2    ;numbers should come before variables
 cp     tpower
 jp     z,sortMult2
 call   isOpenParen
; or     a
 jp     z,sortMult2
 ld     a,(hl)
 cp     1
 jp     nz,sortMultExchange
 inc    hl
 inc    de
 ld     a,(hl)
 ex     de,hl
 neg
 add    a,(hl)                ;(hl)=could = 41 through 5b as well as A
 ex     de,hl
 dec    hl
 dec    de
 rl     a
 jr     c,sortMultExchange
 jp     sortMult2
 
sortMultHLNum:
 ex     de,hl
 ld     a,(hl)
 or     a
 jp     nz,sortMultExchange
 jp     sortMult2

sortMultExchange:
 ex     de,hl
 ld     (ix+1),l 
 ld     (ix+2),h
 push   bc
 pop    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 pop    hl
 pop    de
 pop    af
 ld     a,255
 ld     (modFlag),a
 push   af
 push   de
 push   hl
 jp     sortMult2

sortASLoop:
 xor    a
 push   ix
 push   af
 call   sortAS
 pop    af
 pop    ix
 or     a
 jr     nz,sortASLoop
 ret

sortAS2:
 pop    ix
sortAS:
;*
 call		memAssert
;*
 ld     a,(ix)
 cp     tadd
 ret    nz
 push   ix
 inc    ix
 ld     e,(ix)
 inc    ix
 ld     d,(ix)
 inc    ix
 push   ix
 ld     l,(ix)
 inc    ix
 ld     h,(ix)
 pop    bc
 pop    ix
 push   hl
 ld     a,(hl)
 cp     tadd
 jr     nz,sortASSkipLeft
 inc    hl
 ld     c,(hl)
 push   hl
 inc    hl
 ld     b,(hl)
 push   bc
 pop    hl
 pop    bc
sortASSkipLeft:
 push   ix
 push   bc
 push   de
 pop    ix
 push   de
 push   hl
 call   sortTerms
 pop    ix
 push   ix
 call   sortTerms
 pop    hl
 pop    de
 pop    bc
 pop    ix
 ld     a,(hl)
 cp     tpower
 jp     z,sortASHLExpon
 cp     tmul
 jp     z,sortASHLMult
 cp     tdiv
 jp     z,sortASHLDiv
 cp     1
 jp     z,sortASHLVar
 or     a
 jp     z,sortASHLNum
sortASHLFunc:
 ex     de,hl
 ld     a,(hl)
 cp     1
; jp     z,sortAS2
 jp		z,sortASExchange
 or     a
; jp     z,sortAS2
 jp		z,sortASExchange
 call   isOpenParen
; or     a
; jp     nz,sortASExchange
 jp		nz,sortAS2
;need to figure out which funct comes first
; push   hl
; push   ix
; push   de
; push   bc
 call   greaterNode_s
; pop    bc
; pop    de
; pop    ix
; pop    hl
 bit    nodeZ,(iy+myFlags)
 jp     nz,sortAS2       
 bit    node1,(iy+myFlags)
 jp     z,sortAS2
 jp     sortASExchange
sortASHLMult:
sortASHLDiv:
sortASHLExpon:
 ex     de,hl
 ld     a,(hl)
 cp     1
 jp     z,sortASExchange
 or     a
 jp     z,sortASExchange
 call   isOpenParen
; or     a
 jp     z,sortASExchange
;need to figure out which (^,*, or /) comes first
; push   hl
; push   ix
; push   de
; push   bc
 call   greaterNode_s
; pop    bc
; pop    de
; pop    ix
; pop    hl
 bit    nodeZ,(iy+myFlags)
 jp     nz,sortAS2       
 bit    node1,(iy+myFlags)
 jp     z,sortAS2
 jp     sortASExchange
;sortASHLMult:
; ex     de,hl
; ld     a,(hl)
; cp     $f0
; jp     z,sortAS2
; cp     $82
; jp     nz,sortASExchange
;need to figure out which mult comes first
; jp     sortAS2
;sortASHLDiv:
; ex     de,hl
; ld     a,(hl)
; cp     $f0
; jp     z,sortAS2
; cp     $82
; jp     z,sortAS2
; cp     $83
; jp     nz,sortASExchange
;need to figure out which div comes first
; jp     sortAS2
sortASHLVar:
 ex     de,hl
 ld     a,(hl)
 or     a
 jp     z,sortASExchange
 cp     1
 jp     nz,sortAS2
 inc    hl
 inc    de
 ld     a,(hl)
 ex     de,hl
 neg
 add    a,(hl)                ;(hl)=could = 41 through 5b as well as A
 ex     de,hl
 dec    hl
 dec    de
 rl     a
 jp     c,sortASExchange
 jp     sortAS2
sortASHLNum:
;is there anything to be done here?
 jp     sortAS2
sortASExchange:
 ex     de,hl
 ld     (ix+1),l           ;numbers should come before variables
 ld     (ix+2),h
 push   bc
 pop    hl
 ld     (hl),e
 inc    hl
 ld     (hl),d
 pop    hl
 pop    de
 pop    af
 ld     a,255
 ld     (modFlag),a
 push   af
 push   de
 push   hl
 jp     sortAS2
 
;de = 1st node
;hl = 2nd node
greaterNode:
;*
 call		memAssert
;*
 set    nodeZ,(IY+myFlags)      ; if nodeZ = 1 then as far as we know they are equal
 ld     b,(hl)                  ; if nodeZ = 0 and node1 = 0 then node2 is greater
 ex     de,hl                   ; if nodeZ = 0 and node1 = 1 then node1 is greater
 ld     c,(hl)
 ex     de,hl
 ld     a,tsub
 cp     c
 jp     z,greaterNodeSub1
 cp     b
 jp     z,greaterNodeSub2
 ld     a,tadd
 cp     c
 jp     z,greaterNodeAdd1
 cp     b
 jp     z,greaterNodeAdd2
 ld     a,tdiv
 cp     c
 jp     z,greaterNodeSub1       ;as far as i can tell it will act like subtraction
 cp     b
 jp     z,greaterNodeSub2
 ld     a,tmul
 cp     c
 jp     z,greaterNodeMult1
 cp     b
 jp     z,greaterNodeMult2
 ld     a,tpower
 cp     c
 jp     z,greaterNodeExp1
 cp     b
 jp     z,setNode2Greater
 ld     a,c
 call   isOpenParen
; or     a
 jp     z,greaterNodeFunc1
 ld     a,b
 call   isOpenParen
; or     a
 jp     z,setNode1Greater
 ld     a,1
 cp     c
 jp     z,greaterNodeChar1
 cp     b
 jp     z,setNode2Greater

; xor    a
; cp     b
; jp     nz,assert1
; cp     c
; jp     nz,assert1
 
 push     de
 B_CALL	mov9toop2
 pop      hl
; B_CALL	mov9toop1
 rst		rmov9toop1
 B_CALL	cpop1op2
 ret    z
 jp     nc,setNode1Greater
 jp     setNode2Greater
greaterNodeSub1:
 push   de
 push   de                      ;<- 1
 pop    ix
 ld     e,(ix+1)
 ld     d,(ix+2)
 cp     b
 jp     nz,greaterNodeSub1NoSub2
 push   hl
 push   hl                      ;<- 2
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 call   greaterNode
 bit    nodeZ,(IY+myFlags)
 jp     z,greaterNodeSub1Sub2NE
 pop    ix                      
 ld     l,(ix+3)
 ld     h,(ix+4)
 pop    ix
 ld     e,(ix+3)
 ld     d,(ix+4)
 jp     greaterNode             ;i didn't invert theresults like i did in the pseudo
greaterNodeSub1NoSub2:
 pop    af
 call   greaterNode
 bit    nodeZ,(IY+myFlags)
 ret    z
 res    nodeZ,(IY+myFlags)
 res    node1,(IY+myFlags)
 ret
greaterNodeSub2:
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 call   greaterNode
 bit    nodeZ,(IY+myFlags)
 ret    z
 res    nodeZ,(IY+myFlags)
 set    node1,(IY+myFlags)
 ret

greaterNodeAdd1:
 push   de
 push   de                      ;<- 1
 pop    ix
 ld     e,(ix+1)
 ld     d,(ix+2)
 cp     b
 jp     nz,greaterNodeAdd1NoAdd2
 push   hl
 push   hl                      ;<- 2
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 call   greaterNode
 bit    nodeZ,(IY+myFlags)
 jp     z,greaterNodeAdd1Add2NE
 pop    ix                      
 ld     l,(ix+3)
 ld     h,(ix+4)
 pop    ix
 ld     e,(ix+3)
 ld     d,(ix+4)
 jp     greaterNode 
dispose2Stack:
greaterNodeAdd1Add2NE:
greaterNodeExp1_2:
greaterNodeSub1Sub2NE:
 pop    af
 pop    af
 ret
greaterNodeAdd1NoAdd2:
 pop    af
 call   greaterNode
 bit    nodeZ,(IY+myFlags)
 ret    z
setNode1Greater:
 res    nodeZ,(IY+myFlags)
 set    node1,(IY+myFlags)
 ret
greaterNodeAdd2:
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 call   greaterNode
 bit    nodeZ,(IY+myFlags)
 ret    z
setNode2Greater:
 res    nodeZ,(IY+myFlags)
 res    node1,(IY+myFlags)
 ret
greaterNodeExp1:
 cp     b
 jp     nz,setNode1Greater
 push   hl
 push   hl
 pop    ix
 ld     l,(ix+3)
 ld     h,(ix+4)
 push   de
 push   de
 pop    ix
 ld     e,(ix+3)
 ld     d,(ix+4)
 call   greaterNode
 bit    nodeZ,(iy+myFlags)
 jp     z,greaterNodeExp1_2
 pop    ix
 ld     e,(ix+1)
 ld     d,(ix+2)
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 jp     greaterNode
greaterNodeFunc1:
 ld     a,b
 cp     c
 jp     z,greaterNodeFunc1_2
 jp     nc,setNode1Greater
 jp     setNode2Greater
greaterNodeFunc1_2:
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 push   de
 pop    ix
 ld     e,(ix+1)
 ld     d,(ix+2)
 jp     greaterNode
greaterNodeChar1:
 cp     b
 jp     nz,setNode1Greater
 inc    hl
 inc    de
 ld     a,(hl)
 ex     de,hl
 neg
 add    a,(hl)                ;(hl)=could = 41 through 5b as well as A
 scf
 ccf
 rl     a
 jp     c,setNode1Greater
 or     a
 jp     nz,setNode2Greater
 ret
greaterNodeMult1:
 cp     b
 jp     z,greaterNodeMult1Mult2
 push   de
 pop    ix
 ld     e,(ix+1)
 ld     d,(ix+2)
 ex     de,hl
 ld     a,(hl)
 ex     de,hl
 or     a
 jp     nz,greaterNodeMult1NoNumNoMult2
 ld     e,(ix+3)
 ld     d,(ix+4)
greaterNodeMult1NoNumNoMult2:
 call   greaterNode
 bit    nodeZ,(iy+myFlags)
 ret    z
 jp     setNode1Greater
greaterNodeMult1Mult2:
 push   de
 push   de
 pop    ix
 ld     e,(ix+1)
 ld     d,(ix+2)
 ex     de,hl
 ld     a,(hl)
 ex     de,hl
 or     a
 jp     nz,greaterNodeMult1NoNumMult2
 push   de
 ld     e,(ix+3)
 ld     d,(ix+4)
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 ld     a,(hl)
 or     a
 jp     nz,greaterNodeMult1NumMult2NoNum
 push   hl
 ld     l,(ix+3)
 ld     h,(ix+4)
 call   greaterNode
 pop    hl
 pop    de
 pop    af
 bit    nodeZ,(iy+myFlags)
 ret    z
 jp     greaterNode
greaterNodeMult1NumMult2NoNum:
 call   greaterNode
; pop    de
 pop    af
 pop    af
 bit    nodeZ,(iy+myFlags)
 ret    z
; jp     greaterNode
 jp     setNode1Greater
greaterNodeMult1NoNumMult2:
 push   hl
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 ld     a,(hl)
 or     a
 jp     nz,greaterNodeMult1NoNumMult2NoNum
; push   hl
 ld     l,(ix+3)
 ld     h,(ix+4)
 call   greaterNode
; pop    hl
 pop	  af	;added 8/12/01
 pop    af
 bit    nodeZ,(iy+myFlags)
 ret    z
; jp     greaterNode
 jp     setNode2Greater
greaterNodeMult1NoNumMult2NoNum:
 call   greaterNode
 bit    nodeZ,(iy+myFlags)
 jp     z,dispose2Stack
 pop    ix
 ld     l,(ix+3)
 ld     h,(ix+4)
 pop    ix
 ld     e,(ix+3)
 ld     d,(ix+4)
 jp     greaterNode
 
greaterNodeMult2:
 push   hl
 pop    ix
 ld     l,(ix+1)
 ld     h,(ix+2)
 ld     a,(hl)
 or     a
 jp     nz,greaterNodeMult2NoNum
 ld     l,(ix+3)
 ld     h,(ix+4)
greaterNodeMult2NoNum:
 call   greaterNode
 bit    nodeZ,(iy+myFlags)
 ret    z
 jp     setNode2Greater
 ret