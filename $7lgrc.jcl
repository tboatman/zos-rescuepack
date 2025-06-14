//*****************************************************************             
//* ALLOCATE NEW LOGREC, BRODCAST, SPOOL, CKPT AND SCUNTBL DSNS                 
//*****************************************************************             
//ALLOC9   EXEC  PGM=IEFBR14,COND=(0,NE)                                        
//LOGREC   DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.VSY2PKA.LOGREC,                 
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             SPACE=(CYL,1)                                                    
//HASPCKPT DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.VSY2PKA.HASPCKPT,               
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             SPACE=(CYL,5)                                                    
//HASPACE  DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.VSY2PKA.HASPACE,                
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             SPACE=(CYL,250)                                                  
//BRODCAST DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.BRODCAST,                       
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             SPACE=(CYL,5)                                                    
//SCUNTBL  DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.SCUNTBL,                        
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             DSNTYPE=PDS,                                                     
//             DCB=(DSORG=PO,RECFM=FB,LRECL=256,BLKSIZE=0),                     
//             SPACE=(CYL,(75,5,900))                                           
//*****************************************************************             
//* RENAME NEW LOGREC, BRODCAST, SPOOL, CKPT AND SCUNTBL DSNS                   
//*****************************************************************             
//RENAME10 EXEC  PGM=IEHPROGM,REGION=4M,COND=(0,NE)                             
//SYSPRINT DD  SYSOUT=*                                                         
//SY2PKA   DD  DISP=OLD,VOL=SER=SY2PKA,UNIT=SYSALLDA                            
//SYSIN    DD  *                                                                
 RENAME VOL=SYSDA=SY2PKA,DSNAME=TARGSYS.SYS1.VSY2PKA.LOGREC,           X        
               NEWNAME=SYS1.VSY2PKA.LOGREC                                      
 RENAME VOL=SYSDA=SY2PKA,DSNAME=TARGSYS.SYS1.VSY2PKA.HASPCKPT,         X        
               NEWNAME=SYS1.VSY2PKA.HASPCKPT                                    
 RENAME VOL=SYSDA=SY2PKA,DSNAME=TARGSYS.SYS1.VSY2PKA.HASPACE,          X        
               NEWNAME=SYS1.VSY2PKA.HASPACE                                     
 RENAME VOL=SYSDA=SY2PKA,DSNAME=TARGSYS.SYS1.BRODCAST,                 X        
               NEWNAME=SYS1.BRODCAST                                            
 RENAME VOL=SYSALLDA=SY2PKA,DSNAME=TARGSYS.SYS1.SCUNTBL,               X        
               NEWNAME=SYS1.SCUNTBL                                             
/*                                                                  
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