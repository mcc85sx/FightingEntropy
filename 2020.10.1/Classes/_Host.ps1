# Drives
# Drive
# File

Class _Host
{
    Hidden [String]         $Name = $Env:ComputerName.ToLower()
    Hidden [String]          $DNS = $env:USERDNSDOMAIN.ToLower()
    Hidden [String]      $NetBIOS = $Env:UserDomain.ToLower()

    [String]            $Hostname
    [String]            $Username = [Environment]::UserName
    [Object]           $Principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    [Bool]               $IsAdmin

    [_Drives]             $Drives = [_Drives]::New()
    [Object]             $Profile = (Get-ChildItem $Env:UserProfile)
    [Object]             $Content

    _Host()
    {
        $This.Hostname            = @($This.Name;"{0}.{1}" -f $This.Name, $This.DNS)[(Get-CimInstance Win32_ComputerSystem).PartOfDomain].ToLower()
        $This.IsAdmin             = $This.Principal.IsInRole("Administrator") -or $This.Principal.IsInRole("Administrators")
        
        If ( $This.IsAdmin -eq 0 )
        {
            Throw "Must run as administrator"
        }

        $This.Content             = Get-ChildItem $This.Profile -Recurse | ? PsIsContainer -eq $False | % { [_File]::New($This.Provider,$_.FullName) }
    }
}
