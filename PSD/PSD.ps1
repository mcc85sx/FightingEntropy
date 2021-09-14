# [0] [PSDApplications.ps1]
<#
.SYNOPSIS
    Installs the apps specified in task sequence variables Applications and MandatoryApplications.
.DESCRIPTION
    Installs the apps specified in task sequence variables Applications and MandatoryApplications.
.LINK
    https://github.com/FriendsOfMDT/PSD
.NOTES
          FileName: PSDApplications.ps1
          Solution: PowerShell Deployment for MDT
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy, @AndHammarskjold
          Primary: @jarwidmark 
          Created: 
          Modified: 2019-05-17

          Version - 0.0.0 - () - Finalized functional version 1.

          TODO:

.Example
#>
param (

)

# Load core modules
Import-Module PSDUtility
Import-Module PSDDeploymentShare

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load core modules"

# Internal functions

# Function to install a specified app
function Install-PSDApplication
{
    param(
      [parameter(Mandatory=$true, ValueFromPipeline=$true)]
      [string] $id
    )

    # Make sure we access to the application folder
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Make sure the app exists"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Make sure we access to the application folder"
    if ((Test-Path "DeploymentShare:\Applications") -ne $true)
    {
        
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): no access to DeploymentShare:\Applications , skipping."
        return 0
    }

    # Make sure the app exists
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Make sure the app exists"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Make sure the app exists DeploymentShare:\Applications\$id"
    if ((Test-Path "DeploymentShare:\Applications\$id") -ne $true)
    {
        
        #Write-Verbose "$($MyInvocation.MyCommand.Name): Unable to find application $id, skipping."
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to find application $id, skipping."
        return 0
    }

    # Get the app
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Get the app"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Get the app"
    $app = Get-Item "DeploymentShare:\Applications\$id"

    #Write-Verbose "$($MyInvocation.MyCommand.Name): Processing $($app.Name)"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing :$($app.Name)"

    # Process dependencies (recursive)
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Process dependencies (recursive)"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Process dependencies (recursive)"
    if ($app.Dependency.Count -ne 0)
    {
        $app.Dependency | Install-PSDApplication
    }

    # Check if the app has been installed already
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Check if the app has been installed already"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check if the app has been installed already"
    $alreadyInstalled = @()
    $alreadyInstalled = @((Get-Item tsenvlist:InstalledApplications).Value)
    $found = $false
    $alreadyInstalled | ? {$_ -eq $id} | % {$found = $true}
    if ($found)
    {
        #Write-Verbose "$($MyInvocation.MyCommand.Name): Application $($app.Name) is already installed, skipping."
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Application $($app.Name) is already installed, skipping."
        return
    } 

    # TODO: Check supported platforms
    #Write-Verbose "$($MyInvocation.MyCommand.Name): TODO: Check supported platforms"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Check supported platforms"

    # TODO: Check for uninstall string
    #Write-Verbose "$($MyInvocation.MyCommand.Name): TODO: Check for uninstall string"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Check for uninstall string"

    # Set the working directory
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Set the working directory"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Set the working directory"
    $workingDir = ""
    if ($app.WorkingDirectory -ne "" -and $app.WorkingDirectory -ne ".")
    {
        if ($app.WorkingDirectory -like ".\*")
        {
            # App content is on the deployment share, get it
            #Write-Verbose "$($MyInvocation.MyCommand.Name): App content is on the deployment share, get it"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): App content is on the deployment share, get it"
            $appContent = Get-PSDContent -Content "$($app.WorkingDirectory.Substring(2))"
            $workingDir = $appContent
        }
        else
        {
            $workingDir = $app.WorkingDirectory
        }
        # TODO: Substitute
        #Write-Verbose "$($MyInvocation.MyCommand.Name): TODO: Substitute"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Substitute"
        # TODO: Validate connection
        #Write-Verbose "$($MyInvocation.MyCommand.Name): TODO: Validate connection"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Validate connection"
    }

    # Install the app
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Install the app"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Install the app"

    if ($app.CommandLine -eq "")
    {
        #Write-Verbose "$($MyInvocation.MyCommand.Name): No command line specified (bundle)."
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No command line specified (bundle)."
    }
    elseif ($app.CommandLine -ilike "install-package *")
    {
        Invoke-Expression $($app.CommandLine)
    }
    elseif ($app.CommandLine -icontains ".appx" -or $app.CommandLine -icontains ".appxbundle")
    {
        # TODO: Process modern app
        #Write-Verbose "$($MyInvocation.MyCommand.Name): TODO: Process modern app"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Process modern app"
    }
    else
    {
        $cmd = $app.CommandLine
        # TODO: Substitute
        #Write-Verbose "$($MyInvocation.MyCommand.Name): TODO: Substitute"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Substitute"
        #Write-Verbose "$($MyInvocation.MyCommand.Name): About to run: $cmd"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $cmd"
        if ($workingDir -eq "")
        {
            $result = Start-Process -FilePath "$toolRoot\bddrun.exe" -ArgumentList $cmd -Wait -Passthru
        }
        else
        {
            #Write-Verbose "$($MyInvocation.MyCommand.Name): Setting working directory to $workingDir"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Setting working directory to $workingDir"
            $result = Start-Process -FilePath "$toolRoot\bddrun.exe" -ArgumentList $cmd -WorkingDirectory $workingDir -Wait -Passthru
        }
        # TODO: Check return codes
        #Write-Verbose "$($MyInvocation.MyCommand.Name): TODO: Check return codes"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Check return codes"
        #Write-Verbose "$($MyInvocation.MyCommand.Name): Application $($app.Name) return code = $($result.ExitCode)"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Application $($app.Name) return code = $($result.ExitCode)"
    }

    # Update list of installed apps
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Update list of installed apps"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Update list of installed apps"
    $alreadyInstalled += $id
    $tsenvlist:InstalledApplications = $alreadyInstalled

    # Reboot if specified
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Reboot if specified"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Reboot if specified"
    if ($app.Reboot -ieq "TRUE")
    {
        return 3010
    }
    else
    {
        return 0
    }
}


# Main code
#Write-Verbose "$($MyInvocation.MyCommand.Name): Main code"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Main code"

# Get tools
#Write-Verbose "$($MyInvocation.MyCommand.Name): Get tools"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Get tools"
$toolRoot = Get-PSDContent "Tools\$($tsenv:Architecture)"


# Single application install initiated by a Task Sequence action
# Note: The ApplicationGUID variable isn’t set globally. It’s set only within the scope of the Install Application action/step. One of the hidden mysteries of the task sequence engine :)

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Checking for single application install step"
If ($tsenv:ApplicationGUID -ne "") {
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Mandatory Single Application install indicated. Guid is $($tsenv:ApplicationGUID)"
    Install-PSDApplication $tsenv:ApplicationGUID
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Mandatory Single Application installed, exiting application step"
    Exit
}
else
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No Single Application install found. Continue with checking for dynamic applications"
}
			

# Process applications
#Write-Verbose "$($MyInvocation.MyCommand.Name): Process applications"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Process applications"
if ($tsenvlist:MandatoryApplications.Count -ne 0)
{
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Processing $($tsenvlist:MandatoryApplications.Count) mandatory applications."
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing $($tsenvlist:MandatoryApplications.Count) mandatory applications."
    $tsenvlist:MandatoryApplications | Install-PSDApplication
}
else
{
    #Write-Verbose "$($MyInvocation.MyCommand.Name): No mandatory applications specified."
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No mandatory applications specified."
}

if ($tsenvlist:Applications.Count -ne 0)
{
    #Write-Verbose "$($MyInvocation.MyCommand.Name): Processing $($tsenvlist:Applications.Count) applications."
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing $($tsenvlist:Applications.Count) applications."
    $tsenvlist:Applications | % { Install-PSDApplication $_ }
}
else
{
    #Write-Verbose "$($MyInvocation.MyCommand.Name): No applications specified."
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No applications specified."
}
####

# [1] [PSDApplyOS.ps1]
<#
.SYNOPSIS
    Apply the specified operating system.
.DESCRIPTION
    Apply the specified operating system.
.LINK
    https://github.com/FriendsOfMDT/PSD
.NOTES
          FileName: PSDApplyOS.ps1
          Solution: PowerShell Deployment for MDT
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-05-09

          Version - 0.0.0 - () - Finalized functional version 1.
          Version - 0.1.0 - (2019-05-09) - Check access to image file
          Version - 0.1.1 - (2019-05-09) - Cleanup white space

          TODO:

.Example
#>

param (

)

# Load core modules
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module DISM
Import-Module PSDUtility
Import-Module PSDDeploymentShare

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load core modules"

# Get the OS image details
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Get the OS image details"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Operating system: $($tsenv:OSGUID)"
$os = Get-Item "DeploymentShare:\Operating Systems\$($tsenv:OSGUID)"
$osSource = Get-PSDContent "$($os.Source.Substring(2))"
$image = "$osSource$($os.ImageFile.Substring($os.Source.Length))"
$index = $os.ImageIndex

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): os is now $os"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): osSource is now $osSource"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): image is now $image"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): index is now $index"

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Verifying access to $image"
if((Test-Path -Path $image) -ne $true)
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to continue, could not access the WIM $image"
    Show-PSDInfo -Message "Unable to continue, could not access the WIM $image" -Severity Error
    Exit 1
}

# Create a local scratch folder
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Create a local scratch folder"
$scratchPath = "$(Get-PSDLocalDataPath)\Scratch"
Initialize-PSDFolder $scratchPath

# Apply the image
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Apply the image"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Applying image $image index $index to $($tsenv:OSVolume)"
Show-PSDActionProgress -Message "Applying $($image | Split-Path -Leaf) " -Step "1" -MaxStep "2"
$startTime = Get-Date
Expand-WindowsImage -ImagePath $image -Index $index -ApplyPath "$($tsenv:OSVolume):\" -ScratchDirectory $scratchPath
$duration = $(Get-Date) - $startTime
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Time to apply image: $($duration.ToString('hh\:mm\:ss'))"

# Inject drivers using DISM if Setup.exe is missing
#$ImageFolder = $image | Split-Path | Split-Path
#Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Checking if Setup.exe is present in $ImageFolder"
#if(!(Test-Path -Path "$ImageFolder\Setup.exe"))
#{
#    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Could not find Setup.exe, applying Unattend.xml (Use-WindowsUnattend)"
#    if(Test-Path -Path "$($tsenv:OSVolume):\Windows\Panther\Unattend.xml")
#    {
#        Use-WindowsUnattend -Path "$($tsenv:OSVolume):\" -UnattendPath "$($tsenv:OSVolume):\Windows\Panther\Unattend.xml" -ScratchDirectory $scratchPath
#    }
#    else
#    {
#        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Could not $($tsenv:OSVolume):\Windows\Panther\Unattend.xml"
#    }
#    
#}
#else
#{
#    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Found Setup.exe, no need to apply Unattend.xml"
#}

# Make the OS bootable
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Make the OS volume bootable"
Show-PSDActionProgress -Message "Make the OS volume bootable" -Step "2" -MaxStep "2"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Configuring volume $($tsenv:BootVolume) to boot $($tsenv:OSVolume):\Windows."
if ($tsenv:IsUEFI -eq "True")
{
    $args = @("$($tsenv:OSVolume):\Windows", "/s", "$($tsenv:BootVolume):", "/f", "uefi")
}
else 
{
    $args = @("$($tsenv:OSVolume):\Windows", "/s", "$($tsenv:BootVolume):")
}
#Added for troubleshooting (admminy)
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Running bcdboot.exe with the following arguments: $args"

$result = Start-Process -FilePath "bcdboot.exe" -ArgumentList $args -Wait -Passthru
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): BCDBoot completed, rc = $($result.ExitCode)"

# Fix the EFI partition type
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Fix the EFI partition type if using UEFI"
if ($tsenv:IsUEFI -eq "True")
{
	# Fix the EFI partition type
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Fix the EFI partition type"
	@"
select volume $($tsenv:BootVolume)
set id=c12a7328-f81f-11d2-ba4b-00a0c93ec93b
exit
"@ | diskpart
}

# Fix the recovery partition type for MBR disks, using diskpart.exe since the PowerShell cmdlets are currently missing some options (like ID for MBR disks)
if ($tsenv:IsUEFI -eq "False")
{
    # Fix the recovery partition type 
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Fix the recovery partition type"
  @"
select volume $($tsenv:RecoveryVolume)
set id=27 override
exit
"@ | diskpart
}
####

# [2] [PSDConfigure.ps1]
<#
.SYNOPSIS
    Configure the unattend.xml to be used with the new OS.
.DESCRIPTION
    Configure the unattend.xml to be used with the new OS.
.LINK
    https://github.com/FriendsOfMDT/PSD
.NOTES
          FileName: PSDConfigure.ps1
          Solution: PowerShell Deployment for MDT
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-05-17

          Version - 0.0.0 - () - Finalized functional version 1.
          Version - 0.1.1 - () - Removed $tsenv:SMSTSRebootRequested = "true" in the end, if not the script will force TS to reboot

          TODO:

.Example
#>

param (

)

# Load core modules
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module PSDUtility
Import-Module DISM
Import-Module PSDDeploymentShare

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true){
    $verbosePreference = "Continue"
}
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load core modules"

# Fix issue if Domainjoin value is blank as well as joinworkgroup
if($tsenv:JoinDomain -eq "" -or $tsenv:JoinDomain -eq $null){
    $tsenv:JoinWorkgroup = "WORKGROUP"
}

# Load the unattend.xml
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load the unattend.xml"
$tsInfo = Get-PSDContent "Control\$($tsenv:TaskSequenceID)"
[xml] $unattend = Get-Content "$tsInfo\unattend.xml"
$namespaces = @{unattend='urn:schemas-microsoft-com:unattend'}
$changed = $false
$unattendXml = "$($tsenv:OSVolume):\Windows\Panther\Unattend.xml"
Initialize-PSDFolder "$($tsenv:OSVolume):\Windows\Panther"

# Substitute the values in the unattend.xml
Show-PSDActionProgress -Message "Updating the local unattend.xml" -Step "1" -MaxStep "2"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Substitute the values in the unattend.xml"
$scripts = Get-PSDContent "Scripts"
[xml] $config = Get-Content "$scripts\ZTIConfigure.xml"
$config | Select-Xml "//mapping[@type='xml']" | % {

    # Process each substitution rule from ZTIConfigure.xml
    $variable = $_.Node.id
    $value = (Get-Item tsenv:$variable).Value
    $removes = $_ | Select-Xml "remove"
    $_ | Select-Xml "xpath" | % {

        # Process each XPath query
        $xpath = $_.Node.'#cdata-section'
        $removeIfBlank = $_.Node.removeIfBlank
        $unattend | Select-Xml -XPath $xpath -Namespace $namespaces | % {

            # Process found entry in the unattend.xml
            $prev = $_.Node.InnerText
            if ($value -eq "" -and $prev -eq "" -and $removeIfBlank -eq "Self")
            {
                # Remove the node
                $_.Node.parentNode.removeChild($_.Node) | Out-Null
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Removed $xpath from unattend.xml because the value was blank."
                $changed = $true
            }
            elseif ($value -eq "" -and $prev -eq "" -and $removeIfBlank -eq "Parent")
            {
                # Remove the node
                $_.Node.parentNode.parentNode.removeChild($_.Node.parentNode) | Out-Null
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Removed parent of $xpath from unattend.xml because the value was blank."
                $changed = $true
            }
            elseif ($value -ne "")
            {
                # Set the new value
                $_.Node.InnerText = $value
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Updated unattend.xml with $variable = $value (value was $prev)."
                $changed = $true

                # See if this has a parallel "PlainText" entry, and if it does, set it to true
                $_.Node.parentNode | Select-Xml -XPath "unattend:PlainText" -Namespace $namespaces | % {
                    $_.Node.InnerText = "true"
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Updated PlainText entry to true."
                }

                # Remove any contradictory entries
                $removes | % {
                    $removeXpath = $_.Node.'#cdata-section'
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): *** $removeXpath"
                    $unattend | Select-Xml -XPath $removeXpath -Namespace $namespaces | % {
                        $_.Node.parentNode.removeChild($_.Node) | Out-Null
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Removed $removeXpath entry from unattend.xml."
                    }
                }
            }
            else
            {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No value found for $variable."
            }
        }
    }
}

# Save the file
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Save the file"
$unattend.Save($unattendXml)
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Saved $unattendXml."

# TODO: Copy patches
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Copy patches"

# Apply the unattend.xml
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Apply the unattend.xml"
$scratchPath = "$(Get-PSDLocalDataPath)\Scratch"
Initialize-PSDFolder $scratchPath
Show-PSDActionProgress -Message "Applying local unattend.xml to the OS volume" -Step "2" -MaxStep "2"
Use-WindowsUnattend -UnattendPath $unattendXml -Path "$($tsenv:OSVolume):\" -ScratchDirectory $scratchPath -NoRestart

# The following section has been moved to PSDStart.ps1
# Copy needed script and module files
# Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy needed script and module files"

# Initialize-PSDFolder "$($tsenv:OSVolume):\MININT\Scripts"
# Copy-Item "$scripts\PSDStart.ps1" "$($tsenv:OSVolume):\MININT\Scripts"

# $modules = Get-PSDContent "Tools\Modules"
# Copy-PSDFolder "$modules" "$($tsenv:OSVolume):\MININT\Tools\Modules"

# Save all the current variables for later use
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Save all the current variables for later use"
Save-PSDVariables

# Request a reboot
#$tsenv:SMSTSRebootRequested = "true"
####

# [3] [PSDDeploymentShare.psm1]
<#
.SYNOPSIS

.DESCRIPTION

.LINK

.NOTES
          FileName: PSDDeploymentShare.psd1
          Solution: PowerShell Deployment for MDT
          Purpose: Connect to a deployment share and obtain content from it, using either HTTP(s) or SMB as needed.
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-05-09

          Version - 0.0.0 - () - Finalized functional version 1.
          Version - 0.1.1 - () - Removed blocker if we item could not be found, instead we continue and log, error handling must happen when object is needed, not when downloading.
          Version - 0.1.2 - () - Added Test-PSDContent,Test-PSDContentWeb,Test-PSDContentUNC - The ability to test if content exists before downloading

          TODO:

.Example
#>

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Importing module Bitstransfer"

Import-Module BitsTransfer -Global -Force -Verbose:$False

# Local variables
$global:psddsDeployRoot = ""
$global:psddsDeployUser = ""
$global:psddsDeployPassword = ""
$global:psddsCredential = ""

# Main function for establishing a connection 
function Get-PSDConnection{
    param (
        [string] $deployRoot,
        [string] $username,
        [string] $password
    )

    if(($username -eq "\") -or ($username -eq "")){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No UserID specified"
        $username = Get-PSDInputFromScreen -Header UserID -Message "Enter User ID [DOMAIN\Username] or [COMPUTER\Username]" -ButtonText Ok
        $tsenv:UserDomain = $username | Split-Path
        $tsenv:UserID = $username | Split-Path -Leaf
    }
    if($password -eq ""){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No UserPassword specified"
        $Password = Get-PSDInputFromScreen -Header UserPassword -Message "Enter Password"  -ButtonText Ok -PasswordText
        $tsenv:UserPassword = $Password
    }
    Save-PSDVariables | Out-Null
    # Save values in local variables
    $global:psddsDeployRoot = $deployRoot
    $global:psddsDeployUser = $username
    $global:psddsDeployPassword = $password

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): global:psddsDeployRoot is now $global:psddsDeployRoot"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): global:psddsDeployUser is now $global:psddsDeployUser"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): global:psddsDeployPassword is now $global:psddsDeployPassword"

    # Get credentials
    if (!$global:psddsDeployUser -or !$global:psddsDeployPassword)
    {
        $global:psddsCredential = Get-Credential -Message "Specify credentials needed to connect to $uncPath"
    }
    else
    {
        $secure = ConvertTo-SecureString $global:psddsDeployPassword -AsPlainText -Force
        $global:psddsCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $global:psddsDeployUser, $secure
    }

    # Make sure we can connect to the specified location
    if ($global:psddsDeployRoot -ilike "http*")
    {
        # Get a copy of the Control folder
        $cache = Get-PSDContent -Content "Control"
        $root = Split-Path -Path $cache -Parent

        # Get a copy of the Templates folder
        $null = Get-PSDContent -Content "Templates"

        # Connect to the cache
        Get-PSDProvider -DeployRoot $root
    }
    elseif ($global:psddsDeployRoot -like "\\*") {
        # Connect to a UNC path
        try
        {
            New-PSDrive -Name (Get-PSDAvailableDriveLetter) -PSProvider FileSystem -Root $global:psddsDeployRoot -Credential $global:psddsCredential -Scope Global
        }
        catch
        {
            
        }
        Get-PSDProvider -DeployRoot $global:psddsDeployRoot
    }
    else
    {
        # Connect to a local path (no credential needed)
        Get-PSDProvider -DeployRoot $global:psddsDeployRoot
    }

}

