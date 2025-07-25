      subroutine rosr12 (p,a,b,c,d,delta,nsoil)
c
      implicit none
c
c ----------------------------------------------------------------------
c subroutine rosr12
c ----------------------------------------------------------------------
c invert (solve) the tri-diagonal matrix problem shown below:
c ###                                            ### ###  ###   ###  ###
c #b(1), c(1),  0  ,  0  ,  0  ,   . . .  ,    0   # #      #   #      #
c #a(2), b(2), c(2),  0  ,  0  ,   . . .  ,    0   # #      #   #      #
c # 0  , a(3), b(3), c(3),  0  ,   . . .  ,    0   # #      #   # d(3) #
c # 0  ,  0  , a(4), b(4), c(4),   . . .  ,    0   # # p(4) #   # d(4) #
c # 0  ,  0  ,  0  , a(5), b(5),   . . .  ,    0   # # p(5) #   # d(5) #
c # .                                          .   # #  .   # = #   .  #
c # .                                          .   # #  .   #   #   .  #
c # .                                          .   # #  .   #   #   .  #
c # 0  , . . . , 0 , a(m-2), b(m-2), c(m-2),   0   # #p(m-2)#   #d(m-2)#
c # 0  , . . . , 0 ,   0   , a(m-1), b(m-1), c(m-1)# #p(m-1)#   #d(m-1)#
c # 0  , . . . , 0 ,   0   ,   0   ,  a(m) ,  b(m) # # p(m) #   # d(m) #
c ###                                            ### ###  ###   ###  ###
c ----------------------------------------------------------------------
      integer k
      integer kk
      integer nsoil
c      
      real a(nsoil)
      real b(nsoil)
      real c(nsoil)
      real d(nsoil)
      real delta(nsoil)
      real p(nsoil)
c ----------------------------------------------------------------------
c initialize eqn coef c for the lowest soil layer
c ----------------------------------------------------------------------
      c(nsoil) = 0.0
c ----------------------------------------------------------------------
c solve the coefs for the 1st soil layer
c ----------------------------------------------------------------------
      p(1) = -c(1) / b(1)
      delta(1) = d(1) / b(1)
c ----------------------------------------------------------------------
c solve the coefs for soil layers 2 thru nsoil
c ----------------------------------------------------------------------
      do k = 2,nsoil
        p(k) = -c(k) * ( 1.0 / (b(k) + a (k) * p(k-1)) )
        delta(k) = (d(k)-a(k)*delta(k-1))*(1.0/(b(k)+a(k)*p(k-1)))
      end do
c ----------------------------------------------------------------------
c set p to delta for lowest soil layer
c ----------------------------------------------------------------------
      p(nsoil) = delta(nsoil)
c ----------------------------------------------------------------------
c adjust p for soil layers 2 thru nsoil
c ----------------------------------------------------------------------
      do k = 2,nsoil
         kk = nsoil - k + 1
         p(kk) = p(kk) * p(kk+1) + delta(kk)
      end do
c ----------------------------------------------------------------------
c end subroutine rosr12
c ----------------------------------------------------------------------
      return
      end
