      SUBROUTINE TRYBUMP(LUNIT,LUN,USR,I1,I2,IO,IRET)
#include "ufbprm.h"
      integer TAB_,SEQ_
      parameter(INV_=_INV_,TAB_=_TAB_,SEQ_=_SEQ_)
      COMMON /USRINT/ NVAL(10),INV(INV_,10),VAL(INV_,10)
      COMMON /USRSTR/ NNOD,NCON,NODS(20),NODC(10),VALS(10),KONS(10)

      REAL*8 USR(I1,I2),VAL
      REAL*4 VALS

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C  SEE IF THERE IS A DRP GROUP INVOLVED
C  ------------------------------------

      NDRP = LSTJPB(NODS(1),LUN,'DRP')
      IF(NDRP.LE.0) RETURN

C  IF SO, CLEAN IT OUT, BUMP IT TO I2, AND TRY UFBRW AGAIN
C  -------------------------------------------------------

      INVN = INVWIN(NDRP,LUN,1,NVAL(LUN))
      VAL(INVN,LUN) = 0
      JNVN = INVN+1
      DO WHILE(NINT(VAL(JNVN,LUN)).GT.0)
         JNVN = JNVN+NINT(VAL(JNVN,LUN))
      ENDDO
      DO KNVN=1,NVAL(LUN)-JNVN+1
      INV(INVN+KNVN,LUN) = INV(JNVN+KNVN-1,LUN)
      VAL(INVN+KNVN,LUN) = VAL(JNVN+KNVN-1,LUN)
      ENDDO
      NVAL(LUN) = NVAL(LUN)-(JNVN-INVN-1)
      CALL USRTPL(LUN,INVN,I2)
      CALL UFBRW(LUN,USR,I1,I2,IO,IRET)

      RETURN
900   CALL ABORT('TRYBUMP - ATTEMPT TO BUMP NON-ZERO REP FACTOR')
      END
