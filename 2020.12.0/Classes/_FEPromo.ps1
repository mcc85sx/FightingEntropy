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

    [String]                             $Command
    [Int32]                                 $Mode
    [String]                                $Slot
    [String]                          $DomainType
    [String]                          $ForestMode
    [String]                          $DomainMode
    [String]                    $ParentDomainName

    [Object]                          $InstallDNS
    [Object]                 $CreateDNSDelegation
    [Object]                     $NoGlobalCatalog
    [Object]             $CriticalReplicationOnly

    [Object]                        $DatabasePath
    [Object]                             $LogPath
    [Object]                          $SysvolPath
    
    [Object]                          $Credential
    [Object]                          $DomainName
    [Object]                   $DomainNetBIOSName
    [Object]                       $NewDomainName
    [Object]                $NewDomainNetBIOSName
    [Object]                 $ReplicationSourceDC
    [Object]                            $SiteName

    [SecureString] $SafeModeAdministratorPassword
    [String]                             $Profile

    [Object]                              $Output

    SetMode([Int32]$Mode)
    {
        $This.Mode                              = $Mode
        $This.Command                           = ("{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain").Split(" ")[$Mode]
        $This.Slot                              = ("Forest Tree Child Clone" -Split " ")[$Mode]

        $This.IO.Forest.IsChecked               = $False
        $This.IO.Tree.IsChecked                 = $False
        $This.IO.Child.IsChecked                = $False
        $This.IO.Clone.IsChecked                = $False

        $This.IO.$($This.Slot).IsChecked        = $True

        $Tray                                   = @("Visible","Collapsed")[@((0,0,1),(1,0,1),(1,1,0),(1,1,0))[$Mode]]
        $This.IO.ForestModeBox.Visibility       = $Tray[0]
        $This.IO.DomainModeBox.Visibility       = $Tray[1]
        $This.IO.ParentDomainNameBox.Visibility = $Tray[2]
        $This.IO.ParentDomainName.Text          = "<Domain Name>"

        $This.DomainType                        = @("-","TreeDomain","ChildDomain","-")[$Mode]
                
        $Tray                                   = Switch ($Mode)
        {
            0 { $This.IO.ForestMode.SelectedIndex,$This.IO.DomainMode.SelectedIndex,"-" }
            1 { $This.IO.ForestMode.SelectedIndex,"-","-" }
            2 { "-","-","<Domain Name>" }
            3 { "-","-","<Domain Name>" }
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
            $This.Set_FEPromo_Roles($This.$($Item))
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
            $This.Set_FEPromo_Text($This.$($Item))
        }

        If ( !!$This.Connection.Credential )
        {
            $This.IO.Credential.Text            = $This.Connection.Credential.Username
            $This.IO.Credential.IsEnabled       = $False
        }
    }

    Set_FEPromo_Roles([Object]$Obj)
    {
        $This.IO.$( $Obj.Name ).IsEnabled       = $Obj.IsEnabled
        $This.IO.$( $Obj.Name ).IsChecked       = $Obj.IsChecked
    }

    Set_FEPromo_Text([Object]$Obj)
    {
        $This.IO."$( $Obj.Name    )".IsEnabled  = $Obj.IsEnabled
        $This.IO."$( $Obj.Name )Box".Visibility = @("Collapsed","Visible")[$Obj.IsEnabled]
        $This.IO."$( $Obj.Name    )".Text       = ""
    }

    Get_FEPromo_Domain_Controllers()
    {
        $This.Connection   = @{ 

            Primary        = $This.HostMap | ? { $_.NBT.ID -match "1b" }
            Secondary      = $This.HostMap | ? { $_.NBT.ID -match "1c" }
            Output         = @( )
            Target         = @( )
            Credential     = $Null
        }

        $This.Connection   | % { 

            $_.Primary     | % { 

                $_.NetBIOS = $_.NBT | ? ID -eq 1b | % Name
            }

            $_.Secondary   | % { 
                
                $_.NetBIOS = $_.NBT | ? ID -eq 1c | % Name 
            }

            $_.Output      = $_.Primary, $_.Secondary | Select -Unique
            $_.Output      = $_.Output | Select-Object IPAddress, Hostname, NetBIOS
        }
    }

    _FEPromo([Object]$Window,[Int32]$Mode)
    {
        $This.Window                            = $Window
        $This.IO                                = $Window.Host
        $This.Host                              = Get-FEModule | % Role | % Host
        $This.Host._Network()
        $This.Network                           = $This.Host.Network
        $HostRange                              = $This.Host.Network.Interface.IPV4 | ? Gateway | % Range

        $This.Range                             = [_PingSweep]::New($HostRange -Split "`n")
        $This.HostMap                           = $This.Range._Filter() 
        
        ForEach ( $IHost in $This.Hostmap ) 
        { 
            Write-Host "[+] $($IHost.HostName)/$($IHost.IPAddress)"
            $IHost.NBT                          = nbtstat -a $IHost.IPAddress | ? { $_ -match "Registered" } | % { [_NbtHost]::New($This.Network.NBT,$_) }
        }

        $This.Get_FEPromo_Domain_Controllers()

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
