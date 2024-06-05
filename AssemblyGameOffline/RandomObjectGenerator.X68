*-----------------------------------------------------------
* Title      : Random Object Generator
* Written by : Haley Park
* Date       :
* Description: This file randomly generates the objects that appear on the screen
*              objects will include: recycling, trash, or gold
*-----------------------------------------------------------
GET_TIME_COMMAND        EQU     8
RANDOMVAL               DS.L    1

seedRandomNumber:
        movem.l d0-d2,-(sp)         ; Save registers d0, d1, and d2
        clr.l   d6
        move.b  #GET_TIME_COMMAND, d0
        TRAP    #15                 ; Get the current time
        
        move.l  d1, RANDOMVAL       ; Store the time in RANDOMVAL
        movem.l (sp)+, d0-d2        ; Restore registers
        rts

getRandomByteIntoD6:
        movem.l d0-d2, -(sp)        ; Save registers d0, d1, and d2

        move.l  RANDOMVAL, d0
        moveq   #$AF, d1            ; Polynomial constant
        moveq   #18, d2             ; Number of bits to shift

Ninc0:
        add.l   d0, d0
        bcc     Ninc1
        eor.b   d1, d0
Ninc1:
        dbf     d2, Ninc0           ; Loop until d2 reaches 0

        move.l  d0, RANDOMVAL       ; Store new random value
        move.l  d0, d6              ; Put result in d6

        movem.l (sp)+, d0-d2        ; Restore registers
        rts

RandomObjGenerator:
        jsr     getRandomByteIntoD6 ; Get a random byte into d6
        move.l  d6, d0
        asr.l   #8, d0              ; Shift right to get a random byte
        and.b   #$FF, d0            ; Mask to ensure we have a byte
        move.b  d0, d7              ; Move the result to d7
        rts


* Variables used


RANDOMVAL       ds.l    1
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
