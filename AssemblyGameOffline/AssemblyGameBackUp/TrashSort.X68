*-----------------------------------------------------------
* Title      : Trash Sort
* Written by : Haley Park
* Date       :
* Description: A game where the player must sort as much recycling and trash before the time runs out
*-----------------------------------------------------------
DISPLAY_SCORE           EQU     15
PRINT_STRING            EQU     95
DOUBLE_BUFFERED_MODE	EQU     17
REPAINT_SCREEN_COMMAND	equ	    94
CLEAR_SCREEN_COMMAND    equ     11
CLEAR_SCREEN_MAGIC_VAL  equ     $FF00
DRAWING_MODE_COMMAND	equ	    92

DISPLAY_STRING          EQU     95

ENTER_GAMELOOP_INPUT    EQU     5

PEN_COLOR_COMMAND       EQU     80
FILL_COLOR_COMMAND      EQU     81
BACKGROUND_COLOR        EQU     $009C6258
FLOOD_FILL_COMMAND      EQU     89
DRAW_RECTANGLE          EQU     87

GET_TIME_COMMAND        EQU     8

RECYCLE_BIN             EQU     1    
TRASH_BIN               EQU     3  
KEEP_BIN                EQU     2 

    ORG    $1000
START:                  ; first instruction of program
**********************************************************************
* Initialization
**********************************************************************
MainInitialize
        
      	move.l      #0,randomObjPosY
        move.l      #300,randomObjPosX
        move.l      #0,score
        jsr         setScreenResolution  
      	
      	jsr         FillBackground
      	
      	jsr         DisplayEnterScreen
      	;jsr         GetTime
        
        *set double buffered mode                   
      	move.b	    #DRAWING_MODE_COMMAND,d0
      	move.b	    #DOUBLE_BUFFERED_MODE,d1
      	trap	    #15   	
      	
WaitForEnter
        jsr         RestartScreen
        jsr         FillBackground
      	jsr         DisplayLoadingScreen
      	move.l      #ENTER_GAMELOOP_INPUT,d0
      	trap        #15
      	
      	cmpi.b      #$0D,d1
      	beq         GameLoopInitialize
      	
      	bra         WaitForEnter
      	
GameLoopInitialize
         ;jsr         DisplayBackground 
         jsr         SwapBuffers  
      	
**********************************************************************
* GameLoop
**********************************************************************   
GameLoop     
        ;jsr         FindTimeBasedMovement

         jsr        Update
*--------------------------------------------------        
*        *drop random object in place
        cmpi.l      #160,randomObjPosY
        bgt         ObjDropEnd
        
        jsr         RandomObjDrop
        bra         GameLoop
        
ObjDropEnd
        * input subroutines
        jsr         InitData

        jsr         CheckInput
   
*-------------------------------------------------------------------- 
        * set curr frame key press to true
        move.l      #0,currentFrameKeyDown
        
        * if there is no input, set current frame key press to false
        cmpi.l      #0,d7
        bne         EndGameLoop
        move.l      #1,currentFrameKeyDown
        
*--------------------------------------------------------------------
        * compare last frame and curr frame to see if the key is held down
        move.l  lastFrameKeyDown,d0
        add.l   currentFrameKeyDown,d0
        cmpi.l  #2,d0
        beq     EndGameLoop
        
        * Occurs every key up
* -------------------------------------------------------------------
ObjInputMove       
        jsr     ObjMovement
        move.l  #1,d0
        jsr     Update
        bra     ObjInputMove
        
ObjInputMoveEnd
        add.l   #4,sp
 *----------------------------------------------------------------------
        jsr     CheckObjSorted
        jsr     RandomObjGenerator
        lea     randomObjToSort,a3
        move.l  d7,(a3)
        
        * reset obj pos Y&X
        move.l      #280,randomObjPosX
        move.l      #0,randomObjPosY
        jsr         CalcScore
        
        
EndGameLoop         
        
        * record curr frame value for comparison in next frame
        lea         LastFrameKeyDown,a2
        move.l      currentFrameKeyDown,(a2)
        
        jsr         SwapBuffers

        bra         GameLoop


**********************************************************************
* Subroutines
**********************************************************************
Update      
        jsr         RestartScreen
        
        jsr         FillBackground

        jsr         DisplayBinLabels
        
        jsr         DisplayScore
        
        jsr         DisplayRandomObj
        
        jsr         SwapBuffers
        
        ;jsr         ObjInval
         
        rts
        
DisplayBinLabels
*recycle bin label
        move.l      #DISPLAY_STRING,d0
        move.w      #10,d1
        move.w      #140,d2
        lea         recycleString,a1
        trap        #15
        
*trash bin label
        move.l      #DISPLAY_STRING,d0
        move.w      #590,d1
        move.w      #140,d2
        lea         trashString,a1
        trap        #15
        
*keep bin label
        move.l      #DISPLAY_STRING,d0
        move.w      #315,d1
        move.w      #450,d2
        lea         keepString,a1
        trap        #15
        
        rts
        
        
