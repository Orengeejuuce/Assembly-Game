*-----------------------------------------------------------
* Title      : Display Random Objects from Bitmap
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DisplayRandomObj                
        * if random obj is recycle, find on bitmap to print
        move.l      randomObjToSort,d0
        cmpi.l      #1,d0
        beq         DisplayRecycleObj
        
        cmpi.l      #2,d0
        beq         DisplayGoldObj
        
        cmpi.l      #3,d0
        beq         DisplayTrashObj
        
DisplayRandomObjEnd       
        move.l      d1,-(sp) ; Screen pos x
        move.l      d2,-(sp) ; Screen pos y
        move.l      d3,-(sp) ; Selection Position X
        move.l      d4,-(sp) ; Selection Position Y
        move.l      d5,-(sp) ;HEIGHT
        move.l      d6,-(sp) ;WIDTH
        jsr         display
        add.l       #24,sp
        rts 
            
DisplayRecycleObj
        move.l      #80,randomObjHeight
        move.l      #52,randomObjWidth

        move.l      randomObjPosX,d1 ; Selection Position X
        move.l      randomObjPosY,d2 ; Selection Position Y
        move.l      #809,d3 ; Selection Position X
        move.l      #0,d4 ; Selection Position Y
        move.l      #80,d5 ;HEIGHT
        move.l      #52,d6 ;WIDTH
        
        
        bra         DisplayRandomObjEnd
        

DisplayTrashObj
        move.l      #70,randomObjHeight
        move.l      #78,randomObjWidth
      
        move.l      randomObjPosX,d1 ; Selection Position X
        move.l      randomObjPosY,d2 ; Selection Position Y
        move.l      #982,d3 
        move.l      #7,d4 
        move.l      #70,d5 
        move.l      #78,d6 
        bra         DisplayRandomObjEnd
DisplayGoldObj
        move.l      #70,randomObjHeight
        move.l      #79,randomObjWidth
        
        move.l      randomObjPosX,d1 ; Selection Position X
        move.l      randomObjPosY,d2 ; Selection Position Y
        move.l      #894,d3 
        move.l      #0,d4 
        move.l      #70,d5
        move.l      #79,d6
        bra         DisplayRandomObjEnd






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
