<# 
Hi, my name is Michael Cook.
I'm an application developer, design artist, and system engineer.
In this video, I will demonstrate use of the module, FightingEntropy.
FightingEntropy is a module for PowerShell (Windows Powershell, PowerShell 7),
and has a long list of features related to system (administration/management).

The starting point in this demonstration will feature a single preconfigured (PDC)
-    ADDS / Active Directory Domain Services
-     DNS / Domain Naming Service
-    DHCP / Dynamic Host Control Protocol
-     WDS / Windows Deployment Services 
- Hyper-V / Hyper-(Viridian|Virtualization)

This domain controller will also have: 
-     MDT / Microsoft Deployment Toolkit
-  WinADK / Windows Assessment and Deployment Kit
-   WinPE / Windows Preinstallation Environment

Target Items (3): 
(1) Physical machine [Client]
(1) Virtual machine [Client]
(1) Virtual machine [Server] #>

# With the module in memory, current FE Shares may be located...
# [Get current share]
Get-FEShare | Format-Table

# Set Named Items for Active Directory & Hyper-V 
$Physical = "hp-ts600"
$Virtual  = "dsc1","10p64"
$Items    = $Physical , $Virtual

# Remove Named Items if they exist in this Active Directory instance
Get-ADObject -Filter * | ? ObjectClass -eq Computer | ? Name -in $Items | Remove-ADObject -Recursive -Verbose -Confirm:$False

# Remove the module
Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules" | ? Name -match FightingEntropy | Remove-Item -Verbose -Recurse
Get-ChildItem -Path "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.3.0 | Remove-Item -Verbose -Recurse
Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.3.0 | Remove-Item -Verbose -Recurse

# Install the module
Invoke-Expression ( Invoke-RestMethod https://github.com/mcc85sx/FightingEntropy/blob/master/Install.ps1?raw=true )

# Install FE Deployment Share
New-FEDeploymentShare
# The server will initialize a GUI dialog via function New-FEDeploymentShare. 
# All of the fields that are populated in the GUI, are needed for the process to fully test/flush a given 
# share if it exists, or simply create a brand new share if it does not.

# The GUI input is tested, and if it is good, it will begin processing the ISO's found in the target $ImageRoot folder.
# The process currently selects the image indexes belonging to Server 2016 Datacenter, 
# as well as Windows 10 Education, Home, Pro, and extracts the corresponding wim files to the swap directory.

# After the images are extracted and pooled, the New-FEShare can be created.
# Then, the Import-FEImage can import the operating systems and create task sequences for the share.
# Then, the Update-FEShare can create/cycle in boot images through DISM/MDT -> WDS.
# Then, WDS offers the boot images to the deployment share...

# At this point, target computers can boot from the network.

# Start VM Group
Start-VMGroup -NamedVM $Virtual

# [FEDCPromo] Once the virtual machine server is online, it will be upgraded to a domain controller using the module.
# [FENetwork] Once one of the client systems load, initialize the service configuration utility + MadBomb + BlackViper.
# [ViperBomb] **
# [MadBomb]   **

#>

#!!!!!!!!! Set Server Static IP Information, use dns suffix in dns registration, etc
