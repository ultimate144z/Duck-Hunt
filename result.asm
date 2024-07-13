.model small
.stack 100h
.data

;----------------------------------Variables-----------------------------------------------------------------------------------------

	currentScreen db 1             ; Screen 1 initially . . .
	userName db 20 dup(' ')        ; Space for storing the user's name . . .
	userNameLength db ?            ; Length of entered name . . .
	prompt db 'Enter your name: $'
	gameTitle db 'DUCK HUNT', '$'
	redrawScreen db 1              ; Flag for screen redraw . . .
	videoBuffer dw 0A000h          ; Video memory for mode 0x13 . . .
	cursorPosition db 1            ; Start at MODE ONE . . .
	MODE_ONE       equ 1
	MODE_TWO       equ 2
	currentColor db 09h            ; Default color, can be changed dynamically . . .
	backBuffer db 32000 dup(0)  ; Reduced buffer size . . .
	videoMode db 13h
	
	modeOneMessage db "Mode One: Single duck and white dot. Use arrow keys to move the dot and press ENTER to raise score. ", 13, 10,
                "Score reaches 5: Round one over. Score resets to 0 and goes till 10 (round two over), ", 13, 10,
                "score resets to 0 and finally goes till 20 (round 3 over). Back to game menu (screen2).", 13, 10, "$"

	modeTwoMessage db "Mode Two: Same concept, just 3 ducks moving faster.", 13, 10,
                "Use arrow keys to move the dot and press ENTER to raise score. ", 13, 10,
                "Score reaches 5: Round one over. Score resets to 0 and goes till 10 (round two over), ", 13, 10,
                "score resets to 0 and finally goes till 20 (round 3 over). Back to game menu (screen2).", 13, 10, "$"
	
;------------------------------------------------------------------------------------------------------------------------------------	
;--------------------------------------------------------BITMAPS---------------------------------------------------------------------
grass db 00,02,00,02,02,00,02,00
      db 02,10,10,10,02,02,02,02
      db 02,02,02,02,10,10,10,10
	  db 10,10,02,02,10,10,02,02
	  db 10,10,10,02,02,10,10,10
      db 10,10,02,10,10,02,10,10

mud db 06,06,06,06,06,06,06,06
	db 06,06,04,04,04,06,06,06
	db 06,06,04,04,06,04,04,06
	db 06,06,06,06,06,06,06,06
	db 06,04,04,06,06,04,04,06
	db 06,06,04,04,06,04,06,06
	
duck db 09,09,09,09,15,15,09,09,09,09   ; Eyes in White
     db 09,09,09,00,00,00,15,09,09,09   ; Head in Black and Eyes in White
     db 09,09,00,00,00,00,00,00,09,09   ; Head in Black
     db 09,00,00,00,00,00,00,00,00,09   ; Head in Black
     db 09,00,00,00,00,00,00,00,00,09   ; Head in Black
     db 09,00,00,00,00,00,00,00,00,09   ; Head in Black
     db 09,09,14,14,14,14,14,09,09,09   ; Body in Yellow
     db 09,14,14,14,14,14,14,14,14,09   ; Body in Yellow
     db 14,14,14,14,14,14,06,06,14,14   ; Beak in Brown
     db 14,14,14,14,14,14,14,14,14,09   ; Body in Yellow
     db 14,14,14,14,14,14,14,14,14,14   ; Body in Yellow
     db 14,14,14,14,09,09,14,14,14,14   ; Body in Yellow
     db 14,14,14,09,09,09,09,14,14,14   ; Body in Yellow
	
	
duck2 db 09,09,09,09,15,15,09,09,09,09   ; Eyes in White
      db 09,09,09,14,14,14,15,09,09,09   ; Head in Yellow and Eyes in White
      db 09,09,14,14,14,14,14,14,09,09   ; Head in Yellow
      db 09,14,14,14,14,14,14,14,14,09   ; Head in Yellow
      db 09,14,14,14,14,14,14,14,14,09   ; Head in Yellow
      db 09,14,14,14,14,14,14,14,14,09   ; Head in Yellow
      db 09,09,06,06,06,06,06,09,09,09   ; Body in Orange
      db 09,06,06,06,06,06,06,06,06,09   ; Body in Orange
      db 06,06,06,06,06,06,00,00,06,06   ; Beak in Brown
      db 06,06,06,06,06,06,06,06,06,09   ; Body in Orange
      db 06,06,06,06,06,06,06,06,06,06   ; Body in Orange
      db 06,06,06,06,09,09,06,06,06,06   ; Body in Orange
      db 06,06,06,09,09,09,09,06,06,06   ; Body in Orange

	
duck3 db 09,09,09,09,15,15,09,09,09,09   ; Eyes in White
      db 09,09,09,06,06,06,15,09,09,09   ; Head in Brown and Eyes in White
      db 09,09,06,06,06,06,06,06,09,09   ; Head in Brown
      db 09,06,06,06,06,06,06,06,06,09   ; Head in Brown
      db 09,06,06,06,06,06,06,06,06,09   ; Head in Brown
      db 09,06,06,06,06,06,06,06,06,09   ; Head in Brown
      db 09,09,15,15,15,15,15,09,09,09   ; Body in White
      db 09,15,15,15,15,15,15,15,15,09   ; Body in White
      db 15,15,15,15,15,15,00,00,15,15   ; Beak in Brown
      db 15,15,15,15,15,15,15,15,15,09   ; Body in White
      db 15,15,15,15,15,15,15,15,15,15   ; Body in White
      db 15,15,15,15,09,09,15,15,15,15   ; Body in White
      db 15,15,15,09,09,09,09,15,15,15   ; Body in White

	
	
sky	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	db 09,09,09,09,09,09,09,09
	

	
cloud db 09,09,09,09,09,09,09,09,09,09,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,09,09,09,09,09,09,09,09,09
	  db 09,09,09,09,09,09,09,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,09,09,09,09,09,09
	  db 09,09,09,09,09,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,09,09,09,09
	  db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	  db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	  db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	  db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	  db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	  db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	  db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	  db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	  db 09,09,09,09,09,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,09,09,09,09
	  db 09,09,09,09,09,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,09,09,09,09
	  db 09,09,09,09,09,09,09,09,09,09,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,09,09,09,09,09,09,09,09,09

	
	
	
; this bitmap is for a heart:
Heart 	db 00,00,04,04,00,04,04,00,00 ;09
		db 00,04,15,04,04,04,04,04,00
		db 00,04,04,04,04,04,04,04,00
		db 00,00,04,04,04,04,04,00,00
		db 00,00,00,04,04,04,00,00,00
		db 00,00,00,00,04,00,00,00,00 ;06	
	
; defining colors for 'D'
green_D  db 02,02,02,02,00,00,00,00,00 ; defining top half of 'D'
         db 02,02,00,00,02,00,00,00,00
         db 02,02,00,00,02,00,00,00,00
         db 02,02,00,00,02,00,00,00,00
         db 02,02,00,00,02,00,00,00,00
         db 02,02,02,02,00,00,00,00,00 ; defining bottom half of 'D'
	  
