//USZCZT0P  JOB (ADSS),'#07B42 ZELDEN',                                         
//             NOTIFY=&SYSUID,                                                  
//             CLASS=M,MSGCLASS=H,MSGLEVEL=(1,1)                                
//*                                                                             
//*JOBPARM SYSAFF=????                                                          
//*                                                                             
//*****************************************************************             
//* **WARNING: DO NOT SET "NUMBER ON" IN THIS MEMBER OR RENUMBER                
//*****************************************************************             
//* THIS SAMPLE CAN BE USED FOR Z/OS 2.4 AND Z/OS 2.5                           
//*   FOR Z/OS 2.3 SEE TWOPAK23                                                 
//*   FOR Z/OS 2.2 SEE TWOPAK22                                                 
//*   FOR Z/OS 2.1 SEE TWOPAK21                                                 
//*   FOR Z/OS 1.8 THOUGH Z/OS 1.13, SEE TWOPAKZ*                               
//*                                                                             
//* PLEASE READ ALL COMMENTS BELOW!!                                            
//*                                                                             
//* SAMPLE LAST UPDATED ON 09/16/2024                                           
//*                                                                             
//*****************************************************************             
//*  YOU MUST USE NEWLY INITIALIZED DASD VOLUMES FOR OUTPUT                     
//*  BEFORE SUBMITTING THIS JOB                                                 
//*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*             
//* While this sample is named "TWOPAKxx" due to OS changes                     
//* over the years, it is now configured to all be on a single                  
//* volume which must be a 3390-9 or bigger.                                    
//*                                                                             
//* On my own environment, about 600 CYL were left free on a                    
//* 3390-9 using this sample. You can adjust JES2 SPOOL space                   
//* up or down depending on your own environment.                               
//*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*             
//*  GLOBALLY CHANGE SY2PKA TO DESIRED TWOPAK VOLSER #1                         
//*  GLOBALLY CHANGE TARGSYS TO DESIRED SSA (NEED ALTER ACCESS)                 
//*  GLOBALLY CHANGE SYS1.ICFCAT.MSTRDRVR TO DRIVER SYS MCAT NAME               
//*  GLOBALLY CHANGE SYS1.IODF53 TO DRIVER SYS / CURRENT IODF                   
//*  GLOBALLY CHANGE OMVS.ROOT TO DRIVER SYS OMVS ROOT                          
//*  GLOBALLY CHANGE OMVS.ETC  TO DRIVER SYS OMVS ETC                           
//*  GLOBALLY CHANGE SYS1.RACF.LOCAL.PRIMARY to DRIVER RACF PRIM                
//*  GLOBALLY CHANGE SYS1.RACF.LOCAL.BACKUP  to DRIVER RACF BKUP                
//*****************************************************************             
//*  REVIEW ALL PARMLIB, PROCLIB & VTAMLST MEMBERS (STEPS 15-17)                
//*  REVIEW TCPIP PARM MEMBERS (STEP 20)                                        
//*  - CONSOL00 AND LCL3270A ADDRESSES MUST MATCH LOCAL 3270 CONFIG             
//*  - LOAD00 MUST HAVE A VALID OS CONFIG AND EDT CONFIG                        
//*  - CHECK SPOOLDEF IN JES2PARM FOR CORRECT 5 CHAR. VOLUME PREFIX             
//*  - TCPIP ACCESS NEEDS PROFILE CUSTOMZIATION AND PROBABLY                    
//*       ADDITIONAL VTAM OSA / TRLE MEMBERS ADDED TO THE JOB                   
//*       AND NODES ACTIVATED BASED ON LOCAL CONFIG.                            
//*****************************************************************             
//* THE TWOPAK SYSTEM INCLUDES (AT LEAST) THE FOLLOWING PRODUCTS                
//* (IN ADDITION TO Z/OS BCP AND DFSMS): JES2, TSO/E, RACF, VTAM,               
//*  TCP/IP, ISPF, SDSF, ICKDSF, HCD, LE, HLASM, UNICODE PLUS                   
//*  ISV PRODUCTS: SYNCSORT  (FDR NO LONGER AVAILABLE)                          
//*                                                                             
//*  A 3390-3 IS REQUIRED FOR THE PRIMARY SYSTEM VOLUME.                        
//*  YOU MAY BE ABLE TO USE A 3390-2 OR 3380-K DEPENDING ON THE                 
//*  SIZE OF YOUR RACF DATA SETS, IODF DSN, HOW BIG YOU ALLOCATE                
//*  YOUR SPOOL AND LOCAL PAGE DATA SET, AND BY NOT INCLUDING                   
//*  SYS1.MACLIB AND SYS1.MODGEN. ALTERNATIVLY, YOU CAN MOVE SOME               
//*  OF THE DATASETS IN THE COPY STEP TO THE SECONDARY VOLUME.                  
//*                                                                             
//*  IF YOUR CURRENT OMVS ROOT DOES NOT FIT ON A 3390-3, THEN                   
//*  YOU CAN NOT BUILD THIS SYSTEM WITH 2 VOLUMES.  IN THAT                     
//*  CASE, USE A SINGLE 3390-9 AND "CHANGE SY2PKB SY2PKA ALL".                  
//*  THIS WOULD ALSO GIVE YOU PLENTY OF ROOM TO ENLARGE THE                     
//*  JES2 SPOOL OR LOCAL PAGE DATASET IF NEEDED.                                
//*                                                                             
//*  IF YOU ARE NOT USING ZFS, YOU DON'T NEED HLQ.SIOELMOD AND                  
//*  THE STARTUP OF ZFS NEEDS TO BE REMOVED FROM BPXPRM00. THIS                 
//*  CAN ALSO SAVE 100+ CYLINDERS.                                              
//*                                                                             
//*  UNICODE (SYS1.SCUN*) CAN PROBABLY BE REMOVED IF NOT USING                  
//*  THIS SAMPLE FOR Z/OS 1.9 (OR ABOVE) AND YOU DON'T CARE ABOUT               
//*  BEING ABLE TO TELNET INTO UNIX. THIS CAN SAVE ABOUT 150 CYLS.              
//*  BE SURE TO REMOVE SYS1.SCUNIMG FROM THE LNKLST IN PROG00.                  
//*****************************************************************             
//*  SMS IS ACTIVATED IN A NULL CONFIGURATION TO ALLOW TCP/IP TO                
//*  DYNAMICALLY ALLOCATE Z/OS UNIX FILES.  WITHOUT IT SOME TCP/IP              
//*  FUNCTIONS THAT REQUIRE TO READ THEIR CONFIG FILES FROM UNIX                
//*  VIA DYNALLOC WITH PATHNAME WILL FAIL (RC=4, ERRORCODE=04D0)                
//*  (/ETC/SERVICES IS REQUIRED FOR INETD FOR EXAMPLE AND CAN'T                 
//*  BE READ).  THIS ISN'T REQUIRED FOR A "RESCUE" SYSTEM, BUT IS               
//*  INCLUDED IN THE CONFIGURATION ANYWAY AND ALLOWS TELNET INTO                
//*  Z/OS UNIX IF DESIRED (AND CONFIGURED).                                     
//*                                                                             
//*  NOTE THAT WHEN TESTING Z/OS 1.8 I SAW AN ABEND AT IPL TIME                 
//*  DURING OMVS STARTUP IN CEEBINIT.  THIS TURNED OUT TO BE FROM               
//*  SYSLOGD WHICH WAS STARTED VIA /ETC/RC IN MY ETC FILE SYSTEM.               
//*  SYSLOGD NEEDS SCEERUN2 WHICH IS NOT INCLUDED IN THIS SAMPLE                
//*  DUE TO ITS SIZE. IF YOU WANT TO INCLUDE IT YOU MAY NEED TO MOVE            
//*  SOME OF THE SECONDARY VOLUME DATA SETS (TCP/IP, ISHELL, /ETC) TO           
//*  THE PRIMARY VOLUME. YOU MAY ALSO HAVE TO DECREASE THE SIZE OF              
//*  SOME OF THE OPERATIONAL DATA SETS AS NOTED ABOVE AND LEAVE OUT             
//*  SYS1.MACLIB / SYS1.MODGEN AS THEY ARE NOT NEEDED FOR THE RUNNING           
//*  SYSTEM. OTHER OPTIONS ARE TO USE A 3RD VOLUME OR A SINGLE                  
//*  3390-9 (OR BIGGER) - "CHANGE SY2PKB SY2PKA ALL".                           
//*****************************************************************             
//*                                                                             
//*   THE FOLLOWING STEPS COPY THE RUNNING SYSTEM TO SY2PKA AND ......          
//*                                                                             
//*  1.  DEFINE MASTER CATALOG AND SSA                                          
//*  2.  ALLOCATE RACF DSNS                                                     
//*  3.  REPRO COPY RACF DSNS                                                   
//*  4.  DEFINE PAGE DATA SETS, SMF DATA SETS, VIO DSN, AND SMS DSNS            
//*  5.  FORMAT SMF DATASETS                                                    
//*  6.  DSS COPY THE CURRENT/RUNNING SYSTEM TO SY2PKA AND CATLG DSNS           
//*  7.  ZAP RACF DATA SET NAME TABLE                                           
//*  8.  PUT IPL TEXT ON IPL VOLUME USING ICKDSF                                
//*  9.  ALLOCATE NEW LOGREC, BRODCAST, SPOOL AND CKPT DSNS                     
//* 10.  RENAME NEW LOGREC, BRODCAST, SPOOL AND CKPT DSNS                       
//* 11.  CATALOG NEW LOGREC, BRODCAST, SPOOL AND CKPT DSNS                      
//* 12.  INITIALIZE LOGREC                                                      
//* 13.  RENAME ALL OTHER DSNS TO REMOVE SSA                                    
//* 14.  COMPRESS SYS1.PARMLIB ON SY2PKA                                        
//* 15.  UPDATE PARMLIB WITH REQUIRED MEMBERS                                   
//* 16.  UPDATE PROCLIB WITH REQUIRED MEMBERS                                   
//* 17.  UPDATE VTAMLST WITH REQUIRED MEMBERS                                   
//* 18.  UPDATE SISPCLIB WITH REQUIRED MEMBERS                                  
//* 19.  UPDATE SISPPENU WITH REQUIRED MEMBERS                                  
//* 20.  UPDATE TCPPARMS WITH REQUIRED MEMBERS                                  
//* 21.  LIST THE SY2PKA MASTER CATALOG                                         
//* 22.  CLEANUP - REMOVE SSA AND EXPORT DISCONNECT SY2PKA MCAT                 
//*                                                                             
//* AFTER THE FIRST IPL:                                                        
//* 1) REPLY "CONTINUE" to MSG ICH586A FOR PRIMARY AND BACKUP RACF              
//*    DATABASE IF SEEN (NEW IN Z/OS 1.10)                                      
//* 2) REPLY "FORMAT,NOREQ" TO JES2 STARTUP OPTION  (MSG $HASP426)              
//* 3) LOGON TO TSO BY USING "LOGON APPLID(TSO)" FROM VTAM TERMINAL             
//* 4) FROM TSO READY OR ISPF OPT. 6 ISSUE THE SYNC COMMAND TO                  
//*    FORMAT THE BRODCAST DATASET. IF USING UADS, BE SURE TO FIRST             
//*    "ALLOC FI(SYSUADS)" THEN "SYNC BOTH", OTHERWISE "SYNC RACF".             
//*****************************************************************             
//* CHANGES FROM Z/OS 1.3 VERSION FOR Z/OS 1.6:                                 
//* 1. DEL SEUVFLPA AND REPLACE WITH SEUVLPA in COPY / LPALST00                 
//* 2. DEL SEUVFLNK AND REPLACE WITH SEUVLINK in COPY / PROG00                  
//* 3. ADD SEAGALT  to COPY / ALTER / LPALST00                                  
//* 4. ADD SIEALNKE to COPY / ALTER / LNKLST and APF in PROG00                  
//* 5. REMOVE ILM PARMS FROM IEASYS00                                           
//*****************************************************************             
//* CHANGES FROM Z/OS 1.6 VERSION FOR Z/OS 1.8:                                 
//* 1. DEL REFERENCES TO SISPSASC (1.8 CHANGE)                                  
//*  (Add to COPY/ALTER/LNKLST/APF to use this sample for z/OS 1.7)             
//* 2. DEL SHASLINK AND REPLACE WITH SHASLNKE (1.7 CHANGE)                      
//* 3. ADD SIEAMIGE TO COPY/ALTER/LNKLST/APF IN PROG00 (1.7 CHANGE)             
//* 4. REMOVE RDINUM= AND RELADDR= FROM JES2PARM (1.7 CHANGE)                   
//* 5. CHANGE TMP HFS TO A TFS (UNRELATED TO OS LEVEL CHANGE)                   
//* 6. ADDED HLQ.SIOELMOD FOR ZFS (UNRELATED TO OS LEVEL CHANGE)                
//*         ADDED IT TO COPY/ALTER/APF/LNKLST                                   
//* 7. ASSUME UNIX ROOT / ETC ARE ZFS (ALTER STEP CHANGE AND                    
//*             BPXPRM00 CHANGE - UNRELATED TO OS LEVEL CHANGE)                 
//* 8. ADDED TN3270 AS A SEPARATE ASID (REQUIRED A/O Z/OS 1.9 BUT               
//*                                     VALID A/O Z/OS 1.6)                     
//* 9. ADDED UNICODE DSNS SYS1.SCUN*. SYS1.SCUNIMG to LNKLST                    
//*     (REQUIRED A/O Z/OS 1.9 FOR SOME TCP/IP FUNCTIONS - TELNET               
//*        TO UNIX WOULD NOT WORK WITHOUT IT)                                   
//*****************************************************************             
//* CHANGES FROM Z/OS 1.8 VERSION FOR Z/OS 1.9:                                 
//*   (NONE REQUIRED, USE SAMPLE AS IS)                                         
//*****************************************************************             
//* CHANGES FROM Z/OS 1.8 VERSION FOR Z/OS 1.10:                                
//*   MOVED HLQ.SEZALOAD FROM SY2PKB TO SY2PKA DUE TO BIGGER OMVS               
//*   ROOT.  NO OTHER CHANGES WERE MADE BUT TO USE THIS SAMPLE FOR              
//*   Z/OS 1.10 YOU MUST MODIFY THIS JOB TO ADD NEW HLQ.SISFMOD1                
//*   FOR SDSF TO THE COPY/ALTER/LNKLST STEPS.                                  
//*                                                                             
//*   YOU MAY SEE MESSAGE ICH586A AT THE FIRST IPL IF YOUR INPUT                
//*   RACF DATABASE THAT YOU COPIED WAS IN DATA SHARING MODE.                   
//*****************************************************************             
//* CHANGES FROM Z/OS 1.8 VERSION FOR Z/OS 1.11:                                
//*   MAKE THE SAME CHANGES AS FOR Z/OS 1.10 - NO OTHER CHANGES                 
//*****************************************************************             
//* CHANGES FROM Z/OS 1.8 VERSION FOR Z/OS 1.13 (ALREADY INCORPORATED):         
//*  (NOTE THAT YOU PROBABLY NEED A SINGLE 3390-9 FOR THIS BUILD AND            
//*     WILL NEED TO "CHANGE SY2PKB SY2PKA ALL")                                
//*   ADD HLQ.SISFMOD1 TO COPY/ALTER/LNKLST       (NEED A/O 1.10)               
//*   DEL HLQ.HASPINDX FROM COPY/ALTER & ISFPRM00 (NOT NEEDED A/O 1.11)         
//*   DEL HLQ.SCUNIMG  FROM COPY/ALTER/LNKLST     (NOT NEEDED A/O 1.12)         
//*   DEL HLQ.SEUVLINK FROM COPY/ALTER/LNKLST/APF (NOT NEEDED A/O 1.13)         
//*   DEL HLQ.SEUVLPA  FROM COPY/ALTER/LPA        (NOT NEEDED A/O 1.13)         
//*   DEL HLQ.SIOELMOD FROM COPY/ALTER/LNKLST/APF (NOT NEEDED A/O 1.13)         
//*   DEL HLQ.SIOELMOD FROM ZFS PROC (comment)    (NOT NEEDED A/O 1.13)         
//*   MOVED ALL FILES FROM SY2PKB TO SY2PKA EXCEPT THE OMVS ROOT                
//*   INCREASED LOCAL PAGE DATASET FROM 200 CYL TO 300 CYL                      
//*****************************************************************             
//* CHANGES FROM Z/OS 1.13 VERSION FOR Z/OS 2.1  (ALREADY INCORPORATED):        
//*  (NOTE THAT YOU PROBABLY NEED A SINGLE 3390-9 FOR THIS BUILD AND            
//*     WILL NEED TO "CHANGE SY2PKB SY2PKA ALL")                                
//*   DO NOT COPY ALL OF SYS1.SCUNTBL. SIZE INCREASED FROM ABOUT 1000           
//*   TRACKS TO 37500 DUE TO THE THE UNICODE DYNAMIC LOCALE SERVICE.            
//*   INSTEAD IEBCOPY ONLY CUN* PDS MEMBERS.                                    
//*     REMOVE COPY  OF SCUNTBL FROM STEP 6                                     
//*     ADD ALLOCATE OF SCUNTBL TO STEP 9                                       
//*     ADD RENAME   OF SCUNTBL TO STEP 10                                      
//*     ADD CATALOG  OF SCUNTBL TO STEP 11                                      
//*     INSERT NEW IEBCOPY STEP OF SCUNTBL CUN* MEMBERS AS STEP 12              
//*     RENUMBER ALL STEPS AFTER STEP 12.                                       
//*     REMOVE ALTER OF SCUNTBL FROM (RENUMBERED) STEP 14                       
//*   PARMLIB CHANGES:                                                          
//*     IEASYS00 - ADD HZSPROC=NONE                                             
//*     IFAPRD00 - NEW ID - ID(5650-ZOS)                                        
//*     JES2PARM - RMV BRODCAST= FROM OUTDEF, RMV JCLERR= FROM JOBDEF           
//*****************************************************************             
//* CHANGES FROM Z/OS 2.1 VERSION FOR Z/OS 2.2  (ALREADY INCORPORATED):         
//*   REMOVE ISF.SISFMOD1 FROM COPY/ALTER/LNKLST                                
//*   PARMLIB CHANGES:                                                          
//*     CONSOL00 - ADDED HMCS AND SYSCONS                                       
//*     IEASYS00 - ADD SMFLIM=00                                                
//*     SMFPRM00 - REMOVE REFERENCES TO IEFUSI                                  
//*     SMFLIM00 - NEW MEMBER TO CONTROL REGION DEFAULTS                        
//*****************************************************************             
//* CHANGES FROM Z/OS 2.2 VERSION FOR Z/OS 2.3  (ALREADY INCORPORATED):         
//* REMOVE NETVTM.SCNMLPA1 FROM COPY/ALTER/LNKLST and LPALST00                  
//*   PARMLIB CHANGES:                                                          
//*     LPALST00 - Remove NETVTM.SCNMLPA1                                       
//*     IEASYS00 - Add "IZU=00" and "RACF=00"                                   
//*     ISFPRM00 - Add "CONNECT" statement for SDSFAUX                          
//*     IZUPRM00 - New member for z/OSMF (so it doesn't start)                  
//*     IRRPRM00 - New member for RACF Data Set Name table                      
//*     JES2PARM - (THESE ARE NOT REQUIRED CHANGES)                             
//*                CKPTDEF DUPLEX=OFF                                           
//*                SPOOLDEF BUFSIZE=3992,TGSPACE=(MAX=162880),                  
//*                SPOOLDEF - REMOVED TGBPERVL (OBSOLETE)                       
//*                TPDEF    - REMOVED STATEMENT                                 
//*   PROCLIB CHANGES:                                                          
//*     SDSFAUX  - New member added to SYS1.PROCLIB                             
//*   CHANGED STEP:                                                             
//*     ZAP STEP OF RACF DATA SET NAME TABLE (DSNT now in IRRPRM00)             
//*      - STEP IS LEFT IN BUT IS NOW PGM=IEFBR14                               
//*****************************************************************             
//* CHANGES FROM Z/OS 2.3 VERSION FOR Z/OS 2.4  (ALREADY INCORPORATED):         
//*   REMOVE EPH.SEPHTAB FROM COPY/ALTER + ADD OF PARMLIB MEMBER EPHWP00        
//*   ADD SCSFMOD1 TO COPY / ALTER / LNKLST AND APF IN PROG00                   
//*   PARMLIB CHANGES:                                                          
//*     IKJTSO00 - REMOVE IOEDFSXP FROM AUTHPGM                                 
//*     PROG00   - ADD CSF.SCSFMOD1 TO APF/LNKLST                               
//*****************************************************************             
//* CHANGES FROM Z/OS 2.4 VERSION FOR Z/OS 2.5  (ALREADY INCORPORATED):         
//*   All changes are cosmetic due to FDR no longer available.                  
//*                                                                             
//*   1) A single volume is used - SY2PKA.                                      
//*   2) Changed FDRCOPY to ADRDSSU (DFDSS) in step COPY6.                      
//*   3) Removed rename of SYS1.FDR.LINKLIB in RENAME14 step                    
//*   4) Removed SYS1.FDR.LINKLIB from APF and LNKLST in UPARM16 step           
//*****************************************************************             
//*                                                                             
//* ADDITIONAL THINGS YOU MAY WANT TO DO AFTER THE FIRST IPL:                   
//*                                                                             
//*  1) Set up some userids with special non-expiring passwords                 
//*     with no password change interval:                                       
//*                                                                             
//*         PASSWORD USER(userid) NOINTERVAL                                    
//*         ALU userid PASSWORD(newpass) NOEXP                                  
//*                                                                             
//*     ** NOTE: even though RACF will accept NEWPASS as being                  
//*     the same as the userid, you can't logon with it                         
//*                                                                             
//*                                                                             
//*  2) Turn off RACF inactive auto-revoke:  SETR NOINACTIVE                    
//*                                                                             
//*  3) Remove the data sharing profile (auto created in z/OS 1.10              
//*     and above). This will prevent ICH586A that you will see                 
//*     during the first IPL if the RACF database you copied was                
//*     in data sharing mode.                                                   
//*                                                                             
//*        RDELETE GXFACILI IRRPLEX_sysplex-name                                
//*          (sysplex-name is from the RACF database you copied)                
//*                                                                             
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
//*****************************************************************             
//* ALLOCATE RACF DSNS                                                          
//*****************************************************************             
//RACFALC2 EXEC PGM=IEFBR14,REGION=4M,COND=(0,NE)                               
//RACFPRIM DD  DSN=TARGSYS.SYS1.RACF.PRIMARY,                                   
//             DISP=(NEW,CATLG,DELETE),                                         
//             UNIT=SYSALLDA,VOL=SER=SY2PKA,                                    
//             SPACE=(CYL,(300),,CONTIG),                                       
//             STORCLAS=SCNONSMS,  /* CAN'T USE WITH DSORG=PSU */               
//             DCB=(DSORG=PS,RECFM=F,LRECL=4096,BLKSIZE=4096)                   
//*            DCB=(DSORG=PSU,RECFM=F,LRECL=4096,BLKSIZE=4096)                  
//RACFBKUP DD  DSN=TARGSYS.SYS1.RACF.BACKUP,                                    
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
//IN1      DD  DSN=SYS1.RACF.LOCAL.PRIMARY,DISP=SHR                             
//IN2      DD  DSN=SYS1.RACF.LOCAL.BACKUP,DISP=SHR                              
//OUT1     DD  DSN=TARGSYS.SYS1.RACF.PRIMARY,DISP=SHR                           
//OUT2     DD  DSN=TARGSYS.SYS1.RACF.BACKUP,DISP=SHR                            
//SYSIN    DD  *                                                                
  REPRO INFILE(IN1) OUTFILE(OUT1)                                               
  REPRO INFILE(IN2) OUTFILE(OUT2)                                               
