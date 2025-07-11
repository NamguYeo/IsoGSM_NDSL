#include <define.h>
      SUBROUTINE W3FP11 (IPDS0, IPDS, TITL, IERR)
C$$$  SUBPROGRAM DOCUMENTATION  BLOCK
C                .      .    .                                       .
C SUBPROGRAM:  W3FP11        ONE-LINE GRIB TITLER FROM PDS SECTION
C   PRGMMR: MCCLEES          ORG: NMC421      DATE:88-02-02
C
C ABSTRACT: CONVERTS GRIB FORMATTED PRODUCT DEFINITION SECTION VERSION 
C   1 TO A ONE LINE READABLE TITLE.  GRIB SECTION 0 IS ALSO TESTED TO
C   VERIFY THAT GRIB DATA IS BEING DECIPHERED.
C
C PROGRAM HISTORY LOG:
C   91-06-19  R.E.JONES
C   92-05-29  R.E.JONES   ADD WATER TEMP TO TABLES  
C   93-01-19  R.E.JONES   ADD MONTGOMARY STREAM FUNCTION TO TABLES 
C                         ADD CODE FOR SURFACE VALUE 113.
C                         ADD CONDENSATION PRESSURE TO TABLES
C   93-02-19  R.E.JONES   ADD CAPE AND TKE (157 & 158) TO TABLES
C   93-02-24  R.E.JONES   ADD GRIB TYPE PMSLE (130) TO TABLES
C   93-03-26  R.E.JONES   ADD GRIB TYPE SGLYR (175) TO TABLES
C   93-03-27  R.E.JONES   CHANGES FOR REVISED O.N.388 MAR. 3,1993
C   93-03-29  R.E.JONES   ADD SAVE STATEMENT
C   93-04-16  R.E.JONES   ADD GRIB TYPE LAT, LON (176,177) TO TABLES
C   93-04-25  R.E.JONES   ADD GRIB TYPE 204, 205, 211, 212, 218
C   93-05-18  R.E.JONES   ADD TEST FOR MODEL 70
C   93-06-26  R.E.JONES   ADD GRIB TYPE 128, 129, TAKE OUT TEST FOR
C                         MODEL 86.
C   93-08-07  R.E.JONES   ADD GRIB TYPE 156 (CIN), 150 (CBMZW),
C                         151 (CBTZW), 152 (CBTMW) TO TABLES.
C   93-10-14  R.E.JONES   CHANGE FOR O.N. 388 REV. OCT. 8,1993
C   93-10-29  R.E.JONES   CHANGE FOR 'L CDC' 'M CDC' 'H CDC'
C   93-10-14  R.E.JONES   CHANGE FOR O.N. 388 REV. NOV. 19,1993
C   94-02-05  R.E.JONES   CHANGE FOR O.N. 388 REV. DEC. 14,1993
C                         ADD MODEL NUMBER 86 AND 87.
C   94-03-24  R.E.JONES   ADD GRIB TYPE 24 (TOTO3), 206 (UVPI)
C   94-06-04  R.E.JONES   CHANGE UVPI TO UVI
C   94-06-16  R.E.JONES   ADD GRIB TYPE 144,145,146,147,148,149
C                         SOILW,PEVPR,CWORK,U-GWD,V-GWD,PV TO TABLES.
C   94-06-22  R.E.JONES   ADD NCAR (60) TO CENTERS
C   94-07-25  R.E.JONES   CORRECTION FOR 71, 72, 213 (T CDC), (CDCON),
C                         (CDLYR)
C   94-10-27  R.E.JONES   ADD GRIB TYPE 191 (PROB), 192 (PROBN), ADD
C                         TEST FOR MODEL 90, 91, 92, 93, ADD SUB
C                         CENTER 2.
C   95-02-09  R.E.JONES   CORRECTION FOR CENTURY FOR FNOC
C   95-04-11  R.E.JONES   CORRECTION FOR LMH AND LMV
C   95-06-20  R.E.JONES   ADD GRIB TYPE 189 (VSTM), 190 (HLCY), 193
C                         (POP), 194 (CPOFP), 195 (CPOZP), 196
C                         (USTM), 197 (VSTM) TO TABLES.
C   95-08-07  R.E.JONES   ADD GRIB TYPE 153 (CLWMR), 154 (O3MR), 221
C                         (HPBL), 237 (O3TOT). 
C   95-09-07  R.E.JONES   TAKE OUT GRIB TYPE 24 (TOTO3), CHANGE TO
C                         GRIB TYPE 10 (TOZNE). ADD LEVEL 117,
C                         POTENTIAL VORTITICITY (pv) LEVEL, ADD ETA
C                         LEVEL 119, ADD 120 LAYER BETWWEN TWO ETA
C                         LEVELS. CHANGE NAME OF LEVEL 107 TO (SIGL),
C                         CHANGE NAME OF LEVEL 108 TO (SIGY).
C   95-09-26  R.E.JONES   ADD LEVEL 204 (HTFL) HIGHEST TROPSPHERE
C                         FREEZING LEVEL.
C   95-10-19  R.E.JONES   CHANGE SOME OF THE LEVEL ABREVIATIONS. 
C   95-12-13  R.E.JONES   ADD 8 SUB-CENTERS TO TABLES
C   96-03-04  R.E.JONES   CHANGES FOR O.N. 388   JAN 2, 1996
C   96-03-22  R.E.JONES   CHANGE SCUSF TO CSUSF
C   96-10-01  IREDELL     RECOGNIZE FORECAST TIME UNITS 1 TO 12
C                         AND CORRECT FOR YEAR 2000
C   96-10-31  R.E.JONES   CHANGE ARRAY AND TABLE FOR ICS1 TO 10.
C   96-10-01  IREDELL     ALLOW PARAMETER TABLE VERSION UP TO 127
C   98-05-26  Gilbert     Added 17 new parameters ( GRIB Table 2 )
C                         Added 6 new special Levels for clouds
C                         (GRIB table 3a)
C                         Added Subcenter 11 (TDL) under center 7 (NCEP)
C   98-12-21  Gilbert     Replaced Function ICHAR with mova2i.
C   01-01-05  VUONG       ADD GRIB TYPE 247 (EHLT) TO TABLES.
C   02-05-01  VUONG       CHANGES FOR O.N. 388   MAR 21, 2002
C
C USAGE:    CALL W3FP11  (IPDS0,  IPDS,  TITL, IERR )
C   INPUT ARGUMENT LIST:
C     IPDS0    - GRIB SECTION 0 READ AS CHARACTER*8
C     IPDS     - GRIB PDS SECTION READ AS CHARACTER*28
C
C   OUTPUT ARGUMENT LIST:   
C     TITL     - CHARACTER*86 OUTPUT PRINT LINE
C     IERR   0 - COMPLETED SATISFACTORILY
C            1 - GRIB SECTION 0, CAN NOT FIND 'GRIB'
C            2 - GRIB IS NOT VERSION 1
C            3 - LENGTH OF PDS SECTION IS LESS THAN 28
C            4 - COULD NOT MATCH TYPE INDICATOR
C            5 - COULD NOT MATCH TYPE LEVEL
C            6 - COULD NOT INTERPRET ORIGINATOR OF CODE
C            7 - COULD NOT INTERPRET SUB CENTER 7 ORIGINATOR OF CODE
C            8 - COULD NOT INTERPRET SUB CENTER 9 ORIGINATOR OF CODE
C            9 - PARAMETER TABLE VERSION NOT 1 OR 2
C
C ATTRIBUTES:
C   LANGUAGE: SiliconGraphics 3.5 FORTRAN 77
C   MACHINE:  SiliconGraphics IRIS-4D/25, 35, INDIGO, Indy
C   LANGUAGE: IBM VS FORTRAN, CRAY CFT77 FORTRAN
C   MACHINE:  HDS, CRAY C916/16256, J916/162048
C
C$$$
C
        INTEGER         CENTER(15)
        INTEGER         SCNTR1(14)
        INTEGER         SCNTR2(14)
        INTEGER         FCSTIM
        INTEGER         HH(252)
        INTEGER         HH1(105)
        INTEGER         HH2(105)
        INTEGER         HH3(42)
        INTEGER         HHH(55)
        INTEGER         IERR
        INTEGER         P1
        INTEGER         P2
        INTEGER         TIMERG
