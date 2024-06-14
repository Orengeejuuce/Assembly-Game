*-----------------------------------------------------------
* Title      : Bitmap SubRoutine
* Written by : Haley Park
* Date       :
* Description: 
*-----------------------------------------------------------
PEN_COLOR_TRAP_CODE             EQU     80
DRAW_PIXEL_TRAP_CODE            EQU     82
SET_OUTPUT_RESOLUTION_TRAP_CODE EQU     33 
 
FILE_SIGNATURE                  EQU     $424D
PRINT_STRING_CR_LF              EQU     13

HEADER_STARTING_ADDRESS_OFFSET  EQU     10
HEADER_WIDTH_OFFSET             EQU     18
HEADER_HEIGHT_OFFSET            EQU     22
HEADER_BITSPPIXEL               EQU     28

* Reads in bitmap file and verifies file identity

Check_File
    lea     START_OF_DATA,a0
    move.w  (a0)+,d0
    cmp.w   #FILE_SIGNATURE,d0   
    beq     Initialize
    
    move.l	#PRINT_STRING_CR_LF,d0           
    lea     ErrorMessage_WrongSignature, a1
    TRAP    #15
    SIMHALT
    
* -------------------------------------------------------------
Initialize
    lea  SelectionWidth,a2
    move.l  4(sp),(a2)
    
    lea  SelectionHeight,a2   
    move.l  8(sp),(a2)
    
    lea  SelectionPosY,a2   
    move.l  12(sp),(a2)
    
    lea  SelectionPosX,a2
    move.l  16(sp),(a2)
    
    lea     BMPosY,a2
    move.l  20(sp),(a2)  

    lea     BMPosYDraw,a2
    move.l  BMPosY,(a2)  
  
    lea     BMPosX,a2
    move.l  24(sp),(a2) 
  
    lea     BMPosXDraw,a2
    move.l  BMPosX,(a2) 

* -------------------------------------------------------------
Display

    * Set Screen Resolution
    move.b  #SET_OUTPUT_RESOLUTION_TRAP_CODE,d0
    move.l  ScreenHeight,d1
    swap d1
    trap    #15
    
    bsr     BM_Header           ; load header info into variables
    
    bsr     Set_Selection      ; set selection of pixels to print 
    
    bsr     Padding
 
    cmpi.w  #$20,BMBitsPPixel ; if BM is 32 bits per pixel, color with the 32 bit setting
    beq     Color_32bit
    
    bra     Color_24bit        ; otherwise color with 24 bit setting
    
    rts     

* -------------------------------------------------------------
Endian_Conversion
    move.l  4(sp),d0        
    rol.w   #8,d0           
    swap    d0              
    rol.w   #8,d0           
    
    rts
* -------------------------------------------------------------
* record color hex for 24 bit
Color_24bit
    move.b  #PEN_COLOR_TRAP_CODE,d0 ; sets pen color
    clr.l   d4
    move.b  (a0)+,d4    ; blue byte
    asl.l   #8,d4       ; shift register to make space for next byte
    
    move.b  (a0)+,d4    ; green byte
    asl.l   #8,d4
    
    move.b  (a0)+,d4    ; red byte
    
    move.l  d4,d1       ; set pen color
    
    trap    #15
    cmpi.w  #$18,BMBitsPPixel ; if BM is 24 bits per pixel, color with the 24 bit setting
    beq     Draw_Row
    
    rts
* -------------------------------------------------------------
* record color hex for 32 bit
Color_32bit
    move.b  #PEN_COLOR_TRAP_CODE,d0 ; sets pen color
    
    bsr     Color_24bit ; records the first 3 bytes
    
    add.l   #1,a0
    
*    asl.l   #8,d4       ; shift register to make space for next byte
*    move.b  (a0)+,d4    ; alpha byte
*    
*    asr.l   #8,d4       ; shift alpha byte out
   
    trap    #15
    

* -------------------------------------------------------------
* drawing pixels in the row
Draw_Row
    cmp.l   SelectionWidth,d3          ; ensures only width amount of pixels are drawn per row
    beq     Next_Row
    
    move.b  #DRAW_PIXEL_TRAP_CODE,d0    ; draws pixel with set color at specified position
    move.l  BMPosXDraw,d1                  ; draws pixel at specified position
    move.l  BMPosYDraw,d2
    trap    #15
    
    addq.l  #1,BMPosXDraw                  ; points to the next x position
    addq.l  #1,d3                       ; counter to ensure only the width amount of pixels are drawn per row
    
    cmpi.w  #$18,BMBitsPPixel          ; if BM is 32 bits per pixel, color with the 32 bit setting
    beq     Color_24bit
    
    bra     Color_32bit
 
*-------------------------------------------------------------
* keeping track of the number of rows drawn
Next_Row
    add.w   PaddingBytes,a0
    add.l   SelectionColorOffset,a0 ; skips rest of bytes for the row and moves pointer to next row in the pixel array
    move.l  BMPosX,BMPosXDraw              ; resets x position to its original
    cmpi.l  #0,BMPosY              ; ensures there are only n height rows drawn
    beq     Finish
    
    clr.l   d3                      ; resets the pixel per row counter
    subq.l  #1,BMPosYDraw           ; moves pen to next y position
    subq.l  #1,BMPosY               ; decreases height counter
    
    bra     Draw_Row
    
*--------------------------------------------------------------    
Set_Selection
* getting selection of bitmap to print 
* SelectionPos_x       dc.l    20
* SelectionPos_y       dc.l    20
* Selection_width      dc.l    100
* Selection_height     dc.l    100      

    move.l  BMWidth,d2
    move.l  BMBitsPPixel,d3
    
    move.l  SelectionPosX,d1           ; x pos
    move.l  SelectionPosY,d0           ; y pos
    
