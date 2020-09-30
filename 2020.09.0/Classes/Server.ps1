Class FEServerFeature
{
    [String] $Name
    [String] $DisplayName
    [Int32]  $Installed

    FEServerFeature([String]$Name,[String]$DisplayName,[Int32]$Installed)
    {
        $This.Name           = $Name
        $This.DisplayName    = $Displayname
        $This.Installed      = $Installed
    }
}
    
Class FEServerFeatureList
{
    [Object[]]      $Feature

    FEServerFeatureList() 
    { 
        $This.Feature        =  ( Get-WindowsFeature | ? Name -in ("AD-Domain-Services DHCP DNS GPMC RSAT RSAT-AD-AdminCe" + 
                                "nter RSAT-AD-PowerShell RSAT-AD-Tools RSAT-ADDS RSAT-ADDS-Tools RSAT-DHCP RSAT-DNS-Se" + 
                                "rver RSAT-Role-Tools WDS WDS-AdminPack WDS-Deployment WDS-Transport").Split(" ") | % { 
                                [FEServerFeature]::New($_.Name,$_.DisplayName,$_.Installed) } )
    }
}

Class FEServerDependency
{
    Hidden [Hashtable] $MDT   = @{ 
    
        Name                  = "MDT"
        DisplayName           = "Microsoft Deployment Toolkit"
        Version               = "6.3.8450.0000"
        Resource              = "https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x{0}.msi"
        Path                  = "{0}\Tools\MDT"
        File                  = "MicrosoftDeploymentToolkit_x{0}.msi"
        Arguments             = "/quiet /norestart"
    }
    
    Hidden [Hashtable] $WinADK = @{ 
    
        Name                   = "WinADK"
        DisplayName            = "Windows Assessment and Deployment Kit"
        Version                = "10.1.17763.1"
        Resource               = "https://go.microsoft.com/fwlink/?linkid=2086042"
        Path                   = "{0}\Tools\WinADK"
        File                   = "winadk1903.exe"
        Arguments              = "/quiet /norestart /log `$env:temp\win_adk.log /features +"
    }

    Hidden [Hashtable] $WinPE  = @{

        Name                   = "WinPE"
        DisplayName            = "Windows ADK Preinstallation Environment"
        Version                = "10.1.17763.1"
        Resource               = "https://go.microsoft.com/fwlink/?linkid=2087112"
        Path                   = "{0}\Tools\WinPE"
        File                   = "winpe1903.exe"
        Arguments              = "/quiet /norestart /log `$env:temp\win_adk.log /features +"
    }
    
    [String] $Name
    [String] $DisplayName
    [String] $Version
    [String] $Resource
    [String] $Path
    [String] $File
    [String] $Arguments

    FEServerDependency([String]$Name,[String]$DisplayName,[String]$Version,[String]$Resource,[String]$Path,[String]$File,[String]$Arguments)
    {
        $This.Name        = $Name
        $This.DisplayName = $DisplayName
        $This.Version     = $Version
        $This.Resource    = $Resource
        $This.Path        = $Path
        $This.File        = $File
        $This.Arguments   = $Arguments
    }
}
