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
        move.l      #80,invalHeight
        move.l      #52,invalWidth

        move.l      randomObjPosX,d1 ; Selection Position X
        move.l      randomObjPosY,d2 ; Selection Position Y
        move.l      #809,d3 ; Selection Position X
        move.l      #0,d4 ; Selection Position Y
        move.l      #80,d5 ;HEIGHT
        move.l      #52,d6 ;WIDTH
        
        
        bra         DisplayRandomObjEnd
        

DisplayTrashObj
        move.l      #70,invalHeight
        move.l      #78,invalWidth
      
        move.l      randomObjPosX,d1 ; Selection Position X
        move.l      randomObjPosY,d2 ; Selection Position Y
        move.l      #982,d3 
        move.l      #7,d4 
        move.l      #70,d5 
        move.l      #78,d6 
        bra         DisplayRandomObjEnd
DisplayGoldObj
        move.l      #70,invalHeight
        move.l      #79,invalWidth
        
        move.l      randomObjPosX,d1 ; Selection Position X
        move.l      randomObjPosY,d2 ; Selection Position Y
        move.l      #894,d3 
        move.l      #0,d4 
        move.l      #70,d5
        move.l      #79,d6
        bra         DisplayRandomObjEnd
        
*************************************************************************
* Display Intro
*************************************************************************        
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








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
