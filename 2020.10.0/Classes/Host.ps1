Class Host
{
    [String]                $Name = $Env:ComputerName.ToLower()
    [String]                 $DNS = $env:USERDNSDOMAIN.ToLower()
    [String]             $NetBIOS = $Env:UserDomain.ToLower()

    [String]            $Hostname
    [String]            $Username = [Environment]::UserName
    [Object]           $Principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    [Bool]               $IsAdmin

    [Object]              $Drives
    [Object]             $Profile
    [Object]             $Content

    Host()
    {
        $This.Hostname            = @($This.Name;"{0}.{1}" -f $This.Name, $This.DNS)[(Get-CimInstance Win32_ComputerSystem).PartOfDomain].ToLower()
        $This.IsAdmin             = $This.Principal.IsInRole("Administrator") -or $This.Principal.IsInRole("Administrators")
        
        If ( $This.IsAdmin -eq 0 )
        {
            Throw "Must run as administrator"
        }

        $This.Drives              = [Drives]::New()
        $This.Profile             = $Env:UserProfile
        $This.Content             = Get-ChildItem -Path $Env:UserProfile | % FullName
    }
}