/*                                                                              
//*****************************************************************             
//* DEFINE PAGE DATA SETS, SMF DATASETS, AND VIO DSN                            
//*****************************************************************             
//PAGSMFV4  EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                              
//SYSPRINT  DD    SYSOUT=*                                                      
//SYSIN     DD    *                                                             
 DEF PGSPC(NAME(TARGSYS.SYS1.PAGE.VSY2PKA.PLPA) -                               
     STORCLAS(SCNONSMS) -                                                       
     VOL(SY2PKA) CYLINDERS(85))                                                 
 DEF PGSPC(NAME(TARGSYS.SYS1.PAGE.VSY2PKA.COMMON) -                             
     STORCLAS(SCNONSMS) -                                                       
     VOL(SY2PKA) CYLINDERS(25))                                                 
 DEF PGSPC(NAME(TARGSYS.SYS1.PAGE.VSY2PKA.LOCAL) -                              
     STORCLAS(SCNONSMS) -                                                       
     VOL(SY2PKA) CYLINDERS(300))                                                
 DEF CL (CISZ(4096) CYLINDERS(25) -                                             
     STORCLAS(SCNONSMS) -                                                       
     NAME(TARGSYS.SYS1.VSY2PKA.MAN1) NIXD RECSZ(4086,32767)-                    
     REUSE SHR(2) SPANNED SPEED VOL(SY2PKA)) -                                  
     DATA (NAME(TARGSYS.SYS1.VSY2PKA.MAN1.DATA))                                
 DEF CL (CISZ(4096) CYLINDERS(25) -                                             
     STORCLAS(SCNONSMS) -                                                       
     NAME(TARGSYS.SYS1.VSY2PKA.MAN2) NIXD RECSZ(4086,32767)-                    
     REUSE SHR(2) SPANNED SPEED VOL(SY2PKA)) -                                  
     DATA (NAME(TARGSYS.SYS1.VSY2PKA.MAN2.DATA))                                
 DEF CL (BUFSP(20480) CYL(5)             -                                      
     STORCLAS(SCNONSMS) -                                                       
     KEYS(12,8) NAME(TARGSYS.SYS1.VSY2PKA.STGINDEX) -                           
     RECSZ(2041,2041) REUSE VOL(SY2PKA)) -                                      
     DATA(CISZ(2048)) INDEX(CISZ(4096))                                         
 DEF CL (TRK(1 1)       -                                                       
     STORCLAS(SCNONSMS) -                                                       
     LINEAR NAME(TARGSYS.SYS1.SMS.ACDS1) -                                      
     SHR(3,3) REUSE VOL(SY2PKA)) -                                              
     DATA (NAME(TARGSYS.SYS1.SMS.ACDS1.DATA))                                   
 DEF CL (TRK(1 1)       -                                                       
     STORCLAS(SCNONSMS) -                                                       
     LINEAR NAME(TARGSYS.SYS1.SMS.COMMDS1) -                                    
     SHR(3,3) REUSE VOL(SY2PKA)) -                                              
     DATA (NAME(TARGSYS.SYS1.SMS.COMMDS1.DATA))                                 
/*                                                                              
//*****************************************************************             
//* FORMAT SMF DATASETS                                                         
//*****************************************************************             
//SMFFMT5 EXEC  PGM=IFASMFDP,REGION=4M,COND=(0,NE)                              
//SYSPRINT DD  SYSOUT=*                                                         
//MAN1     DD  DSN=TARGSYS.SYS1.VSY2PKA.MAN1,DISP=SHR                           
//MAN2     DD  DSN=TARGSYS.SYS1.VSY2PKA.MAN2,DISP=SHR                           
//SYSIN    DD  *                                                                
   INDD(MAN1,OPTIONS(CLEAR))                                                    
   INDD(MAN2,OPTIONS(CLEAR))                                                    
/*                                                                              
//*****************************************************************             
//* DSS COPY THE CURRENT/RUNNING SYSTEM TO SYS1PK AND CATLG DSNS                
//*****************************************************************             
//COPY6   EXEC  PGM=ADRDSSU,REGION=4M,COND=(0,NE)                               
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
 COPY DS( -                                                                     
  INCLUDE( -                                                                    
      SYS1.IODF53.CLUSTER    -                                                  
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
      ASM.SASMMOD1    -                                                         
      SYS1.PARMLIB    -                                                         
      SYS1.PROCLIB    -                                                         
      SYS1.SAMPLIB    -                                                         
      SYS1.SISTCLIB    -                                                        
      SYS1.SVCLIB    -                                                          
      CEE.SCEERUN    -                                                          
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
      REXX.SEAGALT    -                                                         
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
      SYS1.IBM.PROCLIB    -                                                     
      SYS1.IBM.PARMLIB    -                                                     
      SYSV.SYNCSORT.ZOS.SYNCLPA    -                                            
      SYSV.SYNCSORT.ZOS.SYNCRENT    -                                           
      SYSV.SYNCSORT.ZOS.SYNCAUTH    -                                           
      SYSV.SYNCSORT.ZOS.SYNCLINK    -                                           
      SYS2.LOCAL.LPALIB    -                                                    
      SYS2.LOCAL.LINKLIB    -                                                   
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
      OMVS.ROOT    -                                                            
      OMVS.ETC    -                                                             
         )  -                                                                   
     ) -                                                                        
  RENAMEU( -                                                                    
     (SYS1.IODF53.CLUSTER,   -                                                  
        TARGSYS.SYS1.IODF53.CLUSTER)   -                                        
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
     (ASM.SASMMOD1,   -                                                         
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
     (SYS1.IBM.PROCLIB,   -                                                     
        TARGSYS.SYS1.IBM.PROCLIB)   -                                           
     (SYS1.IBM.PARMLIB,   -                                                     
        TARGSYS.SYS1.IBM.PARMLIB)   -                                           
     (SYSV.SYNCSORT.ZOS.SYNCLPA,   -                                            
        TARGSYS.SYSV.SYNCSORT.ZOS.SYNCLPA)   -                                  
     (SYSV.SYNCSORT.ZOS.SYNCRENT,   -                                           
        TARGSYS.SYSV.SYNCSORT.ZOS.SYNCRENT)   -                                 
     (SYSV.SYNCSORT.ZOS.SYNCAUTH,   -                                           
        TARGSYS.SYSV.SYNCSORT.ZOS.SYNCAUTH)   -                                 
     (SYSV.SYNCSORT.ZOS.SYNCLINK,   -                                           
        TARGSYS.SYSV.SYNCSORT.ZOS.SYNCLINK)   -                                 
     (SYS2.LOCAL.LPALIB,   -                                                    
        TARGSYS.SYS1.VSY2PKA.LPALIB)   -                                        
     (SYS2.LOCAL.LINKLIB,   -                                                   
        TARGSYS.SYS1.VSY2PKA.LINKLIB)   -                                       
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
     (OMVS.ROOT,   -                                                            
        TARGSYS.SYS1.OMVS.ROOT)   -                                             
     (OMVS.ETC,   -                                                             
        TARGSYS.SYS1.OMVS.ETC)   -                                              
     ) -                                                                        
  SHARE TOL(ENQF)                  -                                            
  STORCLAS(SCNONSMS)               -                                            
  OUTDYNAM(SYS1PK,SYSALLDA)        -                                            
  REPLACEU -                                                                    
  CATALOG -                                                                     
  PROCESS(SYS1) SPHERE -                                                        
  WAIT(2,2)  ALLDATA(*)  ALLEXCP                                                
/*                                                                              
/*                                                                              
//*                                                                             
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
//*****************************************************************             
//* ALLOCATE NEW LOGREC, BRODCAST, SPOOL, CKPT AND SCUNTBL DSNS                 
//*****************************************************************             
//ALLOC9   EXEC  PGM=IEFBR14,COND=(0,NE)                                        
//LOGREC   DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.VSY2PKA.LOGREC,                 
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             SPACE=(CYL,1)                                                    
//HASPCKPT DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.VSY2PKA.HASPCKPT,               
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             SPACE=(CYL,5)                                                    
//HASPACE  DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.VSY2PKA.HASPACE,                
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             SPACE=(CYL,250)                                                  
//BRODCAST DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.BRODCAST,                       
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             SPACE=(CYL,5)                                                    
//SCUNTBL  DD  DISP=(NEW,KEEP),DSN=TARGSYS.SYS1.SCUNTBL,                        
//             VOL=SER=SY2PKA,UNIT=SYSALLDA,                                    
//             STORCLAS=SCNONSMS,                                               
//             DSNTYPE=PDS,                                                     
//             DCB=(DSORG=PO,RECFM=FB,LRECL=256,BLKSIZE=0),                     
//             SPACE=(CYL,(75,5,900))                                           
//*****************************************************************             
//* RENAME NEW LOGREC, BRODCAST, SPOOL, CKPT AND SCUNTBL DSNS                   
//*****************************************************************             
//RENAME10 EXEC  PGM=IEHPROGM,REGION=4M,COND=(0,NE)                             
//SYSPRINT DD  SYSOUT=*                                                         
//SY2PKA   DD  DISP=OLD,VOL=SER=SY2PKA,UNIT=SYSALLDA                            
//SYSIN    DD  *                                                                
 RENAME VOL=SYSDA=SY2PKA,DSNAME=TARGSYS.SYS1.VSY2PKA.LOGREC,           X        
               NEWNAME=SYS1.VSY2PKA.LOGREC                                      
 RENAME VOL=SYSDA=SY2PKA,DSNAME=TARGSYS.SYS1.VSY2PKA.HASPCKPT,         X        
               NEWNAME=SYS1.VSY2PKA.HASPCKPT                                    
 RENAME VOL=SYSDA=SY2PKA,DSNAME=TARGSYS.SYS1.VSY2PKA.HASPACE,          X        
               NEWNAME=SYS1.VSY2PKA.HASPACE                                     
 RENAME VOL=SYSDA=SY2PKA,DSNAME=TARGSYS.SYS1.BRODCAST,                 X        
               NEWNAME=SYS1.BRODCAST                                            
 RENAME VOL=SYSALLDA=SY2PKA,DSNAME=TARGSYS.SYS1.SCUNTBL,               X        
               NEWNAME=SYS1.SCUNTBL                                             
/*                                                                              
//*****************************************************************             
//* CATALOG NEW LOGREC, BRODCAST, SPOOL, CKPT AND SCUNTBL DSNS                  
//*****************************************************************             
//CATLG11   EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                              
//SYSPRINT  DD    SYSOUT=*                                                      
//SYSIN     DD    *                                                             
 DEF NVSAM(NAME(SYS1.VSY2PKA.LOGREC)   VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
 DEF NVSAM(NAME(SYS1.VSY2PKA.HASPACE)  VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
 DEF NVSAM(NAME(SYS1.VSY2PKA.HASPCKPT) VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
 DEF NVSAM(NAME(SYS1.BRODCAST)         VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
 DEF NVSAM(NAME(SYS1.SCUNTBL)          VOL(SY2PKA) DEVT(3390)) -                
    CAT(SYS1.MCAT.VSY2PKA)                                                      
/*                                                                              
//*****************************************************************             
//* IEBCOPY DRIVING SYSTEM SCUNTBL CUN* MEMBERS TO TARGET                       
//*****************************************************************             
//CPYCUN12 EXEC PGM=IEBCOPY,REGION=4M,PARM='WORK=4M'                            
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUDUMP DD  SYSOUT=*                                                         
//SYSUT3   DD  UNIT=SYSALLDA,SPACE=(CYL,(1,1))                                  
//SYSUT4   DD  UNIT=SYSALLDA,SPACE=(CYL,(1,1))                                  
//IN1      DD  DSN=SYS1.SCUNTBL,DISP=SHR                                        
//OUT1     DD  DSN=SYS1.SCUNTBL,DISP=SHR,                                       
//             VOL=SER=SY2PKA,UNIT=SYSALLDA                                     
//SYSIN    DD  *                                                                
 COPYGROUP INDD=IN1,OUTDD=OUT1                                                  
 SELECT MEMBER=(CUN*)                                                           
/*                                                                              
//*****************************************************************             
//* INITIALIZE LOGREC                                                           
//*****************************************************************             
//LOGREC13  EXEC  PGM=IFCDIP00,REGION=4M,COND=(0,NE)                            
//SERERDS   DD DISP=SHR,DSN=SYS1.VSY2PKA.LOGREC,                                
//             VOL=SER=SY2PKA,UNIT=SYSALLDA                                     
//*****************************************************************             
//* RENAME ALL OTHER DSNS TO REMOVE SSA                                         
//*****************************************************************             
//RENAME14  EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                              
//SYSPRINT  DD    SYSOUT=*                                                      
//SYSIN     DD    *                                                             
 ALTER TARGSYS.SYS1.RACF.PRIMARY -                                              
   NEWNAME(SYS1.RACF.PRIMARY) -                                                 
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.RACF.BACKUP -                                               
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
 ALTER TARGSYS.SYS1.IODF53.CLUSTER -                                            
   NEWNAME(SYS1.IODF00.CLUSTER) -                                               
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.IODF53 -                                                    
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
  /* ALTER TARGSYS.CEE.SCEERUN2      - */                                       
  /*  NEWNAME(CEE.SCEERUN2)      -     */                                       
  /*    CAT(SYS1.MCAT.VSY2PKA)         */                                       
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
 ALTER TARGSYS.REXX.SEAGALT      -                                              
   NEWNAME(REXX.SEAGALT)      -                                                 
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
 ALTER TARGSYS.SYS1.IBM.PROCLIB -                                               
   NEWNAME(SYS1.IBM.PROCLIB) -                                                  
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.IBM.PARMLIB -                                               
   NEWNAME(SYS1.IBM.PARMLIB) -                                                  
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYSV.SYNCSORT.ZOS.SYNCLPA -                                      
   NEWNAME(SYS1.SYNCSORT.ZOS.SYNCLPA) -                                         
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYSV.SYNCSORT.ZOS.SYNCRENT -                                     
   NEWNAME(SYS1.SYNCSORT.ZOS.SYNCRENT) -                                        
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYSV.SYNCSORT.ZOS.SYNCAUTH -                                     
   NEWNAME(SYS1.SYNCSORT.ZOS.SYNCAUTH) -                                        
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYSV.SYNCSORT.ZOS.SYNCLINK -                                     
   NEWNAME(SYS1.SYNCSORT.ZOS.SYNCLINK) -                                        
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
 ALTER TARGSYS.SYS1.OMVS.ROOT -                                                 
   NEWNAME(SYS1.OMVS.ROOT) -                                                    
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.OMVS.ROOT.DATA -                                            
   NEWNAME(SYS1.OMVS.ROOT.DATA) -                                               
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.OMVS.ETC -                                                  
   NEWNAME(SYS1.OMVS.ETC) -                                                     
     CAT(SYS1.MCAT.VSY2PKA)                                                     
 ALTER TARGSYS.SYS1.OMVS.ETC.DATA -                                             
   NEWNAME(SYS1.OMVS.ETC.DATA) -                                                
     CAT(SYS1.MCAT.VSY2PKA)                                                     
  /* ALTER TARGSYS.SYS1.OMVS.TMP -     */                                       
  /*   NEWNAME(SYS1.OMVS.TMP) -        */                                       
  /*    CAT(SYS1.MCAT.VSY2PKA)         */                                       
/*                                                                              
//*****************************************************************             
//* COMPRESS SYS1.PARMLIB ON SY2PKA                                             
//*****************************************************************             
//COMP15     EXEC PGM=IEBCOPY,REGION=4M,COND=(0,NE)                             
//SYSPRINT DD  SYSOUT=*                                                         
//IN1      DD  DISP=SHR,DSN=SYS1.PARMLIB,                                       
//             UNIT=SYSALLDA,VOL=SER=SY2PKA                                     
//SYSUT3   DD  UNIT=SYSALLDA,SPACE=(CYL,(10,5))                                 
//SYSUT4   DD  UNIT=SYSALLDA,SPACE=(CYL,(10,5))                                 
//SYSIN    DD  *                                                                
  COPY INDD=IN1,OUTDD=IN1,LIST=NO                                               
/*                                                                              
//*****************************************************************             
//* UPDATE PARMLIB WITH REQUIRED MEMBERS                                        
//*****************************************************************             
//UPARM16  EXEC PGM=IEBUPDTE,PARM=NEW,REGION=4M,COND=(0,NE)                     
//SYSUT2   DD  DSN=SYS1.PARMLIB,DISP=SHR,                                       
//             UNIT=SYSALLDA,VOL=SER=SY2PKA                                     
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DATA,DLM=@#                                                      
./ ADD NAME=CLOCK00,LEVEL=00,SOURCE=0,LIST=ALL                                  
OPERATOR NOPROMPT                                                               
TIMEZONE W.05.00.00                                                             
ETRMODE  NO                                                                     
ETRZONE  NO                                                                     
ETRDELTA 10                                                                     
./ ADD NAME=COFVLF00,LEVEL=00,SOURCE=0,LIST=ALL                                 
/*Start of specifications ********************************************/         
/*                                                                   */         
/*  Name: COFVLF00                                                   */         
/*                                                                   */         
/*  Descriptive Name: Virtual Lookaside Facility (VLF)               */         
/*                    default SYS1.PARMLIB member                    */         
/*                                                                   */         
/*  Copyright =                                                      */         
/*        5685-001                                                   */         
/*        This macro is "RESTRICTED MATERIALS OF IBM"                */         
/*        (C) Copyright IBM Corporation 1988                         */         
/*        Licensed materials - Property of IBM                       */         
/*                                                                   */         
/*  Status: JBB3311                                                  */         
/*                                                                   */         
/*  Function:                                                        */         
/*    COFVLF00 specifies the VLF CLASS and Major Name used for       */         
/*    objects stored by Library Lookaside (LLA). The class       @P2C*/         
/*    of objects is named "CSVLLA" with a single major name of   @P1C*/         
/*    "LLA".                                                         */         
/*                                                                   */         
/*  Change activity:                                                 */         
/*    $L0=VLF     HBB3310 871023 PDAM: Virtual Lookaside Facility    */         
/*    $P1=VLF     HBB3310 880209 PDAM: Change LLA class name         */         
/*    $P2=PCG0085 JBB3311 880419 PDAM: Library Lookaside name        */         
/*                                                                   */         
/*End of Specifications **********************************************/         
CLASS NAME(CSVLLA)           /* Class name for Library Lookaside @P2C*/         
      EMAJ(LLA)              /* Major name for Library Lookaside @P2C*/         
                             /*                                      */         
CLASS NAME(IRRGTS)           /* CLASS NAME FOR RACF 1.9 GTS          */         
      EMAJ(GTS)              /* MAJOR NAME OF IRRGTS class           */         
                             /*                                      */         
CLASS NAME(IRRACEE)          /* RACF 1.9.2 ACEE Data in Memory       */         
      EMAJ(ACEE)             /* Major name = ACEE                    */         
                                /*                                   */         
CLASS NAME(IRRGMAP)             /* OPENMVS-RACF GMAP TABLE           */         
      EMAJ(GMAP)                /* MAJOR NAME GMAP                   */         
                                /*                                   */         
CLASS NAME(IRRSMAP)             /* OPENMVS-RACF SMAP TABLE           */         
      EMAJ(SMAP)                /* MAJOR NAME SMAP                   */         
                                /*                                   */         
CLASS NAME(IRRUMAP)             /* OPENMVS-RACF UMAP TABLE           */         
      EMAJ(UMAP)                /* MAJOR NAME UMAP                   */         
                                /*                                   */         
./ ADD NAME=COMMND00,LEVEL=00,SOURCE=0,LIST=ALL                                 
COM='S VLF,SUB=MSTR'                                                            
COM='S EZAZSSI,SUB=MSTR'                                                        
COM='DD ADD,VOL=SY2PKA'                                                         
COM='DD NAME=SYS1.&SYSNAME..DMP&SEQ'                                            
COM='DD ALLOC=ACTIVE'                                                           
COM='S IRRDPTAB'                                                                
COM='SETLOGRC IGNORE'                                                           
COM='S NET'                                                                     
COM='S SDSF'                                                                    
COM='S TSO'                                                                     
COM='S TCPIP'                                                                   
COM='S TN3270'                                                                  
./ ADD NAME=CONSOL00,LEVEL=00,SOURCE=0,LIST=ALL                                 
INIT     AMRF(N) CMDDELIM(;) MLIM(3000) MMS(NO) MONITOR(DSNAME)                 
         RLIM(9999)                                                             
DEFAULT HOLDMODE(NO) RMAX(9999) ROUTCODE(ALL)                                   
HARDCOPY DEVNUM(SYSLOG)                                                         
         ROUTCODE(ALL)                                                          
         CMDLEVEL(CMDS)                                                         
/********************************************************************/          
/* MASTER AND ALTERNATE CONSOLES                                    */          
/********************************************************************/          
CONSOLE DEVNUM(120)  ROUTCODE(ALL)  /* MASTER - 0120 */                         
        ALTERNATE(720)                                                          
        AUTH(MASTER)                                                            
        AREA(NONE)                                                              
        UNIT(3270-X)                                                            
        NAME(MASTER)                                                            
        MSCOPE(*)                                                               
        CMDSYS(*)                                                               
        MONITOR(JOBNAMES-T,SESS-T)                                              
        CON(N) DEL(RD) RNUM(20) RTME(1/4) MFORM(J,T,S)                          
        SEG(20)                                                                 
CONSOLE DEVNUM(720)  ROUTCODE(ALL)  /* ALTERNATE - 0720 */                      
        ALTERNATE(120)                                                          
        AUTH(ALL)                                                               
        AREA(NONE)                                                              
        UNIT(3270-X)                                                            
        NAME(ALT)                                                               
        MSCOPE(*)                                                               
        CMDSYS(*)                                                               
        MONITOR(JOBNAMES-T,SESS-T)                                              
        CON(N) DEL(RD) RNUM(20) RTME(1/4) MFORM(J,T,S)                          
        SEG(20)                                                                 
CONSOLE DEVNUM(HMCS) ROUTCODE(ALL)  /* HMC 3270 CONS */                         
        AUTH(MASTER)                                                            
        AREA(NONE)                                                              
        NAME(HMCCONS)                                                           
        MSCOPE(*)                                                               
        CMDSYS(*)                                                               
        MONITOR(JOBNAMES-T,SESS-T)                                              
        CON(N) DEL(RD) RNUM(20) RTME(1/4) MFORM(J,T,S)                          
        SEG(20)                                                                 
CONSOLE DEVNUM(SYSCONS)                                                         
        NAME(HMCSYSC)                                                           
        ROUTCODE(1,2,10)                                                        
        MSCOPE(*)                                                               
        CMDSYS(*)                                                               
        ALLOWCMD(Y)                                                             
/********************************************************************/          
/* SUBSYS CONSOLES                                                  */          
/********************************************************************/          
CONSOLE DEVNUM(SUBSYSTEM) NAME(SUB1)  AUTH(ALL)                                 
CONSOLE DEVNUM(SUBSYSTEM) NAME(SUB2)  AUTH(ALL)                                 
./ ADD NAME=COUPLE00,LEVEL=00,SOURCE=0,LIST=ALL                                 
 COUPLE SYSPLEX(LOCAL)                                                          
./ ADD NAME=DEVSUP00,LEVEL=00,SOURCE=0,LIST=ALL                                 
COMPACT=YES,                                                                    
VOLNSNS=YES                                                                     
./ ADD NAME=GRSCNF00,LEVEL=00,SOURCE=0,LIST=ALL                                 
    GRSDEF                                                                      
            RESMIL(10)                                                          
            TOLINT(180)                                                         
            ACCELSYS(99)                                                        
         /* RESTART(YES)       - Defaulted */                                   
         /* REJOIN(YES)        - Defaulted */                                   
         /* CTRACE(CTIGRS00)   - Defaulted */                                   
./ ADD NAME=IEACMD00,LEVEL=00,SOURCE=0,LIST=ALL                                 
COM='CHNGDUMP SET,SDUMP=(LSQA,TRT,XESDATA),ADD'                                 
COM='SET SLIP=00'                                                               
COM='SET DAE=01'                                                                
COM='START LLA,SUB=MSTR'                                                        
COM='START BLSJPRMI,SUB=MSTR'                                                   
./ ADD NAME=IEAFIX00,LEVEL=00,SOURCE=0,LIST=ALL                                 
INCLUDE LIBRARY(SYS1.LPALIB)                                                    
MODULES(IEFBR14)                                                                
./ ADD NAME=IEALPA00,LEVEL=00,SOURCE=0,LIST=ALL                                 
INCLUDE  LIBRARY (SYS1.VSY2PKA.LINKLIB)                                         
 MODULES(ICHRDSNT,ICHRFR01,ICHRRCDE,ICHRIN03)                                   
./ ADD NAME=IEAOPT00,LEVEL=00,SOURCE=0,LIST=ALL                                 
CNTCLIST=YES,                                                                   
ERV=5000                                                                        
./ ADD NAME=IEAPAK00,LEVEL=00,SOURCE=0,LIST=ALL                                 
(IEFBR14)                                                                       
./ ADD NAME=IEASVC00,LEVEL=00,SOURCE=0,LIST=ALL                                 
SVCPARM 245,REPLACE,TYPE(3)                   /* SYNCSORT */                    
./ ADD NAME=IEASYM00,LEVEL=00,SOURCE=0,LIST=ALL                                 
SYSDEF   SYSCLONE(00)                 /* SYSTEM CLONE                */         
         SYSNAME(EMRG)                /* SYSTEM NAME                 */         
         SYSPARM(00,L)                /* USE IEASYS00                */         
./ ADD NAME=IEASYS00,LEVEL=00,SOURCE=0,LIST=ALL                                 
CMB=(UNITR,COMM,GRAPH,CHRDR), ADDITIONAL CMB ENTRIES                            
CON=(00,NOJES3),              CONSOLE MEMBER - CONSOL00                         
COUPLE=00,                    COUPLE00                                          
CLOCK=00,                     CLOCK00                                           
CLPA,                         CLPA                                              
CMD=(00,L),                   COMMND00                                          
CSA=(2048,80000),             SIZE IN K FOR CSA                                 
DEVSUP=00,                    DEVSUP00                                          
DIAG=00,                      DIAG00                                            
DUMP=(DASD),                  PLACE SVC DUMPS ON DASD DEVICES                   
FIX=00,                       IEAFIX00                                          
GRS=NONE,                     NO GRS                                            
GRSCNF=00,                    GRSCNF00                                          
HZSPROC=*NONE,                DO NOT START HEALTH CHECKER                       
IZU=00,                       IZUPRM00 FOR Z/OSMF                               
LICENSE=Z/OS,                 LICENSE Z/OS                                      
LNKAUTH=LNKLST,               LNKLST IS APF AUTHORIZED                          
LOGCLS=L,                     SYSOUT L FOR PRINT OF SYSLOG                      
LOGLMT=999999,                MAXIMUM WTL MESSAGES QUEUED                       
LOGREC=SYS1.VSY2PKA.LOGREC,   LOGREC DSN                                        
LPA=(00,L),                   LPALST00                                          
MAXUSER=300,                  MAXIMUM # ADDRESS SPACES                          
MLPA=(00,L),                  IEALPA00                                          
MSTRJCL=(00,L),               MSTJCL00                                          
OMVS=00,                      BPXPRM00                                          
OPI=YES,                      ALLOW OPERATOR OVERRIDE TO IEASYS00               
OPT=00,                       IEAOPT00                                          
PAGE=(SYS1.PAGE.VSY2PKA.PLPA,          PLPA PAGE DATA SET                       
      SYS1.PAGE.VSY2PKA.COMMON,        COMMON PAGE DATA SET                     
      SYS1.PAGE.VSY2PKA.LOCAL,L),      LOCAL PAGE DATA SET                      
PAK=00,                       IEAPAK00                                          
PLEXCFG=XCFLOCAL,             SYSPLEX CONFIG                                    
PROD=00,                      IFAPRD00 SPECIFIED                                
PROG=(00,L),                  PROG00 - APF LIST AND LNKLST                      
RACF=00,                      IRRPRM00 - RACF DATA SET NAME TABLE               
REAL=0,                       V=R SIZE                                          
RSU=00,                       NO RECONFIG STORAGE UNITS                         
RSVNONR=50,                   RESERVED ASIDS FOR NON-REUSABLE                   
RSVSTRT=10,                   RESERVED ASIDS FOR START                          
SMF=00,                       SMFPRM00                                          
SMFLIM=00,                    SMFLIM00                                          
SMS=00,                       IGDSMS00                                          
SQA=(15,200),                 SIZE IN 64K INCREMENTS FOR SQA                    
SSN=(00),                     IEFSSN00                                          
SVC=00,                       IEASVC00                                          
VAL=00,                       VATLST00                                          
VIODSN=SYS1.VSY2PKA.STGINDEX, VIO DSN                                           
VRREGN=0                      DEFAULT REAL-STORAGE REGION SIZE                  
./ ADD NAME=IEFSSN00,LEVEL=00,SOURCE=0,LIST=ALL                                 
SUBSYS SUBNAME(SMS)  INITRTN(IGDSSIIN) INITPARM('ID=00')     /* SMS */          
SUBSYS SUBNAME(JES2)                   /* JES2 AS PRIMARY SUBSYSTEM */          
  PRIMARY(YES) START(YES)                                                       
SUBSYS SUBNAME(RACF) INITRTN(IRRSSI00) INITPARM('RACF,M')                       
SUBSYS SUBNAME(TNF)                    /*     TCPIP SUBSYSTEM       */          
SUBSYS SUBNAME(VMCF)                   /*     TCPIP SUBSYSTEM       */          
./ ADD NAME=IFAPRD00,LEVEL=00,SOURCE=0,LIST=ALL                                 
/* ========== IBM LICENSING TERMS AND CONDITIONS NOTICE ==========  */          
/*                                                                  */          
/* THIS IFAPRD00 MEMBER HAS BEEN CUSTOMIZED BY IBM TO REFLECT THE   */          
/* IBM PRODUCTS AND OPTIONAL INTEGRATED FEATURES SPECIFICALLY       */          
/* ORDERED BY YOU.                                                  */          
/*                                                                  */          
/* THE PRODUCTS AND OPTIONAL FEATURES WHICH WERE ORDERED HAVE BEEN  */          
/* 'ENABLED' IN THIS MEMBER.  THOSE OPTIONAL FEATURES, WHICH WERE   */          
/* NOT ORDERED BUT SHIPPED TO YOU AS A PART OF THE INTEGRATED       */          
/* PRODUCT, HAVE BEEN 'DISABLED'.                                   */          
/*                                                                  */          
/* CHANGES TO THE 'ENABLED' OR 'DISABLED' STATE OF ANY OF THE IBM   */          
/* PRODUCTS AND OPTIONAL FEATURES PROVIDED IN THIS MEMBER MUST BE   */          
/* DONE IN ACCORDANCE WITH IBM'S LICENSING TERMS AND CONDITIONS AS  */          
/* DESCRIBED IN SUCH PRODUCT'S LICENSED PROGRAM SPECIFICATIONS AND  */          
/* THE TERMS AND CONDITIONS FOR z/OS DESCRIBED IN "z/OS             */          
/* LICENSED PROGRAM SPECIFICATIONS" GA32-0888.  SEE "Z/OS MVS       */          
/* PRODUCT MANAGEMENT" GC28-1730 FOR ADDITIONAL INFORMATION.        */          
/*                                                                  */          
/* ================================================================ */          
/*                                                                  */          
/* CHANGE ACTIVITY:                                                 */          
/*   OS/390   : - Dynamic Enablement support was introduced         */          
/*                since OS/390. For detailed information            */          
/*                on using dynamic enablement, please refer         */          
/*                to "Planning for Installation" GC28-1726.         */          
/*   z/OS V1R1: - Changes required:                                 */          
/*                ID(5647-0A1) changed to ID(5694-A01))             */          
/*                NAME(OS/390) changed to NAME('z/OS')              */          
/*                                                                  */          
/*   z/OS V1R2: - Changes required:                                 */          
/*                1. DFSORT became exclusive in z/OS V1R2           */          
/*                2. SOMobjects ADE was no longer an element, it    */          
/*                   has been removed from this list.               */          
/*                                                                  */          
/*   z/OS V1R3: - Changes required:                                 */          
/*                1. Added program number for z/OS.e                */          
/*                   ID(5655-G52) - NAME remains as ('z/OS')        */          
/*                                                                  */          
/*   z/OS V1R5: - Changes required:                                 */          
/*                1. Added DFSMStvs                                 */          
/*                2. Removed C/C++ with DEBUG                       */          
/*                                                                  */          
/*   z/OS V1R6: - Changes required:                                 */          
/*                1. Added DFSMStvs in z/OS.e section               */          
/*                2. Removed C/C++ with DEBUG from z/OS.e section   */          
/*                                                                  */          
/*   z/OS V1R7: - Changes required:                                 */          
/*                1. Added High Level Assembler Toolkit DISASSEM,   */          
/*                   SUPERC, XRF                                    */          
/*                                                                  */          
/*   z/OS V1R8: - Changes required:                                 */          
/*                1. Removed Infoprint Server Transforms since it   */          
/*                   is no longer service supported.                */          
/*                                                                  */          
/*   z/OS V1R9: - Changes required:                                 */          
/*                1. z/OS.e is no longer supported                  */          
/*                                                                  */          
/*   z/OS V1R11:- Changes required:                                 */          
/*               1. removed PSF for OS/390, IBM COBOL OS/390,       */          
/*                  IBM COBOL MVS/VM, IBM PL/I MVS/VM               */          
/*                  since these products are no longer supported    */          
/*                                                                  */          
/*   z/OS V1R12:- Changes none                                      */          
/*                                                                  */          
/*   z/OS V1R13:- Changes none                                      */          
/*                                                                  */          
/*   z/OS V2R1 :- 5650-ZOS                                          */          
/*                                                                  */          
/* ================================================================ */          
   WHEN (HWNAME(*))                                                             
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('z/OS')                                                     
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('TCP/IP BASE')                                              
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('TCP/IP CICS')                                              
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('TCP/IP IMS')                                               
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(DFSMSDSS)                                                   
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(DFSMSHSM)                                                   
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(DFSMSRMM)                                                   
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(DFSMSTVS)                                                   
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(GDDM-REXX)                                                  
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(JES3)                                                       
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('BOOKMGR BUILD')                                            
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(BDTFTF)                                                     
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(BDTNJE)                                                     
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('C/C++')                                                    
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(DFSORT)                                                     
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(GDDM-PGF)                                                   
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('TOOLKIT DEBUGGER')                                         
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('TOOLKIT DISASSEM')                                         
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('TOOLKIT SUPERC')                                           
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('TOOLKIT XREF')                                             
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('SECURITY SERVER')                                          
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(RMF)                                                        
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(SDSF)                                                       
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME(zEDC)                                                       
        STATE(DISABLED)                                                         
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('HCM')                                                      
        STATE(ENABLED)                                                          
PRODUCT OWNER('IBM CORP')                                                       
        NAME('z/OS')                                                            
        ID(5650-ZOS)                                                            
        VERSION(*) RELEASE(*) MOD(*)                                            
        FEATURENAME('INFOPRINT SERVER')                                         
        STATE(DISABLED)                                                         
./ ADD NAME=IKJTSO00,LEVEL=00,SOURCE=0,LIST=ALL                                 
AUTHCMD NAMES(          /* AUTHORIZED COMMANDS      */      +                   
   AD       ADDSD       /* RACF COMMANDS            */ +                        
   AG       ADDGROUP    /*                          */ +                        
   AU       ADDUSER     /*                          */ +                        
   ALG      ALTGROUP    /*                          */ +                        
   ALD      ALTDSD      /*                          */ +                        
   ALU      ALTUSER     /*                          */ +                        
   BLKUPD               /*                          */ +                        
   CO       CONNECT     /*                          */ +                        
   DD       DELDSD      /*                          */ +                        
   DG       DELGROUP    /*                          */ +                        
   DU       DELUSER     /*                          */ +                        
   LD       LISTDSD     /*                          */ +                        
   LG       LISTGRP     /*                          */ +                        
   LU       LISTUSER    /*                          */ +                        
   RACDCERT             /*                          */ +                        
   RALT     RALTER      /*                          */ +                        
   RACLINK              /*                          */ +                        
   RDEF     RDEFINE     /*                          */ +                        
   RDEL     RDELETE     /*                          */ +                        
   RE       REMOVE      /*                          */ +                        
   RL       RLIST       /*                          */ +                        
   RVARY                /*                          */ +                        
   PASSWORD PW          /*                          */ +                        
   PE       PERMIT      /*                          */ +                        
   SETR     SETROPTS    /*                          */ +                        
   SR       SEARCH      /*                          */ +                        
   IRRDPI00             /*                          */ +                        
   MVPXDISP             /* TCPIP                    */ +                        
   TRACERTE             /* TCPIP                    */ +                        
   PING                 /* TCPIP                    */ +                        
   NETSTAT              /* TCPIP                    */ +                        
   RECEIVE              /* TSO COMMANDS             */ +                        
   TRANSMIT XMIT        /*                          */ +                        
   CONSPROF           /* ICSF COMMAND             */ +                          
   RACONVRT CONSPROF    /*                          */ +                        
   LISTB    LISTBC      /*                          */ +                        
   LISTD    LISTDS      /*                          */ +                        
   SE       SEND        /*                          */ +                        
   SYNC                 /*                          */ +                        
   TESTAUTH TESTA       /*                          */ +                        
   PARMLIB  IKJPRMLB    /*                          */ +                        
   IEBCOPY              /*                          */ +                        
   BINDDATA BDATA       /*  DMSMS COMMANDS          */ +                        
   LISTDATA LDATA       /*                          */ +                        
   SETCACHE SETC        /*                          */)                         
                        /*                          */                          
