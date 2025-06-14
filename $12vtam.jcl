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