ObjInval
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$009C6258,d1
        trap        #15
        
        move.l      #FILL_COLOR_COMMAND,d0
        trap        #15

        move.l      #DRAW_RECTANGLE,d0
        move.w      randomObjPosX,d1
        move.w      randomObjPosY,d2
        add.w       randomObjHeight,d2
        move.w      randomObjPosX,d3
        add.w       randomObjWidth,d3
        move.w      randomObjHeight,d4
        trap        #15
        rts
        
        
DisplayLoadingScreen
        move.l      #200,d1 ; Screen Position X
        move.l      #215,d2 ; Screen  Position Y
        move.l      #630,d3 ; Selection Position X
        move.l      #548,d4 ; Selection Position Y
        move.l      #65,d5 ;HEIGHT
        move.l      #275,d6 ;WIDTH
        jsr         DisplayRandomObjEnd
        rts        
DisplayEnterScreen
        move.l      #155,d1 ; Screen Position X
        move.l      #155,d2 ; Screen  Position Y
        move.l      #18,d3 ; Selection Position X
        move.l      #483,d4 ; Selection Position Y
        move.l      #180,d5 ;HEIGHT
        move.l      #374,d6 ;WIDTH
        jsr         DisplayRandomObjEnd
        rts
        
DisplayBackground
        move.l      #0,d1 ; Screen Position X
        move.l      #0,d2 ; Screen  Position Y
        move.l      #0,d3 ; Selection Position X
        move.l      #0,d4 ; Selection Position Y
        move.l      #480,d5 ;HEIGHT
        move.l      #680,d6 ;WIDTH
        jsr         DisplayRandomObjEnd
        rts        
 
FindTimeBasedMovement
        move.l      currentFrameTime,lastFrameTime
        jsr         GetTime
        jsr         CalcDeltaTime
        jsr         CalcVelocity 
        rts
        
GetTime
        move.l      #GET_TIME_COMMAND,d0
        trap        #15
        
        move.l      d1,currentFrameTime
        rts
        
CalcDeltaTime
        move.l       currentFrameTime,d0
        sub.l        lastFrameTime,d0
        move.w       d0,deltaTime
        rts

* calc for time-based movement       
CalcVelocity
        move.l      velocity,d0
        mulu.w      deltaTime,d0
        move.l      d0,velocity
        rts
        
FillBackground
        move.l      #FILL_COLOR_COMMAND,d0
        move.l      #BACKGROUND_COLOR,d1
        trap        #15
        
        move.l      #FLOOD_FILL_COMMAND,d0
        move.w      #0,d1
        move.w      #0,d2
        trap        #15
        rts

RandomObjDrop
        * change in position
        
        move.l      randomObjPosY,d0
        add.l       velocity,d0
        move.l      d0,randomObjPosY
       
*        move.l      randomObjPosY,d0
        
        * velocity * position
*        move.l      velocity,d1
*        mulu.w      d1,d0
*        move.l      d0,randomObjPosY
        
        
*        jsr         DisplayRandomObj  
*        jsr         SwapBuffers
        rts
        
        
     
* Testing Purposes      
DisplayRandomNum
        * returns random value through d7
        move.l      #DISPLAY_SCORE,d0
        move.l      randomObjToSort,d1
        move.b      #10,d2
        trap        #15   
        rts
        
        
DisplayScore
        
        move.l      #DISPLAY_SCORE,d0
        move.l      score,d1
        move.b      #10,d2
        trap        #15   
        rts   
        
CalcScore
        * adding to score
        move.l      #0,d0
        lea         score,a2
        add.l       pointsToAdd,d0
        add.l       d0,(a2)
        rts
	    
SwapBuffers
	    move.b  #REPAINT_SCREEN_COMMAND,d0
      	trap    #15
	    rts        	    
        
    SIMHALT             ; halt simulator        
* Put program code here


    INCLUDE             "Movement.X68"
    INCLUDE             "CheckObjectType.X68"
    INCLUDE             "BMP_32Bit_Subroutine.X68"
    INCLUDE             "RandomObjectGenerator.X68"
    INCLUDE             "DisplayRandomObject.X68"
    
LastFrameKeyDown    dc.l    1
CurrentFrameKeyDown ds.l    1
LastFrameTime       ds.l    1
CurrentFrameTime    ds.l    1
deltaTime           ds.l    1

randomObjPosX       dc.l    280
randomObjPosY       dc.l    0  
randomObjHeight     ds.l    1
randomObjWidth      ds.l    1 

velocity            dc.l    80
    
screenHeight        dc.w    480
screenWidth         dc.w    680
chosenBin           dc.l    0
sortedObj           dc.l    1
score               dc.l    0
randomObjToSort     dc.l    1
pointsToAdd         dc.l    0

CR                  EQU     $0D
LF                  EQU     $0A

scoreString         dc.b    '$',0

recycleString       dc.b    'RECYCLE BIN',CR,LF,0
                    
trashString         dc.b    'TRASH BIN',CR,LF,0
                    
keepString          dc.b    'KEEP',CR,LF,0



    END    START        ; last line of source

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
