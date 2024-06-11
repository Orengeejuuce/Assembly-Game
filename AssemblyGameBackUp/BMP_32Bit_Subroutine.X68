*-----------------------------------------------------------
* Title      : BMP_32Bit_Subroutine
* Written by : Haley Park
* Date       :
* Description:
*-----------------------------------------------------------
PEN_COLOR_TRAP_CODE             EQU     80
DRAW_PIXEL_TRAP_CODE            EQU     82
SET_OUTPUT_RESOLUTION_TRAP_CODE EQU     33 
TRANSPARENT_COLOR               EQU     $0000FF65
 
FILE_SIGNATURE                  EQU     $424D
PRINT_STRING_CR_LF              EQU     13

HEADER_STARTING_ADDRESS_OFFSET  EQU     10
HEADER_WIDTH_OFFSET             EQU     18
HEADER_HEIGHT_OFFSET            EQU     22
HEADER_BITSPPIXEL               EQU     28

* Reads in bitmap file and verifies file identity

* -------------------------------------------------------------
Check_File_Error
    move.l	#PRINT_STRING_CR_LF,d0           
    lea     ErrorMessage_WrongSignature, a1
    TRAP    #15
    SIMHALT

* -------------------------------------------------------------   
Check_File
    lea     START_OF_DATA,a0
    move.w  (a0)+,d0
    cmp.w   #FILE_SIGNATURE,d0   
    bne     Check_File_Error
    rts
* -------------------------------------------------------------
Initialize
    lea  SelectionWidth,a2
    move.l  8(sp),(a2)
    
    lea  SelectionHeight,a2   
    move.l  12(sp),(a2)
    
    lea  SelectionPosY,a2   
    move.l  16(sp),(a2)
    
    lea  SelectionPosX,a2
    move.l  20(sp),(a2)
    
    lea     BMPosY,a2
    move.l  24(sp),(a2)  

    lea     BMPosYDraw,a2
    move.l  BMPosY,(a2)  
  
    lea     BMPosX,a2
    move.l  28(sp),(a2) 
  
    lea     BMPosXDraw,a2
    move.l  BMPosX,(a2) 
    
    rts
    
* -------------------------------------------------------------
SetScreenResolution
    
    * Set Screen Resolution
    move.b  #SET_OUTPUT_RESOLUTION_TRAP_CODE,d0
    move.l  ScreenHeight,d1
    swap    d1
    trap    #15
    rts

* -------------------------------------------------------------
Display
    jsr     Check_File
    
    jsr     Initialize
    
    jsr     BM_Header           ; load header info into variables
    
    jsr     Set_Selection      ; set selection of pixels to print

    move.l  #0,d5              ; sets  d4 to true to indicate first iteration case
    
    jsr     Next_Row   
    
    rts     

* -------------------------------------------------------------
Endian_Conversion
    move.l  4(sp),d0        
    rol.w   #8,d0           
    swap    d0              
    rol.w   #8,d0           
    
    rts
* -------------------------------------------------------------
* record color hex for 32 bit
Color_32bit
    move.b  #PEN_COLOR_TRAP_CODE,d0 ; sets pen color
    
    move.l  (a0)+,d4
    lsr.l   #8,d4      
    move.l  d4,d1
   
    trap    #15
    
    rts

* -------------------------------------------------------------
* drawing pixels in the row
Draw_Row
    move.l  #1,d5                      ; sets d4 to false to show program has starting drawing rows
    jsr     Color_32bit
    cmp.l   #TRANSPARENT_COLOR,d4       ; checks for transparent color
    beq     Move_To_Next_Draw_Pos   
    
    move.b  #DRAW_PIXEL_TRAP_CODE,d0    ; draws pixel with set color at specified position
    move.l  BMPosXDraw,d1                  ; draws pixel at specified position
    move.l  BMPosYDraw,d2
    trap    #15

Move_To_Next_Draw_Pos   
    addq.l  #1,BMPosXDraw               ; points to the next x position
    addq.l  #1,d3                       ; counter to ensure only the width amount of pixels are drawn per row
    
    cmp.l   SelectionWidth,d3          ; ensures only width amount of pixels are drawn per row
    beq     Next_Row
    
    bra     Draw_Row
  
*-------------------------------------------------------------
* keeping track of the number of rows drawn
Next_Row
    cmpi.l  #0,d5                   ; if true, skip first iteration of next_row 
    beq     Draw_Row
    
    add.l   SelectionColorOffset,a0 ; skips rest of bytes for the row and moves pointer to next row in the pixel array
    move.l  BMPosX,BMPosXDraw              ; resets x position to its original
    
    clr.l   d3                      ; resets the pixel per row counter
    subq.l  #1,BMPosYDraw           ; moves pen to next y position
    subq.l  #1,SelectionHeight
    
    cmpi.l  #1,SelectionHeight              ; ensures there are only n height rows drawn
    bgt     Draw_Row
    
    rts  
      
*--------------------------------------------------------------
Set_Selection
* getting selection of bitmap to print 
* SelectionPos_x       dc.l    20
* SelectionPos_y       dc.l    20
* Selection_width      dc.l    100
* Selection_height     dc.l    100      

    move.l  BMWidth,d2
    move.w  BMBitsPPixel,d3
    
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
    
    mulu.w  d3,d1                   ; multiplying by # of bytes per pixel for 24 bit image

 
    lea     SelectionColorOffset,a2 ; assigning value to a variable 
    move.l  d1,(a2)
 
    clr.l   d3                      ; clearing d3 register   
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
    jsr     Endian_Conversion                   ; little to big endian conversion
    add.l   #4,sp                               ; fix stack
    lea     BMStart,a2                          ; moves address BM_width is stored at into register a2
    move.l  d0,(a2)                             ; storing starting address offset value in BM_Start
    
    * recording width of BM
    move.l  HEADER_WIDTH_OFFSET(a0),-(sp)       ; offset from starting address to find value of width
    jsr     Endian_Conversion                   ; little to big endian conversion
    add.l   #4,sp                               ; fix stack
    lea     BMWidth,a2                          ; moves address BM_width is stored at into register a2
    move.l  d0,(a2)                             ; storing width value in BM_width
    
    * recording height of BM
    move.l  HEADER_HEIGHT_OFFSET(a0),-(sp)      ; offset from starting address to find value of width
    jsr     Endian_Conversion  
    add.l   #4,sp               
    lea     BMHeight,a2        
    move.l  d0,(a2)            
    
    * recording the BM's bits per pixel
    move.l  HEADER_BITSPPIXEL(a0),-(sp)         ; offset to find the number of bits per pixel of BM
    jsr     Endian_Conversion  
    add.l   #4,sp               
    lea     BMBitsPPixel,a2    
    move.w  d0,(a2)            
    
    add.l   BMStart,a0         ; setting pointer to start of pixel array
    
    rts

*--------------------------------------------------------------

START_OF_DATA
DataFromBMP         INCBIN "TrashSortAssets.bmp"
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
