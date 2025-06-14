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
