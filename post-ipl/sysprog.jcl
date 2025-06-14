//NEWUSER JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID                         00010000
//USERS EXEC PGM=IKJEFT01                                               00169403
//SYSPRINT DD SYSOUT=*                                                  00170000
//SYSTSPRT DD SYSOUT=*                                                  00180000
//SYSTSIN DD *                                                          00190000
  ADDUSER  ALIM -                                                       00200001
           DFLTGRP(SYS1) -                                              00210001
           NAME('Alim') OWNER(IBMUSER) -                                00220004
           OMVS(AUTOUID PROGRAM('/bin/sh') HOME('/u/alim')) -           00230001
           PASSWORD(SYS1) UACC(NONE) -                                  00240000
           TSO(ACCTNUM(ACCT#) COMMAND(ISPF) JOBCLASS(A) -               00250000
           MSGCLASS(X) PROC(CTMPROC) SIZE(0))                           00260000
//PERMIT  EXEC PGM=IKJEFT01                                             00640000
//SYSPRINT DD SYSOUT=*                                                  00650000
//SYSTSPRT DD SYSOUT=*                                                  00660000
//SYSTSIN DD *                                                          00670000
  PERMIT ISPFPROC CLASS(TSOPROC) ID(ALIM) ACCESS(READ)                  00690000
  PERMIT ISPFLITE CLASS(TSOPROC) ID(ALIM) ACCESS(READ)                  00690000
  PERMIT CTMPROC CLASS(TSOPROC) ID(ALIM) ACCESS(READ)                   00690000
  PERMIT C21PROC CLASS(TSOPROC) ID(ALIM) ACCESS(READ)                   00690000
  PERMIT JCL CLASS(TSOAUTH) ID(ALIM) ACCESS(READ)                       00700000
  PERMIT MOUNT CLASS(TSOAUTH) ID(ALIM) ACCESS(READ)                     00710000
  PERMIT OPER CLASS(TSOAUTH) ID(ALIM) ACCESS(READ)                      00710000
  PERMIT CONSOLE CLASS(TSOAUTH) ID(ALIM) ACCESS(READ)                   00710000
  PERMIT ACCT# CLASS(ACCTNUM) ID(ALIM) ACCESS(READ)                     00720000
  PERMIT GROUP.ISFSPROG.* CLASS(SDSF) ID(ALIM) ACCESS(READ)             00740000
  PERMIT *.** CLASS(JESSPOOL) ID(ALIM) ACCESS(ALTER)                    00760000
  PERMIT S0W1.+MASTER+.SYSLOG.*.* CLASS(JESSPOOL) -                     00770000
         ID(ALIM) ACCESS(READ)                                          00780000
/*                                                                      00790000
//REFRESH  EXEC PGM=IKJEFT01                                            00800000
//SYSPRINT DD SYSOUT=*                                                  00810000
//SYSTSPRT DD SYSOUT=*                                                  00820000
//SYSTSIN DD *                                                          00830000
  SETROPTS RACLIST(TSOPROC) REFRESH                                     00840000
  SETROPTS RACLIST(TSOAUTH) REFRESH                                     00850000
  SETROPTS RACLIST(SDSF) REFRESH                                        00860000
/*                                                                      00880000
//DATASET  EXEC PGM=IKJEFT01                                            00881005
//SYSPRINT DD SYSOUT=*                                                  00882005
//SYSTSPRT DD SYSOUT=*                                                  00883005
//SYSTSIN DD *                                                          00884005
 ADDSD 'ALIM.*' UACC(NONE) OWNER(ALIM)
 DEFINE ALIAS(NAME(ALIM) RELATE('USERCAT.Z25A.USER')) -
    CATALOG('CATALOG.Z25A.MASTER')
