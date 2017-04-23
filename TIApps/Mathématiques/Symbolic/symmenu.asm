;press math twice to pull up this menu...  what a great idea.  this makes the tios do the work for you.  since a
;system menu is already pulled up, everything is stored.
noMenu:
 cp		2fh
 jr		z,progMathMenu			;math menu has more than 1 value?  why?!
 ld		a,kmath
 ret
keyRoutine:
 add		a,e
 cp		kLinkIO
 jp		z,deversion
 cp		kmath
 ret		nz
 ld		a,(menucurrent)
 cp		mMath
 jr		nz,noMenu
progMathMenu:
 call		customMenu
 cp		0ffh
 ret		nz
 ld		a,e
 ld		(rawKeyHookPtr+3),a
 B_CALL	LoadMenuNumL
 ld		a,1
 ld		(tokenHookPtr+3),a
 ld		a,kreal
 ld		(keyExtend),a
 ld		a,0FCh
 ret
; xor		a
; ld		(menucurrent),a
; inc		a
; ld		(tokenHookPtr+3),a
; ld		a,e
; ld		(rawKeyHookPtr+3),a
; ld		hl,(textshadcur)
; ld		(currow),hl
; ld		a,kreal
; ld		(keyExtend),a
; set		apptextsave,(iy+appflags)
; ld		a,0fch
; B_CALL	excCxMain
; ld		a,(rawKeyHookPtr+3)
; or		a
; push		af
; xor		a
; ld		(rawKeyHookPtr+3),a	;just incase the token wasn't displayed.  such as when mem runs out
; ld		(tokenHookPtr+3),a
; pop		af
; jr		nz,wasntdisplayed
; ld		hl,(currow)
; ld		(textshadcur),hl
; ld		hl,85e4h
; res		4,(hl)
;wasntdisplayed:
; ld		a,3
; ld		(menucurrent),a
; ld		a,kclear
; ret

tokenRoutine:
 add		a,e
 push		hl
 push		de
 ld		hl,03f6h
 or		a
 sbc		hl,de
 jp		z,realTok
 pop		hl
 ld		de,0548h
 or		a
 sbc		hl,de
 ex		de,hl
 pop		hl
 ret		c		;check if hl < id for token bb cf
 rr		e		;should be an even number 0 through ?
 ld		a,e
 jr		getToken

realTok:
 pop		de
 pop		hl
 ld		a,(tokenHookPtr+3)
 dec		a
 jr		z,notgarbaged
 scf
 ret
notgarbaged:
 ld		a,(rawkeyhookptr+3)
 ld		b,a
 sub		0CFh
 ret		c
