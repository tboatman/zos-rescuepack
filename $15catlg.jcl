//LISTC JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K
//*****************************************************************             
//* LIST THE SY2PKA MASTER CATALOG                                              
//*****************************************************************             
//LIST22 EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                                 
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUDUMP DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
     LISTC CATALOG(SYS1.MCAT.VSY2PKA) ALL                                       
/*                                                                              
//*****************************************************************             
//* CLEANUP - REMOVE SSA AND EXPORT DISCONNECT SY2PKA MCAT                      
//*****************************************************************             
//CLEAN23 EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                                
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUDUMP DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
    DEL TARGSYS ALIAS                                                           
    EXP SYS1.MCAT.VSY2PKA DISCONNECT                                            
/*    