AUTHPGM NAMES(          /* AUTHORIZED PROGRAMS      */      +                   
   ICHUT100             /*                          */ +                        
   ICHUT200             /*                          */ +                        
   ICHUT400             /*                          */ +                        
   ICHDSM00             /*                          */ +                        
   IRRDSC00             /*                          */ +                        
   IRRUT100             /*                          */ +                        
   IRRUT200             /*                          */ +                        
   IRRUT400             /*                          */ +                        
   IRRDPI00             /*                          */ +                        
   GIMSMP               /* SMPE                     */ +                        
   IOEGRWAG           /* DFS                      */ +                          
   IOENEWAG           /* DFS                      */ +                          
   IOESALVG           /* DFS                      */ +                          
   IOEBAK             /* DFS                      */ +                          
   IOEBOS             /* DFS                      */ +                          
   IOECM              /* DFS                      */ +                          
   IOEDCEER           /* DFS                      */ +                          
   IOEDFSXP           /* DFS                      */ +                          
   IOEFTS             /* DFS                      */ +                          
   IOEMAPID           /* DFS                      */ +                          
   IOESCOUT           /* DFS                      */ +                          
   IOEUDBG            /* DFS                      */ +                          
   IOEAGFMT           /* DFS                      */ +                          
   IOEAGSLV           /* DFS                      */ +                          
   IOEZADM            /* DFS                      */ +                          
   ICADCT             /* FIREWALL                 */ +                          
   ICADDCT            /* FIREWALL                 */ +                          
   ICADCFGS           /* FIREWALL                 */ +                          
   ICADPFTP           /* FIREWALL                 */ +                          
   ICADFTPD           /* FIREWALL                 */ +                          
   ICADSLOG           /* FIREWALL                 */ +                          
   ICADSOCK           /* FIREWALL                 */ +                          
   ICADSOXD           /* FIREWALL                 */ +                          
   ICADSTAK           /* FIREWALL                 */ +                          
   ICADIKED           /* FIREWALL                 */ +                          
   IEBCOPY            /*                          */ +                          
   MVPXDISP           /* TCPIP                    */ +                          
   CSFDAUTH           /* ICSF PGM                 */)                           
                        /*                          */                          
NOTBKGND NAMES(         /* COMMANDS WHICH MAY NOT BE */  +                      
                        /* ISSUED IN THE BACKGROUND  */  +                      
   OPER     OPERATOR    /*                           */ +                       
   TERM     TERMINAL    /*                           */)                        
                        /*                           */                         
AUTHTSF NAMES(          /* PROGRAMS TO BE AUTHORIZED */  +                      
                        /* WHEN CALLED THROUGH THE   */  +                      
                        /* TSO SERVICE FACILITY.     */  +                      
   GIMSMP               /* SMPE                     */ +                        
   ICQASLI0             /*                          */ +                        
   IKJEFF76             /*                          */ +                        
   IEBCOPY              /*                          */ +                        
   CSFDAUTH             /* ICSF SF                  */)                         
                        /*                           */                         
SEND                    /* SEND COMMAND DEFAULTS     */  +                      
   OPERSEND(ON)         /*                           */ +                       
   USERSEND(ON)         /*                           */ +                       
   SAVE(ON)             /*                           */ +                       
   CHKBROD(OFF)         /*                           */ +                       
   LOGNAME(SYS1.BRODCAST)  /*                        */                         
ALLOCATE                /* ALLOCATE COMMAND DEFAULT  */  +                      
   DEFAULT(OLD)         /*                           */                         
TRANSREC                         /* ALLOCATE COMMAND DEFAULT  */  +             
   NODESMF((*,*))       /*ALLOCATE COMMAND DEFAULT*/ +                          
   CIPHER(YES)          /*                           */ +                       
   SPOOLCL(B)           /*                           */ +                       
   OUTWARN(50000,15000) /*                           */ +                       
   OUTLIM(5000000)      /*                           */ +                       
   VIO(SYSALLDA)        /*                           */ +                       
   LOGSEL(LOG)          /*                           */ +                       
   LOGNAME(MISC)        /*                           */ +                       
   DAPREFIX(TUPREFIX)   /*                           */ +                       
   USRCTL(NAMES.TEXT)   /*                           */ +                       
   SYSOUT(*)            /*                           */                         
./ ADD NAME=ISFPRM00,LEVEL=00,SOURCE=0,LIST=ALL                                 
    /***********************/                                                   
    /*  SDSFAUX PARMS      */                                                   
    /***********************/                                                   
 CONNECT AUXSAF(NOFAILRC4)                                                      
                                                                                
    /*******************************************/                               
    /* OPTIONS Statement - Global SDSF Options */                               
    /*******************************************/                               
                                                                                
 OPTIONS ATHOPEN(YES),       /* Use authorized open for datasets    */          
   DCHAR('?'),               /* Command query character             */          
   DSI(NO),                  /* Bypass ENQ for dynamic allocation   */          
   FINDLIM(5000),            /* Maximum lines to search for FIND    */          
   IDBLKS(4096),             /* HASPINDX blocksize                  */          
   JESDATA(VERSIONS),        /* Use checkpoint versioning           */          
   LINECNT(55),              /* Print lines per page                */          
   LOGLIM(0),                /* OPERLOG search limit in hours       */          
   MENUS(ISF.SISFPLIB),      /* PANELS DATASET NAME FOR TSO         */          
   NIDBUF(5),                /* Number of haspindx buffers          */          
   NSPBUF(5),                /* Number of spool buffers             */          
   SCHARS('*%'),             /* Generic and placeholder characters  */          
   SCRSIZE(1920),            /* Maximum screen size                 */          
   SYSOUT(A),                /* Default print sysout class          */          
   TIMEOUT(5),               /* Communications timeout in seconds   */          
   TRACE(C000),              /* Default trace mask                  */          
   TRCLASS(A),               /* Default trace sysout class          */          
   UNALLOC(NO)               /* Do not free dynalloc data sets      */          
                                                                                
                                                                                
    /***************************************/                                   
    /* GROUP ISFSPROG - System Programmers */                                   
    /***************************************/                                   
                                                                                
 GROUP NAME(ISFSPROG),       /* Group name                          */          
 TSOAUTH(JCL),               /* USER MUST HAVE JCL, OPER, ACCT      */          
 ACTION(ALL),                /* All route codes displayed           */          
 ACTIONBAR(YES),             /* Display the action bar on panels    */          
 APPC(ON),                   /* Include APPC sysout                 */          
 AUPDT(2),                   /* Minimum auto update interval        */          
 AUTH(LOG,I,O,H,DA,DEST,PREF,     /* Authorized functions           */          
      SYSID,ABEND,ACTION,INPUT,                                                 
      FINDLIM,ST,INIT,PR,TRACE,                                                 
      ULOG,MAS,SYSNAME,LI,SO,NO,RSYS,                                           
      PUN,RDR,JC,SE,RES,SR,SP,                                                  
      ENC,PS),                                                                  
 CMDAUTH(ALL),               /* Commands allowed for all jobs       */          
 CMDLEV(7),                  /* Authorized command level            */          
 CONFIRM(ON),                /* Enable cancel confirmation          */          
 CTITLE(ASIS),               /* Allow mixed case column titles      */          
 CURSOR(ON),                 /* Leave cursor on last row processed  */          
 DADFLT(IN,OUT,TRANS,STC,TSU,JOB),  /* Default rows shown on DA     */          
 DATE(MMDDYYYY),             /* Default date format                 */          
 DATESEP('/'),               /* Default datesep format              */          
 DISPLAY(OFF),               /* Do not display current values       */          
 DSPAUTH(ALL),               /* Browse allowed for all jobs         */          
 GPLEN(2),                   /* Group prefix length                 */          
 ILOGCOL(1),                 /* Initial display column in log       */          
 ISYS(LOCAL),                /* Initial system default              */          
 LANG(ENGLISH),              /* Default language                    */          
 LOGOPT(OPERACT),            /* Default log option                  */          
 OWNER(NONE),                /* Default owner                       */          
 RSYS(NONE),                 /* Initial system default for wtors    */          
 UPCTAB(TRTAB2),             /* Upper case translate table name     */          
 VALTAB(TRTAB),              /* Valid character translate table     */          
 VIO(SYSALLDA)               /* Unit name for page mode output      */          
                                                                                
    /********************************/                                          
    /* Define default SDSF Codepage */                                          
    /********************************/                                          
 TRTAB CODPAG(SDSF) VALTAB(TRTAB) UPCTAB(TRTAB2)                                
./ ADD NAME=IRRPRM00,LEVEL=00,SOURCE=0,LIST=ALL                                 
DATABASE_OPTIONS                                                                
SYSPLEX(NOCOMMUNICATIONS)                                                       
DATASETNAMETABLE                                                                
  ENTRY                                                                         
    PRIMARYDSN('SYS1.RACF.PRIMARY')                                             
    BACKUPDSN('SYS1.RACF.BACKUP')                                               
    UPDATEBACKUP(NOSTATS)                                                       
    BUFFERS(255)                                                                
./ ADD NAME=IZUPRM00,LEVEL=00,SOURCE=0,LIST=ALL                                 
AUTOSTART(CONNECT)                                                              
./ ADD NAME=JES2PARM,LEVEL=00,SOURCE=0,LIST=ALL                                 
/*****PROPRIETARY-STATEMENT*******************************************/         
/*                                                                   */         
/*     LICENSED MATERIALS-PROPERTY OF IBM                            */         
/*     THIS SAMPLE IS "RESTRICTED MATERIALS OF IBM"                  */         
/*                                                                   */         
/*                                                                   */         
/*****END-OF-PROPRIETARY-STATEMENT************************************/         
/*********************************************************************/         
/*                                                                   */         
/* SYNTAX RULES for JES2 Initialization Statements:                  */         
/*                                                                   */         
/*   - Statements may be coded free-form in Columns 1 through 71     */         
/*   - Column 72 may be used for a Continuation Character, but is    */         
/*     NOT Required.  A trailing comma indicates continuation.       */         
/*   - Comments and Blanks may appear anywhere before, after, or     */         
/*     in-between statements, parameters, and delimiters.            */         
/*   - Comments are NOT allowed within a range.                      */         
/*   - Comments must be bounded by the slash-asterisk,               */         
/*     asterisk-slash type delimiters.                               */         
/*   - Statements must have at least one parameter coded on the      */         
/*     same line as the statement name.                              */         
/*                                                                   */         
/*********************************************************************/         
/*                                                                   */         
/* NOTES on the Format of this Member:                               */         
/*                                                                   */         
/*   - The Order of Statements is Alphabetical within the following  */         
/*     categories:                                                   */         
/*     - ALL Initialization Statements, showing new statements,      */         
/*       new and changed operands, etc.                              */         
/*     - An abbreviated list of statements and operands ADDED        */         
/*       in the JES2 SP 4.1.0 and later releases                     */         
/*     - An abbreviated list of statements and operands CHANGED      */         
/*       in the JES2 SP 4.1.0 and later releases                     */         
/*     - An abbreviated list of statements and operands DELETED      */         
/*       in SP 2.2.0 JES2 or later releases.                         */         
/*     - An abbreviated list of statement operands which cannot      */         
/*       be changed without a COLD start.                            */         
/*                                                                   */         
/* COLUMN layouts of the following statements are as follows:        */         
/*                                                                              
STMT     PARAMETER=DEFAULT,       COMMENTS                   CHG-CODE*/         
/*                                                                   */         
/*    1- 8 - Statement Name                                          */         
/*   10-29 - Parameters set to default values                        */         
/*            ›› - Indicates there is no default, or the default is  */         
/*                   based on other parameters.                      */         
/*            @@ - Indicates the default should not be taken blindly.*/         
/*   30-60 - Comments                                                */         
/*   62-69 - How the Parameter can be changed.  One or more of the   */         
/*           following flags will appear in the change code list.    */         
/*           They are listed in order of flexibility and power, but  */         
/*           these capabilities are not hierarchical.  For example,  */         
/*           some parameters can be changed only by cold starts      */         
/*           and commands.                                           */         
/*                                                                   */         
/*            a  - can be added by $ADD                              */         
/*            o  - can be altered by operand $T                      */         
/*            r  - can be removed by $DEL                            */         
/*            h  - can be altered/added by a hot start               */         
/*                 (if no H, the parm is ignored during hot start)   */         
/*            w  - can be altered/added by JES2 Warm or Quick Start  */         
/*            n  - can be altered/added by a JES2                    */         
/*                 All Member Warm Start                             */         
/*            c  - can be altered/added by JES2 Cold Start           */         
/*                                                                   */         
/*********************************************************************/         
/*********************************************************************/         
/*                                                                   */         
/*  NOTE: Changing ANY of the following parameters will prevent a    */         
/*        JES2 Warmstart; they can ONLY be changed on a COLDSTART    */         
/*                                                                   */         
/*********************************************************************/         
/*                                                                   */         
/*  CKPTDEF   DSNAME=                                                */         
/*  JOBDEF    JOBNUM=                                                */         
/*  NJEDEF    OWNNODE=                                               */         
/*  OUTDEF    JOENUM=                                                */         
/*  SPOOLDEF  BUFSIZE=, DSNAME=, RECINCR=, SPOOLNUM=, TGNUM=,        */         
/*            TRKCELL=, VOLUME=                                      */         
/*  TPDEF     RMTNUM=                                                */         
/*                                                                   */         
/*********************************************************************/         
/*                           *---------------------------------------*          
                             *    Checkpoint Parameters              *          
                             *---------------------------------------*          
                                                                     */         
CKPTDEF  CKPT1=(DSNAME=SYS1.VSY2PKA.HASPCKPT,                                   
                             /* NAME FOR CKPT &DSNPRFX           onc*/          
         VOLSER=SY2PKA,     /* SYS1.HASPCKPT ONC*/                              
         INUSE=YES),         /*                                   onc*/         
         CKPT2=(DSNAME=SYS1.VSY2PKA.HASPCKP2,                                   
                             /* NAME FOR CKPT &DSNPRFX           onc*/          
         VOLSER=SY2PKA,     /* SYS1.HASPCKP2 ONC*/                              
         INUSE=NO),          /*                                   ONC*/         
         DUPLEX=OFF,         /* NO DUPLEXING        &CHKPT2       nc*/          
         LOGSIZE=2,          /*                                    nc*/         
         MODE=DUPLEX,        /* NO DUPLEXING        &CHKPT2    ohwnc*/          
         VERSIONS=(NUMBER=0, /* Number of checkpoint versions   ohwnc*/         
                             /*   JES2 will maintain-0 indicates     */         
                             /*   JES2 will determine the maximum    */         
                             /*   number of versions to maintain.    */         
                             /*     (added SP410)                    */         
                             /*       Related to APPLCOPY            */         
            WARN=80),        /* Threshold percentage at which   ohwnc*/         
                             /*   operator is to be notified.        */         
                             /*     (added SP410)                    */         
         VOLATILE=(ONECKPT=WTOR,                                                
                             /* Specifies JES2 should issue WTOR to  */         
                             /* determine action if one CKPT is on a */         
                             /* volatile coupling facility           */         
                             /*     (added in SP510)            ohwnc*/         
                ALLCKPT=WTOR)                                                   
                             /* Specifies JES2 should issue WTOR to  */         
                             /* determine action if all CKPTs are on */         
                             /* volatile coupling facilities         */         
                             /*     (added in SP510)            ohwnc*/         
/*                                                                   */         
/*********************************************************************/         
/*                            *--------------------------------------*          
                              |    Checkpoint Space Definitions      |          
                              *--------------------------------------*          
                                                                     */         
CKPTSPACE BERTNUM=2000,      /* Number of BERTs                    oc*/         
                             /*     (added in OS/390 R4)             */         
          BERTWARN=80        /* $HASP050 threshold for BERTs    ohwnc*/         
                             /*     (added in OS/390 R4)             */         
/*                                                                   */         
/*********************************************************************/         
/*                           *---------------------------------------*          
                             *    Compaction Table Definitions       *          
                             *---------------------------------------*          
                                                                     */         
COMPACT  NAME=JESDATA,       /* NAME OF COMPACTION TABLE         hwnc*/         
         NUMBER=10,          /* Compaction Table Number          hwnc*/         
                             /* Table Definition                 hwnc*/         
         CHARS=(16,          /* - Number of Master Characters    hwnc*/         
          F1,F2,F3,F4,F5,F6, /* - MASTER CHARACTERS              hwnc*/         
          F7,F8,F9,A,E,I,D6, /* - MASTER CHARACTERS              hwnc*/         
          E4,40,X)           /* - MASTER CHARACTERS              hwnc*/         
                             /*                                      */         
/*                                                                   */         
/*********************************************************************/         
/*                            *--------------------------------------*          
                              *    CONSOLE PARAMETERS                *          
                              *--------------------------------------*          
                                                                     */         
CONDEF   AUTOCMD=20,         /* Number of Auto Cmds              hwnc*/         
         BUFNUM=9999,        /* Number of CMBs                  ohwnc*/         
         BUFWARN=80,         /* Warning Threshold %             ohwnc*/         
         CMDNUM=999,         /* Maximum number of CMBs for JES2  ownc*/         
                             /* commands from common storage     ownc*/         
                             /*     (added in SP510)             ownc*/         
         CONCHAR=$,          /* Console Cmd Character           ohwnc*/         
         DISPLEN=64,         /* $SCAN Cmd/init Display Length   ohwnc*/         
         DISPMAX=100,        /* $SCAN Cmd/init Max Lines        ohwnc*/         
         MASMSG=200,         /* Number of Queued Msgs           ohwnc*/         
         RDIRAREA=Z,         /* Default console out-of-line     ohwnc*/         
                             /*   area  (added SP410)           ohwnc*/         
         RDRCHAR=$,          /* Reader Cmd Character            ohwnc*/         
         SCOPE=SYSTEM        /* Specifies scope of command        wnc*/         
                             /*   prefix  (added SP410)              */         
/*                                                                   */         
/*********************************************************************/         
/*                            *--------------------------------------*          
                              *    DEBUG PARAMETERS                  *          
                              *      (revised by OW05639)            *          
                              *    Do not use unless necessary       *          
                              *--------------------------------------*          
                                                                     */         
DEBUG    CKPT=NO,            /* Verify integrity of checkpoint  ohwnc*/         
         MISC=NO,            /* Count certain JES2 events       ohwnc*/         
         STORAGE=NO,         /* Verify GETWORKed areas          ohwnc*/         
         SYMREC=NO,          /* Issue $WTO with SYMREC          ohwnc*/         
                             /*     (added OS110)                    */         
         VERSION=NO          /* Verify integrity of ckpt vers   ohwnc*/         
                             /*                                      */         
/*                                                                   */         
/*********************************************************************/         
/*                           *---------------------------------------*          
                             *   Default Estimated Sysout Bytes/Job  *          
                             *---------------------------------------*          
                                                                     */         
ESTBYTE  NUM=99999,          /* 99999000 Bytes for 1st Message  ohwnc*/         
         INT=99999,          /*  then 99999000 Byte Intervals   ohwnc*/         
         OPT=0               /* Allow Jobs to Continue          ohwnc*/         
                             /*                                      */         
/*                           *---------------------------------------*          
                             *   Default Estimated Execution Time    *          
                             *---------------------------------------*          
                                                                     */         
ESTIME   NUM=2,              /* 2 minutes for 1st Message       ohwnc*/         
         INT=1,              /*  then at 1 minute Intervals     ohwnc*/         
         OPT=NO              /* No HASP308 message              ohwnc*/         
                             /*                                      */         
/*                           *---------------------------------------*          
                             *   Default Estimated Sysout Lines/Job  *          
                             *---------------------------------------*          
                                                                     */         
ESTLNCT  NUM=12,             /*12000 LINES FOR 1ST MESSAGE      ohwnc*/         
         INT=6000,           /*  THEN AT 6000 LINE INTERVALS    ohwnc*/         
         OPT=0               /* Allow Jobs to Continue          ohwnc*/         
                             /*                                      */         
/*                           *---------------------------------------*          
                             *   Default Estimated Sysout Pages/Job  *          
                             *---------------------------------------*          
                                                                     */         
ESTPAGE  NUM=40,             /* 40 PAGES FOR 1ST MESSAGE        ohwnc*/         
         INT=10,             /*  THEN AT 10 PAGE INTERVALS      ohwnc*/         
         OPT=0               /* Allow Jobs to Continue          ohwnc*/         
                             /*                                      */         
/*                           *---------------------------------------*          
                             *   Default Estimated Sysout Cards/Job  *          
                             *---------------------------------------*          
                                                                     */         
ESTPUN   NUM=100,            /* 100 Cards for 1st Message       ohwnc*/         
         INT=2000,           /*  then at 2000 Card Intervals    ohwnc*/         
         OPT=0               /* Allow Jobs to Continue          ohwnc*/         
                             /*                                      */         
/*                           *---------------------------------------*          
                             *   Functional Subsystem Definition     *          
                             *---------------------------------------*          
                                                                     */         
FSS(PRINTOFF)                /* FSS TOKEN FOR PRINTERNN FSS=    aownc*/         
/*       PROC=PRINT,            FSS PROCEDURE TO START FSA       ownc*/         
/*       HASPFSSM=HASPFSSM      FSS Load Module FSS Support      ownc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    Logical Initiator Definitions     *          
                              *--------------------------------------*          
                                                                     */         
INITDEF  PARTNUM=12          /* NUMBER OF INITIATORS    &MAXPART wnc*/          
                             /*                                      */         
                             /*--------------------------------------*/         
                             /*    Logical Initiators                */         
                             /*--------------------------------------*/         
INIT(1)  NAME=1,             /* INITIATOR NAME                    wnc*/         
         CLASS=A,            /* INITIAL JOB CLASSES              ownc*/         
         START               /* Start Automatically               wnc*/         
                             /*                                      */         
INIT(2)  NAME=2,             /* INITIATOR NAME                    wnc*/         
         CLASS=AB,           /* INITIAL JOB CLASSES              ownc*/         
         START=YES           /* Start Automatically               wnc*/         
                             /*                                      */         
INIT(3)  NAME=3,             /* INITIATOR NAME                    wnc*/         
         CLASS=ABC,          /* INITIAL JOB CLASSES              ownc*/         
         START=YES           /* Start Automatically               wnc*/         
                             /*                                      */         
INIT(4)  NAME=4,             /* INITIATOR NAME                    wnc*/         
         CLASS=ABCDE,        /* INITIAL JOB CLASSES              ownc*/         
         START=YES           /* Start Automatically               wnc*/         
                             /*                                      */         
INIT(5)  NAME=5,             /* INITIATOR NAME                    wnc*/         
         CLASS=ABCD,         /* INITIAL JOB CLASSES              ownc*/         
         START=NO            /*                                      */         
                             /*                                      */         
INIT(6)  NAME=6,             /* INITIATOR NAME                    wnc*/         
         CLASS=ABCD,         /* INITIAL JOB CLASSES              ownc*/         
         START=NO            /*                                      */         
                             /*                                      */         
INIT(7)  NAME=7,             /* INITIATOR NAME                    wnc*/         
         CLASS=ABCD,         /* INITIAL JOB CLASSES              ownc*/         
         START=NO            /*                                      */         
                             /*                                      */         
INIT(8)  NAME=8,             /* INITIATOR NAME                    wnc*/         
         CLASS=ABCD,         /* INITIAL JOB CLASSES              ownc*/         
         START=NO            /*                                      */         
                             /*                                      */         
INIT(9)  NAME=9,             /* INITIATOR NAME                    wnc*/         
         CLASS=ABCD,         /* INITIAL JOB CLASSES              ownc*/         
         START=NO            /*                                      */         
                             /*                                      */         
INIT(10) NAME=10,            /* INITIATOR NAME                    wnc*/         
         CLASS=ABCD,         /* INITIAL JOB CLASSES              ownc*/         
         START=NO            /*                                      */         
                             /*                                      */         
INIT(11) NAME=11,            /* INITIATOR NAME                    wnc*/         
         CLASS=ABCD,         /* INITIAL JOB CLASSES              ownc*/         
         START=NO            /*                                      */         
                             /*                                      */         
INIT(12) NAME=12,            /* INITIATOR NAME                    wnc*/         
         CLASS=ABCD,         /* INITIAL JOB CLASSES              ownc*/         
         START=NO            /*                                      */         
/*                            *--------------------------------------*          
                              *    Internal Readers                  *          
                              *--------------------------------------*          
                                                                     */         
INTRDR   AUTH=(JOB=YES,      /* Allow Job cmds                   ownc*/         
               DEVICE=NO,    /* Allow Device Cmds                ownc*/         
               SYSTEM=YES),  /* Allow System Cmds                ownc*/         
                             /*     (pre-SP420 AUTH=0 for all 3      */         
                             /*      subparameters)                  */         
         BATCH=YES,          /* Allow batch jobs to use           wnc*/         
                             /*     internal readers                 */         
                             /*     (added SP420)                    */         
         CLASS=A,            /* Default Job Class                ownc*/         
         HOLD=NO,            /* Don't Hold Jobs Read             ownc*/         
         HONORLIM=NO,        /* Do output excession for INTRDR   ownc*/         
                             /*     (added by OW06743)               */         
         PRTYINC=0,          /* Don't Prty Age Jobs               wnc*/         
         PRTYLIM=15,         /* Limit Job Prty to 15              wnc*/         
         TRACE=NO            /* Allow Tracing                    ownc*/         
                             /*    (added SP420)                     */         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    Job Class Characteristics         *          
                              *--------------------------------------*          
                                                                     */         
JOBCLASS(*) AUTH=ALL,        /* All commnds accepted             hwnc*/         
         ACCT=NO,            /* Account   not required           hwnc*/         
         BLP=NO,             /* BLP ignored                      hwnc*/         
         COMMAND=VERIFY,     /* verify commands                  hwnc*/         
         COPY=NO,            /* not TYPRUN=COPY                  hwnc*/         
         HOLD=NO,            /* not TYPRUN=HOLD                  hwnc*/         
         IEFUJP=YES,         /* take SMF Job Purge Exit          hwnc*/         
         IEFUSO=YES,         /* take SYSOUT Excess Exit          hwnc*/         
         JOURNAL=YES,        /* Journal this Job Class           hwnc*/         
         LOG=YES,            /* Print JES2 JOB LOG               hwnc*/         
         MSGLEVEL=(1,1),     /* msg level                        hwnc*/         
         OUTDISP=(HOLD,HOLD),  /* Disposition of System Output   hwnc*/         
                             /*   normal termination and abnormal    */         
                             /*   termination  (added SP410)         */         
                             /*   (pre-SP410=CONDPURG)               */         
         OUTPUT=YES,         /* Produce Output for Job           hwnc*/         
         PERFORM=000,        /* SRM Performance Group 0          hwnc*/         
         PGMRNAME=NO,        /* Pgmrname not required            hwnc*/         
         PROCLIB=00,         /* Use //PROC00 DD                  hwnc*/         
         QHELD=NO,           /* Hold jobs prior to execution    ohwnc*/         
                             /*     (added by APAR OW06439)          */         
         RESTART=NO,         /* No Requeue (XEQ) on IPL          hwnc*/         
         SCAN=NO,            /* Not TYPRUN=SCAN                  hwnc*/         
         TIME=(1440,0),      /* Job Step Time                    hwnc*/         
                             /*   (format changed SP410)             */         
         TYPE6=YES,          /* Produce SMF 6 Records            hwnc*/         
         TYPE26=YES          /* Produce SMF 26 Records           hwnc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    Job Characteristics               *          
                              *--------------------------------------*          
                                                                     */         
JOBDEF   ACCTFLD=OPTIONAL,  /* Acct'g Field Optional  &RJOBOPT ohwnc*/          
         DUPL_JOB=DELAY,    /* Don't allow jobs with duplicate       */         
                            /*  names to execute concurrently     onc*/         
                            /*     (added OS130)                     */         
         JOBNUM=1000,       /* Job Queue Size         &MAXJOBS(1   c*/          
         JOBWARN=80,        /* Warning Threshold %    &MAXJOBS(2 onc*/          
         PRTYHIGH=10,       /* Upper Limit for Aging  &PRIHIGH   onc*/          
         PRTYJECL=YES,      /*PRIORITY JECL Supported &PRIOOPT ohwnc*/          
         PRTYJOB=YES,       /* PRTY= ON JOB NOT SUP'D &PRTYJOB ohwnc*/          
         PRTYLOW=5,         /* Lower Limit for Aging  &PRILOW    onc*/          
         PRTYRATE=0,        /* Prty Aging Rate X/Day  &PRIRATE   onc*/          
         RANGE=(1-9999)     /* Local Job Number Range &JRANGE     oc*/          
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    Default PRTY Calculations         *          
                              *--------------------------------------*          
                                                                     */         
JOBPRTY(1) PRIORITY=9,       /* Job Prty=9 if           &RPRI1 ohwnc*/          
           TIME=2            /*  < 2 min. exec. time    &RPRT1 ohwnc*/          
                             /*                                      */         
JOBPRTY(2) PRIORITY=8,       /* Job Prty=8 if < 5 min.  &RPRI2 ohwnc*/          
           TIME=5            /* etc.                            ohwnc*/         
                             /*                                      */         
JOBPRTY(3) PRIORITY=7,       /* Job Prty=7 if <15 min.  &RPRI2 ohwnc*/          
           TIME=15           /* etc.                            ohwnc*/         
                             /*                                      */         
JOBPRTY(4) PRIORITY=6,       /* Job Prty=6 if nolim     &RPRI2 ohwnc*/          
           TIME=1440         /* etc.                            ohwnc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              * Identify JES2 APPLIDs to VTAM        *          
                              *--------------------------------------*          
                                                                     */         
LOGON(1)   APPLID=JES2,      /* ACCESS CONTROL BLOCK (ACB) NAME ohwnc*/         
           LOG=Y,            /* Monitor VTAM interface (Y)      ohwnc*/         
                             /*   or discontinue monitoring (N)      */         
           TRACEIO=NO        /* Trace I/O Activity (YES)        ohwnc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              * TP Line for RJE/NJE                  *          
                              *    SNA Line                          *          
                              *--------------------------------------*          
                                                                     */         
LINE(1)  UNIT=SNA            /* LOGICAL LINE 1                  ohwnc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    Multi-Access Spool                *          
                              *--------------------------------------*          
                                                                     */         
MASDEF   SHARED=NOCHECK,     /* MULTI ACCESS SPOOL NOCHECK      ohwnc*/         
         DORMANCY=(100,500), /*                                 ohwnc*/         
         HOLD=100,           /*                                 ohwnc*/         
         LOCKOUT=1200        /*                                 ohwnc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    NJE Definitions                   *          
                              *--------------------------------------*          
                                                                     */         
NJEDEF   DELAY=120,          /* Max. Msg Delay Time             ohwnc*/         
         HDRBUF=(LIMIT=100,  /* Number of NJE header + trailer  ohwnc*/         
                             /*     buffers                          */         
              WARN=80),      /* Warning Threshhold              ohwnc*/         
         JRNUM=2,            /* Number of job receivers          hwnc*/         
         JTNUM=2,            /* Number of job xmitters           hwnc*/         
         LINENUM=5,          /* Number of lines for NJE          hwnc*/         
         MAILMSG=NO,         /* Don't automatically issue       ohwnc*/         
                             /* notification message                 */         
         MAXHOP=0,           /* Num. of iterations to limit      hwnc*/         
                             /*     hoping in network                */         
                             /* 0 means no hop counting              */         
         NODENUM=50,         /* Max. number of NJE nodes           nc*/         
         OWNNODE=1,          /* this node's number                  c*/         
         PATH=1,             /* number of paths                  hwnc*/         
         RESTMAX=8000000,    /* Max. resistance tolerance       ohwnc*/         
         RESTNODE=150,       /* this node's resistance          ohwnc*/         
         RESTTOL=300,        /* Alt. resistance tolerance       ohwnc*/         
         SRNUM=2,            /* number of sysout receivers       hwnc*/         
         STNUM=2,            /* number of sysout xmitters        hwnc*/         
         TIMETOL=30          /* Time variation between clocks   ohwnc*/         
                             /* Times are in 1/100 sec. unless spec'd*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    Offlaod Data Set                  *          
                              *--------------------------------------*          
                                                                     */         
