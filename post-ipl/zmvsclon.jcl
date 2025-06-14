//OMVSCLON JOB CLASS=A,MSGCLASS=X,REGION=0K,NOTIFY=&SYSUID.
//*****************************************************************
//*
//*
//* CREATE SYSTEM-SPECIFIC ZFS DATASETS
//*
//*
//*****************************************************************
//********************************************************
//*
//*  ALLOCATE A SYSTEM ROOT FOR THE S0W2 SYSTEM
//*
//********************************************************
//DEFINE   EXEC   PGM=IDCAMS
//SYSPRINT DD     SYSOUT=*
//SYSUDUMP DD     SYSOUT=*
//AMSDUMP  DD     SYSOUT=*
//SYSIN    DD     *
     DEFINE CLUSTER (NAME(ZFS.S0W2.SYSTEM) -
            LINEAR CYL(2 1) SHAREOPTIONS(3,3)    -
            VOLUMES(B4SYS2))
/*
//********************************************************
//*
//*  NOW INITIALIZE THE NEW SYSTEM ROOT
//*
//********************************************************
//CREATE   EXEC   PGM=IOEFSUTL,REGION=0M,
// PARM=('format -aggregate ZFS.S0W2.SYSTEM')
//SYSPRINT DD     SYSOUT=*
//STDOUT   DD     SYSOUT=*
//STDERR   DD     SYSOUT=*
//SYSUDUMP DD     SYSOUT=*
//CEEDUMP  DD     SYSOUT=*
//********************************************************
//*
//*  NOW RUN BPXISYS2 AGAINST NEW SYSTEM ROOT
//*
//********************************************************
//IKJEFT1A  EXEC PGM=IKJEFT1A,PARM='BPXISYS2 ZFS'
//SYSEXEC   DD   DSN=SYS1.SAMPLIB,DISP=SHR
//SYSTSPRT  DD   SYSOUT=*
//FSSYSTS   DD   DSNAME=ZFS.S0W2.SYSTEM,DISP=SHR
//SYSTSIN   DD   DUMMY
//********************************************************
//*
//*  NOW USE DSS TO COPY THE SYSTEM-SPECIFIC ZFS FILES
//*
//********************************************************
//CLONE   EXEC PGM=ADRDSSU,REGION=0M PARM='TYPRUN=NORUN'
//SYSPRINT DD SYSOUT=*
//FROMDASD DD UNIT=3390,DISP=SHR,VOL=SER=B4USS2
//TODASD   DD UNIT=3390,DISP=SHR,VOL=SER=B4SYS2
//SYSIN    DD *
 COPY DATASET(INCLUDE(                   -
                      ZFS.S0W1.ETC,     -
                      ZFS.S0W1.USR.MAIL, -
                      ZFS.S0W1.VAR,     -
                      ZFS.S0W1.VARWBEM,  -
                      ZFS.S0W1.WEB,      -
                      ZFS.S0W1.WEB.CONFIG.ZFS)) -
      LOGINDDNAME(FROMDASD) OUTDD(TODASD)  -
      TOLERATE(ENQF)  -
      RENAMEU(                                   -
              (ZFS.S0W1.ETC,ZFS.S0W2.ETC),              -
              (ZFS.S0W1.USR.MAIL,ZFS.S0W2.USR.MAIL),    -
              (ZFS.S0W1.VAR,ZFS.S0W2.VAR),              -
              (ZFS.S0W1.VARWBEM,ZFS.S0W2.VARWBEM),      -
              (ZFS.S0W1.WEB,ZFS.S0W2.WEB),              -
              (ZFS.S0W1.WEB.CONFIG.ZFS,       -
               ZFS.S0W2.WEB.CONFIG.ZFS))                          -
      SHARE ALLEXCP ALLDATA(*) CANCELERROR CATALOG
/*