# Internal function for initializing the MDT PowerShell provider, to be used to get 
# objects from the MDT deployment share.
function Get-PSDProvider{
    param (
        [string] $deployRoot
    )
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): deployRoot is now $deployRoot"

    # Set an install directory if necessary (needed so the provider can find templates)
    if ((Test-Path "HKLM:\Software\Microsoft\Deployment 4") -eq $false){
        $null = New-Item "HKLM:\Software\Microsoft\Deployment 4" -Force
        Set-ItemProperty "HKLM:\Software\Microsoft\Deployment 4" -Name "Install_Dir" -Value "$deployRoot\" -Force
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Set MDT Install_Dir to $deployRoot\ for MDT Provider."
    }

    # Set an install directory if necessary (needed so the provider can find templates)
    if ((Test-Path "HKLM:\Software\Microsoft\Deployment 4\Install_Dir") -eq $false){
        Set-ItemProperty "HKLM:\Software\Microsoft\Deployment 4" -Name "Install_Dir" -Value "$deployRoot\" -Force
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Set MDT Install_Dir to $deployRoot\ for MDT Provider."
    }


    # Load the PSSnapIn PowerShell provider module
    $modules = Get-PSDContent -Content "Tools\Modules"
    Import-Module "$modules\Microsoft.BDD.PSSnapIn" -Verbose:$False

    # Create the PSDrive
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating MDT provider drive DeploymentShare: at $deployRoot"
    $Result = New-PSDrive -Name DeploymentShare -PSProvider MDTProvider -Root $deployRoot -Scope Global
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating MDT provider drive $($Result.name): at $($result.Root)"
}

# Internal function for getting the next available drive letter.
function Get-PSDAvailableDriveLetter{
    $drives = (Get-PSDrive -PSProvider filesystem).Name
    foreach ($letter in "ZYXWVUTSRQPONMLKJIHGFED".ToCharArray()) {
        if ($drives -notcontains $letter) {
            return $letter
            break
        }
    }
}

# Function for finding and retrieving the specified content.  The source location specifies
# a relative path within the deployment share.  The destination specifies the local path where
# the content should be placed.  If no destination is specified, it will be placed in a
# cache folder.
function Get-PSDContent{
    param (
        [string] $content,
        [string] $destination = ""
    )

    $dest = ""

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Content:[$content], destination:[$destination]"

    # Track the time
    # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Track the time"
    $start = Get-Date

    # If the destination is blank, use a default value
    # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): If the destination is blank, use a default value"
    if ($destination -eq ""){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Destination is blank, running $PSDLocalDataPath = Get-PSDLocalDataPath"
        $PSDLocalDataPath = Get-PSDLocalDataPath
        # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): PSDLocalDataPath is $PSDLocalDataPath"
        $dest = "$PSDLocalDataPath\Cache\$content"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Dest is $dest"
    }
    else{
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Destination is NOT blank"
        $dest = $destination
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Dest is $dest"
    }

    # If the destination already exists, assume the content was already downloaded.
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): If the destination already exists, assume the content was already downloaded."
    # Otherwise, download it, copy it, .
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Otherwise, download it, copy it."

    if (Test-Path $dest){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Access to $dest is OK"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Already copied $content, not copying again."
    }
    elseif ($global:psddsDeployRoot -ilike "http*"){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): global:psddsDeployRoot is now $global:psddsDeployRoot"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Running Get-PSDContentWeb -content $content -destination $dest"
        Get-PSDContentWeb -content $content -destination $dest
    }
    elseif ($global:psddsDeployRoot -like "\\*"){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): global:psddsDeployRoot is now $global:psddsDeployRoot"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Running Get-PSDContentUNC -content $content -destination $dest"
        Get-PSDContentUNC -content $content -destination $dest
    }
    else{
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Path for $content is already local, not copying again"
    }

    # Report the time
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Report the time"
    $elapsed = (Get-Date) - $start
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Elapsed time to transfer $content : $elapsed"
    # Return the destination
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Return the destination $dest"
    return $dest
}

# Internal function for retrieving content from a UNC path (file share)
function Get-PSDContentUNC
{
    param (
        [string] $content,
        [string] $destination
    )

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copying from $($global:psddsDeployRoot)\$content to $destination"
    Copy-PSDFolder "$($global:psddsDeployRoot)\$content" $destination
}