OFFLOAD1 DSN=SYS1.OFFLOAD    /* DATA SET NAME           DSN     ohwnc*/         
                             /* No. of Devices (units)  UNITCT  ohwnc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    JES2 Options Definition           *          
                              *--------------------------------------*          
                                                                     */         
OPTSDEF  LIST=NO,            /* Do not copy following init.      hwnc*/         
                             /*   stmts. to HARDCOPY console         */         
         LOG=NO,             /* Do not copy following init stmts hwnc*/         
                             /*   to printer defined on HASPLIST     */         
         SPOOL=NOVALIDATE    /* Do not validate track group map    nc*/         
                             /*--------------------------------------*/         
                             /* The following options can only       */         
                             /* be overridden when the JES2          */         
                             /* initialization process is in         */         
                             /* CONSOLE mode.                        */         
                             /*--------------------------------------*/         
/*       CKPTOPT=HIGHEST      * Use highest checkpoint to        hwnc*/         
/*                            *      restart                         */         
/*       CONSOLE=YES          * Prompt for more init. stmts.     hwnc*/         
/*       LISTOPT=NO           * Support LIST start option        hwnc*/         
/*       LOGOPT=YES           * Support LOG start option         hwnc*/         
/*       RECONFIG=YES         * Allow op to specify RECONFIG     hwnc*/         
/*       REQMSG=YES           * Display HASP400 message          hwnc*/         
/*                                                                   */         
/*                                                                   */         
/*                            *--------------------------------------*          
                              *    Output Class Attributes $$a       *          
                              *--------------------------------------*/         
OUTCLASS(A) BLNKTRNC=YES,    /* Truncate trailing blanks          wnc*/         
         OUTDISP=(WRITE,WRITE), /* OUT disp             PRINT    ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(B) BLNKTRNC=YES,    /* Truncate trailing blanks          wnc*/         
         OUTDISP=(WRITE,WRITE), /* OUT disp             PRINT    ownc*/         
         OUTPUT=PUNCH,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(C) BLNKTRNC=YES,    /* Truncate trailing blanks          wnc*/         
         OUTDISP=(WRITE,WRITE), /* OUT disp             PRINT    ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(D) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(WRITE,WRITE), /* OUT disp             PRINT    ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(H) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(HOLD,HOLD), /* HOLD disp              HOLD     ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(J) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(WRITE,WRITE), /* OUT disp             PRINT    ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(K) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(HOLD,HOLD), /* OUT disp               PRINT    ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(L) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(WRITE,WRITE), /* OUT disp             PRINT    ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(O) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(HOLD,HOLD), /* OUT disp               PRINT    ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(X) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(HOLD,HOLD), /* OUT disp               PRINT    ownc*/         
         OUTPUT=PRINT,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(Z) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(HOLD,HOLD), /* OUT disp               PRINT    ownc*/         
         OUTPUT=DUMMY,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(5) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(PURGE,PURGE), /* OUT disp             PRINT    ownc*/         
         OUTPUT=DUMMY,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
OUTCLASS(9) BLNKTRNC=YES,    /* TRUNCATE TRAILING BLANKS          wnc*/         
         OUTDISP=(PURGE,PURGE), /* OUT disp             PRINT    ownc*/         
         OUTPUT=DUMMY,       /* Print Class             PRINT     wnc*/         
         TRKCELL=YES         /* Track-Cell this Class   NOTRKCEL  wnc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    Output Characteristics            *          
                              *--------------------------------------*          
                                                                     */         
OUTDEF   COPIES=30,          /* MAX.  COPIES ALLWD &JCOPYLM    ohwnc*/          
         DMNDSET=NO,         /* No Demand Setup    &DMNDSET      wnc*/          
         JOENUM=1500,        /* MAX.  OF JOES      &NUMJOES(,      c*/          
         JOEWARN=80,         /* Warning Threshold  &NUMJOES(,% ohwnc*/          
         OUTTIME=CREATE,     /* Specifies when JOE time saved   ohwnc*/         
                             /*     (added SP410)                    */         
         PRTYHIGH=255,       /* Ceiling for PRTY Aging  ---     ohwnc*/         
         PRTYLOW=0,          /* Floor for PRTY Aging    ---     ohwnc*/         
         PRTYOUT=NO,         /* No PRTY= on // OUTPUT &PRTYOUT ohwnc*/          
         PRYORATE=0,         /* Don't priority age              ohwnc*/         
         SEGLIM=100,         /* Max. number output segments      ownc*/         
         STDFORM=STD,        /* Default Forms ID   &STDFORM      wnc*/          
         USERSET=NO          /* No User Demand-Setup &USERSET    wnc*/          
                             /*                                      */         
/*                           *---------------------------------------*          
                             *   Default Output Priority             *          
                             *---------------------------------------*          
                                                                     */         
                             /* based on records (line mode)         */         
                             /*         or pages (page mode)         */         
OUTPRTY(1) PRIORITY=144,     /* OUTPUT PRTY IS 144 IF   &XPRI1 ohwnc*/          
           RECORD=2000,      /*  < 2000 RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=50           /*  OR < 50 PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
OUTPRTY(2) PRIORITY=128,     /* OUTPUT PRTY IS 128 IF   &XPRI1 ohwnc*/          
           RECORD=5000,      /*  < 5000 RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=100          /*  OR <100 PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
OUTPRTY(3) PRIORITY=112,     /* OUTPUT PRTY IS 112 IF   &XPRI1 ohwnc*/          
           RECORD=15000,     /*  <15000 RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=300          /*  OR <300 PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
OUTPRTY(4) PRIORITY=96,      /* OUTPUT PRTY IS  96 IF   &XPRI1 ohwnc*/          
           RECORD=16677215,  /*  < MAX  RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=16677215     /*  OR <MAX PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
OUTPRTY(5) PRIORITY=80,      /* OUTPUT PRTY IS  80 IF   &XPRI1 ohwnc*/          
           RECORD=16677215,  /*  < MAX  RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=16677215     /*  OR <MAX PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
OUTPRTY(6) PRIORITY=64,      /* OUTPUT PRTY IS  64 IF   &XPRI1 ohwnc*/          
           RECORD=16677215,  /*  < MAX  RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=16677215     /*  OR <MAX PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
OUTPRTY(7) PRIORITY=48,      /* OUTPUT PRTY IS  48 IF   &XPRI1 ohwnc*/          
           RECORD=16677215,  /*  < MAX  RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=16677215     /*  OR <MAX PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
OUTPRTY(8) PRIORITY=32,      /* OUTPUT PRTY IS  32 IF   &XPRI1 ohwnc*/          
           RECORD=16677215,  /*  < MAX  RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=16677215     /*  OR < 50 PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
OUTPRTY(9) PRIORITY=16,      /* OUTPUT PRTY IS  16 IF   &XPRI1 ohwnc*/          
           RECORD=16677215,  /*  < MAX  RECORDS (LINE)  &XLIN1 ohwnc*/          
           PAGE=16677215     /*  OR <MAX PAGES (PAGE)   &XPAG1 ohwnc*/          
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    JES2 Processor Numbers            *          
                              *--------------------------------------*          
                                                                     */         
PCEDEF   CNVTNUM=2,          /* 2 Converter PCEs        ---      hwnc*/         
         PSONUM=2,           /* 2 PSO PCEs              ---      hwnc*/         
         OUTNUM=2,           /* 2 Output PCEs           ---      hwnc*/         
         PURGENUM=2,         /* 2 Purge PCEs            ---      hwnc*/         
         SPINNUM=3,          /* 2 Spin PCEs             ---      hwnc*/         
         STACNUM=2           /* 2 STATUS/CANCEL PCEs    ---      hwnc*/         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    Printing Characteristics          *          
                              *--------------------------------------*          
                                                                     */         
PRINTDEF CCWNUM=10,          /*  CCWS / PRINT BUFFER   &NOPRCCW wnc*/           
         DBLBUFR=YES,        /* Double Buffer Lcl Prts  &PRTBOPT wnc*/          
         FCB=EX01,           /* INITIAL FCB LOADED      &PRTFCB  wnc*/          
         LINECT=61,          /* 61 LINES/PAGE          &LINECT ohwnc*/          
         NIUCS=GF10,         /* 3800 Char. Set Loaded   &NIPUCS  wnc*/          
         RDBLBUFR=NO,        /* Single Buffer Rmt Prts  &RPRBOPT wnc*/          
         SEPPAGE=(LOCAL=DOUBLE,                                                 
                             /* Separator page defaults         ohwnc*/         
                             /*     (added SP410)                    */         
                             /*   Local printer  (pre SP410 SEPLINE) */         
             REMOTE=HALF),   /*   Remote printer (pre SP410 RSEPLINE)*/         
         TRANS=YES,          /* PN-Xlate for 1403/Rm.Pr &PRTRANS wnc*/          
         UCS=0               /* Bypass UCS-Loading      &PRTUCS  wnc*/          
                             /*                                      */         
/*                           *---------------------------------------*          
                             *    Printer Parameters                 *          
                             *---------------------------------------*          
                                                                     */         
                             /* More WS parms(JOBNAME,RANGE,VOLUME)OC*/         
/*                           *---------------------------------------*          
                             *    Punch parameters                   *          
                             *---------------------------------------*          
                                                                     */         
PUNCHDEF CCWNUM=02,          /*  CCWs / Punch Buffer    &NOPUCCW wnc*/          
         DBLBUFR=NO,         /* Single Buffer Lcl Puns  &PUNBOPT wnc*/          
         RDBLBUFR=NO         /* Single Buffer Rmt Puns  &RPUBOPT wnc*/          
                             /*                                      */         
/*                           *---------------------------------------*          
                             *    SMF Definitions                    *          
                             *---------------------------------------*          
                                                                     */         
SMFDEF   BUFNUM=5,           /* No. of SMF Buffers   &SMFBUF(,   wnc*/          
         BUFWARN=80          /* Warn Threshold %     &SMFBUF(,%ohwnc*/          
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    SPOOL Definitions                 *          
                              *--------------------------------------*          
                                                                     */         
SPOOLDEF BUFSIZE=3992,       /* MAXIMUM BUFFER SIZE     &BUFSIZE   c*/          
         DSNAME=SYS1.VSY2PKA.HASPACE,                                           
         FENCE=NO,           /* Don't Force to Min.Vol. &FENCE    oc*/          
         SPOOLNUM=32,        /* Max. Num. Spool Vols    ---         c*/         
         TGSIZE=33,          /* 30 BUFFERS/TRACK GROUP  &TGSIZE  wnc*/          
         TGSPACE=(MAX=162880, /* Fits TGMs into 4K Page  &NUMTG=(, c*/          
                  WARN=80),  /*                       &NUMTG=(,% onc*/          
         TRKCELL=5,          /* 5 Buffers/Track-cell    &TCELSIZ   c*/          
         VOLUME=SY2PK /* SPOOL VOLUME SERIAL   &SPOOL     C*/                   
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    STC Defaults                      *          
                              *--------------------------------------*          
                                                                     */         
                             /*    on &RDROPST = bppmmmmsscrlaaaaeWS*/          
JOBCLASS(STC) TIME=(1440,00), /* Job Step Time   ...mmmmss....... WS*/          
         COMMAND=EXECUTE,    /* Execute Commands ..........r...... WS*/         
         BLP=NO,             /* Ignore BLP parm  ...........l..... WS*/         
         AUTH=ALL,           /* Allow all Cmds   ............aaaa. WS*/         
         MSGLEVEL=(1,1),     /* Job, All Msgs    ................e WS*/         
         IEFUJP=YES,         /* Take SMF Job Purge Exit IEFUJP     WS*/         
         IEFUSO=YES,         /* Take SYSOUT Excess Exit IEFUSO     WS*/         
         OUTDISP=(PURGE,HOLD),       /*                            WS*/         
         LOG=YES,            /* Print JES2 JOB LOG      LOG        WS*/         
         OUTPUT=YES,         /* Produce Output for Job  OUTPUT     WS*/         
         PERFORM=000,        /* SRM Performance Group 0 PERFORM  hwnc*/         
         PROCLIB=00,         /* Use //PROC00 DD                  hwnc*/         
         REGION=0K,          /* Region Size                      hwnc*/         
                             /*   (format changed SP410)             */         
         TYPE6=YES,          /* Produce SMF 6 Records   TYPE6      WS*/         
         TYPE26=YES,         /* Produce SMF 26 Records  TYPE26     WS*/         
         MSGCLASS=K          /* Default Message Class   STCMCLAS   WS*/         
                             /*                                      */         
                             /*--------------------------------------*/         
                             /*    Subtask definition                */         
                             /*--------------------------------------*/         
 SUBTDEF  GSUBNUM=10         /* Specify the number of general    hwnc*/         
                             /* purpose subtask                      */         
                             /*                                      */         
/*                            *--------------------------------------*          
                              *    TSU Defaults         &TSU        *           
                              *--------------------------------------*          
                                                                     */         
                             /*    on &RDROPSL = bppmmmmsscrlaaaaeWS*/          
JOBCLASS(TSU) TIME=(0120,00), /* Job Step Time   ...mmmmss........ WS*/         
         COMMAND=EXECUTE,    /* Execute Commands ..........r...... WS*/         
         BLP=NO,             /* Ignore BLP parm  ...........l..... WS*/         
         AUTH=ALL,           /* Allow all Cmds   ............aaaa. WS*/         
         MSGLEVEL=(1,1),     /* Job, All Msgs    ................e WS*/         
         IEFUJP=YES,         /* Take SMF Job Purge Exit IEFUJP     WS*/         
         IEFUSO=YES,         /* Take SYSOUT Excess Exit IEFUSO     WS*/         
         OUTDISP=(PURGE,HOLD),       /*                            WS*/         
         LOG=YES,            /* Print JES2 JOB LOG      LOG        WS*/         
         OUTPUT=YES,         /* Produce Output for Job  OUTPUT     WS*/         
         PERFORM=0,          /* SRM Performance Group 0 PERFORM    WS*/         
         PROCLIB=00,         /* Use //PROC00 DD         PROCLIB    WS*/         
         TYPE6=YES,          /* Produce SMF 6 Records   TYPE6      WS*/         
         TYPE26=YES,         /* Produce SMF 26 Records  TYPE26     WS*/         
         MSGCLASS=K          /* Default Message Class   TSUMCLAS   WS*/         
                             /*                                      */         
/*********************************************************************/         
/*                                                                   */         
/*      CHANGED Initialization Statements  (New Parameters)          */         
/*                                                                   */         
/*********************************************************************/         
                             /*--------------------------------------*/         
                             /*    Recovery Options                  */         
                             /*--------------------------------------*/         
                             /* Error Type               --- (new) OC*/         
/*CVOPTS (ALL)                  JES2 MAIN TASK           --- (NEW) OC*/         
                             /*                                      */         
                             /*--------------------------------------*/         
                             /*    $TRACE Facility                   */         
                             /*--------------------------------------*/         
TRACE(1) START=NO            /* Spin Log after 500 Pgs &TRLOGSZ hwnc*/          
                             /*                                      */         
/*********************************************************************/         
./ ADD NAME=LOAD00,LEVEL=00,SOURCE=0,LIST=ALL                                   
IODF     00 SYS1     TESTLPAR SF Y                                              
SYSCAT   SY2PKA113CSYS1.MCAT.VSY2PKA                                            
PARMLIB  SYS1.PARMLIB                                                           
PARMLIB  SYS1.IBM.PARMLIB                                                       
IEASYM   (00,L)                                                                 
INITSQA  0000M 0002M                                                            
./ ADD NAME=LPALST00,LEVEL=00,SOURCE=0,LIST=ALL                                 
SYS1.LPALIB,                                                                    
ISP.SISPLPA,                                                                    
ISF.SISFLPA,                                                                    
TCPIP.SEZALPA,                                                                  
SYS1.SDWWDLPA,                                                                  
REXX.SEAGALT,                                                                   
SYS1.SYNCSORT.ZOS.SYNCLPA,                                                      
SYS1.SYNCSORT.ZOS.SYNCRENT                                                      
./ ADD NAME=MSTJCL00,LEVEL=00,SOURCE=0,LIST=ALL                                 
//MSTJCL00 JOB MSGLEVEL=(1,1),TIME=NOLIMIT                                      
//         EXEC PGM=IEEMB860,DPRTY=(15,15)                                      
//STCINRDR DD SYSOUT=(A,INTRDR)                                                 
//TSOINRDR DD SYSOUT=(A,INTRDR)                                                 
//IEFPDSI  DD DSN=SYS1.PROCLIB,DISP=SHR                                         
//         DD DSN=SYS1.IBM.PROCLIB,DISP=SHR                                     
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR                                            
//SYSLBC   DD DSN=SYS1.BRODCAST,DISP=SHR /*IGNORED Z/OS 1.3 AND ABOVE*/         
./ ADD NAME=PROG00,LEVEL=00,SOURCE=0,LIST=ALL                                   
SYSLIB LINKLIB(SYS1.VSY2PKA.LINKLIB)                                            
SYSLIB LPALIB(SYS1.VSY2PKA.LPALIB)                                              
 /*                                        */                                   
APF FORMAT(DYNAMIC)                                                             
APF ADD DSNAME(SYS1.LINKLIB)                  VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.MIGLIB)                   VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.CSSLIB)                   VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.SIEALNKE)                 VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.SIEAMIGE)                 VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.SHASMIG)                  VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.SHASLNKE)                 VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.CMDLIB)                   VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.LPALIB)                   VOLUME(SY2PKA)                    
APF ADD DSNAME(CEE.SCEERUN)                   VOLUME(SY2PKA)                    
 /* APF ADD DSNAME(CEE.SCEERUN2)                  VOLUME(SY2PKA) */             
APF ADD DSNAME(SYS1.SISTCLIB)                 VOLUME(SY2PKA)                    
APF ADD DSNAME(ISP.SISPLOAD)                  VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.VTAMLIB)                  VOLUME(SY2PKA)                    
APF ADD DSNAME(CSF.SCSFMOD1)                  VOLUME(SY2PKA)                    
APF ADD DSNAME(TCPIP.SEZALOAD)                VOLUME(SY2PKA)                    
APF ADD DSNAME(TCPIP.SEZATCP)                 VOLUME(SY2PKA)                    
APF ADD DSNAME(TCPIP.SEZALPA)                 VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.SYNCSORT.ZOS.SYNCLPA)     VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.SYNCSORT.ZOS.SYNCRENT)    VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.SYNCSORT.ZOS.SYNCAUTH)    VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.SYNCSORT.ZOS.SYNCLINK)    VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.VSY2PKA.LINKLIB)          VOLUME(SY2PKA)                    
APF ADD DSNAME(SYS1.VSY2PKA.LPALIB)           VOLUME(SY2PKA)                    
 /*                                        */                                   
LNKLST DEFINE NAME(LNKLST00)                                                    
LNKLST ADD NAME(LNKLST00) DSN(SYS1.LINKLIB)                                     
LNKLST ADD NAME(LNKLST00) DSN(SYS1.MIGLIB)                                      
LNKLST ADD NAME(LNKLST00) DSN(SYS1.CSSLIB)                                      
LNKLST ADD NAME(LNKLST00) DSN(SYS1.SIEALNKE)                                    
LNKLST ADD NAME(LNKLST00) DSN(SYS1.SIEAMIGE)                                    
LNKLST ADD NAME(LNKLST00) DSN(CEE.SCEERUN)                                      
 /* LNKLST ADD NAME(LNKLST00) DSN(CEE.SCEERUN2)      */                         
LNKLST ADD NAME(LNKLST00) DSN(ASM.SASMMOD1)                                     
LNKLST ADD NAME(LNKLST00) DSN(SYS1.SHASMIG)                                     
LNKLST ADD NAME(LNKLST00) DSN(SYS1.SHASLNKE)                                    
LNKLST ADD NAME(LNKLST00) DSN(SYS1.CMDLIB)                                      
LNKLST ADD NAME(LNKLST00) DSN(SYS1.VTAMLIB)                                     
LNKLST ADD NAME(LNKLST00) DSN(SYS1.SCBDHENU)                                    
LNKLST ADD NAME(LNKLST00) DSN(SYS1.SISTCLIB)                                    
LNKLST ADD NAME(LNKLST00) DSN(CSF.SCSFMOD1)                                     
LNKLST ADD NAME(LNKLST00) DSN(TCPIP.SEZALOAD)                                   
LNKLST ADD NAME(LNKLST00) DSN(TCPIP.SEZALNK2)                                   
LNKLST ADD NAME(LNKLST00) DSN(TCPIP.SEZATCP)                                    
LNKLST ADD NAME(LNKLST00) DSN(ISF.SISFLOAD)                                     
LNKLST ADD NAME(LNKLST00) DSN(ISF.SISFLINK)                                     
LNKLST ADD NAME(LNKLST00) DSN(ISP.SISPLOAD)                                     
LNKLST ADD NAME(LNKLST00) DSN(SYS1.SYNCSORT.ZOS.SYNCAUTH)                       
LNKLST ADD NAME(LNKLST00) DSN(SYS1.SYNCSORT.ZOS.SYNCLINK)                       
LNKLST ACTIVATE NAME(LNKLST00)                                                  
./ ADD NAME=SMFPRM00,LEVEL=00,SOURCE=0,LIST=ALL                                 
 ACTIVE                          /* ACTIVE SMF RECORDING             */         
 DSNAME(SYS1.VSY2PKA.MAN1,                                                      
        SYS1.VSY2PKA.MAN2)                                                      
 NOPROMPT                        /* DO NOT PROMPT OPERATOR           */         
 REC(PERM)                       /* TYPE 17 PERM RECORDS ONLY        */         
 MAXDORM(3000)                   /* WRITE IDLE BUFFER AFTER 30 MIN   */         
 STATUS(010000)                  /* WRITE SMF STATS AFTER 1 HOUR     */         
 JWT(0030)                       /* 522 AFTER 30 MINUTES             */         
 SID(&SYSNAME)                   /* SMF SYSID                        */         
 LISTDSN                         /* LIST DATA SET STATUS AT IPL      */         
 SYS(NOTYPE(14:19,62:69,99),EXITS(IEFU83,IEFU84,IEFACTRT,                       
               IEFUJI,IEFU29),NOINTERVAL,NODETAIL)                              
 /* WRITE ALL EXCEPT DATA MANAGEMENT RECORDS, TAKE EXITS.            */         
 /* NOTE: JES EXITS CONTROLED BY JES , THERE IS NO                   */         
 /* DEFAULT INTERVAL RECORDS WRITTEN AND ONLY SUMMARY T32            */         
 /* RECORDS AS A DEFAULT FOR TSO.                                    */         
 SUBSYS(STC,EXITS(IEFU29,IEFU83,IEFU84,IEFUJP,IEFUSO))                          
 /* WRITE RECORDS ACCORDING TO SYS VALUE, TAKE ONLY FIVE             */         
 /* EXITS, NOTE: IEFU29 EXECUTES IN THE MASTER ASID WHICH IS A       */         
 /* STC ADDRESS SPACE SO IEFU29 MUST BE ON FOR STC.                  */         
 /* USE ALL OTHER SYS PARMETERS AS A DEFAULT.                        */         
./ ADD NAME=SMFLIM00,LEVEL=00,SOURCE=0,LIST=ALL                                 
/****************************************************************/              
/* SMFLIMxx member.            This replaces the IEFUSI exit    */              
/* usage for z/OS 2.2 and above.                                */              
/*                                                              */              
/*   The statements are ordered; subsequent statements with     */              
/*   matching filters that appear later in the parmlib          */              
/*   member or in a subsequent parmlib member will override     */              
/*   the values of statements that previously appeared. The     */              
/*   end result is a compendium of the IEFUSI exit results      */              
/*   and the results of the various ordered SMFLIMxx            */              
/*   statements that matched this job step program.             */              
/*                                                              */              
/* This is why SUBSYS(*) is not coded.                          */              
/*                                                              */              
/* See the MVS Initialization and Tuning Reference and the      */              
/* MVS Initialization and Tuning guide for more information.    */              
/*                                                              */              
/****************************************************************/              
/***********************************************************/                   
/* BATCH JOB & TSO REGION / SMFLIMxx RULES                 */                   
/***********************************************************/                   
REGION SUBSYS(JES2,TSO)                                                         
   REGIONABOVE(NOLIMIT) REGIONBELOW(NOLIMIT)                                    
   SYSRESVBELOW(512K)                                                           
   MEMLIMIT(10G)                                                                
/***********************************************************/                   
/* STC REGION / SMFLIMxx RULES                             */                   
/***********************************************************/                   
REGION SUBSYS(STC)                                                              
   REGIONABOVE(NOLIMIT) REGIONBELOW(NOLIMIT)                                    
   SYSRESVBELOW(512K)                                                           
   MEMLIMIT(NOLIMIT)                                                            
/***********************************************************/                   
/* OMVS REGION / SMFLIMxx RULES (NOT RECOMMENDED)          */                   
/***********************************************************/                   
/*REGION SUBSYS(OMVS)                          */                               
/* REGIONABOVE(NOLIMIT) REGIONBELOW(NOLIMIT)   */                               
/* SYSRESVBELOW(0K)                            */                               
/* MEMLIMIT(10G)                               */                               
./ ADD NAME=TSOKEY00,LEVEL=00,SOURCE=0,LIST=ALL                                 
USERMAX=10,                                                            +        
RECONLIM=3,                                                            +        
BUFRSIZE=132,                                                          +        
HIBFREXT=96000,                                                        +        
LOBFREXT=24000,                                                        +        
CHNLEN=4,                                                              +        
SCRSIZE=1920                                                                    
./ ADD NAME=VATLST00,LEVEL=00,SOURCE=0,LIST=ALL                                 
VATDEF IPLUSE(PRIVATE) SYSUSE(PRIVATE)                                          
SY2PKA,0,0,3390                                                                 
./ ADD NAME=IGDSMS00,LEVEL=00,SOURCE=0,LIST=ALL                                 
 SMS                                                                            
   ACDS(SYS1.SMS.ACDS1)                                                         
   COMMDS(SYS1.SMS.COMMDS1)                                                     
./ ADD NAME=BPXPRM00,LEVEL=00,SOURCE=0,LIST=ALL                                 
 /*** BPXPRM00 *******************************************************/         
 /*                                                                  */         
 /*  TWOPAK SYSTEM BPXPRM00                                          */         
 /*                                                                  */         
 /********************************************************************/         
   MAXTHREADTASKS(5000)             /* Specifies the maximum number             
                                       of MVS pthread_created threads           
                                       that a single process can                
                                       have concurrently active.     */         
   MAXUIDS(700)                     /* Allow at most 50 OpenEdition             
                                       MVS users to be active                   
                                       concurrently                   */        
   MAXFILEPROC(10000)               /* Allow at most 10000 open files           
                                       per user                      */         
   MAXMMAPAREA(4096)                /* System will allow at most 4096           
                                       pages to be used for memory              
                                       mapping.                      */         
   MAXPROCUSER(4096)                /* Allow each user (same UID) to            
                                       have at most 25 concurrent               
                                       processes active              */         
   MAXPTYS(6000)                    /* Allow up to 256 pseudo-terminal          
                                       sessions                      */         
   CTRACE(CTIBPX00)                 /* Parmlib member 'CTIBPX00' will           
                                       contain the initial tracing              
                                       options to be used            */         
   MAXCORESIZE(2147483647)          /* RLIMIT_CORE soft and hard                
                                       resource value                */         
   MAXASSIZE(2147483647)            /* Adress Space Region Size      */         
   MAXCPUTIME(9999)                 /* CPU-Time for a Process        */         
   MAXSHAREPAGES(131072)            /* System will allow at most 131072         
                                       pages of shared storage to be            
                                       concurrently in use           */         
   IPCMSGNIDS(500)                                                              
   IPCMSGQBYTES(262144)                                                         
   IPCMSGQMNUM(10000)                                                           
   IPCSEMNSEMS(50)                                                              
   IPCSEMNIDS(5000)                 /* Max number of semaphores     */          
   IPCSEMNOPS(32767)                /* Max number of ops in semaph. */          
   IPCSHMNIDS(12800)                /* Max number of shr.mem. segs. */          
   IPCSHMMPAGES(1024)               /* Max number of pages per seg. */          
   IPCSHMNSEGS(600)                 /* Max number of shr.mem. segs. */          
   IPCSHMSPAGES(2621440)            /* Max number of pages shr.mem. */          
   FORKCOPY(COW)                    /* System will use copy-on-write            
                                       for fork system calls if the             
                                       suppression-on-protection                
                                       hardware feature is available */         
   SUPERUSER(BPXROOT)               /* Userid assigned via SU command*/         
   TTYGROUP(TTY)                    /* group name given to slave                
                                       pseudoterminals               */         
   STEPLIBLIST('/system/steplib')   /* contains list of mvs dsns for            
                                       use as step libs for pgms who            
                                       have the set-user-ID and                 
                                       set-group-ID bit set          */         
 /********************************************************************/         
   FILESYSTYPE TYPE(HFS)            /* Type of file system to start  */         
               ENTRYPOINT(GFUAINIT) /* Entry Point of load module    */         
               PARM(' ')            /* Null PARM for physical file              
                                       system                        */         
            /* ASNAME(adrspc01) */  /* Name of address space for                
                                       physical file system          */         
 /********************************************************************/         
 /* Define Automount Facility                                        */         
 /********************************************************************/         
   FILESYSTYPE TYPE(AUTOMNT)        /* Active Automount Facility     */         
               ENTRYPOINT(BPXTAMD)  /* see /etc/auto.master          */         
 /********************************************************************/         
 /* Define Temporary File System (TFS)                               */         
 /********************************************************************/         
   FILESYSTYPE TYPE(TFS)            /* Type of file system to start  */         
               ENTRYPOINT(BPXTFS)   /* Entry Point of load module    */         
 /********************************************************************/         
 /* Define zSeries File System (zFS)                                 */         
 /********************************************************************/         
   FILESYSTYPE TYPE(ZFS) ENTRYPOINT(IOEFSCM) ASNAME(ZFS,'SUB=MSTR')             
 /********************************************************************/         
   ROOT     FILESYSTEM('SYS1.OMVS.ROOT')                                        
                                    /* Either FILESYSTEM or DDNAME must         
                                       be specified, but not both.              
                                       FILESYSTEM must be entered in            
                                       quotes.                       */         
            TYPE(ZFS)               /* Type of File system           */         
            MODE(RDWR)              /* (OPTIONAL) CAN BE READ OR RDWR.          
                                       Default = RDWR                */         
