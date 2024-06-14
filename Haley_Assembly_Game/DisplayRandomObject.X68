*-----------------------------------------------------------
* Title      : Display Random Objects from Bitmap
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DisplayRandomObj                
        * if random obj is recycle, find on bitmap to print
        move.l      randomObjToSort,d0
        
        move.l      randomObjPosX,d1
        move.l      randomObjPosY,d2
       
        cmpi.l      #1,d0
        beq         DisplayRecycleObj
        
        cmpi.l      #2,d0
        beq         DisplayValuableObj
        
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
        
        move.l      #807,d3 ; Selection Position X
        move.l      #1,d4 ; Selection Position Y
        move.l      invalHeight,d5 ;HEIGHT
        move.l      invalWidth,d6 ;WIDTH
        
        
        bra         DisplayRandomObjEnd
        

DisplayTrashObj
        move.l      #61,invalHeight
        move.l      #61,invalWidth
        
        move.l      #953 ,d3 
        move.l      #2,d4 
        move.l      invalHeight,d5 
        move.l      invalWidth,d6 
        bra         DisplayRandomObjEnd
        
DisplayValuableObj
        cmpi.l      #0,keepObj
        beq         DisplayMoneyObj
        
DisplayTimeObj
        move.l      #49,invalHeight
        move.l      #48,invalWidth
        
        move.l      #740,d3 
        move.l      #4,d4 
        move.l      invalHeight,d5
        move.l      invalWidth,d6
        bra         DisplayRandomObjEnd

DisplayMoneyObj
        move.l      #55,invalHeight
        move.l      #57,invalWidth
        
        move.l      randomObjPosX,d1
        move.l      randomObjPosY,d2
        move.l      #884,d3 
        move.l      #0,d4 
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

****************************************************************************
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
        move.l      #290,d1
        move.l      #220,d2
        trap        #15
        
        move.l      #DISPLAY_STRING,d0
        lea         workerString,a1
        move.l      #240,d1
        move.l      #235,d2
        trap        #15
        
        move.l      #DISPLAY_STRING,d0
        lea         workerStringCon,a1
        move.l      #255,d1
        move.l      #250,d2
        trap        #15
        
        
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$001616DC,d1
        trap        #15
        
        move.l      #FILL_COLOR_COMMAND,d0
        trap        #15
        
        clr.l       d1
        
        jsr         SwapBuffers
        
        * block out warning sign
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$009C6258,d1
        trap        #15
        
        move.l      #FILL_COLOR_COMMAND,d0
        move.l      #$009C6258,d1
        trap        #15
        
        move.l      #DRAW_RECTANGLE,d0
        move.l      #189,d1
        move.l      #180,d2
        move.l      #460,d3
        move.l      #320,d4
        trap        #15
        
        * blocking previous bin labels
        
        move.l      #DRAW_RECTANGLE,d0 ; bottom bin
        move.l      #267,d1
        move.l      #383,d2
        move.l      #380,d3
        move.l      #478,d4
        trap        #15
        
        move.l      #DRAW_RECTANGLE,d0 ; left bin
        move.l      #0,d1
        move.l      #193,d2
        move.l      #149,d3
        move.l      #296,d4
        trap        #15
        
        move.l      #DRAW_RECTANGLE,d0 ; right bin
        move.l      #538,d1
        move.l      #191,d2
        move.l      #679,d3
        move.l      #286,d4
        trap        #15
       
        jsr         DisplayBackground
        jsr         DisplayAllBins
        
        jsr         SwapBuffers
        
        add.l       #600,time

        rts    

*********** ENDINGS ********************************************************
DisplayEnding
        move.l  $00000000,backgroundColor
        jsr     FillBackground
        
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$00FFFFFF,d1
        trap        #15
        
        
        cmpi.l  #100,score
        blt     DisplayBadEnd
        
        cmpi.l  #350,score
        blt     DisplayNormalEnd
        
        bra      DisplayGoodEnd
EndingFinish 
        move.l      #768,d3 ; Selection Position X
        move.l      #215,d1 ; Screen Position X
        move.l      #147,d2 ; Screen  Position Y 
        move.l      #153,d5 ;HEIGHT
        move.l      #247,d6 ;WIDTH
        jsr         DisplayRandomObjEnd   
        
           
        rts
        

DisplayBadEnd
        jsr         PlayTrashWorkerMusic
        
        move.l      #542,d4 ; Selection Position Y
        
        movem.l ALL_REG,-(sp) 
        move.l      #DISPLAY_STRING,d0
        lea         endingOne,a1
        move.l      #240,d1
        move.l      #118,d2
        trap        #15
        
        lea         trashWorker,a1
        move.l      #232,d1
        move.l      #356,d2
        trap        #15

        move.l      #330,-(sp)
        move.l      #338,-(sp)
        jsr         DisplayScore
        add.l       #8,sp
        movem.l (sp)+,ALL_REG

        bra         EndingFinish
        
DisplayNormalEnd
        jsr         PlayHardWorkerMusic
        
        move.l      #718,d4 ; Selection Position Y
        
        movem.l ALL_REG,-(sp) 
        move.l      #DISPLAY_STRING,d0
        lea         endingTwo,a1
        move.l      #250,d1
        move.l      #118,d2
        trap        #15
        
        lea         hardWorker,a1
        move.l      #252,d1
        move.l      #356,d2
        trap        #15
        
        move.l      #330,-(sp)
        move.l      #353,-(sp)
        jsr         DisplayScore
        add.l       #8,sp
        movem.l (sp)+,ALL_REG
        
        bra         EndingFinish

DisplayGoodEnd
        jsr         PlayBestWorkerMusic
        
        move.l      #896,d4 ; Selection Position Y
        
        movem.l ALL_REG,-(sp) 
        move.l      #DISPLAY_STRING,d0
        lea         endingThree,a1
        move.l      #212,d1
        move.l      #118,d2
        trap        #15
        
        lea         bestWorker,a1
        move.l      #220,d1
        move.l      #356,d2
        trap        #15
        
        move.l      #330,-(sp)
        move.l      #353,-(sp)
        jsr         DisplayScore
        add.l       #8,sp
        movem.l (sp)+,ALL_REG
        
        bra         EndingFinish    


endingOne           dc.b    'Ending #1: Trash Worker',CR,LF,0
trashWorker         dc.b    'You got mistaken for trash.',CR,LF,0

endingTwo           dc.b    'Ending #2: Hard Worker',CR,LF,0
hardworker          dc.b    'Keep up the good work!',CR,LF,0

endingThree         dc.b    'Ending #3: Employee of the Month',CR,LF,0
bestworker          dc.b    'All hail the new recycle king!',CR,LF,0




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