;ok this is an real( token in the disguise of another token
 ld		hl,(editCursor)
 dec		hl
 ld		(hl),b			;change the real( token to the true token
getToken:
 sla		a
 ld		e,a
 ld		d,0
 ld		hl,tokenTable
 add		hl,de
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 inc		hl
 ld		b,0
 ld		c,(hl)
 dec		hl
 inc		bc
 inc		bc
 inc		bc
 ld		de,localtokstr
 ldir
 xor		a
 ld		(rawkeyhookptr+3),a
 ld		hl,localtokstr
 ret

;the following is probably the worst menu routine a person has ever seen
;this has nothing to do with system menus, only the same data locations are good for storage...
;(menucurrent+1) = 0... how far over
;(menucurrent+2) = 0... how far down 
;(menucurrent+3) = 1... number across
;(menucurrent+4) = 1... number down
customMenu:
 ld		hl,myMenu
 res		indicrun,(iy+indicflags)
 res		apptextsave,(iy+appflags)
 ld		a,(hl)
 ld		(menucurrent+3),a
 xor		a
 ld		(menucurrent+1),a
 ld		(menucurrent+2),a
 inc		hl
 push		hl
 ld		c,0	;how deep into the menu the top item on the screen is
menuDisp:
; push		bc
; push		hl
; push		de
; B_CALL	clrlcdfull
; pop		de
; pop		hl
; pop		bc
 ld		hl,0
 ld		(currow),hl
 pop		hl
 push		hl
 ld		b,0	;increments as the words accross are displayed
menuDisp2:
 ld		a,(menucurrent+1)
 cp		b
 jr		nz,menuDisp3
 set		textinverse,(iy+textflags)
menuDisp3:
 call		puts
 inc		hl	;skip the 0 terminated
 res		textinverse,(iy+textflags)
 ld		a,lspace
 B_CALL	putc
 ld		a,(menucurrent+1)
 cp		b
 push		bc
 push		hl
 call		z,menuDisp4
 pop		hl
 inc		hl
 inc		hl	;skip sub menu address
 pop		bc
 ld		a,(menucurrent+3)
 inc		b
 cp		b
 jr		nz,menuDisp2
menuWait:
; pop		af
; pop		ix ;call
; pop		hl ;currow
; ld		(currow),hl
; push		hl
; push		ix
; dec		sp
; dec		sp
 push		de
 B_CALL	getkey ;bc preserved	;*** is apd and link stuff ok here?
 pop		de
 cp		kright
 jr		z,menuRight
 cp		kleft
 jp		z,menuLeft
 cp		kup
 jp		z,menuUp
 cp		kdown
 jp		z,menuDown
 cp		k0
 jr		nz,notkeyzero
 cp		kee
 jr		z,notNumOrLett
 cp		kspace
 jr		z,notNumOrLett
 ld		a,k9+1
notkeyzero:
 cp		k0
 jr		c,notNumOrLett
 cp		kcapz+1
 jr		nc,notNumOrLett
 cp		kcapa
 jr		c,notLett
 dec		a	;to correct for kspace
notLett: ;now we need to check to see if a item named this exists....
 pop		hl
 push		hl
 sub		k0
 push		af	;save menu item attempted to be selected by the user
 ld		a,(menucurrent+1)
 inc		a
 ld		b,a
getPullDown:
 inc		hl
 call		find0
 inc		hl
 dec		b
 jr		nz,getPullDown
gotPullDown:
 ld		a,(hl)
 dec		hl
 ld		l,(hl)
 ld		h,a
 pop		af	;attempted depth
 ld		b,a
 dec		a
 cp		(hl)
 jr		nc,notValidNumOrLett

getMenusToken:
 call		find0
 dec		b
 jr		nz,getMenusToken
 ld		e,(hl)
 jr		menuEnter
notNumOrLett:
 cp		kenter
 jr		z,menuEnter
 call		keychecker
 jr		z,exitcustmenu
notValidNumOrLett:
 jr		menuWait
menuEnter:
 pop		hl
 ld		a,0ffh
 ret
exitcustmenu:
 pop		hl
 ret
keychecker:
 push		bc
 ld		hl,menukeys
 ld		c,(hl)
 inc		hl
 ld		b,0
 cpir
 pop		bc
 ret
menuRight:
 xor		a
 ld		(menucurrent+2),a
 ld		c,a
 ld		a,(menucurrent+1)
 inc		a
 ld		(menucurrent+1),a
 ld		b,a
 ld		a,(menucurrent+3)
 cp		b
 jp		nz,menuDisp
 xor		a
 ld		(menucurrent+1),a
 jp		menuDisp
menuLeft:
 xor		a
 ld		(menucurrent+2),a
 ld		c,a
 ld		a,(menucurrent+1)
 dec		a
 ld		(menucurrent+1),a
 cp		0ffh
 jp		nz,menuDisp
 ld		a,(menucurrent+3)
 dec		a
 ld		(menucurrent+1),a
 jp		menuDisp
menuUp:
 ld		a,(menucurrent+2)
 dec		a
 ld		(menucurrent+2),a
 cp		c
 jr		nc,menuUp2
 dec		c
menuUp2:
 cp		0ffh
 jp		nz,menuDisp
 ld		a,(menucurrent+4)
 dec		a
 ld		(menucurrent+2),a
 ld		c,0
 sub		8
 jr		c,menuUp3
 inc		a
 inc		a
 ld		c,a
menuUp3:
 jp		menuDisp
menuDown:
 ld		a,(menucurrent+2)
 inc		a
 ld		(menucurrent+2),a
 ld		b,a
 sub		c
 cp		7
 jr		c,menuDown2
 inc		c
menuDown2:
 ld		a,(menucurrent+4)
 cp		b
 jp		nz,menuDisp
 xor		a
 ld		(menucurrent+2),a
 ld		c,a
 jp		menuDisp
menuDisp4:
 push		de
 pop		ix
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 ex		de,hl
 ld		de,(currow)
 push		de
 ld		de,1
 ld		(currow),de
 push		ix
 pop		de
 ld		d,0
 ld		b,(hl)		;depth of current menu
 ld		a,b
 ld		(menucurrent+4),a
 inc		hl
 ld		a,c	;depth of window
 or		a
 jr		z,displayDown
 push		bc
findtopchoice:
 call		find0
 inc		hl ;skip 2nd token byte
 dec		c
 jr		nz,findtopchoice
 pop		bc
 ld		b,7
 jr		displayDown2
displayDown:
 ld		a,(menucurrent+4)
 cp		8
 jr		c,displayDown2
 ld		b,7
displayDown2:
; B_CALL	newline
;
 ld		a,(curcol)
 or		a
 jr		z,nonewln
 call		newline
nonewln:
;
 ld		a,(menucurrent+2)
 sub		c
 sub		d
 jr		nz,displaydown3
 set		textinverse,(iy+textflags)
 ld		a,(hl)
 inc		hl
 B_CALL	putc
 ld		a,(hl)
 inc		hl
 B_CALL	putc
 res		textinverse,(iy+textflags)
displaydown3:
 call		puts
 inc		hl ;skip 0
 ld		a,(menucurrent+2)
 sub		c
 sub		d
 jr		nz,dontgettoken
 ld		e,(hl)
dontgettoken:
 inc		hl ;skip 2nd token byte
 inc		d
 djnz		displayDown2
;
 call		newline
filldown:
 ld		a,(currow)
 cp		8
 jr		z,dontfill
 call		newline
 jr		filldown
dontfill:
;
 pop		hl
 ld		(currow),hl
 ret
find0:
 ld		a,(hl)
 inc		hl
 or		a
 jr		nz,find0
 ret
puts:
 ld		a,(hl)
 or		a
 ret		z
 B_CALL	putc
 inc		hl
 jr		puts

newline:
 push		hl
 push		de
 push		bc
newline2:
 ld		a,lspace
 B_CALL	putc
 ld		a,(curcol)
 or		a
 jr		nz,newline2
 pop		bc
 pop		de
 pop		hl
 ret

myMenu:
 db	3		;wide
 db	"Trig",0
 dw	trigMenu
 db	"Calc",0
 dw	calcMenu
 db	"Algbr",0
 dw	algbrMenu

algbrMenu:
 db	6
 db	"1:simp(",0,0cfh+13
 db	"2:sign(",0,0cfh+14
 db	"3:let(",0,0cfh+17
 db	"4:version(",0,0cfh+15
 db	"5:numStr(",0,0cfh+18
 db	"6:pretty(",0,0cfh+19
calcMenu:
 db	2
 db	"1:d(",0,0cfh+12
 db	"2:arclength(",0,0cfh+16
trigMenu:
 db	12
 db	"1:csc(",0,0cfh+0
 db	"2:csc",linverse,"(",0,0cfh+1
 db	"3:sec(",0,0cfh+2
 db	"4:sec",linverse,"(",0,0cfh+3
 db	"5:cot(",0,0cfh+4
 db	"6:cot",linverse,"(",0,0cfh+5
 db	"7:csch(",0,0cfh+6
 db	"8:csch",linverse,"(",0,0cfh+7
 db	"9:sech(",0,0cfh+8
 db	"0:sech",linverse,"(",0,0cfh+9
 db	"A:coth(",0,0cfh+10
 db	"B:coth",linverse,"(",0,0cfh+11

tokenTable:
 dw	cscStr
 dw	csciStr
 dw	secStr
 dw	seciStr
 dw	cotStr
 dw	cotiStr
 dw	cschStr 
 dw	cschiStr
 dw	sechStr
 dw	sechiStr
 dw	cothStr
 dw	cothiStr
 dw	diffStr
 dw	simpStr
 dw	signStr
 dw	versionStr
 dw	arclengthStr
 dw	letStr
 dw	numStr
 dw	prettyStr
versionStr:
 db		0,8,"version(",0
cscStr:
 db		0,4,"csc(",0
csciStr:
 db		0,5,"csc",linverse,"(",0
secStr:
 db		0,4,"sec(",0 ;does the first byte have a purpose?
seciStr:
 db		0,5,"sec",linverse,"(",0
cotStr:
 db		0,4,"cot(",0
cotiStr:
 db		0,5,"cot",linverse,"(",0
cschStr:
 db		0,5,"csch(",0
cschiStr:
 db		0,6,"csch",linverse,"(",0
sechStr:
 db		0,5,"sech(",0 ;does the first byte have a purpose?
sechiStr:
 db		0,6,"sech",linverse,"(",0
cothStr:
 db		0,5,"coth(",0
cothiStr:
 db		0,6,"coth",linverse,"(",0
diffStr:
 db		0,2,"d(",0
simpStr:
 db		0,5,"simp(",0
signStr:
 db		0,5,"sign(",0
arclengthStr:
 db		0,10,"arclength(",0
letStr:
 db		0,4,"let(",0
numStr:
 db		0,7,"numStr(",0
prettyStr:
 db		0,7,"pretty(",0
menukeys:
 db	29
 db	kclear,kappsmenu,kprgm,kzoom,kdraw,ksplot,kstat,kmath
 db	ktest,kchar,kvars,kmem,kmatrix,kdist,kangle,klist,kcalc
 db	kcatalog,kgraph,kmode,kwindow,kyequ,ktable,ktblset
 db	kstatp,kformat,ktrace,kquit