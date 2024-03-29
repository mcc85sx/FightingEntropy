<#
.SYNOPSIS
    Start or continue a PSD task sequence. 
.DESCRIPTION
    Start or continue a PSD task sequence.
.LINK
    https://github.com/FriendsOfMDT/PSD
.NOTES
          FileName: PSDStart.ps1
          Solution: PowerShell Deployment for MDT
          Author: (Original) PSD Development Team, (Modified) Michael C. Cook Sr.
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2021-11-26

          Version - 0.0.0 - () - Finalized functional version 1.
          Version - 0.9.1 - Added check for network access when doing network deployment
          Version - 0.9.2 - Check that needed files are in WinPE for XAML files to show correctly
                            Logic for detection if running in WinPE
                            Check for unsupported variables
          Version - 0.9.2 - Added logic when removing tscore.dll and TSprogressUI to avoid errors in log files
          Version - 0.9.3 - ZTINextPhase.wsf is now replaced with PSDNextPhase.ps1
                            ZTIApplications.wsf is now replaced with PSDApplications.ps1
          Version - 0.9.4 - Added partial support for HTTPS
          version - 0.9.5 - Added detection if we can find certificate in certain folders, of so they will be imported as Root Cert's
                            $($env:SYSTEMDRIVE)\Deploy\Certificates
                            $($env:SYSTEMDRIVE)\MININT\Certificates
          version - 0.9.6 - Added https condition for NTP, and set time
          version - 0.9.7 - Debugging, logging, Write to screen has changed... alot...
          TODO:

.Example
#>

Param ([Switch]$Start,[switch]$Debug)

Function Write-PSDBootInfo
{
    Param($Message,$SleepSec="NA")

    # Check for BGInfo
    If (!(Test-Path "$env:SystemRoot\system32\bginfo.exe"))
    {
        Return
    }

    # Check for BGinfo file
    If (!(Test-Path -Path "$env:SystemRoot\system32\psd.bgi"))
    {
        Return
    }

    # Update background
    $Result            = New-Item -Path HKLM:\SOFTWARE\PSD -ItemType Directory -Force
    $Result            = New-ItemProperty -Path HKLM:\SOFTWARE\PSD -Name PSDBootInfo -PropertyType MultiString -Value $Message -Force
    & bginfo.exe "$env:SystemRoot\system32\psd.bgi" /timer:0 /NOLICPROMPT /SILENT
    
    If ($SleepSec -ne "NA")
    {
        Start-Sleep -Seconds $SleepSec
    }
}

# Set the module path based on the current script path
$DeployRoot            = Split-Path $PSScriptRoot
$env:PSModulePath     += ";$DeployRoot\Tools\Modules"

# Check for debug settings
$Global:PSDDebug       = $False
If (Test-Path -Path "C:\MININT\PSDDebug.txt")
{
    $DeBug             = $True
    $Global:PSDDebug   = $True
}

If ($Global:PSDDebug -eq $False)
{
    If ($DeBug -eq $True)
    {
        $Result        = Read-Host -Prompt "Press y and Enter to continue in debug mode, any other key to exit from debug..."
        If ($Result -eq "y")
        {
            $DeBug     = $True
        }
        Else
        {
            $DeBug     = $False
        }
    }
}

If ($DeBug -eq $True)
{
    $Global:PSDDebug   = $True
    $verbosePreference = "Continue"
}

If ($PSDDeBug -eq $true)
{
    Write-Verbose "PSDDeBug is now $PSDDeBug"
    Write-Verbose "verbosePreference is now $verbosePreference"
    Write-Verbose $env:PSModulePath
}

# Make sure we run at full power
Write-PSDBootInfo -Message "Setting Power plan to High performance" -SleepSec 1
& powercfg.exe /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Load core modules
Write-PSDBootInfo -SleepSec 1 -Message "Loading core PowerShell modules"
Import-Module PSDUtility -Force -Verbose:$False
Import-Module Storage -Force -Verbose:$False

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Beginning initial process in PSDStart.ps1"

If ($PSDDeBug -eq $True)
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Imported Module: PSDUtility,Storage "
}

# Check if we booted from WinPE
$Global:BootfromWinPE = $False
If ($env:SYSTEMDRIVE -eq "X:")
{
    $Global:BootfromWinPE = $True
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): BootfromWinPE is now [$BootfromWinPE]"

# Write Debug status to logfile
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): PSDDeBug is now [$PSDDeBug]"

# Install PSDRoot certificate if exist in WinPE
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Looking for certificates..."