/********************************************************************/          
/* DEV TFS data set                                                 */          
/********************************************************************/          
   MOUNT FILESYSTEM('SYS1.&SYSNAME..TFS.DEV')                                   
     TYPE(TFS) MODE(RDWR)                                                       
     MOUNTPOINT('/dev')                                                         
     PARM('-s 2')                    /* Create a 2M TFS  */                     
/********************************************************************/          
/* VAR TFS data set                                                 */          
/********************************************************************/          
   MOUNT FILESYSTEM('SYS1.&SYSNAME..TFS.VAR')                                   
     TYPE(TFS) MODE(RDWR)                                                       
     MOUNTPOINT('/var')                                                         
     PARM('-s 2')                    /* Create a 2M TFS  */                     
/********************************************************************/          
/* TMP TFS dataset                                                  */          
/********************************************************************/          
  /*  MOUNT FILESYSTEM('SYS1.OMVS.TMP')   */                                    
   MOUNT FILESYSTEM('SYS1.&SYSNAME..TFS.TMP')                                   
     TYPE(TFS) MODE(RDWR)                                                       
     MOUNTPOINT('/tmp')                                                         
     PARM('-s 10')                  /* Create a 10M TFS */                      
/********************************************************************/          
/* ETC ZFS dataset                                                  */          
/********************************************************************/          
   MOUNT FILESYSTEM('SYS1.OMVS.ETC')                                            
     TYPE(ZFS) MODE(RDWR)                                                       
     MOUNTPOINT('/etc')                                                         
/********************************************************************/          
 FILESYSTYPE TYPE(UDS) ENTRYPOINT(BPXTUINT)                                     
 NETWORK DOMAINNAME(AF_UNIX)                                                    
         DOMAINNUMBER(1)                                                        
         MAXSOCKETS(6000)                                                       
         TYPE(UDS)                                                              
 FILESYSTYPE TYPE(INET) ENTRYPOINT(EZBPFINI)                                    
 NETWORK DOMAINNAME(AF_INET)                                                    
         DOMAINNUMBER(2)                                                        
         MAXSOCKETS(10000)                                                      
         TYPE(INET)                                                             
         INADDRANYPORT(20000)                                                   
         INADDRANYCOUNT(2000)                                                   
./ ADD NAME=IOEFSPRM,LEVEL=00,SOURCE=0,LIST=ALL                                 
**********************************************************************          
* zSeries File System (zFS) Sample Parameter File:  ioefsprm                    
* For a description of these and other zFS parameters, refer to the             
* zSeries File System Administration, SC24-5989.                                
* Notes:                                                                        
*  1. The ioefsprm file and parameters in the file are optional but it          
*     is recommended that the parameter file be created in order to be          
*     referenced by the DDNAME=IOEZPRM statement the PROCLIB JCL for            
*     the zFS started task.                                                     
*  2. An asterisk in column 1 identifies a comment line.                        
*  3. A parameter specification must begin in column 1.                         
************************************************************************        
* The following msg_output_dsn parameter defines the optional output            
* message data set. If this parameter is not specified, or if the data          
* set is not found, messages will be written to the system log.                 
* You must delete the * from a line to activate the parameter.                  
************************************************************************        
* msg_output_dsn=data.set.name                                                  
************************************************************************        
* The following msg_input_dsn parameter is ONLY required if the optional        
* NLS feature (e.g J0H232J) is installed. The parameter specifies the           
* message input data set containing the NLS message text which is               
* supplied by the NLS feature. If this parameter is not specified or if         
* the data set is not found, English language messages will be generated        
* by zFS. You must delete the * from a line to activate the parameter.          
************************************************************************        
* msg_input_dsn=data.set.name                                                   
*********************************************************************           
* The following are examples of some of the optional parameters that            
* control the sizes of caches, tuning options, and program operation.           
* You must delete the * from a line to activate a parameter.                    
*********************************************************************           
*adm_threads=5                                                                  
*auto_attach=ON                                                                 
*user_cache_size=256M                                                           
*log_cache_size=12M                                                             
*sync_interval=45                                                               
*vnode_cache_size=5000                                                          
*nbs=off                                                                        
*fsfull(85,5)                                                                   
*aggrfull(90,5)                                                                 
**********************************************************************          
* The following are examples of some of the options that control zFS            
* debug facilitities. These parameters are not required for normal              
* operation and should only be specified on the recommendation of IBM.          
* You must delete the * column from a line to activate a parameter.             
**********************************************************************          
*trace_dsn=data.set.name                                                        
*debug_settings_dsn=data.set.name(membername)                                   
*trace_table_size=32M                                                           
*storage_details=ON                                                             
*storage_details_dsn=data.set.name                                              
./ ENDUP                                                                        
@#                                                                              
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
//*****************************************************************             
//* UPDATE VTAMLST WITH REQUIRED MEMBERS                                        
//*****************************************************************             
//UVTAM18  EXEC PGM=IEBUPDTE,PARM=NEW,REGION=4M,COND=(0,NE)                     
//SYSUT2   DD  DSN=SYS1.VTAMLST,DISP=SHR,                                       
//             UNIT=SYSALLDA,VOL=SER=SY2PKA                                     
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DATA,DLM=@#                                                      
./ ADD NAME=APTSO,LEVEL=00,SOURCE=0,LIST=ALL                                    
APTSO  VBUILD  TYPE=APPL                                                        
*                                                                               
A01TSO   APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO                                                
*                                                                               
A01TSO01 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0001                                            
A01TSO02 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0002                                            
A01TSO03 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0003                                            
A01TSO04 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0004                                            
A01TSO05 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0005                                            
A01TSO06 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0006                                            
A01TSO07 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0007                                            
A01TSO08 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0008                                            
A01TSO09 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0009                                            
A01TSO10 APPL  AUTH=(NOACQ,NOBLOCK,PASS,NOTCAM,NVPACE,TSO,NOPO),       X        
               EAS=1,ACBNAME=TSO0010                                            
./ ADD NAME=ATCCON00,LEVEL=00,SOURCE=0,LIST=ALL                                 
APTSO,APTELNET,LCL3270A                                                         
./ ADD NAME=ATCSTR00,LEVEL=00,SOURCE=0,LIST=ALL                                 
SSCPID=01,                                                             X        
SSCPNAME=EMRG01,                                                       X        
NETID=USEMRG01,                                                        X        
CONFIG=00,                                                             X        
NOPROMPT,                                                              X        
MAXSUBA=31,                                                            X        
SUPP=NOSUP,                                                            X        
HOSTSA=1,                                                              X        
CRPLBUF=(208,,15,,1,16),                                               X        
IOBUF=(100,128,19,,1,20),                                              X        
LFBUF=(104,,0,,1,1),                                                   X        
LPBUF=(64,,0,,1,1),                                                    X        
SFBUF=(163,,0,,1,1)                                                             
./ ADD NAME=LCL3270A,LEVEL=00,SOURCE=0,LIST=ALL                                 
LCL3270A LBUILD                                                                 
*                                                                               
*  0120 IS MASTER CONSOLE                                                       
*LCL120   LOCAL CUADDR=0120,                                          X         
*               DLOGMOD=D4B32782,                                     X         
*               TERM=3277,                                            X         
*               FEATUR2=MODEL2,                                       X         
*               ISTATUS=ACTIVE,                                       X         
*               USSTAB=ISTINCDT                                                 
*                                                                               
LCL121   LOCAL CUADDR=0121,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL122   LOCAL CUADDR=0122,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL123   LOCAL CUADDR=0123,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL124   LOCAL CUADDR=0124,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL125   LOCAL CUADDR=0125,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL126   LOCAL CUADDR=0126,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL127   LOCAL CUADDR=0127,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL128   LOCAL CUADDR=0128,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL129   LOCAL CUADDR=0129,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL12A   LOCAL CUADDR=012A,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL12B   LOCAL CUADDR=012B,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL12C   LOCAL CUADDR=012C,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL12D   LOCAL CUADDR=012D,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL12E   LOCAL CUADDR=012E,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
*                                                                               
LCL12F   LOCAL CUADDR=012F,                                            X        
               DLOGMOD=D4B32782,                                       X        
               TERM=3277,                                              X        
               FEATUR2=MODEL2,                                         X        
               ISTATUS=ACTIVE,                                         X        
               USSTAB=ISTINCDT                                                  
./ ADD NAME=APTELNET,LEVEL=00,SOURCE=0,LIST=ALL                                 
APTELNET VBUILD TYPE=APPL                                                       
*                                                                               
TN3270   GROUP AUTH=NVPACE,EAS=1,PARSESS=NO,SESSLIM=YES                         
*                                                                               
TCPE*    APPL                                                                   
./ ENDUP                                                                        
@#                                                                              
//*****************************************************************             
//* UPDATE SISPCLIB WITH REQUIRED MEMBERS                                       
//*****************************************************************             
//UCLIST19 EXEC PGM=IEBUPDTE,PARM=NEW,REGION=4M,COND=(0,NE)                     
//SYSUT2   DD  DSN=ISP.SISPCLIB,DISP=SHR,                                       
//             UNIT=SYSALLDA,VOL=SER=SY2PKA                                     
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DATA,DLM=@#                                                      
./ ADD NAME=LOGPROF,LEVEL=00,SOURCE=0,LIST=ALL                                  
CONTROL NOLIST NOFLUSH NOMSG                                                    
SET &DSNAME = &SYSUID..ISPPROF                                                  
ALLOC FI(ISPPROF) SHR  DA('&DSNAME.')                                           
 IF &LASTCC ^= 0 THEN +                                                         
  DO                                                                            
    FREE FI(ISPCRTE)                                                            
    CONTROL MSG                                                                 
    ATTRIB ISPCRTE DSORG(PO) RECFM(F B) LRECL(80) BLKSIZE(3120)                 
    ALLOC DA('&DSNAME.') SP(2,1) TRACKS DIR(2) USING(ISPCRTE) +                 
        UNIT(SYSALLDA) FI(ISPPROF)                                              
    IF &LASTCC = 0 THEN +                                                       
      WRITE *** ISPF PROFILE DATA SET '&DSNAME.' HAS BEEN CREATED               
    ELSE +                                                                      
     DO                                                                         
      WRITE  *** UNABLE TO ALLOCATE ISPF PROFILE DATA SET '&DSNAME.'            
      FREE FI(ISPCRTE)                                                          
      EXIT CODE(12)                                                             
    END                                                                         
 END                                                                            
ISPF                                                                            
./ ENDUP                                                                        
@#                                                                              
//*****************************************************************             
//* UPDATE SISPPENU WITH REQUIRED MEMBERS                                       
//*****************************************************************             
//UPANEL20 EXEC PGM=IEBUPDTE,PARM=NEW,REGION=4M,COND=(0,NE)                     
//SYSUT2   DD  DSN=ISP.SISPPENU,DISP=SHR,                                       
//             UNIT=SYSALLDA,VOL=SER=SY2PKA                                     
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DATA,DLM=@#                                                      
./ ADD NAME=ISR@PRIM,LEVEL=00,SOURCE=0,LIST=ALL                                 
)PANEL KEYLIST(ISRSAB,ISR) IMAGE(&ZIMGNAM,&ZIMGROW,&ZIMGCOL)                    
)ATTR DEFAULT() FORMAT(MIX)            /* ISR@PRIM - ENGLISH - 5.2 */        
 0B TYPE(AB)                                                                    
 0D TYPE(PS)                                                                    
 04 TYPE(ABSL) GE(ON)                                                           
 05 TYPE(PT)                                                                    
 09 TYPE(FP)                                                                    
 0A TYPE(NT)                                                                    
 11 TYPE(SAC)                                                                   
 16 TYPE(VOI) PADC(USER)                                                        
 2B TYPE(DT)                                                                    
 22 TYPE(WASL) SKIP(ON) GE(ON)                                                  
 26 TYPE(NEF) CAPS(ON) PADC(USER)                                               
 27 AREA(SCRL) EXTEND(ON)                                                       
 28 TYPE(PS) CSRGRP(99)                                                         
 29 TYPE(GRPBOX)                                                                
 2A AREA(DYNAMIC)                                                               
 19 TYPE(DATAOUT) COLOR(WHITE)                                                  
 1A TYPE(DATAOUT) COLOR(RED)                                                    
 1B TYPE(DATAOUT) COLOR(BLUE)                                                   
 1C TYPE(DATAOUT) COLOR(GREEN)                                                  
 1D TYPE(DATAOUT) COLOR(PINK)                                                   
 1E TYPE(DATAOUT) COLOR(YELLOW)                                                 
 1F TYPE(DATAOUT) COLOR(TURQ)                                                   
 30 TYPE(DATAOUT) PAS(ON)                                                       
 31 TYPE(CHAR) COLOR(WHITE)                                                     
 32 TYPE(CHAR) COLOR(RED)                                                       
 33 TYPE(CHAR) COLOR(BLUE)                                                      
 34 TYPE(CHAR) COLOR(GREEN)                                                     
 35 TYPE(CHAR) COLOR(PINK)                                                      
 36 TYPE(CHAR) COLOR(YELLOW)                                                    
 37 TYPE(CHAR) COLOR(TURQ)                                                      
 38 TYPE(DATAOUT) CUADYN(VOI)                                                   
 39 TYPE(CHAR) COLOR(WHITE) HILITE(REVERSE)                                     
 3A TYPE(CHAR) COLOR(RED) HILITE(REVERSE)                                       
 3B TYPE(CHAR) COLOR(BLUE) HILITE(REVERSE)                                      
 3C TYPE(CHAR) COLOR(GREEN) HILITE(REVERSE)                                     
 3D TYPE(CHAR) COLOR(PINK) HILITE(REVERSE)                                      
 3E TYPE(CHAR) COLOR(YELLOW) HILITE(REVERSE)                                    
 3F TYPE(CHAR) COLOR(TURQ) HILITE(REVERSE)                                      
)ABC DESC('Menu') MNEM(1)                                                       
PDC DESC('Settings') UNAVAIL(ZPM1) MNEM(1) ACC(CTRL+S)                          
 ACTION RUN(ISRROUTE) PARM('SET')                                               
PDC DESC('View') UNAVAIL(ZPM2) MNEM(1) ACC(CTRL+V)                              
 ACTION RUN(ISRROUTE) PARM('BR1')                                               
PDC DESC('Edit') UNAVAIL(ZPM3) MNEM(1) ACC(CTRL+E)                              
 ACTION RUN(ISRROUTE) PARM('ED1')                                               
PDC DESC('ISPF Command Shell') UNAVAIL(ZPM4) MNEM(6) ACC(CTRL+C)                
 ACTION RUN(ISRROUTE) PARM('C1')                                                
PDC DESC('Dialog Test...') UNAVAIL(ZPM5) MNEM(8) ACC(CTRL+T)                    
 ACTION RUN(ISRROUTE) PARM('DAL')                                               
PDC DESC('Other IBM Products...') UNAVAIL(ZPM6) MNEM(1) ACC(CTRL+O)             
 ACTION RUN(ISRROUTE) PARM('OIB')                                               
PDC DESC('SCLM') UNAVAIL(ZPM7) MNEM(3) ACC(CTRL+L)                              
 ACTION RUN(ISRROUTE) PARM('SCL')                                               
PDC DESC('ISPF Workplace') UNAVAIL(ZPM8) MNEM(6) ACC(CTRL+W)                    
 ACTION RUN(ISRROUTE) PARM('WRK')                                               
PDC DESC('Status Area...') UNAVAIL(ZPMS) MNEM(8) ACC(CTRL+A)                    
 ACTION RUN(ISRROUTE) PARM('SAM')                                               
PDC DESC('Exit') MNEM(2) PDSEP(ON) ACC(CTRL+X) ACTION RUN(EXIT)                 
)ABCINIT                                                                        
.ZVARS=ISR@OPT                                                                  
)ABC DESC('Utilities') MNEM(1)                                                  
PDC DESC('Library') UNAVAIL(ZUT1) MNEM(1) ACC(ALT+1)                            
 ACTION RUN(ISRROUTE) PARM('U1')                                                
PDC DESC('Data set') UNAVAIL(ZUT2) MNEM(1) ACC(ALT+2)                           
 ACTION RUN(ISRROUTE) PARM('U2')                                                
PDC DESC('Move/Copy') UNAVAIL(ZUT3) MNEM(1) ACC(ALT+3)                          
 ACTION RUN(ISRROUTE) PARM('U3')                                                
PDC DESC('Data Set List') UNAVAIL(ZUT4) MNEM(2) ACC(ALT+4)                      
 ACTION RUN(ISRROUTE) PARM('U4')                                                
PDC DESC('Reset Statistics') UNAVAIL(ZUT5) MNEM(5) ACC(ALT+5)                   
 ACTION RUN(ISRROUTE) PARM('U5')                                                
PDC DESC('Hardcopy') UNAVAIL(ZUT6) MNEM(1) ACC(ALT+6)                           
 ACTION RUN(ISRROUTE) PARM('U6')                                                
PDC DESC('Download...') UNAVAIL(ZUTDT) MNEM(2) ACC(ALT+7)                       
 ACTION RUN(ISRROUTE) PARM('UDT')                                               
PDC DESC('Outlist') UNAVAIL(ZUT7) MNEM(2) ACC(ALT+8)                            
 ACTION RUN(ISRROUTE) PARM('U8')                                                
PDC DESC('Commands...') UNAVAIL(ZUT8) MNEM(1) ACC(ALT+9)                        
 ACTION RUN(ISRROUTE) PARM('U9')                                                
PDC DESC('Reserved') UNAVAIL(ZUT9) MNEM(6) ACTION RUN(ISRROUTE) PARM('U10')     
PDC DESC('Format') UNAVAIL(ZUT10) MNEM(1) ACC(ALT+F1)                           
 ACTION RUN(ISRROUTE) PARM('U11')                                               
PDC DESC('SuperC') UNAVAIL(ZUT11) MNEM(1) PDSEP(ON) ACC(CTRL+F2)                
 ACTION RUN(ISRROUTE) PARM('U12')                                               
PDC DESC('SuperCE') UNAVAIL(ZUT12) MNEM(3) ACC(CTRL+F3)                         
 ACTION RUN(ISRROUTE) PARM('U13')                                               
PDC DESC('Search-For') UNAVAIL(ZUT13) MNEM(2) ACC(CTRL+F4)                      
 ACTION RUN(ISRROUTE) PARM('U14')                                               
PDC DESC('Search-ForE') UNAVAIL(ZUT14) MNEM(4) ACC(CTRL+F5)                     
 ACTION RUN(ISRROUTE) PARM('U15')                                               
)ABCINIT                                                                        
.ZVARS=PDFUTIL                                                                  
     &zut9 = '1'                                                                
)ABC DESC('Compilers') MNEM(1)                                                  
PDC DESC('Foreground Compilers') MNEM(1) ACTION RUN(ISRROUTE) PARM('FGD')       
PDC DESC('Background Compilers') MNEM(1) ACTION RUN(ISRROUTE) PARM('BKG')       
PDC DESC('ISPPREP Panel Utility...') MNEM(1) ACTION RUN(ISPPREP)                
PDC DESC('DTL Compiler...') MNEM(1) ACTION RUN(ISPDTLC)                         
)ABCINIT                                                                        
.ZVARS=ISRLANG                                                                  
)ABC DESC('Options') MNEM(1)                                                    
PDC DESC('General Settings') MNEM(1) ACTION RUN(ISRROUTE) PARM('SET')           
PDC DESC('CUA Attributes...') MNEM(1) ACTION RUN(CUAATTR)                       
PDC DESC('Keylists...') MNEM(1) ACTION RUN(KEYLIST)                             
PDC DESC('Point-and-Shoot...') MNEM(1) ACTION RUN(PSCOLOR)                      
PDC DESC('Colors...') MNEM(2) ACTION RUN(COLOR)                                 
PDC DESC('Dialog Test appl ID...') MNEM(1) ACTION RUN(ISRROUTE) PARM('DAP')     
)ABCINIT                                                                        
.ZVARS=PDFOPTM                                                                  
)ABC DESC('Status') MNEM(1)                                                     
PDC DESC('Session') UNAVAIL(ZCSTA) MNEM(1) ACTION RUN(ISRROUTE) PARM('SES')     
PDC DESC('Function keys') UNAVAIL(ZCSTB) MNEM(1)                                
 ACTION RUN(ISRROUTE) PARM('FUN')                                               
PDC DESC('Calendar') UNAVAIL(ZCSTC) MNEM(1) ACTION RUN(ISRROUTE) PARM('CAL')    
PDC DESC('User status') UNAVAIL(ZCSTD) MNEM(1) ACTION RUN(ISRROUTE) PARM('USE') 
PDC DESC('User point and shoot') UNAVAIL(ZCSTE) MNEM(3)                         
 ACTION RUN(ISRROUTE) PARM('UPS')                                               
PDC DESC('None') UNAVAIL(ZCSTF) MNEM(1) ACTION RUN(ISRROUTE) PARM('OFF')        
)ABCINIT                                                                        
.ZVARS=PDFSTA                                                                   
IF (&ZSCREEN = '1')                                                             
  VGET (ZSAREA1)                                                                
  &ZSAREA = &ZSAREA1                                                            
  GOTO A                                                                        
IF (&ZSCREEN = '2')                                                             
  VGET (ZSAREA2)                                                                
  &ZSAREA = &ZSAREA2                                                            
  GOTO A                                                                        
IF (&ZSCREEN = '3')                                                             
  VGET (ZSAREA3)                                                                
  &ZSAREA = &ZSAREA3                                                            
  GOTO A                                                                        
IF (&ZSCREEN = '4')                                                             
  VGET (ZSAREA4)                                                                
  &ZSAREA = &ZSAREA4                                                            
  GOTO A                                                                        
ELSE                                                                            
  VGET (ZSAREA5)                                                                
  &ZSAREA = &ZSAREA5                                                            
A:                                                                              
&zcsta = 0                                                                      
&zcstb = 0                                                                      
&zcstc = 0                                                                      
&zcstd = 0                                                                      
&zcste = 0                                                                      
&zcstf = 0                                                                      
IF (&ZSAREA = 'SES') &zcsta = 1                                                 
IF (&ZSAREA = 'FUN') &zcstb = 1                                                 
IF (&ZSAREA = 'CAL') &zcstc = 1                                                 
IF (&ZSAREA = 'USE') &zcstd = 1                                                 
IF (&ZSAREA = 'UPS') &zcste = 1                                                 
IF (&ZSAREA = 'OFF') &zcstf = 1                                                 
&PDFSTA = ' '                                                                   
)ABC DESC('Help') MNEM(1)                                                       
PDC DESC('General') MNEM(1) ACTION RUN(TUTOR) PARM('ISR01000')                  
PDC DESC('Settings') MNEM(1) ACTION RUN(TUTOR) PARM('ISP05000')                 
PDC DESC('View') MNEM(1) ACTION RUN(TUTOR) PARM('ISR10000')                     
PDC DESC('Edit') MNEM(1) ACTION RUN(TUTOR) PARM('ISR20000')                     
PDC DESC('Utilities') MNEM(1) ACTION RUN(TUTOR) PARM('ISR30000')                
PDC DESC('Foreground') MNEM(1) ACTION RUN(TUTOR) PARM('ISR40000')               
PDC DESC('Batch') MNEM(1) ACTION RUN(TUTOR) PARM('ISR50000')                    
PDC DESC('Command') MNEM(1) ACTION RUN(TUTOR) PARM('ISR60010')                  
PDC DESC('Dialog Test') MNEM(1) ACTION RUN(TUTOR) PARM('ISP70000')              
PDC DESC('LM Facility') MNEM(1) ACTION RUN(TUTOR) PARM('ISR80000')              
PDC DESC('IBM Products') MNEM(1) ACTION RUN(TUTOR) PARM('ISRD0000')             
PDC DESC('SCLM') MNEM(4) ACTION RUN(TUTOR) PARM('FLMTD')                        
PDC DESC('Workplace') MNEM(1) ACTION RUN(TUTOR) PARM('ISR00400')                
PDC DESC('Exit') MNEM(2) ACTION RUN(TUTOR) PARM('ISP90100')                     
PDC DESC('Status Area') MNEM(2) ACTION RUN(TUTOR) PARM('ISPSAMHP')              
PDC DESC('About...') MNEM(1) ACTION RUN(TUTOR) PARM('ISR@LOGO')                 
PDC DESC('Changes for this Release') MNEM(2) ACTION RUN(TUTOR) PARM('ISR00005') 
PDC DESC('Tutorial') MNEM(4) ACTION RUN(TUTOR) PARM('ISR00000')                 
PDC DESC('Appendices') MNEM(2) ACTION RUN(TUTOR) PARM('ISR00004')               
PDC DESC('Index') MNEM(2) ACTION RUN(TUTOR) PARM('ISR91000')                    
)ABCINIT                                                                        
.ZVARS=PRIMHELP                                                                 
)BODY  CMD(ZCMD)                                                                
 Menu Utilities Compilers Options Status Help                           
------------------------------------------------------------------------------ 
                          	ISPF Primary Option Menu                          
Option ===>Z                                                                 
SAREA39                                               GRPBOX1                
                                                      TMPROWS,TMPSHDW     
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                              
ZEXI                                                                        
    EnterZto Terminate using log/list defaults                             
)AREA SAREA39                                                                   
0 Settings     Terminal and user parameters                                 
1 View         Display source data or listings                              
2 Edit         Create or change source data                                 
3 Utilities    Perform utility functions                                    
4 Foreground   Interactive language processing                              
5 Batch        Submit job for language processing                           
6 Command      Enter TSO or Workstation commands                            
7 Dialog Test  Perform dialog testing                                       
9 IBM Products IBM program development products                             
10SCLM         SW Configuration Library Manager                             
11Workplace    ISPF Object/Action Workplace                                 
S SDSF         System Display and Search Facility                           
H HCD          Hardware Configuration Definition                            
I ISPF Shell   Unix System Services ISPF Shell                              
)INIT                                                                           
.ZVARS = '(ZCMD ZEXX)'                                                          
.HELP = ISR00003                                                                
&ZPRIM = YES                                                                    
&ZEXX = 'X'                                                                     
&ZEXI = ' '                                                                     
.CURSOR = ZCMD                                                                  
&TMPROWS = &ZSDATA                                                              
&TMPSHDW = &ZSSHDW                                                              
IF (&ZHILITE = YES OR &ZGUI ^= &Z)                                              
  .ATTRCHAR(19)='PAS(ON) COLOR(WHITE)'                                          
  .ATTRCHAR(1A)='PAS(ON) COLOR(RED)'                                            
  .ATTRCHAR(1B)='PAS(ON) COLOR(BLUE)'                                           
  .ATTRCHAR(1C)='PAS(ON) COLOR(GREEN)'                                          
  .ATTRCHAR(1D)='PAS(ON) COLOR(PINK)'                                           
  .ATTRCHAR(1E)='PAS(ON) COLOR(YELLOW)'                                         
  .ATTRCHAR(1F)='PAS(ON) COLOR(TURQ)'                                           
IF (&ZGUI ^= &Z)                                                                
  &ZPASICON = 'ON'                                                              
  &ZPASTEXT = 'OFF'                                                             
  IF (&ZSCREEN = '1')                                                           
    VGET (ZSAREA1)                                                              
    &ZSAREA = &ZSAREA1                                                          
    GOTO A                                                                      
  IF (&ZSCREEN = '2')                                                           
    VGET (ZSAREA2)                                                              
    &ZSAREA = &ZSAREA2                                                          
    GOTO A                                                                      
  IF (&ZSCREEN = '3')                                                           
    VGET (ZSAREA3)                                                              
    &ZSAREA = &ZSAREA3                                                          
    GOTO A                                                                      
  IF (&ZSCREEN = '4')                                                           
    VGET (ZSAREA4)                                                              
    &ZSAREA = &ZSAREA4                                                          
    GOTO A                                                                      
  ELSE                                                                          
    VGET (ZSAREA5)                                                              
    &ZSAREA = &ZSAREA5                                                          
  A:                                                                            
  &zcstf = 0                   /* initialize Status AB unavail flags */         
  IF (&ZSAREA = 'OFF') &zcstf = 1                                               
ELSE                                                                            
  &ZPASICON = 'OFF'                                                             
  &ZPASTEXT = 'ON'                                                              
VGET (ZSCML ZSCBR ZSCED ZTAPPLID) PROFILE /*   @V6A*/                           
IF (&ZSCML = ' ') &ZSCML = 'PAGE'        /*                      @V6A */        
IF (&ZSCBR  = ' ') &ZSCBR = 'PAGE'       /*                      @V6A */        
IF (&ZSCED  = ' ') &ZSCED = 'PAGE'       /*                      @V6A */        
IF (&ZTAPPLID = ' ') &ZTAPPLID = 'ISR'                                          
VPUT (ZSCML ZSCBR ZSCED ZTAPPLID) PROFILE /*   @V6A*/                           
&ZHTOP = ISR00003   /* TUTORIAL TABLE OF CONTENTS        */                     
&ZHINDEX = ISR91000 /* TUTORIAL INDEX - 1ST PAGE         */                     
&ZSCLMPRJ = &Z      /* TUTORIAL INDEX - 1ST PAGE     @L1A*/                     
IF (&ZLOGO = 'YES')                                     /* CK@MJC*/             
  IF (&ZSPLIT = 'NO')      /* Not in split screen            @L5A*/             
    IF (&ZCMD = &Z)        /* No command pending             @L5A*/             
      IF (&ZLOGOPAN ^= 'DONE') /* No logo displayed yet      @L5A*/             
        .MSG = ISRLO999    /* Set logo information           @L5A*/             
        .RESP = ENTER      /* Simulate enter                 @L5A*/             
        &ZLOGOPAN = 'DONE' /*                                @L5A*/             
        &ZCLEAN = 'NO'     /*                                @L5A*/             
    IF (&ZCMD ^= &Z) &ZLOGOPAN = 'DONE'   /* command pending @L5A*/             
    VPUT (ZLOGOPAN) SHARED /*                                @L5A*/             
  IF (&ZSPLIT = 'YES') &ZLOGOPAN = 'DONE'                                       
VPUT (ZHTOP,ZHINDEX,ZSCLMPRJ) PROFILE                                           
IF (&ZCSTF = 1)   /* Status area = None */                                      
  &ZIMGNAM ='ISPFGIFL'                                                          
  &ZIMGROW =3                                                                   
ELSE                                                                            
  &ZIMGNAM ='ISPFGIFS'                                                          
  &ZIMGROW =15                                                                  
