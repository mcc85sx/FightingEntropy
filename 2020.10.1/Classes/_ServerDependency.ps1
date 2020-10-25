Class _ServerDependency
{
    [Object]         $Registry = @( "" , "\WOW6432Node" | % { "HKLM:\SOFTWARE$_\Microsoft\Windows\CurrentVersion\Uninstall\*"  } )
    [Object]             $Root = (Get-FEModule).Path
    [Object[]]       $Packages = @(@{
        
        Name                   = "MDT"
        DisplayName            = "Microsoft Deployment Toolkit"
        Version                = "6.3.8450.0000"
        Resource               = "https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x{0}.msi" -f $Env:Processor_Architecture
        Path                   = "{0}\Tools\MDT"
        File                   = "MicrosoftDeploymentToolkit_x{0}.msi" -f $Env:Processor_Architecture
        Arguments              = "/quiet /norestart"
    
    };@{  

        Name                   = "WinADK"
        DisplayName            = "Windows Assessment and Deployment Kit"
        Version                = "10.1.17763.1"
        Resource               = "https://go.microsoft.com/fwlink/?linkid=2086042"
        Path                   = "{0}\Tools\WinADK"
        File                   = "winadk1903.exe"
        Arguments              = "/quiet /norestart /log `$env:temp\win_adk.log /features +" 
        
    };@{  
        
        Name                   = "WinPE"
        DisplayName            = "Windows Preinstallation Environment"
        Version                = "10.1.17763.1"
        Resource               = "https://go.microsoft.com/fwlink/?linkid=2087112"
        Path                   = "{0}\Tools\WinPE"
        File                   = "winpe1903.exe"
        Arguments              = "/quiet /norestart /log `$env:temp\win_adk.log /features +" 
    })
    
    [String[]] $Name
    [String[]] $DisplayName
    [String[]] $Version
    [String[]] $Resource
    [String[]] $Path
    [String[]] $File
    [String[]] $Arguments

    _ServerDependency()
    { 
        If ( ! ( Test-Path "$($This.Root)\Tools" ) ) 
        { 
            New-Item "$($This.Root)\Tools" -ItemType Directory -Verbose 
        }

        $DisplayNames          = Get-ItemProperty $This.Registry

        ForEach ( $I in 0..2 ) 
        {
            $Item              = $DisplayNames | ? { $_.DisplayName -match $This.Packages[$I].DisplayName }

            If ( $Item -eq $Null -or $Item.DisplayVersion -lt $This.Packages[$I].Version )
            {
                Write-Host ( "Installing {0}" -f $This.Packages[$I].DisplayName )

                $This.Name        = $This.Packages[$I].Name
                $This.DisplayName = $This.Packages[$I].DisplayName
                $This.Version     = $This.Packages[$I].Version
                $This.Resource    = $This.Packages[$I].Resource
                $This.Path        = $This.Packages[$I].Path -f $This.Root
                $This.File        = $This.Packages[$I].File
                $This.Arguments   = $This.Packages[$I].Arguments

                $Process          = Start-Process -FilePath $This.Path -ArgumentList $This.Arguments -WorkingDirectory $This.Path -PassThru

                For ( $X = 0; $X -le 100; $X++ )
                {
                    Write-Progress -Activity "[Installing] @: $($This.Name)" -PercentComplete $X -Status "$X% Complete"
                    Sleep -M 250

                    If ( $Process.HasExited )
                    {
                        Write-Progress -Activity "[Installed] @: $($This.Name)" -Completed
                    }
                }
            }

            Else
            {
                Write-Host ( "{0} is already installed" -f $This.Packages[$I].DisplayName )
            }
        }
    }

    Download()
    {
        [Net.ServicePointManager]::SecurityProtocol = 3072

        Invoke-RestMethod -URI $This.Resource -OutFile ( $This.Path, $This.File -join '\' )
    }
}
