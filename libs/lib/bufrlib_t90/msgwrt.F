      5000 MSGWRT(LUNIT,MBAY,MBYT)                                
                                                                        
      COMMON /HRDWRD/ NBYTW,NBITW,NREV,IORD(8)                          
                                                                        
      CHARACTER*4 BUFR,SEVN                                             
      DIMENSION   MBAY(*)                                               
                                                                        
      DATA BUFR/'BUFR'/                                                 
      DATA SEVN/'7777'/                                                 
      DATA NMCD/   99 /                                                 
                                                                        
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
                                                                        
C  MAKE SURE ALL SECTIONS HAVE EVEN NUMBER OF BYTES                     
C  ------------------------------------------------                     
                                                                        
      IAD1 = 8                                                          
      LEN1 = IUPB(MBAY,IAD1+1,24)                                       
      LEN2 = IUPB(MBAY,IAD1+8, 1)                                       
      IAD2 = IAD1+LEN1                                                  
      LEN2 = IUPB(MBAY,IAD2+1,24)*LEN2                                  
      IAD3 = IAD2+LEN2                                                  
      LEN3 = IUPB(MBAY,IAD3+1,24)                                       
      IAD4 = IAD3+LEN3                                                  
      LEN4 = IUPB(MBAY,IAD4+1,24)                                       
                                                                        
      IF(MOD(LEN1,2).NE.0) GOTO 901                                     
      IF(MOD(LEN2,2).NE.0) GOTO 902                                     
      IF(MOD(LEN3,2).NE.0) GOTO 903                                     
      IF(MOD(LEN4,2).NE.0) THEN                                         
         IBIT = IAD4*8                                                  
         LEN4 = LEN4+1                                                  
         CALL PKB(LEN4,24,MBAY,IBIT)                                    
         IAD5 = IAD4+LEN4                                               
         IBIT = IAD5*8                                                  
         CALL PKB(0,8,MBAY,IBIT)                                        
         MBYX = MBYT+1                                                  
      ELSE                                                              
         MBYX = MBYT                                                    
      ENDIF                                                             
                                                                        
C  WRITE SECTION 0, NMC CODE, AND SECTION 5                             
C  ----------------------------------------                             
                                                                        
      IBIT = 0                                                          
      JBIT = 12*8                                                       
      KBIT = (MBYX-4)*8                                                 
                                                                        
      CALL PKC(BUFR, 4,MBAY,IBIT)                                       
      CALL PKB(MBYX,24,MBAY,IBIT)                                       
      CALL PKB(   2, 8,MBAY,IBIT)                                       
      CALL PKB(NMCD,16,MBAY,JBIT)                                       
      CALL PKC(SEVN, 4,MBAY,KBIT)                                       
                                                                        
C  ZERO OUT THE EXTRA BYTES WHICH WILL BE WRITTEN                       
C  ----------------------------------------------                       
                                                                        
      CALL PKB(0,NBITW,MBAY,KBIT)                                       
                                                                        
C  WRITE THE MESSAGE PLUS PADDING TO A WORD BOUNDARY                    
C  -------------------------------------------------                    
                                                                        
      MWRD = MBYX/NBYTW + 1                                             
      WRITE(LUNIT) (MBAY(I),I=1,MWRD)                                   
C     PRINT*,'MSGWRT - LUNIT=',LUNIT,' BYTES=',MBYX                     
                                                                        
      RETURN                                                            
901   PRINT *,'MSGWRT - UNEVEN SECTION 1'
      CALL ABORT
902   PRINT *,'MSGWRT - UNEVEN SECTION 2'
      CALL ABORT
903   PRINT *,'MSGWRT - UNEVEN SECTION 3'
      CALL ABORT
      END                                                               
