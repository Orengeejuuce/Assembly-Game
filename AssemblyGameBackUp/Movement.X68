*-----------------------------------------------------------
* Title      : Sort Trash
* Written by : Haley Park
* Date       :
* Description: A game where the player must sort as much recycling and trash before the time runs out

*-----------------------------------------------------------
ALL_REG                 REG     D0-D5/A0-A6
KEY_LEFT_INPUT          equ     $41
KEY_RIGHT_INPUT         EQU     $44
KEY_DOWN_INPUT          EQU     $53
GET_KEY_INPUT_COMMAND   EQU     19
CLEAR_SCREEN            EQU     11
CLEAR_SCREEN_MAGIC_VAL  EQU     $FF00
DRAW_RECTANGLE          EQU     87
GET_SCREEN_SIZE         EQU     33
FILL_COLOR              EQU     81
PEN_COLOR               EQU     80
MOVE_OBJECT_POSITION    EQU     86 

InitData
        clr.l   d7
        move.l  #$41,d2
        rts
CheckInput  
        move.b  #GET_KEY_INPUT_COMMAND,d0
*put current ascii value we're looking for into d1 for trap
        move.l  d2,d1
        TRAP    #15
*if key is pressed call function if not just goto next ascii value
        cmpi.b  #0,d1
        beq     noInput

        jsr     callFunction

CallFunction

*save off registers
        movem.l ALL_REG,-(sp)
*load up FunctionTable[d2-'0']  
        lea     FunctionTable,a0
        sub.l   #$41,d2
        lsl.l   #2,d2
        move.l  (a0,d2),d1
*if it's a null function ptr, nothing to call so leave
        cmpi.l  #0,d1
        beq     noFuncPtr
        
* signals that key was pressed        
        move.l  #0,currentFrameKeyDown
        move.l  #0,objIsMoving
*move value into A1 and call it
        move.l  d1,a1
        jsr     (a1)  
        movem.l (sp)+,ALL_REG
        add.l   #4,sp
        
NoFuncPtr
        rts

NoInput
        *bump to next ascii value
        add.l    #1,d2
*if we're at T, then reinit the data to 0 and begin loop again
        cmpi.b   #$54,d2
        bne      CheckInput
        jmp      InitData


Center
*returns screen size in long and finds center of screen 
       *high 16 bits = width
       *low 16 bits = height
       *divide by 2 to get center
       
       move.l   #GET_SCREEN_SIZE,d0
       move.w   #0,d1
       trap     #15
       
       move.w   d1,screenHeight
       move.w   d1,d5
       
       lea      objectPosY,a2
       lsr.w    #1,d5
       move.w   d5,(a2)
       
       swap     d1
       
       move.w   d1,screenWidth
       lea      objectPosX,a2
       lsr.w    #1,d1
       move.w   d1,(a2)
       
       rts
        
RestartScreen
  * Clears screen and resets drawing point at the center
        move.l   #CLEAR_SCREEN,d0
        move.w   #CLEAR_SCREEN_MAGIC_VAL,d1
        trap     #15
        jsr      center
        
        rts


SortLeft  * if A is pressed, update graphics and indicate which bin the object was sorted into
        movem.l ALL_REG,-(sp)
        
        move.l  leftBin,chosenBin  
        movem.l (sp)+,ALL_REG
        rts

SortRight
        movem.l ALL_REG,-(sp) 
        
        move.l  rightBin,chosenBin
        movem.l (sp)+,ALL_REG
        rts

SortDown
        movem.l ALL_REG,-(sp)   

        move.l  downBin,chosenBin
        movem.l (sp)+,ALL_REG
        rts
        
*************************************************************        
        
ObjMovement
        move.l      chosenBin,d0
        cmp.l       leftBin,d0
        beq         LeftBinMove
        
        cmp.l       rightBin,d0
        beq         RightBinMove
        
        cmp.l       downBin,d0
        beq         DownBinMove
        
        rts

LeftBinMove
        *check boundary
        jsr         ObjInval
        move.l      randomObjPosX,d0
        sub.l       velocity,d0
        move.l      d0,randomObjPosX
        
        cmpi.l      #0,d0
        blt         BinMoveEnd
        rts


RightBinMove
  *check boundary
        
        jsr         ObjInval
        move.l      randomObjPosX,d0
        add.l       velocity,d0
        move.l      d0,randomObjPosX
        
        cmpi.l      #680,d0
        bgt         BinMoveEnd
        rts
        

DownBinMove
          *check boundary

        
        jsr         ObjInval
        move.l      randomObjPosY,d0
        add.l       velocity,d0
        move.l      d0,randomObjPosY

        cmpi.l      #480,d0
        bgt         BinMoveEnd
        rts

BinMoveEnd
        jsr         ChosenBinInval
        move.l      #1,objIsMoving
        rts 



*start data
HAVE_HAD_NO_INPUT  ds.b    1

objectPosX         ds.w    1
objectPosY         ds.w    1
functionTable   
                *0-9
                dc.l    SortLeft,0,0,SortRight,0,0,0
                dc.l    0,0,0,0,0,0,0
                dc.l    0,0,0,0,SortDown,0




































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
