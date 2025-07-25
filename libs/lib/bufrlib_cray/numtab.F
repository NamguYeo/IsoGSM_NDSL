      SUBROUTINE NUMTAB(LUN,IDN,NEMO,TAB,IRET)                          
                                                                        
      COMMON /REPTAB/ IDNR(5,2),TYPS(5,2),REPS(5,2),LENS(5)             
      COMMON /TABABD/ NTBA(0:10),NTBB(0:10),NTBD(0:10),MTAB(50,10),     
     .                IDNA(50,10),IDNB(150,10),IDND(100,10),            
     .                TABA(50,10),TABB(150,10),TABD(100,10)             
                                                                        
      CHARACTER*(*) NEMO                                                
      CHARACTER*176 TABD                                                
      CHARACTER*120 TABB                                                
      CHARACTER*72  TABA                                                
      CHARACTER*56  DXSTR                                               
      CHARACTER*8   NEMT                                                
      CHARACTER*3   TYPS                                                
      CHARACTER*1   REPS,TAB                                            
                                                                        
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
                                                                        
      NEMO = ' '                                                        
      IRET = 0                                                          
      TAB = ' '                                                         
                                                                        
C  LOOK FOR A REPLICATOR OR A REPLICATOR FACTOR                         
C  --------------------------------------------                         
                                                                        
      IF(IDN.GE.IDNR(1,1) .AND. IDN.LE.IDNR(1,2)) THEN                  
         TAB  = 'R'                                                     
         IRET = -MOD(IDN,256)                                           
         RETURN                                                         
      ENDIF                                                             
                                                                        
      DO I=2,5                                                          
      IF(IDN.EQ.IDNR(I,1)) THEN                                         
         TAB  = 'R'                                                     
         IRET = I                                                       
         RETURN                                                         
      ELSEIF(IDN.EQ.IDNR(I,2)) THEN                                     
         TAB  = 'F'                                                     
         IRET = I                                                       
         RETURN                                                         
      ENDIF                                                             
      ENDDO                                                             
                                                                        
C  LOOK FOR IDN IN TABLE D                                              
C  -----------------------                                              
                                                                        
      DO I=1,NTBD(LUN)                                                  
      IF(IDN.EQ.IDND(I,LUN)) THEN                                       
         NEMO = TABD(I,LUN)(7:14)                                       
         TAB  = 'D'                                                     
         IRET = I                                                       
         RETURN                                                         
      ENDIF                                                             
      ENDDO                                                             
                                                                        
C  LOOK FOR IDN IN TABLE B                                              
C  -----------------------                                              
                                                                        
      DO I=1,NTBB(LUN)                                                  
      IF(IDN.EQ.IDNB(I,LUN)) THEN                                       
         NEMO = TABB(I,LUN)(7:14)                                       
         TAB  = 'B'                                                     
         IRET = I                                                       
         RETURN                                                         
      ENDIF                                                             
      ENDDO                                                             
                                                                        
      RETURN                                                            
      END                                                               
