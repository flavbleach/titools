;perhaps divflag could be only zeroed once?

;the order of operations you never learned in school... pe(xroot)dmsa

;input: 
;   hl = start of expression
;   b  = length of expression
;   (freeRam) = place to put new node
;output:
;   hl = location of node created
;   (freeRam) is updated

parse:
;*
 call		memAssert
;*
 ld		a,b
 or		c
 jp		z,syntaxErr		;if for some reason a substring is 0 in length due to either "2+" or "2++3", an error is thrown
 push   hl  ;save these for when we call the next parse
 push   bc
parse2:     ;need to add parse for = sign
 ld		a,(hl)
 inc		hl
 cp		tadd
 jp		z,subString
 call   isOpenParen
 call   z,findEONest
 dec    bc
 ld		a,b
 or		c
 jr		nz,parse2
parse_as_Done:
 pop    bc
 pop    hl
 push   hl
 push   bc
 xor    a
 ld (divFlag),a
parseS:
 ld a,(hl)
 inc    hl
 cp tsub
; jp    z,subString ;need to do a reverse search for '-' here
 jr nz,parseS2
 ld (tempHL),hl
 ld (tempBC),bc
 ld (divFlag),a
parseS2:    
 call   isOpenParen
; or a
 call   z,findEONest
 dec    bc
 ld		a,b
 or		c
 jr nz,parseS
 ld a,(divFlag)
 or a
 jr z,parseS_done
 ld hl,(tempHL)
 ld bc,(tempBC)
 jp subString
parseS_done:
 pop    bc
 pop    hl
 push   hl
 push   bc
parseN:
 ld a,(hl)
 cp 0b0h
 jr nz,parseNO
 push   hl
 ld hl,(freeRam)
 ld (hl),a
 inc    hl
 inc    hl
 inc    hl
 ld (freeRam),hl
 dec    hl
 ex de,hl
 pop    hl
 inc    hl
 push   de
 dec    bc
 call   parse
 ex de,hl
 pop    hl
 ld (hl),d
 dec    hl
 ld (hl),e
 dec    hl
 pop    af
 pop    af
 ret
parseNO:
 pop    bc
 pop    hl
 push   hl
 push   bc
parsem:
 ld a,(hl)
 inc    hl
 cp tmul ;'*'
 jp z,subString
 call   isOpenParen
; or a
 call   z,findEONest
 dec    bc
 ld		a,b
 or		c
 jr nz,parsem
 pop    bc
 pop    hl
 push   hl
 push   bc
 xor    a
 ld (divFlag),a
parsed:
 ld a,(hl)
 inc    hl
 cp tdiv ;'/'
; jp    z,subString ;need to do a reverse search for '/' here
 jr nz,parsed2
 ld (tempHL),hl
 ld (tempBC),bc
 ld (divFlag),a
parsed2:    
 call   isOpenParen
; or a
 call   z,findEONest
 dec    bc
 ld		a,b
 or		c
 jr nz,parsed
 ld a,(divFlag)
 or a
 jr z,parsed3
 ld hl,(tempHL)
 ld bc,(tempBC)
 jp subString
parsed3:
 pop    bc
 pop    hl
 push   hl
 push   bc
parseXRoot:
 ld		a,(hl)
 inc		hl
 cp		txroot
 jp		z,subString2
 call		isOpenParen
 call		z,findEONest
 dec		bc
 ld		a,b
 or		c
 jr		nz,parseXRoot
 pop		bc
 pop		hl
 push		hl
 push		bc
 xor    a
 ld (divFlag),a
parseE:
 ld a,(hl)
 inc    hl
 cp tpower ;'*'
 jr nz,parseE2
 ld (tempHL),hl
 ld (tempBC),bc
 ld (divFlag),a
parseE2:
 call   isOpenParen
 call   z,findEONest
 dec    bc
 ld		a,b
 or		c
 jr nz,parseE
 ld a,(divFlag)
 or a
 jr z,parseE_done
 ld hl,(tempHL)
 ld bc,(tempBC)
 jp subString
parseE_done:
 pop    bc
 pop    hl
 push   hl
 push   bc
parseP:
 ld a,(hl)
; ld c,a
 inc    hl
 cp tlparen ;'('
 jr nz,parseP2
 dec    bc
 dec    bc
 pop    af
 pop    af 
 jp     parse

parseP2:
 call		isOpenParen
 jr		nz,NOpen
 dec		hl
 ld		a,(hl)
 inc		hl
 dec		bc
 dec		bc
 cp		talog
 jr		z,ten2Power
 push		hl      ;save current location in string
 ld		hl,(freeRam)
 ld		(hl),a
 inc		hl      
 push		hl      ;save location for 1st pointer in node
 ld		de,2
 add		hl,de
 ld		(freeRam),hl
 pop		de      ;recall location for 1st pointer in node
 pop		hl      ;recall location within string
 push		de      ;save location in node
 push		bc      ;save length of string after this + or -
 call		parse       ;parse second half of string
 pop		bc      ;recall length of string after the + or -
 pop		de      ;recall location in node
 ex		de,hl       ;de=location of sub tree; hl=location in node
 ld		(hl),e
 inc		hl
 ld		(hl),d
 ld		de,-2       ;we're making this node 3 bytes
 add		hl,de
 pop		af
 pop		af
 ret
