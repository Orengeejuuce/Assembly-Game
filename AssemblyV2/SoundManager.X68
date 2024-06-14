*-----------------------------------------------------------
* Title      : Music & Sound Manager
* Written by : Haley Park
* Date       :
* Description:
*-----------------------------------------------------------
LOAD_SOUND_IN_MEMORY             EQU     71
CONTROL_STANDARD_PLAYER          EQU     76

SoundInitialize
        move.l      #LOAD_SOUND_IN_MEMORY,d0
        lea         backgroundMusic,a1
        move.l      #0,d1
        trap        #15
        rts
        
PlayBackgroundMusic
        move.l      #CONTROL_STANDARD_PLAYER,d0
        move.l      #0,d1       ; sound reference number
        move.l      #1,d2       ; plays on loop
        trap        #15     
        rts


backgroundMusic     dc.b    'Coursebot.WAV',0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
