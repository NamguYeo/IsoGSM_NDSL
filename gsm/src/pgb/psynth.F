#include <define.h>
      subroutine psynth(m,im,nc,nctop,km,pln,plntop,spc,spctop,f)               
c$$$  subprogram documentation block                                            
c                                                                               
c subprogram:    psynth      synthesize fourier from spectral                   
c   prgmmr: iredell          org: w/nmc23     date: 92-10-31                    
c                                                                               
c abstract: synthesizes fourier coefficients from spectral coefficients         
c           for a latitude pair (northern and southern hemispheres).            
c                                                                               
c program history log:                                                          
c   91-10-31  mark iredell                                                      
c                                                                               
c usage:    call psynth(m,im,nc,nctop,km,pln,plntop,spc,spctop,f)               
c                                                                               
c   input argument list:                                                        
c     m        - integer spectral truncation                                    
c     im       - integer dimension of fourier coefficients (im>=2*(m+1))        
c     nc       - integer dimension of spectral coefficients                     
c                (nc>=(m+1)*(m+2))                                              
c     nctop    - integer dimension of spectral coefficients over top            
c                (nctop>=2*(m+1))                                               
c     km       - integer number of fields                                       
c     pln      - real ((m+1)*(m+2)/2) legendre polynomial                       
c     plntop   - real (m+1) legendre polynomial over top                        
c     spc      - real (nc,km) spectral coefficients                             
c     spctop   - real (nctop,km) spectral coefficients over top                 
c                                                                               
c   output argument list:                                                       
c     f        - real (im,2,km) fourier coefficients for latitude pair          
c                                                                               
c subprograms called:                                                           
c   sgemvx1      cray library matrix times vector                               
c                                                                               
c attributes:                                                                   
c   language: cray fortran                                                      
c                                                                               
c$$$                                                                            
#ifdef CRAY_THREAD
cfpp$ noconcur r                                                                
#endif
      real pln((m+1)*(m+2)/2),plntop(m+1)                                       
      real spc(nc,km),spctop(nctop,km)                                          
      real f(im,2,km)                                                           
c
      mmax=min(m,(im-2)/2)
c
c  initialize fourier coefficients with terms over top of the spectrum.         
c  initialize even and odd polynomials separately.                              
c
      ltope=mod(mmax+1,2)
      ltopo=1-ltope                                                             
      do k=1,km                                                                 
        do l=ltope,mmax,2
          f(2*l+1,1,k)=plntop(l+1)*spctop(2*l+1,k)                              
          f(2*l+2,1,k)=plntop(l+1)*spctop(2*l+2,k)                              
          f(2*l+1,2,k)=0.                                                       
          f(2*l+2,2,k)=0.                                                       
        enddo                                                                   
        do l=ltopo,mmax,2
          f(2*l+1,1,k)=0.                                                       
          f(2*l+2,1,k)=0.                                                       
          f(2*l+1,2,k)=plntop(l+1)*spctop(2*l+1,k)                              
          f(2*l+2,2,k)=plntop(l+1)*spctop(2*l+2,k)                              
        enddo                                                                   
      enddo                                                                     
c
c  for each zonal wavenumber, synthesize terms over total wavenumber.           
c  synthesize even and odd polynomials separately.                              
c  commented code replaced by library calls.                                    
c
      do l=0,mmax                                                               
        is=l*(2*m+1-l)
        ip=is/2+1                                                               
#define DEFAULT
#ifdef SGEMVX1
#undef DEFAULT
        call sgemvx1(km,(m+2-l)/2,1.,spc(is+2*l+1,1),nc,4,pln(ip+l),2,          
     &               1.,f(2*l+1,1,1),im*2)                                      
        call sgemvx1(km,(m+2-l)/2,1.,spc(is+2*l+2,1),nc,4,pln(ip+l),2,          
     &               1.,f(2*l+2,1,1),im*2)                                      
        call sgemvx1(km,(m+1-l)/2,1.,spc(is+2*l+3,1),nc,4,pln(ip+l+1),2,        
     &               1.,f(2*l+1,2,1),im*2)                                      
        call sgemvx1(km,(m+1-l)/2,1.,spc(is+2*l+4,1),nc,4,pln(ip+l+1),2,        
     &               1.,f(2*l+2,2,1),im*2)                                      
#endif
#ifdef DEFAULT
        do n=l,m,2
          do k=1,km                                                             
            f(2*l+1,1,k)=f(2*l+1,1,k)+pln(ip+n)*spc(is+2*n+1,k)                 
            f(2*l+2,1,k)=f(2*l+2,1,k)+pln(ip+n)*spc(is+2*n+2,k)                 
          enddo                                                                 
        enddo                                                                   
        do n=l+1,m,2
          do k=1,km                                                             
            f(2*l+1,2,k)=f(2*l+1,2,k)+pln(ip+n)*spc(is+2*n+1,k)                 
            f(2*l+2,2,k)=f(2*l+2,2,k)+pln(ip+n)*spc(is+2*n+2,k)                 
          enddo                                                                 
        enddo                                                                   
#endif
      enddo                                                                     
c
c  separate fourier coefficients from each hemisphere.                          
c  odd polynomials contribute negatively to the southern hemisphere.            
c
      do k=1,km   
        do l=0,mmax
          f1r=f(2*l+1,1,k)                                                      
          f1i=f(2*l+2,1,k)                                                      
          f(2*l+1,1,k)=f1r+f(2*l+1,2,k)                                         
          f(2*l+2,1,k)=f1i+f(2*l+2,2,k)                                         
          f(2*l+1,2,k)=f1r-f(2*l+1,2,k)                                         
          f(2*l+2,2,k)=f1i-f(2*l+2,2,k)                                         
        enddo                                                                   
      enddo                                                                     
c 
c  zero out fourier waves outside of spectrum                                   
c
      if(2*m+3.gt.im) return
      do l2=2*m+3,im                                                            
        do k=1,km                                                               
          f(l2,1,k)=0.                                                          
          f(l2,2,k)=0.                                                          
        enddo                                                                   
      enddo                                                                     
c
      return                                                                    
      end                                                                       
