typeErr:
 B_CALL	ErrDataType	
notEnMemErr:
 call		closeandreplace
notenoughram:
 B_CALL	ErrNotEnoughMem
syntaxErr:
 call		closeandreplace
syntaxErr2:
 B_CALL	ErrSyntax
divZerErr:
 call		closeandreplace
 B_CALL	ErrDivBy0
breakErr:
 call		closeandreplace
 B_CALL	ErrBreak
closeandreplace:
 B_CALL	closeprog
 call		replacesaferam
 ret
