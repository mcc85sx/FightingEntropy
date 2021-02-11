Function New-FEShare
{
    [CmdLetBinding()]
    Param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory)][String]        $Path ,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory)][String]   $ShareName ,
    [Parameter()]         [String] $Description = "[FightingEntropy]://Development Share" )

    Class _Share
    {
        Hidden [Object] $Shares
        [String]          $Path
        [String]      $Hostname
        [String]          $Name
        [Object]          $Root
        [String]     $ShareName
        [String]   $NetworkPath
        [String]   $Description = $Null
        [String]      $Comments = (Get-Date -UFormat "[%Y-%m%d (MCC/SDP)]")

        _Share([String]$Path,[String]$SMBName,[String]$Description)
        {
            If (!(Test-Path $Path))
            {
                 New-Item -Path $Path -ItemType Directory -Verbose
            }

            $This.Root         = Get-Item -Path $Path
        
            If ($This.Root)
            {
                $This.Path     = $Path
            }

            $This.Description  = $Description
         
            Import-Module (Get-MDTModule)

            $This.Shares       = Get-MDTPersistentDrive

            $This.Hostname     = Resolve-DNSName ([Environment]::MachineName) | % Name | Select-Object -Unique
            $This.ShareName    = "{0}$" -f $SMBName.TrimEnd("$")

            $This.Name         = $This.GetLabel()
            $This.NetworkPath  = "\\{0}\{1}" -f $This.HostName, $This.ShareName
        }

        [String] GetLabel()
        {                
            Return @( If ($This.Shares)
            {
                $This.Shares | % Name | % { @($_,$_[-1])[[Int32]($_.Count -gt 1)].Replace("DS","") } | % { "FE{0:d3}" -f ( [Int32]$_ + 1 ) }
            }

            Else
            {
                "FE001"
            })
        }

        [Object] CheckPath()
        {
            Return @( If ( $This.Root -in $This.Shares.Path )
            {
                $This.Shares | ? Path -eq $This.Root    
            }

            ElseIf ( $This.Name -in $This.Shares.Name )
            { 
                $This.Shares | ? Name -eq $This.Name
            })
        }

        NewSMB()
        {
            If ( $This.ShareName -notin ( Get-SMBShare | % Name ) )
            {
                Write-Host "New-SMBShare $($This.ShareName)"

                @{ 
                    Name        = $This.ShareName
                    Path        = $This.Root
                    Description = $This.Description 
                   
                }               | % { New-SMBShare @_ -FullAccess Administrators -Verbose }
            }
        }

        NewPSD()
        {
            If ( $This.Name -notin ( Get-PSDrive | % Name ) )
            {
                Write-Host "New-PSDrive $($This.Name)"

                @{  
                    Name           = $This.Name
                    PSProvider     = "MDTProvider"
                    Root           = $This.Root
                    Description    = $This.Description
                    NetworkPath    = $This.NetworkPath 

                }                  | % { New-PSDrive @_ | Add-MDTPersistentDrive -Verbose }
            }

            Else
            {
                Write-Host "Drive exists"
                New-PSDrive -Name $This.Name -Verbose
            }
        }
    }

    Import-Module (Get-MDTModule)

    $Item   = [_Share]::New($Path,$ShareName,$Description)
    $Item.NewSMB()
    $Item.NewPSD()

    # Load Module / Share Drive Mount
    $Module                = Get-FEModule
    $Root                  = "$($Item.Label):\"
    $Control               = "$($Item.Path)\Control"
    $Script                = "$($Item.Path)\Scripts"

    # Share Settings
    Set-ItemProperty $Root -Name Comments    -Value $("[FightingEntropy({0})]{1}" -f [Char]960,(Get-Date -UFormat "[%Y-%m%d (MCC/SDP)]") ) -Verbose
    Set-ItemProperty $Root -Name MonitorHost -Value $Item.HostName -Verbose

    # Image Names/Background
    $Names  = 64 , 86 | % { "Boot.x$_" } | % { "$_.Generate{0}ISO $_.{0}WIMDescription $_.{0}ISOName $_.BackgroundFile" -f "LiteTouch" -Split " " }
    $Values = 64 , 86 | % { "$($Module.Name)(x$_)" } | % { "True;$_;$_.iso;$($Module.Graphics | ? Name -match OEMbg.jpg)" -Split ";" }

    ForEach ( $X in 0..($Names.Count - 1 ) )
    {
        If ( ( Get-ItemProperty -Path $Root | % $Names[$X] ) -ne $Values[$X] )
        {
            Set-ItemProperty -Path $Root -Name $Names[$X] -Value $Values[$X] -Verbose
        }
    }

    # Service
    If (!(Get-CimInstance Win32_Service | ? Name -eq MDT_Monitor))
    {
        Enable-MDTMonitorService -EventPort 9800 -DataPort 9801 -Verbose
    }

    # Bootstrap
    $Bootstrap             = @{ 
        Settings           = @{ Priority           = "Default"                      }
        Default            = @{ DeployRoot         = $This.Share.NetworkPath
                                UserID             = "mcook85@securedigitsplus.com"
                                UserPassword       = "password"
                                UserDomain         = "SECURED"
                                SkipBDDWelcome     = "YES"                          }
    }
    Export-Ini -Path $Control\Bootstrap.ini -Value $BootStrap | Out-Null

    # CustomSettings
    $CustomSettings        = @{ 
        Settings           = @{ Priority           = "Default" 
                                Properties         = "MyCustomProperty" } 
        Default            = @{ _SMSTSOrgName      = "Secure Digits Plus LLC"
                                OSInstall          = "Y" 
                                SkipCapture        = "NO" 
                                SkipAdminPassword  = "YES" 
                                SkipProductKey     = "YES" 
                                SkipComputerBackup = "NO" 
                                SkipBitLocker      = "YES" 
                                KeyboardLocale     = "en-US" 
                                TimeZoneName       = Get-TimeZone | % ID
                                EventService       = "http://{0}:9800" -f $This.Share.Hostname }
    }

    Export-Ini -Path $Control\CustomSettings.ini -Value $CustomSettings | Out-Null

    ForEach ( $File in $Module.Control | ? Extension -eq ".png" )
    {
        If ( (Get-Item "$Scripts\$($File.Name)" | % Length ) -ne $File.Length )
        {
            Copy-Item -Path $File.Fullname -Destination $Scripts -Force -Verbose
        }
    }
}