C
        CHARACTER * 6   HHNAM(252)
        CHARACTER * 6   HHNAM1(105)
        CHARACTER * 6   HHNAM2(105)
        CHARACTER * 6   HHNAM3(42)
        CHARACTER * 4   HHHNAM(55)
        CHARACTER * (*) IPDS 
        CHARACTER * 8   IPDS0
        CHARACTER * 28  IDPDS
        CHARACTER * 4   GRIB
        CHARACTER * 28  KNAM1(15)
        CHARACTER * 28  KNAM2(14)
        CHARACTER * 28  KNAM3(14)
        CHARACTER * 3   MONTH(12)
        CHARACTER * 4   TIMUN(12)
        CHARACTER * 2   TIMUN1(12)
        CHARACTER * 86  TITL
C
        EQUIVALENCE     (HH(1),HH1(1))
        EQUIVALENCE     (HH(106),HH2(1))
        EQUIVALENCE     (HH(211),HH3(1))
        EQUIVALENCE     (HHNAM(1),HHNAM1(1))
        EQUIVALENCE     (HHNAM(106),HHNAM2(1))
        EQUIVALENCE     (HHNAM(211),HHNAM3(1))
C
        SAVE
C
        DATA  CENTER/  7,   8,   9,  34,  52,  54,  57, 
     &                58,  59,  60,  74,  85,  97,  98, 
     &                99/
        DATA  HH1  /
     &                 1,   2,   3,   5,   6,   7,   8,  
     &                 9,  10,  11,  12,  13,  14,  15,    
     &                16,  17,  18,  19,  20,  21,  22,
     &                23,  24,  25,  26,  27,  28,  29,  
     &                30,  31,  32,  33,  34,  35,  36,   
     &                37,  38,  39,  40,  41,  42,  43, 
     &                44,  45,  46,  47,  48,  49,  50, 
     &                51,  52,  53,  54,  55,  56,  57, 
     &                58,  59,  60,  61,  62,  63,  64,
     &                65,  66,  67,  68,  69,  70,  71,
     &                72,  73,  74,  75,  76,  77,  78,
     &                79,  80,  81,  82,  83,  84,  85,
     &                86,  87,  88,  89,  90,  91,  92,
     &                93,  94,  95,  96,  97,  98,  99, 
     &               100, 101, 102, 103, 104, 105, 106/
        DATA  HH2  /
     &               107, 108, 109, 110, 111, 112, 113, 
     &               114, 115, 116, 117, 121, 122, 123,
     &               124, 125, 126, 127, 128, 129, 130, 
     &               131, 132, 133, 134, 135, 136, 137,
     &               138, 139, 140, 141, 142, 143, 144,
     &               145, 146, 147, 148, 149, 150, 151,  
     &               152, 153, 154, 155, 156, 157, 158,
     &               159, 160, 161, 162, 163, 164, 165,
     &               166, 167, 168, 169, 172, 173, 174,
     &               175, 176, 177, 181, 182, 183, 184, 
     &               189, 190, 191, 192, 193, 194, 195,
     &               196, 197, 201, 204, 205, 206, 207,
     &               208, 209, 211, 212, 213, 214, 215, 
     &               216, 217, 218, 219, 220 ,221, 222,
     &               223, 226, 227, 228, 229, 231, 232/
        DATA  HH3  /
     &               233, 234, 235, 237, 238, 239, 241,
     &               242, 243, 244, 245, 246, 247, 248,
     &               249, 250, 251, 252, 253, 254, 255,
     &                 4, 118, 119, 120, 170, 171, 178,
     &               179, 185, 186, 187, 198, 199, 200,
     &               224, 225, 230, 180, 202, 210, 240/ 
        DATA  HHH  /   1,   2,   3,   4,   5,   6,   7,
     &                 8,   9,  20, 100, 101, 102, 103,
     &               104, 105, 106, 107, 108, 109, 110,
     &               111, 112, 113, 114, 115, 116, 117,
     &               119, 120, 121, 125, 128, 141, 160, 
     &               200, 201, 204, 212, 213, 214, 222,
     &               223, 224, 232, 233, 234, 209, 210,
     &               211, 242, 243, 244, 246, 247/
       DATA  HHHNAM/'SFC ','CBL ','CTL ','0DEG','ADCL','MWSL','TRO ',
     &              'NTAT','SEAB','TMPL','ISBL','ISBY','MSL ','GPML',
     &              'GPMY','HTGL','HTGY','SIGL','SIGY','HYBL','HYBY',
     &              'DBLL','DBLY','THEL','THEY','SPDL','SPDY','PVL ',
     &              'ETAL','ETAY','IBYH','HGLH','SGYH','IBYM','DBSL',
     &              'EATM','EOCN','HTFL','LCBL','LCTL','LCY ','MCBL',
     &              'MCTL','MCY ','HCBL','HCTL','HCY ','BCBL','BCTL',
     &              'BCY ','CCBL','CCTL','CCY ','MTHE','EHLT'/
       DATA  HHNAM1/ 
     &' PRES ',' PRMSL',' PTEND',' ICAHT',' GP   ',' HGT  ',' DIST ',
     &' HSTDV',' TOZNE',' TMP  ',' VTMP ',' POT  ',' EPOT ',' T MAX',
     &' T MIN',' DPT  ',' DEPR ',' LAPR ',' VIS  ',' RDSP1',' RDSP2',
     &' RDSP3',' PLI  ',' TMP A',' PRESA',' GP A ',' WVSP1',' WVSP2',
     &' WVSP3',' WDIR ',' WIND ',' U GRD',' V GRD',' STRM ',' V POT',
     &' MNTSF',' SGCVV',' V VEL',' DZDT ',' ABS V',' ABS D',' REL V',
     &' REL D',' VUCSH',' VVCSH',' DIR C',' SP C ',' UOGRD',' VOGRD',
     &' SPF H',' R H  ',' MIXR ',' P WAT',' VAPP ',' SAT D',' EVP  ',
     &' C ICE',' PRATE',' TSTM ',' A PCP',' NCPCP',' ACPCP',' SRWEQ',
     &' WEASD',' SNO D',' MIXHT',' TTHDP',' MTHD ',' MTH A',' T CDC',
     &' CDCON',' L CDC',' M CDC',' H CDC',' C WAT',' BLI  ',' SNO C',
     &' SNO L',' WTMP ',' LAND ',' DSL M',' SFC R',' ALBDO',' TSOIL',
     &' SOILM',' VEG  ',' SALTY',' DEN  ',' WATR ',' ICE C',' ICETK',
     &' DICED',' SICED',' U ICE',' V ICE',' ICE G',' ICE D',' SNO M',
     &' HTSGW',' WVDIR',' WVHGT',' WVPER',' SWDIR',' SWELL',' SWPER'/
        DATA  HHNAM2/     
     &' DIRPW',' PERPW',' DIRSW',' PERSW',' NSWRS',' NLWRS',' NSWRT',
     &' NLWRT',' LWAVR',' SWAVR',' G RAD',' LHTFL',' SHTFL',' BLYDP',
     &' U FLX',' V FLX',' WMIXE',' IMG D',' MSLSA',' MSLMA',' MSLET',
     &' LFT X',' 4LFTX',' K X  ',' S X  ',' MCONV',' VW SH',' TSLSA',
     &' BVF2 ',' PV MW',' CRAIN',' CRFZR',' CICEP',' CSNOW',' SOILW',
     &' PEVPR',' CWORK',' U-GWD',' V-GWD',' PV   ',' COVMZ',' COVTZ',
     &' COVTM',' CLWMR',' O3MR ',' GFLUX',' CIN  ',' CAPE ',' TKE  ',
     &' CONDP',' CSUSF',' CSDSF',' CSULF',' CSDLF',' CFNSF',' CFNLF',
     &' VBDSF',' VDDSF',' NBDSF',' NDDSF',' M FLX',' LMH  ',' LMV  ',
     &' MLYNO',' NLAT ',' ELON ',' LPS X',' LPS Y',' HGT X',' HGT Y',
     &' VPTMP',' HLCY ',' PROB ',' PROBN',' POP  ',' CPOFP',' CPOZP',
     &' USTM ',' VSTM ',' ICWAT',' DSWRF',' DLWRF',' UVI  ',' MSTAV',
     &' SFEXC',' MIXLY',' USWRF',' ULWRF',' CDLYR',' CPRAT',' TTDIA',
     &' TTRAD',' TTPHY',' PREIX',' TSD1D',' NLGSP',' HPBL ',' 5WAVH',
     &' CNWAT',' BMIXL',' AMIXL',' PEVAP',' SNOHF',' MFLUX',' DTRF '/
        DATA  HHNAM3/     
     &' UTRF ',' BGRUN',' SSRUN',' O3TOT',' SNOWC',' SNO T',' LRGHR',
     &' CNVHR',' CNVMR',' SHAHR',' SHAMR',' VDFHR',' VDFUA',' VDFVA',
     &' VDFMR',' SWHR ',' LWHR ',' CD   ',' FRICV',' RI   ',' MISS ',
     &' PVORT',' BRTMP',' LWRAD',' SWRAD',' RWMR ',' SNMR ',' ICMR ',
     &' GRMR ',' TURB ',' ICNG ',' LTNG ',' NCIP ',' EVBS ',' EVCW ',
     &' SOTYP',' VGTYP',' 5WAVA',' GUST ',' CWDI ',' TRANS',' COVTW'/
