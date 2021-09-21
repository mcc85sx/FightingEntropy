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
          Author: (Original) PSD Development Team, (Modified) Michael C. Cook Sr.
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2021-09-21

          Version - 0.0.0 - () - Finalized functional version 1.
          TODO:

.Example
#>

[CmdletBinding()]Param()

# Load core module
Import-Module Microsoft.BDD.TaskSequenceModule -Scope Global
Import-Module PSDUtility
Import-Module PSDGather

# Check for debug in PowerShell and TSEnv
If ($TSEnv:PSDDebug -eq "YES")
{
    $Global:PSDDebug = $True
}
If ($PSDDebug -eq $True)
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
