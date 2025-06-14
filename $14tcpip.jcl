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