; defining colors for 'D'
Hert  db 03,03,03,03,00,00,00,00,00 ; defining top half of 'D'
      db 03,03,00,00,03,00,00,00,00
      db 03,03,00,00,03,00,00,00,00
      db 03,03,00,00,03,00,00,00,00
      db 03,03,00,00,03,00,00,00,00
      db 03,03,03,03,00,00,00,00,00 ; defining bottom half of 'D'
	  
; defining grass pattern

grass_ 	db 00,02,00,02,02,00,02,00,02,02,00,00,02,00,02,02,00,02,00,02,02,00
        db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
        db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
		db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
        db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
        db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02
        db 02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02,02

grassPattern   db 00,02,00,02,00,00,00,00,00 ; Top of the grass blades
               db 02,02,02,02,00,00,00,00,00
               db 02,02,02,02,02,00,00,00,00
               db 02,02,02,02,02,00,00,00,00
               db 02,02,02,02,00,00,00,00,00
               db 02,02,00,02,00,00,00,00,00 ; Base of the grass blades

	 
	  
; defining colors for 'U', hert2 is for 'U'
Hert2 db 02,02,00,00,02,02,00,00,00 
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,02,02,02,02,00,00,00 
	  
; defining colors for 'C', hert3 is for 'C'
Hert3 db 00,00,02,02,02,00,00,00,00 
      db 00,02,02,02,02,00,00,00,00
      db 00,02,02,00,00,00,00,00,00
      db 00,02,02,00,00,00,00,00,00
      db 00,02,02,02,02,00,00,00,00
      db 00,00,02,02,02,00,00,00,00
	  
; defining colors for 'K', hert4 is for 'K'
Hert4 db 02,02,00,00,02,02,00,00,00 
      db 02,02,00,02,02,00,00,00,00
      db 02,02,02,02,00,00,00,00,00
      db 02,02,02,00,00,00,00,00,00
      db 02,02,02,02,00,00,00,00,00
      db 02,02,00,02,02,00,00,00,00
      db 02,02,00,00,03,00,00,00,00
	  
; green H	  
green_H db 02,02,00,00,02,02,00,00,00 
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,02,02,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
	  
; defining colors for 'U', hert6 is for 'U'
green_U db 02,02,00,00,02,02,00,00,00 
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,00,00,02,02,00,00,00
      db 02,02,02,02,02,02,00,00,00 	  
	  
; defining color for 'N' heart7 is for 'N'
Hert7 db 09,09,00,00,00,00,09,09,00
      db 09,09,00,00,00,00,09,09,00
      db 09,09,09,00,00,00,09,09,00
      db 09,09,09,09,00,00,09,09,00
      db 09,09,00,09,09,00,09,09,00
      db 09,09,00,00,09,09,09,09,00
      db 09,00,00,00,00,00,09,09,00
	  db 09,09,00,00,00,00,09,09,00
	  
; green N
green_N db 02,02,00,00,00,00,02,02,00
      db 02,02,00,00,00,00,02,02,00
      db 02,02,02,00,00,00,02,02,00
      db 02,02,02,02,00,00,02,02,00
      db 02,02,00,02,02,00,02,02,00
      db 02,02,00,00,02,02,02,02,00
      db 02,00,00,00,00,00,02,02,00
	  db 02,02,00,00,00,00,02,02,00
	  
; defining color for 'T' heart8 is for 'T'
Hert8 db 09,09,09,09,09,09,09,00,00
      db 09,09,09,09,09,09,09,00,00
      db 00,00,00,09,09,00,00,00,00
      db 00,00,00,09,09,00,00,00,00
      db 00,00,00,09,09,00,00,00,00
      db 00,00,00,09,09,00,00,00,00
      db 00,00,00,09,09,00,00,00,00
	  
; green T
green_T db 02,02,02,02,02,02,02,00,00
      db 02,02,02,02,02,02,02,00,00
      db 00,00,00,02,02,00,00,00,00
      db 00,00,00,02,02,00,00,00,00
      db 00,00,00,02,02,00,00,00,00
      db 00,00,00,02,02,00,00,00,00
      db 00,00,00,02,02,00,00,00,00
	  
; Enhanced 'E'
s6 db 09,09,09,09,09,09,00,00,00
   db 09,09,09,09,09,09,00,00,00
   db 09,09,09,00,00,00,00,00,00
   db 09,09,09,09,09,09,00,00,00
   db 09,09,09,00,00,00,00,00,00
   db 09,09,09,09,09,09,00,00,00
   db 09,09,09,09,09,09,00,00,00
	  
	 ; enchanced M
s7 db 09,09,00,00,00,00,09,09,00
      db 09,09,00,00,00,09,09,09,00
      db 09,09,09,00,09,09,09,09,00
      db 09,09,09,09,09,09,09,09,00
      db 09,09,00,09,09,00,09,09,00
      db 09,09,00,00,09,00,09,09,00
      db 09,09,00,00,00,00,09,09,00
      db 09,09,00,00,00,00,09,09,00  
	  
; Bold and thick 'W'
bold_W db 03,03,00,00,03,03,00,00,00 
      db 03,03,00,00,03,03,00,00,00  
      db 03,03,00,00,03,03,00,00,00  
      db 03,03,03,00,03,03,03,00,00  
      db 03,03,03,03,03,03,03,00,00  
      db 03,03,03,03,03,03,03,00,00  
      db 03,03,00,00,03,03,00,00,00  

	  
; Define colors for 'W' using the existing rows
HertW db 09,00,00,00,09,00,00,00,00 
      db 09,00,00,00,09,00,00,00,00 
      db 09,00,00,00,09,00,00,00,00 
      db 09,00,00,00,09,00,00,00,00 
      db 09,00,09,00,09,00,00,00,00 
      db 09,09,00,09,09,00,00,00,00 
      db 09,00,00,00,09,00,00,00,00 
	  
; now below is what we will use to draw screen1's pixels
; Bold and thick 'E'
bold_E db 03,03,03,03,03,03,00,00,00 
      db 03,03,03,03,03,03,00,00,00  
      db 03,03,03,00,00,00,00,00,00  
      db 03,03,03,03,03,03,00,00,00  
      db 03,03,03,00,00,00,00,00,00  
      db 03,03,03,03,03,03,00,00,00  
      db 03,03,03,03,03,03,00,00,00  


	  
; Enhanced 'R'
s2    db 09,09,09,09,09,00,00,00,00 
      db 09,09,09,00,00,00,00,00,00 
      db 09,09,09,00,00,00,00,00,00 
      db 09,09,09,09,09,00,00,00,00 
      db 09,09,09,00,09,00,00,00,00 
      db 09,09,09,00,00,09,00,00,00 
      db 09,09,09,00,00,00,09,00,00 
      db 09,09,09,00,00,00,00,09,00 
      db 09,09,09,00,00,00,00,00,09 
	  
