<#
.SYNOPSIS

.DESCRIPTION

.LINK

.NOTES
          FileName: PSDWizard.xaml.ps1
          Solution: PowerShell Deployment for MDT
          Purpose: Script to initialize the wizard content in PSD
          Author: (Original) PSD Development Team, (Modified) Michael C. Cook Sr.
          Contact: @Mikael_Nystrom , @jarwidmark , @mniehaus , @SoupAtWork , @JordanTheItGuy
          Primary: @Mikael_Nystrom 
          Created: 
          Modified: 2021-09-21

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

    $Tree               = New-Object System.Windows.Controls.TreeViewItem
    $Tree.Header        = $_.Name
    $Tree.Tag           = $_

    Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): $($Tree.Tag.PSPath)"
    
    If ($_.PSIsContainer) 
    {
        $Tree.Items.Add("*")
    }

    $tsTree.Items.Add($Tree)
}

# Create the Expand event handler
[System.Windows.RoutedEventHandler]$expandEvent = {

    If ($_.OriginalSource -is [System.Windows.Controls.TreeViewItem])
    {
        # Populate the next level of objects
        $Current         = $_.OriginalSource
        $Current.Items.Clear()
        $POS             = $Current.Tag.PSPath.IndexOf("::") + 2
        $Path            = $Current.Tag.PSPath.Substring($POS)

        Write-PSDLog -Message "$($MyInvocation.MyCommand.Name): [$Path]"

        Get-ChildItem -Path $Path | % {

            $Tree        = New-Object System.Windows.Controls.TreeViewItem
            $Tree.Header = $_.Name
            $Tree.Tag    = $_
            
            If ($_.PSIsContainer) 
            {
                $Tree.Items.Add("*")
            }

            $Current.Items.Add($Tree)
        }
    }
}

$tsTree.AddHandler([System.Windows.Controls.TreeViewItem]::ExpandedEvent,$expandEvent)

# Create the SelectionChanged event handler
$tsTree.add_SelectedItemChanged(
{
    If ($this.SelectedItem.Tag.PSIsContainer -ne $True)
    {
        $TS_TaskSequenceID.Text = $this.SelectedItem.Tag.ID
        #$TS_TaskSequenceName = $TS_TaskSequenceID.Text
    }
})