C
C      ONE LINE CHANGE FOR HDS (IBM370) (ASCII NAME GRIB IN HEX)
C
C      DATA  GRIB  /Z47524942/
C
C      ONE LINE CHANGE FOR CRAY AND WORKSTATIONS 
C
       DATA  GRIB  /'GRIB'/
       DATA  KNAM1 /
     & '   WMC/NMC WASHINGTON.  ','   NWS TELECOMMS GATEWAY',
     & '   US FIELD STATIONS    ','   JAPANESE MA TOKYO    ',
     & '   NAT. HURR. C. MIAMI  ','   CANADIAN MC MONTREAL ',
     & '   U.S.A.F. GWC         ','   FNOC MONTEREY, CA.   ',
     & '   NOAA FCST SYS LAB    ','   NCAR, BOULDER CO.    ',
     & '   U.K MET BRACKNELL    ','   FRENCH WS  TOULOUSE  ',
     & '   EUROPEAN SPACE AGENCY','   EUROPEAN CENTER MRF. ',
     & '   DEBILT NETHERLANDS   '/
       DATA  KNAM2 /
     & '   NCEP RE-ANALYSIS PRO.','   NCEP ENSEMBLE PRODUCT',
     & '   NCEP CENTRAL OPS.    ','   ENV. MODELING CENTER ',
     & '   HYDRO. PRED. CENTER  ','   MARINE PRED. CENTER  ',
     & '   CLIMATE PRED. CENTER ','   AVN. WEATHER CENTER  ',
     & '   STORM PRED. CENTER   ','   TROPICAL PRED. CENTER',
     & '   NWS TECH. DEV. LAB.  ','   NESDIS OFF. RES. APP.', 
     & '   FAA                  ','   NWS MET. DEV. LAB.   '/ 
       DATA  KNAM3 /
     & '   ABRFC  TULSA, OK     ','   AKRFC  ANCHORAGE, AK ',
     & '   CBRFC  SALT LAKE, UT ','   CNRFC  SACRAMENTO, CA',
     & '   LMRFC  SLIDEL, LA.   ','   MARFC  STATE CO., PA ',
     & '   MBRFC  KANSAS CITY MO','   NCRFC  MINNEAPOLIS MN',
     & '   NERFC  HARTFORD, CT. ','   NWRFC  PORTLAND, OR  ',
     & '   OHRFC  CINCINNATI, OH','   SERFC  ATLANTA, GA   ',
     & '   WGRFC  FORT WORTH, TX','   OUN  NORMAN OK WFO   '/
       DATA  MONTH /'JAN','FEB','MAR','APR','MAY','JUN',
     &              'JUL','AUG','SEP','OCT','NOV','DEC'/
       DATA  SCNTR1/   1,   2,   3,   4,   5,   6,   7,
     &                 8,   9,  10,  11,  12,  13,  14/
       DATA  SCNTR2/ 150, 151, 152, 153, 154, 155, 156,
     &               157, 158, 159, 160, 161, 162, 170/
       DATA  TIMUN /'HRS.','DAYS','MOS.','YRS.','DECS','NORM','CENS',
     &              2*'----','3HRS','6HRS','HDYS'/
       DATA  TIMUN1/'HR','DY','MO','YR','DC','NO','CN',
     &              2*'--','3H','6H','HD'/