; Define colors for 'A' using the existing rows
s3 db 00,00,00,09,09,00,00,00,00 
      db 00,00,09,09,09,09,00,00,00 
      db 00,09,09,09,09,09,09,00,00 
      db 09,09,09,09,09,09,09,09,00 
      db 09,09,00,00,00,00,00,09,09 
      db 09,09,00,00,00,00,00,09,09
      db 09,09,00,00,00,00,00,09,09 

	  
	 ; enchanced M
s7_2  db 03,03,00,00,00,00,09,09,00
      db 03,03,00,00,00,03,03,03,00
      db 03,03,03,00,03,03,03,03,00
      db 03,03,03,03,03,03,03,03,00
      db 03,03,00,03,03,00,03,03,00
      db 03,03,00,00,03,00,03,03,00
      db 03,03,00,00,00,00,03,03,00
      db 03,03,00,00,00,00,03,03,00  

; Bold and thick 'X'
thick_X db 03,00,00,00,03,00,00,00,00  
        db 03,03,00,00,03,03,00,00,00  
        db 00,03,03,03,03,00,00,00,00  
        db 00,03,03,03,03,00,00,00,00  
        db 03,03,00,00,03,03,00,00,00  
        db 03,00,00,00,03,00,00,00,00  
	   
	   
; Define colors for 's1' to match the grass pattern
s1     db 00,02,00,02,00,00,00,00,00 ; Top of the grass blades
       db 02,02,02,02,00,00,00,00,00
       db 02,02,02,02,02,00,00,00,00
       db 02,02,02,02,02,00,00,00,00
       db 02,02,02,02,00,00,00,00,00
       db 02,02,00,02,00,00,00,00,00 ; Base of the grass blades
	   
			  
; Define colors for 'I'
bold_I db 00,00,03,03,00,00,00,00,00  
       db 00,00,03,03,00,00,00,00,00  
       db 00,00,03,03,00,00,00,00,00  
       db 00,00,03,03,00,00,00,00,00  
       db 00,00,03,03,00,00,00,00,00  
       db 00,00,03,03,00,00,00,00,00  			  
			  
; Bold and thick 'R'
bold_R db 03,03,03,03,03,00,00,00,00
       db 03,00,00,00,03,00,00,00,00
       db 03,00,00,00,03,00,00,00,00
       db 03,03,03,03,03,00,00,00,00
       db 03,00,03,00,00,00,00,00,00
       db 03,00,00,03,00,00,00,00,00
       db 03,00,00,00,03,00,00,00,00


; Bold and thick 'S'
bold_S db 00,03,03,03,03,03,00,00,00
       db 03,03,03,03,03,03,03,00,00
       db 03,03,00,00,00,00,00,00,00
       db 00,03,03,03,03,03,03,00,00
       db 00,00,00,00,00,03,03,00,00
       db 03,03,03,03,03,03,03,00,00
       db 03,03,03,03,03,03,00,00,00
       db 00,00,03,03,03,03,03,00,00


; Bold and thick 'U'
bold_U db 03,00,00,00,03,00,00,00,00
       db 03,00,00,00,03,00,00,00,00
       db 03,00,00,00,03,00,00,00,00
       db 03,00,00,00,03,00,00,00,00
       db 03,00,00,00,03,00,00,00,00
       db 03,03,03,03,03,03,00,00,00
       db 00,03,03,03,00,00,00,00,00
	   
; cyan N	  
cyan_N db 03,03,00,00,00,00,03,03,00
      db 03,03,00,00,00,00,03,03,00
      db 03,03,03,00,00,00,03,03,00
      db 03,03,03,03,00,00,03,03,00
      db 03,03,00,03,03,00,03,03,00
      db 03,03,00,00,03,03,03,03,00
      db 03,00,00,00,00,00,03,03,00
	  db 03,03,00,00,00,00,03,03,00
	  
; cyan T  
cyan_T db 03,03,03,03,03,03,03,00,00
      db 03,03,03,03,03,03,03,00,00
      db 00,00,00,03,03,00,00,00,00
      db 00,00,00,03,03,00,00,00,00
      db 00,00,00,03,03,00,00,00,00
      db 00,00,00,03,03,00,00,00,00
      db 00,00,00,03,03,00,00,00,00
	  
; Bold and thick 'O'
bold_O db 00,03,03,03,03,03,00,00,00 
      db 03,03,00,00,00,03,03,00,00  
      db 03,03,00,00,00,03,03,00,00  
      db 03,03,00,00,00,03,03,00,00  
      db 03,03,00,00,00,03,03,00,00  
      db 00,03,03,03,03,03,00,00,00  
	  
cyan_C db 00,03,03,03,03,00,00,00,00
       db 03,03,03,03,03,03,00,00,00
       db 03,03,00,00,00,00,00,00,00
       db 03,03,00,00,00,00,00,00,00
       db 03,03,00,00,00,00,00,00,00
       db 03,03,03,03,03,03,00,00,00
       db 00,03,03,03,03,00,00,00,00

;------------------------------------------------------------------------------------------------------------------------------------
	 
; coordinates definitions for drawing . . .
xi dw 0
xf dw 0
yi dw 0
yf dw 0


; Coordinates for Duck 1
xi1 dw 50
xf1 dw 58
yi1 dw 50
yf1 dw 58
direction1 db 1
v_direction1 db 1

; Coordinates for Duck 2
xi2 dw 100
xf2 dw 108
yi2 dw 50
yf2 dw 58
direction2 db 1
v_direction2 db 1

; Coordinates for Duck 3
xi3 dw 150
xf3 dw 158
yi3 dw 50
yf3 dw 58
direction3 db 1
v_direction3 db 1


final_score dw ?

direction db 1  ; 1 for right, -1 for left
v_direction db 10
arrow_x dw 160
arrow_y dw 100
last_arrow_x dw 160
last_arrow_y dw 100
score dw 0
round db 1
shot db 0
enter_key_pressed db 0
	
.code
;-----------------------------------------------------MAIN PROC----------------------------------------------------------------------
main proc
    ; Set up data segment
    mov ax, @data
    mov ds, ax

    ; Loop to handle screen transitions
main_loop:
    cmp currentScreen, 1
    je Screen1
    cmp currentScreen, 2
    je Screen2
    cmp currentScreen, 3
    je Screen3
    cmp currentScreen, 4
    je Screen4
    cmp currentScreen, 5
    je Screen5
    cmp currentScreen, 6
    je Screen6
    jmp Exit

Screen1:
    call InitializeGraphics
    call drawstart           
    call WaitForDisplay      
	call setTextMode
    call GetUserInput         ; now i am switching to text mode and get user input . . .
	call displayUserName 
	;call WaitForDisplay
    mov currentScreen, 2      ; setting to transition to Screen 2 . . .
    jmp main_loop             ; Jump back to main loop . . .

