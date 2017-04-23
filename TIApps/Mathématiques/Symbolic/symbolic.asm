; Symbolic v1.8 Source Code By Brandon Sterner
; 
;March 6, 2002
; 
; I've decided to post the source code to this application which is in one of its last revisions.  I've
;learned alot from this application.  Unfortunately one of those things was how poorly it was planned.  Its been
;under development for more than a year now.  It started out based on an 83, using code from zasmload.  Since then
;its been ported to the 83+ in app form, and embedded into the OS using hooks.  Its time for a rewrite, a totally new CAS.
;I'd like to thank everyone who has sent be bugs to fix, tested this, and encouraged me to continue this project.
;Here is what the code looks like.  I hope it will be helpful to someone.  You may use portions of this code if 
;your software is freeware and you give me credit in the documentation.
;  If anyone experienced with some college math is interested in assisting in a joint project on a future CAS, 
;please let me know.  I need help understanding algorithms and notation.  Of course assistance programming these
;algorithms is also welcome.
;
;Brandon Sterner
;brandon@detacheds.com
;
;fix:
; compress help text
; expr(numStr(9)) throws err:version - kevin barmish
; press + on menu items for help
; uninstaller finds illegal tokens when it shouldn't
; better square roots
; web page does not mention numStr or pretty
; sending a app after installation - paxl
; preserve asmflag1
;v1.8 fixed:
; d("2-","X") crashes, doesn't even get to parser - el barto
; d("X3+1+)^10+","X" crashes - David Lindstrom
; menuroutine in jump table - Michael Vincent
; sin(x)+2sin( crashes - Sebastian Theiss
; wrap around was buggy - Chuck Adams
; EOL not recognized as end of quotes - calebhwrd
; if expression ended with an e, then errored 
; d("[cuberoot]x","x") gives divide by 0 error - Patrick Poon
; cot(pi/2) throws error - Kevin Barmish
; split screen mode fixed - sebastian theiss
; preserve those bytes in savescreen during parse
;v1.7 fixed:
; subtraction rule got mixed up with addition - introduced in v1.6
; simp("(a/b)^-2") returns 1/(a/b)^2 when (b/a)^2 is simpler - kevin Barmish
;v1.6 fixed:
; didn't check variable type for first arg in let()
; pretty() token added
; d(cot-1(x)) didn't return negative result - David Vorobeychik
;v1.5 fixed:
;  negative exponents simplify to reciprical of base to abs of power -Kevin Barmish
;  natural logs and logs had problems with decimals - Kevin Barmish
;  minus sign in numStr - Kevin Barmish
;  simp("a=b") didn't throw syntax error
;  d(str1,"x") no longer destroys str1 - Kevin Barmish
;  updated help mode
;  sending BASIC programs via the link no longer causes ERR:Version - Robert Maresh
;     other varaibles such as equation and strings still may not be sent
;  ptempcnt was not being updated, this caused "1"+numStr(0) to return "11" - Jason Kovacs
;  X^X^X is no longer assumed to be X^(X^X) but rather (X^X)^X
;v1.4 fixed:
;  problems with exponents - Kevin Barmish
;v1.3 fixed:
;	problems with let() - Andrey Gorlin, Patrick Poon
;	optimized lots of things
;  safer memory management in implicit mult routines
;	period after delete all - Andrey Gorlin
;  inverse trig was wrong!!! - Andrey Gorlin
;  graphing sign - Andrey Gorlin
;		I now made it so that it threw the errow divide by 0
;		The grapher and table editor like this much more
;  uninstaller had problems with archives - Andrey Gorlin
;  Graph marked dirty after symbolic is run
;v1.2 fixed:
;	problems with uninstaller - Bob Wang
;v1.1 fixed:
;	problem with fractions

;bugs:
;pasting is buggy in progedit

 GLOBALS ON

 include "ti83plus.inc"

                                ;Field code = 080h:  Field codes are delimiters 
                        ; of the various datums in the header file. 
 db 080h,0Fh           ;Field:Program Length      where "length" = 0Fh 
                        ; and the "Fh"  tells us four bytes follow 
 db 00h,00h,00h,00h    ;Length= 4 bytes in size = (0 or N/A for 
                        ; unsigned apps) For signed apps the length is 
                        ; TBD/TBA 
; 
 db 080h,012h          ;Field:Program type    Prgm.typeh, in 2nd byte is 12h.
                        ; The "2" defines the number of bytes in the keyfile 
                        ; name (which are the next 2 bytes). As illustrated in 
                        ; the Demo's Keyfile example from the Developer's Guideh,
                        ; the keyfile example was 0104; two bytes in size.

    db 01h,04h


        ;Field: App ID   Field code = 080h and App ID = "21h" 
 db 080h,021h  ; "2" = 2nd data fieldh, 1 for one byte in size.
;
                ;ID = 1 and it's one byte in sizeh, as denoted in the 
            ; App ID's second nibble("1").This field is typically
                ; incremented on shareware or authenicated apps for 
 db   01h  ; major revisionsh,i.e:  1.x to 2.0; 2.n to 3.0h, etc.
;
        ;Field: App Build       App Build = "31h" ; the 
        ;  "3"  tells us it's build data; the "1" tells us the
 db 080h,031h  ;  Build data is "1" byte in size
;
                ;Build = 1 (always = 1 for development); is the 
                ; configuration control for minor revisionsh, eg: 
 db   08h  ; 1.1 to 1.2h, or X.m to X.(m+1)

 db 080h,048h           ;Field:App Name   and App Name ="48h"
                                         ; and MUST be 8 characters
  db "Symbolic"
;
 db 080h,081h            ;Field: App Pages    App pages code = "8" &
                        ;  the "1" infers one byte following which 
                         ;  tells us the number of pages of the app.        
 db 01h                     ;App Pages = 1   egh, a 1-page application
;
 db 080h,090h       ;No default splash screen
;
 db 03h,026h,09h,04h,04h,06fh,01bh,80h   ;Field: Date stamp- 5/12/1999
                                         ;(No decode of the Date Stamp)
;
 db 02h,0dh,040h              ;Dummy-encrypted TI date stamp signature
                               ;(No decode of encrypted date stamp
                               ; signature) 
;                                             
; ==== Below 64 bytes of data are p/o application data  ===== 
;
 db 0a1h,06bh,099h,0f6h,059h,0bch,067h 
 db 0f5h,085h,09ch,09h,06ch,0fh,0b4h,03h,09bh,0c9h 
 db 03h,032h,02ch,0e0h,03h,020h,0e3h,02ch,0f4h,02dh 
 db 073h,0b4h,027h,0c4h,0a0h,072h,054h,0b9h,0eah,07ch 
 db 03bh,0aah,016h,0f6h,077h,083h,07ah,0eeh,01ah,0d4h 
 db 042h,04ch,06bh,08bh,013h,01fh,0bbh,093h,08bh,0fch 
 db 019h,01ch,03ch,0ech,04dh,0e5h,075h 
;
 db 80h,7Fh         ;Field:  Program Image length 
 db   0h,0h,0h,0h       ;Length=0h, N/A
;
 db   0h,0h,0h,0h       ;Reserved / pad  
 db   0h,0h,0h,0h       ;Reserved / pad
 db   0h,0h,0h,0h       ;Reserved / pad
 db   0h,0h,0h,0h       ;Reserved / pad (use if you have a 4 hex character sized keyfile)

mMath       equ     8h
ask			equ 4
;system rom calls
_setKeyH        equ 4F66h
_setTokenH  equ 4F99h
_setParseH  equ 5026h
_excCxMain  equ 4045h
_IsA2ByteTok equ 42a3h
_getSerial equ 807eh
_JForceCmd	equ 402Ah
_GET_TOK_STRNG	equ 4594h
_CREATETEMP	equ 4a4dh 
baseAppBrTab2        EQU  9C06h
parserHookPtr equ 9bach
tokenHookPtr equ 9bc8h
_LoadMenuNumL equ 45e2h

exitkey equ appbackupscreen
tempbc equ appbackupscreen+1
timer	equ appbackupscreen+3

begin:
 jr		endofjumps
;jumptable
parsejumptable:
 dw	cscRoutine		;1
 dw	csciRoutine		;2
 dw	secRoutine		;3
 dw	seciRoutine		;4
 dw	cotRoutine		;5
 dw	cotiRoutine		;6
 dw	cschRoutine		;7
 dw	cschiRoutine	;8
 dw	sechRoutine		;9
 dw	sechiRoutine	;10
 dw	cothRoutine		;11
 dw	cothiRoutine	;12
 dw	diffRoutine		;13
 dw	simpRoutine		;14
 dw	signRoutine		;15
 dw	getVersion		;16
 dw	arclength		;17
 dw	letRoutine		;18
 dw	numcaststr		;19
 dw	prettyRoutine	;20
 dw	0
 dw	customMenu
 dw	parse
endofjumps:
 B_CALL	forcefullscreen
 xor		a
 ld		(exitkey),a
 ld		(tokenHookPtr+3),a
 ld		(rawKeyHookPtr+3),a
 ld		(parserHookPtr+3),a
 ld		hl,splash
 ld		de,plotsscreen
 call		DispRLE
 B_CALL	grbufcpy
 ld		hl,byTxt
 ld		de,256*35+17
 call		DE_vputs   
 ld		hl,30000
 ld		(timer),hl
authorLoop:
 B_CALL	getcsc
 or		a
 jr		nz,creditsdone
 ld		hl,(timer)
 dec		hl
 ld		(timer),hl
 ld		a,l
 or		h
 jr		nz,authorLoop

 ld		hl,peopleTxt
 ld		(tempBC),hl
credits:
 B_CALL	grbufcpy
 ld		hl,thanksTxt
 ld		de,32*256+17
 call		DE_vputs
 ld		hl,(tempBC)
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 inc		hl
 call		DE_vputs
 ld		(tempBC),hl
 ld		de,endNames
 or		a
 sbc		hl,de
 jr		nz,credits2
 ld		hl,peopleTxt
 ld		(tempBC),hl
credits2:
 ld		hl,6000
 ld		(timer),hl
credits3:
 B_CALL	getcsc
 or		a
 jr		nz,creditsdone
 ld		hl,(timer)
 dec		hl
 ld		(timer),hl
 ld		a,h
 or		l
 jr		nz,credits3
 jr		credits
creditsdone:
 cp		skclear
 jp		z,quitApp
mainmenu:
 call		window
 call		vertmen
 sub		4
 jp		z,quitApp
 inc		a
 jp		z,instructions
 inc		a
 jp		z,uninstall

checkInstall:
;choose install from main menu
checkParser:
 bit		1,(iy+36h)
 jp		z,checkKey
 ld		a,(parserHookPtr+2)
 ld		b,a
 in		a,(6)
 cp		b
 jp		z,checkKey
 ld		hl,parserTxt
 call		conflict
checkKey:
 bit		5,(iy+34h)
 jr		z,checkToken
 ld		a,(rawKeyHookPtr+2)
 ld		b,a
 in		a,(6)
 cp		b
 jr		z,checkToken
 ld		hl,rawkeyTxt
 call		conflict
checkToken:
 bit		0,(iy+35h)
 jr		z,install
 ld		a,(tokenHookPtr+2)
 ld		b,a
 in		a,(6)
 cp		b
 jr		z,install
 ld		hl,tokenTxt
 call		conflict
install:
 in     a,(6)
 ld     hl,keyRoutine
 B_CALL setKeyH
 in     a,(6)
 ld     hl,tokenRoutine
 B_CALL setTokenH
 in     a,(6)
 ld     hl,parseRoutine
 B_CALL setParseH
 call		window
 ld		hl,success
 ld		de,27*256+37
 call		DE_vputs
 ld		de,33*256+31
 ld		hl,completedTxt
 call		DE_vputs
 call		wait
 call		window
 ld		hl,warningTxt
 ld		de,23*256+24
 call		DE_vputs
 ld		de,29*256+24
 call		DE_vputs
 ld		de,35*256+24
 call		DE_vputs
 ld		de,41*256+24
 call		DE_vputs
 call		wait
invalidCalc:
quitApp:
 ld		a,(exitkey)
 set		graphDraw,(iy+graphFlags)
 B_JUMP JForceCmd   ;Exit the application

window:
    ld  hl,16*256+22
    ld de, 22*256+74
    B_CALL FillRect
    ld  hl,23*256+22
    ld de, 46*256+22
    B_CALL FillRect
    ld  hl,23*256+74
    ld de, 46*256+74
    B_CALL FillRect
    ld  hl,47*256+22
    ld de, 47*256+74
    B_CALL FillRect
    ld  hl,23*256+23
    ld  de,46*256+73
    B_CALL ClearRect

 ld hl,sym_title
 ld de, 16*256+24
 SET textinverse, (IY+textflags)
 call DE_vputs
 RES textInverse,(iy+textflags)
 ret

DE_vputs:
    ld (pencol), de
Vputs:
vputs:
    ld a, (hl)
    inc hl
    or a
    ret z
    b_call vputmap
    jr nc,vputs
    ret

myRamCode:
 ld		b,a
 in		a,(6)
 push		af
 ld		a,b
 out		(6),a
 xor		a
 ld		(op1),a
 ld		(op1+9),a
 ld		hl,4007h
 ld		a,(hl)
 ld		c,00001111b
 and		c
 inc		a
 inc		a
 ld		d,0
 ld		e,a
 add		hl,de
 ld		a,(hl)
 and		c  ;00001111b
 inc		a
 inc		a
 ld		e,a
 add		hl,de
 ld		a,(hl)
 and		c ;00001111b
 add		a,3
 ld		e,a
 add		hl,de
 ld		bc,8
 ld		de,op1+1
 ldir
 ex		de,hl
 ld		(hl),0
 pop		af
 out		(6),a
 ret
endOfMyRamCode:

conflict:
 push		hl
 push		bc
 call		window
 pop		af
 call		getBasePage
 pop		hl
 push		af
 push		hl
 ld		bc,endOfMyRamCode-myRamCode
 ld		hl,myRamCode
 ld		de,ramCode
 ldir
 call		ramCode
 B_CALL	findapp
 jr		nc,appexists
 pop		af
 pop		hl
 ret
appexists:
 ld		de,23*256+24
 ld		hl,op1+1
 call		DE_vputs
 ld		hl,isTxt
 call		Vputs
 ld		de,29*256+24
 ld		hl,usingTxt
 call		DE_vputs

 pop		hl
 call		Vputs
 ld		hl,hookTxt
 ld		de,35*256+24
 call		DE_vputs
 call		yesNoMenu
 bit		textinverse,(iy+textflags)
 jr		z,checkifallappshooks
 call		window
 ld		hl,failedTxt
 ld		de,30*256+26
 call		DE_vputs
 call		wait
; B_JUMP	JForceCmdNoChar
 jp		quitApp
checkifallappshooks:
 call		window
 ld		hl,allapps
 ld		de,23*256+28
 call		DE_vputs
 push		hl
 ld		hl,op1+1
 ld		de,29*256+29
 call		DE_vputs
 pop		hl
 call		Vputs
 ld		de,35*256+36
 call		DE_vputs
 call		yesNoMenu
 pop		af
 ld		c,a
 bit		textinverse,(iy+textflags)
 call		z,delallapphok
 ret

wait:
 B_CALL	getcsc
 or		a
 jr		z,wait
 cp		skclear
 jp		z,quitApp
 ret

vertmen:
 ld		a,1
vertmen2:
 push		af
 ld		b,4
 ld		hl,mainTxt
vertmen3:
 res		textinverse,(iy+textflags)
 pop		af
 push		bc
 cp		b
 jr		nz,notInverse
 set		textinverse,(iy+textflags)
notInverse:
 ld		de,17*256+33
 push		af
 ld		a,b
 add		a,a
 add		a,b
 add		a,a
 add		a,d
 ld		d,a
 call		DE_vputs
 pop		af
 pop		bc
 push		af
 djnz		vertmen3
nokey2:
 B_CALL	getcsc
 or		a
 jr		z,nokey2
 cp		skclear
 jp		z,quitApp
 cp		skdown
 jr		z,menudown
 cp		skup
 jr		z,menuup
 cp		skenter
 jr		nz,nokey2
 pop		af
 ret
menudown:
 pop		af
 inc		a
 cp		5
 jr		nz,vertmen2
 jr		vertmen
menuup:
 pop		af
 dec		a
 or		a
 jr		nz,vertmen2
 ld		a,4
 jr		vertmen2

yesNoMenu:
 set		textinverse,(iy+textflags)
ynmen:
 ld		hl,confirmMenu
 ld		de,41*256+37
 call		DE_vputs
 ld		a,(iy+textflags)
 xor		00001000b
 ld		(iy+textflags),a
 call		Vputs
nokey:
 B_CALL	getcsc
 or		a
 jr		z,nokey
 cp		skenter
 ret		z
 cp		skclear
 jp		z,quitApp
 cp		skleft
 jr		c,nokey
 cp		skright+1
 jr		nc,nokey
 jr		ynmen

getBasePage:
 ld		hl,baseAppBrTab
 cp		20h
 jr		c,inchart1
 sub		20h
 ld		hl,baseAppBrTab2
inchart1:
 ld		d,0
 ld		e,a
 add		hl,de
 ld		a,(hl)	;a now is the base page of the app
 ret

delallapphok:
 ld		hl,9b78h-2
 ld		b,23
delallapphok2:
 inc		hl
 inc		hl
 inc		hl
 inc		hl
 ld		a,(hl)
 push		hl
 call		getBasePage
 pop		hl
 cp		c
 jr		nz,delallapphok3
 ld		(hl),0ffh
delallapphok3:
 djnz		delallapphok2
 ret
 include "symmenu.asm"
 include "symparse.asm"
 include "reciptrig.asm"
 include "cas.asm"
 include "casdiff.asm"
 include "caspars.asm"
 include "cassimp.asm"
 include "cassort.asm"
 include "caserrs.asm"
 include "casutil.asm"
 include "casdata.asm"
 include "syminstruc.asm"
 include "symunin.asm"
 include "symblink.asm"
.end
END