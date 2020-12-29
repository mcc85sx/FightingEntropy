Class _FEPromo
{
    [Object]                              $Window
    [Object]                                  $IO
    [Object]                                $Host
    [Object]                             $Network
    [Object]                               $Range
    [Object]                             $HostMap
    [Object]                          $Connection
    [Object]                            $Features

    [Int32]                                 $Mode
    [Object]                             $Profile
    [String]                             $Command
    [String]                          $ForestMode
    [String]                          $DomainMode
    [String]                          $DomainType

    [Object]                          $InstallDNS
    [Object]                 $CreateDNSDelegation
    [Object]                     $NoGlobalCatalog
    [Object]             $CriticalReplicationOnly

    [Object]                    $ParentDomainName
    [Object]                          $DomainName
    [Object]                   $DomainNetBIOSName
    [Object]                       $NewDomainName
    [Object]                $NewDomainNetBIOSName
    [Object]                 $ReplicationSourceDC
    [Object]                            $SiteName

    [Object]                        $DatabasePath
    [Object]                             $LogPath
    [Object]                          $SysvolPath

    [SecureString] $SafeModeAdministratorPassword
    [Object]                          $Credential

    [Object]                              $Output

    SetMode([Int32]$Mode)
    {
        $This.Mode                               = $Mode
        $This.Profile                            = [_FEDCPromoProfile]::New($Mode)
        $This.Command                            = ("{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain").Split(" ")[$Mode]

        $This.IO.Forest.IsChecked                = $False
        $This.IO.Tree.IsChecked                  = $False
        $This.IO.Child.IsChecked                 = $False
        $This.IO.Clone.IsChecked                 = $False

        $This.IO.$($This.Profile.Slot).IsChecked = $True

        $Tray                                    = @("Visible","Collapsed")[@((0,0,1),(1,0,0),(1,1,0),(1,1,1))[$Mode]]
        $This.IO.ForestModeBox.Visibility        = $Tray[0]
        $This.IO.DomainModeBox.Visibility        = $Tray[1]
        $This.IO.ParentDomainNameBox.Visibility  = $Tray[2]
        $This.IO.ParentDomainName.Text           = "<Domain Name>"

        $This.DomainType                         = @($Null,"TreeDomain","ChildDomain",$Null)[$Mode]
                
        $Tray                                   = Switch ($Mode)
        {
            0 { $This.IO.ForestMode.SelectedIndex,$This.IO.DomainMode.SelectedIndex,$Null }
            1 { $This.IO.ForestMode.SelectedIndex,$Null,$Null }
            2 { $Null,$Null,"<Domain Name>" }
            3 { $Null,$Null,$Null }
        }
                
        $This.ForestMode                        = $Tray[0]
        $This.DomainMode                        = $Tray[1]
        $This.ParentDomainName                  = $Tray[2]

        # Roles
        $This.InstallDNS                        = [_FEPromoRoles]::New(              "InstallDNS", (1,1,1,1)[$Mode], (1,1,1,1)[$Mode])
        $This.CreateDNSDelegation               = [_FEPromoRoles]::New(     "CreateDNSDelegation", (1,1,1,1)[$Mode], (0,0,1,0)[$Mode])
        $This.NoGlobalCatalog                   = [_FEPromoRoles]::New(         "NoGlobalCatalog", (0,1,1,1)[$Mode], (0,0,0,0)[$Mode])
        $This.CriticalReplicationOnly           = [_FEPromoRoles]::New( "CriticalReplicationOnly", (0,0,0,1)[$Mode], (0,0,0,0)[$Mode])

        ForEach ( $Item in "InstallDNS CreateDNSDelegation NoGlobalCatalog CriticalReplicationOnly".Split(" ") )
        {
            $This.Set_FEPromoRoles($This.$($Item))
        }

        # Domain/Text
        $This.Credential                        = [_FEPromoDomain]::New(             "Credential", (0,1,1,1)[$Mode])
        $This.DomainName                        = [_FEPromoDomain]::New(             "DomainName", (1,0,0,1)[$Mode])
        $This.DomainNetBIOSName                 = [_FEPromoDomain]::New(      "DomainNetBIOSName", (1,0,0,0)[$Mode])
        $This.NewDomainName                     = [_FEPromoDomain]::New(          "NewDomainName", (0,1,1,0)[$Mode])
        $This.NewDomainNetBIOSName              = [_FEPromoDomain]::New(   "NewDomainNetBIOSName", (0,1,1,0)[$Mode])
        $This.ReplicationSourceDC               = [_FEPromoDomain]::New(    "ReplicationSourceDC", (0,0,0,1)[$Mode])
        $This.SiteName                          = [_FEPromoDomain]::New(               "SiteName", (0,1,1,1)[$Mode])

        ForEach ( $Item in "Credential DomainName DomainNetBIOSName NewDomainName NewDomainNetBIOSName ReplicationSourceDC SiteName".Split(" ") )
        {    
            $This.Set_FEPromoDomain($This.$($Item))
        }

        If ( !!$This.Connection.Credential )
        {
            $This.IO.Credential.Text            = $This.Connection.Credential.Username
            $This.IO.Credential.IsEnabled       = $False
            $This.IO
        }

        $This.Output                            = @( )
    }

    Set_FEPromoRoles([Object]$Obj)
    {
        $This.IO.$( $Obj.Name ).IsEnabled       = $Obj.IsEnabled
        $This.IO.$( $Obj.Name ).IsChecked       = $Obj.IsChecked
    }

    Set_FEPromoDomain([Object]$Obj)
    {
        $This.IO."$( $Obj.Name    )".IsEnabled  = $Obj.IsEnabled
        $This.IO."$( $Obj.Name )Box".Visibility = @("Collapsed","Visible")[$Obj.IsEnabled]
        $This.IO."$( $Obj.Name    )".Text       = ""
    }

    Get_ADConnection()
    {
        $This.Connection                        = [_ADConnection]::New($This.HostMap)
    }

    HostRange()
    {
        $This.Range = [_PingSweep]::New(($This.Host.Network.Interface.IPV4 | ? Gateway | % Range | Select -Unique | % Split `n))
    }

    _FEPromo([Object]$Window,[Int32]$Mode)
    {
        $This.Window                            = $Window
        $This.IO                                = $Window.IO
        $This.Host                              = Get-FEModule | % Role | % Host
        $This.Host._Network()
        $This.Network                           = $This.Host.Network
        $This.HostRange()
        $This.HostMap                           = $This.Range._Filter()
        
        ForEach ( $IHost in $This.Hostmap ) 
        { 
            Write-Host "[+] $($IHost.HostName)/$($IHost.IPAddress)"
            $IHost.NBT                          = nbtstat -a $IHost.IPAddress | ? { $_ -match "Registered" } | % { [_NbtHost]::New($This.Network.NBT,$_) }
        }

        $This.Get_ADConnection()

        $This.Features                          = [_ServerFeatures]::New().Output
                
        ForEach ( $Feature in $This.Features ) 
        {
            $This.IO.$($Feature.Name).IsEnabled = !$Feature.Installed
            $This.IO.$($Feature.Name).IsChecked = "True"
        }

        $This.DatabasePath                      = "$Env:SystemRoot\NTDS"
        $This.IO.DatabasePath.Text              = $This.DatabasePath

        $This.LogPath                           = "$Env:SystemRoot\NTDS"
        $This.IO.LogPath.Text                   = $This.LogPath 

        $This.SysvolPath                        = "$Env:SystemRoot\SYSVOL"
        $This.IO.SysvolPath.Text                = $This.SysvolPath

        $This.SetMode($Mode)
    }
}