WaitForDisplay:
    mov ah, 00h
    int 16h                   ; BIOS wait for keypress, just to view graphics . . .
    ret

Screen2:
    call InitializeGraphics
    call DrawGameTitle
    call WaitForKeypress
    ; checking which key was pressed and set transition to another screen . . .
    cmp al, 'a'         ; If 'A' was pressed, go to Screen 3 . . .
    je GoToScreen3
    cmp al, 'b'         ; If 'B' was pressed, go to Screen 4 . . .
    je GoToScreen4
	cmp al, 'x' ; for EXIT . . .
	je GoToScreen5 ; EXIT SCREEN . . .
	cmp al, 's' ; if s was pressed then we go to instructions
	je GoToScreen6
    jmp Exit

GoToScreen3:
    mov currentScreen, 3      ; setting to transition to Screen 3 . . .
    jmp main_loop             ; jumping back to main loop . . .

GoToScreen4:
    mov currentScreen, 4      ; setting to transition to Screen 4 . . .
    jmp main_loop             ; jumping back to main loop . . .
	
GoToScreen5:
	mov currentScreen, 5
	jmp main_loop

GoToScreen6:
	mov currentScreen, 6
	jmp main_loop
	
WaitForKeypress:
    xor ax, ax        ; clearing AX before calling interrupt . . .
    int 16h           ; BIOS call to wait for key press . . .
    mov ah, 0         ; clearing AH to ensure only the key code in AL is used . . .
    int 16h           ; getting the ASCII code of the pressed key in AL . . .
    ret

Screen3:

	call clearScreen ; clearing the screen for a blank display . . .
    call InitializeGraphics
	call clearBuffer
	call DrawD2 
    call WaitForKeypress   ; waiting for a keypress . . .
    jmp Screen3            

Screen4:
    call clearScreen       ; clearing the screen for a blank display . . .
    call InitializeGraphics   ; waiting for a keypress . . .
	call clearBuffer
	call DrawD
	call WaitForKeypress
    jmp Screen4            
	
Screen5:
	call clearScreen
	jmp Exit ; exitting the program
	
Screen6:
    call clearScreen
    call setTextMode
    ; Display the mode one message
    lea dx, modeOneMessage
    mov ah, 09h
    int 21h
    ; Display the mode two message
    lea dx, modeTwoMessage
    mov ah, 09h
    int 21h
    call WaitForKeypress   ; waiting for a keypress . . .
    cmp al, 08h            ; checking if Backspace key was pressed . . .
    je ReturnToScreen2     ; If Backspace was pressed, jumping to return logic . . .
    jmp Screen6   


ReturnToScreen2:
    mov currentScreen, 2   ; setting to transition back to Screen 2
    jmp main_loop          ; returning to the main loop
	
GoToScreen1:
    mov currentScreen, 1      ; setting to transition to Screen 1
    jmp main_loop             ; Jump back to main loop

	

; clearing screen procedure
clearScreen:
    mov ax, 0A000h
    mov es, ax
    xor di, di
    mov cx, 32000          ; filling half the video buffer size (total 32000 bytes for 320x200 screen) . . .
    xor ax, ax
    rep stosw              ; filling with zeros (black) . . .
    ret

InitializeGraphics:
    mov ax, 0013h           
    int 10h
    ret
	
setTextMode:
    mov ax, 0003h                  
    int 10h
    ret

;-------------------------------input---------------------------------------------

getUserInput:
    ;call setTextMode  
	mov al, 13h
    mov ah, 00h
    int 10H
	
    mov ah, 09h
    lea dx, prompt
    int 21h                        
    lea dx, userName
    mov ah, 0Ah
    int 21h                        
    mov userNameLength, al         
    ret

displayUserName:
    lea dx, userName
    mov ah, 09h
    int 21h                        ; logic to display the entered name (note it is being distorted so i am not using it currently)
    ret
	
;---------------------------------------------------------------------------------	
HandleInput:
    mov ah, 00h
    int 16h      
    mov ah, 0    
    int 16h      
    cmp ah, 48h  
    je MoveLeft
    cmp ah, 4Bh  
    je MoveRight
    ret

MoveLeft:
   dec byte ptr [cursorPosition]
   cmp byte ptr [cursorPosition], MODE_ONE
   jge UpdateDisplay  
   mov byte ptr [cursorPosition], MODE_ONE 
   jmp UpdateDisplay

MoveRight:
   inc byte ptr [cursorPosition]
   cmp byte ptr [cursorPosition], MODE_TWO
   jle UpdateDisplay
   mov byte ptr [cursorPosition], MODE_TWO 
   jmp UpdateDisplay

UpdateDisplay:
    
    call DrawGameTitle  
    jmp HandleInput
clearBuffer:
    lea di, [backBuffer]  ; Load the offset of backBuffer into DI
    xor ax, ax            ; Clear AX to use as the zero value
    mov cx, 16000         ; The buffer is 32000 bytes, so we need 16000 words
    rep stosw             ; Fill the buffer with zeros (16-bit words)
    ret	
	
	
DrawD:
	
	push ds
    mov ax, @data
    mov ds, ax
    mov es, ax
    lea si, [backBuffer]
	
	; switching to graphics mode:
    mov al, 13h
    mov ah, 00h
    int 10H
	call clearBuffer
         
    ; Set coordinates for drawing the 'D'
	;MUD
    mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start:
	mov si, offset mud
    mov yi, 193
    mov yf, 199	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start0:
	mov si, offset mud
    mov yi, 187
    mov yf, 193	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start0
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start1:
	mov si, offset mud
    mov yi, 181
    mov yf, 187	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start1
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start2:
	mov si, offset mud
    mov yi, 175
    mov yf, 181	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start2
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start3:
	mov si, offset mud
    mov yi, 169
    mov yf, 175	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start3
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start4:
	mov si, offset mud
    mov yi, 163
    mov yf, 169	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start4
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start5:
	mov si, offset grass
    mov yi, 157
    mov yf, 163	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start5
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start6:
	mov si, offset grass
    mov yi, 152
    mov yf, 158	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start6
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start7:
	mov si, offset grass
    mov yi, 147
    mov yf, 153	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start7
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start8:
	mov si, offset grass
    mov yi, 142
    mov yf, 148	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start8
	
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start10:
	mov si, offset sky
    mov yi, 122
    mov yf, 142	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start10
	
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start11:
	mov si, offset sky
    mov yi, 102
    mov yf, 122	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start11
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start12:
	mov si, offset sky
    mov yi, 82
    mov yf, 102	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start12
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start13:
	mov si, offset sky
    mov yi, 62
    mov yf, 82	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start13
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start14:
	mov si, offset sky
    mov yi, 42
    mov yf, 62	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start14
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start15:
	mov si, offset sky
    mov yi, 22
    mov yf, 42	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start15
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start16:
	mov si, offset sky
    mov yi, 2
    mov yf, 22	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start16
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_start17:
	mov si, offset sky
    mov yi, 0
    mov yf, 2	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_start17
	
	mov si, offset cloud
	mov xi, 150 ;11 ;256 ;554
    mov xf, 194	;575	;278	;576
    mov yi, 20
    mov yf, 34	;6
	call draw
	
	mov si, offset cloud
	mov xi, 50 ;11 ;256 ;554
    mov xf, 94	;575	;278	;576
    mov yi, 10
    mov yf, 24	;6
	call draw
	
	mov si, offset cloud
	mov xi, 250 ;11 ;256 ;554
    mov xf, 294	;575	;278	;576
    mov yi, 10
    mov yf, 24	;6
	call draw

	mov yi, 50
	mov yf, 56
	mov xi, 0
	mov xf, 9
	
	loop_start20:
	cmp al, 08h            ; checking if Backspace key was pressed . . .
    je ReturnToScreen2 
	call erase_ducks
	call move_duck
    call draw_du
    call draw_arrow
    call draw_score
    call delay_new
	call move_arrow
    jmp loop_start20
			
	mov di, 0A000h ; starting of video buffer . . .
    mov cx, 16000  ; Words to copy (32000 bytes / 2 bytes per word) . . .
    rep movsw      ; copying word sized chunks . . .
        
	; Switching back to text mode:
   ; mov ax, 03h     ; Text mode
    ;int 10h
	;call setTextMode
	
	pop ds
    ret
	