C
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C$          1.0 INITIALIZATION - NO. OF ENTRIES IN INDCATOR PARM.
C$                             - NO. OF ENTRIES IN TYPE LEVEL
C$                             - NO. OF ENTRIES IN CNTR PROD. DTA.
C$                             - NO. OF ENTRIES IN SUB CNTR1 PROD. DTA.
C$                             - NO. OF ENTRIES IN SUB CNTR2 PROD. DTA.
C
        IQ   = 252
        IS   =  55 
        IC   =  15
        ICS1 =  14
        ICS2 =  14
        IERR =   0
C
        TITL(1:30)  = '                              '
        TITL(31:60) = '                              '
        TITL(61:86) = '                          '
C
C ---------------------------------------------------------------------
C$           2.0 TEST SECTION 0 FOR ASCII 'GRIB'
C
         IF (GRIB(1:4) .NE. IPDS0(1:4)) THEN
           IERR = 1
           RETURN
         ENDIF
C      
C       TEST SECTION 0 FOR GRIB VERSION 1
C
        IF (mova2i(IPDS0(8:8)).NE.1) THEN
          IERR = 2
          RETURN
        END IF
C
C       TEST THE LENGTH OF THE PDS (SECTION 1)  
C
        LENPDS  = mova2i(IPDS(1:1)) * 65536 + mova2i(IPDS(2:2)) * 256 +
     &            mova2i(IPDS(3:3))   
        IF (LENPDS.GE.28) THEN
          IDPDS(1:28) = IPDS(1:28)
        ELSE
          IERR = 3
          RETURN
        ENDIF
