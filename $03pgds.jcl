//PGDS JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K
//*****************************************************************             
//* DEFINE PAGE DATA SETS, SMF DATASETS, AND VIO DSN                            
//*****************************************************************             
//PAGSMFV4  EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                              
//SYSPRINT  DD    SYSOUT=*                                                      
//SYSIN     DD    *                                                             
 DEF PGSPC(NAME(TARGSYS.SYS1.PAGE.VSY2PKA.PLPA) -                               
     STORCLAS(SCNONSMS) -                                                       
     VOL(SY2PKA) CYLINDERS(85))                                                 
 DEF PGSPC(NAME(TARGSYS.SYS1.PAGE.VSY2PKA.COMMON) -                             
     STORCLAS(SCNONSMS) -                                                       
     VOL(SY2PKA) CYLINDERS(25))                                                 
 DEF PGSPC(NAME(TARGSYS.SYS1.PAGE.VSY2PKA.LOCAL) -                              
     STORCLAS(SCNONSMS) -                                                       
     VOL(SY2PKA) CYLINDERS(300))                                                
 DEF CL (CISZ(4096) CYLINDERS(25) -                                             
     STORCLAS(SCNONSMS) -                                                       
     NAME(TARGSYS.SYS1.VSY2PKA.MAN1) NIXD RECSZ(4086,32767)-                    
     REUSE SHR(2) SPANNED SPEED VOL(SY2PKA)) -                                  
     DATA (NAME(TARGSYS.SYS1.VSY2PKA.MAN1.DATA))                                
 DEF CL (CISZ(4096) CYLINDERS(25) -                                             
     STORCLAS(SCNONSMS) -                                                       
     NAME(TARGSYS.SYS1.VSY2PKA.MAN2) NIXD RECSZ(4086,32767)-                    
     REUSE SHR(2) SPANNED SPEED VOL(SY2PKA)) -                                  
     DATA (NAME(TARGSYS.SYS1.VSY2PKA.MAN2.DATA))                                
 DEF CL (BUFSP(20480) CYL(5)             -                                      
     STORCLAS(SCNONSMS) -                                                       
     KEYS(12,8) NAME(TARGSYS.SYS1.VSY2PKA.STGINDEX) -                           
     RECSZ(2041,2041) REUSE VOL(SY2PKA)) -                                      
     DATA(CISZ(2048)) INDEX(CISZ(4096))                                         
 DEF CL (TRK(1 1)       -                                                       
     STORCLAS(SCNONSMS) -                                                       
     LINEAR NAME(TARGSYS.SYS1.SMS.ACDS1) -                                      
     SHR(3,3) REUSE VOL(SY2PKA)) -                                              
     DATA (NAME(TARGSYS.SYS1.SMS.ACDS1.DATA))                                   
 DEF CL (TRK(1 1)       -                                                       
     STORCLAS(SCNONSMS) -                                                       
     LINEAR NAME(TARGSYS.SYS1.SMS.COMMDS1) -                                    
     SHR(3,3) REUSE VOL(SY2PKA)) -                                              
     DATA (NAME(TARGSYS.SYS1.SMS.COMMDS1.DATA))                                 
/*                                                                              
//*****************************************************************             
//* FORMAT SMF DATASETS                                                         
//*****************************************************************             
//SMFFMT5 EXEC  PGM=IFASMFDP,REGION=4M,COND=(0,NE)                              
//SYSPRINT DD  SYSOUT=*                                                         
//MAN1     DD  DSN=TARGSYS.SYS1.VSY2PKA.MAN1,DISP=SHR                           
//MAN2     DD  DSN=TARGSYS.SYS1.VSY2PKA.MAN2,DISP=SHR                           
//SYSIN    DD  *                                                                
   INDD(MAN1,OPTIONS(CLEAR))                                                    
   INDD(MAN2,OPTIONS(CLEAR))                                                    
/*        