; this is used for mode one
DrawD2:
	
	push ds
    mov ax, @data
    mov ds, ax
    mov es, ax
    lea si, [backBuffer]
	
	; switching to graphics mode:
    mov al, 13h
    mov ah, 00h
    int 10H
	call clearBuffer
         
    ; Set coordinates for drawing the 'D'
	;MUD
    mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting:
	mov si, offset mud
    mov yi, 193
    mov yf, 199	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting0:
	mov si, offset mud
    mov yi, 187
    mov yf, 193	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting0
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting1:
	mov si, offset mud
    mov yi, 181
    mov yf, 187	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting1
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting2:
	mov si, offset mud
    mov yi, 175
    mov yf, 181	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting2
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting3:
	mov si, offset mud
    mov yi, 169
    mov yf, 175	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting3
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting4:
	mov si, offset mud
    mov yi, 163
    mov yf, 169	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting4
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting5:
	mov si, offset grass
    mov yi, 157
    mov yf, 163	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting5
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting6:
	mov si, offset grass
    mov yi, 152
    mov yf, 158	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting6
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting7:
	mov si, offset grass
    mov yi, 147
    mov yf, 153	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting7
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting8:
	mov si, offset grass
    mov yi, 142
    mov yf, 148	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting8
	
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting10:
	mov si, offset sky
    mov yi, 122
    mov yf, 142	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting10
	
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting11:
	mov si, offset sky
    mov yi, 102
    mov yf, 122	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting11
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting12:
	mov si, offset sky
    mov yi, 82
    mov yf, 102	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting12
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting13:
	mov si, offset sky
    mov yi, 62
    mov yf, 82	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting13
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting14:
	mov si, offset sky
    mov yi, 42
    mov yf, 62	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting14
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting15:
	mov si, offset sky
    mov yi, 22
    mov yf, 42	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting15
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting16:
	mov si, offset sky
    mov yi, 2
    mov yf, 22	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting16
	
	mov xi, 0 ;11 ;256 ;554
    mov xf, 8	;575	;278	;576
	loop_starting17:
	mov si, offset sky
    mov yi, 0
    mov yf, 2	;6
	call draw
	add xi, 8
    add xf, 8
    cmp xf, 320
    jle loop_starting17
	
	mov si, offset cloud
	mov xi, 150 ;11 ;256 ;554
    mov xf, 194	;575	;278	;576
    mov yi, 20
    mov yf, 34	;6
	call draw
	
	mov si, offset cloud
	mov xi, 50 ;11 ;256 ;554
    mov xf, 94	;575	;278	;576
    mov yi, 10
    mov yf, 24	;6
	call draw
	
	mov si, offset cloud
	mov xi, 250 ;11 ;256 ;554
    mov xf, 294	;575	;278	;576
    mov yi, 10
    mov yf, 24	;6
	call draw

	mov yi, 50
	mov yf, 56
	mov xi, 0
	mov xf, 9
	
	loop_starting20:
	cmp al, 08h            ; checking if Backspace key was pressed . . .
    je ReturnToScreen2 
	call erase_ducks
	call move_duck
    call draw_duone
    call draw_arrow
    call draw_score
    call delay
	call move_arrow
    jmp loop_starting20
			
	mov di, 0A000h ; starting of video buffer . . .
    mov cx, 16000  ; Words to copy (32000 bytes / 2 bytes per word) . . .
    rep movsw      ; copying word sized chunks . . .
        
	; Switching back to text mode:
   ; mov ax, 03h     ; Text mode
    ;int 10h
	;call setTextMode
	
	pop ds
    ret	

draw_duone proc
    ; Duck 1
    mov si, offset duck
    mov ah, 0ch
    mov dx, yi1  ; y coordinate initial (up down)
drawing_duck1_y:
    mov cx, xi1  ; x coordinate initial (left right)
drawing_duck1_x:
    mov al, [si]  ; start array
    int 10h
    inc si  ; increment full row (x axis)
    inc cx
    cmp cx, xf1  ; x coordinate final (left right)
    jb drawing_duck1_x
    inc dx  ; jump to next row
    cmp dx, yf1  ; y coordinate final (up down)
    jb drawing_duck1_y	
	ret
draw_duone endp
		
draw_du proc
    ; Duck 1
    mov si, offset duck
    mov ah, 0ch
    mov dx, yi1  ; y coordinate initial (up down)
draw_duck1_y:
    mov cx, xi1  ; x coordinate initial (left right)
draw_duck1_x:
    mov al, [si]  ; start array
    int 10h
    inc si  ; increment full row (x axis)
    inc cx
    cmp cx, xf1  ; x coordinate final (left right)
    jb draw_duck1_x
    inc dx  ; jump to next row
    cmp dx, yf1  ; y coordinate final (up down)
    jb draw_duck1_y

    ; Duck 2
    mov si, offset duck2
    mov dx, yi2  ; y coordinate initial (up down)
draw_duck2_y:
    mov cx, xi2  ; x coordinate initial (left right)
draw_duck2_x:
    mov al, [si]  ; start array
    int 10h
    inc si  ; increment full row (x axis)
    inc cx
    cmp cx, xf2  ; x coordinate final (left right)
    jb draw_duck2_x
    inc dx  ; jump to next row
    cmp dx, yf2  ; y coordinate final (up down)
    jb draw_duck2_y

    ; Duck 3
    mov si, offset duck3
    mov dx, yi3  ; y coordinate initial (up down)
