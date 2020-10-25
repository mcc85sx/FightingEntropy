Class _Module
{
    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.10.1"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Path = $Env:ProgramData
    [String]                $URL = "https://github.com/mcc85sx/FightingEntropy/blob/master/2020.10.1"
    [Object]               $File
    [Object]           $Manifest
    [String]           $Registry = "HKLM:\SOFTWARE\Policies"
    [Object]         $Properties
    [Object]               $Base
    [Object]            $Classes
    [Object]            $Control
    [Object]          $Functions
    [Object]           $Graphics
    [Object]              $Tools
    [Object]             $Shares
    
    Hidden [Hashtable]     $Hash = @{ 
    
        Folders   = ("/Classes/Control/Functions/Graphics" -Split "/")

        # _Root _Module
        Classes   = ("_QMark _File _FirewallRule _Drive _Cache _Icons _Shortcut _Drives _Host _Block _Faces " +
                     "_Track _Theme _Object _Flag _Banner _UISwitch _Toast _XamlWindow _XamlObject _Root _Mo" + 
                     "dule _VendorList _V4Network _V6Network _NetInterface _Network _Info _Service _Services" + 
                     " _ViperBomb _Brand _Branding _Certificate _Company _Key _RootVar _Share _Master _Sourc" + 
                     "e _Target _ServerDependency _ServerFeature _ServerFeatures _IISFeatures _IIS _DCPromo " + 
                     "_Xaml _XamlGlossaryItem" ) -Split " "
                     
        Control   = ("Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f 
                     "ClientMod.xml","ServerMod.xml") -Split " "
                     
        Functions = ("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write" + 
                     "-Banner Install-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotifica" + 
                     "tion") -Split " "
                     
        Graphics  = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp") -Split " "
    }

    Hidden [String[]]   $Folders = "Classes Control Functions Graphics" -Split " "
    Hidden [String[]]     $Files = ( "{0}.ps1 {0}.psm1" -f "FightingEntropy" ) -Split " "

    [String] GetRoot([String]$Root)
    {
        Return ( $Root, $This.Provider, $This.Name, $This.Version -join '\' )
    }

    _Module()
    {
        $This.Registry           = $This.GetRoot($This.Registry)
        $This.Path               = $This.GetRoot($This.Path)
        
        If ( ! ( Test-Path $This.Path ) )
        {
            New-Item -Path $This.Path -ItemType Directory -Verbose
        }

        If ( ! ( Test-Path $This.Registry ) )
        {
            ForEach ( $I in 3..5 )
            { 
                $This.Registry.Split('\')[0..$I] -join '\' | ? { ! ( Test-Path $_ ) } | % { New-Item $_ -Verbose }
            }

            [_Root]::New( $This.Registry, $This.Name, $This.Version, $This.Provider, $This.Path )
        }

        $This.Properties         = Get-ItemProperty -Path $This.Registry | Select-Object Name, Version, Provider, Date, Path, Status
        $This.Folders            | % { "{0}\$_" -f $This.Path } | ? { ! ( Test-Path $_ ) } | % { New-Item -Path $_ -ItemType Directory -Verbose }
        $This.Base               = Get-ChildItem -Path $This.Path
        $This.File               = Get-Item -Path ( "{0}\FightingEntropy.psm1" -f $This.Path )
        $This.Manifest           = Get-Item -Path ( "{0}\FightingEntropy.psd1" -f $This.Path )
        $This.Classes            = $This.Base | ? Name -eq Classes   | Get-ChildItem
        $This.Control            = $This.Base | ? Name -eq Control   | Get-ChildItem
        $This.Functions          = $This.Base | ? Name -eq Functions | Get-ChildItem 
        $This.Graphics           = $This.Base | ? Name -eq Graphics  | Get-ChildItem
    }
    
    LoadClassLib()
    {
        $This.Classes | Get-ChildItem | ? Name -match __index.txt | Get-Content | % { Import-Module -Path "{0}\Classes\{1}.ps1" -f $This.Path, $_ }
    }
    
    LoadFunctionLib()
    {
        $This.Functions | Get-ChildItem | ? Name -match __index.txt | Get-Content | % { Import-Module -Path "{0}\Functions\{1}.ps1" -f $This.Path, $_ }
    }
    
    LoadNetwork()
    {
        
    }
}
