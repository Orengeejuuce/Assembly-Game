*-----------------------------------------------------------
* Title      : 7 segment display
* Written by : Haley Park
* Date       :
* Description: 
*-----------------------------------------------------------

PEN_WIDTH_COMMAND   EQU  93
PEN_WIDTH           EQU  3

PEN_COLOR_COMMAND   EQU  80
SEG_COLOR           EQU  $00FFFFFF

DRAW_COMMAND        EQU  84   

;START   ORG $1000
* takes in center position and number to display
SevenSegDisplay
            move.l  #0,numOfDigits
            move.l  #0,counter
            move.l  numberToDisplay,d6
            move.l  #0,d0
            jsr     NumberOfDigits
            move.l  centerX,centerXWithOffset
SegCheck

            * sets display offset depending on number of digits
            move.l  counter,d0
            move.l  #18,d1
            mulu.w  d1,d0
            move.l  d0,digitDisplayOffset
            
            move.l  centerX,d0
            sub.l   digitDisplayOffset,d0
            move.l  d0,centerXWithOffset
            
            * only reads last digit of the number to display
            move.l  numberToDisplay,d0
            divu.w  #10,d0
            swap    d0
            move.w  d0,d5
            lsl.l   #2,d5
            
            jsr     ResetSegPosition
           
            lea     SevenSegBitmask,a0
            move.l  (a0,d5),d6     ; number from table stored in d1
            
            jsr     SetPenSettings
            jsr     DisplaySegment ; go through display conditional statements
            
            clr.l   d6
            
            move.l  numberToDisplay,d0
            divu.w   #10,d0
            move.w  d0,d6
            move.l  d6,d0
            move.l  d0,numberToDisplay
            
            add.l   #1,counter
            
            move.l  numOfDigits,d0
            cmp.l  counter,d0
            bgt     SegCheck
            
            rts
            
            ;SIMHALT
            
NumberOfDigits
            
            add.l   #1,numOfDigits
            divu.w  #10,d6
            move.w  d6,d0
            move.l  d0,d6
            
            * finding the number of digits of the inputted number
            cmpi.w  #0,d6
            bgt     NumberOfDigits
            
NumberOfDigitsEnd
            rts            
            
            
DisplaySegment
            ; display segment G
            btst.l  #00,d6
            beq     DisplaySegF
            
            * drawing segment based on center position
            sub.l   #3,segX1
            add.l   #3,segX2
            
            jsr     DrawSegment
            jsr     ResetSegPosition
              
DisplaySegF
            ror.l   #4,d6
            btst.l  #00,d6
            beq     DisplaySegE
            
            * drawing segment based on center position
            sub.l   #8,segY1
            sub.l   #6,segX1
            
            move.l  segX1,segX2
            sub.l   #2,segY2
            
            jsr     DrawSegment
            jsr     ResetSegPosition

DisplaySegE
            ror.l   #4,d6
            btst.l  #00,d6
            beq     DisplaySegD
            
            * drawing segment based on center position
            add.l   #2,segY1
            sub.l   #6,segX1
            
            move.l  segX1,segX2
            add.l   #8,segY2
            
            jsr     DrawSegment
            jsr     ResetSegPosition

DisplaySegD
            ror.l   #4,d6
            btst.l  #00,d6
            beq     DisplaySegC
            
            * drawing segment based on center position
            sub.l   #3,segX1
            add.l   #10,segY1
            
            add.l   #3,segX2
            move.l  segY1,segY2
            
            jsr     DrawSegment
            jsr     ResetSegPosition

DisplaySegC
            ror.l   #4,d6
            btst.l  #00,d6
            beq     DisplaySegB
            
            * drawing segment based on center position
            add.l   #2,segY1
            add.l   #6,segX1
            
            move.l  segX1,segX2
            add.l   #8,segY2
            
            jsr     DrawSegment
            jsr     ResetSegPosition

DisplaySegB
            ror.l   #4,d6
            btst.l  #00,d6
            beq     DisplaySegA
            
            * drawing segment based on center position
            sub.l   #8,segY1
            add.l   #6,segX1
            
            move.l  segX1,segX2
            sub.l   #2,segY2
            
            jsr     DrawSegment
            jsr     ResetSegPosition

              
DisplaySegA
            ror.l   #4,d6
            btst.l  #00,d6
            beq     DisplaySegEnd
            
            * drawing segment based on center position
            sub.l   #3,segX1
            sub.l   #10,segY1
            
            add.l   #3,segX2
            move.l  segY1,segY2
            
            jsr     DrawSegment
            jsr     ResetSegPosition

DisplaySegEnd
            rts
            
DrawSegment
            move.l  #DRAW_COMMAND,d0
            move.l  segX1,d1
            move.l  segY1,d2
            move.l  segX2,d3
            move.l  segY2,d4
            trap    #15
            rts
            
ResetSegPosition
            move.l  centerXWithOffset,segX1
            move.l  centerXWithOffset,segX2
            move.l  centerY,segY1
            move.l  centerY,segY2
            rts

SetPenSettings
            move.l  #PEN_WIDTH_COMMAND,d0
            move.l  #PEN_WIDTH,d1
            trap    #15
            
            move.l  #PEN_COLOR_COMMAND,d0
            move.l  #SEG_COLOR,d1
            trap    #15
            rts
            

digitDisplayOffset  dc.l    0
numOfDigits         dc.l    0
counter             dc.l    0


centerXWithOffset   dc.l    centerX

segX1               dc.l    0
segY1               dc.l    0
segX2               dc.l    0
segY2               dc.l    0
            
SevenSegBitmask
            dc.l    $01111110, $00110000, $01101101, $01111001, $00110011 
            dc.l    $01011011, $01011111, $01110000, $01111111, $01111011 
  
  ;END START





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
