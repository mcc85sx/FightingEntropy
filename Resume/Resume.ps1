Class Person
{
    [String] $Name
    [String] $Title
    Person([String]$Name,[String]$Title)
    {
        $This.Name       = $Name
        $This.Title      = $Title
    }
}

Class Experience
{
    [String] $Company
    [String] $Location
    [String] $Title
    [String] $Date
    [String[]] $Duties
    Experience([String]$Company,[String]$Location,[String]$Date,[String]$Title)
    {
        $This.Company  = $Company
        $This.Location = $Location
        $This.Date     = $Date
        $This.Title    = $Title
    }
}

Class Education
{
    [String] $School
    [String] $Location
    [String] $Date
    [String[]] $Studies
    Education([String]$School,[String]$Location,[String]$Date)
    {
        $This.School   = $School
        $This.Location = $Location
        $This.Date     = $Date
    }
}

$Person      = [Person]::New("Michael C. Cook Sr.","Network Information System Security Professional | DevOPS Engineer")
$Details     = @("CompTIA A+/Network+/Security+|Cisco CCNA/CNAP|Microsoft Certified Professional/MCDST/MCSA/MCSE|Associate Degree in Information Technology (Drafting and Design/Multimedia)|High School English Portfolio Award (CRCATS)".Split("|") | % { "[+] $_" })

$Experience1 = [Experience]::New("Secure Digits Plus LLC","Clifton Park, NY","October 2018 - Current","Chief Executive Officer / Security Engineer")
$Duties1     = @("Portfolio Development at https://www.securedigitsplus.com",
"Main development focus: C#/PowerShell module development, codename 'FightingEntropy'",
"'FightingEntropy' is a module for PowerShell which automatically installs itself, as well as (installing/configuring) Windows Server 2016/2019, Windows 10 Home/Education/Pro, RHEL/CentOS, and FreeBSD/OPNsense/pfSense via the Microsoft Deployment Toolkit",
"'FightingEntropy' also configures and establishes a network baseline for Active Directory Domain Services, Windows Deployment Services, Hyper-V/Veridian, DNS, DHCP, and a slew of other client/server side utilities",
"Other areas of development include Internet Information Services/IIS, (Linux/Unix/FreeBSD) integration, Razor/Blazor/ASP.Net Core, Desired State Configuration, Extensible Application Markup Language, and Graphical User Interface/GUI design",
"'FightingEntropy' is completely written in C#/PowerShell/.Net, and is currently split between production/development:",
"(Development): https://www.github.com/mcc85sx/FightingEntropy",
"(Production): https://www.github.com/mcc85sx/FightingEntropy)" | % { "[+] $_" })

$Experience2 = [Experience]::New("Computer Answers","Clifton Park, NY","October 2015 - July 2019","Senior Technical Officer / Business Solutions Expert")
$Duties2     = @("Developed scripts and protocol, overseeing productivity/training of all employees",
"Complaining about the development team that took forever to do anything",
"Featured on WTEN Alert Desk via Andrew Banas regarding SmartTV’s at https://youtu.be/-jkDPv9H6BQ",
"Set highest sales record in the company to date, in August 2017",
"Rebuilt all of the networking equipment, point of sale equipment, access point configuration, server configuration, internet gateway, and DHCP configuration/deployment, for all (7) stores that existed at one point.",
"Deploying and configuring Clients, Servers, Routers, Switches, Access Points, receipt printers, SmartTV’s… led to the founding of 'Secure Digits Plus LLC', spiritual successor to 'Mike’s PC Repair', in order to build a program that does all of this configuration, in a similar manner to (Kubernetes | Azure | AWS | vSphere | SD-WAN)",
"Upgraded each store to gigabit Ethernet internally, as well as (pfSense | OPNSense | HardenedBSD))" | % { "[+] $_" })

$Experience3 = [Experience]::New("KeyCorp","Albany, NY","March 2016 - December 2016","Help Desk Level I/II Support Engineer")
$Duties3     = @("Provided support to (KeyCorp/KeyBank) employees over the phone and over Key's Inter IM client, Cisco Jabber, for various first and second level help desk support tickets",
"First experience with System center Configuration Manager, which utilizes core aspects of the Microsoft Deployment Toolkit and other Microsoft-centric programs/applications",
"Exposure to Active Directory Administration was rather limited in this position (typically used for password resets), brief contact with Organizational Units, Site Links, Lotus Notes, Exchange, vSphere/eSXI, Group Policy Objects, RSA Encryption/Software tokens, (KeyCounselor/HOGAN), handled *some* network desk calls)" | % { "[+] $_" })

$Experience4 = [Experience]::New("Metroland/Lou Communications","Albany, NY","January 2007 - January 2014","Distribution Contractor / IT Consultant")
$Duties4     = @("Distributed the newspaper Metroland for several years throughout the Greater Capital Region",
"Eventually they were in need of IT services from 'Mike’s PC Repair' in September 2012",
"Accurately documented and migrated their network from 420 Madison Ave, Albany NY to 523 Western Ave, Albany NY installing a 1U blade server with dual AMD processors, and Windows Server 2008",
"Migrated all data from an older Windows NT 4.0 system that publishers used for archiving (weekly/legacy) content",
"Assisted Mr. Bracchi with network storage for publishers via (Adobe Photoshop/Illustrator), mapping printers, domain logins, and (emails/Outlook) etc. Limited use of domain resources otherwise.)" | % { "[+] $_" })