# Internal function for retrieving content from URL (web server/HTTP)
function Get-PSDContentWeb{
    param (
        [string] $content,
        [string] $destination
    )
    
    $maxAttempts = 3
    $attempts = 0
    $RetryInterval = 5
    $Retry = $True

    if($tsenv:BranchCacheEnabled -eq "YES"){
        if($tsenv:SMSTSDownloadProgram -ne "" -or $tsenv:SMSTSDownloadProgram -ne $null){
            if((Get-Process | Where-Object Name -EQ tsmanager).count -ge 1){
                
                # Create the destination folder
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating $destination"
                try{
                    New-Item -Path $destination -ItemType Directory -Force | Out-Null
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating $destination was a success"
                }catch{
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating $destination was a failure"
                    Return
                }
                

                # Make some calc...
                $fullSource = "$($global:psddsDeployRoot)/$content"
                $fullSource = $fullSource.Replace("\", "/")
                #$request = [System.Net.WebRequest]::Create($fullSource)
                $topUri = New-Object system.uri $fullSource
                #$prefixLen = $topUri.LocalPath.Length

                # We are using an ACP/ assume it works in WinPE as well. We use ACP as BITS does not function as regular BITS in WinPE, so cannot use PS cmdlet.
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Downloading files using ACP."

                # Begin create regular ACP style .ini file
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Create regular ACP style .ini file"

                #Needed, do not remove.
                $PSDPkgId = "PSD12345" 

                # Create regular ACP style .ini file
                $iniPath = "$env:tmp\$PSDPkgId"+"_Download.ini"
                Set-Content -Value '[Download]' -Path $iniPath -Force -Encoding Ascii
                Add-Content -Value "Source=$topUri" -Path $iniPath
                Add-Content -Value "Destination=$destination" -Path $iniPath
                Add-Content -Value "MDT=true" -Path $iniPath

                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Destination=$destination"
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Source=$topUri"

                if((Get-Process | Where-Object Name -EQ TSManager).count -ne 0){
                    Add-Content -Value "Username=$($tsenv:UserDomain)\$($tsenv:UserID)" -Path $iniPath
                    Add-Content -Value "Password=$($tsenv:UserPassword)" -Path $iniPath
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Username=$($tsenv:UserDomain)\$($tsenv:UserID)"
                }

                # ToDo, check that the ini file exists before we try...
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Downloading information saved to $iniPath so starting $tsenv:SMSTSDownloadProgram"

                if((Test-Path -Path $iniPath) -eq $true){
                    #Start-Process -Wait -FilePath "$tsenv:SMSTSDownloadProgram" -ArgumentList "$iniPath $PSDPkgId `"$($destination)`""
                    $return = Start-Process -Wait -WindowStyle Hidden -FilePath "$tsenv:SMSTSDownloadProgram" -ArgumentList "$iniPath $PSDPkgId `"$($destination)`"" -PassThru
                    if($return.ExitCode -eq 0){
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $tsenv:SMSTSDownloadProgram Success"
                        $Retry = $False
                        Return
                    }
                    else{
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $tsenv:SMSTSDownloadProgram Fail with exitcode $($return.ExitCode)" -Loglevel 2
                    }
                    # ToDo hash verification?
                }
                else{
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $iniPath, aborting..." -Loglevel 2
                    # Show-PSDInfo -Message "Unable to access $iniPath, aborting..." -Severity Information
                    # Start-Process PowerShell -Wait
                    # Exit 1
                }
            }
            else{
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to use ACP since TSManager is not running, using fallback"
            }
        }
    }

    while($Retry){
    $attempts++
        try{
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Retrieving directory listing of $fullSource via WebDAV."
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Attempt $attempts of $maxAttempts"

            $fullSource = "$($global:psddsDeployRoot)/$content"
            $fullSource = $fullSource.Replace("\", "/")
            $request = [System.Net.WebRequest]::Create($fullSource)
            $topUri = new-object system.uri $fullSource
            $prefixLen = $topUri.LocalPath.Length
        
            $request.UserAgent = "PSD"
            $request.Method = "PROPFIND"
            $request.ContentType = "text/xml"
            $request.Headers.Set("Depth", "infinity")
            $request.Credentials = $global:psddsCredential

            $response = $request.GetResponse()
            $Retry = $False
        }
        catch{
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to retrieve directory listing!"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $($_.Exception.InnerException)"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $response"
            
            #$Message = "Unable to Retrieve directory listing of $($fullSource) via WebDAV. Error message: $($_.Exception.Message)"
            #Show-PSDInfo -Message "$($Message)" -Severity Error
            #Start-Process PowerShell -Wait
            #Break 
            
            if($attempts -ge $maxAttempts){
                Throw
            }
            else{
                Start-Sleep -Seconds $RetryInterval
            }
        }
    }

	if ($response -ne $null){
        $sr = new-object System.IO.StreamReader -ArgumentList $response.GetResponseStream(),[System.Encoding]::Default
        [xml]$xml = $sr.ReadToEnd()		

        # Get the list of files and folders, to make this easier to work with
    	$results = @()
        $xml.multistatus.response | ? { $_.href -ine $url } | % {
            $uri = new-object system.uri $_.href
            $dest = $uri.LocalPath.Replace("/","\").Substring($prefixLen).Trim("\")
            $obj = [PSCustomObject]@{
                href = $_.href
                name = $_.propstat.prop.displayname
                iscollection = $_.propstat.prop.iscollection
                destination = $dest
            }
            $results += $obj
        }
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Directory listing retrieved with $($results.Count) items."

        # Create the folder structure
        $results | ? { $_.iscollection -eq "1"} | sort destination | % {
            $folder = "$destination\$($_.destination)"
            if (Test-Path $folder){
                # Already exists
            }
            else{
                $null = MkDir $folder
            }
        }

        # If possible, do the transfer using BITS.  Otherwise, download the files one at a time
        if($env:SYSTEMDRIVE -eq "X:"){
            # In Windows PE, download the files one at a time using WebClient
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Downloading files using WebClient."
            $wc = New-Object System.Net.WebClient
            $wc.Credentials = $global:psddsCredential
            $results | ? { $_.iscollection -eq "0"} | sort destination | % {
                $href = $_.href
                $fullFile = "$destination\$($_.destination)"
                try
                {
                    $wc.DownloadFile($href, $fullFile)
                }
                catch
                {
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to download file $href."
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $($_.Exception.InnerException)"
                }
            }            
        }
        else{
            # Create the list of files to download
            $sourceUrl = @()
            $destFile = @()
            $results | ? { $_.iscollection -eq "0"} | sort destination | % {
                $sourceUrl += [string]$_.href
                $fullFile = "$destination\$($_.destination)"
                $destFile += [string]$fullFile
            }
            # Do the download using BITS
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Downloading files using BITS."
            $bitsJob = Start-BitsTransfer -Authentication Ntlm -Credential $global:psddsCredential -Source $sourceUrl -Destination $destFile -TransferType Download -DisplayName "PSD Transfer" -Priority High
        }
    }
}

# Reconnection logic
if (Test-Path "tsenv:")
{
    if ($tsenv:DeployRoot -ne "")
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Reconnecting to the deployment share at $($tsenv:DeployRoot)."
        if ($tsenv:UserDomain -ne "")
        {
            Get-PSDConnection -deployRoot $tsenv:DeployRoot -username "$($tsenv:UserDomain)\$($tsenv:UserID)" -password $tsenv:UserPassword
        }
        else
        {
            Get-PSDConnection -deployRoot $tsenv:DeployRoot -username $tsenv:UserID -password $tsenv:UserPassword
        }
    }
}

function Test-PSDContent{
    param (
        [string] $content
    )
    if ($global:psddsDeployRoot -ilike "http*"){
        Return Test-PSDContentWeb -content $content
    }
    if ($global:psddsDeployRoot -like "\\*"){
        Return Test-PSDContentUNC -content $content
    }
}
function Test-PSDContentWeb{
    param (
        [string] $content
    )
    
    $maxAttempts = 3
    $attempts = 0
    $RetryInterval = 5
    $Retry = $True

    while($Retry){
    $attempts++
        try{
            #Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Retrieving directory listing of $fullSource via WebDAV."
            #Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Attempt $attempts of $maxAttempts"

            $fullSource = "$($global:psddsDeployRoot)/$content"
            $fullSource = $fullSource.Replace("\", "/")
            $request = [System.Net.WebRequest]::Create($fullSource)
            $topUri = new-object system.uri $fullSource
            $prefixLen = $topUri.LocalPath.Length
        
            $request.UserAgent = "PSD"
            $request.Method = "PROPFIND"
            $request.ContentType = "text/xml"
            $request.Headers.Set("Depth", "infinity")
            $request.Credentials = $global:psddsCredential

            $response = $request.GetResponse()
            $Retry = $False
        }
        catch{
            #Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to retrieve directory listing!"
            #Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $($_.Exception.InnerException)"
            #Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $response"
            
            #$Message = "Unable to Retrieve directory listing of $($fullSource) via WebDAV. Error message: $($_.Exception.Message)"
            #Show-PSDInfo -Message "$($Message)" -Severity Error
            #Start-Process PowerShell -Wait
            #Break 
            
            if($attempts -ge $maxAttempts){
                Throw
            }
            else{
                Start-Sleep -Seconds $RetryInterval
            }
        }
    }

	if ($response -ne $null){
        $sr = new-object System.IO.StreamReader -ArgumentList $response.GetResponseStream(),[System.Encoding]::Default
        [xml]$xml = $sr.ReadToEnd()		

        # Get the list of files and folders, to make this easier to work with
    	$results = @()
        $xml.multistatus.response | ? { $_.href -ine $url } | % {
            $uri = new-object system.uri $_.href
            $dest = $uri.LocalPath.Replace("/","\").Substring($prefixLen).Trim("\")
            $obj = [PSCustomObject]@{
                href = $_.href
                name = $_.propstat.prop.displayname
                iscollection = $_.propstat.prop.iscollection
                destination = $dest
            }
            $results += $obj
        }
    }
    Return $results
}
function Test-PSDContentUNC{
    param (
        [string] $content
    )
    Get-ChildItem "$($global:psddsDeployRoot)\$content"
}

Export-ModuleMember -function Get-PSDConnection
Export-ModuleMember -function Get-PSDContent
Export-ModuleMember -function Test-PSDContent
####

# [4] [PSDDrivers.ps1]
<#
.SYNOPSIS

.DESCRIPTION

.LINK

.NOTES
          FileName: PSDDrivers.ps1
          Solution: PowerShell Deployment for MDT
          Purpose: Download and install drivers
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-06-02

          Version - 0.0.0 - () - Finalized functional version 1.
          Version - 0.0.1 - () - Changed BaseDriverPath = "PSDResources\DriverPackages", to "fit" the new folder structure
          Version - 0.0.2 - () - Testing if there is a driver package to download.

          TODO:
          Verify that it works with new package format

          DriverGroup should be Array, solves fallback and more package, DriverGroup
            DriverGroup002=Windows 10 x64\Generic

          Add support for PNP

          Fallback Package as PNP (PSDDriverFallBackPNP=YES), default is NO

          Add support for nasty Universal Drivers  

.Example
#>

param (

)

# Load core modules
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module DISM
Import-Module PSDUtility
Import-Module PSDDeploymentShare

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true){
    $verbosePreference = "Continue"
}
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load core modules"

# Building source and destionation paths based on model DriverGroup001
$BaseDriverPath = "PSDResources\DriverPackages"
$SourceDriverPackagePath = ($BaseDriverPath + "\" + ($tsenv:DriverGroup001).Replace("\","-")).replace(" ","_")
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:DriverGroup001 is $($tsenv:DriverGroup001)"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): SourceDriverPackagePath is now $SourceDriverPackagePath"

# Check of a driver package exists
$DriverPackageName = $($SourceDriverPackagePath | Split-Path -Leaf)
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Searching for package"
if((Test-PSDContent -content $BaseDriverPath | Where-Object Name -EQ $DriverPackageName) -NE $null){

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $DriverPackageName found"

    #Copy drivers to cache
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy $SourceDriverPackagePath to cache "
    Show-PSDActionProgress -Message "Trying to download driver package : $($SourceDriverPackagePath | Split-Path -Leaf)" -Step "1" -MaxStep "1"
    Get-PSDContent -content $SourceDriverPackagePath

    #Get all ZIP files from the cache
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Getting drivers..."
    $Zips = Get-ChildItem -Path "$($tsenv:OSVolume):\MININT\Cache\PSDResources\DriverPackages" -Filter *.zip -Recurse

    #Did we find any?
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Found $($Zips.count) packages"
    Show-PSDActionProgress -Message "Found $($Zips.count) packages" -Step "1" -MaxStep "1"
    Foreach($Zip in $Zips){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unpacking $($Zip.FullName)"
        #Need to use this method, since the assemblys can not be loaded due to a issue...
        if($PSDDebug -eq $true){
            Start PowerShell -ArgumentList "Expand-Archive -Path $($Zip.FullName) -DestinationPath $($tsenv:OSVolume):\Drivers -Force -Verbose" -Wait
        }
        else{
            Start PowerShell -ArgumentList "Expand-Archive -Path $($Zip.FullName) -DestinationPath $($tsenv:OSVolume):\Drivers -Force" -Wait
        }
    }

    Start-Sleep -Seconds 1

    #What do we have here
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Get list of drivers from \Drivers"
    $Drivers = Get-ChildItem -Path "$($tsenv:OSVolume):\Drivers" -Filter *.inf -Recurse
    foreach($Driver in $Drivers){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $($Driver.Name) is now in the \Drivers folder"
        $TSxDriverInfo = Get-PSDDriverInfo -Path $Driver.FullName
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Driverinfo: Name:$($TSxDriverInfo.Name)  Vendor:$($TSxDriverInfo.Manufacturer)  Class:$($TSxDriverInfo.Class)  Date:$($TSxDriverInfo.Date)  Version:$($TSxDriverInfo.Version)"
    }
}
else{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No driver package found"
}


####

# [5] [PSDExportDriversInWinPE.ps1]
<#
.SYNOPSIS
    Update gathered information in the task sequence environment.
.DESCRIPTION
    Update gathered information in the task sequence environment.
.LINK
    https://github.com/FriendsOfMDT/PSD
.NOTES
          FileName: PSDGather.ps1
          Solution: PowerShell Deployment for MDT
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2020-06-16

          Version - 0.0.0 - () - Finalized functional version 1.
          TODO:

.Example
#>

[CmdletBinding()]
param (

)

# Load core module
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module PSDUtility
Import-Module PSDGather

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}

Write-PSDEvent -MessageID 41000 -severity 1 -Message "Starting: $($MyInvocation.MyCommand.Name)"
####

# [6] [PSDFinal.ps1]
# The Final Countdown
Param(
    $Restart,
    $ParentPID
)

Write-Verbose "Running Stop-Process -Id $ParentPID"
Stop-Process -Id $ParentPID -Force

$Folders = "MININT","Drivers"
Foreach($Folder in $Folders){
    Get-Volume | ? {-not [String]::IsNullOrWhiteSpace($_.DriveLetter) } | ? {$_.DriveType -eq 'Fixed'} | ? {$_.DriveLetter -ne 'X'} | ? {Test-Path "$($_.DriveLetter):\MININT"} | % {
        $localPath = "$($_.DriveLetter):\$Folder"
        if(Test-Path -Path "$localPath"){
            Write-Verbose "trying to remove $localPath"
            Remove-Item "$localPath" -Recurse -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }
    }
}

if($Restart -eq $True){
    Write-Verbose "Running Shutdown.exe /r /t 30 /f"
    Shutdown.exe /r /t 30 /f
}
####

# [7] [PSDGather.ps1]
<#
.SYNOPSIS
    Update gathered information in the task sequence environment.
.DESCRIPTION
    Update gathered information in the task sequence environment.
.LINK
    https://github.com/FriendsOfMDT/PSD
.NOTES
          FileName: PSDGather.ps1
          Solution: PowerShell Deployment for MDT
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2020-06-16

          Version - 0.0.0 - () - Finalized functional version 1.
          TODO:

.Example
#>

[CmdletBinding()]
param (

)

# Load core module
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module PSDUtility
Import-Module PSDGather

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}

Write-PSDEvent -MessageID 41000 -severity 1 -Message "Starting: $($MyInvocation.MyCommand.Name)"

# Gather local info to make sure key variables are set (e.g. Architecture)
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Gather local info to make sure key variables are set (e.g. Architecture)"
Get-PSDLocalInfo

# Save all the current variables for later use
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Save all the current variables for later use"
Save-PSDVariables
####

# [8] [PSDGather.psm1]
<#
.SYNOPSIS

.DESCRIPTION

.LINK

.NOTES
          FileName: PSDUtility.psd1
          Solution: PowerShell Deployment for MDT
          Purpose: Module for gathering information about the OS and environment
                    (mostly from WMI), and for processing rules (Bootstrap.ini, 
                    CustomSettings.ini).  All the resulting information is saved
          into task sequence variables.
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-05-09

          Version - 0.0.0 - () - Finalized functional version 1.

          TODO:

.Example
#>

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true){
    $verbosePreference = "Continue"
}

Function Get-PSDLocalInfo{
  Process
  {
    # Look up OS details
    $tsenv:IsServerCoreOS = "False"
    $tsenv:IsServerOS = "False"

    Get-WmiObject Win32_OperatingSystem | % { $tsenv:OSCurrentVersion = $_.Version; $tsenv:OSCurrentBuild = $_.BuildNumber }
    if (Test-Path HKLM:System\CurrentControlSet\Control\MiniNT) {
      $tsenv:OSVersion = "WinPE"
    }
    else
    {
      $tsenv:OSVersion = "Other"
      if (Test-Path "$env:WINDIR\Explorer.exe") {
        $tsenv:IsServerCoreOS = "True"
      }
      if (Test-Path HKLM:\System\CurrentControlSet\Control\ProductOptions\ProductType)
      {
        $productType = Get-Item HKLM:System\CurrentControlSet\Control\ProductOptions\ProductType
        if ($productType -eq "ServerNT" -or $productType -eq "LanmanNT") {
          $tsenv:IsServerOS = "True"
        }
      }
    }

    # Look up network details
    $ipList = @()
    $macList = @()
    $gwList = @()
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 1" | % {
      $_.IPAddress | % {$ipList += $_ }
      $_.MacAddress | % {$macList += $_ }
      if ($_.DefaultGateway) {
        $_.DefaultGateway | % {$gwList += $_ }
      }
    }
    $tsenvlist:IPAddress = $ipList
    $tsenvlist:MacAddress = $macList
    $tsenvlist:DefaultGateway = $gwList

    # Look up asset information
    $tsenv:IsDesktop = "False"
    $tsenv:IsLaptop = "False"
    $tsenv:IsServer = "False"
    $tsenv:IsSFF = "False"
    $tsenv:IsTablet = "False"
    Get-WmiObject Win32_SystemEnclosure | % {
      $tsenv:AssetTag = $_.SMBIOSAssetTag.Trim()
      if ($_.ChassisTypes[0] -in "8", "9", "10", "11", "12", "14", "18", "21") { $tsenv:IsLaptop = "True" }
      if ($_.ChassisTypes[0] -in "3", "4", "5", "6", "7", "15", "16") { $tsenv:IsDesktop = "True" }
      if ($_.ChassisTypes[0] -in "23") { $tsenv:IsServer = "True" }
      if ($_.ChassisTypes[0] -in "34", "35", "36") { $tsenv:IsSFF = "True" }
      if ($_.ChassisTypes[0] -in "13", "31", "32", "30") { $tsenv:IsTablet = "True" } 
    }

    Get-WmiObject Win32_BIOS | % {
      $tsenv:SerialNumber = $_.SerialNumber.Trim()
    }

    if ($env:PROCESSOR_ARCHITEW6432) {
      if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
        $tsenv:Architecture = "x64"
      }
      else {
        $tsenv:Architecture = $env:PROCESSOR_ARCHITEW6432.ToUpper()
      }
    }
    else {
      if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
        $tsenv:Architecture = "x64"
      }
      else {
        $tsenv:Architecture = $env:PROCESSOR_ARCHITECTURE.ToUpper()
      }
    }

    Get-WmiObject Win32_Processor | % {
      $tsenv:ProcessorSpeed = $_.MaxClockSpeed
      $tsenv:SupportsSLAT = $_.SecondLevelAddressTranslationExtensions
    }

    # TODO: Capable architecture
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Capable architecture" 

    Get-WmiObject Win32_ComputerSystem | % {
      $tsenv:Make = $_.Manufacturer
      $tsenv:Model = $_.Model
      $tsenv:Memory = [int] ($_.TotalPhysicalMemory / 1024 / 1024)
    }

    Get-WmiObject Win32_ComputerSystemProduct | % {
      $tsenv:UUID = $_.UUID
    }
    
    Get-WmiObject Win32_BaseBoard | % {
      $tsenv:Product = $_.Product
    }

    # UEFI
    try
    {
        Get-SecureBootUEFI -Name SetupMode | Out-Null
        $tsenv:IsUEFI = "True"
    }
    catch
    {
        $tsenv:IsUEFI = "False"
    }

    # TEST: Battery
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TEST: Battery" 

 	$bFoundAC = $false
    $bOnBattery = $false
	$bFoundBattery = $false
    foreach($Battery in (Get-WmiObject -Class Win32_Battery))
    {
        $bFoundBattery = $true
        if ($Battery.BatteryStatus -eq "2")
        {
            $bFoundAC = $true
        }
    }
    If ($bFoundBattery -and !$bFoundAC)
    {
        $tsenv.IsOnBattery = $true
    }
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): bFoundAC: $bFoundAC" 
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): bOnBattery :$bOnBattery" 
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): bFoundBattery: $bFoundBattery"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv.IsOnBattery is now $($tsenv.IsOnBattery)"

    # TODO: GetDP
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: GetDP" 

    # TODO: GetWDS
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: GetWDS" 

    # TODO: GetHostName
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: GetHostName" 
    
    # TODO: GetOSSKU
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: GetOSSKU" 

    # TODO: GetCurrentOSInfo
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: GetCurrentOSInfo" 

    # TODO: Virtualization
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TEST: Virtualization" 
    
    $Win32_ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem
    switch ($Win32_ComputerSystem.model)
    {
        "Virtual Machine"
        {
            $tsenv:IsVM = "True"
        }
        "VMware Virtual Platform"
        {
            $tsenv:IsVM = "True"
        }
        "VMware7,1"
        {
            $tsenv:IsVM = "True"
        }
        "Virtual Box"
        {
            $tsenv:IsVM = "True"
        }
        Default
        {
            $tsenv:IsVM = "False"
        }
    }

    
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Model is $($Win32_ComputerSystem.model)" 
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:IsVM is now $tsenv:IsVM" 
    
    # TODO: BitLocker
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: BitLocker" 

  }
}
Function Invoke-PSDRules{
    [CmdletBinding()] 
    Param( 
        [ValidateNotNullOrEmpty()] 
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)] 
        [string]$FilePath,
        [ValidateNotNullOrEmpty()] 
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)] 
        [string]$MappingFile
    ) 
    Begin
    {
        $global:iniFile = Get-IniContent $FilePath
        [xml]$global:variableFile = Get-Content $MappingFile

        # Process custom properties
        if ($global:iniFile["Settings"]["Properties"])
        {
          $global:iniFile["Settings"]["Properties"].Split(",").Trim() | % {
            $newVar = $global:variableFile.properties.property[0].Clone()
            if ($_.EndsWith("(*)"))
            {
              $newVar.id = $_.Replace("(*)","")
              $newVar.type = "list"
            }
            else
            {
              $newVar.id = "$_"
              $newVar.type = "string"
            }
            $newVar.overwrite = "false"
            $newVar.description = "Custom property"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Adding custom property $($newVar.id)" 
            $null = $global:variableFile.properties.appendChild($newVar)
          }
        }
        $global:variables = $global:variableFile.properties.property
    }
    Process
    {
        $global:iniFile["Settings"]["Priority"].Split(",").Trim() | Invoke-PSDRule
    }
}
Function Invoke-PSDRule{
    [CmdletBinding()] 
    Param( 
        [ValidateNotNullOrEmpty()] 
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)] 
        [string]$RuleName
    ) 
    Begin
    {

    }
    Process
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing rule $RuleName" 

        $v = $global:variables | ? {$_.id -ieq $RuleName}
        if ($RuleName.ToUpper() -eq "DEFAULTGATEWAY") {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Process default gateway" 
        }
        elseif ($v) {
            if ($v.type -eq "list") {
              Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing values of $RuleName" 
              (Get-Item tsenvlist:$($v.id)).Value | Invoke-PSDRule
            }
            else
            {
              $s = (Get-Item tsenv:$($v.id)).Value
              if ($s -ne "")
              {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing value of $RuleName" 
                Invoke-PSDRule $s
              }
              else
              {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Skipping rule $RuleName, value is blank" 
              }
            }
        }
        else
        {
            Get-PSDSettings $global:iniFile[$RuleName]
        }
    }
}
Function Get-PSDSettings{
    [CmdletBinding()] 
    Param( 
        $section
    ) 
    Begin
    {

    }
    Process
    {
      $skipProperties = $false

      # Exit if the section doesn't exist
      if (-not $section)
      {
        return
      }

      # Process special sections and exits
      if ($section.Contains("UserExit"))
      {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Process UserExit Before" 
      }

      if ($section.Contains("SQLServer")) {
        $skipProperties = $true
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Database" 
      }

      if ($section.Contains("WebService")) {
        $skipProperties = $true
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: WebService" 
      }

      if ($section.Contains("Subsection")) {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing subsection" 
        Invoke-PSDRule $section["Subsection"]
      }

      # Process properties
      if (-not $skipProperties) {	
        $section.Keys | % {
          $sectionVar = $_
          $v = $global:variables | ? {$_.id -ieq $sectionVar}
          if ($v)
          {
		    if ((Get-Item tsenv:$v).Value -eq $section[$sectionVar])
			{
			  # Do nothing, value unchanged
			}
            if ((Get-Item tsenv:$v).Value -eq "" -or $v.overwrite -eq "true") {
              $Value = $((Get-Item tsenv:$($v.id)).Value)
              if($value -eq ''){$value = "EMPTY"}
              Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Changing PROPERTY $($v.id) to $($section[$sectionVar]), was $Value" 
              Set-Item tsenv:$($v.id) -Value $section[$sectionVar]
            }
            elseif ((Get-Item tsenv:$v).Value -ne "") {
              Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Ignoring new value for $($v.id)" 
            }
          }
          else
          {
            $trimVar = $sectionVar.TrimEnd("0","1","2","3","4","5","6","7","8","9")
            $v = $global:variables | ? {$_.id -ieq $trimVar}
            if ($v)
            {
              if ($v.type -eq "list") {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Adding $($section[$sectionVar]) to $($v.id)" 
                $n = @((Get-Item tsenvlist:$($v.id)).Value)
                $n += [String] $section[$sectionVar]
                Set-Item tsenvlist:$($v.id) -Value $n
              }
            }
          }
        } 
      }

      if ($section.Contains("UserExit")) {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TODO: Process UserExit After" 
      }

    }
}
Function Get-IniContent{ 
    <# 
    .Synopsis 
        Gets the content of an INI file 
         
    .Description 
        Gets the content of an INI file and returns it as a hashtable 
         
    .Notes 
        Author		: Oliver Lipkau <oliver@lipkau.net> 
        Blog		: http://oliver.lipkau.net/blog/ 
	Source		: https://github.com/lipkau/PsIni
			  http://gallery.technet.microsoft.com/scriptcenter/ea40c1ef-c856-434b-b8fb-ebd7a76e8d91
        Version		: 1.0 - 2010/03/12 - Initial release 
			  1.1 - 2014/12/11 - Typo (Thx SLDR)
                                         Typo (Thx Dave Stiff)
         
        #Requires -Version 2.0 
         
    .Inputs 
        System.String 
         
    .Outputs 
        System.Collections.Hashtable 
         
    .Parameter FilePath 
        Specifies the path to the input file. 
         
    .Example 
        $FileContent = Get-IniContent "C:\myinifile.ini" 
        ----------- 
        Description 
        Saves the content of the c:\myinifile.ini in a hashtable called $FileContent 
     
    .Example 
        $inifilepath | $FileContent = Get-IniContent 
        ----------- 
        Description 
        Gets the content of the ini file passed through the pipe into a hashtable called $FileContent 
     
    .Example 
        C:\PS>$FileContent = Get-IniContent "c:\settings.ini" 
        C:\PS>$FileContent["Section"]["Key"] 
        ----------- 
        Description 
        Returns the key "Key" of the section "Section" from the C:\settings.ini file 
         
    .Link 
        Out-IniFile 
    #> 
     
    [CmdletBinding()] 
    Param
    ( 
        [ValidateNotNullOrEmpty()] 
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".ini")})] 
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)] 
        [string]$FilePath 
    ) 
     
    Begin 
    {
        # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Function started"
    } 
         
    Process 
    { 
        # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing file: $Filepath"
             
        $ini = @{} 
        switch -regex -file $FilePath 
        { 
            "^\[(.+)\]$" # Section 
            { 
                $section = $matches[1] 
                $ini[$section] = @{} 
                $CommentCount = 0 
            } 
            "^(;.*)$" # Comment 
            { 
                if (!($section)) 
                { 
                    $section = "No-Section" 
                    $ini[$section] = @{} 
                } 
                $value = $matches[1] 
                $CommentCount = $CommentCount + 1 
                $name = "Comment" + $CommentCount 
                $ini[$section][$name] = $value 
            }  
            "(.+?)\s*=\s*(.*)" # Key 
            { 
                if (!($section)) 
                { 
                    $section = "No-Section" 
                    $ini[$section] = @{} 
                } 
                $name,$value = $matches[1..2] 
                $ini[$section][$name] = $value 
            } 
        } 
        # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Finished Processing file: $FilePath" 
        Return $ini 
    } 
         
    End 
    {
        # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Function ended" 
    } 
}
####

# [9] [PSDHelper.ps1]
#PSD Helper
Param(
    $MDTDeploySharePath,
    $UserName,
    $Password
)

#Connect
& net use $MDTDeploySharePath $Password /USER:$UserName

# Set the module path based on the current script path
$deployRoot = Split-Path -Path "$PSScriptRoot"
$env:PSModulePath = $env:PSModulePath + ";$deployRoot\Tools\Modules"


#Import Env
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global -Force -Verbose
Import-Module PSDUtility -Force -Verbose -Scope Global
Import-Module PSDDeploymentShare -Force -Verbose -Scope Global
Import-Module PSDGather -Force -Verbose -Scope Global

dir tsenv: | Out-File "$($env:SystemDrive)\PSDDumpVars.log"
Get-Content -Path "$($env:SystemDrive)\PSDDumpVars.log"

####

# [10] [PSDPartition.ps1]
# // ***************************************************************************
# // 
# // PowerShell Deployment for MDT
# //
# // File:      PSDPartition.ps1
# // 
# // Purpose:   Partition the disk
# // 
# // 
# // ***************************************************************************

param (

)

# Load core modules
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module PSDUtility

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}

Write-PSDEvent -MessageID 41000 -severity 1 -Message "Starting: $($MyInvocation.MyCommand.Name)"

# Keep the logging out of the way
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Keep the logging out of the way"
$currentLocalDataPath = Get-PSDLocalDataPath
if ($currentLocalDataPath -NotLike "X:\*")
{
    Stop-PSDLogging
    $logPath = "X:\MININT\Logs"
    if ((Test-Path $logPath) -eq $false) {
        New-Item -ItemType Directory -Force -Path $logPath | Out-Null
    }
    Start-Transcript "$logPath\PSDPartition.ps1.log"
}

# Partition and format the disk
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Partition and format the disk"
Show-PSDActionProgress -Message "Partition and format the disk" -Step "1" -MaxStep "1"
Update-Disk -Number 0
$disk = Get-Disk -Number 0

if ($tsenv:IsUEFI -eq "True"){
    
    # UEFI partitioning
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): UEFI partitioning"

    # Clean the disk if it isn't raw
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Clean the disk if it isn't raw"
    if ($disk.PartitionStyle -ne "RAW"){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Clearing disk"
        Show-PSDActionProgress -Message "Clearing disk" -Step "1" -MaxStep "1"
        Clear-Disk -Number 0 -RemoveData -RemoveOEM -Confirm:$false
    }

    # Initialize the disk
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Initialize the disk"
    Show-PSDActionProgress -Message "Initialize the disk" -Step "1" -MaxStep "1"
    Initialize-Disk -Number 0 -PartitionStyle GPT
    Get-Disk -Number 0

    # Calculate the OS partition size, as we want a recovery partiton after it
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Calculate the OS partition size, as we want a recovery partiton after it"
    Show-PSDActionProgress -Message "Calculate the OS partition size, as we want a recovery partiton after it" -Step "1" -MaxStep "1"
    $osSize = $disk.Size - 499MB - 128MB - 1024MB

    # Create the partitions
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Create the partitions"
    Show-PSDActionProgress -Message "Create the paritions" -Step "1" -MaxStep "1"
    $efi = New-Partition -DiskNumber 0 -Size 499MB -AssignDriveLetter
    $msr = New-Partition -DiskNumber 0 -Size 128MB -GptType '{e3c9e316-0b5c-4db8-817d-f92df00215ae}'
    $os = New-Partition -DiskNumber 0 -Size $osSize -AssignDriveLetter
    $recovery = New-Partition -DiskNumber 0 -UseMaximumSize -AssignDriveLetter -GptType '{de94bba4-06d1-4d40-a16a-bfd50179d6ac}'

    # Save the drive letters and volume GUIDs to task sequence variables
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Save the drive letters and volume GUIDs to task sequence variables"
    $tsenv:BootVolume = $efi.DriveLetter
    $tsenv:BootVolumeGuid = $efi.Guid
    $tsenv:OSVolume = $os.DriveLetter
    $tsenv:OSVolumeGuid = $os.Guid
    $tsenv:RecoveryVolume = $recovery.DriveLetter
    $tsenv:RecoveryVolumeGuid = $recovery.Guid

    # Format the volumes
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Format the volumes"
    Show-PSDActionProgress -Message "Format the volumes" -Step "1" -MaxStep "1"
    Format-Volume -DriveLetter $tsenv:BootVolume -FileSystem FAT32
    Format-Volume -DriveLetter $tsenv:OSVolume -FileSystem NTFS
    Format-Volume -DriveLetter $tsenv:RecoveryVolume -FileSystem NTFS
}
else{
    # Clean the disk if it isn't raw
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Clean the disk if it isn't raw"
    if ($disk.PartitionStyle -ne "RAW")
    {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Clearing disk"
        Show-PSDActionProgress -Message "Clearing disk" -Step "1" -MaxStep "1"
        Clear-Disk -Number 0 -RemoveData -RemoveOEM -Confirm:$false
    }

    # Initialize the disk
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Initialize the disk"
    Show-PSDActionProgress -Message "Initialize the disk" -Step "1" -MaxStep "1"
    Initialize-Disk -Number 0 -PartitionStyle MBR
    Get-Disk -Number 0

    # Calculate the OS partition size, as we want a recovery partiton after it
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Calculate the OS partition size, as we want a recovery partiton after it"
    Show-PSDActionProgress -Message "Calculate the OS partition size, as we want a recovery partiton after it" -Step "1" -MaxStep "1"
    $osSize = $disk.Size - 499MB - 1024MB

    # Create the partitions
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Create the partitions"
    Show-PSDActionProgress -Message "Create the paritions" -Step "1" -MaxStep "1"
    $boot = New-Partition -DiskNumber 0 -Size 499MB -AssignDriveLetter -IsActive
    $os = New-Partition -DiskNumber 0 -Size $osSize -AssignDriveLetter
    $recovery = New-Partition -DiskNumber 0 -UseMaximumSize -AssignDriveLetter

    # Save the drive letters and volume GUIDs to task sequence variables
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Save the drive letters and volume GUIDs to task sequence variables"

    # Modified for better output (admminy)
    $tsenv:BootVolume = $boot.DriveLetter
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:BootVolume is now $tsenv:BootVolume"
    
    # Modified for better output (admminy)
    $tsenv:OSVolume = $os.DriveLetter
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:OSVolume is now $tsenv:OSVolume"
    
    # Modified for better output (admminy)
    $tsenv:RecoveryVolume = $recovery.DriveLetter
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:RecoveryVolume $tsenv:RecoveryVolume"
    
    # Format the partitions (admminy)
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Format the partitions (admminy)"
    Show-PSDActionProgress -Message "Format the volumes" -Step "1" -MaxStep "1"
    Format-Volume -DriveLetter $tsenv:BootVolume -FileSystem NTFS -Verbose
    Format-Volume -DriveLetter $tsenv:OSVolume -FileSystem NTFS -Verbose
    Format-Volume -DriveLetter $tsenv:RecoveryVolume -FileSystem NTFS -Verbose

    #Fix for MBR
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Getting Guids from the volumes"

    $tsenv:OSVolumeGuid = (Get-Volume | Where-Object Driveletter -EQ $tsenv:OSVolume).UniqueId.replace("\\?\Volume","").replace("\","")
    $tsenv:RecoveryVolumeGuid = (Get-Volume | Where-Object Driveletter -EQ $tsenv:RecoveryVolume).UniqueId.replace("\\?\Volume","").replace("\","")
    $tsenv:BootVolumeGuid = (Get-Volume | Where-Object Driveletter -EQ $tsenv:BootVolume).UniqueId.replace("\\?\Volume","").replace("\","")

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:OSVolumeGuid is now $tsenv:OSVolumeGuid"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:RecoveryVolumeGuid is now $tsenv:RecoveryVolumeGuid"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:BootVolumeGuid is now $tsenv:BootVolumeGuid"
}

# Make sure there is a PSDrive for the OS volume
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Make sure there is a PSDrive for the OS volume"
if ((Test-Path "$($tsenv:OSVolume):\") -eq $false){
    New-PSDrive -Name $tsenv:OSVolume -PSProvider FileSystem -Root "$($tsenv:OSVolume):\" -Verbose
}

# If the old local data path survived the partitioning, copy it to the new location
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): If the old local data path survived the partitioning, copy it to the new location"
if (Test-Path $currentLocalDataPath){
    # Copy files to new data path
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy files to new data path"
    $newLocalDataPath = Get-PSDLocalDataPath -Move
    if ($currentLocalDataPath -ine $newLocalDataPath){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copying $currentLocalDataPath to $newLocalDataPath"
        Copy-PSDFolder $currentLocalDataPath $newLocalDataPath
        
        # Change log location for TSxLogPath, since we now have a volume
        # TODO: TSx should not be used, verify that the script works if the $TSxLogPath is changed to $LogPath
        $Global:TSxLogPath = "$newLocalDataPath\SMSOSD\OSDLOGS\PSDPartition.log"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Now logging to $Global:TSxLogPath"
    }
}

# Dumping out variables for troubleshooting
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Dumping out variables for troubleshooting"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:BootVolume  is $tsenv:BootVolume"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:OSVolume is $tsenv:OSVolume"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:RecoveryVolume is $tsenv:RecoveryVolume"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:IsUEFI is $tsenv:IsUEFI"

# Save all the current variables for later use
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Save all the current variables for later use"
Save-PSDVariables
####

# [11] [PSDPreComp.ps1]
$FrameworkDir=[Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
$NGENPath = Join-Path $FrameworkDir 'ngen.exe'

$Null = & "$NGENPath" install ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -Like *Microsoft.Management.Infrastructure*).Location /NoDependencies
$Null = & "$NGENPath" install ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -Like *MSCorlib*).Location /NoDependencies
$Null = & "$NGENPath" install ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -Like *System.Management.Automation*).Location /NoDependencies
####

# [12] [PSDPrestart.ps1]
# PSDPrestart.ps1

if(Test-Path -Path X:\Deploy\Prestart\PSDPrestart.xml){
    [xml]$XML = Get-Content -Path X:\Deploy\Prestart\PSDPrestart.xml
    foreach($item in ($XML.Commands.Command)){
        Start-Process -FilePath $item.Executable -ArgumentList $item.Argument -Wait -NoNewWindow -PassThru
    }
}

####

# [13] [PSDSetVariable.ps1]
# // ***************************************************************************
# // 
# // PowerShell Deployment for MDT
# //
# // File:      PSDSetVariables.ps1
# // 
# // Purpose:   Set variable
# // 
# // 
# // ***************************************************************************

param (

)

# Load core modules
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module PSDUtility

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}

Write-PSDEvent -MessageID 41000 -severity 1 -Message "Starting: $($MyInvocation.MyCommand.Name)"

$VariableName = $TSEnv:VariableName
$VariableValue = $TSEnv:VariableValue
New-Item -Path TSEnv: -Name "$VariableName" -Value "$VariableValue" -Force

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $VariableName is now $((Get-ChildItem -Path TSEnv: | Where-Object Name -Like $VariableName).value)"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Save all the current variables for later use"
Save-PSDVariables | Out-Null
####

# [14] [PSDStart.ps1]
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
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-06-02

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

param (
    [switch] $start,
    [switch] $Debug
)

function Write-PSDBootInfo{
    Param(
        $Message,
        $SleepSec = "NA"
    )

    # Check for BGInfo
    if(!(Test-Path -Path "$env:SystemRoot\system32\bginfo.exe")){
        Return
    }

    # Check for BGinfo file
    if(!(Test-Path -Path "$env:SystemRoot\system32\psd.bgi")){
        Return
    }

    # Update background
    $Result = New-Item -Path HKLM:\SOFTWARE\PSD -ItemType Directory -Force
    $Result = New-ItemProperty -Path HKLM:\SOFTWARE\PSD -Name PSDBootInfo -PropertyType MultiString -Value $Message -Force
    & bginfo.exe "$env:SystemRoot\system32\psd.bgi" /timer:0 /NOLICPROMPT /SILENT
    
    if($SleepSec -ne "NA"){
        Start-Sleep -Seconds $SleepSec
    }
}

# Set the module path based on the current script path
$deployRoot = Split-Path -Path "$PSScriptRoot"
$env:PSModulePath = $env:PSModulePath + ";$deployRoot\Tools\Modules"

# Check for debug settings

$Global:PSDDebug = $false
if(Test-Path -Path "C:\MININT\PSDDebug.txt"){
    $DeBug = $true
    $Global:PSDDebug = $True
}

if($Global:PSDDebug -eq $false){
    if($DeBug -eq $true){
        $Result = Read-Host -Prompt "Press y and Enter to continue in debug mode, any other key to exit from debug..."
        if($Result -eq "y"){
            $DeBug = $True
        }else{
            $DeBug = $False
        }
    }
}

if($DeBug -eq $true){
    $Global:PSDDebug = $True
    $verbosePreference = "Continue"
}

if($PSDDeBug -eq $true){
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

if($PSDDeBug -eq $true){
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Imported Module: PSDUtility,Storage "
}

# Check if we booted from WinPE
$Global:BootfromWinPE = $false
if ($env:SYSTEMDRIVE -eq "X:"){
    $Global:BootfromWinPE = $true
}
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): BootfromWinPE is now $BootfromWinPE"

# Write Debug status to logfile
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): PSDDeBug is now $PSDDeBug"

# Install PSDRoot certificate if exist in WinPE
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Looking for certificates..."

$Certificates = @()

$CertificateLocations = "$($env:SYSTEMDRIVE)\Deploy\Certificates","$($env:SYSTEMDRIVE)\MININT\Certificates"
foreach($CertificateLocation in $CertificateLocations){
    if((Test-Path -Path $CertificateLocation) -eq $true){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Looking for certificates in $CertificateLocation"
        $Certificates += Get-ChildItem -Path "$CertificateLocation" -Filter *.cer
    }
}

foreach($Certificate in $Certificates){
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Found $($Certificate.FullName), trying to add as root certificate"
    # Write-PSDBootInfo -SleepSec 1 -Message "Installing PSDRoot certificate"
    $Return = Import-PSDCertificate -Path $Certificate.FullName -CertStoreScope "LocalMachine" -CertStoreName "Root"
    If($Return -eq "0"){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Succesfully imported $($Certificate.FullName)"
    }
    else{
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Failed to import $($Certificate.FullName)"
    }
}

# Set Command Window size
# Reason for 99 is that 99 seems to use the screen in the best possible way, 100 is just one pixel to much
if($Global:PSDDebug -ne $True){
    Set-PSDCommandWindowsSize -Width 99 -Height 15
}

if($BootfromWinPE -eq $true){
    # Windows ADK v1809 could be missing certain files, we need to check for that.
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check if we are running Windows ADK 10 v1809"
    if($(Get-WmiObject Win32_OperatingSystem).BuildNumber -eq "17763"){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check for BCP47Langs.dll and BCP47mrm.dll, needed for WPF"
        if(-not(Test-Path -Path X:\Windows\System32\BCP47Langs.dll) -or -not(Test-Path -Path X:\Windows\System32\BCP47mrm.dll)){
            Start-Process PowerShell -ArgumentList {
                "Write-warning -Message 'We are missing the BCP47Langs.dll and BCP47mrm.dll files required for WinPE 1809.';Write-warning -Message 'Please check the PSD documentation on how to add those files.';Write-warning -Message 'Critical error, deployment can not continue..';Pause"
            } -Wait
            exit 1
        }
    }

    # We need more than 1.5 GB (Testing for at least 1499MB of RAM)
    Write-PSDBootInfo -SleepSec 2 -Message "Checking that we have at least 1.5 GB of RAM"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check for minimum amount of memory in WinPE to run PSD"
    if ((Get-WmiObject -Class Win32_computersystem).TotalPhysicalMemory -le 1499MB){
        Show-PSDInfo -Message "Not enough memory to run PSD, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        exit 1
    }

    # All tests succeded, log that info
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Completed WinPE prerequisite checks"
}

# Load more modules
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load more modules"
Import-Module PSDDeploymentShare -ErrorAction Stop -Force -Verbose:$False
Import-Module PSDGather -ErrorAction Stop -Force -Verbose:$False
Import-Module PSDWizard -ErrorAction Stop -Force -Verbose:$False

#Set-PSDDebugPause -Prompt 182

#Check if tsenv: works
try{
    Get-ChildItem -Path "TSEnv:"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Able to read from TSEnv"
}
catch{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to read from TSEnv"
    #Break
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"

# If running from RunOnce, create a startup folder item and then exit
if ($start){
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating a link to re-run $PSCommandPath from the all users Startup folder"

    # Create a shortcut to run this script
    $allUsersStartup = [Environment]::GetFolderPath('CommonStartup')
    $linkPath = "$allUsersStartup\PSDStartup.lnk"
    $wshShell = New-Object -comObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($linkPath)
    $shortcut.TargetPath = "powershell.exe"
    
    if($PSDDebug -eq $True){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Command set to:PowerShell.exe -Noprofile -Executionpolicy Bypass -File $PSCommandPath -Debug"
        $shortcut.Arguments = "-Noprofile -Executionpolicy Bypass -File $PSCommandPath -Debug"
    }
    else{
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Command set to:PowerShell.exe -Noprofile -Executionpolicy Bypass -Windowstyle Hidden -File $PSCommandPath"
        $shortcut.Arguments = "-Noprofile -Executionpolicy Bypass -Windowstyle Hidden -File $PSCommandPath"
    }
    $shortcut.Save()
    exit 0
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
$tsInProgress = $false
Get-Volume | ? {-not [String]::IsNullOrWhiteSpace($_.DriveLetter) } | ? {$_.DriveType -eq 'Fixed'} | ? {$_.DriveLetter -ne 'X'} | ? {Test-Path "$($_.DriveLetter):\_SMSTaskSequence\TSEnv.dat"} | % {

    # Found it, save the location
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): In-progress task sequence found at $($_.DriveLetter):\_SMSTaskSequence"
    $tsInProgress = $true
    $tsDrive = $_.DriveLetter

    #Set-PSDDebugPause -Prompt 240

    # Restore the task sequence variables
    $variablesPath = Restore-PSDVariables
    try{
        foreach($i in (Get-ChildItem -Path TSEnv:)){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Property $($i.Name) is $($i.Value)"
        }
    }
    catch{
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to restore variables from $variablesPath."
        Show-PSDInfo -Message "Unable to restore variables from $variablesPath." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Exit 1
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Restored variables from $variablesPath."

    # Reconnect to the deployment share
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Reconnecting to the deployment share at $($tsenv:DeployRoot)."
    if ($tsenv:UserDomain -ne ""){
        Get-PSDConnection -deployRoot $tsenv:DeployRoot -username "$($tsenv:UserDomain)\$($tsenv:UserID)" -password $tsenv:UserPassword
    }
    else{
        Get-PSDConnection -deployRoot $tsenv:DeployRoot -username $tsenv:UserID -password $tsenv:UserPassword
    }
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): If a task sequence is in progress, resume it. Otherwise, start a new one"

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"

# If a task sequence is in progress, resume it.  Otherwise, start a new one
[Environment]::CurrentDirectory = "$($env:WINDIR)\System32"
if ($tsInProgress){
    # Find the task sequence engine
    if (Test-Path -Path "X:\Deploy\Tools\$($tsenv:Architecture)\tsmbootstrap.exe"){
        $tsEngine = "X:\Deploy\Tools\$($tsenv:Architecture)"
    }
    else{
        $tsEngine = Get-PSDContent "Tools\$($tsenv:Architecture)"
    }
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Task sequence engine located at $tsEngine."

    # Get full scripts location
    $scripts = Get-PSDContent -Content "Scripts"
    $env:ScriptRoot = $scripts

    # Set the PSModulePath
    $modules = Get-PSDContent -Content "Tools\Modules"
    $env:PSModulePath = $env:PSModulePath + ";$modules"

    # Resume task sequence
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"
    Stop-PSDLogging
    Write-PSDBootInfo -SleepSec 1 -Message "Resuming existing task sequence"
    $result = Start-Process -FilePath "$tsEngine\TSMBootstrap.exe" -ArgumentList "/env:SAContinue" -Wait -Passthru
}
else{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No task sequence is in progress."

    # Process bootstrap
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing Bootstrap.ini"
    if ($env:SYSTEMDRIVE -eq "X:"){
        $mappingFile = "X:\Deploy\Tools\Modules\PSDGather\ZTIGather.xml"
        Invoke-PSDRules -FilePath "X:\Deploy\Scripts\Bootstrap.ini" -MappingFile $mappingFile
    }
    else{
        $mappingFile = "$deployRoot\Scripts\ZTIGather.xml"
        Invoke-PSDRules -FilePath "$deployRoot\Control\Bootstrap.ini" -MappingFile $mappingFile
    }

    # Determine the Deployroot
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Determine the Deployroot"

    # Check if we are deploying from media
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Check if we are deploying from media"

    Get-Volume | ? {-not [String]::IsNullOrWhiteSpace($_.DriveLetter) } | ? {$_.DriveType -eq 'Fixed'} | ? {$_.DriveLetter -ne 'X'} | ? {Test-Path "$($_.DriveLetter):Deploy\Scripts\Media.tag"} | % {
        # Found it, save the location
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Found Media Tag $($_.DriveLetter):Deploy\Scripts\Media.tag"
        $tsDrive = $_.DriveLetter
	    $tsenv:DeployRoot = $tsDrive + ":\Deploy"
	    $tsenv:ResourceRoot = $tsDrive + ":\Deploy"
	    $tsenv:DeploymentMethod = "MEDIA"

        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): DeploymentMethod is $tsenv:DeploymentMethod, this solution does not currently support deploying from media, sorry, aborting"
        Show-PSDInfo -Message "No deployroot set, this solution does not currently support deploying from media, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Break
    }

    #Set-PSDDebugPause -Prompt 337


    switch ($tsenv:DeploymentMethod){
        'MEDIA'{
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): DeploymentMethod is $tsenv:DeploymentMethod, this solution does not currently support deploying from media, sorry, aborting"
            Show-PSDInfo -Message "No deployroot set, this solution does not currently support deploying from media, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
            Start-Process PowerShell -Wait
            Break
        }
        Default{
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): We are deploying from Network, checking IP's,"
            
            # Check Network
            Write-PSDBootInfo -SleepSec 1 -Message "Checking for a valid network configuration"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Invoking DHCP refresh..."    
            $Null = Invoke-PSDexe -Executable ipconfig.exe -Arguments "/renew"

            $NICIPOK = $False

            $ipList = @()
            $ipListv4 = @()
            $macList = @()
            $gwList = @()
            Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 1" | % {
                $_.IPAddress | % {$ipList += $_ }
                $_.MacAddress | % {$macList += $_ }
                if ($_.DefaultIPGateway) {
                $_.DefaultIPGateway | % {$gwList += $_ }
                }
            }
            $ipListv4 = $ipList | Where-Object Length -EQ 15
            
            foreach($IPv4 in $ipListv4){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Found IP address $IPv4"
            }

            if (((Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 1").Index).count -ge 1){
                $NICIPOK = $True
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): We have at least one network adapter with a IP address, we should be able to continue"
            }
            

            if($NICIPOK -ne $True){
                $Message = "Sorry, it seems that you don't have a valid IP, aborting..."
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message"
                Show-PSDInfo -Message "$Message" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
                Start-Process PowerShell -Wait
                break
            }

            # Log if we are running APIPA as warning
            # Log IP, Networkadapter name, if exist GW and DNS
            # Return Network as deployment method, with Yes we have network
        }
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Looking for PSDeployRoots in the usual places..."

    #Set-PSDDebugPause -Prompt 398

    if($tsenv:PSDDeployRoots -ne ""){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): PSDeployRoots definition found!"
        $items = $tsenv:PSDDeployRoots.Split(",")
        foreach($item in $items){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Testing PSDDeployRoots value: $item"
            if ($item -ilike "https://*"){
                $ServerName = $item.Replace("https://","") | Split-Path
                $Result = Test-PSDNetCon -Hostname $ServerName -Protocol HTTPS
                if(($Result) -ne $true){
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access PSDDeployRoots value $item using HTTP"
                }
                else{
                    $tsenv:DeployRoot = $item
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $tsenv:DeployRoot"
                    Break
                }
            }
            if ($item -ilike "http://*"){
                $ServerName = $item.Replace("http://","") | Split-Path
                $Result = Test-PSDNetCon -Hostname $ServerName -Protocol HTTP
                if(($Result) -ne $true){
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access PSDDeployRoots value $item using HTTPS"
                }
                else{
                    $tsenv:DeployRoot = $item
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $tsenv:DeployRoot"
                    Break
                }
            }
            if ($item -like "\\*"){
                $ServerName = $item.Split("\\")[2]
                $Result = Test-PSDNetCon -Hostname $ServerName -Protocol SMB
                if(($Result) -ne $true){
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $item using SMB"
                }
                else{
                    $tsenv:DeployRoot = $item
                    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $tsenv:DeployRoot"
                    Break
                }
            }
        }
    }
    else{
        $deployRoot = $tsenv:DeployRoot
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Validating network access to $tsenv:DeployRoot"
    Write-PSDBootInfo -SleepSec 2 -Message "Validating network access to $tsenv:DeployRoot"

    #Set-PSDDebugPause -Prompt 451

    if(!($tsenv:DeployRoot -notlike $null -or "")){
        $Message = "Since we are deploying from network, we should be able to access the deploymentshare, but we can't, please check your network."
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message"
        Show-PSDInfo -Message "$Message" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Break
    } 
    
    if($NICIPOK -eq $False){
        if ($deployRoot -notlike $null -or ""){
            $Message = "Since we are deploying from network, we should have network access but we don't, check networking"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message"
            Show-PSDInfo -Message "$Message" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
            Start-Process PowerShell -Wait
            Break
        }
    }

    # Validate network route to $deployRoot
    if ($deployRoot -notlike $null -or ""){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): New deploy root is $deployRoot."
        if ($deployRoot -ilike "https://*"){
            $ServerName = $deployRoot.Replace("https://","") | Split-Path
            $Result = Test-PSDNetCon -Hostname $ServerName -Protocol HTTPS
            if(($Result) -ne $true){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $ServerName"
                Show-PSDInfo -Message "Unable to access $ServerName, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
                Start-Process PowerShell -Wait
                Break
            }
        }

        if ($deployRoot -ilike "http://*"){
            $ServerName = $deployRoot.Replace("http://","") | Split-Path
            $Result = Test-PSDNetCon -Hostname $ServerName -Protocol HTTP
            if(($Result) -ne $true){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $ServerName"
                Show-PSDInfo -Message "Unable to access $ServerName, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
                Start-Process PowerShell -Wait
                Break
            }
        }

        if ($deployRoot -like "\\*"){
            $ServerName = $deployRoot.Split("\\")[2]
            $Result = Test-PSDNetCon -Hostname $ServerName -Protocol SMB -ErrorAction SilentlyContinue
            if(($Result) -ne $true){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $ServerName"
                Show-PSDInfo -Message "Unable to access $ServerName, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
                Start-Process PowerShell -Wait
                Break
            }
        }
    }
    else{
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
    If($tsenv:DeploymentMethod -ne "MEDIA"){
        if ($deployRoot -like "\\*"){
            net time \\$ServerName /set /y
        }
        if ($deployRoot -ilike "https://*"){
            $NTPTime = Get-PSDNtpTime
            if($NTPTime -ne $null){
                Set-Date -Date $NTPTime.NtpTime
            }
            else{
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Failed to set time/date" -LogLevel 2
            }
            
        }
        if ($deployRoot -ilike "http://*"){
            $NTPTime = Get-PSDNtpTime -Server Gunk.gunk.gunk
            if($NTPTime -ne $null){
                Set-Date -Date $NTPTime.NtpTime
            }
            else{
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Failed to set time/date" -LogLevel 2
            }
        }
    }

    $Time = Get-Date
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): New time on computer is: $Time"

    # Process CustomSettings.ini
    $control = Get-PSDContent -Content "Control"

    #verify access to "$control\CustomSettings.ini" 
    if((Test-path -Path "$control\CustomSettings.ini") -ne $true){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $control\CustomSettings.ini"
        Show-PSDInfo -Message "Unable to access $control\CustomSettings.ini, aborting..." -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Start-Process PowerShell -Wait
        Break    
    }
    
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing CustomSettings.ini"
    Invoke-PSDRules -FilePath "$control\CustomSettings.ini" -MappingFile $mappingFile

    if($tsenv:EventService -notlike $null -or ""){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Eventlogging is enabled"
    }
    else{
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Eventlogging is not enabled"
    }

    # Get full scripts location
    $scripts = Get-PSDContent -Content "Scripts"
    $env:ScriptRoot = $scripts

    # Set the PSModulePath
    $modules = Get-PSDContent -Content "Tools\Modules"
    $env:PSModulePath = $env:PSModulePath + ";$modules"

    #Set-PSDDebugPause -Prompt "Process wizard"

    # Process wizard
    Write-PSDBootInfo -SleepSec 1 -Message "Loading the PSD Deployment Wizard"
    # $tsenv:TaskSequenceID = ""
    if ($tsenv:SkipWizard -ine "YES"){
        $result = Show-PSDWizard "$scripts\PSDWizard.xaml"
        if ($result.DialogResult -eq $false){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Cancelling, aborting..."
            Show-PSDInfo -Message "Cancelling, aborting..." -Severity Information -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
            Stop-PSDLogging
            Clear-PSDInformation
            Start-Process PowerShell -Wait
            Exit 0
        }
    }

    If ($tsenv:TaskSequenceID -eq ""){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): No TaskSequence selected, aborting..."
        Show-PSDInfo -Message "No TaskSequence selected, aborting..." -Severity Information -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        Stop-PSDLogging
        Clear-PSDInformation
        Start-Process PowerShell -Wait
        Exit 0
    }

    if ($tsenv:OSDComputerName -eq "") {
        $tsenv:OSDComputerName = $env:COMPUTERNAME
    }

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): --------------------"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Find the task sequence engine"

    # Find the task sequence engine
    if (Test-Path -Path "X:\Deploy\Tools\$($tsenv:Architecture)\tsmbootstrap.exe"){
        $tsEngine = "X:\Deploy\Tools\$($tsenv:Architecture)"
    }
    else{
        $tsEngine = Get-PSDContent "Tools\$($tsenv:Architecture)"
    }
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Task sequence engine located at $tsEngine."

    # Transfer $PSDDeBug to TSEnv: for TS to understand
    If($PSDDeBug -eq $true){
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
    if((Test-Path -Path "$tsEngine\TSMBootstrap.exe") -ne $true){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to access $tsEngine\TSMBootstrap.exe" -Loglevel 3
        Show-PSDInfo -Message "Unable to access $tsEngine\TSMBootstrap.exe" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
    }
    $result = Start-Process -FilePath "$tsEngine\TSMBootstrap.exe" -ArgumentList "/env:SAStart" -Wait -Passthru
}

# If we are in WinPE and we have deployed an operating system, we should write logfiles to the new drive
if($BootfromWinPE -eq $True){
    # Assuming that the first Volume having mspaint.exe is the correct OS volume
    $Drives = Get-PSDrive | Where-Object {$_.Provider -like "*filesystem*"}
    Foreach ($Drive in $Drives){
        # TODO: Need to find a better file for detection of running OS
        If (Test-Path -Path "$($Drive.Name):\Windows\System32\mspaint.exe"){
            Start-PSDLogging -Logpath "$($Drive.Name):\MININT\SMSOSD\OSDLOGS"

            Break
        }
    }
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): logPath is now $logPath"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Task Sequence is done, PSDStart.ps1 is now in charge.."

# Make sure variables.dat is in the current local directory
if (Test-Path -Path "$(Get-PSDLocalDataPath)\Variables.dat"){
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Variables.dat found in the correct location, $(Get-PSDLocalDataPath)\Variables.dat, no need to copy."
}
else{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copying Variables.dat to the current location, $(Get-PSDLocalDataPath)\Variables.dat."
    Copy-Item $variablesPath "$(Get-PSDLocalDataPath)\"
}

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $deployRoot"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"

# Process the exit code from the task sequence
# Start-PSDLogging
#if($result.ExitCode -eq $null){$result.ExitCode = 0}
#Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Return code from TSMBootstrap.exe is $($result.ExitCode)"

Switch ($result.ExitCode){
    0 {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): SUCCESS!"
        Write-PSDEvent -MessageID 41015 -severity 4 -Message "PSD deployment completed successfully."
        
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Reset HKLM:\Software\Microsoft\Deployment 4"
        Get-ItemProperty "HKLM:\Software\Microsoft\Deployment 4" | Remove-Item -Force -Recurse

        $Executable = "regsvr32.exe"
        $Arguments = "/u /s $tools\tscore.dll"
        if((Test-Path -Path "$tools\tscore.dll") -eq $true){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
            $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
        }

        $Executable = "$Tools\TSProgressUI.exe"
        $Arguments = "/Unregister"
        if((Test-Path -Path "$Tools\TSProgressUI.exe") -eq $true){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
            $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
        }

        # TODO Reboot for finishaction
        # Read-Host -Prompt "Check for FinishAction and cleanup leftovers"
        Write-Verbose "tsenv:FinishAction is $tsenv:FinishAction"
        
        if($tsenv:FinishAction -eq "Reboot" -or $tsenv:FinishAction -eq "Restart"){
            $Global:RebootAfterTS = $True
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Will reboot for finishaction"
        }

        # Set-PSDDebugPause -Prompt "Before PSDFinal.ps1"
       
        Stop-PSDLogging

        Copy-Item -Path $env:SystemDrive\MININT\Cache\Scripts\PSDFinal.ps1 -Destination $env:TEMP
        Clear-PSDInformation
                
        #Checking for FinalSummary
        if(!($tsenv:SkipFinalSummary -eq "YES")){
            Show-PSDInfo -Message "OSD SUCCESS!" -Severity Information -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot
        }

        if($tsenv:PSDPause -eq "YES"){
            Read-Host -Prompt "Exit 0"
        }

        # Read-Host -Prompt "Check for finish action and cleanup leftovers"
        # Check for finish action and cleanup leftovers
        
        if($RebootAfterTS -eq $True){
            Start-Process powershell -ArgumentList "$env:TEMP\PSDFinal.ps1 -Restart $true -ParentPID $PID" -WindowStyle Hidden -Wait
        }
        else{
            Start-Process powershell -ArgumentList "$env:TEMP\PSDFinal.ps1 -Restart $false -ParentPID $PID" -WindowStyle Hidden -Wait
        }

        # Done
        Exit 0
        
    }
    -2147021886 {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): REBOOT!"
        $variablesPath = Restore-PSDVariables

        try{
            foreach($i in (Get-ChildItem -Path TSEnv:)){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Property $($i.Name) is $($i.Value)"
            }
        }
        catch{
        }


        if ($env:SYSTEMDRIVE -eq "X:"){
            # We are running in WinPE and need to reboot, if we have a hard disk, then we need files to continute the TS after reboot, copy files...
            # Exit with a zero return code and let Windows PE reboot

            # Assuming that the first Volume having mspaint.exe is the correct OS volume
            $Drives = Get-PSDrive | Where-Object {$_.Provider -like "*filesystem*"}
            Foreach ($Drive in $Drives){
                # TODO: Need to find a better file for detection of running OS
                If (Test-Path -Path "$($Drive.Name):\Windows\System32\mspaint.exe"){
                    #Copy files needed for full OS

                    Write-PSDLog -Message "Copy-Item $scripts\PSDStart.ps1 $($Drive.Name):\MININT\Scripts"
                    Initialize-PSDFolder "$($Drive.Name):\MININT\Scripts"
                    Copy-Item "$scripts\PSDStart.ps1" "$($Drive.Name):\MININT\Scripts"

                    try{
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
                    catch{
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

                    if($PSDDeBug -eq $true){
                        New-Item -Path "$($Drive.Name):\MININT\PSDDebug.txt" -ItemType File -Force
                    }

                    #Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): We are now on line 775 and we are doing a break on line 776..."
                    #Break
                }
            }

            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exit with a zero return code and let Windows PE reboot"
            Stop-PSDLogging

            if($tsenv:PSDPause -eq "YES"){
                Read-Host -Prompt "Exit -2147021886 (WinPE)"
            }

            exit 0
        }
        else{
            # In full OS, need to initiate a reboot
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): In full OS, need to initiate a reboot"

            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Saving Variables"
            $variablesPath = Save-PSDVariables

            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Finding out where the tools folder is..."
            $Tools = Get-PSDContent -Content "Tools\$($tsenv:Architecture)"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Tools is now $Tools"
            
            $Executable = "regsvr32.exe"
            $Arguments = "/u /s $tools\tscore.dll"
            if((Test-Path -Path "$tools\tscore.dll") -eq $true){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
                $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
            }
            if($return -ne 0){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to unload $tools\tscore.dll" -Loglevel 2
            }

            $Executable = "$Tools\TSProgressUI.exe"
            $Arguments = "/Unregister"
            if((Test-Path -Path "$Tools\TSProgressUI.exe") -eq $true){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
                $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
            }
            if($return -ne 0){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Unable to unload $Tools\TSProgressUI.exe" -Loglevel 2
            }

            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Restart, see you on the other side... (Shutdown.exe /r /t 30 /f)"
            
            if($tsenv:PSDPause -eq "YES"){
                Read-Host -Prompt "Exit -2147021886 (Windows)"
            }
            
            #Restart-Computer -Force
            Shutdown.exe /r /t 30 /f

            Stop-PSDLogging
            exit 0
        }
    }
    default {
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
        $Arguments = "/u /s $tools\tscore.dll"
        if((Test-Path -Path "$tools\tscore.dll") -eq $true){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
            $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
        }

        $Executable = "$Tools\TSProgressUI.exe"
        $Arguments = "/Unregister"
        if((Test-Path -Path "$Tools\TSProgressUI.exe") -eq $true){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): About to run: $Executable $Arguments"
            $return = Invoke-PSDEXE -Executable $Executable -Arguments $Arguments
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Exitcode: $return"
        }

        Clear-PSDInformation
        Stop-PSDLogging

        #Invoke-PSDInfoGather
        Write-PSDEvent -MessageID 41014 -severity 1 -Message "PSD deployment failed, Return Code is $($result.ExitCode)"
        Show-PSDInfo -Message "Task sequence failed, Return Code is $($result.ExitCode)" -Severity Error -OSDComputername $OSDComputername -Deployroot $global:psddsDeployRoot

        exit $result.ExitCode
    }
}
####

# [15] [PSDTBA.ps1]
# // ***************************************************************************
# // 
# // PowerShell Deployment for MDT
# //
# // File:      PSDTemplate.ps1
# // 
# // Purpose:   Apply the specified operating system.
# // 
# // 
# // ***************************************************************************

param (

)

# Load core modules
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module PSDUtility
Import-Module PSDDeploymentShare

$verbosePreference = "Continue"

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load core modules"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Deployroot is now $($tsenv:DeployRoot)"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): env:PSModulePath is now $env:PSModulePath"

#Notify
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): The built in VB Script has been replaced by the script, however, the function the VB Script would have done is not yet implemented, sorry, working on this"
####

# [16] [PSDUpdateExit.ps1]
<#
.Synopsis
    This script runs when a deployment share is updated, and the completely generate boot image option is selected.
    
.Description
    This script was written by Johan Arwidmark @jarwidmark. This script is for adding features and tools to the boot image WIM and/or ISO.

.LINK
    https://github.com/FriendsOfMDT/PSD

.NOTES
          FileName: New-UpdateExit.ps1
          Solution: PowerShell Deployment for MDT
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark
          Primary: @jarwidmark 
          Created: 2019-05-09
          Modified: 2020-07-03

          Version - 0.0.0 - () - Finalized functional version 1.

.EXAMPLE
	.\PSD-UpdateExit.ps1
#>

#Requires -RunAsAdministrator

[CmdletBinding()]
Param(
)

function Start-PSDLog{
	[CmdletBinding()]
    param (
    #[ValidateScript({ Split-Path $_ -Parent | Test-Path })]
	[string]$FilePath
 	)
    try
    	{
			if(!(Split-Path $FilePath -Parent | Test-Path))
			{
				New-Item (Split-Path $FilePath -Parent) -Type Directory | Out-Null
			}
			#Confirm the provided destination for logging exists if it doesn't then create it.
			if (!(Test-Path $FilePath)){
	    			## Create the log file destination if it doesn't exist.
                    New-Item $FilePath -Type File | Out-Null
			}
				## Set the global variable to be used as the FilePath for all subsequent write-PSDInstallLog
				## calls in this session
				$global:ScriptLogFilePath = $FilePath
    	}
    catch
    {
		#In event of an error write an exception
        Write-Error $_.Exception.Message
    }
}
function Write-PSDInstallLog{
	param (
    [Parameter(Mandatory = $true)]
    [string]$Message,
    [Parameter()]
    [ValidateSet(1, 2, 3)]
	[string]$LogLevel=1,
	[Parameter(Mandatory = $false)]
    [bool]$writetoscreen = $true   
   )
    $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
    $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", $LogLevel
	$Line = $Line -f $LineFormat
	[system.GC]::Collect()
    Add-Content -Value $Line -Path $global:ScriptLogFilePath
	if($writetoscreen)
	{
        switch ($LogLevel)
        {
            '1'{
                Write-Verbose -Message $Message
                }
            '2'{
                Write-Warning -Message $Message
                }
            '3'{
                Write-Error -Message $Message
                }
            Default {
            }
        }
    }
	if($writetolistbox -eq $true)
	{
        $result1.Items.Add("$Message")
    }
}
function set-PSDDefaultLogPath{
	#Function to set the default log path if something is put in the field then it is sent somewhere else. 
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $false)]
		[bool]$defaultLogLocation = $true,
		[parameter(Mandatory = $false)]
		[string]$LogLocation
	)
	if($defaultLogLocation)
	{
		$LogPath = Split-Path $script:MyInvocation.MyCommand.Path
		$LogFile = "$($($script:MyInvocation.MyCommand.Name).Substring(0,$($script:MyInvocation.MyCommand.Name).Length-4)).log"		
		Start-PSDLog -FilePath $($LogPath + "\" + $LogFile)
	}
	else 
	{
		$LogPath = $LogLocation
		$LogFile = "$($($script:MyInvocation.MyCommand.Name).Substring(0,$($script:MyInvocation.MyCommand.Name).Length-4)).log"		
		Start-PSDLog -FilePath $($LogPath + "\" + $LogFile)
	}
}

# Start logging
set-PSDDefaultLogPath -defaultLogLocation $false -LogLocation "$Env:DEPLOYROOT"

# List some variables
Write-PSDInstallLog -Message "Write out each of the passed-in environment variable values"
Write-PSDInstallLog -Message "INSTALLDIR = $Env:INSTALLDIR"
Write-PSDInstallLog -Message "DEPLOYROOT = $Env:DEPLOYROOT"
Write-PSDInstallLog -Message "PLATFORM = $Env:PLATFORM"
Write-PSDInstallLog -Message "ARCHITECTURE = $Env:ARCHITECTURE"
Write-PSDInstallLog -Message "TEMPLATE = $Env:TEMPLATE"

# Do any desired WIM customizations (right before the WIM changes are committed)
If ($Env:STAGE -eq "WIM") {
    # CONTENT environment variable contains the path to the mounted WIM
    Write-PSDInstallLog -Message "Entering the $Env:STAGE phase"
    Write-PSDInstallLog -Message "CONTENT = $Env:CONTENT"
}

# Do any desired customizations (right after the WIM changes are committed)
If ($Env:STAGE -eq "POSTWIM") {
    Write-PSDInstallLog -Message "Entering the $Env:STAGE phase"
    Write-PSDInstallLog -Message "CONTENT = $Env:CONTENT"

    # Added for the OSD Toolkit Plugin
    Write-PSDInstallLog -Message "Adding the OSD Toolkit by running Set-PSDBootImage2PintEnabled.ps1 from the PSDResources\Plugins\OSDToolKit folder"
    $PSDArgument = "$Env:DEPLOYROOT\PSDResources\Plugins\OSDToolKit\Set-PSDBootImage2PintEnabled.ps1"
    $PSDProcess = Start-Process PowerShell -ArgumentList $PSDArgument  -NoNewWindow -PassThru -Wait

    Write-PSDInstallLog -Message "Wait a while for MDT to catch up"
    Start-sleep -Seconds 10
}

# Do any desired ISO customizations (right before a new ISO is captured, assuming deployment share is configured to create an ISO)
If ($Env:STAGE -eq "ISO") {
	# CONTENT environment variable contains the path to the directory that will be used to create the ISO.
    Write-PSDInstallLog -Message "Entering the $Env:STAGE phase"
    Write-PSDInstallLog -Message "CONTENT = $Env:CONTENT"
    Write-PSDInstallLog -Message "Wait a while for MDT to catch up"
    Start-sleep -Seconds 10
} 

# Do any steps needed after the ISO has been generated
If ($Env:STAGE -eq "POSTISO") {
	# CONTENT environment variable is empty at this stage
    Write-PSDInstallLog -Message "Entering the $Env:STAGE phase"
} 

####

# [17] [PSDUtility.psm1]
<#
.SYNOPSIS

.DESCRIPTION

.LINK

.NOTES
          FileName: PSDUtility.psd1
          Solution: PowerShell Deployment for MDT
          Purpose: General utility routines useful for all PSD scripts.
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-06-02

          Version - 0.0.0 - () - Finalized functional version 1.
          Version - 0.0.1 - () - Added Import-PSDCertificate.
          Version - 0.0.2 - () - Replaced Get-PSDNtpTime
          TODO:

.Example
#>

# Import main module Microsoft.BDD.TaskSequenceModule
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global -Force -ErrorAction Stop -Verbose:$False

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true){
    $verbosePreference = "Continue"
}

$global:psuDataPath = ""
$caller = Split-Path -Path $MyInvocation.PSCommandPath -Leaf

function Get-PSDLocalDataPath{
    param (
        [switch] $move
    )
    # Return the cached local data path if possible
    if ($global:psuDataPath -ne "" -and (-not $move)){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): global:psuDataPath is $psuDataPath, testing access"
        if (Test-Path $global:psuDataPath){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Returning data $global:psuDataPath"
            Return $global:psuDataPath
        }
    }

    # Always prefer the OS volume
    # Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Always prefer the OS volume"

    $localPath = ""
    if ($tsenv:OSVolumeGuid -ne ""){
        if ($tsenv:OSVolumeGuid -eq "MBR"){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:OSVolumeGuid is now $($tsenv:OSVolumeGuid)"
            if($tsenv:OSVersion -eq "WinPE"){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:OSVersion is now $($tsenv:OSVersion)"

                # If the OS volume GUID is not set, we use the fake volume guid value "MBR"
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Get the OS image details (MBR)"
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Using OS volume from tsenv:OSVolume: $($tsenv:OSVolume)."
                $localPath = "$($tsenv:OSVolume):\MININT"
            }
            else{
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:OSVersion is now $($tsenv:OSVersion)"
                # If the OS volume GUID is not set, we use the fake volume guid value "MBR"
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Get the OS image details (MBR)"
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Using OS volume from env:SystemDrive $($env:SystemDrive)."
                $localPath = "$($env:SystemDrive)\MININT"
            }
        }
        else{
            # If the OS volume GUID is set, we should use that volume (UEFI)
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Get the OS image details (UEFI)"
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Checking for OS volume using $($tsenv:OSVolumeGuid)."
            Get-Volume | ? { $_.UniqueID -like "*$($tsenv:OSVolumeGuid)*" } | % {
                $localPath = "$($_.DriveLetter):\MININT"
            }
        }
    }
    
    if ($localPath -eq ""){
        # Look on all other volumes 
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Checking other volumes for a MININT folder."
        Get-Volume | ? {-not [String]::IsNullOrWhiteSpace($_.DriveLetter) } | ? {$_.DriveType -eq 'Fixed'} | ? {$_.DriveLetter -ne 'X'} | ? {Test-Path "$($_.DriveLetter):\MININT"} | Select-Object -First 1 | % {
            $localPath = "$($_.DriveLetter):\MININT"
        }
    }
    
    # Not found on any drive, create one on the current system drive
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Not found on any drive, create one on the current system drive"
    if ($localPath -eq ""){
        $localPath = "$($env:SYSTEMDRIVE)\MININT"
    }
    
    # Create the MININT folder if it doesn't exist
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Create the MININT folder if it doesn't exist"
    if ((Test-Path $localPath) -eq $false){
        New-Item -ItemType Directory -Force -Path $localPath | Out-Null
    }
    
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): localpath set to $localPath"
    $global:psuDataPath = $localPath
    return $localPath
}

function Initialize-PSDFolder{
    Param( 
        $folderPath
    ) 

    if ((Test-Path $folderPath) -eq $false){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating $folderPath"
        New-Item -ItemType Directory -Force -Path $folderPath | Out-Null
    }
}

function Start-PSDLogging{
    Param(
        $Logpath = ""
    )
    
    if($Logpath -eq ""){
        $logPath = "$(Get-PSDLocalDataPath)\SMSOSD\OSDLOGS"
    }
    Initialize-PSDfolder $logPath

    if($PSDDeBug -eq $true){
        Start-Transcript "$logPath\$caller.transcript.log" -Append
        $Global:PSDTranscriptLog = "$logPath\$caller.transcript.log"
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Logging Transcript to $Global:PSDTranscriptLog"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Logging Transcript to $Global:PSDTranscriptLog"
    }

    #Writing to CMtrace file
    #Set PSDLogPath
    $PSDLogFile = "$($($caller).Substring(0,$($caller).Length-4)).log"
    $Global:PSDLogPath = "$logPath\$PSDLogFile"
    
    #Create logfile
    if (!(Test-Path $Global:PSDLogPath))
    {
        ## Create the log file
        New-Item $Global:PSDLogPath -Type File | Out-Null
    } 

    Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Logging CMtrace logs to $Global:PSDLogPath"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Logging CMtrace logs to $Global:PSDLogPath"
}

function Stop-PSDLogging{
    if($PSDDebug -ne $true){
        Return
    }
    try{
        Stop-Transcript | Out-Null
    }
    catch{
    }
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Stop Transcript Logging"
}

Function Write-PSDLog{
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
                                             
        [Parameter()]
        [ValidateSet(1, 2, 3)]
        [string]$LogLevel = 1
    )

    # Don't log any lines containing the word password
    if($Message -like '*password*'){
        $Message = "<Message containing password has been suppressed>"
    }
    
    #check if we have a logpath set
    if($Global:PSDLogPath -ne $null){
        if (!(Test-Path -Path $Global:PSDLogPath)){
            ## Create the log file
            New-Item $Global:PSDLogPath -Type File | Out-Null
        }

        $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
        $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
        $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", $LogLevel
        $Line = $Line -f $LineFormat

        #Log to scriptfile
        Add-Content -Value $Line -Path $Global:PSDLogPath

        #Log to masterfile
        Add-Content -Value $Line -Path (($Global:PSDLogPath | Split-Path) + "\PSD.log")
    }

    if($PSDDebug -eq $true){
        switch ($LogLevel){
            '1'{Write-Verbose -Message $Message}
            '2'{Write-Warning -Message $Message}
            '3'{Write-Error -Message $Message}
            Default {}
        }
    }
}

Start-PSDLogging

function Save-PSDVariables{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Running Save-PSDVariables"
    $PSDLocaldataPath = Get-PSDLocaldataPath
    $v = [xml]"<?xml version=`"1.0`" ?><MediaVarList Version=`"4.00.5345.0000`"></MediaVarList>"
    $Items = Get-ChildItem TSEnv:
    foreach ($Item in $Items){
        $element = $v.CreateElement("var")
        $element.SetAttribute("name", $Item.Name) | Out-Null
        $element.AppendChild($v.createCDATASection($Item.Value)) | Out-Null
        $v.DocumentElement.AppendChild($element) | Out-Null
    }
    
    $path = "$PSDLocaldataPath\Variables.dat"
    $v.Save($path)
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): PSDVariables are saved in: $path"
    $path
}

function Restore-PSDVariables{
    $path = "$(Get-PSDLocaldataPath)\Variables.dat"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Restore-PSDVariables from $path"
    if (Test-Path -Path $path) {
        [xml] $v = Get-Content -Path $path
        $v | Select-Xml -Xpath "//var" | % { Set-Item tsenv:$($_.Node.name) -Value $_.Node.'#cdata-section' } 
    }
    return $path
}

function Clear-PSDInformation{
    # Create a folder for the logs
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Create a folder for the logs"
    $logDest = "$($env:SystemRoot)\Temp\DeploymentLogs"
    Initialize-PSDFolder $logDest

    # Process each volume looking for MININT folders
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Process each volume looking for MININT folders"
    Get-Volume | ? {-not [String]::IsNullOrWhiteSpace($_.DriveLetter) } | ? {$_.DriveType -eq 'Fixed'} | ? {$_.DriveLetter -ne 'X'} | ? {Test-Path "$($_.DriveLetter):\MININT"} | % {
        $localPath = "$($_.DriveLetter):\MININT"

        # Copy PSD logs
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy PSD logs"
        if (Test-Path "$localPath\SMSOSD\OSDLOGS"){
            Write-Verbose "Copy-Item $localPath\SMSOSD\OSDLOGS\* $logDest"
            Copy-Item "$localPath\SMSOSD\OSDLOGS\*" $logDest -Force
        }

        # Copy Panther,Debug and other logs
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy Panther,Debug and other logs"
        if (Test-Path "$env:SystemRoot\Panther"){
            New-Item -Path "$logDest\Panther" -ItemType Directory -Force | Out-Null
            New-Item -Path "$logDest\Debug" -ItemType Directory -Force | Out-Null
            New-Item -Path "$logDest\Panther\UnattendGC" -ItemType Directory -Force | Out-Null

            # Check for log files in different locations
            $Logfiles = @(
                "wpeinit.log"
                "Debug\DCPROMO.LOG"
                "Debug\DCPROMOUI.LOG"
                "Debug\Netsetup.log"
                "Panther\cbs_unattend.log"
                "Panther\setupact.log"
                "Panther\setuperr.log"
                "Panther\UnattendGC\setupact.log"
                "Panther\UnattendGC\setuperr.log"
            )

            foreach($Logfile in $Logfiles){
                
                $Sources = "$env:TEMP\$Logfile","$env:SystemRoot\$Logfile","$env:SystemRoot\System32\$Logfile","$env:Systemdrive\`$WINDOWS.~BT\Sources"
                foreach($Source in $Sources){
                    If(Test-Path -Path "$Source"){
                        Write-Verbose "$($MyInvocation.MyCommand.Name): Copying $Source to $logDest\$Logfile"
                        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copying $Source to $logDest\$Logfile"
                        Copy-Item -Path "$Source" -Destination $logDest\$Logfile
                    }
                }
            }
        }

        # Copy SMSTS log
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy SMSTS log"
        if (Test-Path "$env:LOCALAPPDATA\temp\smstslog\smsts.log"){
            Copy-Item -Path "$env:LOCALAPPDATA\temp\smstslog\smsts.log" -Destination $logDest
        }

        # Copy variables.dat (TODO: Password needs to be cleaned out)
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copy variables.dat (TODO)"
        if (Test-Path "$localPath\Variables.dat"){
            Copy-Item "$localPath\Variables.dat" $logDest -Force
        }

        # Check if DEVRunCleanup is set to NO
        if ($($tsenv:DEVRunCleanup) -eq "NO"){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:DEVRunCleanup is now $tsenv:DEVRunCleanup."
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Cleanup will not remove MININT or Drivers folder."
        }
        else{
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:DEVRunCleanup is now $tsenv:DEVRunCleanup."
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Cleanup will remove MININT and Drivers folder."
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): This will be the last log entry."

            # Remove the MININT folder
            if(Test-Path -Path "$localPath"){
                Remove-Item "$localPath" -Recurse -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            }
            
            # Remove the Drivers folder
            if(Test-Path -Path "$($env:Systemdrive + "\Drivers")"){
                Remove-Item "$($env:Systemdrive + "\Drivers")" -Recurse -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            }
        }
    }

    # Remove shortcut to PSDStart.ps1 if it exists
    $allUsersStartup = [Environment]::GetFolderPath('CommonStartup')
    $linkPath = "$allUsersStartup\PSDStartup.lnk"
    if(Test-Path $linkPath){
        $Null = Get-Item -Path $linkPath | Remove-Item -Force
    }

    # Cleanup AutoLogon
    $Null = New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoAdminLogon -Value 0 -Force
    $Null = New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultUserName -Value "" -Force
    $Null = New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultPassword -Value "" -Force
}

function Copy-PSDFolder{
    param (
        [Parameter(Mandatory=$True,Position=1)]
        [string] $source,
        [Parameter(Mandatory=$True,Position=2)]
        [string] $destination
    )

    $s = $source.TrimEnd("\")
    $d = $destination.TrimEnd("\")
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Copying folder $source to $destination using XCopy"
    & xcopy $s $d /s /e /v /d /y /i
}

function Test-PSDNetCon{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        $Hostname, 
        $Protocol
    )

    switch ($Protocol){
        SMB{
            $Port = 445
        }
        HTTP{
            $Port = 80
        }
        HTTPS{
            $Port = 443
        }
        WINRM{
            $Port = 5985
        }
        Default{
            exit
        }
    }

    try{
        $ips = [System.Net.Dns]::GetHostAddresses($hostname) | Where-Object AddressFamily -EQ InterNetwork | Select-Object IPAddressToString -ExpandProperty  IPAddressToString
        if($ips.GetType().Name -eq "Object[]"){
            $ips
        }
    }
    catch{
        Write-Verbose "Possibly $hostname is wrong hostname or IP"
        $ips = "NA"
    }

    $maxAttempts = 5
    $attempts=0

    foreach($ip in $ips){
        While($true){
            $attempts++
            $TcpClient = New-Object Net.Sockets.TcpClient
            try{
                Write-Verbose "Testing $ip,$port, attempt $attempts"
                $TcpClient.Connect($ip,$port)
            }
            catch{
                Write-Verbose "Attempt $attempts of $maxAttempts failed"
                if($attempts -ge $maxAttempts){
                    Throw
                }else{
                    sleep -s 2
                }
            }
            if($TcpClient.Connected){
                $TcpClient.Close()
                $Result = $true
                Return $Result
                Break
            }
            else{
                $Result = $false
            }
        }
        Return $Result
    }
}

Function Get-PSDDriverInfo{
    Param
    (
        $Path = $Driver.FullName
    )

    #Get filename
    $InfName = $Path | Split-Path -Leaf

    $Pattern = 'DriverVer'
    $Content = Get-Content -Path $Path
    #$DriverVer = $Content | Select-String -Pattern $Pattern
    $DriverVer = (($Content | Select-String -Pattern $Pattern -CaseSensitive) -replace '.*=(.*)','$1') -replace ' ','' -replace ',','-' -split "-"

    $DriverVersion = ($DriverVer[1] -split ";")[0]

    $Pattern = 'Class'
    $Content = Get-Content -Path $Path
    $Class = ((($Content | Select-String -Pattern $Pattern) -notlike "ClassGUID*"))[0] -replace " ","" -replace '.*=(.*)','$1' -replace '"',''


    $Provider = ($Content | Select-String '^\s*Provider\s*=.*') -replace '.*=(.*)','$1'
    if ($Provider.Length -eq 0) {
        $Provider = ""
    }
    elseif($Provider.Length -gt 0 -And $Provider -is [system.array]) {
        if ($Provider.Length -gt 1 -And $Provider[0].Trim(" ").StartsWith("%")) {
            $Provider = $Provider[1];
        } else {
            $Provider = $Provider[0]
        }
    }
    $Provider = $Provider.Trim(' ')

    if ($Provider.StartsWith("%")) {
        $Provider = $Provider.Trim('%')
        $Manufacter = ($Content | Select-String "^$Provider\s*=") -replace '.*=(.*)','$1'
    }
    else {
        $Manufacter = ""
    }    

    if ($Manufacter.Length -eq 0) {
        $Manufacter = $Provider
    } elseif ($Manufacter.Length -gt 0 -And $Manufacter -is [system.array]) {
        if ($Manufacter.Length -gt 1 -And $Manufacter[0].Trim(" ").StartsWith("%")) {
            $Manufacter = $Manufacter[1];
        }
        else {
            $Manufacter = $Manufacter[0];
        }
    }
    $Manufacter = $Manufacter.Trim(' ').Trim('"')

    

    $HashTable = [Ordered]@{
        Name = $InfName
        Manufacturer = $Manufacter
        Class = $Class
        Date = $DriverVer[0]
        Version = $DriverVersion
    }
    
    New-Object -TypeName psobject -Property $HashTable
}

Function Show-PSDInfo{
    Param
    (
        $Message,
        [ValidateSet("Information","Warning","Error")]
        $Severity = "Information",
        $OSDComputername,
        $Deployroot
    )

$File = {
Param
(
    $Message,
    $Severity = "Information",
    $OSDComputername,
    $Deployroot
)
    
switch ($Severity)
{
    'Error' 
    {
        $BackColor = "salmon"
        $Label1Text = "Error"
    }
    'Warning' 
    {
        $BackColor = "yellow"
        $Label1Text = "Warning"
    }
    'Information' 
    {
        $BackColor = "#F0F0F0"
        $Label1Text = "Information"
    }
    Default 
    {
        $BackColor = "#F0F0F0"
        $Label1Text = "Information"
    }
}

Get-WmiObject Win32_ComputerSystem | % {
    $Manufacturer = $_.Manufacturer
    $Model = $_.Model
    $Memory = [int] ($_.TotalPhysicalMemory / 1024 / 1024)
}

Get-WmiObject Win32_ComputerSystemProduct | % {
    $UUID = $_.UUID
}
    
Get-WmiObject Win32_BaseBoard | % {
    $Product = $_.Product
    $SerialNumber = $_.SerialNumber
}

try{Get-SecureBootUEFI -Name SetupMode | Out-Null ; $BIOSUEFI = "UEFI"}catch{$BIOSUEFI = "BIOS"}

Get-WmiObject Win32_SystemEnclosure | % {
    $AssetTag = $_.SMBIOSAssetTag.Trim()
    if ($_.ChassisTypes[0] -in "8", "9", "10", "11", "12", "14", "18", "21") { $ChassisType = "Laptop"}
    if ($_.ChassisTypes[0] -in "3", "4", "5", "6", "7", "15", "16") { $ChassisType = "Desktop"}
    if ($_.ChassisTypes[0] -in "23") { $ChassisType = "Server"}
    if ($_.ChassisTypes[0] -in "34", "35", "36") { $ChassisType = "Small Form Factor"}
    if ($_.ChassisTypes[0] -in "13", "31", "32", "30") { $ChassisType = "Tablet"} 
}

$ipList = @()
$macList = @()
$gwList = @()
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 1" | % {
    $_.IPAddress | % {$ipList += $_ }
    $_.MacAddress | % {$macList += $_ }
    if ($_.DefaultIPGateway) {
    $_.DefaultIPGateway | % {$gwList += $_ }
    }
}
$IPAddress = $ipList
$MacAddress = $macList
$DefaultGateway = $gwList

try
{
    Add-Type -AssemblyName System.Windows.Forms -IgnoreWarnings
    [System.Windows.Forms.Application]::EnableVisualStyles()
}
catch [System.UnauthorizedAccessException] {
    # This should never happen, but we're catching if it does anyway.
    Start-Process PowerShell -ArgumentList {
        Write-warning -Message 'Access denied when trying to load required assemblies, cannot display the summary window.'
        Pause
    } -Wait
    exit 1
}
catch [System.Exception] {
    # This should never happen either, but we're catching if it does anyway.
    Start-Process PowerShell -ArgumentList {
        Write-warning -Message 'Unable to load required assemblies, cannot display the summary window.'
        Pause
    } -Wait
    exit 1
}

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '600,390'
$Form.text                       = "PSD"
$Form.StartPosition              = "CenterScreen"
$Form.BackColor                  = $BackColor
$Form.TopMost                    = $true
$Form.Icon                       = [System.Drawing.Icon]::ExtractAssociatedIcon($PSHome + "\powershell.exe")

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "$Label1Text"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(25,10)
$Label1.Font                     = 'Segoe UI,14'

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "OSDComputername: $OSDComputername"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(25,180)
$Label2.Font                     = 'Segoe UI,10'

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "DeployRoot: $Deployroot"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(25,200)
$Label3.Font                     = 'Segoe UI,10'

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.text                     = "Model: $Model"
$Label4.AutoSize                 = $true
$Label4.width                    = 25
$Label4.height                   = 10
$Label4.location                 = New-Object System.Drawing.Point(25,220)
$Label4.Font                     = 'Segoe UI,10'

$Label5                          = New-Object system.Windows.Forms.Label
$Label5.text                     = "Manufacturer: $Manufacturer"
$Label5.AutoSize                 = $true
$Label5.width                    = 25
$Label5.height                   = 10
$Label5.location                 = New-Object System.Drawing.Point(25,240)
$Label5.Font                     = 'Segoe UI,10'

$Label6                          = New-Object system.Windows.Forms.Label
$Label6.text                     = "Memory(MB): $Memory"
$Label6.AutoSize                 = $true
$Label6.width                    = 25
$Label6.height                   = 10
$Label6.location                 = New-Object System.Drawing.Point(25,260)
$Label6.Font                     = 'Segoe UI,10'

$Label7                          = New-Object system.Windows.Forms.Label
$Label7.text                     = "BIOS/UEFI: $BIOSUEFI"
$Label7.AutoSize                 = $true
$Label7.width                    = 25
$Label7.height                   = 10
$Label7.location                 = New-Object System.Drawing.Point(25,280)
$Label7.Font                     = 'Segoe UI,10'

$Label8                          = New-Object system.Windows.Forms.Label
$Label8.text                     = "SerialNumber: $SerialNumber"
$Label8.AutoSize                 = $true
$Label8.width                    = 25
$Label8.height                   = 10
$Label8.location                 = New-Object System.Drawing.Point(25,300)
$Label8.Font                     = 'Segoe UI,10'

$Label9                          = New-Object system.Windows.Forms.Label
$Label9.text                     = "UUID: $UUID"
$Label9.AutoSize                 = $true
$Label9.width                    = 25
$Label9.height                   = 10
$Label9.location                 = New-Object System.Drawing.Point(25,320)
$Label9.Font                     = 'Segoe UI,10'

$Label10                          = New-Object system.Windows.Forms.Label
$Label10.text                     = "ChassisType: $ChassisType"
$Label10.AutoSize                 = $true
$Label10.width                    = 25
$Label10.height                   = 10
$Label10.location                 = New-Object System.Drawing.Point(25,340)
$Label10.Font                     = 'Segoe UI,10'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $True
$TextBox1.width                  = 550
$TextBox1.height                 = 100
$TextBox1.location               = New-Object System.Drawing.Point(25,60)
$TextBox1.Font                   = 'Segoe UI,12'
$TextBox1.Text                   = $Message
$TextBox1.ReadOnly               = $True

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Ok"
$Button1.width                   = 60
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(500,300)
$Button1.Font                    = 'Segoe UI,12'

$Form.controls.AddRange(@($Label1,$Label2,$Label3,$Label4,$Label5,$Label6,$Label7,$Label8,$Label9,$Label10,$TextBox1,$Button1))

$Button1.Add_Click({ Ok })
    
function Ok (){$Form.close()}

[void]$Form.ShowDialog()
}
    $ScriptFile = $env:TEMP + "\Show-PSDInfo.ps1"
    $File | Out-File -Width 255 -FilePath $ScriptFile

    if(($OSDComputername -eq "") -or ($OSDComputername -eq $null)){$OSDComputername = $env:COMPUTERNAME}
    if(($Deployroot -eq "") -or ($Deployroot -eq $null)){$Deployroot = "NA"}

    Start-Process -FilePath PowerShell.exe -ArgumentList $ScriptFile, "'$Message'", $Severity, $OSDComputername, $Deployroot

    #$ScriptFile = $env:TEMP + "\Show-PSDInfo.ps1"
    #$RunFile = $env:TEMP + "\Show-PSDInfo.cmd"
    #$File | Out-File -Width 255 -FilePath $ScriptFile
    #Set-Content -Path $RunFile -Force -Value "PowerShell.exe -File $ScriptFile -Message ""$Message"" -Severity $Severity -OSDComputername $OSDComputername -Deployroot $Deployroot"
    #Start-Process -FilePath $RunFile
}

Function Get-PSDInputFromScreen{
    Param
    (
        $Header,
        $Message,

        [ValidateSet("Ok","Yes")]
        $ButtonText,
        [switch]$PasswordText
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Header
    $form.Size = New-Object System.Drawing.Size(400,200)
    $form.StartPosition = 'CenterScreen'

    $Button1 = New-Object System.Windows.Forms.Button
    $Button1.Location = New-Object System.Drawing.Point(290,110)
    $Button1.Size = New-Object System.Drawing.Size(80,30)
    $Button1.Text = $ButtonText
    $Button1.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $Button1
    $form.Controls.Add($Button1)

    $Label1 = New-Object System.Windows.Forms.Label
    $Label1.Location = New-Object System.Drawing.Point(10,20)
    $Label1.Size = New-Object System.Drawing.Size(360,20)
    $Label1.Text = $Message
    $form.Controls.Add($Label1)

    if($PasswordText){
        $textBox = New-Object System.Windows.Forms.MaskedTextBox
        $textBox.Location = New-Object System.Drawing.Point(10,60)
        $textBox.Size = New-Object System.Drawing.Size(360,20)
        $textBox.PasswordChar = '*'
        $form.Controls.Add($textBox)
    }
    else{
        $textBox = New-Object System.Windows.Forms.TextBox
        $textBox.Location = New-Object System.Drawing.Point(10,60)
        $textBox.Size = New-Object System.Drawing.Size(360,20)
        $form.Controls.Add($textBox)
    }

    $form.Topmost = $true
    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()

    Return $textBox.Text
}

Function Show-PSDSimpleNotify{
    Param
    (
        $Message
    )

    $Header =  "PSD"

    $ButtonText = "Ok"

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Header
    $form.Size = New-Object System.Drawing.Size(400,200)
    $form.StartPosition = 'CenterScreen'

    $Button1 = New-Object System.Windows.Forms.Button
    $Button1.Location = New-Object System.Drawing.Point(290,110)
    $Button1.Size = New-Object System.Drawing.Size(80,30)
    $Button1.Text = $ButtonText
    $Button1.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $Button1
    $form.Controls.Add($Button1)

    $Label1 = New-Object System.Windows.Forms.Label
    $Label1.Location = New-Object System.Drawing.Point(10,20)
    $Label1.Size = New-Object System.Drawing.Size(360,20)
    $Label1.Text = $Message
    $form.Controls.Add($Label1)
    $form.Topmost = $true
    $result = $form.ShowDialog()
}

Function Invoke-PSDHelper{
    Param(
        $MDTDeploySharePath,
        $UserName,
        $Password
    )

    #Connect
    & net use $MDTDeploySharePath $Password /USER:$UserName

    #Import Env
    Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global -Force -Verbose:$False
    Import-Module PSDUtility -Force -Verbose:$False
    Import-Module PSDDeploymentShare -Force -Verbose:$False
    Import-Module PSDGather -Force -Verbose:$False

    dir tsenv: | Out-File "$($env:SystemDrive)\DumpVars.log"
    Get-Content -Path "$($env:SystemDrive)\DumpVars.log"
}

Function Invoke-PSDEXE{
    [CmdletBinding(SupportsShouldProcess=$true)]

    param(
        [parameter(mandatory=$true,position=0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Executable,

        [parameter(mandatory=$false,position=1)]
        [string]
        $Arguments
    )

    if($Arguments -eq "")
    {
        Write-Verbose "Running Start-Process -FilePath $Executable -ArgumentList $Arguments -NoNewWindow -Wait -Passthru"
        $ReturnFromEXE = Start-Process -FilePath $Executable -NoNewWindow -Wait -Passthru -RedirectStandardError "RedirectStandardError" -RedirectStandardOutput "RedirectStandardOutput"
    }else{
        Write-Verbose "Running Start-Process -FilePath $Executable -ArgumentList $Arguments -NoNewWindow -Wait -Passthru"
        $ReturnFromEXE = Start-Process -FilePath $Executable -ArgumentList $Arguments -NoNewWindow -Wait -Passthru -RedirectStandardError "RedirectStandardError" -RedirectStandardOutput "RedirectStandardOutput"
    }
    Write-Verbose "Returncode is $($ReturnFromEXE.ExitCode)"
    Return $ReturnFromEXE.ExitCode
}

Function Set-PSDCommandWindowsSize{
    <#
    .Synopsis
    Resets the size of the current console window
    .Description
    Set-myConSize resets the size of the current console window. By default, it
    sets the windows to a height of 40 lines, with a 3000 line buffer, and sets the 
    the width and width buffer to 120 characters. 
    .Example
    Set-myConSize
    Restores the console window to 120x40
    .Example
    Set-myConSize -Height 30 -Width 180
    Changes the current console to a height of 30 lines and a width of 180 characters. 
    .Parameter Height
    The number of lines to which to set the current console. The default is 40 lines. 
    .Parameter Width
    The number of characters to which to set the current console. Default is 120. Also sets the buffer to the same value
    .Inputs
    [int]
    [int]
    .Notes
        Author: Charlie Russel
     Copyright: 2017 by Charlie Russel
              : Permission to use is granted but attribution is appreciated
       Initial: 28 April, 2017 (cpr)
       ModHist:
              :
    #>
    [CmdletBinding()]
    Param(
         [Parameter(Mandatory=$False,Position=0)]
         [int]
         $Height = 40,
         [Parameter(Mandatory=$False,Position=1)]
         [int]
         $Width = 120
         )
    $Console = $host.ui.rawui
    $Buffer  = $Console.BufferSize
    $ConSize = $Console.WindowSize

    # If the Buffer is wider than the new console setting, first reduce the buffer, then do the resize
    If ($Buffer.Width -gt $Width ) {
       $ConSize.Width = $Width
       $Console.WindowSize = $ConSize
    }
    $Buffer.Width = $Width
    $ConSize.Width = $Width
    $Buffer.Height = 3000
    $Console.BufferSize = $Buffer
    $ConSize = $Console.WindowSize
    $ConSize.Width = $Width
    $ConSize.Height = $Height
    $Console.WindowSize = $ConSize
}

Function Get-PSDNtpTime {
    [CmdletBinding()]
    [OutputType()]
    Param (
        [String]$Server = 'pool.ntp.org'
        # [Switch]$NoDns    # Do not attempt to lookup V3 secondary-server referenceIdentifier
    )

    # --------------------------------------------------------------------
    # From https://gallery.technet.microsoft.com/scriptcenter/Get-Network-NTP-Time-with-07b216ca
    # Modifications via https://www.mathewjbray.com/powershell/powershell-get-ntp-time/
    # --------------------------------------------------------------------

    # NTP Times are all UTC and are relative to midnight on 1/1/1900
    $StartOfEpoch=New-Object DateTime(1900,1,1,0,0,0,[DateTimeKind]::Utc)   


    Function OffsetToLocal($Offset) {
    # Convert milliseconds since midnight on 1/1/1900 to local time
        $StartOfEpoch.AddMilliseconds($Offset).ToLocalTime()
    }


    # Construct a 48-byte client NTP time packet to send to the specified server
    # (Request Header: [00=No Leap Warning; 011=Version 3; 011=Client Mode]; 00011011 = 0x1B)

    [Byte[]]$NtpData = ,0 * 48
    $NtpData[0] = 0x1B    # NTP Request header in first byte

    $Socket = New-Object Net.Sockets.Socket([Net.Sockets.AddressFamily]::InterNetwork,
                                            [Net.Sockets.SocketType]::Dgram,
                                            [Net.Sockets.ProtocolType]::Udp)
    $Socket.SendTimeOut = 2000  # ms
    $Socket.ReceiveTimeOut = 2000   # ms

    Try {
        $Socket.Connect($Server,123)
    }
    Catch {
        Write-Warning "Failed to connect to server $Server"
        Return 
    }


# NTP Transaction -------------------------------------------------------

        $t1 = Get-Date    # t1, Start time of transaction... 
    
        Try {
            [Void]$Socket.Send($NtpData)
            [Void]$Socket.Receive($NtpData)  
        }
        Catch {
            Write-Warning "Failed to communicate with server $Server"
            Return
        }

        $t4 = Get-Date    # End of NTP transaction time

# End of NTP Transaction ------------------------------------------------

    $Socket.Shutdown("Both") 
    $Socket.Close()

# We now have an NTP response packet in $NtpData to decode.  Start with the LI flag
# as this is used to indicate errors as well as leap-second information

    # Decode the 64-bit NTP times

    # The NTP time is the number of seconds since 1/1/1900 and is split into an 
    # integer part (top 32 bits) and a fractional part, multipled by 2^32, in the 
    # bottom 32 bits.

    # Convert Integer and Fractional parts of the (64-bit) t3 NTP time from the byte array
    $IntPart = [BitConverter]::ToUInt32($NtpData[43..40],0)
    $FracPart = [BitConverter]::ToUInt32($NtpData[47..44],0)

    # Convert to Millseconds (convert fractional part by dividing value by 2^32)
    $t3ms = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)

    # Perform the same calculations for t2 (in bytes [32..39]) 
    $IntPart = [BitConverter]::ToUInt32($NtpData[35..32],0)
    $FracPart = [BitConverter]::ToUInt32($NtpData[39..36],0)
    $t2ms = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)

    # Calculate values for t1 and t4 as milliseconds since 1/1/1900 (NTP format)
    $t1ms = ([TimeZoneInfo]::ConvertTimeToUtc($t1) - $StartOfEpoch).TotalMilliseconds
    $t4ms = ([TimeZoneInfo]::ConvertTimeToUtc($t4) - $StartOfEpoch).TotalMilliseconds
 
    # Calculate the NTP Offset and Delay values
    $Offset = (($t2ms - $t1ms) + ($t3ms-$t4ms))/2
    $Delay = ($t4ms - $t1ms) - ($t3ms - $t2ms)

    # Make sure the result looks sane...
    # If ([Math]::Abs($Offset) -gt $MaxOffset) {
    #     # Network server time is too different from local time
    #     Throw "Network time offset exceeds maximum ($($MaxOffset)ms)"
    # }

    # Decode other useful parts of the received NTP time packet

    # We already have the Leap Indicator (LI) flag.  Now extract the remaining data
    # flags (NTP Version, Server Mode) from the first byte by masking and shifting (dividing)

    $LI_text = Switch ($LI) {
        0    {'no warning'}
        1    {'last minute has 61 seconds'}
        2    {'last minute has 59 seconds'}
        3    {'alarm condition (clock not synchronized)'}
    }

    $VN = ($NtpData[0] -band 0x38) -shr 3    # Server version number

    $Mode = ($NtpData[0] -band 0x07)     # Server mode (probably 'server')
    $Mode_text = Switch ($Mode) {
        0    {'reserved'}
        1    {'symmetric active'}
        2    {'symmetric passive'}
        3    {'client'}
        4    {'server'}
        5    {'broadcast'}
        6    {'reserved for NTP control message'}
        7    {'reserved for private use'}
    }

    # Other NTP information (Stratum, PollInterval, Precision)

    $Stratum = [UInt16]$NtpData[1]   # Actually [UInt8] but we don't have one of those...
    $Stratum_text = Switch ($Stratum) {
        0                            {'unspecified or unavailable'}
        1                            {'primary reference (e.g., radio clock)'}
        {$_ -ge 2 -and $_ -le 15}    {'secondary reference (via NTP or SNTP)'}
        {$_ -ge 16}                  {'reserved'}
    }

    $PollInterval = $NtpData[2]              # Poll interval - to neareast power of 2
    $PollIntervalSeconds = [Math]::Pow(2, $PollInterval)

    $PrecisionBits = $NtpData[3]      # Precision in seconds to nearest power of 2
    # ...this is a signed 8-bit int
    If ($PrecisionBits -band 0x80) {    # ? negative (top bit set)
        [Int]$Precision = $PrecisionBits -bor 0xFFFFFFE0    # Sign extend
    } else {
        # ..this is unlikely - indicates a precision of less than 1 second
        [Int]$Precision = $PrecisionBits   # top bit clear - just use positive value
    }
    $PrecisionSeconds = [Math]::Pow(2, $Precision)
    

    # Determine the format of the ReferenceIdentifier field and decode
    
    If ($Stratum -le 1) {
        # Response from Primary Server.  RefId is ASCII string describing source
        $ReferenceIdentifier = [String]([Char[]]$NtpData[12..15] -join '')
    }
    Else {

        # Response from Secondary Server; determine server version and decode

        Switch ($VN) {
            3       {
                        # Version 3 Secondary Server, RefId = IPv4 address of reference source
                        $ReferenceIdentifier = $NtpData[12..15] -join '.'

                        # If (-Not $NoDns) {
                        #     If ($DnsLookup =  Resolve-DnsName $ReferenceIdentifier -QuickTimeout -ErrorAction SilentlyContinue) {
                        #         $ReferenceIdentifier = "$ReferenceIdentifier <$($DnsLookup.NameHost)>"
                        #    }
                        # }
                        # Break
                    }

            4       {
                        # Version 4 Secondary Server, RefId = low-order 32-bits of  
                        # latest transmit time of reference source
                        $ReferenceIdentifier = [BitConverter]::ToUInt32($NtpData[15..12],0) * 1000 / 0x100000000
                        Break
                    }

            Default {
                        # Unhandled NTP version...
                        $ReferenceIdentifier = $Null
                    }
        }
    }


    # Calculate Root Delay and Root Dispersion values
    
    $RootDelay = [BitConverter]::ToInt32($NtpData[7..4],0) / 0x10000
    $RootDispersion = [BitConverter]::ToUInt32($NtpData[11..8],0) / 0x10000


    # Finally, create output object and return

    $NtpTimeObj = [PSCustomObject]@{
        NtpServer = $Server
        NtpTime = OffsetToLocal($t4ms + $Offset)
        Offset = $Offset
        OffsetSeconds = [Math]::Round($Offset/1000, 3)
        Delay = $Delay
        t1ms = $t1ms
        t2ms = $t2ms
        t3ms = $t3ms
        t4ms = $t4ms
        t1 = OffsetToLocal($t1ms)
        t2 = OffsetToLocal($t2ms)
        t3 = OffsetToLocal($t3ms)
        t4 = OffsetToLocal($t4ms)
        LI = $LI
        LI_text = $LI_text
        NtpVersionNumber = $VN
        Mode = $Mode
        Mode_text = $Mode_text
        Stratum = $Stratum
        Stratum_text = $Stratum_text
        PollIntervalRaw = $PollInterval
        PollInterval = New-Object TimeSpan(0,0,$PollIntervalSeconds)
        Precision = $Precision
        PrecisionSeconds = $PrecisionSeconds
        ReferenceIdentifier = $ReferenceIdentifier
        RootDelay = $RootDelay
        RootDispersion = $RootDispersion
        Raw = $NtpData   # The undecoded bytes returned from the NTP server
    }

    # Set the default display properties for the returned object
    [String[]]$DefaultProperties =  'NtpServer', 'NtpTime', 'OffsetSeconds', 'NtpVersionNumber', 
                                    'Mode_text', 'Stratum', 'ReferenceIdentifier'

    # Create the PSStandardMembers.DefaultDisplayPropertySet member
    $ddps = New-Object Management.Automation.PSPropertySet('DefaultDisplayPropertySet', $DefaultProperties)

    # Attach default display property set and output object
    $PSStandardMembers = [Management.Automation.PSMemberInfo[]]$ddps 
    $NtpTimeObj | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $PSStandardMembers -PassThru
}

Function Write-PSDEvent{
    param(
        $MessageID,
        $Severity,
        $Message
    )

    if($tsenv:EventService -eq ""){
        return
    }
    
    # a Deployment has started (EventID 41016)
    # a Deployment completed successfully (EventID 41015)
    # a Deployment failed (EventID 41014)
    # an error occurred (EventID 3)
    # a warning occurred (EventID 2)

    if($tsenv:LTIGUID -eq ""){
        $LTIGUID = ([guid]::NewGuid()).guid
        New-Item -Path TSEnv: -Name "LTIGUID" -Value "$LTIGUID" -Force
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:LTIGUID is now: $tsenv:LTIGUID"
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Saving Variables"
        $variablesPath = Save-PSDVariables
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Variables was saved to $variablesPath"
    }

    $MacAddress = $tsenv:MacAddress001
    $Lguid = $tsenv:LTIGUID
    $id = $tsenv:UUID
    $vmhost = 'NA'
    $ComputerName = $tsenv:OSDComputerName

    $CurrentStep = $tsenv:_SMSTSNextInstructionPointer
	if($CurrentStep -eq ""){
        $CurrentStep = '0'
    }

	$TotalSteps = $tsenv:_SMSTSInstructionTableSize
	if($TotalSteps -eq ""){
        $TotalSteps= '0'
    }
    $Return = Invoke-WebRequest "$tsenv:EventService/MDTMonitorEvent/PostEvent?uniqueID=$Lguid&computerName=$ComputerName&messageID=$messageID&severity=$severity&stepName=$CurrentStep&totalSteps=$TotalSteps&id=$id,$macaddress&message=$Message&dartIP=&dartPort=&dartTicket=&vmHost=$vmhost&vmName=$ComputerName" -UseBasicParsing
}

Function Show-PSDActionProgress {
    Param(
        $Message,
        $Step,
        $MaxStep
    )
    $ts = New-Object -ComObject Microsoft.SMS.TSEnvironment
    $tsui = New-Object -ComObject Microsoft.SMS.TSProgressUI
    $tsui.ShowActionProgress($ts.Value("_SMSTSOrgName"),$ts.Value("_SMSTSPackageName"),$ts.Value("_SMSTSCustomProgressDialogMessage"),$ts.Value("_SMSTSCurrentActionName"),[Convert]::ToUInt32($ts.Value("_SMSTSNextInstructionPointer")),[Convert]::ToUInt32($ts.Value("_SMSTSInstructionTableSize")),$Message,$Step,$MaxStep)
}

function Import-PSDCertificate{
    Param(
        $Path,
        $CertStoreScope,
        $CertStoreName
    )

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Adding $Path to Certificate Store: $CertStoreName in Certificate Scope: $CertStoreScope"
    # Create Object
    $CertStore = New-Object System.Security.Cryptography.X509Certificates.X509Store  -ArgumentList  $CertStoreName,$CertStoreScope
    $Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 

    # Import Certificate
    $CertStore.Open('ReadWrite')
    $Cert.Import($Path)
    $CertStore.Add($Cert)
    $Result = $CertStore.Certificates | Where-Object Subject -EQ $Cert.Subject
    $CertStore.Close()
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Certificate Subject    : $($Result.Subject)"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Certificate Issuer     : $($Result.Issuer)"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Certificate Thumbprint : $($Result.Thumbprint)"
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Certificate NotAfter   : $($Result.NotAfter)"
    Return "0"
}

Function Set-PSDDebugPause{
    Param(
        $Prompt
    )
    if($Global:PSDDebug -eq $True){
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name)"
        Read-Host -Prompt "$Prompt"
    }
}
####

# [18] [PSDValidate.ps1]
# // ***************************************************************************
# // 
# // PowerShell Deployment for MDT
# //
# // File:      PSDTemplate.ps1
# // 
# // Purpose:   Apply the specified operating system.
# // 
# // 
# // ***************************************************************************

param (

)

# Load core modules
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module PSDUtility
Import-Module PSDDeploymentShare

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Load core modules"

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:ImageSize $($tsenv:ImageSize)"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:ImageProcessorSpeed $($tsenv:ImageProcessorSpeed)"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:ImageMemory $($tsenv:ImageMemory)"
Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): tsenv:VerifyOS $($tsenv:VerifyOS)"

<#
    '//----------------------------------------------------------------------------
    '//  Abort if this is a server OS
    '//----------------------------------------------------------------------------
#>

# TODO: The logic is only used when running in Windows, the logic needs to change from using DeploymentType to detect we are running inside Windows or not
If($TSEnv:DeploymentType -eq "REFRESH")
{
	If ($TSEnv:VerifyOS -eq "CLIENT")
    {
		If($TSEnv:IsServerOS -eq "TRUE")
        {
            $Message = "ERROR - Attempting to deploy a client operating system to a machine running a server operating system."
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message" -LogLevel 3
            Show-PSDInfo -Message $Message  -Severity Error
            Start-Process PowerShell -Wait
            Break
        }
    }

	If ($TSEnv:VerifyOS -eq "SERVER")
    {
		If($TSEnv:IsServerOS -eq "FALSE")
        {
            $Message = "ERROR - Attempting to deploy a server operating system to a machine running a client operating system."
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message" -LogLevel 3
            Show-PSDInfo -Message $Message  -Severity Error
            Start-Process PowerShell -Wait
            Break
        }
    }
}

<#
	'//----------------------------------------------------------------------------
	'//  Abort if "OSInstall" flag is set to something other than Y or YES
	'//----------------------------------------------------------------------------
#>

    If($TSEnv:OSInstall -eq "Y" -or "YES")
    {
        $Message = "OSInstall flag is $TSEnv:OSInstall , install is allowed."
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message" -LogLevel 1
    }
    else
    {
        $Message = "OSInstall flag is NOT set to Y or YES, abort."
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $Message" -LogLevel 3
        Show-PSDInfo -Message $Message -Severity Error
        Start-Process PowerShell -Wait
        Break
    }


Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Save all the current variables for later use"
Save-PSDVariables
####

# [19] [PSDWindowsUpdate.ps1]
# // ***************************************************************************
# // 
# // PowerShell Deployment for MDT
# //
# // File:      PSDWindowsUpdate.ps1
# // 
# // Purpose:   Apply the specified operating system.
# // 
# // 
# // ***************************************************************************

param (

)

# Load core modules
Import-Module PSDUtility
Import-Module PSDDeploymentShare

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true)
{
    $verbosePreference = "Continue"
}

# Write to the 
Write-PSDEvent -MessageID 41000 -severity 1 -Message "Starting: $($MyInvocation.MyCommand.Name)"

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating COM object for WU"
$objServiceManager = New-Object -ComObject 'Microsoft.Update.ServiceManager';
$objSession = New-Object -ComObject 'Microsoft.Update.Session';
$objSearcher = $objSession.CreateUpdateSearcher();
$objSearcher.ServerSelection = $serverSelection;
$serviceName = 'Windows Update';
$search = 'IsInstalled = 0';
$objResults = $objSearcher.Search($search);
$Updates = $objResults.Updates;
$FoundUpdatesToDownload = $Updates.Count;

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Searching for updates"
$NumberOfUpdate = 1;
$objCollectionDownload = New-Object -ComObject 'Microsoft.Update.UpdateColl';
$updateCount = $Updates.Count;
Foreach($Update in $Updates)
{
	Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Downloading $($Update.Title)"
    Show-PSDActionProgress -Message "Downloading $($Update.Title)" -Step "$NumberOfUpdate" -MaxStep "$ReadyUpdatesToInstall"
	$NumberOfUpdate++;
	Write-Debug `"Show` update` to` download:` $($Update.Title)`" ;
	Write-Debug 'Accept Eula';
	$Update.AcceptEula();
	Write-Debug 'Send update to download collection';
	$objCollectionTmp = New-Object -ComObject 'Microsoft.Update.UpdateColl';
	$objCollectionTmp.Add($Update) | Out-Null;

	$Downloader = $objSession.CreateUpdateDownloader();
	$Downloader.Updates = $objCollectionTmp;
	Try
	{
		Write-Debug 'Try download update';
		$DownloadResult = $Downloader.Download();
	} <#End Try#>
	Catch
	{
		If($_ -match 'HRESULT: 0x80240044')
		{
			Write-Warning 'Your security policy do not allow a non-administator identity to perform this task';
		} <#End If $_ -match 'HRESULT: 0x80240044'#>

		Return
	} <#End Catch#>

	Write-Debug 'Check ResultCode';
	Switch -exact ($DownloadResult.ResultCode)
	{
		0   { $Status = 'NotStarted'; }
		1   { $Status = 'InProgress'; }
		2   { $Status = 'Downloaded'; }
		3   { $Status = 'DownloadedWithErrors'; }
		4   { $Status = 'Failed'; }
		5   { $Status = 'Aborted'; }
	} <#End Switch#>

	If($DownloadResult.ResultCode -eq 2)
	{
		Write-Debug 'Downloaded then send update to next stage';
		$objCollectionDownload.Add($Update) | Out-Null;
	} <#End If $DownloadResult.ResultCode -eq 2#>
}

$ReadyUpdatesToInstall = $objCollectionDownload.count;
Write-Verbose `"Downloaded` [$ReadyUpdatesToInstall]` Updates` to` Install`" ;
If($ReadyUpdatesToInstall -eq 0)
{
	Return;
} <#End If $ReadyUpdatesToInstall -eq 0#>

$NeedsReboot = $false;
$NumberOfUpdate = 1;

Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): install updates"
<#install updates#>
Foreach($Update in $objCollectionDownload)
{
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Installing update $($Update.Title)"
	Show-PSDActionProgress -Message "Installing $($Update.Title)" -Step "$NumberOfUpdate" -MaxStep "$ReadyUpdatesToInstall"
	Write-Debug "Show update to install: $($Update.Title)"

	Write-Debug 'Send update to install collection';
	$objCollectionTmp = New-Object -ComObject 'Microsoft.Update.UpdateColl';
	$objCollectionTmp.Add($Update) | Out-Null;

	$objInstaller = $objSession.CreateUpdateInstaller();
	$objInstaller.Updates = $objCollectionTmp;

	Try
	{
		Write-Debug 'Try install update';
		$InstallResult = $objInstaller.Install();
	} <#End Try#>
	Catch
	{
		If($_ -match 'HRESULT: 0x80240044')
		{
			Write-Warning 'Your security policy do not allow a non-administator identity to perform this task';
		} <#End If $_ -match 'HRESULT: 0x80240044'#>

		Return;
	} #End Catch

	If(!$NeedsReboot)
	{
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): RebootRequired"
		Write-Debug 'Set instalation status RebootRequired';
		$NeedsReboot = $installResult.RebootRequired;
	} <#End If !$NeedsReboot#>
	$NumberOfUpdate++;
} <#End Foreach $Update in $objCollectionDownload#>

