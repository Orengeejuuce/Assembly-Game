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

RECYCLE_BIN             EQU     1    
TRASH_BIN               EQU     2  
KEEP_BIN                EQU     3  

InitData
        move.l  #$41,d2
        rts
CheckInput   
        
        move.b  #GET_KEY_INPUT_COMMAND,d0
*put current ascii value we're looking for into d1 for trap
        move.l          d2,d1
        TRAP            #15
*if key is pressed call function if not just goto next ascii value
        cmpi.b          #0,d1
        beq             noInput
        
;key up pressed
        move.b  HAVE_HAD_NO_INPUT,d0    ;What would happen if I comment
        beq     aroundNoInput           ;these two lines out?
        move.b  #0,HAVE_HAD_NO_INPUT
        
        jsr     callFunction

*        move.b  #CLEAR_SCREEN_COMMAND,d0
*        move.l  #CLEAR_SCREEN_MAGIC_VAL,d1
*        TRAP    #15

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
*move value into A1 and call it
        move.l  d1,a1
        jsr     (a1)  
 
noFuncPtr
        move.b  #1,HAVE_HAD_NO_INPUT
        movem.l (sp)+,ALL_REG
        add.l   #4,sp
        rts

noInput
        move.b  #1,HAVE_HAD_NO_INPUT
        *bump to next ascii value
        add.l           #1,d2
*if we're at T, then reinit the data to 0 and begin loop again
        cmpi.b          #$54,d2
        bne             CheckInput
        jmp             InitData
        
aroundNoInput
        bra     CheckInput


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

DrawSquare
  *drawing retangle around center position
        move.l   #DRAW_RECTANGLE,d0
       
        move.w   objectPosX,d5
        subq.w   #5,d5
        move.w   d5,d1
       
        add.w    #10,d5
        move.w   d5,d3
       
        move.w   objectPosY,d5
        addq.w   #5,d5
        move.w   d5,d2
       
        sub.w    #10,d5
        move.w   d5,d4
       
        trap     #15     

        rts 
        
RestartScreen
  * Clears screen and resets drawing point at the center
        move.l   #CLEAR_SCREEN,d0
        move.w   #CLEAR_SCREEN_MAGIC_VAL,d1
        trap     #15
        jsr      center
        
        rts


SortLeftRecycle
  * if A is pressed, update graphics and indicate which bin the object was sorted into
        movem.l ALL_REG,-(sp)
        move.w  #0,objectPosX   
        jsr     DrawSquare
        
        * adding to score
        lea         score,a2
        add.l       #10,(a2)
        
        move.l  #RECYCLE_BIN,d7  
        movem.l (sp)+,ALL_REG
        rts

SortRightTrash
        movem.l ALL_REG,-(sp) 
        move.w   screenWidth,objectPosX 
        jsr     DrawSquare
        
        * adding to score
        lea         score,a2
        add.l       #20,(a2)
        
        move.l  #TRASH_BIN,d7
        movem.l (sp)+,ALL_REG
        rts

SortDownKeep
        movem.l ALL_REG,-(sp)   
        move.w   screenHeight,objectPosY
        jsr     DrawSquare
        
        * adding to score
        lea         score,a2
        add.l       #20,(a2)
        
        move.l  #KEEP_BIN,d7
        movem.l (sp)+,ALL_REG
        rts


*start data
HAVE_HAD_NO_INPUT  ds.b    1

objectPosX         ds.w    1
objectPosY         ds.w    1
functionTable   
                *0-9
                dc.l    SortLeftRecycle,0,0,SortRightTrash,0,0,0
                dc.l    0,0,0,0,0,0,0
                dc.l    0,0,0,0,SortDownKeep,0


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
