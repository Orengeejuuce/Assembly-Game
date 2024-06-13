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

CONST_VELOCITY          EQU     12

ENTER_GAMELOOP_INPUT    EQU     5

PEN_COLOR_COMMAND       EQU     80
FILL_COLOR_COMMAND      EQU     81
BACKGROUND_COLOR        EQU     $00DCA399
FLOOD_FILL_COMMAND      EQU     89
DRAW_RECTANGLE          EQU     87

GET_TIME_COMMAND        EQU     8
FRACTIONAL_BITS         EQU     2

    ORG    $1000
START:                  ; first instruction of program
**********************************************************************
* Initialization
**********************************************************************
MainInitialize
        move.l      #0,chosenBin
        move.l      #0,score
        move.l      #6000,time
        jsr         setScreenResolution  
      	
      	jsr         FillBackground
      	
      	jsr         DisplayEnterScreen
      	
      	jsr         RandomBinGenerator
      	
      	jsr         SoundInitialize
      
        
        *set double buffered mode                   
      	move.b	    #DRAWING_MODE_COMMAND,d0
      	move.b	    #DOUBLE_BUFFERED_MODE,d1
      	trap	        #15   	
      	
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
         jsr         SwapBuffers
         jsr         PlayBackgroundMusic
         jsr         RestartScreen
         jsr         DisplayBackground 
         jsr         DisplayAllBins
         jsr         SwapBuffers  
         jsr         GetTime
      	
**********************************************************************
* GameLoop
********************************************************************** 
GameLoop
        
        
        jsr         FindDeltaTime ; finds time-based velocity


       
        jsr         CalcVelocity 
        
        
        
        cmpi.l      #1,time
        blt         GameOver
        
        move.l      randomObjPosX,invalPosX
        move.l      randomObjPosY,invalPosY
        
        cmpi.l      #0,objIsMoving
        beq         InputObjMovement
        
        cmpi.l      #0,objDropped
        beq         Input
        
        * if obj is not at the center yet, keep updating its position and render it until it is
        move.l      randomObjPosY,d0
        cmp.l       objDropCenterPos,d0
        beq         Input
        
        move.l      #200,d0
        sub.l       randomObjPosY,d0
        cmp.l       #200,d0
        bgt         Update
        
        *last frame before obj reaches center
*-----------------------------------------------------------------------------------------
        * randomly generates new locations for bins every 10 seconds
*        move.l      binMixCounter,d0
*        divu.w      #10,d0
*        swap        d0

        move.l      score,d0
        cmpi.w      #100,d0
        bne         centerInval
        
        jsr         SwapBuffers
         
        jsr         RandomBinGenerator
        jsr         PauseTimer
        
        
CenterInval        
        jsr         objInval
        move.l      objDropCenterPos,randomObjPosY
        bra         render
        
Input
        
        
        * record curr frame value for comparison in next frame
        lea         lastFrameKeyDown,a2
        move.l      currentFrameKeyDown,(a2)
    
        move.l      #0,objDropped
        move.l      #1,currentFrameKeyDown
        
        jsr         InitData
        jsr         CheckInput
        bra         ObjDropComplete
    
Update 
        * checks to see if obj has finished dropping
        cmpi.l      #0,objDropped
        beq         objDropComplete

        jsr         objInval
        jsr         RandomObjDrop         ; updates position of  random obj dropped
        bra         Render
    
ObjDropComplete

        
        * if there is an input, check to see if the previous frame also has input
        * otherwise, do not update and render
        cmpi.l      #0,currentFrameKeyDown
        bne         Render
        
        * compare the two frames: if last frame was not pressed, then process input
        move.l      lastFrameKeyDown,d0
        cmpi.l      #1,d0
        bne         Render
*----------- KEY UP ----------------------------------
InputObjMovement
        jsr         ObjMovement ; updates obj position based on player input
        
        * checks to see if object has finished moving
        cmpi.l      #0,objIsMoving
        beq         Render
        * ------- obj is done moving ----------------
        
        jsr         CheckObjSorted ; checks obj to update score
        jsr         CalcScore
        
        * generate next random obj
        jsr     RandomObjGenerator
        lea     randomObjToSort,a3
        move.l  d7,(a3)

        
        * reset drop obj
        move.l      #1,objDropped
        
        * reset obj position
        move.l      #290,randomObjPosX
        move.l      #-50,randomObjPosY
        
        
Render  
        jsr         SevenSegInval
        move.l      #70,-(sp)
        move.l      #570,-(sp)
        jsr         DisplayCountdownTimer
        add.l       #8,sp

        move.l      #70,-(sp)
        move.l      #159,-(sp)
        jsr         DisplayScore
        add.l       #8,sp
        
        
        jsr         DisplayRandomObj
     
        jsr         SwapBuffers   

        bra         GameLoop
**********************************************************************
* Game Over & final score  
GameOver 
        jsr         RestartScreen
        jsr         FillBackground
        
        move.l      #240,-(sp)
        move.l      #340,-(sp)
        jsr         DisplayScore
        add.l       #8,sp
        
        jsr         SwapBuffers
        
        SIMHALT