if($NeedsReboot){
    $tsenv:SMSTSRebootRequested = "true"
}
####

# [20] [PSDWizard.psm1]
<#
.SYNOPSIS
    Module for the PSD Wizard
.DESCRIPTION
    Module for the PSD Wizard
.LINK
    https://github.com/FriendsOfMDT/PSD
.NOTES
          FileName: PSDWizard.psm1
          Solution: PowerShell Deployment for MDT
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-05-09

          Version - 0.0.0 - () - Finalized functional version 1.

          TODO:

.Example
#>

# Check for debug in PowerShell and TSEnv
if($TSEnv:PSDDebug -eq "YES"){
    $Global:PSDDebug = $true
}
if($PSDDebug -eq $true){
    $verbosePreference = "Continue"
}


$script:Wizard = $null
$script:Xaml = $null

function Get-PSDWizard{
    Param( 
        $xamlPath
    ) 

    # Load the XAML
    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
    [xml] $script:Xaml = Get-Content $xamlPath
 
    # Process XAML
    $reader=(New-Object System.Xml.XmlNodeReader $script:Xaml) 
    $script:wizard = [Windows.Markup.XamlReader]::Load($reader)

    # Store objects in PowerShell variables
    $script:Xaml.SelectNodes("//*[@Name]") | % {
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating variable $($_.Name)"
        Set-Variable -Name ($_.Name) -Value $script:Wizard.FindName($_.Name) -Scope Global
    }

    # Attach event handlers
    $wizFinishButton.Add_Click({
        $script:Wizard.DialogResult = $true
        $script:Wizard.Close()
    })

    # Attach event handlers
    $wizCancelButton.Add_Click({
        $script:Wizard.DialogResult = $false
        $script:Wizard.Close()
    })

    # Load wizard script and execute it
    Invoke-Expression "$($xamlPath).Initialize.ps1" | Out-Null

    # Return the form to the caller
    return $script:Wizard
}
function Save-PSDWizardResult{
    $script:Xaml.SelectNodes("//*[@Name]") | ? { $_.Name -like "TS_*" } | % {
        $name = $_.Name.Substring(3)
        $control = $script:Wizard.FindName($_.Name)
        if($_.Name -eq "TS_DomainAdminPassword" -or $_.Name -eq "TS_AdminPassword"){
            $value = $control.Password
            Set-Item -Path tsenv:$name -Value $value 
        }
        else{
            $value = $control.Text
            Set-Item -Path tsenv:$name -Value $value 
        }
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Set variable $name using form value $value"
        if($name -eq "TaskSequenceID"){
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Checking TaskSequenceID value"
            if ($value -eq ""){
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TaskSequenceID is empty!!!"
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Re-Running Wizard, TaskSequenceID must not be empty..."
                Show-PSDSimpleNotify -Message "No Task Sequence selected, restarting wizard..."
                Show-PSDWizard "$scripts\PSDWizard.xaml"
            }
        }
    }
}
function Set-PSDWizardDefault{
    $script:Xaml.SelectNodes("//*[@Name]") | ? { $_.Name -like "TS_*" } | % {
        $name = $_.Name.Substring(3)
        $control = $script:Wizard.FindName($_.Name)
        if($_.Name -eq "TS_DomainAdminPassword" -or $_.Name -eq "TS_AdminPassword"){
            $value = $control.Password
            $control.Password = (Get-Item tsenv:$name).Value
        }
        else{
            $value = $control.Text
            $control.Text = (Get-Item tsenv:$name).Value
        }
    }
}
function Show-PSDWizard{
    Param( 
        $xamlPath
    ) 
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing wizard from $xamlPath"
    $wizard = Get-PSDWizard $xamlPath
    Set-PSDWizardDefault
    $result = $wizard.ShowDialog()
    Save-PSDWizardResult
    Return $wizard
}

