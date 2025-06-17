//COPY JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K
//* Verify existence of all datasets
//* Alter zfs data set names
//* update volumes
//***************************************************************               
//* OPTIONAL (SEPARATE TMP AND SCEERUN2 - SEE NOTES ABOVE):                     
//*                                                                             
//*  ADD THE FOLLOWING TO "INCLUDE" above:                                      
//*                                                                             
//*    OMVS.TMP -                                                               
//*    CEE.SCEERUN2 -                                                           
//*                                                                             
//*  ADD THE FOLLOWING TO "RENAMEU" above: "                                    
//*                                                                             
//*    (OMVS.TMP,   -                                                           
//*       TARGSYS.SYS1.OMVS.TMP)   -                                            
//*    (CEE.SCEERUN2,  -                                                        
//*       TARGSYS.CEE.SCEERUN2)   -                                             
//*                                                                             
//*****************************************************************             
//* ZAP RACF DATA SET NAME TABLE TO DISABLE SYSPLEX MODE                        
//* AND CHANGE PRIMARY DATA SET NAME TO SYS1.RACF.PRIMARY                       
//* AND CHANGE BACKUP  DATA SET NAME TO SYS1.RACF.BACKUP                  
//*****************************************************************             
//* DSS COPY THE CURRENT/RUNNING SYSTEM TO SYS1PK AND CATLG DSNS                
//*****************************************************************             
//COPY6   EXEC  PGM=ADRDSSU,REGION=4M,COND=(0,NE)                               
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
 COPY DS( -                                                                     
  INCLUDE( -                                                                    
      SYS1.IODF99.CLUSTER    -                                                  
      CSF.SCSFMOD1    -                                                         
      SYS1.CMDLIB    -                                                          
      SYS1.DAE    -                                                             
      SYS1.HELP    -                                                            
      SYS1.IMAGELIB    -                                                        
      SYS1.LINKLIB    -                                                         
      SYS1.MIGLIB    -                                                          
      SYS1.CSSLIB    -                                                          
      SYS1.SIEALNKE    -                                                        
      SYS1.SIEAMIGE    -                                                        
      SYS1.LPALIB    -                                                          
      SYS1.MACLIB    -                                                          
      SYS1.MODGEN    -                                                          
      SYS1.NUCLEUS    -                                                         
      SYS1.SHASLNKE    -                                                        
      SYS1.SHASMIG    -                                                         
      HLA.SASMMOD1    -                                                         
      SYS1.PARMLIB    -                                                         
      SYS1.PROCLIB    -                                                         
      SYS1.SAMPLIB    -                                                         
      SYS1.SISTCLIB    -                                                        
      SYS1.SVCLIB    -                                                          
      CEE.SCEERUN    -  
      CEE.SCEERUN2    -                                                        
      SYS1.VTAMLIB    -                                                         
      SYS1.UADS    -                                                            
      SYS1.VTAMLST    -                                                         
      SYS1.SCBDCLST    -                                                        
      SYS1.SCBDPENU    -                                                        
      SYS1.SCBDMENU    -                                                        
      SYS1.SCBDTENU    -                                                        
      SYS1.SCBDHENU    -                                                        
      SYS1.SDWWDLPA    -                                                        
      SYS1.DBBLIB    -                                                          
      SYS1.SEAGALT    -                                                         
      ISF.SISFEXEC    -                                                         
      ISF.SISFLINK    -                                                         
      ISF.SISFLOAD    -                                                         
      ISF.SISFLPA    -                                                          
      ISF.SISFMLIB    -                                                         
      ISF.SISFPLIB    -                                                         
      ISF.SISFSLIB    -                                                         
      ISF.SISFTLIB    -                                                         
      ISP.SISPCLIB    -                                                         
      ISP.SISPEXEC    -                                                         
      ISP.SISPLOAD    -                                                         
      ISP.SISPLPA    -                                                          
      ISP.SISPMENU    -                                                         
      ISP.SISPPENU    -                                                         
      ISP.SISPSENU    -                                                         
      ISP.SISPSLIB    -                                                         
      ISP.SISPTENU    -                                                         
      SYS1.SCUNLOCL    -                                                        
      TCPIP.SEZALPA    -                                                        
      TCPIP.SEZALOAD    -                                                       
      TCPIP.SEZALNK2    -                                                       
      TCPIP.SEZATCP    -                                                        
      SYS1.TCPPARMS    -                                                        
      SYS1.SBPXEXEC    -                                                        
      SYS1.SBPXPENU    -                                                        
      SYS1.SBPXMENU    -                                                        
      SYS1.SBPXTENU    -                                                        
      ZFS.ADCDPL.ROOT    -                                                      
      ZFS.S0W1.ETC    -  
      ZFS.S0W1.TMP    -
         )  -                                                                   
     ) -                                                                        
  RENAMEU( -                                                                    
     (SYS1.IODF53.CLUSTER,   -                                                  
        TARGSYS.SYS1.IODF99.CLUSTER)   -                                        
     (CSF.SCSFMOD1,   -                                                         
        TARGSYS.CSF.SCSFMOD1)   -                                               
     (SYS1.CMDLIB,   -                                                          
        TARGSYS.SYS1.CMDLIB)   -                                                
     (SYS1.DAE,   -                                                             
        TARGSYS.SYS1.DAE)   -                                                   
     (SYS1.HELP,   -                                                            
        TARGSYS.SYS1.HELP)   -                                                  
     (SYS1.IMAGELIB,   -                                                        
        TARGSYS.SYS1.IMAGELIB)   -                                              
     (SYS1.LINKLIB,   -                                                         
        TARGSYS.SYS1.LINKLIB)   -                                               
     (SYS1.MIGLIB,   -                                                          
        TARGSYS.SYS1.MIGLIB)   -                                                
     (SYS1.CSSLIB,   -                                                          
        TARGSYS.SYS1.CSSLIB)   -                                                
     (SYS1.SIEALNKE,   -                                                        
        TARGSYS.SYS1.SIEALNKE)   -                                              
     (SYS1.SIEAMIGE,   -                                                        
        TARGSYS.SYS1.SIEAMIGE)   -                                              
     (SYS1.LPALIB,   -                                                          
        TARGSYS.SYS1.LPALIB)   -                                                
     (SYS1.MACLIB,   -                                                          
        TARGSYS.SYS1.MACLIB)   -                                                
     (SYS1.MODGEN,   -                                                          
        TARGSYS.SYS1.MODGEN)   -                                                
     (SYS1.NUCLEUS,   -                                                         
        TARGSYS.SYS1.NUCLEUS)   -                                               
     (SYS1.SHASLNKE,   -                                                        
        TARGSYS.SYS1.SHASLNKE)   -                                              
     (SYS1.SHASMIG,   -                                                         
        TARGSYS.SYS1.SHASMIG)   -                                               
     (HLA.SASMMOD1,   -                                                         
        TARGSYS.ASM.SASMMOD1)   -                                               
     (SYS1.PARMLIB,   -                                                         
        TARGSYS.SYS1.PARMLIB)   -                                               
     (SYS1.PROCLIB,   -                                                         
        TARGSYS.SYS1.PROCLIB)   -                                               
     (SYS1.SAMPLIB,   -                                                         
        TARGSYS.SYS1.SAMPLIB)   -                                               
     (SYS1.SISTCLIB,   -                                                        
        TARGSYS.SYS1.SISTCLIB)   -                                              
     (SYS1.SVCLIB,   -                                                          
        TARGSYS.SYS1.SVCLIB)   -                                                
     (CEE.SCEERUN,   -                                                          
        TARGSYS.CEE.SCEERUN)   -                                                
     (CEE.SCEERUN2,   -                                                         
        TARGSYS.CEE.SCEERUN2)   -                                               
     (SYS1.VTAMLIB,   -                                                         
        TARGSYS.SYS1.VTAMLIB)   -                                               
     (SYS1.UADS,   -                                                            
        TARGSYS.SYS1.UADS)   -                                                  
     (SYS1.VTAMLST,   -                                                         
        TARGSYS.SYS1.VTAMLST)   -                                               
     (SYS1.SCBDCLST,   -                                                        
        TARGSYS.SYS1.SCBDCLST)   -                                              
     (SYS1.SCBDPENU,   -                                                        
        TARGSYS.SYS1.SCBDPENU)   -                                              
     (SYS1.SCBDMENU,   -                                                        
        TARGSYS.SYS1.SCBDMENU)   -                                              
     (SYS1.SCBDTENU,   -                                                        
        TARGSYS.SYS1.SCBDTENU)   -                                              
     (SYS1.SCBDHENU,   -                                                        
        TARGSYS.SYS1.SCBDHENU)   -                                              
     (SYS1.SDWWDLPA,   -                                                        
        TARGSYS.SYS1.SDWWDLPA)   -                                              
     (SYS1.DBBLIB,   -                                                          
        TARGSYS.SYS1.DBBLIB)   -                                                
     (REXX.SEAGALT,   -                                                         
        TARGSYS.REXX.SEAGALT)   -                                               
     (ISF.SISFEXEC,   -                                                         
        TARGSYS.ISF.SISFEXEC)   -                                               
     (ISF.SISFLINK,   -                                                         
        TARGSYS.ISF.SISFLINK)   -                                               
     (ISF.SISFLOAD,   -                                                         
        TARGSYS.ISF.SISFLOAD)   -                                               
     (ISF.SISFLPA,   -                                                          
        TARGSYS.ISF.SISFLPA)   -                                                
     (ISF.SISFMLIB,   -                                                         
        TARGSYS.ISF.SISFMLIB)   -                                               
     (ISF.SISFPLIB,   -                                                         
        TARGSYS.ISF.SISFPLIB)   -                                               
     (ISF.SISFSLIB,   -                                                         
        TARGSYS.ISF.SISFSLIB)   -                                               
     (ISF.SISFTLIB,   -                                                         
        TARGSYS.ISF.SISFTLIB)   -                                               
     (ISP.SISPCLIB,   -                                                         
        TARGSYS.ISP.SISPCLIB)   -                                               
     (ISP.SISPEXEC,   -                                                         
        TARGSYS.ISP.SISPEXEC)   -                                               
     (ISP.SISPLOAD,   -                                                         
        TARGSYS.ISP.SISPLOAD)   -                                               
     (ISP.SISPLPA,   -                                                          
        TARGSYS.ISP.SISPLPA)   -                                                
     (ISP.SISPMENU,   -                                                         
        TARGSYS.ISP.SISPMENU)   -                                               
     (ISP.SISPPENU,   -                                                         
        TARGSYS.ISP.SISPPENU)   -                                               
     (ISP.SISPSENU,   -                                                         
        TARGSYS.ISP.SISPSENU)   -                                               
     (ISP.SISPSLIB,   -                                                         
        TARGSYS.ISP.SISPSLIB)   -                                               
     (ISP.SISPTENU,   -                                                         
        TARGSYS.ISP.SISPTENU)   -                                               
     (SYS1.SCUNLOCL,   -                                                        
        TARGSYS.SYS1.SCUNLOCL)   -                                              
     (TCPIP.SEZALPA,   -                                                        
        TARGSYS.TCPIP.SEZALPA)   -                                              
     (TCPIP.SEZALOAD,   -                                                       
        TARGSYS.TCPIP.SEZALOAD)   -                                             
     (TCPIP.SEZALNK2,   -                                                       
        TARGSYS.TCPIP.SEZALNK2)   -                                             
     (TCPIP.SEZATCP,   -                                                        
        TARGSYS.TCPIP.SEZATCP)   -                                              
     (SYS1.TCPPARMS,   -                                                        
        TARGSYS.SYS1.TCPPARMS)   -                                              
     (SYS1.SBPXEXEC,   -                                                        
        TARGSYS.SYS1.SBPXEXEC)   -                                              
     (SYS1.SBPXPENU,   -                                                        
        TARGSYS.SYS1.SBPXPENU)   -                                              
     (SYS1.SBPXMENU,   -                                                        
        TARGSYS.SYS1.SBPXMENU)   -                                              
     (SYS1.SBPXTENU,   -                                                        
        TARGSYS.SYS1.SBPXTENU)   -                                              
     (ZFS.ADCDPL.ROOT,   -                                                      
        TARGSYS.ZFS.ADCDPL.ROOT)   -                                            
     (ZFS.S0W1.ETC,   -                                                         
        TARGSYS.ZFS.S0W1.ETC)   -                                              
     (ZFS.S0W1.TMP,   -                                                         
        TARGSYS.ZFS.S0W1.TMP)   -                                              
     ) -                                                                        
  SHARE TOL(ENQF)                  -                                            
  STORCLAS(SCNONSMS)               -                                            
  OUTDYNAM(SY2PKA,SYSALLDA)        -                                            
  REPLACEU -                                                                    
  CATALOG -                                                                     
  PROCESS(SYS1) SPHERE -                                                        
  WAIT(2,2)  ALLDATA(*)  ALLEXCP                                                
/*                                                                              
/*                                                                              
