*-----------------------------------------------------------
* Title      : Check Object Type
* Written by : Haley Park
* Date       :
* Description: Checks object type and updates score/timer to reflect the outcome
*-----------------------------------------------------------
RECYCLE_OBJ         EQU  1
TRASH_OBJ           EQU  2
GOLD_OBJ            EQU  3
 
* pass in:
* bin type
* object type

* return:
* timer change
* score change
*
CheckGoldObject
* checking if sorted object is Gold 
      move.l      4(sp),d0
      cmp.l       GOLD_OBJ,d0
      bne         rts
      
      add.l       #300,score
      
      
      



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