Export-ModuleMember -function Show-PSDWizard

####

# [21] [PSDWizard.xaml]
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="PSD Wizard" Height="600" Width="800" WindowStartupLocation="CenterScreen" WindowStyle='SingleBorderWindow' ResizeMode='NoResize'>

    <Grid>

        <StackPanel Orientation="Vertical">
            <StackPanel Height="510" Orientation="Horizontal">
                <TreeView Name="tsTree" HorizontalAlignment="Left" Height="200" Margin="10,5,0,0" VerticalAlignment="Top" Width="250"/>
                <Grid Height="500" Margin="10,5,0,0" VerticalAlignment="Top" Width="460">

                    <Label Content="TaskSequenceID" HorizontalAlignment="Left" Height="25" Margin="0,0,0,0" VerticalAlignment="Top"/>
                    <TextBox FontWeight="Bold" Name="TS_TaskSequenceID" HorizontalAlignment="Center" Height="25" Margin="125,0,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="Deployroot" HorizontalAlignment="Left" Height="25" Margin="0,40,0,0" VerticalAlignment="Top"/>
                    <TextBox FontWeight="Bold" IsReadOnly="True" Name="TS_Deployroot" Text="1234567890" HorizontalAlignment="Center" Height="25" Margin="125,40,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="Model" HorizontalAlignment="Left" Height="25" Margin="0,80,0,0" VerticalAlignment="Top"/>
                    <TextBox FontWeight="Bold" IsReadOnly="True" Name="TS_Model" Text="1234567890" HorizontalAlignment="Center" Height="25" Margin="125,80,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="SerialNumber" HorizontalAlignment="Left" Height="25" Margin="0,120,0,0" VerticalAlignment="Top"/>
                    <TextBox FontWeight="Bold" IsReadOnly="True" Name="TS_SerialNumber" Text="1234567890" HorizontalAlignment="Center" Height="25" Margin="125,120,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="ComputerName" HorizontalAlignment="Left" Height="25" Margin="0,170,0,0" VerticalAlignment="Top"/>
                    <TextBox Name="TS_OSDComputerName" HorizontalAlignment="Center" Height="25" Margin="125,170,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="Admin Password" HorizontalAlignment="Left" Height="25" Margin="0,210,0,0" VerticalAlignment="Top"/>
                    <PasswordBox Name="TS_AdminPassword" HorizontalAlignment="Center" Height="25" Margin="125,210,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="Domain" HorizontalAlignment="Left" Height="25" Margin="0,260,0,0" VerticalAlignment="Top"/>
                    <TextBox Name="TS_JoinDomain" HorizontalAlignment="Center" Height="25" Margin="125,260,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="JoinAccount Name" HorizontalAlignment="Left" Height="25" Margin="0,300,0,0" VerticalAlignment="Top"/>
                    <TextBox Name="TS_DomainAdmin" HorizontalAlignment="Center" Height="25" Margin="125,300,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="JoinAccount Password" HorizontalAlignment="Left" Height="25" Margin="0,340,0,0" VerticalAlignment="Top"/>
                    <PasswordBox Name="TS_DomainAdminPassword" HorizontalAlignment="Center" Height="25" Margin="125,340,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="JoinAccount Domain" HorizontalAlignment="Left" Height="25" Margin="0,380,0,0" VerticalAlignment="Top"/>
                    <TextBox Name="TS_DomainAdminDomain" HorizontalAlignment="Center" Height="25" Margin="125,380,0,0" VerticalAlignment="Top" Width="310"/>

                    <Label Content="OSDRnD" HorizontalAlignment="Left" Height="25" Margin="0,450,0,0" VerticalAlignment="Top"/>
                    <TextBox Name="TS_OSDRnD" HorizontalAlignment="Center" Height="25" Margin="125,450,0,0" VerticalAlignment="Top" Width="310"/>

                </Grid>
            </StackPanel>
            <Border BorderBrush="#A0A0A0" BorderThickness="0,1,0,0" Padding="5">
                <StackPanel>
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto" />
                            <ColumnDefinition Width="*" />
                        </Grid.ColumnDefinitions>
                        <StackPanel Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Right">
                            <Button Name="wizCancelButton" Margin="0,0,7,0" MinWidth="75" Content="Cancel" />
                            <Button Name="wizFinishButton" Margin="7,0,0,0" MinWidth="75" Content="Start" />
                        </StackPanel>
                    </Grid>
                </StackPanel>
            </Border>
        </StackPanel>
    </Grid>
