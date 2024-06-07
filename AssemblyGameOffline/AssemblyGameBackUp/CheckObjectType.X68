*-----------------------------------------------------------
* Title      : Check Object Type
* Written by : Haley Park
* Date       :
* Description: Checks to see if object type was sorted correctly
*-----------------------------------------------------------
GOLD_OBJ            EQU  2
 
* pass in:
* bin type
* object type

* return:
* timer change
* score change
*


CheckObjSorted
    lea     pointsToAdd,a3
    move.l  #0,(a3)
    move.l  randomObjToSort,d0
    cmp.l   #GOLD_OBJ,d0
    beq     GoldCondition
    
    bra     RegularCondition

GoldCondition
    move.l  chosenBin,d0
    cmp.l   randomObjToSort,d0
    bne     WrongGoldBin
    
CorrectGoldBin
    add.l   #30,pointsToAdd
    rts

WrongGoldBin
    cmpi.l  #0,score
    beq     FinishRegCondition
    
    sub.l   #30,score
    rts
    
RegularCondition
    cmp.l   chosenBin,d0
    bne     WrongBin     
    
CorrectBin
    add.l   #10,pointsToAdd
    bra     FinishRegCondition
    
WrongBin
    cmpi.l  #0,score
    beq     FinishRegCondition
    
    sub.l   #10,score
FinishRegCondition
    rts
      






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
