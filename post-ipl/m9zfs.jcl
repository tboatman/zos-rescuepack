//AMICZFS JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID    
//CREATE EXEC PGM=BPXBATCH,                        
// PARM='SH mkdir -p /usr/lpp/model9'              
//DEFINE EXEC PGM=IDCAMS                           
//SYSPRINT DD SYSOUT=*                             
//SYSIN DD *                                       
  DEFINE CLUSTER (NAME(BMC.MODEL9.ZFS) -           
   ZFS CYL(200 50) -                               
   VOLUME(A5CFG1)                                  
   )                                               
//MOUNT EXEC PGM=IKJEFT01,DYNAMNBR=10              
//SYSTSPRT DD SYSOUT=*                             
//SYSTSIN DD *                                     
 MOUNT FILESYSTEM('BMC.MODEL9.ZFS') +              
 MOUNTPOINT('/usr/lpp/model9') +                   
 TYPE(ZFS) MODE(RDWR)    
/*                          
//                                                 