$Certificates         = @()
$CertificateLocations = "$($env:SYSTEMDRIVE)\Deploy\Certificates","$($env:SYSTEMDRIVE)\MININT\Certificates"
ForEach ($CertificateLocation in $CertificateLocations)
{
    If (Test-Path $CertificateLocation)
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Looking for certificates in $CertificateLocation"
        $Certificates += Get-ChildItem $CertificateLocation *.cer
    }
}

ForEach ($Certificate in $Certificates)
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Found $($Certificate.FullName), trying to add as root certificate"
    # Write-PSDBootInfo -SleepSec 1 -Message "Installing PSDRoot certificate"
    $Return = Import-PSDCertificate -Path $Certificate.FullName -CertStoreScope "LocalMachine" -CertStoreName "Root"
    If ($Return -eq "0")
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Succesfully imported $($Certificate.FullName)"
    }
    Else
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Failed to import $($Certificate.FullName)"
    }
}

# Set Command Window size
# Reason for 99 is that 99 seems to use the screen in the best possible way, 100 is just one pixel to much
If ($Global:PSDDebug -ne $True)
{
    Set-PSDCommandWindowsSize -Width 99 -Height 15
}

If ($BootfromWinPE)
{
    # Windows ADK v1809 could be missing certain files, we need to check for that.
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check if we are running Windows ADK 10 v1809"
    
    If ((Get-WmiObject Win32_OperatingSystem).BuildNumber -eq 17763)
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check for BCP47Langs.dll and BCP47mrm.dll, needed for WPF"
        If (!(Test-Path X:\Windows\System32\BCP47Langs.dll) -or !(Test-Path X:\Windows\System32\BCP47mrm.dll))
        {
            Start-Process PowerShell -ArgumentList {
                "Write-Warning -Message 'We are missing the BCP47Langs.dll and BCP47mrm.dll files required for WinPE 1809.';Write-warning -Message 'Please check the PSD documentation on how to add those files.';Write-warning -Message 'Critical error, deployment can not continue..';Pause"
            } -Wait
            Exit 1
        }
    }

    # We need more than 1.5 GB (Testing for at least 1499MB of RAM)
    Write-PSDBootInfo -SleepSec 2 -Message "Checking that we have at least 1.5 GB of RAM"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check for minimum amount of memory in WinPE to run PSD"

    If ((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory -le 1499MB)
    {
        Show-PSDInfo -Message "Not enough memory to run PSD, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Exit 1
    }

    # All tests succeded, log that info
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Completed WinPE prerequisite checks"
}

# Load more modules
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load more modules"

Import-Module PSDDeploymentShare -Force -Verbose
Import-Module PSDGather -Force -Verbose
Add-Type -AssemblyName PresentationFramework
Import-Module PSDWizard -Force -Verbose

#Set-PSDDebugPause -Prompt 182

#Check if tsenv: works
Try
{
    Get-ChildItem tsenv:
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Able to read from TSEnv"
}
Catch
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to read from TSEnv"
    #Break
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $DeployRoot"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"

# If running from RunOnce, create a startup folder item and then exit
If ($Start)
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating a link to re-run $PSCommandPath from the all users Startup folder"

    # Create a shortcut to run this script
    $allUsersStartup     = [Environment]::GetFolderPath('CommonStartup')
    $linkPath            = "$allUsersStartup\PSDStartup.lnk"
    $wshShell            = New-Object -comObject WScript.Shell
    $shortcut            = $WshShell.CreateShortcut($linkPath)
    $shortcut.TargetPath = "powershell.exe"
    
    If ($PSDDebug -eq $True)
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Command set to:PowerShell.exe -Noprofile -Executionpolicy Bypass -File $PSCommandPath -Debug"
        $shortcut.Arguments = "-Noprofile -Executionpolicy Bypass -File $PSCommandPath -Debug"
    }
    Else
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Command set to:PowerShell.exe -Noprofile -Executionpolicy Bypass -Windowstyle Hidden -File $PSCommandPath"
        $shortcut.Arguments = "-Noprofile -Executionpolicy Bypass -Windowstyle Hidden -File $PSCommandPath"
    }
    $shortcut.Save()
    Exit 0
}

# Gather local info to make sure key variables are set (e.g. Architecture)
Write-PSDBootInfo -SleepSec 1 -Message "Running local gather"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run Get-PSDLocalInfo"
Get-PSDLocalInfo
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Checking if there is an in-progress task sequence"

