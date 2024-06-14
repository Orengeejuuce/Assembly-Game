*-----------------------------------------------------------
* Title      : Check Object Type
* Written by : Haley Park
* Date       :
* Description: Checks to see if object type was sorted correctly
*-----------------------------------------------------------
VALUABLE_OBJ            EQU  2
 
* pass in:
* bin type
* object type

* return:
* timer change
* score change
*


CheckObjSorted
    move.l  #0,pointsToAdd
    move.l  randomObjToSort,d0
    cmp.l   #VALUABLE_OBJ,d0
    beq     SpecialCondition
    
    bra     RegularCondition

SpecialCondition
    cmpi.l  #0,keepObj
    beq     MoneyCondition
    
    * Time condition
    move.l  chosenBin,d0
    cmp.l   randomObjToSort,d0
    bne     SpeedBin
KeepTime
    add.l   #300,time
    rts    
SpeedBin
    move.l  constVelocity,d0
    cmpi.l  #13,d0
    beq     FinishRegCondition
    
    add.l   #1,constVelocity
    rts

MoneyCondition
    move.l  chosenBin,d0
    cmp.l   randomObjToSort,d0
    bne     WrongMoneyBin
    
CorrectMoneyBin
    add.l   #20,pointsToAdd
    rts

WrongMoneyBin
    move.l  score,d0
    cmpi.l  #40,d0
    blt     FinishSpecialCondition
    
    sub.l   #20,pointsToAdd
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
    
FinishSpecialCondition
    move.l  #0,score
    rts
      









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
