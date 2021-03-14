<# 
    ____                                                                                                    ________    
   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯\\   
   //¯¯\\__[ Introduction ]________________________________________________________________________________//¯¯\\__//   
   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯\\   
   //¯¯¯                                                                                                           //   
   \\        Hi, my name is Michael Cook.                                                                          \\
   //        I'm an application developer, design artist, and system engineer.                                     // 
   \\                                                                                                              \\
   //        In this video, I will demonstrate use of the module, FightingEntropy.                                 //
   \\        FightingEntropy is a module for PowerShell (Windows Powershell, PowerShell 7),                        \\
   //        and has a long list of features related to system (administration/management).                     ___//
   \\___                                                                                                    ___//¯¯\\   
   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯\\   
   //¯¯\\__[ Starting Point ]______________________________________________________________________________//¯¯\\__//   
   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯\\   
   //¯¯¯                                                                                                           //   
   \\        The [Starting Point] in this demonstration, will be (1) preconfigured PDC with:                       \\   
   //                                                                                                              //   
   \\        ADDS                      : Active Directory Domain Services                                          \\   
   //        DHCP                      : Dynamic Host Control Protocol                                             //   
   \\        DNS                       : Domain Naming Service                                                     \\   
   //        HyperV                    : Hyper-Virtualization                                                      //   
   \\        MDT                       : Microsoft Deployment Toolkit                                              \\   
   //        WDS                       : Windows Deployment Services                                               //   
   \\        WinADK                    : Windows Assessment and Deployment Kit                                     \\   
   //        WinPE                     : Windows Preinstallation Environment                                    ___//   
   \\___                                                                                                    ___//¯¯\\   
   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯\\   
   //¯¯\\__[ Target Items ]________________________________________________________________________________//¯¯\\__//   
   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯\\   
   //¯¯¯                                                                                                           //   
   \\        The Target child items that will be spawned and utilized via this process:                            \\   
   //                                                                                                              //   
   \\        - (1) Physical machine [Client]                                                                       \\   
   //        - (1) Virtual machine [Client]                                                                        //   
   \\        - (1) Virtual machine [Server]                                                                        \\   
   //                                                                                                           ___//   
   \\___                                                                                                    ___//¯¯\\   
   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
    ¯¯¯\\__[ End Introduction ]____________________________________________________________________________//¯¯¯        
        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            #>

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ (Step 1) [:] Get Physical/VM names, Domain, and any current FE Shares                          ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  

$Physical  = "hp-ts600"
$Virtual   = "dsc1","10p64"
$Names     = @($Physical;$Virtual)
$Domain    = Get-ADDomain
$Share     = Get-FEShare

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ (Step 2) [:] Clear MDT Monitor Data of test items                                              ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

If ($Share)
{
    $Label = "$($Share.Label):"
    Import-Module (Get-MDTModule) -Verbose
    New-PSDrive -Name $Share.Label -PSProvider MDTProvider -Root $Share.Path -Description $Share.Description | Out-Null
    Get-MDTMonitorData -Path $Label | ? Name -in $Names | Remove-MDTMonitorData -Path $Label
    Remove-PSDrive -Name $Share.Label
}

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ (Step 3) [:] Remove existing test items from AD, DNS, and Hyper-V                              ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

$AD        = Get-ADObject -Filter * | ? ObjectClass -eq Computer | ? Name -in $Names
$DNS       = Get-DnsServerResourceRecord -ZoneName $Domain.DNSRoot | ? HostName -in $Names
$VM        = Get-VM | ? Name -in $Names
$VMHost    = Get-VMHost
$VHDPath   = $VMHost.VirtualHardDiskPath

ForEach ( $Item in $AD )
{
    If ($Item.Name -in $DNS.HostName)
    {
        $DNS | ? HostName -eq $Item.Name | Remove-DnsServerResourceRecord -ZoneName $Domain.DNSRoot -Verbose -Force -EA 0
    }

    If ($Item.Name -in $VM.Name)
    {
        $VM | ? Name -eq $Item.Name | Stop-VM -Verbose -Force

        "{0}\{1}.vhdx" -f $VHDPath,$Item.Name | % { 

            If ( Get-Item -Path $_ )
            {
                Remove-Item -Path $_ -Verbose -Force
            }
        }
    }

    Remove-ADObject -Identity $Item.DistinguishedName -Recursive -Verbose -Confirm:$False
}

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ (Step 4) [:] Remove all existing traces of the module                                          ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules" | ? Name -match FightingEntropy | Remove-Item -Verbose -Recurse
Get-ChildItem -Path "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.3.1 | Remove-Item -Verbose -Recurse
Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.3.1 | Remove-Item -Verbose -Recurse

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ (Step 5) [:] Install module from repository                                                    ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

Invoke-Expression ( Invoke-RestMethod https://github.com/mcc85sx/FightingEntropy/blob/master/Install.ps1?raw=true )

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ (Step 6) [:] Create a new FE Deployment Share                                                  ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

# This function will initialize a GUI dialog with several tabs and sections for user input

New-FEDeploymentShare

# All of the fields that are populated in the GUI, are needed for the process to fully test/flush a given 
# share if it exists, or to simply create a brand new share if it does not.

# The GUI input is tested, and if it is good... it will run through these following functions:

# New-FEImage    - Processes the ISO files in the target $ImageRoot folder.
# New-FEShare    - Loads the MDT module, and creates a new deployment share.
# Import-FEImage - Imports the new OS WIM files, and creates task sequences for them.
# Update-FEShare - MDT builds new boot images, and then brands/injects/replaces them in WDS.

# At this point, target computers can boot from the network.

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ (Step 7) [:] Deploy an operating system to target systems                                      ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

# [Physical Machines] - Use PXE to boot over the network in a subnet where the MDT server is authoritative.
# DHCP and WDS configuration will be covered at another time.

# [Virtual Machines] - This launches brand new VMs and starts them
Start-VMGroup -NamedVM $Virtual

# [Manual entry] - At this point, manual entry is required as this is a "LiteTouch" distribution
# Enter the computer name in each terminal, virtual and physical, and then allow the MDT process to complete.

# Once the virtual server is online, we will upgrade it to a domain controller using the module.
# Once one of the client systems load, initialize the service configuration utility (MadBomb122/BlackViper)
# Once the other client system loads, initialize FENetwork -GUI

# Exhibit the structure of the module
