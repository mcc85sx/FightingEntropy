
Function Set-Branding
{
    [CmdLetBinding()] 
    Param (
    [Parameter()][String] $Background = $Null,
    [Parameter()][String]       $Logo = $Null)

    Get-FEModule -Graphics            | % { 
    
        $Path                         = $_

        Switch ( Split-Path $Path -Leaf ) 
        {
            OEMbg.jpg   
            {
                If ( !$Background )
                {
                    $Background = $Path
                }
            } 
            
            OEMlogo.bmp 
            { 
                If ( !$Logo )
                {
                    $Logo       = $Path
                }
            }
        }
    }

    Class _Brand
    {
        [String] $Path
        [String] $Name
        [Object] $Value

        _Brand([String]$Path,[String]$Name,[Object]$Value)
        {
            $This.Path  = $Path
            $This.Name  = $Name
            $This.Value = $Value
        }
    }
    
    Class _Branding
    {
        [String[]]        $Names = ("{0};{0}Style;Logo;Manufacturer;{1}Phone;{1}Hours;{1}URL;LockScreenImage;OEMBackground") -f "Wallpaper","Support" -Split ";"
        [Object]          $Items
        [Object]         $Values

        [Object]         $Output
        [Object]    $Certificate

        [String]       $Provider
        [String]       $SiteLink
        [String]     $Background
        [String]           $Logo
        [String]          $Phone
        [String]        $Website
        [String]          $Hours
            
        [String[]]     $FilePath = ("{0}\{1};{0}\{1}\{2};{0}\{1}\{2}\Backgrounds;{0}\Web\Screen;{0}\Web\Wallpaper\Windows;C:\ProgramData\Microsoft\" + 
                                    "User Account Pictures") -f "C:\Windows" , "System32" , "OOBE\Info" -Split ";"

        [String[]] $RegistryPath = @(("HKCU:\{0}\{1}\Policies\System;HKLM:\{0}\{1}\OEMInformation;HKLM:\{0}\{1}\Authentication\LogonUI\Background;" +
                                      "HKLM:\{0}\Policies\Microsoft\Windows\Personalization") -f "Software","Microsoft\Windows\CurrentVersion" -Split ";")

        _Branding([String]$Background,[String]$Logo)
        {
            If ( ! ( Test-Path -Path $Background ) )
            {
                Throw "Invalid Path"
            }

            $This.Background     = Get-Item $Background | % FullName

            If ( ! ( Test-Path -Path $Logo ) )
            {
                Throw "Invalid Path"
            }

            $This.Logo           = Get-Item $Logo | % FullName

            ForEach ( $Path in $This.FilePath )
            {
                If ( ! ( Test-Path $Path ) )
                {
                    New-Item $Path -ItemType Directory -Verbose 
                }
            }

            ForEach ( $I in 0..5 )
            {
                Copy-Item -Path @($This.Logo,$This.Background)[0,0,0,1,1,1][$I] -Destination $This.FilePath[$I] -Verbose -Force
            }

            ForEach ( $Path in $This.RegistryPath )
            {
                If ( ! ( Test-Path $Path ) )
                {
                    New-Item -Path ( $Path | Split-Path ) -Name ( $Path | Split-Path -Leaf ) -Verbose
                }
            }
            
            $This.Items           = $This.RegistryPath[0,0,1,1,1,1,1,3,2]
            $This.Values          = @($This.Background,2,$This.Logo,$This.Provider,$This.Phone,$This.Hours,$This.Website,$This.Background,1)
            $This.Output          = @( )

            ForEach ( $I in 0..8 ) 
            {
                $This.Output     += [_Brand]::New($This.Items[$I],$This.Names[$I],$This.Values[$I])

                $This.Output[$I]  | % { Set-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -Verbose }
            }
        }
    }

    [_Branding]::New($Background,$Logo)
}