</Window>
####

# [22] [PSDWizard.xaml.Initialize.ps1]
<#
.SYNOPSIS

.DESCRIPTION

.LINK

.NOTES
          FileName: PSDWizard.xaml.ps1
          Solution: PowerShell Deployment for MDT
          Purpose: Script to initialize the wizard content in PSD
          Author: PSD Development Team
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2019-05-09

          Version - 0.0.0 - () - Finalized functional version 1.

          TODO:

.Example
#>

function Validate-Wizard
{
    # TODO: Make sure selection has been made
    # TODO: Set hidden variables
}

# Populate the top-level tree items
Get-ChildItem -Path "DeploymentShare:\Task Sequences" | % {
    $t = New-Object System.Windows.Controls.TreeViewItem
    $t.Header = $_.Name
    $t.Tag = $_
    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $($t.Tag.PSPath)"
    if ($_.PSIsContainer) {
        $t.Items.Add("*")
    }
    $tsTree.Items.Add($t)
}

# Create the Expand event handler
[System.Windows.RoutedEventHandler]$expandEvent = {

    if ($_.OriginalSource -is [System.Windows.Controls.TreeViewItem])
    {
        # Populate the next level of objects
        $current = $_.OriginalSource
        $current.Items.clear()
        $pos = $current.Tag.PSPath.IndexOf("::") + 2
        $path = $current.Tag.PSPath.Substring($pos)
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $path"

        Get-ChildItem -Path $path | % {
            $t = New-Object System.Windows.Controls.TreeViewItem
            $t.Header = $_.Name
            $t.Tag = $_
            if ($_.PSIsContainer) {
                $t.Items.Add("*")
            }
            $current.Items.Add($t)
        }
    }
}
$tsTree.AddHandler([System.Windows.Controls.TreeViewItem]::ExpandedEvent,$expandEvent)

# Create the SelectionChanged event handler
$tsTree.add_SelectedItemChanged({
    if ($this.SelectedItem.Tag.PSIsContainer -ne $true)
    {
        $TS_TaskSequenceID.Text = $this.SelectedItem.Tag.ID
        #$TS_TaskSequenceName = $TS_TaskSequenceID.Text
    }
})
####
