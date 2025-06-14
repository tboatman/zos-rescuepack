//*****************************************************************             
//* PUT IPL TEXT ON IPL VOLUME USING ICKDSF                                     
//*****************************************************************             
//IPLTEXT8 EXEC PGM=ICKDSF,PARM=NOREPLYU,REGION=4M,COND=(0,NE)                  
//SYSPRINT DD  SYSOUT=*                                                         
//IPLTEXT  DD  DISP=SHR,VOL=SER=SY2PKA,UNIT=SYSALLDA,                           
//             DSN=TARGSYS.SYS1.SAMPLIB(IPLRECS)                                
//         DD  DISP=SHR,VOL=SER=SY2PKA,UNIT=SYSALLDA,                           
//             DSN=TARGSYS.SYS1.SAMPLIB(IEAIPL00)                               
//SYSIN    DD  *                                                                
   REFORMAT  DDNAME(IPLTEXT)                                     -              
             IPLDD(IPLTEXT)                                      -              
             NOVERIFY                                            -              
             BOOTSTRAP   /* IPLRECS OF IPLTEXT DD WILL SUPPLY IT */             
/*           