* calculating the offset of the starting point of the sub-image selection
    divu.w  #8,d3                   ; getting the bytes per pixel
 
    mulu.w  d3,d2                   ; image width x pytes per pixel
    mulu.w  d2,d0                   ; pos y * (image width x bytes per pixel)
    mulu.w  d3,d1                   ; pos x * (bytes per pixel)
    
    add.l   d0,d1                   ; (y product) + (x product)
    
    lea     SelectionStartOffset,a2
    move.l  d1,(a2)                      ; assigning value of offset to the offset variable
    add.l   SelectionStartOffset,a0     ; setting new starting position within pixel array
    
    clr.l   d3                      ; clearing d3 register
    
    move.l  BMPosYDraw,d0              ; setting pos y equal to the height of the image as well
    add.l   SelectionHeight,d0
    lea     BMPosYDraw, a2
    move.l  d0,(a2)
    
    lea     BMPosY,a2
    move.l  SelectionHeight,(a2) 
    
   
* Skipping bytes to adjust pointer to next row
    move.l  SelectionWidth,d0      ; getting the sub-image selection width
    move.l  BMWidth,d1             ; getting the original image width
    
    sub.l   d0,d1                   ; OG width - subwidth = # of bytes to skip for the next row
    
    cmpi.w  #$20,BMBitsPPixel       ; if BM is 32 bits per pixel, skip 24bit instruction
    beq     Selection_NextRow_Finish
    
Selection_24bit
    mulu.w  #3,d1                   ; multiplying by # of bytes per pixel for 24 bit image
    bra     Selection_NextRow_Finish
 
Selection_NextRow_Finish  
    lea     SelectionColorOffset,a2 ; assigning value to a variable 
    move.l  d1,(a2)
    
    rts

* -------------------------------------------------------------
* Header Info
* BMStart       ds.l    ; Starting position of pixel array     
* BMWidth       ds.l    ; image width
* BMHeight      ds.l    ; image height
* BMBitsPPixel  ds.l    ; bits per pixel of BM

BM_Header
    lea     START_OF_DATA,a0
    
    * recording address of first element of pixel array
    move.l  HEADER_STARTING_ADDRESS_OFFSET(a0),-(sp)        ; offset to find starting address
    bsr     Endian_Conversion   ; little to big endian conversion
    add.l   #4,sp               ; fix stack
    lea     BMStart,a2         ; moves address BM_width is stored at into register a2
    move.l  d0,(a2)             ; storing starting address offset value in BM_Start
    
    * recording width of BM
    move.l  HEADER_WIDTH_OFFSET(a0),-(sp)        ; offset from starting address to find value of width
    bsr     Endian_Conversion   ; little to big endian conversion
    add.l   #4,sp               ; fix stack
    lea     BMWidth,a2         ; moves address BM_width is stored at into register a2
    move.l  d0,(a2)             ; storing width value in BM_width
    
    * recording height of BM
    move.l  HEADER_HEIGHT_OFFSET(a0),-(sp)        ; offset from starting address to find value of width
    bsr     Endian_Conversion   ; little to big endian conversion
    add.l   #4,sp               ; fix stack
    lea     BMHeight,a2        ; moves address BM_width is stored at into register a2
    move.l  d0,(a2)             ; storing width value in BM_width
    
    * recording the BM's bits per pixel
    move.l  HEADER_BITSPPIXEL(a0),-(sp)        ; offset to find the number of bits per pixel of BM
    bsr     Endian_Conversion   ; little to big endian conversion
    add.l   #4,sp               ; fix stack
    lea     BMBitsPPixel,a2    ; moves address BM_width is stored at into register a2
    move.w  d0,(a2)             ; storing BPP value in BitsPPixel
    
    add.l   BMStart,a0         ; setting pointer to start of pixel array
    
    rts
*--------------------------------------------------------------
* padding for 24 bit odd images
   
Padding
    move.l  BMWidth,d0        ; setting d0 as the BM width
    
    mulu.w  #3,d0              ; multiply the number of bytes per pixel by the BM width             
    divu.w  #4,d0
    
    swap    d0
    clr.l   d1
    
    cmpi.w  #0,d0
    beq     Padding_Finish
    
    move.w  #4,d1              ; subtracting result from 4 to get the number of bytes needed for padding
    sub.w   d0,d1              ; 4-(width%4) = # of bytes for padding
    
Padding_Finish  
    lea     PaddingBytes,a2    ; accessing address of the padding variable
    move.w  d1,(a2)            ; storing the padding value in the padding variable
    
    rts
*--------------------------------------------------------------

Finish
    add.l   #16,sp      ; fix stack
    rts
* Put variables and constants here

START_OF_DATA
DataFromBMP         INCBIN "MachColor.bmp"
END_OF_DATA


ErrorMessage_WrongSignature dc.b 'Incorrect File Signature', 0

* Bitmap dimensions
*-----------------------------------
BMStart            ds.l    1
BMPosXDraw         ds.l    1
BMPosYDraw         ds.l    1
BMPosX             ds.l    1   
BMPosY             ds.l    1
BMWidth            ds.l    1
BMHeight           ds.l    1
BMBitsPPixel       ds.w    1
*-----------------------------------
*Other variables
*-----------------------------------
ScreenHeight        dc.w    720
ScreenWidth         dc.w    1080
PaddingBytes        ds.l    1
*-----------------------------------
*Selection Variables
*-----------------------------------
SelectionPosX          ds.l    1
SelectionPosY          ds.l    1
Selectionwidth         ds.l    1
SelectionHeight        ds.l    1
SelectionStartOffset   ds.l    1
SelectionColorOffset   ds.l    1

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
