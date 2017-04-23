;needs to look for all fake tokens in:
;1.  All basic programs.  Ignore assembly programs.		check!
;2.  All equation variables.										check!
;3.  All entries.														check!
;4.  Programs !, #													check!													
;5.  The asnwer variable.											check!
;6.  All string variables.											check!
uninstall:
 res		1,(iy+36h)
 res		5,(iy+34h)
 res		0,(iy+35h)
 call		window
 ld		hl,searchTxt			;do you want to search for illegal tokens?
 ld		de,27*256+31
 call		DE_vputs
 ld		de,33*256+24
 call		DE_vputs
 call		yesNoMenu
 bit		textinverse,(iy+textflags)
 jp		nz,quitApp
 call		window
 ld		hl,allTxt				;do you want to automatically delete any files with illegal tokens> 
 ld		de,23*256+24
 call		DE_vputs
 ld		de,29*256+24
 call		DE_vputs
 ld		de,35*256+24
 call		DE_vputs
 call		yesNoMenu
 res		ask,(iy+myFlags)
 bit		textinverse,(iy+textflags)
 jr		nz,dontask
 set		ask,(iy+myFlags)
dontask:
;now do the searching
;search for progs
 B_CALL	zeroop1
 ld		a,progobj
 ld		(op1),a
 ld		a,0feh
 ld		(op1+1),a
 call		anysearch
;search for string vars
 B_CALL	zeroop1
 ld		a,strngobj
 ld		(op1),a
 ld		a,tvarstrng
 ld		(op1+1),a
 ld		a,0feh
 ld		(op1+2),a
 call		anysearch
;search for equation vars
 B_CALL	zeroop1
 ld		a,equobj
 ld		(op1),a
 ld		a,tvarequ
 ld		(op1+1),a
 ld		a,0feh
 ld		(op1+2),a
 call		anysearch
;search ans
 B_CALL	ansname
 B_CALL	rclans
 ld		a,(hl)
 cp		strngobj
 jr		z,anstext
 cp		equobj
 jr		nz,ansdone
anstext:
 push		de
 call		loadsearchprog
 pop		hl
 call		ramcode	;its pretty safe to say ans, !, and # are in ram... no need to care what gets swapped into 4000h
 or		a
 jr		z,ansdone
;do the check to see if the unser wants to be prompted
 bit		ask,(iy+myFlags)
 jr		nz,delans
 call		window
 ld		hl,op1+1
 ld		de,23*256+24
 call		disptokenstr_DE
 ld		hl,hasTxt
 call		vputs
 ld		de,29*256+24
 ld		hl,illegalTxt
 call		DE_vputs
 ld		hl,deleteTxt
 ld		de,35*256+35
 call		DE_vputs
 call		yesNoMenu
 bit		textinverse,(iy+textflags)
 jr		nz,ansdone
delans:
 B_CALL	op1set0
 B_CALL	stoans	;set ans=0 (what ans is when tios boots up for the first time)
ansdone:
;warning extremely nasty routines follow
checkentries:
 ld		a,(numLastEntries)
 or		a
 push		af					;dummy push
 jp		z,entriesdone
 ld		b,a
 ld		hl,lastentrystk
nextentry:
 pop		af					;rid ourselves of a push
nextentry2:
 push		hl					;save the location of the start of this entry
 ld		e,(hl)
 inc		hl
 ld		d,(hl)	;de = length of entry
 inc		hl
iterateentry:
 ld		a,(hl)
 inc		hl
 dec		de
 cp		0bbh
 jr		z,entryhas2byte
finishupentry:
 ld		a,e
 or		d
 jr		nz,iterateentry
 djnz		nextentry
 jp		entriesdone
entryhas2byte:
 ld		a,(hl)
 inc		hl
 dec		de
 cp		0cfh
 jr		c,finishupentry
;ok we now know there is a custom token in the (B+1)th from last entry 
;do the check to see if the unser wants to be prompted
;
 ld		(tempbc),bc
