*-----------------------------------------------------------
* Title      : Random Object Generator
* Written by : Haley Park
* Date       :
* Description: This file randomly generates the objects that appear on the screen
*              objects will include: recycling, trash, or gold
*-----------------------------------------------------------
GET_TIME_COMMAND        EQU     8

;Seed the random number generator using the current time
seedRandomNumber
        movem.l ALL_REG,-(sp)      ; Save registers
        clr.l   d6
        move.b  #GET_TIME_COMMAND,d0
        TRAP    #15

        move.l  d1,RANDOMVAL
        movem.l (sp)+,d0-d2      ; Restore registers
        rts

;Generate a random byte and store it in d6
getRandomByteIntoD6
        movem.l d0-d2,-(sp)      ; Save registers
        move.l  RANDOMVAL,d0
        moveq   #$AF-$100,d1
        moveq   #18,d2
Ninc0
        add.l   d0,d0
        bcc     Ninc1
        eor.b   d1,d0
Ninc1
        dbf     d2,Ninc0

        move.l  d0,RANDOMVAL

        move.l  d0,d6            ; Store random value in d6

        movem.l (sp)+,d0-d2      ; Restore registers
        rts

;Generate a random number between 0 and 2 and store it in d7
RandomObjGenerator
        jsr     getRandomByteIntoD6
        move.l  d6,d0            ; Move the random value to d0
        andi.l  #$FF,d0          ; Ensure it is within byte range
        divu    #3,d0            ; Divide by 3 to get remainder (0, 1, or 2)
        swap    d0
        addq.l  #1,d0
        move.b  d0,d7            ; Move result to d7

        rts

Variables
RANDOMVAL       ds.l    1



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
