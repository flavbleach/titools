3myInterrupt:
 di
 ex     af,af'
 exx
 bit		oninterrupt,(iy+onflags)
 jp		nz,breakErr					;do shadows need to be switched?
 ld     (stack),sp
 ld     hl,(stack)
 ld     de,(freeRam)
 ld     bc,50
 or     a
 sbc    hl,bc
 or     a
 sbc    hl,de
 jr     nc,sysInt
 pop    hl
 exx    
 ex     af,af'
 im     1
 ei
 jp		notEnMemErr
sysInt:
 exx
 ex     af,af'
 jp     0038h
endMyInterrupt: