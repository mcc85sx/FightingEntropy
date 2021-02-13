Function New-FEShare
{
    [CmdLetBinding()]
    Param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory)][String]        $Path ,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory)][String]   $ShareName ,
    [Parameter()]         [String] $Description = "[FightingEntropy($([Char]960))]]://Development Share" )

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

        _Share([String]$Path,[String]$Name,[String]$Description)
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
                Write-Host "Drive exists"
                New-PSDrive -Name $This.Name -Verbose
            }
        }
    }

    Import-Module (Get-MDTModule)
    
    $Item   = [_Share]::New($Path,$ShareName,$Description)

    $Item.NewSMBShare()
    $Item.NewPSDrive()
    
    Get-MDTPersistentDrive | % { 

        If ((Get-PSDrive -Name $_.Name -EA 0 -Verbose) -eq $Null )
        {
            New-PSDrive -Name $_.Name -PSProvider MDTProvider -Root $_.Path -Verbose
        }
    }

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
    Export-Ini $Control\Bootstrap.ini @{ 

        Settings           = @{ Priority           = "Default"                      }
        Default            = @{ DeployRoot         = $Item.NetworkPath
                                UserID             = "mcook85@securedigitsplus.com"
                                UserPassword       = "password"
                                UserDomain         = "SECURED"
                                SkipBDDWelcome     = "YES"                          }
    }

    # CustomSettings
    Export-Ini $Control\CustomSettings.ini @{

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
                                EventService       = "http://{0}:9800" -f $Item.Hostname }
    }

    ForEach ( $File in $Module.Control | ? Extension -eq .png )
    {
        Copy-Item -Path $File.Fullname -Destination $Script -Force -Verbose
    }

    ForEach ( $File in $Module.Functions | ? Name -eq Install-FEModule.ps1 )
    {
        Copy-Item -Path $File.Fullname -Destination $Script -Force -Verbose
    }
}
