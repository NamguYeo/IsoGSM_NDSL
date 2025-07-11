      FUNCTION NVNWIN(NODE,LUN,INV1,INV2,INVN,NMAX)
#include "ufbprm.h"
      integer TAB_,SEQ_
      parameter(INV_=_INV_,TAB_=_TAB_,SEQ_=_SEQ_)

      COMMON /MSGCWD/ NMSG(10),NSUB(10),MSUB(10),INODE(10),IDATE(10)
      COMMON /TABLES/ MAXTAB,NTAB,TAG(TAB_),TYP(TAB_),KNT(TAB_),
     .                JUMP(TAB_),LINK(TAB_),JMPB(TAB_),
     .                IBT(TAB_),IRF(TAB_),ISC(TAB_),
     .                ITP(TAB_),VALI(TAB_),KNTI(TAB_),
     .                ISEQ(TAB_,2),JSEQ(SEQ_)
      COMMON /USRINT/ NVAL(10),INV(INV_,10),VAL(INV_,10)

      CHARACTER*10 TAG
      CHARACTER*3  TYP
      DIMENSION    INVN(NMAX)
      REAL*8       VAL

      DATA BMISS/10E10/

C----------------------------------------------------------------------
C----------------------------------------------------------------------

      IF(NODE.EQ.0) RETURN
      NVNWIN = 0

      DO I=1,NMAX
      INVN(I) = BMISS
      ENDDO

C  SEARCH BETWEEN INV1 AND INV2
C  ----------------------------

      DO N=INV1,INV2
      IF(INV(N,LUN).EQ.NODE) THEN
         NVNWIN = NVNWIN+1
         INVN(NVNWIN) = N
      ENDIF
      ENDDO

      IF(NVNWIN.GT.NMAX) CALL ABT('NVNWIN - TOO MANY EVENTS')

      RETURN
      END
