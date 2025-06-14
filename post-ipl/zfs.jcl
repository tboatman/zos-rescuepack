//AMICZFS JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID 
//DEFINE EXEC PGM=IDCAMS                        
//SYSPRINT DD SYSOUT=*                          
//SYSIN DD *                                    
  DEFINE CLUSTER (NAME(SYS2.OPENAU.ZFS) -       
   ZFS CYL(150 20) -                            
   VOLUME(C3SYS1)) 
/*                             
//                                              