&ZIMGCOL =56                                                                    
&GRPBOX1 = ''                                                                   
IF (&ZCSTF='0') .ATTR(GRPBOX1) = 'WIDTH(22) DEPTH(13)'                          
ELSE .ATTR(GRPBOX1) = 'WIDTH(0)'                                                
.ATTR(ZEXI)='PADC(NULLS) PAS(&ZPASICON) CSRGRP(99)'                             
.ATTR(ZEXX)='PAS(&ZPASTEXT) CSRGRP(99)'                                         
)REINIT                                                                         
.CURSOR = ZCMD                                                                  
VGET (ZTAPPLID) PROFILE       /*                 Z41@MEA*/                      
IF (&ZTAPPLID = ' ') &ZTAPPLID = 'ISR'        /* Z41@MEA*/                      
)PROC                                                                           
IF (&ZCSTF='1') .ATTR(GRPBOX1) = 'WIDTH(0)'                                     
IF (.CURSOR = TMPROWS AND &ZCMD = ' ')                                          
 &ZSAR  =TRANS(&ZSCREEN 1,&ZSAREA1 2,&ZSAREA2 3,&ZSAREA3 4,&ZSAREA4 *,&ZSAREA5) 
 IF (&ZSAR = 'CAL','UPS','SES') &ZCMD = 'SP'                                    
&ZCMDWRK = TRUNC(&ZCMD,'.')                                                     
&ZTRAIL=.TRAIL                                                                  
&ZSEL = TRANS (TRUNC (&ZCMD,'.')                                                
  0,'PGM(ISPISM) SCRNAME(SETTINGS)'                                             
  1,'PGM(ISRBRO) PARM(ISRBRO01) SCRNAME(VIEW)'                                  
  2,'PGM(ISREDIT) PARM(P,ISREDM01) SCRNAME(EDIT)'                               
  3,'PANEL(ISRUTIL) SCRNAME(UTIL)'                                              
  4,'PANEL(ISRFPA) SCRNAME(FOREGRND)'                                           
  5,'PGM(ISRJB1) PARM(ISRJPA) SCRNAME(BATCH) NOCHECK'                           
  6,'PGM(ISRPTC) SCRNAME(CMD)'                                                  
  7,'PGM(ISPYXDR) PARM(&ZTAPPLID) SCRNAME(DTEST) NOCHECK'                       
  9,'PANEL(ISRDIIS) ADDPOP'                                                     
 10,'PGM(ISRSCLM) SCRNAME(SCLM) NOCHECK'                                        
 11,'PGM(ISRUDA) PARM(ISRWORK) SCRNAME(WORK)'                                   
  S,'PANEL(ISFSDOP2) NEWAPPL(ISF) &SCRNM'                                       
 SD,'PANEL(ISFSDOP2) NEWAPPL(ISF) &SCRNM'                                       
 SDSF,'PANEL(ISFSDOP2) NEWAPPL(ISF) &SCRNM'                                     
  H,'CMD(%CBDCHCD) NEWAPPL(CBD) PASSLIB'                                        
 HC,'CMD(%CBDCHCD) NEWAPPL(CBD) PASSLIB'                                        
 HCD,'CMD(%CBDCHCD) NEWAPPL(CBD) PASSLIB'                                       
   I,'CMD(ISHELL) SCRNAME(ISHELL)'                                              
 ISH,'CMD(ISHELL) SCRNAME(ISHELL)'                                              
  X,EXIT                                                                        
 SP,'PGM(ISPSAM) PARM(PNS)'                                                     
 ' ',' '                                                                        
   *,'?')                                                                       
IF (&ZCMD = 'S')                                                                
   &ZSEL = 'PGM(ISFISP) NOCHECK NEWAPPL(ISF) &SCRNM'                            
IF (&ZCMD = 'S.')                                                               
   &ZSEL = 'PGM(ISFISP) NOCHECK NEWAPPL(ISF) &SCRNM'                            
IF (&ZCMD = 'SD')                                                               
   &ZSEL = 'PGM(ISFISP) NOCHECK NEWAPPL(ISF) &SCRNM'                            
IF (&ZCMD = 'SD.')                                                              
   &ZSEL = 'PGM(ISFISP) NOCHECK NEWAPPL(ISF) &SCRNM'                            
IF (&ZCMD = 'SDSF')                                                             
   &ZSEL = 'PGM(ISFISP) NOCHECK NEWAPPL(ISF) &SCRNM'                            
IF (&ZCMD = 'SDSF.')                                                            
   &ZSEL = 'PGM(ISFISP) NOCHECK NEWAPPL(ISF) &SCRNM'                            
&ZTRAIL=.TRAIL                                                                  
)PNTS                                                                           
FIELD(ZPS01001) VAR(ZCMD) VAL(0)                                                
FIELD(ZPS01002) VAR(ZCMD) VAL(1)                                                
FIELD(ZPS01003) VAR(ZCMD) VAL(2)                                                
FIELD(ZPS01004) VAR(ZCMD) VAL(3)                                                
FIELD(ZPS01005) VAR(ZCMD) VAL(4)                                                
FIELD(ZPS01006) VAR(ZCMD) VAL(5)                                                
FIELD(ZPS01007) VAR(ZCMD) VAL(6)                                                
FIELD(ZPS01008) VAR(ZCMD) VAL(7)                                                
FIELD(ZPS01009) VAR(ZCMD) VAL(9)                                                
FIELD(ZPS01010) VAR(ZCMD) VAL(10)                                               
FIELD(ZPS01011) VAR(ZCMD) VAL(11)                                               
FIELD(ZPS01012) VAR(ZCMD) VAL(S)                                                
FIELD(ZPS01013) VAR(ZCMD) VAL(H)                                                
FIELD(ZPS01014) VAR(ZCMD) VAL(I)                                                
FIELD(ZEXI) VAR(ZCMD) VAL(X) DEPTH(2) IMAGE(ISPEXIT) PLACE(L)                   
FIELD(ZEXX) VAR(ZCMD) VAL(X)                                                    
)END                                                                            
/* 5694-A01 (C) COPYRIGHT IBM CORP 1982, 2001 */                                
/* ISPDTLC Release: 5.2.  Level: PID                                  */        
/* z/OS 01.02.00.  Created - Date: 10 Mar 2001, Time: 14:17           */        
./ ENDUP                                                                        
@#                                                                              
//*****************************************************************             
//* UPDATE TCPPARMS WITH REQUIRED MEMBERS                                       
//*****************************************************************             
//UTCPPR21 EXEC PGM=IEBUPDTE,PARM=NEW,REGION=4M,COND=(0,NE)                     
//SYSUT2   DD  DSN=SYS1.TCPPARMS,DISP=SHR,                                      
//             UNIT=SYSALLDA,VOL=SER=SY2PKA                                     
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DATA,DLM=@#                                                      
./ ADD NAME=PROFILE,LEVEL=00,SOURCE=0,LIST=ALL                                  
;                                                                               
; PROFILE.TCPIP                                                                 
; =============                                                                 
;                                                                               
; This is a sample configuration file for the TCPIP address space               
;                                                                               
; SMP/E name: EZAEB025, alias SAMPPROF in target library SEZAINST               
;                                                                               
; COPYRIGHT = NONE                                                              
;                                                                               
; Notes:                                                                        
;                                                                               
; - The device configuration, home and routing statements MUST be               
;   changed to match your hardware and software configuration.                  
;                                                                               
; - Lines beginning with semi-colons are comments.  To use a line               
;   for your configuration, remove the semi-colon.                              
;                                                                               
; - For more information about this file, see the IP Configuration Guide        
;                                                                               
; ======================================================================        
; General TCP/IP address space configuration                                    
; ======================================================================        
;                                                                               
; ARPAGE: Specifies the number of minutes between creation or                   
;   revalidation of an LCS ARP table entry and the deletion of the              
;   entry.                                                                      
;                                                                               
ARPAGE 20                                                                       
;                                                                               
;                                                                               
; GLOBALCONFIG: Provides settings for the entire TCP/IP stack                   
;                                                                               
GLOBALCONFIG NOTCPIPSTATISTICS                                                  
;                                                                               
; IPCONFIG: Provides settings for the IP layer of TCP/IP.                       
;                                                                               
; Example IPCONFIG for single stack/single system:                              
;                                                                               
IPCONFIG DATAGRAMFWD VARSUBNETTING SYSPLEXROUTING                               
;                                                                               
; Example IPCONFIG for automatic activation of inter-stack dynamic XCF          
;   and Same Host (IUTSAMEH) links                                              
;                                                                               
; IPCONFIG DYNAMICXCF 201.1.10.10 255.255.255.0 2                               
;                                                                               
;                                                                               
; SOMAXCONN: Specifies maximum length for the connection request queue          
;   created by the socket call listen().                                        
;                                                                               
SOMAXCONN 10                                                                    
;                                                                               
;                                                                               
; TCPCONFIG: Provides settings for the TCP layer of TCP/IP.                     
;            RESTRICTLOWPORTS limits access to ports below 1024                 
;            to APF authorized or superuser applications.                       
;                                                                               
TCPCONFIG TCPSENDBFRSIZE 64K TCPRCVBUFRSIZE 64K                 ;CHG            
;TCPCONFIG TCPSENDBFRSIZE 16K TCPRCVBUFRSIZE 16K SENDGARBAGE FALSE              
TCPCONFIG RESTRICTLOWPORTS                                                      
;                                                                               
;                                                                               
; UDPCONFIG: Provides settings for the UDP layer of TCP/IP                      
;            RESTRICTLOWPORTS limits access to ports below 1024                 
;            to APF authorized or superuser applications.                       
;                                                                               
UDPCONFIG RESTRICTLOWPORTS                                                      
;                                                                               
;                                                                               
; ======================================================================        
; Hardware definitions                                                          
; ======================================================================        
;                                                                               
; DEVICE: Defines name (and sometimes device number) for various types          
;   of network devices                                                          
; LINK: Defines a network interface to be associated with a particular          
;   device                                                                      
;                                                                               
;                                                                               
; DEVICE and LINK for CTC devices                                               
;                                                                               
;   DEVICE  CTC1    CTC  D00  AUTORESTART                                       
;   LINK    CTCD00  CTC  0  CTC1                                                
;                                                                               
; DEVICE and LINK for HYPERchannel A220 devices:                                
;                                                                               
;   DEVICE  HCH1    HCH  E00  AUTORESTART                                       
;   LINK    HCHE00  HCH  1  HCH1                                                
;                                                                               
; DEVICE and LINK for LAN Channel Station and OSA devices:                      
;   DEVICE: Defines name and hexadecimal device number for an IBM 8232          
;     LAN channel station (LCS) device, and IBM 3172 Interconnect               
;     Controller, an IBM 2216 Multiaccess Connector Model 400,                  
;     an IBM FDDI, Ethernet, or Token Ring OSA, or an IBM ATM OSA-2             
;     in LAN emulation mode                                                     
;   LINK: Defines a network interface link associated with an LCS               
;     device; may be for Ethernet Network, Token-Ring Network or                
;     PC Network, or FDDI.                                                      
;                                                                               
;   Example: LCS1 is a 3172 model 1 with a Token Ring and Ethernet              
;    adapter                                                                    
;                                                                               
;     DEVICE  LCS1  LCS  BA0  AUTORESTART                                       
;     LINK    TR1   IBMTR  0  LCS1                                              
;     LINK    ETH1  ETHERNET  1  LCS1                                           
;                                                                               
;   Example: LCS2 is a 3172 model 2 with a FDDI adapter                         
;                                                                               
;     DEVICE  LCS2   LCS  BE0  AUTORESTART                                      
;     LINK    FDDI1  FDDI  0  LCS2                                              
;                                                                               
; DEVICE and LINK for MPCIPA QDIO Devices:                                      
;                                                                               
;   Example: MPCIPA1 is either an IBM OSA-Express Gigabit Ethernet              
;    or QDIO Fast Ethernet adapter                                              
;                                                                               
;   DEVICE  MPCIPA1     MPCIPA  NONROUTER AUTORESTART                           
;   LINK    MPCIPALINK1 IPAQENET  MPCIPA1                                       
;                                                                               
;   Example: MPCIPA2 is either an IBM OSA-Express Gigabit Ethernet              
;    or QDIO Fast Ethernet adapter, configured as the PRIMARY router            
;                                                                               
;   DEVICE  MPCIPA2     MPCIPA  PRIROUTER AUTORESTART                           
;   LINK    MPCIPALINK2 IPAQENET  MPCIPA2                                       
;                                                                               
; DEVICE and LINK for MPCPTP devices:                                           
;                                                                               
;   DEVICE  MPCPTP1    MPCPTP   AUTORESTART                                     
;   LINK    MPCPTPLINK MPCPTP   MPCPTP1                                         
;                                                                               
; DEVICE and LINK for CLAW devices:                                             
;                                                                               
;   DEVICE  RS6K    CLAW  6B2  HOST  PSCA  NONE  26 26 AUTORESTART              
;   LINK    IPLINK1 IP  0  RS6K                                                 
;                                                                               
; DEVICE and LINK for SNA LU0 links:                                            
;                                                                               
;   DEVICE  SNALU0  SNAIUCV   SNALINK  LU000000  SNALINK  AUTORESTART           
;   LINK    SNA1    SAMEHOST  1  SNALU0                                         
;                                                                               
; DEVICE and LINK for SNA LU 6.2 links:                                         
;                                                                               
;   DEVICE  SNALU621 SNALU62 SNAPROC AUTORESTART                                
;   LINK    SNA2     SAMEHOST  1  SNALU621                                      
;                                                                               
; DEVICE and LINK for X.25 NPSI connections:                                    
;                                                                               
;   DEVICE  X25DEV   X25NPSI  TCPIPX25  AUTORESTART                             
;   LINK    X25LINK  SAMEHOST  1  X25DEV                                        
;                                                                               
; DEVICE and LINK for 3745/46 Channel DLC Devices:                              
;                                                                               
;   DEVICE  CDLC1    CDLC  C00 AUTORESTART                                      
;   LINK    CDLCLINK CDLC  1  CDLC1                                             
;                                                                               
; DEVICE and LINK for MPC OSA Fast Ethernet Devices:                            
;                                                                               
;   DEVICE  MENET1   MPCOSA   AUTORESTART                                       
;   LINK    ENETLINK OSAENET 0 MENET1                                           
;                                                                               
; DEVICE and LINK for MPC OSA FDDI Devices:                                     
;                                                                               
;   DEVICE  MFDDI1   MPCOSA   AUTORESTART                                       
;   LINK    FDDILINK OSAFDDI 0 MFDDI1                                           
;                                                                               
;                                                                               
; CISCO CIP  ;CHG                                                               
;                                                                               
; on SM02SYSB using dr4                                                         
; DEVICE CISCO CLAW  AD0  SM02DR4 CIPTCP NONE 20 20 4096 4096 ;CHG              
; LINK SM02CIP IP 0 CISCO  ;CHG                                                 
;                                                                               
; on SM03SYSW using dr4                                                         
 DEVICE CISCO  CLAW  AD0  SM03DR4 CIPTCP NONE 20 20 4096 4096 ;CHG              
 LINK SM03CIP IP 0 CISCO  ;CHG                                                  
;                                                                               
;                                                                               
; ----------------------------------------------------------------------        
; Virtual device definitions                                                    
; ----------------------------------------------------------------------        
;                                                                               
; DEVICE and LINK for Virtual Devices (VIPA):                                   
;                                                                               
;   DEVICE  VDEV1   VIRTUAL  0                                                  
;   LINK    VLINK1  VIRTUAL  0  VDEV1                                           
;                                                                               
; Dynamic Virtual Devices can be defined on this system.  This system           
; can serve as backup for Dynamic Virtual Devices on other systems.             
; A predefined range will allow Dynamic Virtual Devices to be defined           
; by IOCTL or Bind requests.                                                    
;                                                                               
; VIPADYNAMIC                                                                   
;   Define two dynamic VIPAs on this stack:                                     
;   VIPADEFINE 255.255.255.192 201.2.10.11 201.2.10.12                          
;                                                                               
;   Define this stack as backup for these dynamic VIPAs on                      
;   other TCP/IP stacks:                                                        
;   VIPABACKUP 100             201.2.10.13 201.2.10.14                          
;   VIPABACKUP  80             201.2.10.21 201.2.10.22                          
;   VIPABACKUP  60             201.2.10.31 201.2.10.33                          
;   VIPABACKUP  40             201.2.10.32 201.2.10.34                          
;                                                                               
;   VIPARANGE DEFINE 255.255.255.192 201.2.10.192                               
; ENDVIPADYNAMIC                                                                
;                                                                               
; ----------------------------------------------------------------------        
; ATM hardware definitions                                                      
; ----------------------------------------------------------------------        
;                                                                               
; ATMLIS: Describes characteristics of an ATM logical IP subnet (LIS).          
;                                                                               
; DEVICE and LINK for ATM devices: (See below)                                  
;                                                                               
; ATMPVC: Describes a permanent virtual circuit (PVC) to be used by an          
;   ATM link.                                                                   
;                                                                               
; ATMARPSV: Designates the ATMARP server that will resolve ATMARP               
;   requests for a logical IP subnet (LIS).                                     
;                                                                               
; ATMLIS   LIS1   9.67.100.0 255.255.255.0                                      
; DEVICE   OSA1   ATM  PORTNAME  PORT1                                          
; LINK     LINK1  ATM  OSA1  LIS LIS1                                           
; ATMPVC   PVC1   LINK1                                                         
; ATMARPSV ARPSV1 LIS1 PVC PVC1                                                 
;                                                                               
;                                                                               
; ----------------------------------------------------------------------        
; Other device statements                                                       
; ----------------------------------------------------------------------        
;                                                                               
; START: Starts a device that is currently stopped.                             
;                                                                               
; START LCS1                                                                    
; START LCS2                                                                    
  START CISCO  ;CHG                                                             
;                                                                               
;                                                                               
; TRANSLATE: Indicates a relationship between an internet address and           
;   the network address on a specified link.                                    
;                                                                               
; TRANSLATE                                                                     
;   9.67.43.110   FDDI    FF0000006702   FDDI1                                  
;   9.37.84.49    HCH     FF0000005555   HCHE00                                 
;                                                                               
;                                                                               
; ======================================================================        
; HOME addresses                                                                
; ======================================================================        
;                                                                               
; HOME: Provides the list of home IP addresses and associated link names        
;                                                                               
;   - The LOOPBACK statement of 14.0.0.0 should only be used if the             
;     installation has applications that require this old loopback              
;     address.  The current stack uses 127.0.0.1 as the loopback                
;     address.                                                                  
;                                                                               
  HOME                                                                          
;  172.19.154.192 SM02CIP      ; CHG                                            
   172.19.154.193 SM03CIP      ; CHG                                            
;  14.0.0.0       LOOPBACK                                                      
;  130.50.75.1    TR1                                                           
;  193.5.2.1      ETH1                                                          
;  9.67.43.110    FDDI1                                                         
;  193.7.2.1      SNA1                                                          
;  9.67.113.80    CTCD00                                                        
;  9.37.84.49     HCHE00                                                        
;  9.67.113.81    MPCIPALINK1                                                   
;  9.67.113.82    MPCPTPLINK                                                    
;  9.67.113.83    MPCIPALINK2                                                   
;  9.67.114.02    IPLINK1                                                       
;  9.67.43.03     SNA2                                                          
;  9.67.115.85    X25LINK                                                       
;  9.67.116.86    VLINK1                                                        
;  9.67.117.87    CDLCLINK                                                      
;  9.67.100.80    LINK1                                                         
;  9.37.112.13    ENETLINK                                                      
;  9.37.112.14    FDDILINK                                                      
;                                                                               
;                                                                               
; PRIMARYINTERFACE: Specifies which link is designated as the default           
;   local host for use by the GETHOSTID() function.                             
;                                                                               
;   - If PRIMARYINTERFACE is not specified, then the first link in              
;     the HOME statement is the primary interface, as usual.                    
;                                                                               
; PRIMARYINTERFACE TR1                                                          
; PRIMARYINTERFACE SM02CIP  ; CHG                                               
  PRIMARYINTERFACE SM03CIP  ; CHG                                               
;                                                                               
; ======================================================================        
; Routing configuration                                                         
; ======================================================================        
; **********************************************************************        
; *  Use either BEGINRoutes / ROUTE / ROUTE DEFAULT / ENDRoutes                 
; *       (z/OS 1.2 and above)                                                  
; *   or  GATEWAY / (route definition) / DEFAULTNET                             
; **********************************************************************        
; ======================================================================        
; ----------------------------------------------------------------------        
; Static routing                                                                
; ----------------------------------------------------------------------        
;                                                                               
; BEGINRoutes: Defines static routes to the IP route table.                     
;                                                                               
 BEGINRoutes                                                                    
;                                                                               
; Direct Routes - Routes that are directly connected to my interfaces.          
;                                                                               
;      Destination Subnet Mask   First Hop    Link Name Packet Size             
;                                                                               
;ROUTE 130.50.75.0 255.255.255.0 =            TR1       MTU 2000                
;ROUTE 193.5.2.0/24              =            ETH1      MTU 1500                
;ROUTE 9.67.43.0   255.255.255.0 =            FDDI1     MTU 4000                
;ROUTE 193.7.2.2   HOST          =            SNA1      MTU 2000                
;ROUTE 172.19.154.0  255.255.255.0  =         SM02CIP   MTU 4096 ;CHG           
 ROUTE 172.19.154.0  255.255.255.0  =         SM03CIP   MTU 4096 ;CHG           
;                                                                               
;                                                                               
; Indirect Routes - Routes that are reachable through routers on my             
;                   network.                                                    
;                                                                               
;      Destination Subnet Mask   First Hop    Link Name Packet Size             
;                                                                               
;ROUTE 193.12.2.0  255.255.255.0 130.50.75.10 TR1       MTU 2000                
;ROUTE 10.5.6.4    HOST          193.5.2.10   ETH1      MTU 1500                
;                                                                               
; Default Route - All packets to an unknown destination are routed              
;                 through this route.                                           
;                                                                               
;      Destination Subnet Mask   First Hop    Link Name Packet Size             
;                                                                               
;ROUTE DEFAULT                   9.67.43.99   FDDI1     MTU DEFAULTSIZE         
;ROUTE DEFAULT                 172.19.154.8   SM02CIP   MTU 4096 REPL;CHG       
 ROUTE DEFAULT                 172.19.154.8   SM03CIP   MTU 4096 REPL;CHG       
 ENDRoutes                                                                      
;                                                                               
;                                                                               
; GATEWAY     ; CHG                                                             
;                                                                               
; Direct Routes - Routes that are directly connected to my interfaces.          
; Network  First Hop  Link Name Packet Size  Subnet Mask  Subnet Value          
;                                                                               
; 172.19       =          SM02CIP   4096      0.0.255.0    0.0.154.0 ;CHG       
; DEFAULTNET 172.19.154.8 SM02CIP   4096      0    ;CHG                         
;                                                                               
; ----------------------------------------------------------------------        
; Dynamic routing                                                               
; ----------------------------------------------------------------------        
;                                                                               
; BSDROUTINGPARMS: Defines the characteristics of each link defined at          
;   the host over which OROUTED will send routing information to                
;   adjacent routers running the RIP protocl and which NCPROUTE will            
;   send transport PDUs to client NCPs.                                         
;                                                                               
;   - OMPROUTE is the recommended routing daemon.  It does not use              
;     BSDROUTINGPARMS.                                                          
;                                                                               
;   - OROUTED users must define BSDROUTINGPARMS.                                
;                                                                               
;   - Use of the GATEWAY statement (static routes) with the OMPROUTE            
;     OROUTED routing daemons is not recommended.                               
;                                                                               
; BSDROUTINGPARMS TRUE                                                          
;  Link name      MTU    Cost metric  Subnet Mask    Dest address               
;   TR1          2000         0       255.255.255.0     0                       
;   ETH1         1500         0       255.255.255.0     0                       
;   FDDI1        4000         0       255.255.255.0     0                       
;   VLINK1    DEFAULTSIZE     0       255.255.255.0     0                       
;   CTCD00       65527        0       255.255.255.0  9.67.113.90                
; ENDBSDROUTINGPARMS                                                            
;                                                                               
;                                                                               
; ======================================================================        
; Application configuration                                                     
; ======================================================================        
;                                                                               
; AUTOLOG: Supplies TCPIP with the procedure names to start and the             
;  timeout value to use for a hung procedure during AUTOLOG.                    
;                                                                               
  AUTOLOG 5                                                                     
;  FTPD JOBNAME FTPD1       ; FTP Server                                        
   FTP  JOBNAME FTP1        ; FTP Server ;CHG                                   
;  LPSERVE                  ; LPD Server                                        
;  NAMED                    ; Domain Name Server                                
;  NCPROUT                  ; NCPROUTE Server                                   
;  OROUTED                  ; OROUTED Server                                    
;  OSNMPD                   ; SNMP Agent Server                                 
;  PORTMAP                  ; Portmap Server (SUN 3.9)                          
;  PORTMAP JOBNAME PORTMAP1 ; USS Portmap Server (SUN 4.0)                      
;  RXSERVE                  ; Remote Execution Server                           
;  SMTP                     ; SMTP Server                                       
;  SNMPQE                   ; SNMP Client                                       
;  TCPIPX25                 ; X25 Server                                        
  ENDAUTOLOG                                                                    
;                                                                               
;                                                                               
; PORT: Reserves a port for specified job names                                 
;                                                                               
;   - A port that is not reserved in this list can be used by any user.         
;     If you have TCP/IP hosts in your network that reserve ports               
;     in the range 1-1023 for privileged applications, you should               
;     reserve them here to prevent users from using them.                       
;     The RESTRICTLOWPORTS option on TCPCONFIG and UDPCONFIG will also          
;     prevent unauthorized applications from accessing unreserved               
;     ports in the 1-1023 range.                                                
;                                                                               
;   - A PORT statement with the optional keyword SAF followed by a              
;     1-8 character name can be used to reserve a PORT and control              
;     access to the PORT with a security product such as RACF.                  
;     For port access control, the full resource name for the security          
;     product authorization check is constructed as follows:                    
;     EZB.PORTACCESS.sysname.tcpname.safname                                    
;     where:                                                                    
;       EZB.PORTACCESS is a constant                                            
;       sysname is the MVS system name (substitute your sysname)                
;       tcpname is the TCPIP jobname (substitute your jobname)                  
;       safname is the 1-8 character name following the SAF keyword             
;                                                                               
;     When PORT access control is used, the TCP/IP application                  
;     requiring access to the reserved PORT must be running under a             
;     USERID that is authorized to the resource. The resources                  
;     are defined in the SERVAUTH class.                                        
;                                                                               
;     For an example of how the SAF keyword can be used to enhance              
;     security, see the definition below for the FTP data PORT 20               
;     with the SAF keyword. This definition reserves TCP PORT 20 for            
;     any jobname (the *) but requires that the FTP user be permitted           
;     by the security product to the resource:                                  
;     EZB.PORTACCESS.sysname.tcpname.FTPDATA in the SERVAUTH class.             
;                                                                               
;   - The BIND keyword is used to force a generic server (one that              
;     binds to INADDR_ANY) to bind to the specific IP address that              
;     is specified following the BIND keyword. This capability could            
;     be used, for example, to allow OE telnet and telnet 3270 servers          
;     to both bind to TCP port 23. The IP address that follows bind             
;     must be in IPv4 dotted decimal format and may be any valid                
;     address for the host including VIPA and dynamic VIPA addresses.           
;                                                                               
;   The special jobname of OMVS indicates that the PORT is reserved             
;   for any application with the exception of those that use the Pascal         
;   API.                                                                        
;                                                                               
;   The special jobname of * indicates that the PORT is reserved                
;   for any application, including Pascal API socket applications.              
;                                                                               
;   The special jobname of RESERVED indicates that the PORT is                  
;   blocked. It will not be available to any application.                       
;                                                                               
;   The special jobname of INTCLIEN indicates that the PORT is                  
;   reserved for internal stack use.                                            
;                                                                               
;                                                                               
PORT                                                                            
     7 UDP MISCSERV            ; Miscellaneous Server - echo                    
     7 TCP MISCSERV            ; Miscellaneous Server - echo                    
     9 UDP MISCSERV            ; Miscellaneous Server - discard                 
     9 TCP MISCSERV            ; Miscellaneous Server - discard                 
    19 UDP MISCSERV            ; Miscellaneous Server - chargen                 
    19 TCP MISCSERV            ; Miscellaneous Server - chargen                 
    20 TCP *  NOAUTOLOG        ; FTP Server                                     
;   20 TCP *  NOAUTOLOG SAF FTPDATA ; FTP Server                                
;   21 TCP FTPD1               ; FTP Server   ;CHG                              
    21 TCP FTP1                ; FTP Server   ;CHG                              
;   23 TCP INTCLIEN            ; Telnet 3270 Server ;not supported 1.9          
    23 TCP TN3270              ; Telnet 3270 Server                             
;   23 TCP INETD1 BIND 9.67.113.3 ; OE telnet server                            
    25 TCP SMTP                ; SMTP Server                                    
    53 TCP NAMED               ; Domain Name Server                             
    53 UDP NAMED               ; Domain Name Server                             
   111 TCP PORTMAP             ; Portmap Server (SUN 3.9)                       
   111 UDP PORTMAP             ; Portmap Server (SUN 3.9)                       
;  111 TCP PORTMAP1            ; Unix Portmap Server (SUN 4.0)                  
;  111 UDP PORTMAP1            ; Unix Portmap Server (SUN 4.0)                  
   135 UDP LLBD                ; NCS Location Broker                            
   161 UDP OSNMPD              ; SNMP Agent                                     
   162 UDP SNMPQE              ; SNMP Query Engine                              
   512 TCP RXSERVE             ; Remote Execution Server                        
   514 TCP RXSERVE             ; Remote Execution Server                        
;  512 TCP * SAF OREXECD       ; OE Remote Execution Server                     
;  514 TCP * SAF ORSHELLD      ; OE Remote Shell Server                         
   515 TCP LPSERVE             ; LPD Server                                     
   520 UDP OROUTED             ; OROUTED Server                                 
   580 UDP NCPROUT             ; NCPROUTE Server                                
   750 TCP MVSKERB             ; Kerberos                                       
   750 UDP MVSKERB             ; Kerberos                                       
   751 TCP ADM@SRV             ; Kerberos Admin Server                          
   751 UDP ADM@SRV             ; Kerberos Admin Server                          
  1933 TCP ILMTSRVR            ; IBM LM MT Agent                                
  1934 TCP ILMTSRVR            ; IBM LM Appl Agent                              
  3000 TCP CICSTCP             ; CICS Socket                                    
