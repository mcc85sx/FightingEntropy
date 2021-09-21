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
          Author: (Original) PSD Development Team, (Modified) Michael C. Cook Sr.
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2021-09-21

          Version - 0.0.0 - () - Finalized functional version 1.

          TODO:

.Example
#>

# Check for debug in PowerShell and TSEnv
If ($TSEnv:PSDDebug -eq "YES")
{
    $Global:PSDDebug = $True
}

If ($PSDDebug -eq $True)
{
    $verbosePreference = "Continue"
}

$Script:Wizard = $null
$Script:Xaml   = $null

Function Get-PSDWizard
{
    Param($XamlPath) 

    # Load the XAML
    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
    [xml] $Script:Xaml = Get-Content $XamlPath
 
    # Process XAML
    $Node              = [System.Xml.XmlNodeReader]$script:Xaml
    $Script:Wizard     = [Windows.Markup.XamlReader]::Load($Node)

    # Store objects in PowerShell variables
    $script:Xaml.SelectNodes("//*[@Name]") | % {

        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Creating variable $($_.Name)"
        Set-Variable -Name ($_.Name) -Value $script:Wizard.FindName($_.Name) -Scope Global
    }

    # Attach event handlers
    $WizFinishButton.Add_Click(
    {
        If ($TS_AdminPassword.Password -notmatch $AdminConfirm.Password)
        {
            Return [System.Windows.MessageBox]::Show("Invalid admin password/confirm","Error")
        }

        ElseIf ($TS_DomainAdminPassword.Password -notmatch $DomainAdminConfirm.Password)
        {
            Return [System.Windows.MessageBox]::Show("Invalid admin password/confirm","Error")
        }

        Else
        {
            $Script:Wizard.DialogResult = $True
            $Script:Wizard.Close()
        }
    })

    # Attach event handlers
    $WizCancelButton.Add_Click(
    {
        $Script:Wizard.DialogResult = $False
        $Script:Wizard.Close()
    })

    # Load wizard script and execute it
    Invoke-Expression "$($XamlPath).Initialize.ps1" | Out-Null

    # Return the form to the caller
    Return $script:Wizard
}

Function Save-PSDWizardResult
{
    $script:Xaml.SelectNodes("//*[@Name]") | ? { $_.Name -like "TS_*" } | % {
        
        $Name        = $_.Name.Substring(3)
        $Control     = $script:Wizard.FindName($_.Name)
        
        $Value       = @($Control.Text,$Control.Password)[[UInt32]($_.Name -eq "TS_DomainAdminPassword" -or $_.Name -eq "TS_AdminPassword")]
        Set-Item -Path tsenv:$Name -Value $Value 
        
        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Set variable [$Name] using form value [$Value]"
        
        If ($Name -eq "TaskSequenceID")
        {
            Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Checking TaskSequenceID value"
            
            If ($Value -eq "")
            {
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): TaskSequenceID is empty!!!"
                Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Re-Running Wizard, TaskSequenceID must not be empty..."
                Show-PSDSimpleNotify -Message "No Task Sequence selected, restarting wizard..."
                Show-PSDWizard "$Scripts\PSDWizard.xaml"
            }
        }
    }
}

Function Set-PSDWizardDefault
{
    $Script:Xaml.SelectNodes("//*[@Name]") | ? { $_.Name -like "TS_*" } | % {
        
        $Name                 = $_.Name.Substring(3)
        $Control              = $Script:Wizard.FindName($_.Name)
        
        If ($_.Name -eq "TS_DomainAdminPassword" -or $_.Name -eq "TS_AdminPassword")
        {
            $Value            = $Control.Password
            $Control.Password = (Get-Item tsenv:$Name).Value
        }
        Else
        {
            $Value            = $Control.Text
            $Control.Text     = (Get-Item tsenv:$Name).Value
        }
    }
}

Function Show-PSDWizard
{
    Param($XamlPath)

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): Processing wizard from [$XamlPath]"

    $Wizard                   = Get-PSDWizard $XamlPath

    Set-PSDWizardDefault

    $Result                   = $Wizard.ShowDialog()

    Save-PSDWizardResult

    Return $Wizard
}

Export-ModuleMember -Function Show-PSDWizard
