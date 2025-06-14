//*****************************************************************             
//* UPDATE PROCLIB WITH REQUIRED MEMBERS                                        
//*****************************************************************             
//UPROC17  EXEC PGM=IEBUPDTE,PARM=NEW,REGION=4M,COND=(0,NE)                     
//SYSUT2   DD  DSN=SYS1.PROCLIB,DISP=SHR,                                       
//             UNIT=SYSALLDA,VOL=SER=SY2PKA                                     
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DATA,DLM=@#                                                      
./ ADD NAME=IRRDPTAB,LEVEL=00,SOURCE=0,LIST=ALL                                 
//IRRDPTAB PROC                                                                 
//*  THIS STARTED TASK IS RUN AT IPL TO LOAD THE RACF DYNAMIC                   
//*  PARSE TABLES.  THE USERID FOR THE TASK MUST BE AUTHORIZED                  
//*  TO ISSUE THE IRRDPI00 COMMAND.                                             
//         EXEC PGM=IKJEFT01,REGION=1M,PARM='IRRDPI00 UPDATE'                   
//SYSTSPRT DD SYSOUT=*,HOLD=YES                                                 
//SYSUDUMP DD SYSOUT=*,HOLD=YES                                                 
//SYSUT1   DD DSN=SYS1.SAMPLIB(IRRDPSDS),DISP=SHR                               
//SYSTSIN  DD DUMMY                                                             
./ ADD NAME=IKJACCNT,LEVEL=00,SOURCE=0,LIST=ALL                                 
//IKJACCNT PROC                                                                 
//IKJACCNT EXEC PGM=IKJEFT01,DYNAMNBR=90,PARM='%LOGPROF'                        
//SYSEXEC  DD DISP=SHR,DSN=ISP.SISPEXEC              ISPF                       
//         DD DISP=SHR,DSN=SYS1.SBPXEXEC             ISHELL                     
//SYSPROC  DD DISP=SHR,DSN=ISP.SISPCLIB              ISPF                       
//         DD DISP=SHR,DSN=SYS1.SCBDCLST             HCD                        
//SYSHELP  DD DISP=SHR,DSN=SYS1.HELP                 TSO                        
//ISPTLIB  DD DISP=SHR,DSN=ISP.SISPTENU              ISPF                       
//         DD DISP=SHR,DSN=ISF.SISFTLIB              SDSF                       
//         DD DISP=SHR,DSN=SYS1.SBPXTENU             ISHELL                     
//ISPSLIB  DD DISP=SHR,DSN=ISP.SISPSLIB              ISPF                       
//         DD DISP=SHR,DSN=ISP.SISPSENU              ISPF                       
//ISPMLIB  DD DISP=SHR,DSN=ISP.SISPMENU              ISPF                       
//         DD DISP=SHR,DSN=ISF.SISFMLIB              SDSF                       
//         DD DISP=SHR,DSN=SYS1.SBPXMENU             ISHELL                     
//ISPPLIB  DD DISP=SHR,DSN=ISP.SISPPENU              ISPF                       
//         DD DISP=SHR,DSN=ISF.SISFPLIB              SDSF                       
//         DD DISP=SHR,DSN=SYS1.SBPXPENU             ISHELL                     
//SYSPRINT DD TERM=TS,SYSOUT=*                                                  
//SYSTERM  DD TERM=TS,SYSOUT=*                                                  
//SYSIN    DD TERM=TS                                                           
./ ADD NAME=TSOJCL,LEVEL=00,SOURCE=0,LIST=ALL                                   
//TSOJCL   PROC                                                                 
//TSOJCL   EXEC PGM=IKJEFT01,DYNAMNBR=90,PARM='%LOGPROF'                        
//SYSEXEC  DD DISP=SHR,DSN=ISP.SISPEXEC              ISPF                       
//         DD DISP=SHR,DSN=SYS1.SBPXEXEC             ISHELL                     
//SYSPROC  DD DISP=SHR,DSN=ISP.SISPCLIB              ISPF                       
//         DD DISP=SHR,DSN=SYS1.SCBDCLST             HCD                        
//SYSHELP  DD DISP=SHR,DSN=SYS1.HELP                 TSO                        
//ISPTLIB  DD DISP=SHR,DSN=ISP.SISPTENU              ISPF                       
//         DD DISP=SHR,DSN=ISF.SISFTLIB              SDSF                       
//         DD DISP=SHR,DSN=SYS1.SBPXTENU             ISHELL                     
//ISPSLIB  DD DISP=SHR,DSN=ISP.SISPSLIB              ISPF                       
//         DD DISP=SHR,DSN=ISP.SISPSENU              ISPF                       
//ISPMLIB  DD DISP=SHR,DSN=ISP.SISPMENU              ISPF                       
//         DD DISP=SHR,DSN=ISF.SISFMLIB              SDSF                       
//         DD DISP=SHR,DSN=SYS1.SBPXMENU             ISHELL                     
//ISPPLIB  DD DISP=SHR,DSN=ISP.SISPPENU              ISPF                       
//         DD DISP=SHR,DSN=ISF.SISFPLIB              SDSF                       
//         DD DISP=SHR,DSN=SYS1.SBPXPENU             ISHELL                     
//SYSPRINT DD TERM=TS,SYSOUT=*                                                  
//SYSTERM  DD TERM=TS,SYSOUT=*                                                  
//SYSIN    DD TERM=TS                                                           
./ ADD NAME=JES2,LEVEL=00,SOURCE=0,LIST=ALL                                     
//JES2     PROC                                                                 
//IEFPROC  EXEC PGM=HASJES20,                                                   
//            DPRTY=(15,15),TIME=1440,PERFORM=9                                 
//ALTPARM  DD DISP=SHR,                                                         
//            DSN=SYS1.PARMLIB(JES2PARM)                                        
//HASPPARM DD DISP=SHR,                                                         
//            DSN=SYS1.PARMLIB(JES2PARM)                                        
//PROC00   DD DISP=SHR,                                                         
//            DSN=SYS1.PROCLIB                                                  
//         DD DISP=SHR,                                                         
//            DSN=SYS1.IBM.PROCLIB                                              
//HASPLIST DD DDNAME=IEFRDER                                                    
./ ADD NAME=LLA,LEVEL=00,SOURCE=0,LIST=ALL                                      
//LLA PROC LLA=                                                                 
//LLA EXEC PGM=CSVLLCRE,PARM='LLA=&LLA'                                         
./ ADD NAME=VLF,LEVEL=00,SOURCE=0,LIST=ALL                                      
//VLF      PROC  NN=00                                                          
//VLF      EXEC  PGM=COFMINIT,PARM='NN=&NN'                                     
./ ADD NAME=NET,LEVEL=00,SOURCE=0,LIST=ALL                                      
//NET    PROC                                                                   
//NET      EXEC PGM=ISTINM01,REGION=0M,                                         
//         DPRTY=(15,15),TIME=1440,PERFORM=8                                    
//VTAMLST  DD DISP=SHR,                                                         
//            DSN=SYS1.VTAMLST                                                  
//VTAMLIB  DD DISP=SHR,                                                         
//            DSN=SYS1.VTAMLIB                                                  
//SISTCLIB DD DISP=SHR,                                                         
//            DSN=SYS1.SISTCLIB                                                 
//SYSABEND DD SYSOUT=*,HOLD=YES                                                 
./ ADD NAME=SDSF,LEVEL=00,SOURCE=0,LIST=ALL                                     
//SDSF     PROC  M=00,         /* SUFFIX FOR ISFPRMXX */                        
//             P='LC(X)'       /* USE SYSOUT CLASS X FOR SDSFLOG */             
//SDSF     EXEC  PGM=ISFHCTL,REGION=32M,TIME=1440,PARM='M(&M),&P'               
./ ADD NAME=SDSFAUX,LEVEL=00,SOURCE=0,LIST=ALL                                  
//SDSFAUX  PROC RGN=512M,MEMLIM=100G,FOLDMSG=NO                                 
//*                                                                             
//SDSFAUX  EXEC PGM=HSFSRV00,PARM='FOLDMSG(&FOLDMSG)',                          
//         REGION=&RGN,TIME=NOLIMIT,MEMLIMIT=&MEMLIM                            
//*STEPLIB DD   DISP=SHR,DSN=ISF.SISFLOAD                                       
//HSFLOG   DD   SYSOUT=*                                                        
//HSFTRACE DD   SYSOUT=*                                                        
./ ADD NAME=TSO,LEVEL=00,SOURCE=0,LIST=ALL                                      
//TSO    PROC MBR=TSOKEY00                                                      
//TSO    EXEC PGM=IKTCAS00,TIME=1440                                            
//PARMLIB DD DSN=SYS1.PARMLIB(&MBR),DISP=SHR,FREE=CLOSE                         
//PRINTOUT DD SYSOUT=*,FREE=CLOSE                                               
./ ADD NAME=EZAZSSI,LEVEL=00,SOURCE=0,LIST=ALL                                  
//EZAZSSI  PROC P=&SYSNAME                                                      
//STARTVT  EXEC PGM=EZAZSSI,PARM=&P,TIME=NOLIMIT                                
./ ADD NAME=TCPIP,LEVEL=00,SOURCE=0,LIST=ALL                                    
//TCPIP    PROC PARMS='CTRACE(CTIEZB00)'                                        
//*                                                                             
//*  z/OS Communications Server                                                 
//*  SMP/E Distribution Name: EZAEB01G                                          
//*                                                                             
//*  Licensed Materials - Property of IBM                                       
//*  "Restricted Materials of IBM"                                              
//*  5694-A01                                                                   
//*  (C) Copyright IBM Corp. 1991, 2001                                         
//*  Status = CSV1R2                                                            
//*                                                                             
//TCPIP    EXEC PGM=EZBTCPIP,REGION=0M,TIME=1440,                               
//             PARM='&PARMS'                                                    
//*            PARM=('&PARMS',                                                  
//*        'ENVAR("RESOLVER_CONFIG=//''TCPIVP.TCPPARMS(TCPDATA)''")')           
//*                                                                             
//*PARMS ...                                                                    
//*                                                                             
//*     Valid options for the PARMS procedure operand are:                      
//*                                                                             
//*       1) CTRACE(nnnnnnnn)                                                   
//*                                                                             
//*          Specifies the SYS1.PARMLIB member to be used for SYSTCPIP          
//*          CTRACE initialization.  The default value is "CTIEZB00".           
//*                                                                             
//*       2) TRC=xx                                                             
//*                                                                             
//*          Specifies the suffix of the SYS1.PARMLIB member to by used         
//*          for SYSTCPIP CTRACE initialization.  The full member name          
//*          will be "CTIEZBxx".  The default value is "00".                    
//*                                                                             
//*       3) IDS=xx                                                             
//*                                                                             
//*          Specifies the suffix of the SYS1.PARMLIB member to by used         
//*          for SYSTCPIS CTRACE initialization.  The full member name          
//*          will be "CTIIDSxx".  The default value is "00".                    
//*                                                                             
//*     Multiple options may be specified.  If both the CTRACE and              
//*     TRC options are specified, whichever appears last in the                
//*     parameter string will be used.                                          
//*                                                                             
//*     To enable tracing of Configuration component processing which           
//*     occurs before the ITRACE profile statement is processed,                
//*     specify the -d (or -D) parameter as follows:                            
//*     PARM=('&PARMS',                                                         
//*        'ENVAR("RESOLVER_CONFIG=//''TCPIVP.TCPPARMS(TCPDATA)''")',           
//*        '/ -d')                                                              
//*     This option is the equivalent of the ITRACE ON CONFIG 1                 
//*     Profile statement and can be disabled with ITRACE OFF CONFIG.           
//*******************************************************************           
//*     The C runtime libraries should be in the system's link list             
//*     or add them via a STEPLIB definition here.  If you add                  
//*     them via a STEPLIB, they must be APF authorized with DISP=SHR           
//*                                                                             
//*STEPLIB  DD ...                                                              
//*                                                                             
//*     SYSPRINT contains Resolver run-time diagnostics (TRACE RESOLVER         
//*        output).  It can be directed to SYSOUT or a data set.                
//*        We recommend directing the output to SYSOUT due to                   
//*        data set size restraints.                                            
//*     ALGPRINT contains run-time diagnostics from TCP/IP's Autolog            
//*        task. It can be directed to SYSOUT or a data set.  We                
//*        recommend directing the output to SYSOUT due to data set size        
//*        restraints.                                                          
//*     CFGPRINT contains run-time diagnostics from TCP/IP's Config             
//*        task and TCPIPSTATISTICS counter output.                             
//*        It can be directed to SYSOUT or a data set. We recommend             
//*        directing the output to SYSOUT due to data set size                  
//*        restraints.                                                          
//*     SYSERROR contains console messages issued by TCP/IP's Config            
//*        task while processing a PROFILE or OBEYFILE.                         
//*                                                                             
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=VB,LRECL=132,BLKSIZE=136)                     
//ALGPRINT DD SYSOUT=*,DCB=(RECFM=VB,LRECL=132,BLKSIZE=136)                     
//CFGPRINT DD SYSOUT=*,DCB=(RECFM=VB,LRECL=132,BLKSIZE=136)                     
//SYSOUT   DD SYSOUT=*,DCB=(RECFM=VB,LRECL=132,BLKSIZE=136)                     
//CEEDUMP  DD SYSOUT=*,DCB=(RECFM=VB,LRECL=132,BLKSIZE=136)                     
//SYSERROR DD SYSOUT=*                                                          
//*                                                                             
//*        TNDBCSCN is the configuration data set for TELNET DBCS               
//*        transform mode.                                                      
//*                                                                             
//*TNDBCSCN DD DSN=TCPIP.SEZAINST(TNDBCSCN),DISP=SHR                            
//*                                                                             
//*        TNDBCSXL contains binary DBCS translation table codefiles            
//*        used by TELNET DBCS Transform mode.                                  
//*                                                                             
//*TNDBCSXL DD DSN=TCPIP.SEZAXLD2,DISP=SHR                                      
//*                                                                             
//*        TNDBCSER receives debug output from TELNET DBCS Transform            
//*        mode, when TRACE TELNET is specified in the PROFILE data set.        
//*                                                                             
//*TNDBCSER DD SYSOUT=*                                                         
//*                                                                             
//*                                                                             
//*PROFILE  DD ...                                                              
//*     The PROFILE DD statement specifies the data set containing the          
//*     TCP/IP configuration parameters.  If the PROFILE DD statement           
//*     is not supplied, a default search order is used to find                 
//*     the PROFILE data set.  See the IP Configuration Guide for               
//*     a description of the search order for PROFILE.TCPIP.  A                 
//*     sample profile is included in member SAMPPROF of the                    
//*     SEZAINST data set.                                                      
//*                                                                             
//*PROFILE  DD DISP=SHR,DSN=TCPIVP.TCPPARMS(PROFILE)                            
//*PROFILE  DD DISP=SHR,DSN=TCPIP.PROFILE.TCPIP                                 
//PROFILE  DD DISP=SHR,DSN=SYS1.TCPPARMS(PROFILE)                               
//*                                                                             
//*     SYSTCPD explicitly identifies which data set is to be                   
//*        used to obtain the parameters defined by TCPIP.DATA                  
//*        when no GLOBALTCPIPDATA statement is configured.                     
//*        See the IP Configuration Guide for information on                    
//*        the TCPIP.DATA search order.                                         
//*        The data set can be any sequential data set or a member of           
//*        a partitioned data set (PDS).                                        
//*                                                                             
//*SYSTCPD  DD DSN=TCPIVP.TCPPARMS(TCPDATA),DISP=SHR                            
//*SYSTCPD  DD DSN=TCPIP.SEZAINST(TCPDATA),DISP=SHR                             
//SYSTCPD  DD DSN=SYS1.TCPPARMS(TCPDATA),DISP=SHR                               
./ ADD NAME=TN3270,LEVEL=00,SOURCE=0,LIST=ALL                                   
//TN3270   PROC PARMS='CTRACE(CTIEZBTN)'                                        
//*TN3270   PROC PARMS='TRC=TN'                                                 
//*                                                                             
//*  z/OS Communications Server                                                 
//*  SMP/E Distribution Name: EZBTNPRC                                          
//*                                                                             
//*  5694-A01 (C) Copyright IBM Corp. 1991, 2004                                
//*  Licensed Materials - Property of IBM                                       
//*                                                                             
//*  Function: Start TN3270 Telnet Server                                       
//*                                                                             
//* The PARM= field is used for CTRACE() or TRC= setup only.                    
//* No LE parms are passed to attached C processes.                             
//*                                                                             
//TN3270   EXEC PGM=EZBTNINI,REGION=0M,PARM='&PARMS'                            
//*                                                                             
//*******************************************************************           
//*     The C runtime libraries should be in the system's link list             
//*     or add them via a STEPLIB definition here.  If you add                  
//*     them via a STEPLIB, they must be APF authorized with DISP=SHR           
//*                                                                             
//*STEPLIB  DD ...                                                              
//*                                                                             
//*     SYSPRINT contains detailed trace output from 3270 Transform.            
//*        It can be directed to SYSOUT or a data set.  We recommend            
//*        directing the output to SYSOUT due to data set size                  
//*        constraints.                                                         
//*                                                                             
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=VB,LRECL=132,BLKSIZE=136)                     
//SYSOUT   DD SYSOUT=*,DCB=(RECFM=VB,LRECL=132,BLKSIZE=136)                     
//CEEDUMP  DD SYSOUT=*,DCB=(RECFM=VB,LRECL=132,BLKSIZE=136)                     
//*                                                                             
//*        TNDBCSCN is the configuration data set for DBCSTransform             
//*        mode.                                                                
//*                                                                             
//*TNDBCSCN DD DISP=SHR,DSN=TCPIP.SEZAINST(TNDBCSCN)                            
//*                                                                             
//*        TNDBCSXL contains binary DBCS translation table codefiles            
//*        used by DBCSTransform mode.                                          
//*                                                                             
//*TNDBCSXL DD DISP=SHR,DSN=TCPIP.SEZAXLD2                                      
//*                                                                             
//*        TNDBCSER receives debug output from TELNET DBCS Transform            
//*        mode, when DBCSTRACE is specified in the PROFILE data set.           
//*                                                                             
//*TNDBCSER DD SYSOUT=*                                                         
//*                                                                             
//*                                                                             
//PROFILE  DD DISP=SHR,DSN=SYS1.TCPPARMS(TNPROF)                                
//*     The PROFILE DD statement specifies the data set containing the          
//*     Telnet configuration parameters.  If the PROFILE DD statement           
//*     is not supplied, Telnet will not start any ports.  There is             
//*     no default data set.  An Obeyfile command can be used later             
//*     to start a Telnet port.                                                 
//*     A sample profile is included in member TNPROF of the SEZAINST           
//*     data set.                                                               
//*SYSTCPD  DD ...                                                              
//*     The SYSTCPD DD statement specifies an optional data set containing      
//*     parameters used by the Resolver to resolve client IP addresses          
//*     into hostnames.  The parameters in this data set are used               
//*     when no GLOBALTCPIPDATA statement is configured.                        
//*     The Resolver search order is likely the search order needed by          
//*     Telnet.  Use of the SYSTCPD DD statement here is strongly               
//*     discouraged.                                                            
//*     See the IP Configuration Guide for information on the                   
//*     the TCPIP.DATA search order in the native MVS environment and           
//*     the TCPIP.DATA parameters needed by the Resolver.                       
//*     The data set can be any sequential data set or a member of              
//*     a partitioned data set (PDS).                                           
./ ADD NAME=FTP,LEVEL=00,SOURCE=0,LIST=ALL                                      
//FTPD   PROC MODULE='FTPD',PARMS=''                                            
//*********************************************************************         
//*         Descriptive Name:            FTP Server Start Procedure   *         
//*         File Name:                   tcpip.SEZAINST(EZAFTPAP)     *         
//*                                      tcpip.SEZAINST(FTPD)         *         
//*         SMP/E Distribution Name:     EZAFTPAP                     *         
//*                                                                   *         
//*         Licensed Materials - Property of IBM                      *         
//*         "Restricted Materials of IBM"                             *         
//*         5694-A01                                                  *         
//*         (C) Copyright IBM Corp. 1995, 2001                        *         
//*         Status = CSV1R2                                           *         
//*********************************************************************         
//FTPD   EXEC PGM=&MODULE,REGION=4096K,TIME=NOLIMIT,                            
//       PARM='POSIX(ON) ALL31(ON)/&PARMS'                                      
//*   PARM=('POSIX(ON) ALL31(ON)',                                              
//*  'ENVAR("RESOLVER_CONFIG=//''TCPIVP.TCPPARMS(TCPDATA)''")/&PARMS')          
//*                                                                             
//*   PARM=('POSIX(ON) ALL31(ON) ENVAR("_BPX_JOBNAME=myftp")/',                 
//*   '&PARMS')                                                                 
//*                                                                             
//*   PARM=('POSIX(ON) ALL31(ON) ENVAR("KRB5_SERVER_KEYTAB=1")/',               
//*   '&PARMS')                                                                 
//*                                                                             
//**** IVP Note ******************************************************          
//*                                                                             
//* If executing the FTP installation verification procedures (IVP),            
//* - Comment the first PARM card and uncomment both lines of the               
//*   second PARM card                                                          
//* - Uncomment the appropriate SYSFTPD and SYSTCPD DD cards for the IVP        
//*                                                                             
//********************************************************************          
//**** _BPX_JOBNAME Note *********************************************          
//*                                                                             
//* The environment variable _BPX_JOBNAME can be specified                      
//* here in the FTPD procedure, so that all of the logged on                    
//* FTP users will have the same jobname.  This can then                        
//* be used for performance control and identifying all FTP users.              
//* To use this:                                                                
//* - Comment the first PARM card and uncomment both lines of the               
//*   third PARM card                                                           
//*                                                                             
//********************************************************************          
//**** KRB5_SERVER_KEYTAB Note ***************************************          
//*                                                                             
//* The environment variable KRB5_SERVER_KEYTAB can be specified                
//* here in the FTPD procedure, so that the FTP server will use the             
//* local instance of the Kerberos security server to decrypt tickets           
//* instead of obtaining the key from the key table.                            
//* To use this:                                                                
//* - Comment the first PARM card and uncomment both lines of the               
//*   fourth PARM card                                                          
//*                                                                             
//********************************************************************          
//*                                                                             
//*       The C runtime libraries should be in the system's link                
//*       list or add them to the STEPLIB definition here.  If you              
//*       add them to STEPLIB, they must be APF authorized.                     
//*                                                                             
//*       To submit SQL queries to DB2 through FTP, the DB2 load                
//*       library with the suffix DSNLOAD should be in the system's             
//*       link list, or added to the STEPLIB definition here.  If               
//*       you add it to STEPLIB, it must be APF authorized.                     
//*                                                                             
//CEEDUMP  DD SYSOUT=*                                                          
//*                                                                             
//*       SYSFTPD is used to specify the FTP.DATA file for the FTP              
//*       server.  The file can be any sequential data set, member              
//*       of a partitioned data set (PDS), or HFS file.                         
//*                                                                             
//*       The SYSFTPD DD statement is optional.  The search order for           
//*       FTP.DATA is:                                                          
//*                                                                             
//*           SYSFTPD DD statement                                              
//*           jobname.FTP.DATA                                                  
//*           /etc/ftp.data                                                     
//*           SYS1.TCPPARMS(FTPDATA)                                            
//*           tcpip.FTP.DATA                                                    
//*                                                                             
//*       If no FTP.DATA file is found, FTP default values are used.            
//*       For information on FTP defaults, see OS/390 eNetwork                  
//*       Communications Server: IP Configuration Reference.                    
//*SYSFTPD DD DISP=SHR,DSN=TCPIP.SEZAINST(FTPSDATA)                             
//*SYSFTPD DD DISP=SHR,DSN=TCPIVP.TCPPARMS(FTPSDATA)                            
//*                                                                             
//*       SYSTCPD explicitly identifies which data set is to be                 
//*       used to obtain the parameters defined by TCPIP.DATA                   
//*       when no GLOBALTCPIPDATA statement is configured.                      
//*       See the IP Configuration Guide for information on                     
//*       the TCPIP.DATA search order.                                          
//*       The data set can be any sequential data set or a member of            
//*       a partitioned data set (PDS).                                         
//*SYSTCPD DD DISP=SHR,DSN=TCPIP.SEZAINST(TCPDATA)                              
//*SYSTCPD DD DISP=SHR,DSN=TCPIVP.TCPPARMS(TCPDATA)                             
//SYSTCPD  DD DSN=SYS1.TCPPARMS(TCPDATA),DISP=SHR                               
//*                                                                             
./ ADD NAME=ZFS,LEVEL=00,SOURCE=0,LIST=ALL                                      
//ZFS      PROC REGSIZE=0M                                                      
//*                                                                             
//ZFZGO    EXEC PGM=BPXVCLNY,REGION=&REGSIZE,TIME=1440                          
//*                                                                             
//IOEZPRM DD DISP=SHR,DSN=SYS1.PARMLIB(IOEFSPRM)    <--ZFS PARM FILE            
//*                                                                             
./ ENDUP                                                                        
@#                                                                              
