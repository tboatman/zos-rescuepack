//LOGREC JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K
//*****************************************************************             
//* CATALOG NEW LOGREC, BRODCAST, SPOOL, CKPT AND SCUNTBL DSNS                  
//*****************************************************************             
//CATLG11   EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                              
//SYSPRINT  DD    SYSOUT=*                                                      
//SYSIN     DD    *                                                             
 DEF NVSAM(NAME(SYS1.VSY2PKA.LOGREC)   VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
 DEF NVSAM(NAME(SYS1.VSY2PKA.HASPACE)  VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
 DEF NVSAM(NAME(SYS1.VSY2PKA.HASPCKPT) VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
 DEF NVSAM(NAME(SYS1.BRODCAST)         VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
 DEF NVSAM(NAME(SYS1.SCUNTBL)          VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
/*                                                                              
//*****************************************************************             
//* IEBCOPY DRIVING SYSTEM SCUNTBL CUN* MEMBERS TO TARGET                       
//*****************************************************************             
//CPYCUN12 EXEC PGM=IEBCOPY,REGION=4M,PARM='WORK=4M'                            
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUDUMP DD  SYSOUT=*                                                         
//SYSUT3   DD  UNIT=SYSALLDA,SPACE=(CYL,(1,1))                                  
//SYSUT4   DD  UNIT=SYSALLDA,SPACE=(CYL,(1,1))                                  
//IN1      DD  DSN=SYS1.SCUNTBL,DISP=SHR                                        
//OUT1     DD  DSN=SYS1.SCUNTBL,DISP=SHR,                                       
//             VOL=SER=SY2PKA,UNIT=SYSALLDA                                     
//SYSIN    DD  *                                                                
 COPYGROUP INDD=IN1,OUTDD=OUT1                                                  
 SELECT MEMBER=(CUN*)                                                           
/*                                                                              
//*****************************************************************             
//* INITIALIZE LOGREC                                                           
//*****************************************************************             
//LOGREC13  EXEC  PGM=IFCDIP00,REGION=4M
//SERERDS   DD DISP=SHR,DSN=SYS1.VSY2PKA.LOGREC,                                
//             VOL=SER=SY2PKA,UNIT=SYSALLDA                                     