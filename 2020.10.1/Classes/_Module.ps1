Class _Module
{
    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.10.1"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Path = $Env:ProgramData
    [String]                $URL = "https://github.com/mcc85sx/FightingEntropy/blob/master/2020.10.1"
    [String]           $Registry = "HKLM:\SOFTWARE\Policies"
    [Object]         $Properties
    [Object]               $Base

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
        $This.Base               = Get-ChildItem $This.Path
    }
}