draw_duck3_y:
    mov cx, xi3  ; x coordinate initial (left right)
draw_duck3_x:
    mov al, [si]  ; start array
    int 10h
    inc si  ; increment full row (x axis)
    inc cx
    cmp cx, xf3  ; x coordinate final (left right)
    jb draw_duck3_x
    inc dx  ; jump to next row
    cmp dx, yf3  ; y coordinate final (up down)
    jb draw_duck3_y

    ret
draw_du endp


draw_arrow proc
    ; Erase the previous position of the arrow
    mov ah, 0ch
    mov cx, last_arrow_x
    mov dx, last_arrow_y
    mov al, 09  ; blue pixel to clear (assuming the background is blue)
    int 10h

    ; Draw the current position of the arrow
    mov cx, arrow_x
    mov dx, arrow_y
    mov al, 15  ; white arrow
    int 10h

    ; Update the last position of the arrow
    mov last_arrow_x, cx
    mov last_arrow_y, dx
    ret
draw_arrow endp

draw_score proc
    mov dx, 0000h  ; Move cursor to top left corner
    mov ah, 02h
    int 10h

    mov al, round
    call display_number

    mov dx, 0100h  ; Move cursor to next line
    mov ah, 02h
    int 10h

    mov ax, score
    call display_number

    ret
draw_score endp

display_number proc
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    xor cx, cx

    ; Convert number to string
next_digit:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne next_digit

    ; Display number
    mov ah, 02h
display_digits:
    pop dx
    add dl, '0'
    int 21h
    loop display_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_number endp

erase_ducks proc
    ; Erase Duck 1
    mov si, offset duck
    mov ah, 0ch
    mov dx, yi1  ; y coordinate initial (up down)
erase_duck1_y:
    mov cx, xi1  ; x coordinate initial (left right)
erase_duck1_x:
    mov al, 09h  ; background color to erase the duck (assuming the background is blue)
    int 10h
    inc cx
    cmp cx, xf1  ; x coordinate final (left right)
    jb erase_duck1_x
    inc dx  ; jump to next row
    cmp dx, yf1  ; y coordinate final (up down)
    jb erase_duck1_y

    ; Erase Duck 2
    mov dx, yi2  ; y coordinate initial (up down)
erase_duck2_y:
    mov cx, xi2  ; x coordinate initial (left right)
erase_duck2_x:
    mov al, 09h  ; background color to erase the duck (assuming the background is blue)
    int 10h
    inc cx
    cmp cx, xf2  ; x coordinate final (left right)
    jb erase_duck2_x
    inc dx  ; jump to next row
    cmp dx, yf2  ; y coordinate final (up down)
    jb erase_duck2_y

    ; Erase Duck 3
    mov dx, yi3  ; y coordinate initial (up down)
erase_duck3_y:
    mov cx, xi3  ; x coordinate initial (left right)
erase_duck3_x:
    mov al, 09h  ; background color to erase the duck (assuming the background is blue)
    int 10h
    inc cx
    cmp cx, xf3  ; x coordinate final (left right)
    jb erase_duck3_x
    inc dx  ; jump to next row
    cmp dx, yf3  ; y coordinate final (up down)
    jb erase_duck3_y

    ret
erase_ducks endp


move_duck proc
    call erase_ducks

    ; Move Duck 1 horizontally
    mov al, direction1
    cbw                 ; Convert byte to word to use it with xi and xf
    add xi1, ax
    add xf1, ax

    ; Check boundaries for Duck 1 horizontal movement
    cmp xf1, 319
    jle skip_right1
    mov direction1, -1
skip_right1:
    cmp xi1, 0
    jge skip_left1
    mov direction1, 1
skip_left1:
    ; Move Duck 1 vertically
    mov al, v_direction1
    cbw
    add yi1, ax
    add yf1, ax

    cmp yf1, 135
    jle skip_down1
    mov v_direction1, -1
skip_down1:
    cmp yi1, 40
    jge skip_up1
    mov v_direction1, 1
skip_up1:

    ; Move Duck 2 horizontally
    mov al, direction2
    cbw
    add xi2, ax
    add xf2, ax

    ; Check boundaries for Duck 2 horizontal movement
    cmp xf2, 319
    jle skip_right2
    mov direction2, -1
skip_right2:
    cmp xi2, 0
    jge skip_left2
    mov direction2, 1
skip_left2:
    ; Move Duck 2 vertically
    mov al, v_direction2
    cbw
    add yi2, ax
    add yf2, ax

    cmp yf2, 135
    jle skip_down2
    mov v_direction2, -1
skip_down2:
    cmp yi2, 40
    jge skip_up2
    mov v_direction2, 1
skip_up2:

    ; Move Duck 3 horizontally
    mov al, direction3
    cbw
    add xi3, ax
    add xf3, ax

    ; Check boundaries for Duck 3 horizontal movement
    cmp xf3, 319
    jle skip_right3
    mov direction3, -1
skip_right3:
    cmp xi3, 0
    jge skip_left3
    mov direction3, 1
skip_left3:
    ; Move Duck 3 vertically
    mov al, v_direction3
    cbw
    add yi3, ax
    add yf3, ax

    cmp yf3, 135
    jle skip_down3
    mov v_direction3, -1
skip_down3:
    cmp yi3, 40
    jge skip_up3
    mov v_direction3, 1
skip_up3:

    ret
move_duck endp

move_arrow proc
    mov ah, 01h  ; Check if a key is pressed
    int 16h
    jz no_key_pressed

    mov ah, 00h  ; Get the key press
    int 16h

    ; Handle extended key codes
    cmp ah, 0
    je handle_extended_key

    cmp ah, 48h  ; up arrow key
    je move_up
    cmp ah, 50h  ; down arrow key
    je move_down
    cmp ah, 4Bh  ; left arrow key
    je move_left
    cmp ah, 4Dh  ; right arrow key
    je move_right
    cmp ah, 1Ch  ; ENTER key
    je shoot
    jmp no_key_pressed

handle_extended_key:
    mov ah, 10h
    int 16h

    cmp al, 48h  ; up arrow key
    je move_up
    cmp al, 50h  ; down arrow key
    je move_down
    cmp al, 4Bh  ; left arrow key
    je move_left
    cmp al, 4Dh  ; right arrow key
    je move_right
    cmp al, 1Ch  ; ENTER key
    je shoot
    jmp no_key_pressed

no_key_pressed:
    ; Reset the shot flag if ENTER is released
    mov ah, 01h  ; Check if a key is pressed
    int 16h
    jz clear_shot

    mov ah, 00h  ; Get the key press
    int 16h

    cmp ah, 1Ch  ; ENTER key
    jne clear_shot
    mov enter_key_pressed, 1
    jmp no_key_pressed

clear_shot:
    mov enter_key_pressed, 0
    mov shot, 0  ; Reset shot flag
    ret

move_left:
    cmp arrow_x, 5
    jle no_key_pressed
    sub arrow_x, 5
    jmp no_key_pressed

move_right:
    cmp arrow_x, 314
    jge no_key_pressed
    add arrow_x, 5
    jmp no_key_pressed

move_up:
    cmp arrow_y, 5
    jle no_key_pressed
    sub arrow_y, 5
    jmp no_key_pressed

move_down:
    cmp arrow_y, 194
    jge no_key_pressed
    add arrow_y, 5
    jmp no_key_pressed

shoot:
    cmp shot, 1  ; Check if a shot was already taken
    je no_key_pressed
    cmp enter_key_pressed, 0
    jne no_key_pressed
    mov enter_key_pressed, 1
    call check_arrow_shoot
    mov shot, 1
    jmp no_key_pressed
move_arrow endp

check_arrow_shoot proc
    ; Check if arrow is over Duck 1
    mov ax, arrow_x
    cmp ax, xi1
    jl no_hit1
    cmp ax, xf1
    jg no_hit1

    mov ax, arrow_y
    cmp ax, yi1
    jl no_hit1
    cmp ax, yf1
    jg no_hit1

    ; Duck 1 hit logic
    call duck_hit
    jmp end_check_arrow_shoot

no_hit1:
    ; Check if arrow is over Duck 2
    mov ax, arrow_x
    cmp ax, xi2
    jl no_hit2
    cmp ax, xf2
    jg no_hit2

    mov ax, arrow_y
    cmp ax, yi2
    jl no_hit2
    cmp ax, yf2
    jg no_hit2

    ; Duck 2 hit logic
    call duck_hit
    jmp end_check_arrow_shoot

no_hit2:
    ; Check if arrow is over Duck 3
    mov ax, arrow_x
    cmp ax, xi3
    jl no_hit3
    cmp ax, xf3
    jg no_hit3

    mov ax, arrow_y
    cmp ax, yi3
    jl no_hit3
    cmp ax, yf3
    jg no_hit3

    ; Duck 3 hit logic
    call duck_hit

no_hit3:
end_check_arrow_shoot:
    ret
check_arrow_shoot endp

duck_hit proc
    inc score
    cmp score, 5
    jne round_check_2
    cmp round, 1
    jne end_duck_hit
    inc round
    mov score, 0
    jmp end_duck_hit

round_check_2:
    cmp score, 10
    jne round_check_3
    cmp round, 2
    jne end_duck_hit
    inc round
    mov score, 0
    jmp end_duck_hit

round_check_3:
    cmp score, 20
    jne end_duck_hit
    cmp round, 3
    jne end_duck_hit
    ; Round 3 is over, reset round and score, and return to menu
    mov round, 1
    mov score, 0
    mov currentScreen, 2  ; Return to the game menu
    jmp main_loop
	
end_duck_hit:
    ret
duck_hit endp


; for mode one
delay proc
    push cx
    mov cx, 0FFFFh
delay_loop:
    loop delay_loop
    pop cx
    ret
delay endp

; for mode two
delay_new proc
    push cx
    mov cx, 7FFFh ; Reduced value for faster movement
delay1_loop:
    loop delay1_loop
    pop cx
    ret
delay_new endp


DrawGameTitle:
	   ; switching to back buffer for drawing
    push ds
    mov ax, @data
    mov ds, ax
    mov es, ax
    lea si, [backBuffer]
	
	; switching to graphics mode:
    mov al, 13h
    mov ah, 00h
    int 10H
		; ------------------------------Displaying the title of the game-------------------------------
		
    ; Set coordinates and draw the 'D'
	mov bh, 03h           ; 
    mov si, offset green_D
    mov yi, 60
    mov yf, 66
    mov xi, 90
    mov xf, 99
    call draw
		
    ; setting coordinates and draw the 'U' right after 'D'
    mov si, offset Hert2
    mov yi, 60      
    mov yf, 66      
    mov xi, 100     
    mov xf, 109     
    call draw

    ; setting coordinates and draw the 'C' right after 'U'
    mov si, offset Hert3
    mov yi, 60     
    mov yf, 66     
    mov xi, 110    
    mov xf, 119    
    call draw

    ; setting coordinates and draw the 'K' right after 'C'
    mov si, offset Hert4
    mov yi, 60     
    mov yf, 66     
    mov xi, 120    
    mov xf, 129    
    call draw
	
    ; setting coordinates and draw the 'H' right after 'K'
    mov si, offset green_H
    mov yi, 60      
    mov yf, 66      
    mov xi, 135     
    mov xf, 144     
    call draw
	
	; setting coordinates and draw the 'U' right after 'H'
    mov si, offset green_U
    mov yi, 60      
    mov yf, 66     
    mov xi, 145    
    mov xf, 154    
    call draw
	
	; setting coordinates and draw the 'N' right after 'U'
    mov si, offset green_N
    mov yi, 60      
    mov yf, 66      
    mov xi, 155     
    mov xf, 164     
    call draw
	
	; setting coordinates and draw the 'T' right after 'N'
    mov si, offset green_T
    mov yi, 60      
    mov yf, 66       
    mov xi, 165    
    mov xf, 174     
    call draw
	
		;-------------------------------------MODE ONE------------------------------------------------
	; for M
	mov si, offset s7_2
    mov yi, 75
    mov yf, 81
    mov xi, 90
    mov xf, 99
    call draw
	
	; O
	mov si, offset bold_O
    mov yi, 75
    mov yf, 81
    mov xi, 100
    mov xf, 109
    call draw
	
	; D
	mov si, offset Hert
    mov yi, 75
    mov yf, 81
    mov xi, 110
    mov xf, 119
    call draw
	
	; E
	mov si, offset bold_E
    mov yi, 75
    mov yf, 81
    mov xi, 120
    mov xf, 129
    call draw
	
	; O again
	mov si, offset bold_O
    mov yi, 75     
    mov yf, 81      
    mov xi, 135     
    mov xf, 144     
    call draw
	
	; N 
	mov si, offset cyan_N
    mov yi, 75     
    mov yf, 81      
    mov xi, 145     
    mov xf, 154     
    call draw
	
	; E again
	mov si, offset bold_E
    mov yi, 75
    mov yf, 81
    mov xi, 155
    mov xf, 164
    call draw
	
	;---------------------------------------- Now for MODE TWO-------------------------------------------------
		; for M
	mov si, offset s7_2
    mov yi, 90
    mov yf, 96
    mov xi, 90
    mov xf, 99
    call draw
	
	; O
	mov si, offset bold_O
    mov yi, 90
    mov yf, 96
    mov xi, 100
    mov xf, 109
    call draw
	
	; D
	mov si, offset Hert
    mov yi, 90
    mov yf, 96
    mov xi, 110
    mov xf, 119
    call draw
	
	; E
	mov si, offset bold_E
    mov yi, 90
    mov yf, 96
    mov xi, 120
    mov xf, 129
    call draw
	
	; T 
	mov si, offset cyan_T
    mov yi, 90     
    mov yf, 96      
    mov xi, 135     
    mov xf, 144     
    call draw
	
	; W
	mov si, offset bold_W
    mov yi, 90     
    mov yf, 96      
    mov xi, 145     
    mov xf, 154     
    call draw
	
	; O again
	mov si, offset bold_O
    mov yi, 90
    mov yf, 96
    mov xi, 155
    mov xf, 164
    call draw
	
	; drawing INSTRUCTIONS
	; I
	mov si, offset bold_I
    mov yi, 105
    mov yf, 111
    mov xi, 90
    mov xf, 99
    call draw
	
	; N
	mov si, offset cyan_N
    mov yi, 105
    mov yf, 111
    mov xi, 97
    mov xf, 106
    call draw
	
	; S
	mov si, offset bold_S
    mov yi, 105
    mov yf, 111
    mov xi, 107
    mov xf, 116
    call draw
	
	; T
	mov si, offset cyan_T
    mov yi, 105
    mov yf, 111
    mov xi, 117
    mov xf, 126
    call draw
	
	; R
	mov si, offset bold_R
    mov yi, 105
    mov yf, 111
    mov xi, 127
    mov xf, 136
    call draw
	
	; U
	mov si, offset bold_U
    mov yi, 105
    mov yf, 111
    mov xi, 137
    mov xf, 146
    call draw
	
	; C
	mov si, offset cyan_C
    mov yi, 105
    mov yf, 111
    mov xi, 147
    mov xf, 156
    call draw
	
	; T
	mov si, offset cyan_T
    mov yi, 105
    mov yf, 111
    mov xi, 157
    mov xf, 166
    call draw
	
	; I
	mov si, offset bold_I
    mov yi, 105
    mov yf, 111
    mov xi, 167
    mov xf, 176
    call draw
	
	;O
	mov si, offset bold_O
    mov yi, 105
    mov yf, 111
    mov xi, 174
    mov xf, 183
    call draw
	
	; N
	mov si, offset cyan_N
    mov yi, 105
    mov yf, 111
    mov xi, 185
    mov xf, 194
    call draw
	
	; S
	mov si, offset bold_S
    mov yi, 105
    mov yf, 111
    mov xi, 197
    mov xf, 206
    call draw
	
	
	; Drawing Exit
	mov si, offset bold_E
    mov yi, 120
    mov yf, 126
    mov xi, 90
    mov xf, 99
    call draw
	
	; X
	mov si, offset thick_X
    mov yi, 120
    mov yf, 126
    mov xi, 100
    mov xf, 109
    call draw
	
	; I
	mov si, offset bold_I
    mov yi, 120
    mov yf, 126
    mov xi, 110
    mov xf, 119
    call draw
	
	; T
	mov si, offset cyan_T
    mov yi, 120
    mov yf, 126
    mov xi, 120
    mov xf, 129
    call draw
	
	mov di, 0A000h ; starting of video buffer . . .
    mov cx, 16000  ; Words to copy (32000 bytes / 2 bytes per word) . . .
    rep movsw      ; copying word sized chunks . . .
    pop ds
    ret
	
