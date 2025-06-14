//DEFCKPT JOB NOTIFY=&SYSUID                          
//ALLOC   EXEC PGM=IEFBR14                            
//CHECK2  DD DSN=SYS1.HASPNCK2,VOL=SER=J2SP01,        
//        UNIT=3390,DISP=(NEW,KEEP),DCB=(DSORG=PSU),  
//        SPACE=(TRK,5000)                            