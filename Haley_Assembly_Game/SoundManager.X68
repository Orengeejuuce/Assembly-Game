*-----------------------------------------------------------
* Title      : Music & Sound Manager
* Written by : Haley Park
* Date       :
* Description:
*-----------------------------------------------------------
LOAD_SOUND_IN_MEMORY             EQU     74
CONTROL_DIRECTX_PLAYER           EQU     77
ALARM_SFX                        EQU     1
CLOCK_SFX                        EQU     2
TRASH_RECYCLE_SFX                EQU     4
HARDWORKER_MUSIC                 EQU     6
TRASHWORKER_MUSIC                EQU     5
BESTWORKER_MUSIC                 EQU     7

SoundInitialize
        move.l      #LOAD_SOUND_IN_MEMORY,d0
        lea         backgroundMusic,a1
        move.l      #0,d1
        trap        #15
        
        move.l      #LOAD_SOUND_IN_MEMORY,d0
        lea         alarmSFX,a1
        move.l      #1,d1
        trap        #15
        
        move.l      #LOAD_SOUND_IN_MEMORY,d0
        lea         clockSFX,a1
        move.l      #2,d1
        trap        #15
        
        move.l      #LOAD_SOUND_IN_MEMORY,d0
        lea         trashAndRecycleSFX,a1
        move.l      #4,d1
        trap        #15
        
        move.l      #LOAD_SOUND_IN_MEMORY,d0
        lea         trashWorkerMusic,a1
        move.l      #5,d1
        trap        #15
        
        move.l      #LOAD_SOUND_IN_MEMORY,d0
        lea         hardWorkerMusic,a1
        move.l      #6,d1
        trap        #15
        
        move.l      #LOAD_SOUND_IN_MEMORY,d0
        lea         bestWorkerMusic,a1
        move.l      #7,d1
        trap        #15
        rts
        
PlayBackgroundMusic
        move.l      #CONTROL_DIRECTX_PLAYER,d0
        move.l      #0,d1       ; sound reference number
        move.l      #1,d2       ; plays on loop
        trap        #15     
        rts
        
PlayAlarmSFX
        move.l      #CONTROL_DIRECTX_PLAYER,d0
        move.l      #ALARM_SFX,d1       ; sound reference number
        move.l      #0,d2               ; plays once
        trap        #15  

        rts
  
PlayClockSFX
        move.l      #CONTROL_DIRECTX_PLAYER,d0
        move.l      #CLOCK_SFX,d1       ; sound reference number
        move.l      #0,d2       
        trap        #15     
        move.l      #1,soundPlayed
        bra         SFXEnd
        
        
PlayTrashAndRecycleSFX
        move.l      #CONTROL_DIRECTX_PLAYER,d0
        move.l      #TRASH_RECYCLE_SFX,d1       ; sound reference number
        move.l      #0,d2       
        trap        #15     
        
        move.l      #1,soundPlayed
        bra         SFXEnd
        
PlayTrashWorkerMusic

        move.l      #CONTROL_DIRECTX_PLAYER,d0
        move.l      #TRASHWORKER_MUSIC,d1       ; sound reference number
        move.l      #1,d2       ; plays on loop
        trap        #15     
        rts
PlayHardWorkerMusic

        
        move.l      #CONTROL_DIRECTX_PLAYER,d0
        move.l      #HARDWORKER_MUSIC,d1       ; sound reference number
        move.l      #1,d2       ; plays on loop
        trap        #15     
        rts
PlayBestWorkerMusic

        
        move.l      #CONTROL_DIRECTX_PLAYER,d0
        move.l      #BESTWORKER_MUSIC,d1       ; sound reference number
        move.l      #1,d2       ; plays on loop
        trap        #15     
        rts
   

backgroundMusic     dc.b    'Coursebot.WAV',0
alarmSFX            dc.b    'Alarm.WAV',0
clockSFX            dc.b    'Clock.WAV',0
trashAndRecycleSFX  dc.b    'TrashAndRecycle.WAV',0
hardWorkerMusic     dc.b    'HardWorker.WAV',0
trashWorkerMusic    dc.b    'TrashWorker.WAV',0
bestWorkerMusic     dc.b    'BestWorker.WAV',0






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
