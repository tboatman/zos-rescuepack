//DEFOPLOG JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID  
//SOPERLOG EXEC PGM=IXCMIAPU                      
//SYSPRINT DD SYSOUT=*                            
//SYSIN DD *                                      
 DATA TYPE(LOGR)                                  
 DEFINE LOGSTREAM NAME(SYSPLEX.OPERLOG)           
         DASDONLY(YES)                            
         HLQ(IXGLOGR)                             
         LS_SIZE(1024)                            
         LOWOFFLOAD(0)                            
         HIGHOFFLOAD(80)                          
         RETPD(30)                                
         AUTODELETE(NO)                           
/*                                                
//                                                