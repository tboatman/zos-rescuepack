//*RACFZAP7  EXEC PGM=AMASPZAP,PARM=IGNIDRFULL,REGION=4M,COND=(0,NE)            
//RACFZAP7  EXEC PGM=IEFBR14,PARM=IGNIDRFULL,REGION=4M,COND=(0,NE)              
//SYSPRINT DD  SYSOUT=*                                                         
//SYSLIB   DD  DSN=TARGSYS.SYS1.VSY2PKA.LINKLIB,DISP=SHR                        
//SYSIN    DD  *                                                                
NAME ICHRDSNT ICHRDSNT                                                          
REP 005A 80                                                                     
REP 0001 E2,E8E2                                                                
REP 0004 F14B,D9C1,C3C6,4BD7,D9C9,D4C1,D9E8                                     
REP 0012 4040                                                                   
REP 0014 4040,4040,4040,4040,4040,4040                                          
REP 0020 4040,4040,4040,4040,4040,4040,40                                       
REP 002D E2,E8E2                                                                
REP 0030 F14B,D9C1,C3C6,4BC2,C1C3,D2E4,D740                                     
REP 003E 4040                                                                   
REP 0040 4040,4040,4040,4040,4040,4040                                          
REP 004C 4040,4040,4040,4040,4040,4040,40                                       
/*                                             