NOpen:
 pop    bc
 pop    hl
 push   hl
 push   bc
parseNum:
 ld a,(hl)
 inc    hl
 push   bc
 ld     b,13
 call   isNumNoB
 pop    bc
 or a
 jr nz,noNum
 dec    bc
 ld		a,b
 or		c
 jr nz,parseNum
 jp stringtonum
noNum:          ;should do a negate function check here
 pop		bc
 pop		hl
 dec		bc
 ld		a,b
 or		c
 jp		nz,syntaxErr
 ld		a,(hl)
 ld		hl,(freeRam)
 cp		tFakeExp
 jr		z,yesLetter
 cp		tii
 jr		z,yesLetter
 cp		ta
 jp		c,syntaxErr  
 cp		ttheta+1
 jr		c,yesLetter
 cp		tPi
 jr		z,yesLetter
 jp		syntaxErr
yesLetter:
 ld		(hl),1
 inc		hl
 ld		(hl),a
 inc		hl
 ld		(freeRam),hl
 dec		hl
 dec		hl
 ret

ten2Power:
 pop		af
 pop		af ;garbage
 call		parse
 ld		de,(freeRam)
 push		de
 push		de
 pop		ix
 ld		(ix),tpower
 ld		(ix+3),l
 ld		(ix+4),h
 ld		hl,5
 add		hl,de
 ld		(freeRam),hl
 call		makeOne
 ld		(ix+1),e
 ld		(ix+2),d
 ex		de,hl
 inc		hl
 inc		(hl)		;times 10
 pop		hl
 ret

subString: ;splits up string into two strings to parse after finding either a + or -
 push   hl      ;save current location in string
 ld     hl,(freeRam)
 ld     (hl),a
 push   hl      ;save location for 1st pointer in node
 ld     de,5
 add    hl,de
 ld     (freeRam),hl
 pop    de      ;recall location for 1st pointer in node
 pop    hl      ;recall location within string
 push   de      ;save location in node
 push   bc      ;save length of string after this + or -
 dec    bc       ;
 call   parse       ;parse second half of string
 pop    bc      ;recall length of string after the + or -
 pop    ix; pop    de      ;recall location in node
 ld     (ix+3),l
 ld     (ix+4),h
; pop    af      ;recall full length of string at start of this parse
 pop		hl
; sub    b       ;a = start length - end length  (ei. length of first string
 or		a
 sbc		hl,bc
; ld     b,a
 ld		b,h
 ld		c,l
 pop    hl      ;recall loc of beginning of the string
 push   ix      ;save place to save right child
 call   parse       ;parse first half or string
 pop    ix      ;recall place to save right child
 ld     (ix+1),l
 ld     (ix+2),h      ;save right child in node; hl=front of node + 4
 push   ix
 pop    hl
 ret            ;we return with hl=location of our mother node
;probably very unoptimized
;this is used for xroot... it needs to convert to a exponent. maybe square root and cube root should do something similar? 
subString2: ;splits up string into two strings to parse after finding either a + or -
 push		hl      ;save current location in string
 ld		hl,(freeRam)
 ld		(hl),tpower
 push		hl      ;save location for 1st pointer in node
 push		hl
 pop		ix
 ld		de,5		;needs 2 operators, ^ and /
 add		hl,de
 ld		(ix+3),l
 ld		(ix+4),h
 ld		(ix+5),tdiv
 add		hl,de
 ld		(freeRam),hl
 pop		de      ;recall location for 1st pointer in node
 pop		hl      ;recall location within string
 push		de      ;save location in node
 push		bc      ;save length of string after this + or -
 dec		bc       ;
 call		parse       ;parse second half of string
 pop		bc      ;recall length of string after the + or -
 pop		ix      ;recall location in node
 ld     (ix+1),l
 ld		(ix+2),h ;save waht we're taking the x'th root of
 pop		hl
 or		a
 sbc		hl,bc
 ld		b,h
 ld		c,l
 pop		hl      ;recall loc of beginning of the string
 push		ix      ;save place to save right child
 call		parse       ;parse first half or string
 pop		ix      ;recall place to save right child
 ld		(ix+8),l
 ld		(ix+9),h      ;save right child in node; hl=front of node + 4
 call		makeOne
 ld		(ix+6),e
 ld		(ix+7),d
 push		ix
 pop		hl
 ret            ;we return with hl=location of our mother node
