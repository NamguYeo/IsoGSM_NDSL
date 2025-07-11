      block data bdpkap                                                         
c$$$   subprogram  documentation  block                                         
c                                                                               
c subprogram: bdpkap       set default coefficients for p**kappa                
c   author: phillips         org: w/nmc2x2   date: 29 dec 82                    
c                                                                               
c abstract: set default coefficients for p**kappa.  subprogram gpkap was        
c   used to compute a rational weighted chebyshev approximation to              
c   pressure raised to the kappa power for use by the function fpkap.           
c   the numerator is of order 2 and the denominator is of order 4.              
c   the pressure range is 40-110 kpa and kappa is 287.05/1004.6.                
c   imsl subprogram ratch is used to compute coefficients.                      
c   see subprograms gpkap and fpkap for more details.                           
c                                                                               
c program history log:                                                          
c   94-12-30  iredell                                                           
c                                                                               
c common blocks:                                                                
c   compkap  - coefficients for function fpkap                                  
c                                                                               
c attributes:                                                                   
c   language: fortran 77.                                                       
c   machine:  cray.                                                             
c                                                                               
c$$$                                                                            
      common/compkap/ cn0,cn1,cn2,cd0,cd1,cd2,cd3,cd4                           
      data cn0,cn1,cn2                                                          
     & /   3.13198449e-1,5.78544829e-2, 8.35491871e-4/                          
      data cd0,cd1,cd2,cd3,cd4                                                  
     & /1.,8.15968401e-2,5.72839518e-4,-4.86959812e-7,5.24459889e-10/           
      end                                                                       
