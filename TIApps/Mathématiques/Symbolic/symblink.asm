;set all program variables' version numbers to 0 so that the err:version is not thrown
deversion:
 push		af
 B_CALL	zeroop1
 ld		hl,op1
 ld		(hl),progobj
 inc		hl
 ld		(hl),0feh
deversion2:
 B_CALL	findalphadn
 jr		c,deversion3
 dec		hl
 dec		hl
 ld		(hl),0
 jr		deversion2
deversion3:
 pop		af
;flags?
 ret
