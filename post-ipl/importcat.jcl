//MCAT JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K
//*****************************************************************             
//* DEFINE MASTER CATALOG AND SSA                                               
//*****************************************************************             
//MCATSSA1  EXEC  PGM=IDCAMS,REGION=4M                                          
//SYSPRINT  DD    SYSOUT=*                                                      
//SYSIN     DD    *                                                             
 EXP SYS1.MCAT.VSY2PKA DISCONNECT                                               
 IF LASTCC=12 THEN SET MAXCC=0                                                  
 IMPORT OBJECTS ((SYS1.MCAT.VSY2PKA VOLUME(SY2PKA) DEVICETYPE(3390))) -
    CONNECT CATALOG(CATALOG.Z31C.MASTER)                         
 IF LASTCC=0 THEN DO                                                            
   DEF ALIAS(NAME(TARGSYS) RELATE(SYS1.MCAT.VSY2PKA)) -                         
     CAT(CATALOG.Z31C.MASTER)    /* CHANGE to current master */                
 END                                                                            
/*                                                                              