//USSSCHG  JOB (JOBNAME),'CREATE USS SCREEN ',CLASS=A,                  00010000
//*            TYPRUN=SCAN,                                             00020000
//             MSGLEVEL=(1,1),MSGCLASS=K,NOTIFY=&SYSUID                 00030000
//*
//BUILD   EXEC ASMACL
//C.SYSLIB  DD DSN=SYS1.SISTMAC1,DISP=SHR
//          DD DSN=SYS1.MACLIB,DISP=SHR
//C.SYSIN   DD *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
         MACRO
&NAME    SCREEN &MSG=,&TEXT=
         AIF   ('&MSG' EQ '' OR '&TEXT' EQ '').END
         LCLC  &BFNAME,&BFSTART,&BFEND
&BFNAME  SETC  'BUF'.'&MSG'
&BFBEGIN SETC  '&BFNAME'.'B'
&BFEND   SETC  '&BFNAME'.'E'
.BEGIN   DS    0F
&BFNAME  DC    AL2(&BFEND-&BFBEGIN)        MESSAGE LENGTH
&BFBEGIN EQU   *                       START OF MESSAGE
         DC    X'F57A'                 ERASE/WRITE, WCC
         DC    X'110000'               SBA, 0000     ROW 00 COL 01
         DC    X'290242F6C0E0'         SFE, PROTECTED/NORMAL/YELLOW
         DC    C'Mainframe Operating System           '
         DC    C'                z/OS 3.1   RSU2409   '
*              NEXT ELEVEN LINES DISPLAYS LOGOs
         DC    X'110050'               SBA, 0080     ROW 01 COL 01
         DC    X'290242F2C0E0'         SFE, PROTECTED/NORMAL/RED
         DC C'                                        '
         DC C'                                        '
         DC C'                                        '
         DC C'                                        '
         DC C'                                        '
         DC C'                                        '
         DC C'                                        '
         DC C'                                        '
         DC C'                         SSSS Y   Y  SSS'
         DC C'S  AAA                                  '
         DC C'                        S      Y Y  S   '
         DC C'  A   A                                 '
         DC C'                          SSS   Y    SSS'
         DC C'  AAAAA                                 '
         DC C'                            S   Y       '
         DC C'S A   A                                 '
         DC C'                        SSSS    Y   SSSS'
         DC C'  A   A                                 '
         DC C'                                        '
         DC C'                                        '
         DC C'                                        '
         DC C'                                        '
         DC    X'110410'               SBA, 0960     ROW 12 COL 01
         DC    X'290242F4C0E0'         SFE, PROTECTED/NORMAL/GREEN
         DC C'                   Welcome to ZDT2 Mainf'
         DC C'rame System!                              '
         DC    X'1104B0'               SBA, 1120     ROW 14 COL 01
         DC    X'290242F5C0E0'     SFE, PROTECTED/NORMAL/PURPLE
         DC C'                                        '
         DC C'                                        '
.* APPLICATION: TSO
         DC    X'110508'               APPLICATION POSITION
         DC    X'290242F2C0E0'         SFE, PROTECTED/NORMAL/RED
         DC    C'TSO'                  APPLICATION NAME
         DC    X'110511'               DESCRIPTION POSITION
         DC    X'290242F1C0E0'         SFE, PROTECTED/NORMAL/BLUE
         DC    C'- Logon to TSO/ISPF'  APPLICATION DESCRIPTION
.* APPLICATION: NETVIEW
         DC    X'11052C'               APPLICATION POSITION
         DC    X'290242F2C0E0'         SFE, PROTECTED/NORMAL/RED
         DC    C'CNM01'                APPLICATION NAME
         DC    X'110535'               DESCRIPTION POSITION
         DC    X'290242F1C0E0'         SFE, PROTECTED/NORMAL/BLUE
         DC    C'- Netview System'     APPLICATION DESCRIPTION