C
C       TEST PDS FOR PARAMETER TABLE VERSION NUMBER 1 OR 2
C
        IVER = mova2i(IDPDS(4:4))
        IF (IVER.GT.127) THEN
          IERR = 9
          RETURN
        END IF    
C
C           4.0  FIND THE INDICATOR AND TYPE LEVELS
C
       IQQ = mova2i (IDPDS(9:9))
       DO II = 1,IQ
         IF (IQQ .EQ. HH(II)) GO TO 100
       END DO
         IF (IQQ.EQ.77.AND.IVER.EQ.1) GO TO 100
         IF (IQQ.EQ.24) GO TO 100
         IERR = 4
         RETURN
C
 100   CONTINUE
         IF (IQQ .NE. 77 .AND. IQQ .NE. 24) THEN
           TITL(21:27) = HHNAM(II)
         ELSE IF (IQQ .EQ. 77) THEN
           TITL(21:27) = ' CONDP '
C
C        TAKE OUT AFTER ALL PROGRAMS ARE CHANGED THAT USE 24
C        FOR TOTAL OZONE.
C
         ELSE IF (IQQ .EQ. 24) THEN
           TITL(21:27) = ' TOTO3 '
         END IF
         IF (IQQ.EQ.137.AND.IVER.EQ.1) TITL(21:27) = ' VISIB '
         ISS = mova2i (IDPDS(10:10))