# Check for an in-progress task sequence
Write-PSDBootInfo -SleepSec 1 -Message "Check for an in-progress task sequence"
$tsInProgress       = $False
Get-Volume | ? DriveLetter | ? DriveType -eq Fixed | ? DriveLetter -ne X | ? {Test-Path "$($_.DriveLetter):\_SMSTaskSequence\TSEnv.dat"} | % {

    # Found it, save the location
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): In-progress task sequence found at $($_.DriveLetter):\_SMSTaskSequence"
    $tsInProgress   = $True
    $tsDrive        = $_.DriveLetter

    #Set-PSDDebugPause -Prompt 240

    # Restore the task sequence variables
    $variablesPath  = Restore-PSDVariables
    Try
    {
        ForEach ($I in Get-ChildItem TSEnv:)
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Property $($i.Name) is $($i.Value)"
        }
    }
    Catch
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to restore variables from $variablesPath."
        Show-PSDInfo -Message "Unable to restore variables from $variablesPath." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Exit 1
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Restored variables from $variablesPath."

    # Reconnect to the deployment share
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Reconnecting to the deployment share at $($tsenv:DeployRoot)."
    If ($tsenv:UserDomain -ne "")
    {
        Get-PSDConnection -deployRoot $tsenv:DeployRoot -username "$($tsenv:UserDomain)\$($tsenv:UserID)" -password $tsenv:UserPassword
    }
    Else
    {
        Get-PSDConnection -deployRoot $tsenv:DeployRoot -username $tsenv:UserID -password $tsenv:UserPassword
    }
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): If a task sequence is in progress, resume it. Otherwise, start a new one"

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"

# If a task sequence is in progress, resume it.  Otherwise, start a new one
[Environment]::CurrentDirectory = "$($env:WINDIR)\System32"
If ($tsInProgress)
{
    # Find the task sequence engine
    If (Test-Path -Path "X:\Deploy\Tools\$($tsenv:Architecture)\tsmbootstrap.exe")
    {
        $tsEngine     = "X:\Deploy\Tools\$($tsenv:Architecture)"
    }
    Else
    {
        $tsEngine     = Get-PSDContent "Tools\$($tsenv:Architecture)"
    }
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Task sequence engine located at $tsEngine."

    # Get full scripts location
    $scripts           = Get-PSDContent -Content "Scripts"
    $env:ScriptRoot    = $scripts

    # Set the PSModulePath
    $modules           = Get-PSDContent -Content "Tools\Modules"
    $env:PSModulePath += ";$modules"

    # Resume task sequence
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"
    Stop-PSDLogging
    Write-PSDBootInfo -SleepSec 1 -Message "Resuming existing task sequence"
    $result = Start-Process -FilePath "$tsEngine\TSMBootstrap.exe" -ArgumentList "/env:SAContinue" -Wait -Passthru
}
Else
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No task sequence is in progress."

    # Process bootstrap
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing Bootstrap.ini"
    If ($env:SYSTEMDRIVE -eq "X:")
    {
        $mappingFile = "X:\Deploy\Tools\Modules\PSDGather\ZTIGather.xml"
        Invoke-PSDRules -FilePath "X:\Deploy\Scripts\Bootstrap.ini" -MappingFile $mappingFile
    }
    Else
    {
        $mappingFile = "$deployRoot\Scripts\ZTIGather.xml"
        Invoke-PSDRules -FilePath "$deployRoot\Control\Bootstrap.ini" -MappingFile $mappingFile
    }

    # Determine the Deployroot
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Determine the Deployroot"

    # Check if we are deploying from media
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check if we are deploying from media"

    Get-Volume | ? DriveLetter | ? DriveType -eq Fixed | ? DriveLetter -ne X | ? {Test-Path "$($_.DriveLetter):Deploy\Scripts\Media.tag"} | % {
        
        # Found it, save the location
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Found Media Tag $($_.DriveLetter):Deploy\Scripts\Media.tag"
        $tsDrive                = $_.DriveLetter
	    $tsenv:DeployRoot       = "$($tsDrive):\Deploy"
	    $tsenv:ResourceRoot     = "$($tsDrive):\Deploy"
	    $tsenv:DeploymentMethod = "MEDIA"

        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): DeploymentMethod is $tsenv:DeploymentMethod, this solution does not currently support deploying from media, sorry, aborting"
        Show-PSDInfo -Message "No deployroot set, this solution does not currently support deploying from media, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Break
    }

    #Set-PSDDebugPause -Prompt 337

    Switch ($tsenv:DeploymentMethod)
    {
        MEDIA
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): DeploymentMethod is $tsenv:DeploymentMethod, this solution does not currently support deploying from media, sorry, aborting"
            Show-PSDInfo -Message "No deployroot set, this solution does not currently support deploying from media, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
            Start-Process PowerShell -Wait
            Break
        }
        Default
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): We are deploying from Network, checking IP's,"
            
            # Check Network
            Write-PSDBootInfo -SleepSec 1 -Message "Checking for a valid network configuration"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Invoking DHCP refresh..."    
            $Null        = Invoke-PSDexe -Executable ipconfig.exe -Arguments "/renew"

            $NICIPOK     = $False

            $ipList      = @()
            $ipListv4    = @()
            $macList     = @()
            $gwList      = @()

            Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 1" | % {
                $_.IPAddress            | % {  $ipList += $_ }
                $_.MacAddress           | % { $macList += $_ }
                If ($_.DefaultIPGateway) 
                {
                    $_.DefaultIPGateway | % {  $gwList += $_ }
                }
            }

            $ipListv4    = $ipList | ? Length -eq 15
            
            ForEach ($IPv4 in $ipListv4)
            {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Found IP address $IPv4"
            }

            If (((Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 1").Index).Count -ge 1)
            {
                $NICIPOK = $True
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): We have at least one network adapter with a IP address, we should be able to continue"
            }

            If ($NICIPOK -ne $True)
            {
                $Message = "Sorry, it seems that you don't have a valid IP, aborting..."
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message"
                Show-PSDInfo -Message "$Message" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
                Start-Process PowerShell -Wait
                Break
            }

            # Log if we are running APIPA as warning
            # Log IP, Networkadapter name, if exist GW and DNS
            # Return Network as deployment method, with Yes we have network
        }
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Looking for PSDeployRoots in the usual places..."

    #Set-PSDDebugPause -Prompt 398

    If ($tsenv:PSDDeployRoots -ne "")
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): PSDeployRoots definition found!"
        $Items              = $tsenv:PSDDeployRoots.Split(",")

        ForEach ($Item in $Items)
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Testing PSDDeployRoots value: [$item]"
            If ($Item -ilike "https://*")
            {
                $ServerName = $Item.Replace("https://","") | Split-Path
                $Result     = Test-PSDNetCon -Hostname $ServerName -Protocol HTTPS
                If (!$Result)
                {
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access PSDDeployRoots value [$Item] using HTTP"
                }
                Else
                {
                    $tsenv:DeployRoot = $Item
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot [HTTP] is now [$tsenv:DeployRoot]"
                    Break
                }
            }
            If ($Item -ilike "http://*")
            {
                $ServerName = $Item.Replace("http://","") | Split-Path
                $Result     = Test-PSDNetCon -Hostname $ServerName -Protocol HTTP
                If (!$Result)
                {
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access PSDDeployRoots value [$Item] using [HTTPS]"
                }
                Else
                {
                    $tsenv:DeployRoot = $item
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot [HTTPS] is now [$tsenv:DeployRoot]"
                    Break
                }
            }
            If ($Item -like "\\*")
            {
                $ServerName = $Item.Split("\\")[2]
                $Result     = Test-PSDNetCon -Hostname $ServerName -Protocol SMB
                If (!$Result)
                {
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access [$Item] using [SMB]"
                }
                Else
                {
                    $tsenv:DeployRoot = $Item
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot [SMB] is now [$tsenv:DeployRoot]"
                    Break
                }
            }
        }
    }
    Else
    {
        $deployRoot = $tsenv:DeployRoot
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Validating network access to $tsenv:DeployRoot"
    Write-PSDBootInfo -SleepSec 2 -Message "Validating network access to $tsenv:DeployRoot"

    #Set-PSDDebugPause -Prompt 451

    If (!($tsenv:DeployRoot -notlike $null -or ""))
    {
        $Message = "Since we are deploying from network, we should be able to access the deploymentshare, but we can't, please check your network."
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message"
        Show-PSDInfo -Message "$Message" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Break
    } 
    
    If (!$NICIPOK)
    {
        If ($DeployRoot -notlike $null -or "")
        {
            $Message = "Since we are deploying from network, we should have network access but we don't, check networking"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message"
            Show-PSDInfo -Message "$Message" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
            Start-Process PowerShell -Wait
            Break
        }
    }

    # Validate network route to $deployRoot
    If ($DeployRoot -notlike $null -or "")
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): New deploy root is $DeployRoot."
        Switch -Regex ($DeployRoot)
        {
            "(https\:\/\/.+)"
            {
                $ServerName = $deployRoot.Replace("https://","") | Split-Path
                $Result     = Test-PSDNetCon -Hostname $ServerName -Protocol HTTPS
            }
            "(http\:\/\/.+)"
            {
                $ServerName = $deployRoot.Replace("http://","") | Split-Path
                $Result     = Test-PSDNetCon -Hostname $ServerName -Protocol HTTP
            }
            "(\\\\.+)"
            {
                $ServerName = $deployRoot.Split("\\")[2]
                $Result     = Test-PSDNetCon -Hostname $ServerName -Protocol SMB -ErrorAction SilentlyContinue
            }
        }
        If (!$Result)
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $ServerName"
            Show-PSDInfo -Message "Unable to access $ServerName, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
            Start-Process PowerShell -Wait
            Break
        }
    }
    Else
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is empty, this solution does not currently support deploying from media, sorry, aborting"
        Show-PSDInfo -Message "No deployroot set, this solution does not currently support deploying from media, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Break
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): New deploy root is $deployRoot."
    Get-PSDConnection -DeployRoot $tsenv:DeployRoot -Username "$tsenv:UserDomain\$tsenv:UserID" -Password $tsenv:UserPassword

    #Set-PSDDebugPause -Prompt 518

    # Set time on client
    $Time = Get-Date
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Current time on computer is: $Time"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Set time on client"

    If ($tsenv:DeploymentMethod -ne "MEDIA")
    {
        Switch -Regex ($DeployRoot)
        {
            "(\\\\.+)"
            {
                net time \\$ServerName /set /y
            }
            "(http[s*])"
            {
                $NTPTime = Get-PSDNtpTime
                If ($NTPTime)
                {
                    Set-Date -Date $NTPTime.NtpTime
                }
                Else
                {
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Failed to set time/date" -LogLevel 2
                }
            }
        }
    }

    $Time        = Get-Date
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): New time on computer is: $Time"

    # Process CustomSettings.ini
    $Control     = Get-PSDContent -Content "Control"

    # Verify access to "$control\CustomSettings.ini" 
    If (!(Test-path "$Control\CustomSettings.ini"))
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $Control\CustomSettings.ini"
        Show-PSDInfo -Message "Unable to access $Control\CustomSettings.ini, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Break    
    }
    
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing CustomSettings.ini"
    Invoke-PSDRules -FilePath "$control\CustomSettings.ini" -MappingFile $mappingFile

    If ($tsenv:EventService -notlike $null -or "")
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Eventlogging is enabled"
    }
    Else
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Eventlogging is not enabled"
    }

    # Get full scripts location
    $Scripts          = Get-PSDContent -Content "Scripts"
    $env:ScriptRoot   = $Scripts

    # Set the PSModulePath
    $Modules          = Get-PSDContent -Content "Tools\Modules"
    $env:PSModulePath += ";$modules"

    #Set-PSDDebugPause -Prompt "Process wizard"

    # Process wizard
    Write-PSDBootInfo -SleepSec 1 -Message "Loading the PSD Deployment Wizard"
    # $tsenv:TaskSequenceID = ""
    If ($tsenv:SkipWizard -ine "YES")
    {
        Import-Module PSDWizard
        Add-Type -AssemblyName PresentationFramework
        $Drives = Get-PSDrive
        Try
        {
            $Result = Get-FEWizard -Drive $Drives
        }
        Catch
        {
            $Result = Show-PSDWizard "$Scripts\PSDWizardMod.xaml"
        }
        
        If (!$Result.DialogResult)
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Cancelling, aborting..."
            Show-PSDInfo -Message "Cancelling, aborting..." -Severity Information -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
            Stop-PSDLogging
            Clear-PSDInformation
            Start-Process PowerShell -Wait
            Exit 0
        }
    }

    If ($tsenv:TaskSequenceID -eq "")
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No TaskSequence selected, aborting..."
        Show-PSDInfo -Message "No TaskSequence selected, aborting..." -Severity Information -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Stop-PSDLogging
        Clear-PSDInformation
        Start-Process PowerShell -Wait
        Exit 0
    }

    If ($tsenv:OSDComputerName -eq "")
    {
        $tsenv:OSDComputerName = $env:COMPUTERNAME
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Find the task sequence engine"

    # Find the task sequence engine
    If (Test-Path -Path "X:\Deploy\Tools\$($tsenv:Architecture)\tsmbootstrap.exe")
    {
        $tsEngine = "X:\Deploy\Tools\$($tsenv:Architecture)"
    }
    Else
    {
        $tsEngine = Get-PSDContent "Tools\$($tsenv:Architecture)"
    }
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Task sequence engine located at $tsEngine."

    # Transfer $PSDDeBug to TSEnv: for TS to understand
    If ($PSDDeBug)
    {
        $tsenv:PSDDebug = "YES"
    }

    # Start task sequence
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Start the task sequence"

    # Saving Variables
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Saving Variables"
    $variablesPath = Save-PSDVariables
    
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy Variables"
    Copy-Item -Path $variablesPath -Destination $tsEngine -Force
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copied $variablesPath to $tsEngine"
    
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy ts.xml"
    Copy-Item -Path "$control\$($tsenv:TaskSequenceID)\ts.xml" -Destination $tsEngine -Force
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copied $control\$($tsenv:TaskSequenceID)\ts.xml to $tsEngine"

    #Update TS.XML before using it, changing workbench specific .WSF scripts to PowerShell to avoid issues
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Update ts.xml before using it, changing workbench specific .WSF scripts to PowerShell to avoid issues"

    $TSxml = "$tsEngine\ts.xml"
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIDrivers.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDDrivers.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIGather.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDGather.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIValidate.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDValidate.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIBIOSCheck.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDTBA.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIDiskpart.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDPartition.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIUserState.wsf" /capture','PowerShell.exe -file "%SCRIPTROOT%\PSDTBA.ps1" /capture') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIBackup.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDTBA.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTISetVariable.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDSetVariable.ps1"') | Set-Content -Path $TSxml
    # (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTINextPhase.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDNextPhase.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\LTIApply.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDApplyOS.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIWinRE.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDTBA.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIPatches.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDTBA.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIApplications.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDApplications.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIWindowsUpdate.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDWindowsUpdate.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIBde.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDTBA.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIBDE.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDTBA.ps1"') | Set-Content -Path $TSxml
    (Get-Content -Path $TSxml).replace('cscript.exe "%SCRIPTROOT%\ZTIGroups.wsf"','PowerShell.exe -file "%SCRIPTROOT%\PSDTBA.ps1"') | Set-Content -Path $TSxml
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Saving a copy of the updated TS.xml"
    Copy-Item -Path $tsEngine\ts.xml -Destination "$(Get-PSDLocalDataPath)\"

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"
    Write-PSDEvent -MessageID 41016 -severity 4 -Message "PSD beginning deployment"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Done in PSDStart for now, handing over to Task Sequence by running $tsEngine\TSMBootstrap.exe /env:SAStart"
    Write-PSDBootInfo -SleepSec 0 -Message "Running Task Sequence"
    Stop-PSDLogging
    
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Looking for $tsEngine\TSMBootstrap.exe"
    If (!(Test-Path -Path "$tsEngine\TSMBootstrap.exe"))
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $tsEngine\TSMBootstrap.exe" -Loglevel 3
        Show-PSDInfo -Message "Unable to access $tsEngine\TSMBootstrap.exe" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
    }
    $result = Start-Process -FilePath "$tsEngine\TSMBootstrap.exe" -ArgumentList "/env:SAStart" -Wait -Passthru
}

