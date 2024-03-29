Function New-FEShare
{
    [CmdLetBinding()]
    Param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory)][String]             $Path ,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory)][String]        $ShareName ,
    [Parameter()]         [String]      $Description = "[FightingEntropy($([Char]960))]:\\Development Share",
    [Parameter(Mandatory)][PSCredential] $Credential ,
    [Parameter(Mandatory)][Object]              $Key )

    Class _Share
    {
        Hidden [Object] $Shares
        [String]          $Path
        [String]      $Hostname
        [String]         $Label
        [String]          $Name
        [Object]          $Root
        [String]     $ShareName
        [String]   $NetworkPath
        [String]   $Description
        [String]      $Comments = "$(Get-Date -UFormat "[%Y-%m%d(MCC/SDP)]")"
        [Object]           $Key

        _Share([String]$Path,[String]$Name,[String]$Description,[Object]$Key)
        {
            $This.Key         = $Key

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
            $This.Label        = If ($This.Shares) { "FE{0:d3}" -f ($This.Shares.Count + 1) } Else { "FE001" }
            $This.Hostname     = Resolve-DNSName ([Environment]::MachineName) | % Name | Select-Object -Unique
            $This.ShareName    = "{0}$" -f $Name.TrimEnd("$")
            $This.NetworkPath  = "\\{0}\{1}" -f $This.HostName, $This.ShareName
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

        NewSMBShare()
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

        NewPSDrive()
        {
            If ( $This.Name -notin ( Get-PSDrive | % Name ) )
            {
                Write-Host "New-PSDrive $($This.Name)"
                @{  
                    Name           = $This.Label
                    PSProvider     = "MDTProvider"
                    Root           = $This.Root
                    Description    = $This.Description
                    NetworkPath    = $This.NetworkPath 
                }                  | % { New-PSDrive @_ | Add-MDTPersistentDrive -Verbose }
            }

            Else
            {
                Throw "Drive exists"
            }
        }
    }

    Import-Module (Get-MDTModule)
    $Share   = [_Share]::New($Path,$ShareName,$Description,$Key)
    $Share.NewSMBShare()
    $Share.NewPSDrive()
    
    Get-MDTPersistentDrive | % { 

        If ((Get-PSDrive -Name $_.Name -EA 0 -Verbose) -eq $Null )
        {
            New-PSDrive -Name $_.Name -PSProvider MDTProvider -Root $_.Path -Verbose
        }
    }

    # Load Module / Share Drive Mount
    $Module                = Get-FEModule
    $Root                  = "$($Share.Label):\"
    $Control               = "$($Share.Path)\Control"
    $Script                = "$($Share.Path)\Scripts"

    ForEach ($File in $Key.Background, $Key.Logo)
    {
        $Name = $File | Split-Path -Leaf
        $Item = "$Script\$Name"

        If (!(Test-Path $Item))
        {
            Copy-Item -Path $File -Destination $Script -Verbose
        }

        If ($File -notlike $Key.NetworkPath)
        {
            $Item = ("{0}\Scripts\$Name" -f $Key.NetworkPath)
        }

        Switch ($File)
        {
            $Key.Logo       { $Key.Logo       = $Item }
            $Key.Background { $Key.Background = $Item }
        }
    }

    $Install = @( ) 
    $Install += "[Net.ServicePointManager]::SecurityProtocol = 3072"
    $Install += (Invoke-RestMethod https://github.com/mcc85sx/FightingEntropy/blob/master/Install.ps1?raw=true)
    $Install += "`$Key = '$($Key | ConvertTo-Json)'`n"
    $Install += "`New-EnvironmentKey -Key `$Key | % Apply `n"

    Set-Content -Path $Script\Install.ps1 -Value $Install -Force -Verbose

    # Share Settings
    Set-ItemProperty $Root -Name Comments    -Value $("[FightingEntropy({0})]{1}" -f [Char]960,(Get-Date -UFormat "[%Y-%m%d (MCC/SDP)]") ) -Verbose
    Set-ItemProperty $Root -Name MonitorHost -Value $Share.HostName -Verbose

    # Image Names/Background
    $Names  = 64 , 86 | % { "Boot.x$_" } | % { "$_.Generate{0}ISO $_.{0}WIMDescription $_.{0}ISOName $_.BackgroundFile" -f "LiteTouch" -Split " " }
    $Values = 64 , 86 | % { "$($Module.Name)(x$_)" } | % { "True;$_;$_.iso;$($Key.Background)" -Split ";" }

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
    Export-Ini -Path $Control\Bootstrap.ini -Value @{ 

        Settings           = @{ Priority             = "Default"                      }
        Default            = @{ DeployRoot           = $Key.NetworkPath
                                UserID               = $Credential.Username
                                UserPassword         = $Credential.GetNetworkCredential().Password
                                UserDomain           = $Key.CommonName
                                SkipBDDWelcome       = "YES"                          }
    }

    # CustomSettings
    Export-Ini -Path $Control\CustomSettings.ini -Value @{

        Settings           = @{ Priority             = "Default" 
                                Properties           = "MyCustomProperty" }
        Default            = @{ _SMSTSOrgName        = $Key.Organization
                                JoinDomain           = $Key.CommonName
                                DomainAdmin          = $Credential.Username
                                DomainAdminPassword  = $Credential.GetNetworkCredential().Password
                                DomainAdminDomain    = $Key.CommonName
                                MachineObjectOU      = "OU=Computers,DC=$($Key.CommonName.Split(".") -join ',DC=')"
                                SkipDomainMembership = "YES"
                                OSInstall            = "Y"
                                SkipCapture          = "NO"
                                SkipAdminPassword    = "YES" 
                                SkipProductKey       = "YES" 
                                SkipComputerBackup   = "NO" 
                                SkipBitLocker        = "YES" 
                                KeyboardLocale       = "en-US" 
                                TimeZoneName         = Get-TimeZone | % ID
                                EventService         = "http://{0}:9800" -f $Key.NetworkPath.Split("\")[2] }
    }

    ForEach ( $File in $Module.Control | ? Extension -eq .png )
    {
        Copy-Item -Path $File.Fullname -Destination $Script -Force -Verbose
    }

    ForEach ( $File in $Module.Control | ? Name -match Mod.xml )
    {
        Copy-Item -Path $File.FullName -Destination "$env:ProgramFiles\Microsoft Deployment Toolkit\Templates" -Force -Verbose
    }
}