;                                                                               
;                                                                               
; PORTRANGE: Reserves a range of ports for specified jobnames.                  
;                                                                               
;   In a common INET (CINET) environment, the port range indicated by           
;   the INADDRANYPORT and INADDRANYCOUNT in your BPXPRMxx parmlib member        
;   should be reserved for OMVS.                                                
;                                                                               
;   The special jobname of OMVS indicates that the PORTRANGE is reserved        
;   for ANY OE socket application.                                              
;                                                                               
;   The special jobname of * indicates that the PORTRANGE is reserved           
;   for any socket application, including Pascal API socket                     
;   applications.                                                               
;                                                                               
;   The special jobname of RESERVED indicates that the PORTRANGE is             
;   blocked. It will not be available to any application.                       
;                                                                               
;   The SAF keyword is used to restrict access to the PORTRANGE to              
;   authorized users. See the use of SAF on the PORT statement above.           
;                                                                               
;                                                                               
;   PORTRANGE 4000 1000 TCP OMVS                                                
;   PORTRANGE 4000 1000 UDP OMVS                                                
;   PORTRANGE 2000 3000 TCP RESERVED                                            
;   PORTRANGE 5000 6000 TCP * SAF RANGE1                                        
;                                                                               
; SACONFIG: Configures the TCP/IP SNMP subagent                                 
;                                                                               
SACONFIG ENABLED COMMUNITY public AGENT 161                                     
;                                                                               
;                                                                               
; ----------------------------------------------------------------------        
; Configure Network Access Control                                              
; ----------------------------------------------------------------------        
;     Network access contol can be used to restrict the destinations            
;     that TCP/IP users are allowed to send to. The NETACCESS                   
;     group contains a list of IP destinations that may be subnetworks          
;     or specific hosts. The subnetwork mask can be specified as a              
;     number of significant bits or in dotted decimal notation.                 
;                                                                               
;     A 1-8 character name follows the IP address and subnet mask and           
;     is used as the right-most qualifier in the security product               
;     resource name.                                                            
;                                                                               
;     For network access control, the full resource name for the                
;     security product authorization check is constructed as follows:           
;                                                                               
;     EZB.NETACCESS.sysname.tcpname.resname                                     
;     where:                                                                    
;       EZB.NETACCESS is a constant                                             
;       sysname is the MVS system name (substitute your sysname)                
;       tcpname is the TCPIP jobname (substitute your jobname)                  
;       resname is the 1-8 character name following the subnet mask.            
;                                                                               
;     When network access control is used, the TCP/IP application               
;     requiring access to the restricted subnet or host must be running         
;     under a USERID that is authorized to the resource. The resources          
;     are defined in the SERVAUTH class. See the EZARACF sample for             
;     examples of the RACF definitions.                                         
;                                                                               
;NETACCESS                                                                      
;192.168.0.0/16            SUBNET1     ; Subnet address                         
;192.168.113.19/32         HOST1       ; Specific host address                  
;192.168.113.0 255.255.255.0   SUBNET2 ; Subnet address                         
;192.168.112.0 255.255.248.0   SUBNET3 ; Subnet address                         
;DEFAULT 0                 DEFZONE     ; Optional Default security zone         
;ENDNETACCESS                                                                   
;                                                                               
;                                                                               
;                                                                               
; ======================================================================        
; Diagnostic data statements                                                    
; ======================================================================        
;                                                                               
; - For optimum performance, use of tracing should be limited to when           
;   required for problem analysis.                                              
;                                                                               
; ITRACE: Controls TCP/IP run-time tracing                                      
;                                                                               
; ITRACE ON CONFIG 1                                                            
; ITRACE OFF SUBAGENT                                                           
;                                                                               
;                                                                               
; PKTTRACE: Controls the packet trace facility in TCP/IP.                       
;                                                                               
; PKTTRACE ABBREV=200 LINKNAME=TR1 PROT=ICMP IP=*                               
;   SRCPORT=5000 DESTPORT=161                                                   
;                                                                               
;                                                                               
; SMFCONFIG: Provides SMF logging for Telnet, FTP, TCP API and TCP              
;   stack activity.                                                             
;                                                                               
;     - The SMF record types for TCP/IP records are 118 and 119.                
;                                                                               
; For Type 118 records specify:                                                 
;                                                                               
; SMFCONFIG TCPINIT TCPTERM FTPCLIENT TN3270CLIENT TCPIPSTATISTICS              
;                                                                               
; For Type 119 records specify:                                                 
;                                                                               
; SMFCONFIG                                                                     
;   TYPE119 TCPINIT TCPTERM FTPCLIENT TN3270CLIENT TCPIPSTATISTICS              
;           IFSTATISTICS PORTSTATISTICS TCPSTACK UDPTERM                        
;                                                                               
; For all Type 118 and Type 119 records specify:                                
;                                                                               
; SMFCONFIG TCPINIT TCPTERM FTPCLIENT TN3270CLIENT TCPIPSTATISTICS              
;   TYPE119 TCPINIT TCPTERM FTPCLIENT TN3270CLIENT TCPIPSTATISTICS              
;           IFSTATISTICS PORTSTATISTICS TCPSTACK UDPTERM                        
;                                                                               
;                                                                               
; SMFPARMS: Logs the use of TCP by applications using SMF log records.          
;   However, use of the SMFCONFIG statement is recommended instead.             
;                                                                               
;                                                                               
; ======================================================================        
; Other statements                                                              
; ======================================================================        
;                                                                               
; DELETE: Removes an ATMARPSV, ATMLIS, ATMPVC, device, link, port or            
;   portrange.  This statement is typically done via an obey file, not          
;   in an initial profile.                                                      
;                                                                               
; STOP: Stops a device.  If used, this statement is typically put in            
;   an obey file, not in an initial profile.                                    
;                                                                               
; INCLUDE: Causes another data set that contains profile configuration          
;   statements to be included at this point.                                    
;                                                                               
;                                                                               
; ----------------------------------------------------------------------        
./ ADD NAME=TNPROF,LEVEL=00,SOURCE=0,LIST=ALL                                   
; This is a sample configuration file for the TN3270E Telnet server             
;                                                                               
; TNPROF is in target library SEZAINST                                          
;                                                                               
; COPYRIGHT = NONE                                                              
;                                                                               
; Notes:                                                                        
;                                                                               
; - The BEGINVTAM section MUST be changed to match your VTAM                    
;   configuration.                                                              
;                                                                               
; - Lines beginning with semi-colons are comments.  To use a line               
;   for your configuration, remove the semi-colon.                              
;                                                                               
; - For more information about this file, see the IP Configuration              
;   Guide and IP Configuration Reference.                                       
                                                                                
; ---------------------------------------------------------------------         
; Optional Global Configuration affects all ports                               
; ---------------------------------------------------------------------         
                                                                                
TelnetGlobals                                                                   
  LUSESSIONPEND        ; On termination of a Telnet server connection,          
                       ; the user will redrive application lookup               
                       ; instead of having the connection dropped.              
                                                                                
  MSG07                ; Sends a USS error message to the client if an          
                       ; error occurs during session establishment              
                       ; instead of dropping the connection.                    
  TimeMark 14400       ; No IP activity for 4 hours, send timemark.             
  ScanInterval 3600    ; Check for IP activity every 1 hour                     
  CHECKCLIENTCONN 3    ; User initiated Keepalive. Existing connections         
                       ; have 3 seconds to respond.                             
  ; Define logon mode tables to be the defaults shipped with the                
  ; latest level of VTAM                                                        
  TELNETDEVICE 3278-3-E NSX32703 ; 32 line screen -                             
                                 ; default of NSX32702 is 24                    
  TELNETDEVICE 3279-3-E NSX32703 ; 32 line screen -                             
                                 ; default of NSX32702 is 24                    
  TELNETDEVICE 3278-4-E NSX32704 ; 48 line screen -                             
                                 ; default of NSX32702 is 24                    
  TELNETDEVICE 3279-4-E NSX32704 ; 48 line screen -                             
                                 ; default of NSX32702 is 24                    
  TELNETDEVICE 3278-5-E NSX32705 ; 132 column screen-                           
                                 ; default of NSX32702 is 80                    
  TELNETDEVICE 3279-5-E NSX32705 ; 132 column screen -                          
                                 ; default of NSX32702 is 80                    
  CodePage TNSTD TNSTD           ; Linemode use TN standard translation         
                                                                                
  ; Inactive 10800     ; No SNA terminal activity for 3 hours, drop.            
  ; KeepInactive 10800 ; No SNA session on KeepOpen ACB for 3 hours,            
  ;                    ; drop.                                                  
  ; PrtInactive 10800  ; No SNA printer activity for 3 hours, drop.             
  ; MaxReceive  10000  ; Limit input record length lower than 65K               
  ; MaxReqSess     50  ; Allow up to 50 new sessions in 10 seconds              
  ; MaxRuChain   1000  ; Allow for Printer chains but limit max                 
  ; MaxVTAMSendQ  100  ; Allow 100 RPLs to queue to VTAM                        
  ; SMFINIT TYPE119    ; SMF type 119 record subtype 20                         
  ; SMFTERM TYPE119    ; SMF type 119 record subtype 21                         
  ; Format Long        ; Ensure display format is always long                   
  ; TCPIPJOBNAME TCPIP ; Set affinity to a single TCPIP stack.                  
  ;                    ; Must be set at startup and can not be changed.         
  ; TNSAConfig         ; Start up TN SNMP subagent                              
  ;    Enabled         ; Subagent must be enabled                               
  ;    Agent 161       ; Specify agent port to contact                          
  ;    Cachetime 30    ; Rebuild MIB info if older than 30 seconds              
  ; CRLLDAPServer      ; Define CRL LDAP server for secureport                  
  ;   CRLLDAP.RALEIGH.IBM.COM 389                                               
  ; ENDCRLLDAPSERVER                                                            
EndTelnetGlobals                                                                
                                                                                
; ---------------------------------------------------------------------         
; Required Port Configuration affects the specified port                        
; ---------------------------------------------------------------------         
                                                                                
TelnetParms            ; Standard TN3270E Telnet server port                    
  Port 23                                                                       
  ; WLMClusterName     ; Define WLM name for this port                          
  ;   TN3270E          ; Must have TCPIPJOBNAME coded to use WLM                
  ; EndWLMClusterName                                                           
EndTelnetParms                                                                  
                                                                                
; TelnetParms          ; DBCS port and destination IP address                   
;   Port 23,9.10.11.12                                                          
;   DBCSTransform      ; Use DBCS transform to mimic SNA                        
;   DBCSTrace          ; Get additional trace from DBCS                         
; EndTelnetParms                                                                
                                                                                
; TelnetParms          ; ATTLS defined secure port                              
;   TTLSPort 2023      ;                                                        
;   ConnType Any       ; Client chooses secure or nonsecure connection.         
;   NACUserid  User1   ; Set up Network Access based on User1                   
; EndTelnetParms                                                                
                                                                                
; TelnetParms          ; TN defined secure port                                 
;   Secureport 992     ; Default ConnType is Secure                             
;   Keyring SAF TNsafkeyring  ; Must be defined in Security server.             
;   ClientAuth SAFCERT ; Do certificate/userid client authentication            
;   Encryption         ; Specify allowed ciphers and order                      
;     SSL_NULL_MD5                                                              
;     SSL_3DES_SHA                                                              
;     SSL_DES_SHA                                                               
;   EndEncryption                                                               
;   SSLtimeout  10     ; Wait 10 seconds for Handshake completion               
;   SSLv2              ; Allow SSLv2 security                                   
; EndTelnetParms                                                                
                                                                                
 ;---------------------------------------------------------------------         
 ; Required Mapping definitions                                                 
 ;---------------------------------------------------------------------         
                                                                                
BeginVTAM              ; Mapping for basic and TTLS ports.                      
  Port 23  ; 23,9.10.11.12                                                      
  DEFAULTLUS           ; Define LUs to be used for general users.               
    ;T000AA00..T111ZZFB..FNNNAAXB ;CHG                                          
    TCPE0001..TCPE0099  ;CHG                                                    
  ENDDEFAULTLUS                                                                 
  LuGroup LugDBCS      ; LUs for DBCS                                           
    DLU001..DLU250     ; Maximum 250 DBCS connections allowed                   
  EndLuGroup                                                                    
; DEFAULTAPPL TSO ;CHG ; Default application for all TN3270(E) clients          
  LINEMODEAPPL TSO     ; Send all line-mode terminals directly to TSO.          
  ALLOWAPPL TSO* DISCONNECTABLE                                                 
                       ; Allow all users access to TSO applications.            
                       ; TSO uses unique applications for each session          
                       ; which all begin with TSO.  Use TSO* to cover           
                       ; all TSO sessions.                                      
                       ; If a session is closed, disconnect the user            
                       ; rather than log off the user.                          
  ALLOWAPPL *          ; Allow access to all applications.                      
  USSTCP    EZBTPUST   ; Send out the default TN USS table                      
                                                                                
  LuMap LugDBCS DestIP,9.10.11.12 ; This DestIP uses LugDBCS                    
EndVTAM                                                                         
                                                                                
; BeginVTAM            ; Mapping statements for SecurePorts                     
;   Port 2023 992                                                               
;   DEFAULTLUS         ; Define LUs to be used for general users.               
;     S000AA00..S111ZZFB..FNNNAAXB                                              
;   ENDDEFAULTLUS                                                               
;   DefaultLUsSpec     ; Define LUs for clients that specify LU name.           
;     SP500..SP999                                                              
;   EndDefaultLUsSpec                                                           
;   DEFAULTAPPL TSO  SNA1 ; Default application for all TN3270(E)               
;                      ; clients connecting to SNA1 link.                       
;   LINEMODEAPPL TSO   ; Send all line-mode terminals directly to TSO.          
;                                                                               
;   ALLOWAPPL TSO* DISCONNECTABLE ; Allow all users access to TSO               
;   ALLOWAPPL *        ; Allow access to all other applications.                
;                                                                               
 ; --------------------------------------------------------------------         
 ; SuperSession Logon Manager may do CLSDST Pass to next appl                   
 ; Wait 5 seconds for the session manager bind.                                 
 ; --------------------------------------------------------------------         
;   ALLOWAPPL SuprSess QSESSION,5                                               
;                                                                               
 ; --------------------------------------------------------------------         
 ; Restrict access to the IMS application.                                      
 ; --------------------------------------------------------------------         
;   LuGroup IMSUser2                                                            
;     IM000..IM499                                                              
;   EndLuGroup                                                                  
;   RESTRICTAPPL IMS CertAuth AllowPrinter                                      
;                      ; If the userid was derived from a certificate           
;                      ; do not request a userid/password.                      
;                      ; Printers can not supply a userid/password              
;                      ; so allow printers that request this appl.              
;                      ; Only 3 users can use IMS.                              
;     USER USER1       ; Allow user1 access.                                    
;       LU S111MSAQ    ; Assign USER1 LU TCPIMS01.                              
;     USER USER2*      ; Wildcard user2* accesses the defined LU pool.          
;       LUG IMSUser2   ; Allow 500 LUs                                          
;     USER USER3       ; Allow user3 access from 3 Telnet sessions,             
;                      ; each with a different reserved LU.                     
;       LU S123AB3R LU S456CD9D LU S789EFC3                                     
;                                                                               
;   USSTCP EZBTPUST 9.10.11.24 ; Map USS table to ip address.                   
;   USSTCP EZBTPUST SNA1       ; Map USS table to linkname SNA1.                
;   INTERPTCP EZBTPINT SNA1  ; Interpret table will be used with SNA1.          
 ; --------------------------------------------------------------------         
 ; The first USS table is a 3270 format table for TN3270 mode clients           
 ; that can not accept SCS format data.                                         
 ; The second table is an SCS format used by TN3270E mode clients.              
 ; --------------------------------------------------------------------         
;   USSTCP EZBTPUST,EZBTPSCS ; All other connections                            
;                                                                               
 ; --------------------------------------------------------------------         
 ; Optional ParmsGroup configuration statements affect mapped client            
 ; identifiers.  The list below is not a complete list.                         
 ; Create new ParmsGroups as needed with selected statements and map            
 ; to the appropriate client identifier.                                        
 ; --------------------------------------------------------------------         
;   ParmsGroup PGSample                                                         
;     BinaryLinemode   ; Do not translate linemode ascii.                       
;     ConnType Basic   ; Allow Basic (nonsecure) connections.                   
;     Debug Detail     ; Get detailed debug information.                        
;     ExpressLogon     ; Support the Express Logon function.                    
;     FullDataTrace    ; Trace all data.                                        
;     KeepLU 120       ; Keep the LU associated with the client ID for          
;                      ; 2 minutes.                                             
;     OldSolicitor     ; Put the cursor on the userid request line.             
;     NoRefreshMsg10   ; Do not refresh the MSG10 screen.  Leave blank.         
;     NoSequentialLU   ; Get the first available LU in the group.               
;     SimClientLU      ; Postpone LU assignment until Appl is chosen.           
;     SingleAttn       ; Reduce double ATTN to a single ATTN to VTAM.           
;     SNAExt           ; Support SNA extensions if client capable.              
;     TKOGenLU 5       ; Allow Generic takeover of the connection               
;                      ; after waiting 5 seconds.                               
;     TKOSpecLURecon 5 ; Allow Specific takeover of the connection and          
;                      ; session after waiting 5 seconds.                       
;     NoTN3270E        ; Negotiate down from TN3270E to TN3270 mode.            
;     UnlockKeyboard   ; Specify when to send unlock keyboard to client         
;         AfterRead    ;  - After forwarding a Read command.                    
;         NoTN3270Bind ;  - Do not send clear screen or unlock keyboard         
;                      ;    when the appl bind is received.                     
;   EndParmsGroup                                                               
;                                                                               
 ; --------------------------------------------------------------------         
 ; Set up Debug for a single client                                             
 ; --------------------------------------------------------------------         
;   ParmsGroup PGDebug                                                          
;     Debug Detail Console                                                      
;     FullDataTrace                                                             
;   EndParmsGroup                                                               
;   ParmsMap PGDebug 9.10.11.45 ; Get Debug info for this client.               
;                                                                               
 ; --------------------------------------------------------------------         
 ; DefaultPrt will be used if the printer client does not specify an            
 ; LU name.                                                                     
 ; DefaultPrtSpec will be used when a printer does specify the LU name          
 ; to be used.                                                                  
 ; In either case the printer will immediately establish a session              
 ; with IMS02.                                                                  
 ; --------------------------------------------------------------------         
;   DefaultPrt         ; Printer does not specify an LU name.                   
;     P500..P999                                                                
;   EndDefaultPrt                                                               
;   DEFAULTPRTSPEC     ; Printer specifies the LU name.                         
;     P001..P099                                                                
;   ENDDEFAULTPRTSPEC                                                           
;   PrtDefaultAppl  IMS02 ; Establish a session with IMS02.                     
;                                                                               
 ; --------------------------------------------------------------------         
 ; Define a printer LU group for printers connecting to IP address              
 ; 9.10.11.65 and 9.10.11.66 and 9.10.11.67 and immediately establish           
 ; a session with CICS02.                                                       
 ; --------------------------------------------------------------------         
;   DestIPGroup  DIP6X                                                          
;     9.10.11.65..9.10.11.67                                                    
;   EndDestIPGroup                                                              
;   PrtGroup PrtGrp65                                                           
;     PRT6501..PRT6599                                                          
;   EndPrtGroup                                                                 
;   PrtMap PrtGrp65 DIP6X DefAppl CICS02                                        
;                                                                               
 ; --------------------------------------------------------------------         
 ; Associated Printer setup                                                     
 ; - The user must specify the LU name or LU group to use this LuMap            
 ;   statement.                                                                 
 ; - The printer group is associated with the terminal group.                   
 ; - The terminal logon will default to CICS01.                                 
 ; - The printer logon will default to CICS01.  The PrtDefaultAppl              
 ;   statement is necessary.  The LuMap-DefAppl applies only to the             
 ;   terminal.                                                                  
 ; - Both connections will be affected by the statements coded in               
 ;   ParmsGroup PGDrop.                                                         
 ; --------------------------------------------------------------------         
;   IPGroup  IPASCPRT                                                           
;     9.11.12.0:255.255.255.0                                                   
;   EndIPGroup                                                                  
;   LuGroup  LUGRP1                                                             
;     TCPM0001..TCPM0999                                                        
;     TCPM1001                                                                  
;   ENDLuGroup                                                                  
;   PrtGroup PrtGRP1                                                            
;     PCPM0001..PCPM0999                                                        
;     PCPM1001                                                                  
;   ENDPrtGroup                                                                 
;   ParmsGroup PGDrop                                                           
;     DropAssocPrinter ; Drop printer when terminal dropped.                    
;   EndParmsGroup                                                               
;   LuMap LUGRP1 IPASCPRT Specific DefAppl CICS01 PMAP PGDrop PrtGRP1           
;   PrtDefaultAppl CICS01 IPASCPRT                                              
;                                                                               
 ; --------------------------------------------------------------------         
 ; Set up Performance monitoring based on the client hostname.                  
 ; --------------------------------------------------------------------         
;   HNGroup HNGrpIBM                                                            
;     **.RALEIGH.IBM.COM                                                        
;   EndHNGroup                                                                  
;                                                                               
;   MonitorGroup MonGrp1                                                        
;     Average          ; Collect data for averages                              
;       Buckets        ; Collect transaction counts by time                     
;       Boundary1  25  ; Bucket times are smaller than defaults                 
;       Boundary2  50                                                           
;       Boundary3 100                                                           
;       Boundary4 250                                                           
;     EndMonitorGroup                                                           
;   MonitorMap MonGrp1 HNGrpIBM                                                 
;                                                                               
; EndVTAM                                                                       
./ ADD NAME=TCPDATA,LEVEL=00,SOURCE=0,LIST=ALL                                  
;***********************************************************************        
;                                                                      *        
;   Name of Data Set:     TCPIP.DATA                                   *        
;                                                                      *        
;   COPYRIGHT = NONE.                                                  *        
;                                                                      *        
;   This data, TCPIP.DATA, is used to specify configuration            *        
;   information required by TCP/IP client and server programs.         *        
;                                                                      *        
;                                                                      *        
;   Syntax Rules for the TCPIP.DATA configuration data set:            *        
;                                                                      *        
;   (a) All characters to the right of and including a ; or # will     *        
;       be treated as a comment.                                       *        
;                                                                      *        
;   (b) Blanks and <end-of-line> are used to delimit tokens.           *        
;                                                                      *        
;   (c) The format for each configuration statement is:                *        
;                                                                      *        
;       <SystemName||':'>  keyword  value                              *        
;                                                                      *        
;       where <SystemName||':'> is an optional label that can be       *        
;       specified before a keyword; if present, then the keyword-      *        
;       value pair will only be recognized if the SystemName matches   *        
;       the name of the MVS system.                                    *        
;       SystemName is derived from the MVS image name. Its value should*        
;       be the IEASYSxx parmlib member's SYSNAME= parameter value.     *        
;       The SystemName can be specified by either restartable VMCF     *        
;       or the subsystem definition of VMCF in the IEFSSNxx member of  *        
;       PARMLIB.                                                       *        
;                                                                      *        
;       For SMTP usage use the NJENODENAME statement in the SMTP       *        
;       configuration data set to specify the JES nodename for mail    *        
;       delivery on the NJE network.                                   *        
;                                                                      *        
;***********************************************************************        
;                                                                               
; TCPIPJOBNAME statement                                                        
; ======================                                                        
; TCPIPJOBNAME specifies the name of the started procedure that was             
; used to start the TCPIP address space.    TCPIP is the default for            
; most cases.  However, for applications which use LE services, the             
; lack of a TCPIPJOBNAME statement causes applications that issue               
; __iptcpn() to receive a jobname of NULL, and some of these                    
; application will use INET instead of TCPIP.  Although this presents           
; no problem when running in a single-stack environment, this can               
; potentially cause errors in a multi-stack environment.                        
;                                                                               
; If multiple TCPIP stacks are run on a single system, each stack will          
; require its own copy of this file, each with a different value for            
; TCPIPJOBNAME.                                                                 
;                                                                               
TCPIPJOBNAME TCPIP                                                              
;                                                                               
;                                                                               
; HOSTNAME statement                                                            
; ==================                                                            
; HOSTNAME specifies the TCP host name of this system as it is known            
; in the IP network.  If not specified, the default HOSTNAME will be            
; the name specified by either restartable VMCF or the subsystem                
; definition of VMCF in the IEFSSNxx member of PARMLIB.                         
; If the VMCF name is not available then the IEASYSxx parmlib member's          
; SYSNAME= parameter value will be used.                                        
;                                                                               
; For example, if this TCPIP.DATA data set is shared between 2                  
; systems, OURMVSNAME and YOURMVSNAME, then the following 2 lines               
; will define the HOSTNAME correctly on each system.                            
;                                                                               
; OURMVSNAME:    HOSTNAME  OURTCPNAME                                           
; YOURMVSNAME:   HOSTNAME  YOURTCPNAME                                          
;                                                                               
; No prefix is required if the TCPIP.DATA file is not being shared.             
;                                                                               
HOSTNAME EMRG                                                                   
;                                                                               
;                                                                               
; NOTE - Use either DOMAINORIGIN/DOMAIN or SEARCH to specify your domain        
;         origin value                                                          
;                                                                               
; DOMAINORIGIN or DOMAIN statement                                              
; ================================                                              
; DOMAINORIGIN or DOMAIN specifies the domain origin that will be               
; appended to host names passed to the resolver.  If a host name                
; ends with a dot, then the domain origin will not be appended to the           
; host name.                                                                    
;                                                                               
DOMAINORIGIN  YOUR.COMPANY.COM                                                  
;                                                                               
;                                                                               
; SEARCH statement                                                              
; ================                                                              
; SEARCH specifies a list of 1 to 6 domain origin values that will be           
; appended to host names passed to the resolver.  If a host name                
; ends with a dot, then none of the domain origin values will be                
; appended to the host name.                                                    
;  The first domain origin value specified by SEARCH will be used as the        
; DOMAINORIGIN/DOMAIN value.                                                    
;                                                                               
; SEARCH YOUR.DOMAIN.NAME my.domain.name domain.name                            
;                                                                               
;                                                                               
; DATASETPREFIX statement                                                       
; =======================                                                       
; DATASETPREFIX is used to set the high level qualifier for dynamic             
; allocation of data sets in TCP/IP.                                            
;                                                                               
; The character string specified as a parameter on                              
; DATASETPREFIX takes precedence over the default prefix of "TCPIP".            
;                                                                               
; The DATASETPREFIX parameter can be up to 26 characters long                   
; and the parameter must NOT end with a period.                                 
;                                                                               
; For more information please see "Dynamic Data Set Allocation" in              
; the IP Configuration Guide.                                                   
;                                                                               
DATASETPREFIX SYS1.TCPIP                                                        
;                                                                               
;                                                                               
; MESSAGECASE statement                                                         
; =====================                                                         
; MESSAGECASE MIXED indicates to some servers, such as FTPD, that               
; messages should be displayed in mixed case.  MESSAGECASE UPPER                
; indicates that all messages should be displayed in uppercase.  Mixed          
; case strings that are inserted in messages will not be uppercased.            
;                                                                               
; If MESSAGECASE is not specified, mixed case messages will be used.            
;                                                                               
; MESSAGECASE MIXED                                                             
; MESSAGECASE UPPER                                                             
;                                                                               
;                                                                               
; NSINTERADDR or NAMESERVER statement                                           
; ===================================                                           
; NSINTERADDR or NAMESERVER specifies the IP address of the name server.        
; LOOPBACK (127.0.0.1) specifies your local name server.  If a name             
; server will not be used, then do not code an NSINTERADDR statement            
; or NAMESERVER statement.                                                      
;                                                                               
; The NSINTERADDR or NAMESERVER statement can be repeated up to sixteen         
; times to specify alternate name servers.  The name server listed first        
; will be the first one attempted.                                              
;                                                                               
; NSINTERADDR  127.0.0.1                                                        
;                                                                               
;                                                                               
; NSPORTADDR statement                                                          
; ====================                                                          
; NSPORTADDR specifies the foreign port of the name server.                     
; 53 is the default value.                                                      
;                                                                               
; NSPORTADDR 53                                                                 
;                                                                               
;                                                                               
; RESOLVEVIA statement                                                          
; ====================                                                          
;                                                                               
; RESOLVEVIA specifies how the resolver is to communicate with the              
; name server.  TCP indicates use of TCP connections.  UDP indicates            
; use of UDP datagrams.  The default is UDP.                                    
;                                                                               
RESOLVEVIA UDP                                                                  
;                                                                               
;                                                                               
; RESOLVERTIMEOUT statement                                                     
; =========================                                                     
; RESOLVERTIMEOUT specifies the time in seconds that the resolver               
; will wait for a response from the name server (either UDP or TCP).            
; The default is 30 seconds.                                                    
;                                                                               
RESOLVERTIMEOUT 10                                                              
;                                                                               
;                                                                               
; RESOLVERUDPRETRIES statement                                                  
; ============================                                                  
;                                                                               
; RESOLVERUDPRETRIES specifies the number of times the resolver                 
; should try to connect to the name server when using UDP datagrams.            
; The default is 1.                                                             
;                                                                               
RESOLVERUDPRETRIES 1                                                            
;                                                                               
;                                                                               
; LOOKUP statement                                                              
; ================                                                              
; LOOKUP indicates the order of name and address resolution.  DNS means         
; use the DNSs listed on the NSINTERADDR and NAMESERVER statements.             
; LOCAL means use the local host tables as appropriate for the                  
; environment being used (UNIX System Services or Native MVS).                  
;                                                                               
; LOOKUP DNS LOCAL                                                              
;                                                                               
;                                                                               
; LOADDBCSTABLES statement                                                      
; ========================                                                      
; LOADDBCSTABLES indicates to the FTP server and FTP client which DBCS          
; translation tables should be loaded at initialization time. Remove            
; from the list any tables that are not required. If LOADDBCSTABLES is          
; not specified, no DBCS tables will be loaded.                                 
;                                                                               
; LOADDBCSTABLES JIS78KJ JIS83KJ SJISKANJI EUCKANJI HANGEUL KSC5601             
; LOADDBCSTABLES TCHINESE BIG5 SCHINESE                                         
;                                                                               
;                                                                               
; SOCKDEBUG statement                                                           
; ===================                                                           
; Use the SOCKDEBUG statement to turn on the tracing of TCP/IP C and            
; REXX socket library calls.                                                    
; This command is for debugging purposes only.                                  
;                                                                               
; SOCKDEBUG                                                                     
;                                                                               
;                                                                               
; SOCKNOTESTSTOR statement                                                      
; ========================                                                      
; SOCKTESTSTOR is used to check socket calls for storage access errors          
; on the parameters to the call.  SOCKNOTESTSTOR stops this checking            
; and is better for response time.  SOCKNOTESTSTOR is the default.              
;                                                                               
; SOCKTESTSTOR                                                                  
; SOCKNOTESTSTOR                                                                
;                                                                               
;                                                                               
; TRACE RESOLVER statement                                                      
; ========================                                                      
; TRACE RESOLVER will cause a complete trace of all queries to and              
; responses from the name server or site tables to be written to                
; the user's joblog.  This command is for debugging purposes only.              
;                                                                               
; TRACE RESOLVER                                                                
;                                                                               
;                                                                               
; OPTIONS statement                                                             
; =================                                                             
; Use the OPTIONS statement to specify the following:                           
;  DEBUG                                                                        
;   Causes resolver debug messages to be issued. This is equivalent to          
;    TRACE RESOLVER                                                             
;  NDOTS:n                                                                      
;   Indicates the number of periods (.) that need to be contained in a          
;    domain name for it to be considered a fully qualified domain name          
;                                                                               
; OPTIONS NDOTS:1 DEBUG                                                         
;                                                                               
;                                                                               
; SORTLIST statement                                                            
; ==================                                                            
; Use the SORTLIST statement to specify the ordered list (maximum of 4)         
; of network numbers (subnets or networks) for the resolver to prefer           
; if it receives multiple addresses as the result of a name query.              
;                                                                               
; SORTLIST 128.32.42.0/24 128.32.42.0/255.255.0.0 9.0.0.0                       
;                                                                               
;                                                                               
; TRACE SOCKET statement                                                        
; ======================                                                        
; TRACE SOCKET will cause a complete trace of all calls to TCP/IP               
; through the C socket library.                                                 
; This statement is for debugging purposes only.                                
;                                                                               
; TRACE SOCKET                                                                  
;                                                                               
;                                                                               
; ALWAYSWTO statement                                                           
; ===================                                                           
; ALWAYSWTO causes messages for some servers, such as SMTP and LPD,             
; to be issued as WTOs. Specifying YES can cause excessive operator             
; console messages to be issued.                                                
;                                                                               
ALWAYSWTO NO                                                                    
; ALWAYSWTO YES                                                                 
;                                                                               
; Obsolete statements                                                           
; ===================                                                           
; The following statements no longer have any effect when included in           
; this file:                                                                    
;   SOCKBULKMODE                                                                
;   SOCKDEBUGBULKPERF0                                                          
;                                                                               
; End of file.                                                                  
;                                                                               
./ ADD NAME=FTPDATA,LEVEL=00,SOURCE=0,LIST=ALL                                  
;***********************************************************************        
;                                                                      *        
;   Name of File:             tcpip.SEZAINST(FTPSDATA)                 *        
;                                                                      *        
;   Descriptive Name:         FTP.DATA  (for OE-FTP Server)            *        
;                                                                      *        
;   SMP/E Distribution Name:  EZAFTPAS                                 *        
;                                                                      *        
;   Copyright:    Licensed Materials - Property of IBM                 *        
;                                                                      *        
;                 "Restricted Materials of IBM"                        *        
;                                                                      *        
;                 5694-A01                                             *        
;                                                                      *        
;                 (C) Copyright IBM Corp. 1977, 2001                   *        
;                                                                      *        
;                 US Government Users Restricted Rights -              *        
;                 Use, duplication or disclosure restricted by         *        
;                 GSA ADP Schedule Contract with IBM Corp.             *        
;                                                                      *        
;   Status:       CSV1R2                                               *        
;                                                                      *        
;   This FTP.DATA file is used to specify default file and disk        *        
;   parameters used by the FTP server.                                 *        
;                                                                      *        
;   Note: For an example of an FTP.DATA file for the FTP client,       *        
;   see the FTCDATA example.                                           *        
;                                                                      *        
;   Syntax Rules for the FTP.DATA Configuration File:                  *        
;                                                                      *        
;   (a) All characters to the right of and including a ; will be       *        
;       treated as a comment.                                          *        
;                                                                      *        
;   (b) Blanks and <end-of-line> are used to delimit tokens.           *        
;                                                                      *        
;   (c) The format for each statement is:                              *        
;                                                                      *        
;       parameter value                                                *        
;                                                                      *        
;                                                                      *        
;   The FTP.DATA options are grouped into the following groups in      *        
;   this sample FTP server FTP.DATA configuration data set:            *        
;                                                                      *        
;    1. Basic configuration options (timers, conditional options, etc.)*        
;    2. Anonymous support options                                      *        
;    3. Welcome banners, login messages, and directory information     *        
;       files                                                          *        
;    4. Defaults for MVS data set creation                             *        
;    5. Codepage conversion options                                    *        
;    6. Jes interface options                                          *        
;    7. DB2 (SQL) interface options                                    *        
;    8. SMF recording options                                          *        
;    9. Security options                                               *        
;   10. Debug (trace) options                                          *        
;                                                                      *        
;   For options that have a pre-selected set of values, a (D) indicates*        
;   the default value for the option.                                  *        
;                                                                      *        
;   Options that can be changed via SITE commands are identified       *        
;   with an (S).                                                       *        
;                                                                      *        
;***********************************************************************        
                                                                                
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 1. Basic server configuration options -                                       
;    Server timeout values, conversion options,                                 
;    and conditional processing options                                         
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
 ACCESSERRORMSGS   FALSE         ; (S) Detailed Access Error Replies            
                                     ; TRUE = Send detailed access error        
                                     ;        replies to the client             
                                     ; FALSE = Do not send detailed             
                                     ;         access error replies             
                                     ;         to the client                    
                                                                                
 ASATRANS          FALSE         ; (S) Conversion of ASA print                  
                                     ; control characters                       
                                     ; TRUE  = Use C conversion                 
                                     ; FALSE = Do not convert (D)               
                                                                                
 AUTOMOUNT         TRUE          ; (S) Automatic mount of unmounted             
                                     ; DASD volumes                             
                                     ; TRUE  = Mount volumes (D)                
                                     ; FALSE = Do not mount volumes             
                                                                                
 AUTORECALL        TRUE          ; (S) Automatic recall of                      
                                     ; migrated data sets                       
                                     ; TRUE  = Recall them (D)                  
                                     ; FALSE = Do not recall them               
                                                                                
 AUTOTAPEMOUNT     TRUE              ; Automatic mount of unmounted             
                                     ; tape volumes                             
                                     ; TRUE  = Mount volumes (D)                
                                     ; FALSE = Do not mount volumes             
                                                                                
 BUFNO             5             ; (S) Specify number of access                 
                                     ; method buffers                           
                                     ; Valid range is from 1 through            
                                     ; 35 - default value is 5                  
                                                                                
 CHKPTINT          0             ; (S) Specify the checkpoint interval          
                                     ; in number of records.                    
                                     ; NB: checkpointing only works             
                                     ; with datatype EBCDIC and block           
                                     ; or compressed transfer mode.             
                                     ; 0 = no checkpoints (D)                   
                                                                                
 CONDDISP          CATLG         ; (S) Disposition of a new data set            
                                     ; when transfer ends prematurely           
                                     ; CATLG  = Keep and catalog (D)            
                                     ; DELETE = Delete data set                 
                                                                                