;
 push		hl
 push		de
 bit		ask,(iy+myFlags)
 jr		nz,delent
 call		window
 ld		hl,entryTxt
 ld		de,23*256+24
 call		DE_vputs
 ld		hl,(tempbc)
 ld		a,(numlastentries)
 sub		h
 add		a,2
 B_CALL	SetXXOP1
 B_CALL	formreal
 ld		hl,op3
 call		vputs
 ld		de,29*256+24
 ld		hl,illegalTxt
 call		DE_vputs
 ld		hl,deleteTxt
 ld		de,35*256+35
 call		DE_vputs
 call		yesNoMenu
 bit		textinverse,(iy+textflags)
 jr		z,delent
 pop		de
 pop		hl
 add		hl,de
 ld		bc,(tempbc)
 djnz		nextentry
 jr		entriesdone2
delent:
 pop		de
 pop		hl
 add		hl,de	;hl= start of next entry
 pop		de
 push		hl
 ld		hl,(lastentryptr)
 or		a
 sbc		hl,de
 push		hl
 pop		bc
 pop		hl
 jr		z,lastentrydeleted
;
 push		de
;
 ldir
 ld		(lastentryptr),de
 ld		a,(numlastentries)
 dec		a
 ld		(numlastentries),a
; jr		checkentries
 pop		hl
 ld		bc,(tempbc)
 dec		b
;
 jp		nz,nextentry2
 jr		entriesdone2
lastentrydeleted:
 ld		(lastentryptr),hl
 ld		a,(numlastentries)
 dec		a
 ld		(numlastentries),a
 push		af
entriesdone:
 pop		af
entriesdone2:
 ld		a,progobj
 ld		(op1),a
 ld		a,'#'
 ld		(op1+1),a
 xor		a
 ld		(op1+2),a
 B_CALL	chkfindsym
; rst		rfindsym
 push		de
 call		loadsearchprog
 pop		hl
 push		hl
 call		ramcode	;its pretty safe to say ans, !, and # are in ram... no need to care what gets swapped into 4000h
 pop		hl
 or		a
 jr		z,pnddone
;do the check to see if the unser wants to be prompted
 push		hl
 bit		ask,(iy+myFlags)
 jr		nz,dellast
 call		window
 ld		hl,entryTxt
 ld		de,23*256+24
 call		DE_vputs
 call		vputs
 ld		de,29*256+24
 ld		hl,illegalTxt
 call		DE_vputs
 ld		hl,deleteTxt
 ld		de,35*256+35
 call		DE_vputs
 call		yesNoMenu
 bit		textinverse,(iy+textflags)
 jr		nz,pnddone
dellast:
 pop		hl
 ld		e,(hl)
 inc		hl
 ld		d,(hl)
 push		hl
 inc		hl
 B_CALL	delmem
 ld		a,(numlastentries)
 or		a
 jr		z,lastentry0
 ld		hl,lastentrystk
 ld		a,(hl)
 inc		hl
 ld		h,(hl)
 ld		l,a
 pop		de
 push		de
 push		hl
 B_CALL	insertmem
 pop		bc
 pop		hl
 ld		(hl),b
 dec		hl
 ld		(hl),c
 inc		hl
 inc		hl
 ex		de,hl
 ld		hl,lastentrystk+2
 ldir
 push		hl	;the next entry
 ld		de,(lastentryptr)		
 ex		de,hl
 or		a
 sbc		hl,de
 ld		c,l
 ld		b,h
 ld		de,lastentrystk
 pop		hl
 ldir
 ld		(lastentryptr),hl		
 ld		a,(numlastentries)
 dec		a
 ld		(numlastentries),a
 push		af
 jr		pnddone
lastentry0:
 pop		hl
 ld		(hl),0
 dec		hl
 ld		(hl),0
 push		af
pnddone:
 pop		af
 ld		a,progobj
 ld		(op1),a
 ld		a,'!'
 ld		(op1+1),a
 xor		a
 ld		(op1+2),a
 B_CALL	chkfindsym
; rst		rfindsym
 push		de
 call		loadsearchprog
 pop		hl
 push		hl
 call		ramcode	;its pretty safe to say ans, !, and # are in ram... no need to care what gets swapped into 4000h
 pop		hl
 or		a
 jr		z,expdone
;do the check to see if the unser wants to be prompted
 push		hl
 bit		ask,(iy+myFlags)
 jr		nz,delexp
 call		window
 ld		hl,cmdTxt
 ld		de,23*256+24
 call		DE_vputs
 ld		de,29*256+24
 ld		hl,illegalTxt
 call		DE_vputs
 ld		hl,deleteTxt
 ld		de,35*256+35
 call		DE_vputs
 call		yesNoMenu
 bit		textinverse,(iy+textflags)
 jr		nz,expdone
