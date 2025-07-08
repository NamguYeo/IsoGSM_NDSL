#!/bin/sh

set -a

CON_DIR=/rhome/yeong/test/svrtest/libs/con
F77=ifort
FTNID=fort.
FORT_OPTS="-r8 -O2 -convert big_endian -shared-intel -mcmodel=medium"
LOAD_OPTS="-r8 -O2 -convert big_endian"

if [ -s $CON_DIR/tune_new_max_nvvl.197901-12.ieee ] ; then
	echo ' '
	echo "$CON_DIR/tune_new_max_nvvl.197901-12.ieee already exist. Overwrite? ==>\c"
	read yn
	if [ "$yn" = x ] ; then
		exit 8
	elif [ "$yn" != y ] ; then
		exit
	fi
fi
echo ' '
echo 'Converting new reanalysis cloud tuning ..........'

INPFILE=tune_new_max_nvvl.197901-12.ieee
OUTFILE=${CON_DIR}/tune_new_max_nvvl.197901-12
cat >tunen.f <<'EOF'
      DIMENSION ICDART(15),IDART(4)
C
      PARAMETER(MCLD=3,NSEAL=2,NBIN=100,NLON=2,NLAT=4)
C
      DIMENSION RTNFFX(NBIN,NLON,NLAT,MCLD,NSEAL)
      DIMENSION KPTX(NLON,NLAT,MCLD,NSEAL)
C
      REAL*4 SFHRT
      REAL*4 STNFFX(NBIN,NLON,NLAT,MCLD,NSEAL)
C
      II=10
      IO=50
      READ (II) NBDART,ICDART
      PRINT 100,II,NBDART
  100 FORMAT(1H ,'..READING UNIT=',I3,'..DAYS ON FILE =',I5)
      WRITE(IO) NBDART,ICDART
C
      READ (II) SFHRT,IDART
      FHRT=SFHRT
      PRINT 150,IDART,FHRT
  150 FORMAT(5X,'...LAST DATE/TIME = TIME AND FORECAST HOUR',/,10X,
     1      4I15,F7.1)
      WRITE(IO) FHRT,IDART
C
      DO KD=1,NBDART
        PRINT 200,KD
  200   FORMAT(1H ,'---DAY NUMBER ',I2,'....FOR RTNEPH......')
        DO KK=1,2
          READ (II) STNFFX
          DO M=1,NSEAL
            DO L=1,MCLD
              DO K=1,NLAT
                DO J=1,NLON
                  DO I=1,NBIN
                    RTNFFX(I,J,K,L,M)=STNFFX(I,J,K,L,M)
                  ENDDO
                ENDDO
              ENDDO
            ENDDO
          ENDDO
          WRITE(IO) RTNFFX
        ENDDO
        READ (II) KPTX
        WRITE(IO) KPTX
      ENDDO
C
      STOP
      END
EOF
echo "$F77 $FORT_OPTS -o tunen.x tunen.f"
$F77 $FORT_OPTS -c tunen.f || exit 8
$F77 $LOAD_OPTS -o tunen.x tunen.o || exit 8

rm -f ${FTNID}[0-9]* 2>/dev/null 
ln -s $INPFILE		 ${FTNID}10
ln -s $OUTFILE     ${FTNID}50
./tunen.x  || exit 8
rm ${FTNID}10 ${FTNID}50
rm -f tunen.x tunen.f 
exit 0