C
C        CORRECTION FOR 'NLAT' 'ELON' 'L CDC' 'M CDC', 'H CDC',
C                       'T CDC'
C
         IF (ISS.EQ.0.AND.(IQQ.EQ.176.OR.IQQ.EQ.177.
     &     OR.IQQ.EQ.71.OR.IQQ.EQ.73.OR.IQQ.EQ.74.
     &     OR.IQQ.EQ.72.OR.IQQ.EQ.75.OR.IQQ.EQ.213.
     &     OR.IQQ.EQ.173.OR.IQQ.EQ.174)) THEN
           GO TO 300
         END IF
       DO JJ = 1,IS
         IF (ISS .EQ. HHH(JJ)) GO TO 200
       END DO
         IERR = 5
         RETURN
C
 200   CONTINUE
         IF (ISS.EQ.4.OR.ISS.EQ.5.OR.ISS.EQ.20.OR.ISS.EQ.100.OR.
     &     ISS.EQ.103.OR.ISS.EQ.105.OR.ISS.EQ.107.OR.ISS.EQ.109.OR.
     &     ISS.EQ.111.OR.ISS.EQ.113.OR.ISS.EQ.115.OR.ISS.EQ.117.OR.
     &     ISS.EQ.119.OR.ISS.EQ.125.OR.ISS.EQ.160) THEN
           TITL(16:20) = HHHNAM(JJ)
           LEVEL = mova2i(IDPDS(11:11)) * 256 + mova2i(IDPDS(12:12))
           IF (ISS.EQ.107.OR.ISS.EQ.119) THEN
             ALEVEL = FLOAT(LEVEL) / 10000.0
             WRITE (TITL(9:15),FMT='(F6.4)') ALEVEL
           ELSE IF (ISS.EQ.5) THEN