.* APPLICATION: CICSTS62
         DC    X'110558'               APPLICATION POSITION
         DC    X'290242F2C0E0'         SFE, PROTECTED/NORMAL/RED
         DC    C'CICSTS62'             APPLICATION NAME
         DC    X'110561'               DESCRIPTION POSITION
         DC    X'290242F1C0E0'         SFE, PROTECTED/NORMAL/BLUE
         DC    C'- CICS System 6.2'    APPLICATION DESCRIPTION
.* APPLICATION: CICSTS61
         DC    X'11057C'               APPLICATION POSITION
         DC    X'290242F2C0E0'         SFE, PROTECTED/NORMAL/RED
         DC    C'CICSTS61'             APPLICATION NAME
         DC    X'110585'               DESCRIPTION POSITION
         DC    X'290242F1C0E0'         SFE, PROTECTED/NORMAL/BLUE
         DC    C'- CICS System 6.1'    APPLICATION DESCRIPTION
.* APPLICATION: IMS
         DC    X'1105A8'               APPLICATION POSITION
         DC    X'290242F2C0E0'         SFE, PROTECTED/NORMAL/RED
         DC    C'IMS'                  APPLICATION NAME
         DC    X'1105B1'               DESCRIPTION POSITION
         DC    X'290242F1C0E0'         SFE, PROTECTED/NORMAL/BLUE
         DC    C'- IMS System'         APPLICATION DESCRIPTION
.* OTHER INFORMATION
         DC    X'110640'               SBA, 1600     ROW 21 COL 01
         DC    C'Enter your choice==>'
         DC    X'110654'               SBA, 1622     ROW 21 COL 22
         DC    X'290242F2C0C8'         SFE, UNPROTECTED/NORMAL
         DC    X'13'                   INSERT CURSOR
         DC    X'11068F'               SBA, 1690     ROW 22 COL 01
         DC    X'290242F6C0E0'         SFE, PROTECTED/NORMAL/YELLOW
         DC    C&TEXT                  USS MESSAGES
         DC    X'11072F'               SBA, 1840     ROW 24 COL 01
         DC    X'290242F1C0E0'         SFE, PROTECTED/NORMAL/GREEN
         DC    C'Your IP(@@@@@@@@@IPADDR:@@PRT), SNA LU(@@LUNAME)'
         DC    C'       @@@@DATE @@@@TIME'
&BFEND   EQU   *                       END OF MESSAGE
.END     MEND
*
*
*               ..............
USSTAB   USSTAB TABLE=STDTRANS,FORMAT=DYNAMIC
*        SPACE
TSO      USSCMD CMD=TSO,REP=LOGON,FORMAT=BAL      TSO
         USSPARM PARM=APPLID,DEFAULT=TSO
         USSPARM PARM=P1,REP=DATA
*        SPACE
LOGON    USSCMD CMD=LOGON,REP=LOGON,FORMAT=BAL      TSO
         USSPARM PARM=APPLID,DEFAULT=TSO
         USSPARM PARM=P1,REP=DATA
*        SPACE
CNM01    USSCMD  CMD=CNM01,REP=LOGON,FORMAT=BAL
         USSPARM PARM=APPLID,DEFAULT=CNM01
CICSTS62 USSCMD  CMD=CICSTS62,REP=LOGON,FORMAT=BAL
         USSPARM PARM=APPLID,DEFAULT=CICSTS62
CICSTS61 USSCMD  CMD=CICSTS61,REP=LOGON,FORMAT=BAL
         USSPARM PARM=APPLID,DEFAULT=CICSTS61
IMS      USSCMD  CMD=IMS,REP=LOGON,FORMAT=BAL
         USSPARM PARM=APPLID,DEFAULT=IMS15CR1
SA       USSCMD  CMD=CNM01,REP=LOGON,FORMAT=BAL
         USSPARM PARM=APPLID,DEFAULT=CNM01