# If we are in WinPE and we have deployed an operating system, we should write logfiles to the new drive
If ($BootfromWinPE)
{
    # Assuming that the first Volume having mspaint.exe is the correct OS volume
    $Drives = Get-PSDrive | ? Provider -eq FileSystem
    Foreach ($Drive in $Drives)
    {
        # TODO: Need to find a better file for detection of running OS
        If (Test-Path -Path "$($Drive.Name):\Windows\System32\mspaint.exe")
        {
            Start-PSDLogging -Logpath "$($Drive.Name):\MININT\SMSOSD\OSDLOGS"

            Break
        }
    }
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): logPath is now $logPath"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Task Sequence is done, PSDStart.ps1 is now in charge.."

# Make sure variables.dat is in the current local directory
If (Test-Path -Path "$(Get-PSDLocalDataPath)\Variables.dat")
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Variables.dat found in the correct location, $(Get-PSDLocalDataPath)\Variables.dat, no need to copy."
}
Else
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copying Variables.dat to the current location, $(Get-PSDLocalDataPath)\Variables.dat."
    Copy-Item $variablesPath "$(Get-PSDLocalDataPath)\"
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"

# Process the exit code from the task sequence
# Start-PSDLogging
#if($result.ExitCode -eq $null){$result.ExitCode = 0}
#Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Return code from TSMBootstrap.exe is $($result.ExitCode)"

Switch ($result.ExitCode)
{
    0 
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): SUCCESS!"
        Write-PSDEvent -MessageID 41015 -severity 4 -Message "PSD deployment completed successfully."
        
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Reset HKLM:\Software\Microsoft\Deployment 4"
        Get-ItemProperty "HKLM:\Software\Microsoft\Deployment 4" | Remove-Item -Force -Recurse

        $Executable = "regsvr32.exe"
        $Arguments  = "/u /s $tools\tscore.dll"
        If (!(Test-Path -Path "$tools\tscore.dll"))
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
            $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
        }

        $Executable = "$Tools\TSProgressUI.exe"
        $Arguments  = "/Unregister"
        If ((Test-Path -Path "$Tools\TSProgressUI.exe"))
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
            $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
        }

        # TODO Reboot for finishaction
        # Read-Host -Prompt "Check for FinishAction and cleanup leftovers"
        Write-Verbose "tsenv:FinishAction is $tsenv:FinishAction"
        
        If ($tsenv:FinishAction -eq "Reboot" -or $tsenv:FinishAction -eq "Restart")
        {
            $Global:RebootAfterTS = $True
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Will reboot for finishaction"
        }

        # Set-PSDDebugPause -Prompt "Before PSDFinal.ps1"
       
        Stop-PSDLogging

        Copy-Item -Path $env:SystemDrive\MININT\Cache\Scripts\PSDFinal.ps1 -Destination $env:TEMP
        Clear-PSDInformation
                
        #Checking for FinalSummary
        If (!($tsenv:SkipFinalSummary -eq "YES"))
        {
            Show-PSDInfo -Message "OSD SUCCESS!" -Severity Information -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        }

        If ($tsenv:PSDPause -eq "YES")
        {
            Read-Host -Prompt "Exit 0"
        }

        # Read-Host -Prompt "Check for finish action and cleanup leftovers"
        # Check for finish action and cleanup leftovers
        
        If ($RebootAfterTS -eq $True)
        {
            Start-Process powershell -ArgumentList "$env:TEMP\PSDFinal.ps1 -Restart $true -ParentPID $PID" -WindowStyle Hidden -Wait
        }
        Else
        {
            Start-Process powershell -ArgumentList "$env:TEMP\PSDFinal.ps1 -Restart $false -ParentPID $PID" -WindowStyle Hidden -Wait
        }

        # Done
        Exit 0
        
    }
    -2147021886 {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): REBOOT!"
        $variablesPath = Restore-PSDVariables

        Try
        {
            foreach ($i in (Get-ChildItem -Path TSEnv:))
            {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Property $($i.Name) is $($i.Value)"
            }
        }
        Catch
        {
        
        }


        If ($env:SYSTEMDRIVE -eq "X:")
        {
            # We are running in WinPE and need to reboot, if we have a hard disk, then we need files to continute the TS after reboot, copy files...
            # Exit with a zero return code and let Windows PE reboot

            # Assuming that the first Volume having mspaint.exe is the correct OS volume
            $Drives = Get-PSDrive | ? Provider -eq FileSystem
            Foreach ($Drive in $Drives)
            {
                # TODO: Need to find a better file for detection of running OS
                If (Test-Path -Path "$($Drive.Name):\Windows\System32\mspaint.exe")
                {
                    #Copy files needed for full OS

                    Write-PSDLog -Message "Copy-Item $scripts\PSDStart.ps1 $($Drive.Name):\MININT\Scripts"
                    Initialize-PSDFolder "$($Drive.Name):\MININT\Scripts"
                    Copy-Item "$scripts\PSDStart.ps1" "$($Drive.Name):\MININT\Scripts"

                    Try
                    {
                        $drvcache = "$($Drive.Name):\MININT\Cache"
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy-Item X:\Deploy\Tools -Destination $drvcache"
                        $cres = Copy-Item -Path "X:\Deploy\Tools" -Destination "$drvcache" -Recurse -Force -Verbose -PassThru
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $cres"
                        
                        #simulate download to x:\MININT\Cache\Tools
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy-Item X:\Deploy\Tools -Destination X:\MININT\Cache\Tools"
                        $cres = Copy-Item -Path "X:\Deploy\Tools" -Destination "X:\MININT\Cache" -Recurse -Force -Verbose -PassThru
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $cres"

                        #Copies from x:\MININT\Cache to target drive
                        $Modules = Get-PSDContent "Tools\Modules"
                        Write-PSDLog -Message "Copy-PSDFolder $Modules $($Drive.Name):\MININT\Tools\Modules"
                        Copy-PSDFolder "$Modules" "$($Drive.Name):\MININT\Tools\Modules"
                        
                        #Copies from x:\MININT\Cache\Tools\<arc> to target drive
                        $Tools = Get-PSDContent "Tools\$($tsenv:Architecture)"
                        Write-PSDLog -Message "Copy-PSDFolder $Tools $($Drive.Name):\MININT\Tools\$($tsenv:Architecture)"
                        Copy-PSDFolder "$Tools" "$($Drive.Name):\MININT\Tools\$($tsenv:Architecture)"

                    }
                    Catch
                    {
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy failed"
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $_"
                    }

                    Write-PSDLog -Message "Copy-PSDFolder $Certificates $($Drive.Name):\MININT\Certificates"
                    $Certificates = Get-PSDContent "PSDResources\Certificates"
                    Copy-PSDFolder "$Certificates" "$($Drive.Name):\MININT\Certificates"

                    # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy items from X:\Deploy\Tools to $($tsenv:OSVolume):\MININT\Cache\Tools"
                    # Copy-PSDFolder -Source X:\Deploy\Tools -Destination "$($tsenv:OSVolume):\MININT\Cache\Tools"
                    # Get-ChildItem -Path "$($tsenv:OSVolume):\MININT\Cache\Tools" -Filter ts.xml -Recurse | Remove-Item -Force
                    # Get-ChildItem -Path "$($tsenv:OSVolume):\MININT\Cache\Tools" -Filter variables.dat -Recurse | Remove-Item -Force

                    If ($PSDDeBug)
                    {
                        New-Item -Path "$($Drive.Name):\MININT\PSDDebug.txt" -ItemType File -Force
                    }

                    #Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): We are now on line 775 and we are doing a break on line 776..."
                    #Break
                }
            }

            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exit with a zero return code and let Windows PE reboot"
            Stop-PSDLogging

            If ($tsenv:PSDPause -eq "YES")
            {
                Read-Host -Prompt "Exit -2147021886 (WinPE)"
            }

            Exit 0
        }

        Else
        {
            # In full OS, need to initiate a reboot
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): In full OS, need to initiate a reboot"

            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Saving Variables"
            $variablesPath = Save-PSDVariables

            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Finding out where the tools folder is..."
            $Tools = Get-PSDContent -Content "Tools\$($tsenv:Architecture)"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Tools is now $Tools"
            
            $Executable = "regsvr32.exe"
            $Arguments = "/u /s $tools\tscore.dll"
            If (Test-Path -Path "$tools\tscore.dll")
            {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
                $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
            }
            If ($return -ne 0)
            {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to unload $tools\tscore.dll" -Loglevel 2
            }

            $Executable = "$Tools\TSProgressUI.exe"
            $Arguments = "/Unregister"
            If (Test-Path -Path "$Tools\TSProgressUI.exe")
            {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
                $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
            }

            If ($return -ne 0)
            {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to unload $Tools\TSProgressUI.exe" -Loglevel 2
            }

            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Restart, see you on the other side... (Shutdown.exe /r /t 30 /f)"
            
            If ($tsenv:PSDPause -eq "YES")
            {
                Read-Host -Prompt "Exit -2147021886 (Windows)"
            }
            
            #Restart-Computer -Force
            Shutdown.exe /r /t 30 /f

            Stop-PSDLogging
            Exit 0
        }
    }
    Default 
    {
        # Exit with a non-zero return code
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Task sequence failed, rc = $($result.ExitCode)"

        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Reset HKLM:\Software\Microsoft\Deployment 4"
        Get-ItemProperty "HKLM:\Software\Microsoft\Deployment 4"  -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse

        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Reset HKLM:\Software\Microsoft\SMS"
        Get-ItemProperty "HKLM:\Software\Microsoft\SMS" -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse

        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Findig out where the tools folder is..."
        $Tools = Get-PSDContent -Content "Tools\$($tsenv:Architecture)"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Tools is now $Tools"

        $Executable = "regsvr32.exe"
        $Arguments  = "/u /s $tools\tscore.dll"
        If (Test-Path -Path "$tools\tscore.dll")
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
            $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
        }

        $Executable = "$Tools\TSProgressUI.exe"
        $Arguments  = "/Unregister"
        If (Test-Path -Path "$Tools\TSProgressUI.exe")
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
            $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
        }

        Clear-PSDInformation
        Stop-PSDLogging

        #Invoke-PSDInfoGather
        Write-PSDEvent -MessageID 41014 -severity 1 -Message "PSD deployment failed, Return Code is $($result.ExitCode)"
        Show-PSDInfo -Message "Task sequence failed, Return Code is $($result.ExitCode)" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot

        Exit $result.ExitCode
    }
}