C             DO NOTHING
           ELSE 
             WRITE (TITL(11:15),FMT='(I4)') LEVEL
           END IF
         ELSE IF (ISS.EQ.1.OR.ISS.EQ.6.OR.ISS.EQ.7.OR.ISS.EQ.8.OR.
     &     ISS.EQ.9  .OR.ISS.EQ.102.OR.ISS.EQ.200.OR.ISS.EQ.201.OR.
     &     ISS.EQ.204.OR.ISS.EQ.212.OR.ISS.EQ.213.OR.ISS.EQ.214.OR.
     &     ISS.EQ.222.OR.ISS.EQ.223.OR.ISS.EQ.224.OR.ISS.EQ.232.OR.
     &     ISS.EQ.233.OR.ISS.EQ.234.OR.ISS.EQ.209.OR.ISS.EQ.210.OR.
     &     ISS.EQ.211.OR.ISS.EQ.242.OR.ISS.EQ.243.OR.ISS.EQ.244.OR.
     &     ISS.EQ.246.OR.ISS.EQ.247) THEN
           TITL(16:20) = HHHNAM(JJ)
           TITL(1:4)   = '    '
           TITL(11:15) = '    '
         ELSE IF (ISS.EQ.101.OR.ISS.EQ.104.OR.ISS.EQ.106.OR.ISS.EQ.108.
     &     OR.ISS.EQ.110.OR.ISS.EQ.112.OR.ISS.EQ.114.OR.ISS.EQ.116.OR.
     &     ISS.EQ.120.OR.ISS.EQ.121.OR.ISS.EQ.128.OR.ISS.EQ.141) THEN
           TITL(6:11)  = HHHNAM(JJ)
           TITL(16:20) = HHHNAM(JJ)
           ITEMP = mova2i(IDPDS(11:11))
           WRITE (UNIT=TITL(1:4),FMT='(I4)')   ITEMP
           JTEMP = mova2i(IDPDS(12:12))
           WRITE (UNIT=TITL(11:15),FMT='(I4)') JTEMP
         END IF
C
C               5.0 INSERT THE YEAR,DAY,MONTH AND TIME
C
 300   CONTINUE
       IHR   = mova2i (IDPDS(16:16))
       IDAY  = mova2i (IDPDS(15:15))
       IMON  = mova2i (IDPDS(14:14))
       IYR   = mova2i (IDPDS(13:13))
       ICEN  = mova2i (IDPDS(25:25))
C  
C      SUBTRACT 1 FROM CENTURY TO MAKE 4 DIGIT YEAR
C
       ICEN = ICEN - 1
C
       IYR  = ICEN * 100 + IYR
       WRITE (UNIT=TITL(58:61),FMT='(I4)') IYR
       WRITE (UNIT=TITL(51:52),FMT='(I2)') IDAY
       WRITE (UNIT=TITL(37:48),FMT='(A6,I2.2,A2)') 'AFTER ',IHR,' Z'
       TITL(54:56) = MONTH(IMON)
       FCSTIM      = mova2i (IDPDS(18:18))
       TITL(33:35) = TIMUN(FCSTIM)
       P1          = mova2i(IDPDS(19:19))
       P2          = mova2i(IDPDS(20:20))
       TIMERG      = mova2i(IDPDS(21:21))
       IF (TIMERG.EQ.10) THEN
         P1 = P1 * 256 + P2
         P2 = 0
       END IF
