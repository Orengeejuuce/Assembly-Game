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
        move.l      #60,invalHeight
        move.l      #62,invalWidth
        
        move.l      randomObjPosX,d1
        move.l      randomObjPosY,d2
        move.l      #807,d3 ; Selection Position X
        move.l      #1,d4 ; Selection Position Y
        move.l      invalHeight,d5 ;HEIGHT
        move.l      invalWidth,d6 ;WIDTH
        
        
        bra         DisplayRandomObjEnd
        

DisplayTrashObj
        move.l      #61,invalHeight
        move.l      #61,invalWidth
        
        move.l      randomObjPosX,d1 
        move.l      randomObjPosY,d2 
        move.l      #953 ,d3 
        move.l      #2,d4 
        move.l      invalHeight,d5 
        move.l      invalWidth,d6 
        bra         DisplayRandomObjEnd
DisplayGoldObj
        move.l      #55,invalHeight
        move.l      #59,invalWidth
        
        move.l      randomObjPosX,d1
        move.l      randomObjPosY,d2
        move.l      #890,d3 
        move.l      #1,d4 
        move.l      invalHeight,d5
        move.l      invalWidth,d6
        bra         DisplayRandomObjEnd
        
*************************************************************************
* Display Intro
*************************************************************************        
DisplayLoadingScreen
        * "loading..." 
        move.l      #460,d1 ; Screen Position X
        move.l      #425,d2 ; Screen  Position Y
        move.l      #464,d3 ; Selection Position X
        move.l      #665,d4 ; Selection Position Y
        move.l      #40,d5 ;HEIGHT
        move.l      #196,d6 ;WIDTH  
        jsr         DisplayRandomObjEnd
        
        * control instruction
        move.l      #180,d1 ; Screen Position X
        move.l      #184,d2 ; Screen  Position Y
        move.l      #177,d3 ; Selection Position X
        move.l      #794,d4 ; Selection Position Y
        move.l      #161,d5 ;HEIGHT
        move.l      #284,d6 ;WIDTH  
        jsr         DisplayRandomObjEnd
                
        
        * "sort"
        move.l      #245,d1 ; Screen Position X
        move.l      #355,d2 ; Screen  Position Y
        move.l      #245,d3 ; Selection Position X
        move.l      #722,d4 ; Selection Position Y
        move.l      #47,d5 ;HEIGHT
        move.l      #163,d6 ;WIDTH  
        jsr         DisplayRandomObjEnd
        
        * example trash
        move.l      #253,d1 ; Screen Position X
        move.l      #47,d2 ; Screen  Position Y
        move.l      #256,d3 ; Selection Position X
        move.l      #961,d4 ; Selection Position Y
        move.l      #128,d5 ;HEIGHT
        move.l      #115,d6 ;WIDTH  
        jsr         DisplayRandomObjEnd
        rts
DisplayEnterScreen
        move.l      #155,d1 ; Screen Position X
        move.l      #155,d2 ; Screen  Position Y
        move.l      #14,d3 ; Selection Position X
        move.l      #483,d4 ; Selection Position Y
        move.l      #166,d5 ;HEIGHT
        move.l      #377,d6 ;WIDTH            
        jsr         DisplayRandomObjEnd
        rts
        
DisplayBackground

        move.l      #FILL_COLOR_COMMAND,d0
        move.l      #$009C6258,d1
        trap        #15
        
        move.l      #FLOOD_FILL_COMMAND,d0
        move.w      #0,d1
        move.w      #0,d2
        trap        #15
        
        
        move.l      #0,d1 ; Screen Position X
        move.l      #0,d2 ; Screen  Position Y
        move.l      #0,d3 ; Selection Position X
        move.l      #289,d4 ; Selection Position Y
        move.l      #191,d5 ;HEIGHT
        move.l      #272,d6 ;WIDTH
        jsr         DisplayRandomObjEnd
        
        
        move.l      #381,d1 ; Screen Position X
        move.l      #0,d2   ; Screen  Position Y
        move.l      #381,d3 ; Selection Position X
        move.l      #289,d4 ; Selection Position Y
        move.l      #195,d5 ;HEIGHT
        move.l      #299,d6 ;WIDTH
        jsr         DisplayRandomObjEnd
        
        move.l      #0,d1 ; Screen Position X
        move.l      #297,d2 ; Screen  Position Y
        move.l      #0,d3 ; Selection Position X
        move.l      #0,d4 ; Selection Position Y
        move.l      #184,d5 ;HEIGHT
        move.l      #273,d6 ;WIDTH
        jsr         DisplayRandomObjEnd
        
        move.l      #381,d1 ; Screen Position X
        move.l      #286,d2 ; Screen  Position Y
        move.l      #381,d3 ; Selection Position X
        move.l      #0,d4 ; Selection Position Y
        move.l      #194,d5 ;HEIGHT
        move.l      #299,d6 ;WIDTH
        jsr         DisplayRandomObjEnd
        rts  















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
