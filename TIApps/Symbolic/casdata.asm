num_vals:
  db    30h,31h,32h,33h,34h,35h,36h,37h,38h,39h,3ah,3bh
negsign:
  db    0b0h
operators:
 db	tpower,tdiv,tmul,tadd,tsub,txroot,teq

OpenParen: ;all the tokens dirive recognizes as open parentheses
  db    0bdh,0c2h,0c3h,0c4h,0c5h,0c6h,0c7h,0bch,10h,0c1h,0c0h,0bfh,0cah,0cbh,0cdh,0cch,0c9h,0c8h,0beh,0b2h
;2nd byte of two byte open paren tokens
  db	 0CFh,0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h,0D8h,0D9h,0DAh,0DDh

str11Name:
  db    StrngObj,tVarStrng,10 ;share the last 0 with the next number
;these numbers share the last byte with the next's first byte
versionNum:
 db	00h,80h,18h,00h,00h,00h,00h,00h
aOne:
 db	00h,80h,10h,00h,00h,00h,00h,00h
aZero:
 db	00h,80h,00h,00h,00h,00h,00h,00h
aTwo:
 db	00h,80h,20h,00h,00h,00h,00h,00h
aThree:
 db	00h,00h,00h,00h,00h,00h,00h,00h,00h
allapps:
 db	"Delete all of",0
 db	"'s",0
 db	"Hooks?",0
byTxt:
 db		"by Brandon Sterner",0
cmdTxt:
 db		"Cmd Line has",0
entryTxt:
 db		"Entry #",0
 db		"1 has",0
sym_title:
 db	"  Symbolic v1.8  ",0
hasTxt:
 db	"  has",0
illegalTxt:
 db	"Illegal Tokens",0
deleteTxt:
 db	"Delete?",0
disableTxt:
 db		"Disable?",0
isTxt:
 db		"  is",0
usingTxt:
 db		"using ",0
parserTxt:
 db		"Parser",0
rawkeyTxt:
 db		"Raw Key",0
tokenTxt:
 db		"Token",0
hookTxt:
 db		"Hook.  Disable?",0
confirmMenu:
 db		" Yes ",0," No ",0
failedTxt:
 db		"Install Failed",0
uninstallTxt:
 db		"Uninstall",0
completedTxt:
 db		"Completed",0
success:
 db		"Install",0
warningTxt:
 db		"Warning!  Do not",0
 db		"delete this app",0
 db		"without using",0
 db		"uninstall first.",0
searchTxt:
 db		"Search for",0
 db		"illegal tokens?",0
allTxt:
 db		"Delete all",0
 db		"variables with",0
 db		"illegal tokens?",0
mainTxt:
 db		" Quit ",0
 db		" Help ",0
 db		" Uninstall ",0
 db		" Install ",0
thanksTxt:
 db		"Special Thanks To:",0
peopleTxt:
 db		23,38,"Nicolas Gilles",0
 db		23,38,"Dan Englander",0
 db		21,38,"Michael Vincent",0
 db		25,38,"Jason Kovacs",0
endNames:

splash:
 db 091h,000h,00Dh,038h,001h,010h,091h,000h,004h,006h,091h,000h
 db 004h,0FBh,081h,030h,000h,01Fh,081h,09Ch,006h,00Ch,001h,0E0h
 db 001h,0F3h,083h,070h,002h,0FFh,0E1h,07Eh,00Eh,01Ch,007h,0F0h
 db 003h,0E3h,083h,070h,006h,0D9h,0E3h,0FFh,00Eh,01Ch,01Eh,030h
 db 003h,003h,086h,070h,00Eh,030h,0E3h,087h,00Ch,03Ch,038h,030h
 db 007h,003h,086h,070h,01Eh,030h,0E3h,003h,09Ch,038h,030h,070h
 db 007h,001h,08Eh,070h,01Eh,031h,0C6h,003h,09Ch,038h,060h,070h
 db 007h,001h,08Ch,078h,03Ch,033h,086h,001h,09Ch,038h,0E0h,0E0h
 db 007h,081h,0CCh,078h,06Ch,036h,00Eh,001h,09Ch,038h,0C0h,0E0h
 db 003h,0C1h,0D8h,07Ch,0CCh,07Ch,00Eh,001h,098h,038h,0C0h,0E0h
 db 001h,0C0h,0D8h,07Fh,08Ch,070h,01Eh,001h,098h,039h,0C0h,0C0h
 db 000h,0E0h,0F0h,06Fh,018h,0F0h,01Ch,003h,018h,031h,080h,000h
 db 000h,070h,070h,0C0h,018h,07Ch,00Ch,003h,018h,031h,0C0h,000h
 db 000h,070h,070h,0C0h,018h,067h,08Ch,006h,010h,031h,0C0h,000h
 db 000h,030h,060h,0C0h,018h,061h,0CCh,004h,030h,031h,0C0h,000h
 db 000h,078h,060h,0C0h,010h,061h,0CEh,008h,030h,0B0h,0E0h,030h
 db 001h,0E0h,060h,0C0h,010h,063h,0CEh,030h,037h,0B0h,0F0h,060h
 db 007h,080h,0E0h,0C0h,010h,07Fh,007h,0E0h,03Fh,030h,07Fh,080h
 db 00Fh,000h,0C0h,0C0h,020h,0FCh,003h,080h,03Ch,030h,01Eh,000h
 db 004h,091h,000h,003h,001h,0E0h,091h,000h,00Bh,040h,091h,000h
 db 012h,002h,000h,000h,080h,01Ch,020h,080h,010h,004h,091h,000h
 db 003h,003h,031h,0B1h,093h,002h,064h,0CCh,0D8h,08Dh,086h,04Dh
 db 000h,002h,091h,0AAh,003h,09Ah,0AAh,095h,015h,055h,008h,0AAh
 db 080h,002h,0A2h,091h,0AAh,003h,0ACh,095h,015h,094h,088h,0AAh
 db 080h,003h,021h,0A9h,092h,09Ch,066h,04Ch,0D4h,0CDh,0A6h,04Ah
 db 080h,091h,000h,0FFh,091h,000h,015h,007h,03Dh,0E6h,03Bh,05Eh
 db 0E0h,0E6h,063h,05Eh,0F3h,038h,0E0h,006h,0B0h,0CDh,063h,058h
 db 0D1h,08Dh,063h,04Ch,066h,0B5h,080h,006h,0B8h,0CFh,063h,0DCh
 db 0D0h,0CDh,063h,04Ch,066h,0B4h,0C0h,006h,0B0h,0CDh,063h,058h
 db 0D0h,06Dh,063h,04Ch,066h,0B4h,060h,007h,03Ch,0CDh,03Bh,05Eh
 db 0E1h,0C6h,079h,08Ch,0F3h,035h,0C0h,091h,000h,01Ch,010h,040h
 db 008h,002h,091h,000h,005h,004h,051h,044h,032h,066h,06Ch,046h
 db 0C3h,026h,080h,000h,000h,005h,055h,054h,055h,04Ah,08Ah,0AAh
 db 084h,055h,040h,000h,000h,005h,055h,054h,056h,04Ah,08Ah,0CAh
 db 044h,055h,040h,000h,000h,002h,08Ah,029h,033h,026h,06Ah,066h
 db 0D3h,025h,040h,091h,000h,00Dh