delexp:
 pop		hl
 ld		e,(hl)
 ld		(hl),0
 inc		hl
 ld		d,(hl)
 inc		hl
 ld		(hl),0			
 B_CALL	delmem			;nothing in ! now
 xor		a
 ld		(cmdcursor),a
 ld		a,kclear
 ld		(exitkey),a		;this will clear the screen since ! is now empty
 push		af
expdone:
 pop		af
;uninstall is complete
 call		window
 ld		hl,uninstallTxt
 ld		de,27*256+33
 call		DE_vputs
 ld		de,33*256+31
 call		DE_vputs
 call		wait
 jp		quitApp

anysearch:
 B_CALL	findalphadn
 ret		c
 dec		hl
 dec		hl
 dec		hl
 ld		e,(hl)
 dec		hl
 ld		d,(hl)
 dec		hl
 ld		a,(hl)
 push		de
 call		loadsearchprog
 pop		hl
 call		ramcode
 or		a
 jr		z,anysearch
;do the little check if user wants to be prompted
 xor		a
 ld		(op1+9),a
 bit		ask,(iy+myFlags)
 jr		nz,anysearch2
 call		window
 ld		hl,op1+1
 ld		de,23*256+24
 call		disptokenstr_DE
 ld		hl,hasTxt
 call		vputs
 ld		de,29*256+24
 ld		hl,illegalTxt
 call		DE_vputs
 ld		hl,deleteTxt
 ld		de,35*256+35
 call		DE_vputs
 call		yesNoMenu
 bit		textinverse,(iy+textflags)
 jr		nz,anysearch
anysearch2:
 B_CALL	chkfindsym
 ld		a,(op1)
 and		00011111b		;get lower 5 bits(the object type)
 cp		equobj
 jr		z,equdel
 B_CALL	delvararc
 jr		anysearch
equdel:
 B_CALL	delvararc
 B_CALL	create0equ		;if equation vars don't exist, the stupid tios freaks out
 jr		anysearch
disptokenstr_DE:
 ld		(pencol),de
disptokenstr:
 ld		a,(hl)
 or		a
 ret		z
 push		hl
 B_CALL	GET_TOK_STRNG
 ld		hl,op3
 ld		b,a
 B_CALL	vputsn
 pop		hl
 ld		a,(hl)
 inc		hl
 B_CALL	IsA2ByteTok
 jr		nz,disptokenstr
 inc		hl
 jr		disptokenstr
loadsearchprog:
 ld		hl,searchprog
 ld		de,ramcode
 ld		bc,searchprogend-searchprog
 ldir
 ret
searchprog:
 ld		b,a
 in		a,(6)
 push		af
 ld		a,b
 out		(6),a
 ld		c,(hl)
 inc		hl
 ld		b,(hl)		;bc = length of prog
 inc		hl
 ld		a,(hl)
 cp		0bbh
 jr		nz,notasmprog2
 inc		hl
 ld		a,(hl)
 cp		6dh
 jr		nz,notasmprog1
;this program does not need to be deleted 'cause its an asm prog
returnfalse:
 pop		af
 out		(6),a
 xor		a
 ret
notasmprog1:
 dec		hl
notasmprog2:
 ld		a,b
 or		c
 jr		z,returnfalse
 call		checkpageover-searchprog+ramcode
gotnextpage1:
 ld		a,(hl)
 inc		hl
 dec		bc
 cp		0bbh
 jr		nz,notasmprog2
 ld		a,b
 or		c
 jr		z,returnfalse
 call		checkpageover-searchprog+ramcode
gotnextpage2:
 ld		a,(hl)
 inc		hl
 dec		bc
 cp		0cfh
 jr		c,notasmprog2
 pop		af
 out		(6),a
 ld		a,1
 ret
checkpageover:
 ld		de,8000h
 or		a
 push		hl
 sbc		hl,de
 pop		hl
 ret		nz		;sure you don't want to be dealing with a carry flag?
 in		a,(6)
 inc		a
 out		(6),a
 ld		hl,4000h
 ret
searchprogend:
