*-----------------------------------------------------------
* Title      : Trash Sort
* Written by : Haley Park
* Date       :
* Description: A game where the player must sort as much recycling and trash before the time runs out
*-----------------------------------------------------------
DISPLAY_SCORE           EQU     15
DOUBLE_BUFFERED_MODE	EQU     17
REPAINT_SCREEN_COMMAND	equ	    94
CLEAR_SCREEN_COMMAND    equ     11
CLEAR_SCREEN_MAGIC_VAL  equ     $FF00
DRAWING_MODE_COMMAND	equ	    92

    ORG    $1000
START:                  ; first instruction of program

        move.l      #200,-(sp) ; Screen pos x
        move.l      #200,-(sp) ; Screen pos y
        move.l      #0,-(sp) ; Selection Position X
        move.l      #0,-(sp) ; Selection Position Y
        move.l      #360,-(sp) ;HEIGHT
        move.l      #360,-(sp) ;WIDTH
        ;jsr         Display
        
        *set double buffered mode                   ; What does this mean? Why is it useful?
      	move.b	#DRAWING_MODE_COMMAND,d0
      	move.b	#DOUBLE_BUFFERED_MODE,d1
      	trap	#15
    
GameLoop
        jsr         RestartScreen
        
        jsr         DrawSquare
 
        jsr         DisplayScore
        
        jsr         RandomObjGenerator
        
        jsr         DisplayObject
        
        clr.l       d7
        
        jsr         InitData

        jsr         CheckInput
        
        * d7 contains the return value of the player's input (which bin the obj was sorted into)
        move.l      d7,chosenBin
        
        jsr         swapBuffers
        ;move.l      sortedObj,-(sp)
         
        
        bra         GameLoop

DisplayObject
        move.l      #DISPLAY_SCORE,d0
        move.l      d7,d1
        move.b      #10,d2
        trap        #15   
        rts 
        
DisplayScore
        move.l      #DISPLAY_SCORE,d0
        move.l      score,d1
        move.b      #10,d2
        trap        #15   
        rts   
         
	    
swapBuffers
	    move.b  #REPAINT_SCREEN_COMMAND,d0
      	trap    #15
	    rts        	    
        
    SIMHALT             ; halt simulator        
* Put program code here


    INCLUDE             "Movement.X68"
    ;INCLUDE             "CheckObjectType.X68"
    ;INCLUDE             "BMP_32Bit_Subroutine.X68"
    INCLUDE             "RandomObjectGenerator.X68"
    
ScreenHeight        dc.w    720
ScreenWidth         dc.w    1080
chosenBin      ds.l    1
sortedObj      dc.l    1
score          dc.l    0


    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
