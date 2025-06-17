//INITDASD JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K  
//***************************************************************
//*
//* $00INIT - Initialization of DASD volumes and IPL text
//*
//* C3INM1 on 0A96 will become SY2PKA
//* 
//*************************************************************** 
//STEP1 EXEC PGM=ICKDSF                                         
//SYSPRINT DD SYSOUT=*                                          
//SYSIN DD *                                                    
  INIT UNIT(0A96) NOVERIFY -                       
      OWNERID(IBMUSER) VOLID(SY2PKA)
/*
