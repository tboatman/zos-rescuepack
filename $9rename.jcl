//RENAME JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K
//*****************************************************************             
//* RENAME ALL OTHER DSNS TO REMOVE SSA                                         
//*****************************************************************             
//RENAME14  EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                              
//SYSPRINT  DD    SYSOUT=*                                                      
//SYSIN     DD    *                                                             
 ALTER TARGSYS.SYS1.RACFDS -                                              
   NEWNAME(SYS1.RACF.PRIMARY) -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.RACFDS.BACKUP -                                             
   NEWNAME(SYS1.RACF.BACKUP) -                                                  
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.PAGE.VSY2PKA.PLPA -                                         
   NEWNAME(SYS1.PAGE.VSY2PKA.PLPA) -                                            
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.PAGE.VSY2PKA.PLPA.DATA -                                    
   NEWNAME(SYS1.PAGE.VSY2PKA.PLPA.DATA) -                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.PAGE.VSY2PKA.COMMON -                                       
   NEWNAME(SYS1.PAGE.VSY2PKA.COMMON) -                                          
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.PAGE.VSY2PKA.COMMON.DATA -                                  
   NEWNAME(SYS1.PAGE.VSY2PKA.COMMON.DATA) -                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.PAGE.VSY2PKA.LOCAL -                                        
   NEWNAME(SYS1.PAGE.VSY2PKA.LOCAL) -                                           
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.PAGE.VSY2PKA.LOCAL.DATA -                                   
   NEWNAME(SYS1.PAGE.VSY2PKA.LOCAL.DATA) -                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.MAN1 -                                              
   NEWNAME(SYS1.VSY2PKA.MAN1) -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.MAN1.DATA -                                         
   NEWNAME(SYS1.VSY2PKA.MAN1.DATA) -                                            
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.MAN2 -                                              
   NEWNAME(SYS1.VSY2PKA.MAN2) -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.MAN2.DATA -                                         
   NEWNAME(SYS1.VSY2PKA.MAN2.DATA) -                                            
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.STGINDEX -                                          
   NEWNAME(SYS1.VSY2PKA.STGINDEX) -                                             
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.STGINDEX.DATA -                                     
   NEWNAME(SYS1.VSY2PKA.STGINDEX.DATA) -                                        
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.STGINDEX.INDEX -                                    
   NEWNAME(SYS1.VSY2PKA.STGINDEX.INDEX) -                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SMS.ACDS1 -                                                 
   NEWNAME(SYS1.SMS.ACDS1)  -                                                   
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SMS.ACDS1.DATA -                                            
   NEWNAME(SYS1.SMS.ACDS1.DATA)  -                                              
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SMS.COMMDS1 -                                               
   NEWNAME(SYS1.SMS.COMMDS1) -                                                  
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SMS.COMMDS1.DATA -                                          
   NEWNAME(SYS1.SMS.COMMDS1.DATA) -                                             
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.IODF01.CLUSTER -                                            
   NEWNAME(SYS1.IODF00.CLUSTER) -                                               
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.IODF01 -                                                    
   NEWNAME(SYS1.IODF00) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.CSF.SCSFMOD1 -                                                   
   NEWNAME(CSF.SCSFMOD1) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.CMDLIB -                                                    
   NEWNAME(SYS1.CMDLIB) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.DAE -                                                       
   NEWNAME(SYS1.DAE) -                                                          
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.HELP -                                                      
   NEWNAME(SYS1.HELP) -                                                         
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.IMAGELIB -                                                  
   NEWNAME(SYS1.IMAGELIB) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.LINKLIB -                                                   
   NEWNAME(SYS1.LINKLIB) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.MIGLIB -                                                    
   NEWNAME(SYS1.MIGLIB) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.CSSLIB -                                                    
   NEWNAME(SYS1.CSSLIB) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SIEALNKE -                                                  
   NEWNAME(SYS1.SIEALNKE) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SIEAMIGE -                                                  
   NEWNAME(SYS1.SIEAMIGE) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.LPALIB -                                                    
   NEWNAME(SYS1.LPALIB) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.MACLIB -                                                    
   NEWNAME(SYS1.MACLIB) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.MODGEN -                                                    
   NEWNAME(SYS1.MODGEN) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.NUCLEUS -                                                   
   NEWNAME(SYS1.NUCLEUS) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SHASLNKE -                                                  
   NEWNAME(SYS1.SHASLNKE) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SHASMIG -                                                   
   NEWNAME(SYS1.SHASMIG) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ASM.SASMMOD1  -                                                  
   NEWNAME(ASM.SASMMOD1)  -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.PARMLIB -                                                   
   NEWNAME(SYS1.PARMLIB) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.PROCLIB -                                                   
   NEWNAME(SYS1.PROCLIB) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SAMPLIB -                                                   
   NEWNAME(SYS1.SAMPLIB) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SISTCLIB -                                                  
   NEWNAME(SYS1.SISTCLIB) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SVCLIB -                                                    
   NEWNAME(SYS1.SVCLIB) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.CEE.SCEERUN      -                                               
   NEWNAME(CEE.SCEERUN)      -                                                  
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.CEE.SCEERUN2      -                                       
   NEWNAME(CEE.SCEERUN2)      -                                        
     CAT(SYS1.MCAT.VSY2PKA)                                            
 ALTER TARGSYS.SYS1.VTAMLIB -                                                   
   NEWNAME(SYS1.VTAMLIB) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.UADS -                                                      
   NEWNAME(SYS1.UADS) -                                                         
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VTAMLST -                                                   
   NEWNAME(SYS1.VTAMLST) -                                                      
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SCBDCLST -                                                  
   NEWNAME(SYS1.SCBDCLST) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SCBDPENU -                                                  
   NEWNAME(SYS1.SCBDPENU) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SCBDMENU -                                                  
   NEWNAME(SYS1.SCBDMENU) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SCBDTENU -                                                  
   NEWNAME(SYS1.SCBDTENU) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SCBDHENU -                                                  
   NEWNAME(SYS1.SCBDHENU) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SDWWDLPA -                                                  
   NEWNAME(SYS1.SDWWDLPA) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.DBBLIB -                                                    
   NEWNAME(SYS1.DBBLIB) -                                                       
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SEAGALT      -                                              
   NEWNAME(SYS1.SEAGALT)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISF.SISFEXEC      -                                              
   NEWNAME(ISF.SISFEXEC)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISF.SISFLINK      -                                              
   NEWNAME(ISF.SISFLINK)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISF.SISFLOAD      -                                              
   NEWNAME(ISF.SISFLOAD)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISF.SISFLPA      -                                               
   NEWNAME(ISF.SISFLPA)      -                                                  
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISF.SISFMLIB      -                                              
   NEWNAME(ISF.SISFMLIB)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISF.SISFPLIB      -                                              
   NEWNAME(ISF.SISFPLIB)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISF.SISFSLIB      -                                              
   NEWNAME(ISF.SISFSLIB)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISF.SISFTLIB      -                                              
   NEWNAME(ISF.SISFTLIB)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPCLIB      -                                              
   NEWNAME(ISP.SISPCLIB)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPEXEC      -                                              
   NEWNAME(ISP.SISPEXEC)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPLOAD      -                                              
   NEWNAME(ISP.SISPLOAD)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPLPA      -                                               
   NEWNAME(ISP.SISPLPA)      -                                                  
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPMENU      -                                              
   NEWNAME(ISP.SISPMENU)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPPENU      -                                              
   NEWNAME(ISP.SISPPENU)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPSENU      -                                              
   NEWNAME(ISP.SISPSENU)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPSLIB      -                                              
   NEWNAME(ISP.SISPSLIB)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ISP.SISPTENU      -                                              
   NEWNAME(ISP.SISPTENU)      -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.LPALIB -                                            
   NEWNAME(SYS1.VSY2PKA.LPALIB) -                                               
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.VSY2PKA.LINKLIB -                                           
   NEWNAME(SYS1.VSY2PKA.LINKLIB) -                                              
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SCUNLOCL -                                                  
   NEWNAME(SYS1.SCUNLOCL) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.TCPIP.SEZALPA      -                                             
   NEWNAME(TCPIP.SEZALPA)      -                                                
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.TCPIP.SEZALOAD      -                                            
   NEWNAME(TCPIP.SEZALOAD)      -                                               
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.TCPIP.SEZALNK2      -                                            
   NEWNAME(TCPIP.SEZALNK2)      -                                               
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.TCPIP.SEZATCP      -                                             
   NEWNAME(TCPIP.SEZATCP)      -                                                
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.TCPPARMS -                                                  
   NEWNAME(SYS1.TCPPARMS) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SBPXEXEC -                                                  
   NEWNAME(SYS1.SBPXEXEC) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SBPXPENU -                                                  
   NEWNAME(SYS1.SBPXPENU) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SBPXMENU -                                                  
   NEWNAME(SYS1.SBPXMENU) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.SBPXTENU -                                                  
   NEWNAME(SYS1.SBPXTENU) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ZFS.ADCDPL.ROOT -                                                
   NEWNAME(SYS1.OMVS.ROOT) -                                                    
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ZFS.ADCDPL.ROOT.T0838353.D5447400 -                              
   NEWNAME(SYS1.OMVS.ROOT.DATA) -                                               
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ZFS.S0W1.ETC -                                                  
   NEWNAME(SYS1.OMVS.ETC) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ZFS.S0W1.ETC.DATA -                                             
   NEWNAME(SYS1.OMVS.ETC.DATA) -                                                
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.ZFS.S0W1.TMP -                                            
   NEWNAME(SYS1.OMVS.TMP) -                                               
     CAT(SYS1.MCAT.VSY2PKA)                                                
/*                                                                              
