Class _Module
{
    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.11.0"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Date
    [String]             $Status
    [String]               $Type
    [String]           $Resource = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.11.0"

    [String]           $Registry
    [String]               $Path
    [Object]               $File 
    [Object]           $Manifest 
    [Object]               $Base 

    [Object[]]          $Classes
    [Object[]]          $Control
    [Object[]]        $Functions
    [Object[]]         $Graphics

    [Object[]]            $Tools
    [Object[]]           $Shares
    [Object[]]           $Drives
    [Object[]]     $Certificates

    [Hashtable]          $Module = @{

        Names                    = ("Name Version Provider Date Path Status Type" -Split " ")
        Folders                  = "/Classes/Control/Functions/Graphics" -Split "/"
        Classes                  = ("Root Module QMark File FirewallRule Drive Cache Icons Shortcut Drives Host Block Faces Track Theme " + 
                                    "Object Flag Banner UISwitch Toast XamlWindow XamlObject VendorList V4Network V6Network NetInterface " + 
                                    "Network Info Service Services ViperBomb Brand Branding Certificate Company Key RootVar Share Master " + 
                                    "Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS DCPromo Xaml " + 
                                    "XamlGlossaryItem Image Images Updates" ).Split(" ") | % { "_$_" }
        Control                  = ("Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                                    "ServerMod.xml") -Split " "
        Functions                = ("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write" + 
                                    "-Banner Install-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotifica" + 
                                    "tion New-FECompany Get-ServerDependency Get-FEServices Get-FEHost").Split(" ") | % { "$_" }
        Graphics                 = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp") -Split " "
    }

    Hidden [Object]        $Load
    Hidden [Object]      $Output

    [String] Root([String]$Root)
    {
        Return ( $Root, $This.Provider, $This.Name, $This.Version -join '\' )
    }

    [Object[]] Content([String]$Folder)
    {
        Return ( $This.Base | ? Name -eq $Folder | Get-ChildItem | % FullName )
    }

    _Module()
    {
        $This.Registry           = $This.Root("HKLM:\SOFTWARE\Policies")

        Get-ItemProperty $This.Registry | % { 

            $This.Name           = $_.Name
            $This.Version        = $_.Version
            $This.Provider       = $_.Provider
            $This.Date           = $_.Date
            $This.Status         = $_.Status
            $This.Type           = $_.Type
            $This.Path           = $_.Path
        }

        $This.Path               = $This.Root($Env:ProgramData)
        $This.File               = "{0}\FightingEntropy.psm1" -f $This.Path
        $This.Manifest           = "{0}\FightingEntropy.psd1" -f $This.Path
        $This.Base               = Get-ChildItem -Path $This.Path
        $This.Classes            = $This.Content("Classes")
        $This.Control            = $This.Content("Control")
        $This.Functions          = $This.Content("Functions")
        $This.Graphics           = $This.Content("Graphics")
        $This.Tools              = Get-ChildItem -Path "$($This.Path)\Tools" -EA 0 
        $This.Shares             = Get-ChildItem -Path "$($This.Registry)\Shares" -EA 0 | Get-ItemProperty | Select-Object Name, Path, Description
    }
}
