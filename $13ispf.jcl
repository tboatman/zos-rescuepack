//ISPF JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,REGION=4096K
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
