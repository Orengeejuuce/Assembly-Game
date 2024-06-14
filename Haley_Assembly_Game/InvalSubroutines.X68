*-----------------------------------------------------------
* Title      : Inval
* Written by : Haley Park
* Date       :
* Description: All inval subroutines (primitive and bitmap)
*-----------------------------------------------------------
SevenSegInval
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$0045251F,d1
        trap        #15
        
        move.l      #FILL_COLOR_COMMAND,d0
        trap        #15
        
        clr.l       d1

        move.l      #DRAW_RECTANGLE,d0
        move.l      #74,d1
        move.l      #38,d2
        move.l      #168,d3
        move.l      #91,d4
        trap        #15
        
        move.l      #492,d1
        move.l      #45,d2
        move.l      #583,d3
        move.l      #102,d4
        trap        #15
        
        rts
        
ObjInval
        move.l      #PEN_COLOR_COMMAND,d0
        move.l      #$009C6258,d1
        trap        #15
        
        move.l      #FILL_COLOR_COMMAND,d0
        trap        #15
        
        clr.l       d1
        
        move.l      invalPosX,d0
        asr.l       #2,d0
        move.l      d0,invalPosX
        
        
        move.l      invalPosY,d0
        asr.l       #2,d0
        move.l      d0,invalPosY

        move.l      #DRAW_RECTANGLE,d0
        move.l      invalPosX,d1
        move.l      invalPosY,d2
        move.l      invalPosX,d3
        add.l       invalWidth,d3
        move.l      invalPosY,d4
        add.l       invalHeight,d4
        trap        #15

        rts
        
DisplayAllBins 
        * right bin
        move.l      rightBin,d0
        sub.l       #1,d0
        lsl.l       #2,d0
        jsr         FindTypeOfBin
        jsr         DisplayRight      
        
        * down bin
        move.l      downBin,d0
        sub.l       #1,d0
        lsl.l       #2,d0
        jsr         FindTypeOfBin
        jsr         Displaydown      
        
        *left bin
        move.l      leftBin,d0
        sub.l       #1,d0
        lsl.l       #2,d0
        jsr         FindTypeOfBin
        jsr         DisplayLeft 
        
        rts
        
FindTypeOfBin
         * find and display type of bin
        lea         DisplayChosenBin,a0
        move.l      (a0,d0),d1
        move.l      d1,a1
        jsr         (a1) 
        rts    
        
ChosenBinInval
        move.l      chosenBin,d0
        sub.l       #1,d0 ; indexing purposes
        lsl.l       #2,d0
        
        * find and display type of bin
        lea         DisplayChosenBin,a0
        move.l      (a0,d0),d1
        move.l      d1,a1
        jsr         (a1)
        
        * manipulate bin type number to branch to correct location display
        lsr.l       #2,d0
        move.l      leftBin,-(sp)
        move.l      rightBin,-(sp)
        move.l      downBin,-(sp)
        
        lea         downBinIndex,a2
        move.l      (sp),(a2)
        
        lea         rightBinIndex,a2   
        move.l      4(sp),(a2)
    
        lea         leftBinIndex,a2   
        move.l      8(sp),(a2)
        
        sub.l       #1,downBinIndex
        sub.l       #1,rightBinIndex
        sub.l       #1,leftBinIndex
        
        add.l       #12,sp
        
        * display bin at specified location

        cmp.l       leftBinIndex,d0
        beq         DisplayLeft
        

        cmp.l       rightBinIndex,d0
        beq         DisplayRight
        

        cmp.l       downBinIndex,d0
        beq         DisplayDown

ChosenBinInvalEnd        
        jsr        DisplayRandomObjEnd
        rts
        
DisplayLeft
        move.l      #13,d1
        move.l      #190,d2
        bra         ChosenBinInvalEnd        
        
DisplayRight
        move.l      #588,d1
        move.l      #190,d2
        bra         ChosenBinInvalEnd        
        
DisplayDown
        move.l      #280,d1
        move.l      #370,d2
        bra         ChosenBinInvalEnd        
        
DisplayRecycleBin
        move.l       #716,d3
        move.l       #384,d4
        move.l       #90,d5
        move.l       #82,d6
        rts
        
DisplayTrashBin
        move.l       #921,d3
        move.l       #383,d4
        move.l       #92,d5
        move.l       #91,d6
        rts
        
DisplayKeepBin
        move.l       #828,d3
        move.l       #386,d4
        move.l       #90,d5
        move.l       #82,d6
        rts

leftBinIndex    dc.l 0
rightBinIndex   dc.l 0
downBinIndex    dc.l 0

DisplayChosenBin    
        dc.l        DisplayRecycleBin, DisplayKeepBin, DisplayTrashBin

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