**********************************************************************
**********************************************************************
* Subroutines
********************************************************************** 
PauseTimer
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$00FFFFFF,d1
        trap        #15
        
        move.l      #FILL_COLOR_COMMAND,d0
        move.l      #$001616DC,d1
        trap        #15
        
        move.l      #DRAW_RECTANGLE,d0
        move.l      #192,d1
        move.l      #184,d2
        move.l      #456,d3
        move.l      #313,d4
        trap        #15
        
        move.l      #DISPLAY_STRING,d0
        lea         warningString,a1
        move.l      #281,d1
        move.l      #220,d2
        trap        #15
        
        move.l      #DISPLAY_STRING,d0
        lea         workerString,a1
        move.l      #200,d1
        move.l      #235,d2
        trap        #15
        
        
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$001616DC,d1
        trap        #15
        
        move.l      #FILL_COLOR_COMMAND,d0
        trap        #15
        
        clr.l       d1
        
        jsr         SwapBuffers
        
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$009C6258,d1
        trap        #15
        
        move.l      #FILL_COLOR_COMMAND,d0
        move.l      #$009C6258,d1
        trap        #15
        
        move.l      #DRAW_RECTANGLE,d0
        move.l      #100,d1
        move.l      #150,d2
        move.l      #470,d3
        move.l      #350,d4
        trap        #15
       
        jsr         DisplayBackground
        jsr         DisplayAllBins
        
        jsr         SwapBuffers
        
        add.l       #600,time

        rts       
 
********** TIME-BASED MOVEMENT ****************************
FindDeltaTime
        move.l      currentFrameTime,lastFrameTime
        jsr         GetTime
        jsr         CalcDeltaTime
        rts
        
GetTime
        move.l      #GET_TIME_COMMAND,d0
        trap        #15
        
        move.l      d1,currentFrameTime
        rts
        
CalcDeltaTime
        move.l       currentFrameTime,d0
        sub.l        lastFrameTime,d0
        move.l       d0,deltaTime
        rts

* calc for time-based movement       
CalcVelocity
        move.l      #CONST_VELOCITY,d0
        move.l      deltaTime,d1
        mulu.w      d1,d0
        move.l      d0,velocity
        rts
************************************************************       
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
        rts
       
************ SEVEN SEG DISPLAY ******************************
DisplayScore
        move.l      #0,numberToDisplay
        move.l      score,numberToDisplay
        
        move.l      4(sp),centerX
        move.l      8(sp),centerY
        jsr         sevenSegDisplay 
        rts   
        
CalcScore
        * adding to score
        clr.l       d0
        move.l      score,d0
        add.l       pointsToAdd,d0
        move.l      d0,score
        move.l      #0,pointsToAdd
        rts
        rts

DisplayCountdownTimer
        addq.l      #1,binMixCounter
        move.l      time,d0
        sub.l       deltaTime,d0
        move.l      d0,time
        divu.w      #100,d0
        clr.l       d1
        move.w      d0,d1
        
        move.l      d1,numberToDisplay
        move.l      4(sp),centerX
        move.l      8(sp),centerY
        jsr         sevenSegDisplay   
        rts  
        
************************************************************
	    
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
    INCLUDE             "SevenSegSubroutine.X68"
    INCLUDE             "InvalSubroutines.X68"
    INCLUDE             "SoundManager.X68"
    
LastFrameKeyDown    dc.l    1
CurrentFrameKeyDown ds.l    1
LastFrameTime       ds.l    1
CurrentFrameTime    ds.l    1
deltaTime           ds.l    1

leftBin             dc.l    3 ; number corresponds with the obj to sort (1: recycle, 2: Gold, 3: trash) 
rightBin            dc.l    1
downBin             dc.l    2

objDropCenterPos    dc.l    200

randomObjPosX       dc.l    290
randomObjPosY       dc.l    -50  

invalPosX           dc.l    280
invalPosY           dc.l    -50  
invalHeight         ds.l    1
invalWidth          ds.l    1

velocity            dc.l    1
time                dc.l    6000

binMixCounter       dc.l    0
    
screenHeight        dc.w    480
screenWidth         dc.w    680
chosenBin           dc.l    0
sortedObj           dc.l    1
score               dc.l    0

* 7 seg display ----------------
numberToDisplay     dc.l    0  
centerX             dc.l    0
centerY             dc.l    0
* ------------------------------

objDropped          dc.l    1
objIsMoving         dc.l    1

randomObjToSort     dc.l    1
randomObjToSort2    dc.l    1

pointsToAdd         dc.l    0


CR                  EQU     $0D
LF                  EQU     $0A

warningString       dc.b    'WARNING:',CR,LF,0
workerString        dc.b    'WORKERS ARE SWITCHING ',CR,LF,0 
                    dc.b    'THE SORTING BINS',CR,LF,0
                    



    END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