drawstart:
	
	   ; clearing the screen first to ensure no leftovers . . .
    mov ax, 0A000h
    mov es, ax
    xor di, di
    mov cx, 16000  ; filling half the video buffer size (total 64000 bytes for 320x200 screen) . . .
    xor ax, ax
    rep stosw      ; Fill with zeros (aka black) . . .
	
	mov ax, @data
    mov ds, ax
    
    ; Set video mode to 320x200, 256 colors
    mov al, 13h
    mov ah, 00h
    int 10H

	
    ; Drawing ENTER NAME . . .
	; Drawing E
    mov si, offset s6
    mov yi, 60
    mov yf, 67
    mov xi, 90
    mov xf, 99
    call draw
	
	; drawing a heart
	mov si, offset heart
    mov yi, 75
    mov yf, 81
    mov xi, 135
    mov xf, 144
    call draw

	; drawing N
    mov si, offset Hert7
    mov yi, 60      
    mov yf, 66      
    mov xi, 100     
    mov xf, 109     
    call draw
	
	; now drawing T
    mov si, offset Hert8
    mov yi, 60      
    mov yf, 66       
    mov xi, 110    
    mov xf, 119     
    call draw
	
	; E again
	mov si, offset s6
    mov yi, 60
    mov yf, 66
    mov xi, 120
    mov xf, 129
    call draw
	
	; now drawing R
	mov si, offset s2
    mov yi, 60
    mov yf, 66
    mov xi, 130
    mov xf, 139
    call draw
	
	; now N
    mov si, offset Hert7
    mov yi, 60      
    mov yf, 66      
    mov xi, 145    
    mov xf, 154     
    call draw
	
	; now A
	mov si, offset s3
    mov yi, 60      
    mov yf, 66      
    mov xi, 155   
    mov xf, 164    
    call draw
	
	; now M
	mov si, offset s7
    mov yi, 60      
    mov yf, 66      
    mov xi, 165   
    mov xf, 174    
    call draw
	
	; E again
    mov si, offset s6
    mov yi, 60
    mov yf, 66
    mov xi, 175
    mov xf, 184
    call draw

    ret

; Ending the program
Exit:
    mov ax, 4C00h
    int 21h 

main endp

;-------------------------------------------------------------------------------------------------------------------

; Drawing procedure to plot the letters on screen with variable colors from table . . .
draw proc
   
    mov dx, yi      ; Y coordinate start . . .
y_loop:
    mov cx, xi      ; X coordinate start . . .
x_loop:
    mov al, [si]    ; getting the pixel color value from data . . .
    or al, al       ; checking if pixel is 0 (transparent) . . .
    jz  skip_pixel  ; If zero, don't draw (transparent) . . .
    mov ah, 0Ch     ; Function to plot pixel . . .
    mov bh, 0       ; Page number, usually 0 . . .
	
    int 10h         ; drawing pixel . . .
skip_pixel:
    inc si          ; moving to next pixel in data . . .
    inc cx          ; incrementing X coordinate . . .
    cmp cx, xf      ; checking if end of X reached . . .
    jb x_loop
    inc dx          ; moving to next line in Y . . .
    cmp dx, yf      ; checking if end of Y reached . . .
    jb y_loop
    ret
draw endp

draw_d proc
    mov si, offset duck
    mov ah, 0ch
    mov dx, yi  ; y coordinate initial (up down)
y1:
    mov cx, xi  ; x coordinate initial (left right)
x1:
    mov al, [si]  ; start array
    int 10h
    inc si  ; increment full row (x axis)
    inc cx
    cmp cx, xf  ; x coordinate final (left right)
    jb x1
    inc dx  ; jump to next row
    cmp dx, yf  ; y coordinate final (up down)
    jb y1
    ret

draw_d endp

end