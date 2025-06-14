//*****************************************************************             
//* DEFINE MASTER CATALOG AND SSA                                               
//*****************************************************************             
//MCATSSA1  EXEC  PGM=IDCAMS,REGION=4M                                          
//SYSPRINT  DD    SYSOUT=*                                                      
//SYSIN     DD    *                                                             
 EXP SYS1.MCAT.VSY2PKA DISCONNECT                                               
 IF LASTCC=12 THEN SET MAXCC=0                                                  
 DEF MCAT(NAME(SYS1.MCAT.VSY2PKA) VOL(SY2PKA) -                                 
     STORCLAS(SCNONSMS) -                                                       
     CYL(3 1) ICFCAT -                                                          
     SHR(3 4) STRNO(3) BUFND(4)  BUFNI(4)  FSPC(10 10)) -                       
     DATA( CISZ(4096)) -                                                        
     CAT(SYS1.ICFCAT.MSTRDRVR)    /* CHANGE */                                  
 IF LASTCC=0 THEN DO                                                            
   DEF ALIAS(NAME(TARGSYS) RELATE(SYS1.MCAT.VSY2PKA)) -                         
     CAT(SYS1.ICFCAT.MSTRDRVR)    /* CHANGE */                                  
 END                                                                            
/*                                                                              