C
C      ADD CORRECTION IF BYTE 21 (TIME RANGE) IS 2
C
       IF (TIMERG.EQ.2) THEN
         TITL(4:20)  = TITL(11:27)
         TITL(21:21) = ' '
         WRITE (UNIT=TITL(22:24),FMT='(I3)') P1
         TITL(25:28) = ' TO '
         WRITE (UNIT=TITL(29:31),FMT='(I3)') P2
C
C      PRECIP AMOUNTS
C
       ELSE IF (TIMERG.EQ.4) THEN
         WRITE (UNIT=TITL(29:31),FMT='(I3)') P2
         MTEMP      = P2 - P1
         WRITE (UNIT=TITL(2:4),FMT='(I3)') MTEMP
         TITL(6:7)  = TIMUN1(FCSTIM)
         TITL(8:12) = ' ACUM'
C
C      AVERAGE 
C
       ELSE IF (TIMERG.EQ.3) THEN
         WRITE (UNIT=TITL(29:31),FMT='(I3)') P2
         MTEMP      = P2 - P1
         WRITE (UNIT=TITL(2:4),FMT='(I3)') MTEMP
         TITL(6:7)  = TIMUN1(FCSTIM)
         TITL(8:12) = ' AVG'
       ELSE
         WRITE (UNIT=TITL(29:31),FMT='(I3)') P1
       ENDIF
C
C      TEST FOR ANALYSIS (MAKE CORRECTION IF MODEL IS ANALYSIS)
C
       IF (TIMERG.EQ.0.AND.P1.EQ.0) THEN
          TITL(29:41) = ' ANALYSIS VT '
          MODEL       = mova2i(IDPDS(6:6))
          IF (MODEL.EQ.10.OR.MODEL.EQ.39.OR.MODEL.EQ.45.OR.
     &        MODEL.EQ.53.OR.MODEL.EQ.68.OR.MODEL.EQ.69.OR.
     &        MODEL.EQ.70.OR.MODEL.EQ.73.OR.MODEL.EQ.74.OR.
     &        MODEL.EQ.75.OR.MODEL.EQ.76.OR.MODEL.EQ.77.OR.
     &        MODEL.EQ.78.OR.MODEL.EQ.79.OR.MODEL.EQ.80.OR.
     &        MODEL.EQ.83.OR.MODEL.EQ.84.OR.MODEL.EQ.85.OR.
     &        MODEL.EQ.86.OR.MODEL.EQ.87.OR.MODEL.EQ.88.OR.
     &        MODEL.EQ.90.OR.MODEL.EQ.91.OR.MODEL.EQ.92.OR.
     &        MODEL.EQ.105.OR.MODEL.EQ.110.OR.MODEL.EQ.150.OR.
     &        MODEL.EQ.151) THEN
              TITL(29:41) = ' 00-HR FCST  '
          ENDIF    
       ENDIF
C
C      TEST FOR 00-HR FCST (INITIALIZED ANALYSIS)
C
       IF (TIMERG.EQ.1.AND.P1.EQ.0) THEN
          TITL(29:41) = ' 00-HR FCST  '
       ENDIF  
C
C$            3.0 FIND WHO GENERATED THE CODE
C$                CHECK FOR SUB-CENTERS
C
       IGENC = mova2i (IDPDS(5:5))
       ISUBC = mova2i (IDPDS(26:26))
C
C      TEST FOR SUB-CENTERS WHEN CENTER IS 7
C
       IF (ISUBC.NE.0.AND.IGENC.EQ.7) THEN
         DO J = 1,ICS1
           IF (ISUBC .EQ. SCNTR1(J)) THEN
             TITL(62:86) = KNAM2(J)
             RETURN
           END IF
         END DO
         IERR = 7
       END IF
C
C      TEST FOR SUB-CENTERS WHEN CENTER IS 9
C
       IF (ISUBC.NE.0.AND.IGENC.EQ.9) THEN
         DO J = 1,ICS2
           IF (ISUBC .EQ. SCNTR2(J)) THEN
             TITL(62:86) = KNAM3(J)
             RETURN
           END IF
         END DO
         IERR = 8
       END IF
C 
C      TEST TO SEE IF CENTER IN TABLES
C       
       DO I = 1,IC
         IF (IGENC .EQ. CENTER(I)) THEN
           TITL(62:86) = KNAM1(I)
           RETURN
         END IF
       END DO
C
       IERR = 6
       RETURN
       END
