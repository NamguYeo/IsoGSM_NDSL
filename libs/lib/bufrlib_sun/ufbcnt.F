      SUBROUTINE UFBCNT(LUNIT,KMSG,KSUB)

      COMMON /MSGCWD/ NMSG(10),NSUB(10),MSUB(10),INODE(10),IDATE(10)

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C  CHECK THE FILE STATUS - RETURN THE MESSAGE AND SUBSET COUNTERS
C  --------------------------------------------------------------

      CALL STATUS(LUNIT,LUN,IL,IM)
      IF(IL.EQ.0) CALL ABORT('UFBCNT - FILE IS CLOSED')
      KMSG = NMSG(LUN)
      KSUB = NSUB(LUN)
      RETURN
      END
