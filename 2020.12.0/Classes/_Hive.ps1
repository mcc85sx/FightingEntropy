Class _Hive
{
    [String]        $Type
    [String]     $Version
    Hidden [String] $Name = "{0}\Secure Digits Plus LLC\FightingEntropy\{1}"
    [String[]]  $PSModule
    [String]        $Root
    [Object]        $Path

    [String[]] PSModule_()
    {
        Return @( Get-Item Env:\ | % GetEnumerator | ? Name -eq PSModulePath | % Value | % Split @{  
        
            Win32_Client =                       ";" ; 
            Win32_Server =                       ";" ; 
            RHELCentOS   =                       ":" ; 
            UnixBSD      =                       ":" ;
            
        }[$This.Type])
    }

    [String] Root_()
    {
        Return ($This.Name -f @{
        
            Win32_Client = "HKLM:\Software\Policies" ; 
            Win32_Server = "HKLM:\Software\Policies" ;
            RHELCentOS   =            "/etc/Maestro" ; 
            UnixBSD      =            "/etc/Maestro" ;
            
        }[$This.Type],$This.Version)
    }

    [String] Path_()
    {
        Return ($This.Name -f @{  
        
            Win32_Client = Get-Item Env:\ProgramData | % Value
            Win32_Server = Get-Item Env:\ProgramData | % Value
            RHELCentOS   = "/etc/FEUnix"
            UnixBSD      = "/etc/FEUnix"
            
        }[$This.Type],$This.Version)
    }

    _Hive([String]$Type,[String]$Version)
    {
        If ( $Type -notin "Win32_Client","Win32_Server","RHELCentOS","UnixBSD" )
        {
            Throw "Invalid entry"
        }

        $This.Type      = $Type
        $This.Version   = $Version

        $This.PSModule  = $This.PSModule_()
        $This.Root      = $This.Root_()
        $This.Path      = $This.Path_()

        If ( $This.Type -eq "RHELCentOS" )
        {
            $This.Root  = $This.Root -Replace "/","\"
            $This.Path  = $This.Path -Replace "/","\"
        }
    }
}
