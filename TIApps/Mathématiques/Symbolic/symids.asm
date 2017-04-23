isValidCalc:
 B_CALL getSerial
 ld     hl,idTable
 ld     a,(hl)
 inc        hl
isValidCalc3:
 push       af
 ld     b,5
 ld     de,op4
isValidCalc4:
 ld     a,(de)
 cp     (hl)
 jr     nz,notValidID
 inc        de
 inc        hl
 djnz       isValidCalc4
validCalc:
 pop        af
 cp     a
 ret
notValidID:
 ld     c,b
 ld     b,0
 add        hl,bc
 pop        af
 dec        a
 jr     nz,isValidCalc3
 inc        a
 ret                ;return not valid

idTable:
 db     15
 db     04h,18h,0ch,6bh,0ch     ;dan1
 db     04h,06h,4bh,79h,46h     ;dan2
 db     04h,0fh,0a9h,02h,03h    ;dan3
 db     04h,0eh,0cah,0f6h,80h   ;cube1
 db     04h,18h,0ch,68h,3fh     ;cube2
 db	  04h,1Bh,77h,44h,0D8h		;cube3
 db     04h,03h,0fh,62h,28h     ;me +
 db     04h,1bh,77h,44h,0c5h        ;me se
 db     04h,16h,81h,95h,0b9h        ;silentwar se
 db     04h,01h,4eh,85h,1ah     ;silentwar +
 db     04h,0bh,0d1h,01h,10h        ;greg ford
 db     04h,10h,0d2h,1dh,62h
 db     04h,01h,80h,0E8,0FAh        ;keltus
 db	  04h,0Eh,0FEh,0BBh,0BEh	;micheal - norway
 db	  04h,0Bh,47h,2Ch,82h		;el barto

