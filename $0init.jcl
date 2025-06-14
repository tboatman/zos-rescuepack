//INITDASD JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K   
//STEP1 EXEC PGM=ICKDSF                                         
//SYSPRINT DD SYSOUT=*                                          
//SYSIN DD *                                                    
  INIT UNIT(0601) NOVERIFY -                       
      OWNERID(IBMUSER) VTOC(0,1,10) INDEX(0,11,15) VOLID(V3SPK1)
/*
//* TODO - verify VTOC and INDEX parameters and adapt to proper
//*        volume size