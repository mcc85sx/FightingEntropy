Class _FEDCPromo
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
    [Object]                             $Profile

    [Object]                          $ForestMode
    [Object]                          $DomainMode
    [Object]                          $DomainType
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
    [Object]       $SafeModeAdministratorPassword
    [Object]                          $Credential

    [Object]                              $Output

    SetMode([Int32]$Mode)
    {
        $This.Command                            = ("{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain").Split(" ")[$Mode]
        $This.Mode                               = $Mode
        $This.Profile                            = (Get-FEDCPromoProfile -Mode $Mode)

        $This.IO.Forest.IsChecked                = $False
        $This.IO.Tree.IsChecked                  = $False
        $This.IO.Child.IsChecked                 = $False
        $This.IO.Clone.IsChecked                 = $False

        $This.IO.$($This.Profile.Slot).IsChecked = $True

        ForEach ( $Item in $This.Profile.Type )
        {
            If ( $Item.Name -ne "DomainType" )
            {
                $This.IO."_$($Item.Name)".Visibility = @("Collapsed","Visible")[$Item.IsEnabled]
            }

            If (!$Item.IsEnabled)
            {
                $Item.Value = ""
            }

            Else
            {
                $Item.Value = Switch($Item.Name)
                {
                    ForestMode          { $This.IO.ForestMode.SelectedIndex  }
                    DomainMode          { $This.IO.DomainMode.SelectedIndex  }
                    DomainType          {     $This.Profile.Slot + "Domain"  }
                    ParentDomainName    {                         "<Domain>" }
                    ReplicationSourceDC {                            "<Any>" }
                }
            }
        }

        # Domain/Text
        $This.ParentDomainName                    = $This.Profile.Text.ParentDomainName
        $This.Credential                          = $This.Profile.Text.Credential
        $This.DomainName                          = $This.Profile.Text.DomainName
        $This.DomainNetBIOSName                   = $This.Profile.Text.DomainNetBIOSName
        $This.NewDomainName                       = $This.Profile.Text.NewDomainName
        $This.NewDomainNetBIOSName                = $This.Profile.Text.NewDomainNetBIOSName
        $This.SiteName                            = $This.Profile.Text.Sitename

        # Roles
        $This.InstallDNS                          = $This.Profile.Role.InstallDNS
        $This.CreateDNSDelegation                 = $This.Profile.Role.CreateDNSDelegation
        $This.NoGlobalCatalog                     = $This.Profile.Role.NoGlobalCatalog
        $This.CriticalReplicationOnly             = $This.Profile.Role.CriticalReplicationOnly

        If ( !!$This.Connection.Credential )
        {
            $This.IO.Credential.Text            = $This.Connection.Credential.Username
            $This.IO.Credential.IsEnabled       = $False
        }

        $This.Output                            = @( )
    }

    [Void] SetFEDCPromoRole([Object]$Obj)
    {
        $This.IO.$($Obj.Name).IsEnabled         = $Obj.IsEnabled
        $This.IO.$($Obj.Name).IsChecked         = $Obj.IsChecked
    }

    [Void] SetFEDCPromoText([Object]$Obj)
    {
        $This.IO."$($Obj.Name)".IsEnabled       = $Obj.IsEnabled
        $This.IO."_$($Obj.Name)".Visibility     = @("Collapsed","Visible")[$Obj.IsEnabled]
        $This.IO."$($Obj.Name)".Text            = $Obj.Text
    }

    Get_ADConnection()
    {
        $This.Connection                        = [_ADConnection]::New($This.HostMap)
    }

    HostRange()
    {
        $This.Range = [_PingSweep]::New(($This.Host.Network.Interface.IPV4 | ? Gateway | % Range | Select -Unique | % Split `n))
    }

    _FEDCPromo([Object]$Window,[Int32]$Mode)
    {
        $This.Window                            = $Window
        $This.IO                                = $Window.IO
        $This.Host                              = Get-FEModule | % Role | % Host
        $This.Host._Network()
        $This.Network                           = $This.Host.Network
        $This.HostRange()
        $This.HostMap                           = $This.Range._Filter()

        $This.Features                          = [_ServerFeatures]::New().Output
                
        #ForEach ( $Feature in $This.Features ) 
        #{
        #    $This.IO.$($Feature.Name).IsEnabled = !$Feature.Installed
        #    $This.IO.$($Feature.Name).IsChecked = "True"
        #}

        $This.DatabasePath                      = "$Env:SystemRoot\NTDS"
        $This.IO.DatabasePath.Text              = $This.DatabasePath

        $This.LogPath                           = "$Env:SystemRoot\NTDS"
        $This.IO.LogPath.Text                   = $This.LogPath 

        $This.SysvolPath                        = "$Env:SystemRoot\SYSVOL"
        $This.IO.SysvolPath.Text                = $This.SysvolPath

        $This.SetMode($Mode)
    }
}
