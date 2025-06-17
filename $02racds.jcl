//RACFDS JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K
//*****************************************************************             
//* ALLOCATE RACF DSNS                                                          
//*****************************************************************             
//RACFALC2 EXEC PGM=IEFBR14,REGION=4M,COND=(0,NE)                               
//RACFPRIM DD  DSN=TARGSYS.SYS1.RACFDS,
//             DISP=(NEW,CATLG,DELETE),                                         
//             UNIT=SYSALLDA,VOL=SER=SY2PKA,                                    
//             SPACE=(CYL,(300),,CONTIG),                                       
//             STORCLAS=SCNONSMS,  /* CAN'T USE WITH DSORG=PSU */               
//             DCB=(DSORG=PS,RECFM=F,LRECL=4096,BLKSIZE=4096)                   
//*            DCB=(DSORG=PSU,RECFM=F,LRECL=4096,BLKSIZE=4096)                  
//RACFBKUP DD  DSN=TARGSYS.SYS1.RACFDS.BACKUP,                                  
//             DISP=(NEW,CATLG,DELETE),                                         
//             UNIT=SYSALLDA,VOL=SER=SY2PKA,                                    
//             SPACE=(CYL,(300),,CONTIG),                                       
//             STORCLAS=SCNONSMS,  /* CAN'T USE WITH DSORG=PSU */               
//             DCB=(DSORG=PS,RECFM=F,LRECL=4096,BLKSIZE=4096)                   
//*            DCB=(DSORG=PSU,RECFM=F,LRECL=4096,BLKSIZE=4096)                  
//*****************************************************************             
//* REPRO COPY RACF DSNS                                                        
//*****************************************************************             
//RACFCPY3  EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                              
//SYSPRINT DD  SYSOUT=*                                                         
//IN1      DD  DSN=SYS1.RACFDS,DISP=SHR                             
//IN2      DD  DSN=SYS1.RACFDS.BACKUP,DISP=SHR                              
//OUT1     DD  DSN=TARGSYS.SYS1.RACFDS,DISP=SHR                           
//OUT2     DD  DSN=TARGSYS.SYS1.RACFDS.BACKUP,DISP=SHR                          
//SYSIN    DD  *                                                                
  REPRO INFILE(IN1) OUTFILE(OUT1)                                               
  REPRO INFILE(IN2) OUTFILE(OUT2)                                               
/*   