$Experience5 = [Experience]::New("Nfrastructure","Clifton Park, NY","September 2010 - January 2011","Computer (Hardware/Printer/Network) Technician")
$Duties5     = @("Staged machines to be used for Point-Of-Sale systems for the Adidas-Reebok of North America, as well as testing, repairing, and maintaining inventory of computers, monitors, receipt printers, hand held devices, barcode scanners, and label/form printers (Epson), and made manufacturer warranty calls to Hewlett-Packard for (HP Elite 8100/8200’s), and Dell for various",
"Imaged (hundreds/thousands) of computers to be used for various state government agencies such as New York State Department of Transportation (CSMIN), Office of People with Disabilities Department (OMRDD/OPWDD), New York State Department Of Correctional Services (DOCS), Adidas-Reebok NA, Price Chopper/Golub Corporation, and Testcomm of New York and Massachusetts",
"Provided desktop support for internal company users, on an unofficial capacity",
"(Repaired/inspected/maintained) full-size (Lexmark/Hewlett Packard) stack printers for various state agencies)" | % { "[+] $_" })

$Experience6 = [Experience]::New("TEKsystems","Albany, NY","2006 - May 2019","Various (Computer/Network) related roles")
$Duties6     = @("Completed Pittsfield MA Census Bureau deployment (2009-2010) | KeyCorp (2016) | Patroon Creek (2017)",
"(Trinity Health/St. Peters Hospital) (February 2019) [Interview] -> Potential client was seeking to build an entirely new domain physically as well as via ASP.Net overhaul. Hence, actively researching/building 'FightingEntropy')" | % { "[+] $_" })

$Experience7 = [Experience]::New("Hearst Corporation","Albany, NY","April 2006 - April 2009","Distribution Contractor / Accounts Receivable Collector")
$Duties7     = @("Provided distribution throughout lower Saratoga County, as well as the Greater Capital Region",
"Daily paper drops were required in early morning hours after they are printed (2AM-4AM), and stores would either be open or closed - some stops needed priority treatment (primarily Stewarts Corp)",
"Drifted in the snow a lot, found new ways to drop off newspapers, drove a minimum of 90 miles a night",
"Collected and calculated return payment amounts, deposited into bank account with Bank of America",
"Worked under Chris Jones for daytime return routes, and (Kenny/Patrick Bernard) for night routes)" | % { "[+] $_" })

$Education1 = [Education]::New("New Horizons Learning Center","Albany, NY","January 2008 - January 2009")
$Studies1   = @("Completed certifications from CompTIA A+/Network+, MCP/MCDST",
"Hands on support with hardware, and operating systems Windows (XP Pro/Home/Server 2003)",
"Studied server technologies and services: FTP, File Server, WINS, DNS, DHCP, Active Directory, GPO’s, Driver Installations, Wireless Networking, IIS 6.0, RSAT, WSUS, VPN Encryption, Certificates, & Virtual Server"| % { "[+] $_" })

$Education2 = [Education]::New("ITT Technical Institute","Albany, NY","June 2004 - June 2006")
$Studies2   = @("Received Associate degree in (IT/Drafting and Design-Multimedia), during my course",
"Studied (2D/3D) multimedia graphic design, video editing, web design and publishing, (HTML/CSS) development, (Macromedia Flash/Director) animation, (Adobe Premiere/After Effects) scene editing, (Adobe Photoshop/Illustrator) photo editing, (AutoDesk 3DS/Maya) 3D modeling, character rigging/animation, CompTIA (A+/Network+) studies, Micro-economics, Problem-Solving, Instructional Design, Portfolio Development, Introduction to Visual Basic (.Net))"| % { "[+] $_" })

$Education3 = [Education]::New("Capital Region Career and Technical School","Albany, NY","September 2001 - June 2003")
$Studies3   = @("Attended while in high school, this 2 year program consisted of studies and lab experience in the following curriculum: (CompTIA A+/Network+), (Cisco CSNA/CNAP/CCNA), (Microsoft System Administration)",
"Briefly acted as (Student Network Administrator), using (MMC/Microsoft Management Console) snap-ins, HyperTerminal, Novell Netware IPX/SPX, Windows XP/Server 2000 Workgroup, and some Red Hat Linux",
"Received an in-depth year with Cisco networking routers and switches accessed via serial cable and console",
"Participated in a state competition at Schenectady County Community College, and ITT Technical Institute",
"Received an award from the school for Portfolio Development at final graduation ceremony)" | % { "[+] $_" })

$Buff = " ","_","¯" | % { $_ * 86 -join ''}
$Resume = @(
    $Person;
    $Details;
    $Buff[0]
    $Buff[1]
    "[Experience]--------------------------------------------------------------------------";
    $Experience1;
    $Duties1;
    $Buff[0];
    $Buff[1];
    $Buff[2];
    $Experience2;
    $Duties2;
    $Buff[0];
    $Buff[1];
    $Buff[2];
    $Experience3;
    $Duties3;
    $Buff[0];
    $Buff[1];
    $Buff[2];
    $Experience4;
    $Duties4;
    $Buff[0];
    $Buff[1];
    $Buff[2];
    $Experience5;
    $Duties5;
    $Buff[0];
    $Buff[1];
    $Buff[2];
    $Experience6;
    $Duties6;
    $Buff[0];
    $Buff[1];
    $Buff[2];
    $Experience7;
    $Duties7;
    $Buff[0];
    $Buff[1];
    "[Education]---------------------------------------------------------------------------";
    $Education1;
    $Studies1;
    $Buff[0];
    $Buff[1];
    $Buff[2];
    $Education2;
    $Studies2;
    $Buff[0];
    $Buff[1];
    $Buff[2];
    $Education3;
    $Studies3)

Write-Theme $Resume -Title "Michael C. Cook's Resume ($(Get-Date))" -Prompt "You don't have to press any key to continue"
