#define LATG latg
      subroutine gausslat(k,a,w)                                                
c$$$  subprogram documentation block                                            
c                                                                               
c subprogram:  gausslat   compute gaussian latitudes                            
c   prgmmr: iredell       org: w/nmc23       date: 92-04-16                     
c                                                                               
c abstract: computes cosines of colatitude and gaussian weights                 
c   on the gaussian latitudes.  the k gaussian latitudes are at                 
c   the zeroes of the legendre polynomial of order k.                           
c                                                                               
c program history log:                                                          
c   92-04-16  iredell                                                           
c                                                                               
c usage:    call gausslat(k,a,w)                                                
c                                                                               
c   input argument list:                                                        
c     k        - number of latitudes.                                           
c                                                                               
c   output argument list:                                                       
c     a        - real (k) cosines of colatitude.                                
c     w        - real (k) gaussian weights.                                     
c                                                                               
c   remarks: fortran 9x extensions are used.                                    
c                                                                               
c attributes:                                                                   
c   cray ymp.                                                                   
c                                                                               
c$$$                                                                            
#include <paramodel.h>
      save                                                                      
      dimension a(k),w(k)                                                       
      parameter(npk=latg_/2)                                                    
      dimension pk(npk),pkm1(npk),pkm2(npk)                                     
      parameter(kz=50)                                                          
      dimension bz(kz)                                                          
      data bz        / 2.4048255577,  5.5200781103,                             
     $  8.6537279129, 11.7915344391, 14.9309177086, 18.0710639679,              
     $ 21.2116366299, 24.3524715308, 27.4934791320, 30.6346064684,              
     $ 33.7758202136, 36.9170983537, 40.0584257646, 43.1997917132,              
     $ 46.3411883717, 49.4826098974, 52.6240518411, 55.7655107550,              
     $ 58.9069839261, 62.0484691902, 65.1899648002, 68.3314693299,              
     $ 71.4729816036, 74.6145006437, 77.7560256304, 80.8975558711,              
     $ 84.0390907769, 87.1806298436, 90.3221726372, 93.4637187819,              
     $ 96.6052679510, 99.7468198587, 102.888374254, 106.029930916,              
     $ 109.171489649, 112.313050280, 115.454612653, 118.596176630,              
     $ 121.737742088, 124.879308913, 128.020877005, 131.162446275,              
     $ 134.304016638, 137.445588020, 140.587160352, 143.728733573,              
     $ 146.870307625, 150.011882457, 153.153458019, 156.295034268 /             
      pi=4.*atan(1.)                                                            
      c=(1.-(2./pi)**2)*0.25                                                    
      eps=1.e-14                                                                
      kh=k/2                                                                    
      r=1./sqrt((k+0.5)**2+c)                                                   
      do j=1,min(kh,kz)                                                         
        a(j)=cos(bz(j)*r)                                                       
      enddo                                                                     
      do j=kz+1,kh                                                              
        a(j)=cos((bz(kz)+(j-kz)*pi)*r)                                          
      enddo                                                                     
      spmax=1.                                                                  
      kount=0                                                                   
      do while(spmax.gt.eps)                                                    
        kount=kount+1                                                           
				print *,'in the gausslat loop. kount=',kount                                
        spmax=0.                                                                
        do j=1,kh                                                               
          pkm1(j)=1.                                                            
          pk(j)=a(j)                                                            
        enddo                                                                   
        do n=2,k                                                                
          do j=1,kh                                                             
            pkm2(j)=pkm1(j)                                                     
            pkm1(j)=pk(j)                                                       
            pk(j)=((2*n-1)*a(j)*pkm1(j)-(n-1)*pkm2(j))/n                        
          enddo                                                                 
        enddo                                                                   
        do j=1,kh                                                               
          sp=pk(j)*(1.-a(j)**2)/(k*(pkm1(j)-a(j)*pk(j)))                        
          a(j)=a(j)-sp                                                          
          spmax=max(spmax,abs(sp))                                              
        enddo                                                                   
        if(kount.gt.20) go to 700                                               
      enddo                                                                     
#ifdef CRAY_THREAD
cdir$ ivdep                                                                     
#endif
      do j=1,kh                                                                 
        w(j)=(2.*(1.-a(j)**2))/(k*pkm1(j))**2                                   
        a(k+1-j)=a(j)                                                           
        w(k+1-j)=w(j)                                                           
      enddo                                                                     
      if(k.ne.kh*2) then                                                        
        j=kh+1                                                                  
        a(j)=0.                                                                 
        w(j)=1./k**2                                                            
        do n=2,k,2                                                              
          w(j)=w(j)*n**2/(n-1)**2                                               
        enddo                                                                   
      endif                                                                     
      return                                                                    
  700 continue                                                                  
      print *,'gaulat not converging'                                           
      call abort                                                                
      end                                                                       