;DEST              USER14@MVSL   ; (S) NJE destination of files that            
                                     ; are stored on this FTP server.           
                                     ; There is no default.  If the             
                                     ; option is specified, files are           
                                     ; sent to the specified destination        
                                     ; instead of being stored on the           
                                     ; FTP server.                              
                                                                                
 DIRECTORYMODE     FALSE         ; (S) Specifies how to view the MVS            
                                     ; data set structure:                      
                                     ; FALSE = All qualifiers below             
                                     ;    (D)  CWD are treated as               
                                     ;         entries in the directory         
                                     ; TRUE  = Qualifiers immediately           
                                     ;         below the CWD are treated        
                                     ;         as entries in the                
                                     ;         directory                        
                                                                                
;EXTENSIONS        MDTM              ; Enable MDTM FTP command                  
                                     ; support.                                 
                                     ; Default is disabled.                     
                                                                                
;EXTENSIONS        REST_STREAM       ; Enable stream restart                    
                                     ; support.                                 
                                     ; Default is disabled.                     
                                     ; EXTENSIONS SIZE must be enabled          
                                     ; also.                                    
                                                                                
;EXTENSIONS        SIZE              ; Enable SIZE FTP command                  
                                     ; support.                                 
                                     ; Default is disabled.                     
                                     ; NB: Enabling this support                
                                     ; may have a negative effect               
                                     ; on performance.                          
                                                                                
;EXTENSIONS        UTF8              ; Enable RFC 2640 support.                 
                                     ; Default is disabled.                     
                                     ; Control connection starts as             
                                     ; 7bit ASCII and switches to UTF-8         
                                     ; encoding when LANG command               
                                     ; received.  CCXLATE and CTRLCONN          
                                     ; are ignored.                             
                                                                                
 FILETYPE          SEQ           ; (S) Server mode of operation                 
                                     ; SEQ = transfer data sets or              
                                     ;       files (D)                          
                                     ; JES = submit jobs or retrieve            
                                     ;       JES output                         
                                     ; SQL = submit queries to DB2              
                                                                                
 INACTIVE          300               ; The time in seconds a control            
                                     ; connection is allowed to stay            
                                     ; inactive before it is closed by          
                                     ; the server.                              
                                     ; Default value is 300 seconds.            
                                     ; A value of zero disables the             
                                     ; inactivity timer check.                  
                                                                                
 ISPFSTATS         FALSE             ; TRUE = create/update PDS                 
                                     ;        statistics                        
                                     ; FALSE =does not create/update            
                                     ;        PDS statistics                    
                                                                                
 MIGRATEVOL        MIGRAT        ; (S) Migration volume volser to               
                                     ; identify migrated data sets              
                                     ; under control of non-HSM                 
                                     ; storage management products.             
                                     ; Default value is MIGRAT.                 
                                                                                
;MVSURLKEY         MVSDS             ; URL identifier for references            
                                     ; to MVS data sets - example:              
                                     ; ftp://host/MVSDS/'USER1.DS1'             
                                     ; MVSDS is the identifier that             
                                     ; is used by the WebSphere server.         
                                     ; There is no default value.               
                                                                                
;PORTCOMMAND  ACCEPT                 ; ACCEPT = accept all PORT commands        
                                     ; REJECT = reject all PORT commands        
                                                                                
;PORTCOMMANDPORT UNRESTRICTED        ; UNRESTRICTED = accept PORT               
                                     ;                commands with all         
                                     ;                PORT numbers              
                                     ; NOLOWPORTS = reject PORT                 
                                     ;              commands with PORT          
                                     ;              numbers less than           
                                     ;              1024.                       
                                                                                
;PORTCOMMANDIPADDR UNRESTRICTED      ; UNRESTRICTED = accept PORT               
                                     ;                commands with all         
                                     ;                IP addresses              
                                     ; NOREDIRECT = reject PORT commands        
                                     ;              with IP addresses           
                                     ;              other than the              
                                     ;              client that sent the        
                                     ;              PORT command                
                                                                                
 QUOTESOVERRIDE    TRUE          ; (S) How to treat quotes at the               
                                     ; beginning or surrounding file            
                                     ; names.                                   
                                     ; TRUE  = Override current working         
                                     ;         directory (D)                    
                                     ; FALSE = Treat quotes as part of          
                                     ;         file name                        
                                                                                
 RDW               FALSE         ; (S) Specify whether Record                   
                                     ; Descriptor Words (RDWs) are              
                                     ; discarded or retained.                   
                                     ; TRUE  = Retain RDWs and transfer         
                                     ;         as part of data                  
                                     ; FALSE = Discard RDWs when                
                                     ;         transferring data (D)            
                                                                                
 STARTDIRECTORY    MVS               ; Initial resource type access             
                                     ; MVS = MVS data sets (D)                  
                                     ; HFS = HFS files                          
                                                                                
;TRACE                               ; Enable tracing to SYSLOGD                
                                     ; Please note that there are no            
                                     ; parameters. (See Debug options           
                                     ; below.)                                  
                                                                                
 TRAILINGBLANKS    FALSE         ; (S) How to handle trailing blanks            
                                     ; in fixed format data sets during         
                                     ; text transfers.                          
                                     ; TRUE  = Retain trailing blanks           
                                     ;         (include in transfer)            
                                     ; FALSE = Strip off trailing               
                                     ;         blanks (D)                       
                                                                                
 UMASK             027           ; (S) Octal UMASK to restrict setting          
                                     ; of permission bits when creating         
                                     ; new hfs files                            
                                     ; Default value is 027.                    
                                                                                
;WLMCLUSTERNAME   ftpgroup           ; Use the WLMCLUSTERNAME Statement         
                                     ; to instruct the FTP Daemon to            
                                     ; register in a DNS/WLM                    
                                     ; Sysplex Connection Balancing             
                                     ; Group                                    
                                     ; There is no default value.               
                                                                                
 WRAPRECORD       FALSE          ; (S) Specify what to do if no new-line        
                                     ; is encountered before reaching           
                                     ; the MVS data set record length           
                                     ; limit as defined by LRECL when           
                                     ; transferring data to MVS.                
                                     ; TRUE  = Wrap data to new record          
                                     ; FALSE = Truncate data (D)                
; ---------------------------------------------------------------------         
;                                                                               
; 2. Anonymous support                                                          
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
;ANONYMOUS         GUEST/xxxxxxxx    ; Allow anonymous login                    
                                     ; Use user ID GUEST and                    
                                     ; xxxxxxxx as password                     
                                     ; SURROGATE can be used as password        
                                                                                
 ANONYMOUSLEVEL    1                 ; Enable R10 Anonymous support             
                                     ; 1 = CS OS/390 V2R5 level (D)             
                                     ; 2 = APAR PQ28980 level                   
                                     ; 3 = CS OS/390 V2R10 level                
                                                                                
                                     ; The following options in the             
                                     ; anonymous section of this sample         
                                     ; FTP.DATA only apply to                   
                                     ; ANONYMOUSLEVEL 3 - if you have           
                                     ; configured a lower level, these          
                                     ; options will not be in effect.           
                                                                                
;EMAILADDRCHECK    NO                ; EmailAddrCheck for Anonymous             
                                     ; NO      = No check (D)                   
                                     ; WARNING = Issue warning message          
                                     ; FAIL    = Fail login request             
                                                                                
;ADMINEMAILADDR    user@host.my.net  ; FTP administrator email address.         
                                     ; The substitution value for the           
                                     ; %E magic cookie in banner,               
                                     ; login, and info files.                   
                                                                                
;ANONYMOUSHFSFILEMODE 000            ; If an anonymous user is allowed          
                                     ; to create new files, these files         
                                     ; will be created with these               
                                     ; permission bits.  The anonymous          
                                     ; user is not allowed to use a             
                                     ; SITE CHMOD command.                      
                                     ; Default value is 000.                    
                                                                                
;ANONYMOUSHFSDIRMODE  333            ; If an anonymous user is allowed          
                                     ; to create new directories, these         
                                     ; directories will be created with         
                                     ; these permission bits.  The              
                                     ; anonymous user is not allowed to         
                                     ; use a SITE CHMOD command.                
                                     ; Default value is 333 -wx-wx-wx           
                                                                                
;ANONYMOUSFILEACCESS  HFS            ; Is the anonymous user allowed            
                                     ; to access MVS data sets or HFS           
                                     ; files or both.                           
                                     ; HFS  = HFS files only (D)                
                                     ; MVS  = MVS data sets only                
                                     ; BOTH = HFS files and MVS data            
                                     ;        sets                              
                                                                                
;ANONYMOUSFILETYPESEQ TRUE           ; Is the anonymous user allowed            
                                     ; to use filetype=seq?                     
                                     ; TRUE  = Yes (D)                          
                                     ; FALSE = No                               
                                                                                
;ANONYMOUSFILETYPEJES FALSE          ; Is the anonymous user allowed            
                                     ; to use filetype=jes?                     
                                     ; TRUE  = Yes                              
                                     ; FALSE = No (D)                           
                                     ;                                          
;ANONYMOUSFILETYPESQL FALSE          ; Is the anonymous user allowed            
                                     ; to use filetype=sql?                     
                                     ; TRUE  = Yes                              
                                     ; FALSE = No (D)                           
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 3. Welcome banner, login message, and directory information files             
;                                                                               
;    The welcome banner is displayed at connection.                             
;    Login message is displayed after successful login.                         
;    Info files and data sets are displayed when CD'ing to the path.            
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
;BANNER            /etc/ftpbanner    ; File-path for welcome banner -           
                                     ; both anonymous and real user             
                                                                                
;ANONYMOUSLOGINMSG /etc/ftpanonlogin ; File-path for login message              
                                     ; for anonymous user                       
                                                                                
;LOGINMSG          /etc/ftplogin     ; File-path for login message              
                                     ; for real user                            
                                                                                
;ANONYMOUSMVSINFO  README            ; Anonymous MVS info file LLQ              
                                                                                
;MVSINFO           README            ; Real user MVS info file LLQ              
                                                                                
;ANONYMOUSHFSINFO  readme*           ; Anonymous HFS info file-mask             
                                     ; login                                    
                                                                                
;HFSINFO           readme*           ; Real user HFS info file-mask             
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 4. Default MVS data set creation attributes                                   
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
 BLKSIZE           6233          ; (S) New data set allocation blocksize        
                                                                                
;DATACLASS         SMSDATA       ; (S) SMS data class name                      
                                     ; There is no default                      
                                                                                
;MGMTCLASS         SMSMGNT       ; (S) SMS mgmtclass name                       
                                     ; There is no default                      
                                                                                
;STORCLASS         SMSSTOR       ; (S) SMS storclass name                       
                                     ; There is no default                      
                                                                                
;DCBDSN            MODEL.DCB     ; (S) New data set allocation                  
                                     ; model dcb name - must be a               
                                     ; fully-qualified data set name            
                                     ; There is no default                      
                                                                                
 DIRECTORY         27            ; (S) Number of directory blocks in            
                                     ; new PDS/PDSE data sets.                  
                                     ; Default value is 27.                     
                                     ; Range is from 1 to 16777215.             
                                                                                
 LRECL             256           ; (S) New data set allocation lrecl.           
                                     ; Default value is 256.                    
                                     ; Valid range 0 through 32760.             
                                                                                
 PRIMARY           1             ; (S) New data set allocation                  
                                     ; primary space units according            
                                     ; to the value of SPACETYPE.               
                                     ; Default value is 1.                      
                                     ; Valid range 1 through 16777215.          
                                                                                
 RECFM             VB            ; (S) New data set allocation                  
                                     ; record format.                           
                                     ; Default value is VB.                     
                                     ; Value may be specifed as certain         
                                     ; combinations of:                         
                                     ; A - ASA print control                    
                                     ; B - Blocked                              
                                     ; F - Fixed length records                 
                                     ; M - Machine print control                
                                     ; S - Spanned (V) or Standard (F)          
                                     ; U - Undefined record length              
                                     ; V - Variable length records              
                                                                                
 RETPD                           ; (S) New data set retention                   
                                     ; period in days.                          
                                     ; Blank = no retention period (D)          
                                     ; 0 = expire today                         
                                     ; Valid range 0 through 9999.              
                                     ; NB: Note the difference between          
                                     ;     a blank value and a value            
                                     ;     of zero.                             
                                                                                
 SECONDARY         1             ; (S) New data set allocation                  
                                     ; secondary space units according          
                                     ; to the value of SPACETYPE.               
                                     ; Default value is 1.                      
                                     ; Valid range 1 through 16777215.          
                                                                                
 SPACETYPE         TRACK         ; (S) New data set allocation                  
                                     ; space type.                              
                                     ; TRACK (D)                                
                                     ; BLOCK                                    
                                     ; CYLINDER                                 
                                                                                
 UCOUNT                          ; (S) Sets the unit count for an               
                                     ; allocation.                              
                                     ; If this option is not specified          
                                     ; or is specified with a value of          
                                     ; blank, the unit count attribute          
                                     ; is not used on an allocation (D)         
                                     ; Valid range is 1 through 59 or           
                                     ; the character P for parallel             
                                     ; mount requests                           
                                                                                
;UNITNAME          SYSDA         ; (S) New data set allocation unit             
                                     ; name.                                    
                                     ; There is no default.                     
                                                                                
 VCOUNT            59            ; (S) Volume count for an                      
                                     ; allocation.                              
                                     ; Valid range is 1 through 255.            
                                     ; Default value is 59.                     
                                                                                
;VOLUME            WRKLB1,WRKLB2 ; (S) Volume serial number(s) to               
                                     ; use for allocating a data set.           
                                     ; Specify either a single volser           
                                     ; or a list of volsers                     
                                     ; separated with commas                    
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 5. Text codepage conversion options                                           
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
;CCXLATE           envqual           ; Control connection translate             
                                     ; specification.  If CTRLCONN is           
                                     ; also specified, CCXLATE is               
                                     ; ignored.                                 
                                     ; The specified value is used to           
                                     ; construct the name of an                 
                                     ; environment variable:                    
                                     ; _FTPXLATE_envqual and use the            
                                     ; assigned value as a reference to         
                                     ; a translate table data set.              
                                                                                
;CTRLCONN          7BIT          ; (S) ASCII code page for                      
                                     ; control connection.                      
                                     ; 7BIT is the default if CTRLCONN          
                                     ; is not specified AND no TCPXLBIN         
                                     ; translation table data set found.        
                                     ; Can be specified as any iconv            
                                     ; supported ASCII codepage, such           
                                     ; as IBM-850                               
                                                                                
;SBDATACONN  (IBM-1047,IBM-850)  ; (S) file system/network transfer             
                                     ; code pages for data connection.          
                                     ; Either a fully-qualified MVS             
                                     ; data set name or HFS file name           
                                     ; built with the CONVXLAT utility -        
                                     ;     HLQ.MY.TRANS.DATASET                 
                                     ;     /u/user1/my.trans.file               
                                     ; Or a file system codepage name           
                                     ; followed by a network transfer           
                                     ; codepage name according to iconv         
                                     ; supported codepages - for example        
                                     ;     (IBM-1047,IBM-850)                   
                                     ; If the SYSFTSX DD-name is present        
                                     ; it will override SBDATACONN.             
                                     ; If neither SYSFTSX nor                   
                                     ; SBDATACONN are present, std.             
                                     ; search order for a default               
                                     ; translation table data set will          
                                     ; be used.                                 
                                                                                
;XLATE             envqual           ; Data connection translate                
                                     ; specification.  If SBDATACONN is         
                                     ; also specified, XLATE is                 
                                     ; ignored.                                 
                                     ; The specified value is used to           
                                     ; construct the name of an                 
                                     ; environmen variable:                     
                                     ; _FTPXLATE_envqual and use the            
                                     ; assigned value as a reference to         
                                     ; a translate table data set.              
                                                                                
;UCSHOSTCS         code_page     ; (S) Specify the EBCDIC code set              
                                     ; to be used for data conversion           
                                     ; to or from Unicode.                      
                                     ; If UCSHOSTCS is not specified,           
                                     ; the current EBCDIC codepage              
                                     ; for the data connection is used.         
                                                                                
 UCSSUB            FALSE         ; (S) Specify whether Unicode-to-EBCDIC        
                                     ; conversion should use the EBCDIC         
                                     ; substitution character or                
                                     ; cause the data transfer to be            
                                     ; terminated if a Unicode                  
                                     ; character cannot be converted to         
                                     ; a character in the target                
                                     ; EBCDIC code set                          
                                     ; TRUE  = Use substitution char            
                                     ; FALSE = Terminate transfer (D)           
                                                                                
 UCSTRUNC          FALSE         ; (S) Specify whether the transfer             
                                     ; of Unicode data should be                
                                     ; aborted if truncation                    
                                     ; occurs at the MVS host                   
                                     ; TRUE  = Truncation allowed               
                                     ; FALSE = Terminate transfer (D)           
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 6. JES interface options                                                      
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
 JESLRECL          80            ; (S) Lrecl of jobs submitted to JES.          
                                     ; Default value is 80.                     
                                     ; Valid range from 1 through 254.          
                                                                                
 JESPUTGETTO       600               ; Number of seconds in JesPutGet           
                                     ; state (number of seconds server          
                                     ; will wait between submitting a           
                                     ; job and retrieving its output.           
                                     ; Default value is 600 seconds.            
                                     ; Valid range 0 through 86400.             
                                                                                
 JESRECFM          F             ; (S) Recfm of jobs submitted to JES.          
                                     ; F = Fixed length (D)                     
                                     ; V = Variable length (use only            
                                     ;     with JES3 systems)                   
                                                                                
 JESINTERFACELEVEL 1                 ; Functional level of the JES              
                                     ; interface                                
                                     ; 1 = Interface works as it did            
                                     ;     prior to OS/390 V2R10 (D)            
                                     ; 2 = Interface works according            
                                     ;     to the enhanced support              
                                     ;     in OS/390 V2R10                      
                                                                                
 JESENTRYLIMIT     200           ; (S) Maximum number of JES entries            
                                     ; to include in DIR listings while         
                                     ; in JES mode (LEVEL 2)                    
                                     ; Default value is 200.                    
                                     ; Valid range is 1 through 1024.           
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 7. DB2 (SQL) interface options                                                
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
 DB2               DB2           ; (S) DB2 subsystem name                       
                                     ; The default name is DB2                  
                                                                                
 DB2PLAN           EZAFTPMQ          ; DB2 plan name for FTP Server             
                                     ; The default name is EZAFTPMQ             
                                                                                
 SPREAD            FALSE         ; (S) SQL spreadsheet output format            
                                     ; TRUE  = Spreadsheet format               
                                     ; FALSE = Not spreadsheet                  
                                     ;         format (D)                       
                                                                                
 SQLCOL            NAMES         ; (S) SQL output headings                      
                                     ; NAMES  = Use column names (D)            
                                     ; LABELS = Use column labels               
                                     ; ANY    = Use label if defined,           
                                     ;          else use name                   
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 8. SMF recording options                                                      
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
;SMF               STD               ; SMF records use standard subtypes        
                                     ; Specify either SMF STD - or              
                                     ; individual subtypes below.               
                                     ; (The values used in this sample          
                                     ; for the individual subtypes are          
                                     ; the standard values - the values         
                                     ; that will be used if you specify         
                                     ; SMF STD).                                
                                                                                
;SMFAPPE           70                ; SMF record subtype for the               
                                     ; APPEND subcommand                        
                                                                                
;SMFDEL            71                ; SMF record subtype for the               
                                     ; DELETE subcommand                        
                                                                                
;SMFEXIT                             ; Load SMF user exit FTPSMFEX              
                                     ; Please note that there are no            
                                     ; parameters.  If SMFEXIT is not           
                                     ; specified, no exit will be               
                                     ; loaded.                                  
                                                                                
;SMFJES                              ; SMF recording when filetype=jes          
                                     ; Please note that there are no            
                                     ; parameters.  If SMFJES is not            
                                     ; specified, SMF recording while           
                                     ; in filetype=jes mode will not be         
                                     ; done.                                    
                                                                                
;SMFLOGN           72                ; SMF record subtype when                  
                                     ; recording logon failures                 
                                                                                
;SMFREN            73                ; SMF record subtype for the               
                                     ; RENAME subcommand                        
                                                                                
;SMFRETR           74                ; SMF record subtype for the               
                                     ; RETR subcommand                          
                                                                                
;SMFSQL                              ; SMF recording when filetype=sql          
                                     ; Please note that there are no            
                                     ; parameters.  If SMFSQL is not            
                                     ; specified, SMF recording while           
                                     ; in filetype=sql mode will not be         
                                     ; done.                                    
                                                                                
;SMFSTOR           75                ; SMF record subtype for the               
                                     ; STOR and STOU subcommands                
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 9. Security options                                                           
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
;EXTENSIONS        AUTH_GSSAPI       ; Enable Kerberos authentication           
                                     ; Default is disabled.                     
                                                                                
;EXTENSIONS        AUTH_TLS          ; Enable TLS authentication                
                                     ; Default is disabled.                     
                                                                                
;SECURE_FTP        ALLOWED           ; Authentication indicator                 
                                     ; ALLOWED        (D)                       
                                     ; REQUIRED                                 
                                                                                
;SECURE_LOGIN      NO_CLIENT_AUTH    ; Authorization level indicator            
                                     ; NO_CLIENT_AUTH (D)                       
                                     ; REQUIRED                                 
                                     ; VERIFY_USER                              
                                                                                
;SECURE_CTRLCONN   CLEAR             ; Minimum level of security for            
                                     ; the control connection                   
                                     ; CLEAR          (D)                       
                                     ; SAFE                                     
                                     ; PRIVATE                                  
                                                                                
;SECURE_DATACONN   CLEAR             ; Minimum level of security for            
                                     ; the data connection                      
                                     ; NEVER                                    
                                     ; CLEAR          (D)                       
                                     ; SAFE                                     
                                     ; PRIVATE                                  
                                                                                
                                                                                
;SECURE_PBSZ       16384             ; Kerberos maximum size of the             
                                     ; encoded data blocks                      
                                     ; Default value is 16384                   
                                     ; Valid range is 512 through 32768         
                                                                                
; Name of a ciphersuite that can be passed to the partner during                
; the TLS handshake. None, some, or all of the following may be                 
; specified. The number to the far right is the cipherspec id                   
; that corresponds to the ciphersuite's name.                                   
;CIPHERSUITE       SSL_NULL_MD5      ; 01                                       
;CIPHERSUITE       SSL_NULL_SHA      ; 02                                       
;CIPHERSUITE       SSL_RC4_MD5_EX    ; 03                                       
;CIPHERSUITE       SSL_RC4_MD5       ; 04                                       
;CIPHERSUITE       SSL_RC4_SHA       ; 05                                       
;CIPHERSUITE       SSL_RC2_MD5_EX    ; 06                                       
;CIPHERSUITE       SSL_DES_SHA       ; 09                                       
;CIPHERSUITE       SSL_3DES_SHA      ; 0A                                       
                                                                                
;KEYRING           name              ; Name of the keyring for TLS              
                                     ; It can be the name of an hfs             
                                     ; file (name starts with /) or             
                                     ; a resource name in the security          
                                     ; product (e.g., RACF)                     
                                                                                
;TLSTIMEOUT        100               ; Maximum time limit between full          
                                     ; TLS handshakes to protect data           
                                     ; connections                              
                                     ; Default value is 100 seconds.            
                                     ; Valid range is 0 through 86400           
                                                                                
; ---------------------------------------------------------------------         
;                                                                               
; 10. Debug (trace) options                                                     
;                                                                               
; ---------------------------------------------------------------------         
                                                                                
;DEBUG             ALL    ;   activate all traces                               
;DEBUG             BAS    ;   active basic traces (marked with *)               
;DEBUG             FLO    ;   function flow                                     
;DEBUG             CMD    ; * command trace                                     
;DEBUG             PAR    ;   parser details                                    
;DEBUG             INT    ; * program initialization and termination            
;DEBUG             ACC    ;   access control errors (logging in)                
;DEBUG             UTL    ;   utility functions                                 
;DEBUG             FSC(1) ; * file services                                     
;DEBUG             SOC(1) ; * socket services                                   
;DEBUG             JES    ;   special JES processing                            
;DEBUG             SQL    ;   special SQL processing                            
;DEBUG             SEC    ;   security trace                                    
                                                                                
./ ENDUP                                                                        
@#                                                                              
//*****************************************************************             
//* LIST THE SY2PKA MASTER CATALOG                                              
//*****************************************************************             
//LIST22 EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                                 
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUDUMP DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
     LISTC CATALOG(SYS1.MCAT.VSY2PKA) ALL                                       
/*                                                                              
//*****************************************************************             
//* CLEANUP - REMOVE SSA AND EXPORT DISCONNECT SY2PKA MCAT                      
//*****************************************************************             
//CLEAN23 EXEC  PGM=IDCAMS,REGION=4M,COND=(0,NE)                                
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUDUMP DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
    DEL TARGSYS ALIAS                                                           
    EXP SYS1.MCAT.VSY2PKA DISCONNECT                                            
/*                                                                              