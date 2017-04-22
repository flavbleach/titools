TiDoc Maker v1.0 beta - July 2004
Author: Combe Anthony, member of the TIFT
	Web site: nibbles.fr.st (temporarily down) 
	tift.paxl.org (the site of the TIFT!) 
Email: anthony.combe@insa-lyon.fr
Msn: deserteagle_38@hotmail.com


- Files included in the package
* Tidoc.Exe
* Readme.Txt
* Sdl.Dll
* Sdl_image.Dll
* Sdl_ttf.Dll
* Jpeg.Dll
* Libpng1.Dll
* Zlib.Dll
* Verdana.Ttf
* Tidoc.8xp
* Test.8xp
* Test.Txt
* Codes.Jpg
* Ccm.Gif
* Screen.Gif


I		Functions


- You can type your text in the editing window.
- In order to center your text, it must be framed by two <center> strings. It can be accomplished by selecting the text and choosing CENTER in the OPTIONS menu. 
  The program will automatically return to the next line, if judged necessary.
- To inverse the text color (write white on black), the text must be framed by two <inverse> strings. Selecting the text and choosing INVERSE in the OPTIONS menu
  will automatically add them.

- The program allows you to insert pictures. Here's a list of what has to be known about the function:

* The most common picture types are supported: BMP, GIF, JPG, PNG.
* The maximum width of a picture is 96 pixels: the picture will be shrunken if it is above that limit. However, quality will be lost during the process.
  I recommend reducing the picture's length by your self using a graphic program.


* The height isn't limited. The Ti's limit is 64 pixels but we can scroll the picture.
* It is often required to adjust the contract to obtain a descent result.
* The PICTURES folder contains 4 pictures to show you how adjusting the contrast is important.
* We can include any character by inputting it's hexadecimal code. The syntax is <0x..>, where the dots are replaced by two hex characters.
  Example: <0x41> gives an 'A', once converted.
  The CODES.JPG file included with the package contains all the possible characters and their hex equivalent. It is taken directly from the 83+ SKD.
* Inputting two spaces in a row will result in one "big" space, meaning that it will be bigger on the Ti than the small ones that are only used in 
  sentences to separate words.


II		Usage


What needs to be sent to the calculator:
- Tidoc.8xp (required to read documents)
- The generated file by TiDoc Maker

To open a document:
- You input Asm(prgmXXXX	where XXXX is the document's name
  The Asm( command is found in the catalogue, which can be accessed by [2nd] + 0

- You can also create a basic program that contains the Asm(prgmXXXX command followed by a ClrHome if you wish to continue the execution of the program.

- 3 keys are used in the program, Up/Down to scroll and Clear to exit.


Note: I included a test document; here is how to use it

- Open test.txt with tidoc.exe
- Click on Convert, under the Convert Menu
- Send the *.8xp generated file to the calculator (this file is already included in the folder)
- Send tidoc.8xp
- Execute the following command on the calculator: Asm(PrgmTEST
- Enjoy!



III  Kudos

* Thanks to Reda Ghandour for the english translation and bugs reporting
* Thanks to all the TIFT members who create excellent programs that I invite you to discover.
* If you also wish to make a translation, e-mail me.



IV  Bugs

Please report bugs at anthony.combe@insa-lyon.fr
