//DEFUCAT JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID    
//STEP1 EXEC PGM=IDCAMS                            
//VOL1 DD VOL=SER=B5USR1,UNIT=DISK,DISP=OLD        
//SYSPRINT DD SYSOUT=*                             
//SYSIN DD *                                       
  DEFINE USERCATALOG -                             
        (NAME(USERCAT.CPWR) -                      
            CYLINDERS(3 2) -                       
         VOLUME(IOA001) -                          
         ICFCATALOG -                              
         STRNO(3) -                                
         FREESPACE(10 20) -                        
         SHAREOPTIONS(3 4)) -                      
       DATA -                                      
         (BUFND(4) -                               
          CONTROLINTERVALSIZE(4096)) -             
       INDEX -                                     
         (BUFNI(4) -                               
          CONTROLINTERVALSIZE(2048))               
/*                                                 
//                                                 