*        SPACE
         USSMSG MSG=00,BUFFER=(BUF00,SCAN)
         USSMSG MSG=01,BUFFER=(BUF01,SCAN)
         USSMSG MSG=02,BUFFER=(BUF02,SCAN)
         USSMSG MSG=03,BUFFER=(BUF03,SCAN)
*        USSMSG MSG=04,BUFFER=(BUF04,SCAN)
         USSMSG MSG=05,BUFFER=(BUF05,SCAN)
         USSMSG MSG=06,BUFFER=(BUF06,SCAN)
         USSMSG MSG=08,BUFFER=(BUF08,SCAN)
         USSMSG MSG=10,BUFFER=(BUF10,SCAN)
         USSMSG MSG=11,BUFFER=(BUF11,SCAN)
         USSMSG MSG=12,BUFFER=(BUF12,SCAN)
         USSMSG MSG=14,BUFFER=(BUF14,SCAN)
*        SPACE
STDTRANS DC    X'000102030440060708090A0B0C0D0E0F'
         DC    X'101112131415161718191A1B1C1D1E1F'
         DC    X'202122232425262728292A2B2C2D2E2F'
         DC    X'303132333435363738393A3B3C3D3E3F'
         DC    X'404142434445464748494A4B4C4D4E4F'
         DC    X'505152535455565758595A5B5C5D5E5F'
         DC    X'604062636465666768696A6B6C6D6E6F'
         DC    X'707172737475767778797A7B7C7D7E7F'
         DC    X'80C1C2C3C4C5C6C7C8C98A8B8C8D8E8F'
         DC    X'90D1D2D3D4D5D6D7D8D99A9B9C9D9E9F'
         DC    X'A0A1E2E3E4E5E6E7E8E9AAABACADAEAF'
         DC    X'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'
         DC    X'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF'
         DC    X'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF'
         DC    X'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF'
         DC    X'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'
END      USSEND
*        SPACE
*********************************************************************** ********
*DEFAULT MESSAGE PROVIDED BY VTAM:
*  MSG 00: IST457I POSITIVE command COMMAND RESPONSE
*  MSG 01: IST450I INVALID command COMMAND SYNTAX
*  MSG 02: IST451I command COMMAND UNRECOGNIZED, PARAMETER=parameter
*  MSG 03: IST452I parameter PARAMETER EXTRANEOUS
*  MSG 04: IST453I parameter PARAMETER VALUE value NOT VALID
*  MSG 05: N/A
*  MSG 06: IST792I NO SUCH SESSION EXISTS
*  MSG 07: N/A
*  MSG 08: IST454I command COMMAND FAILED, INSUFFICIENT STORAGE
*  MSG 09: N/A
*  MSG 10: READY
*  MSG 11: IST455I parameters SESSIONS ENDED
*  MSG 12: IST456I keyword REQUIRED PARAMETER OMITTED
*  MSG 13: N/A
*  MSG 14: IST458I USS MESSAGE number NOT DEFINED
*********************************************************************** ********
*  CUSTOMIZED USS MESSAGES:
         SCREEN MSG=00,TEXT='Command is in progress...'
         SCREEN MSG=01,TEXT='Invalid command or syntax'
         SCREEN MSG=02,TEXT='Invalid Command'
         SCREEN MSG=03,TEXT='Parameter is unrecognized!'
*        SCREEN MSG=04,TEXT='Parameter with value is invalid'
         SCREEN MSG=05,TEXT='The key you pressed is inactive'
         SCREEN MSG=06,TEXT='There is not such session.'
         SCREEN MSG=08,TEXT='Command failed as storage shortage.'
         SCREEN MSG=10,TEXT='Enter one of above commands in red'
         SCREEN MSG=11,TEXT='Your session has ended'
         SCREEN MSG=12,TEXT='Required parameter is missing'
         SCREEN MSG=14,TEXT='There is an undefined USS message'
         END
/*
//L.SYSLMOD DD DISP=SHR,DSN=ADCD.Z31C.VTAMLIB
//L.SYSIN   DD *
  NAME USSN(R)
//*
