instructions:
 ld		hl,instructText
 ld		b,7
instruc2:
 push		bc
 xor		a
 ld		(penrow),a
 push		hl
 B_CALL	clrlcdfull
 pop		hl
 ld		b,10 
instruc3:
 push		bc
 xor		a
 ld		(pencol),a
 call		vputs
 pop		bc
 ld		a,(penrow)
 add		a,6
 ld		(penrow),a
 djnz		instruc3
 push		hl
 call		wait
 pop		hl
 pop		bc
 djnz		instruc2
 jp		mainmenu

instructText:
 db		"This  application  adds  new",0
 db		"functions  to  the  current",0
 db		"operating  system.  Once",0
 db		"installed,  from  the",0
 db		"command  prompt,  press  the",0
 db		"math  button  twice  to  enter",0
 db		"the  Symbolic  app's  menu.",0
 db		"Using  this  menu,  you  can",0
 db		"type  any  of  the  new",0
 db		"functions.",0

 db		"Trig  functions",0
 db		"  csc(",llbrack,"real])",0
 db		"  arg1: real #",0
 db		"  returns real #",0
 db		0
 db		"Differentiate  function",0
 db		"  d(",llbrack,"str],",llbrack,"str])",0
 db		"  arg1: expression",0
 db		"  arg2: indep. variable",0
 db		"   returns string",0

 db		"Arc Length function",0
 db		"  arclength(",llbrack,"str],",llbrack,"str],",0
 db		"     ",llbrack,"real] , ",llbrack,"real] )",0
 db		"  arg1: expression",0
 db		"  arg2: indep. variable",0
 db		"  arg3: start of arc",0
 db		"  arg4: end of arc",0
 db		"  returns real #",0
 db		0
 db		0

 db		"Simplify function",0
 db		"  simp(",llbrack,"str])",0
 db		"  arg 1: expression",0
 db		"  returns string",0
 db		0
 db		"Sign function",0
 db		"  sign(",llbrack,"real])",0
 db		"  arg1: real #",0
 db		"  returns (|x|/x)",0
 db		0

 db		"Let function",0
 db		"  let(",llbrack,"str],",llbrack,"str])",0
 db		"  arg1: variable set to",0
 db		"     an expression",0
 db		"  arg2: expression containing",0
 db		"     variable",0
 db		"  returns string",0
 db		0
 db		0
 db		0

 db		"Version function",0
 db		"  version(",llbrack,"real])",0
 db		"  arg1: minimum version #",0
 db		"  returns real (version)",0 
 db		"  error if arg1<version",0
 db		0
 db		"numStr function",0
 db		"  numStr(",llbrack,"real])",0
 db		"  arg1: real",0
 db		"  returns string",0

 db		"pretty function",0
 db		"  see www.softheiss.de",0
 db		"  for more info.",0
 db		0
 db		0
 db		0
 db		0
 db		0
 db		0
 db		0
