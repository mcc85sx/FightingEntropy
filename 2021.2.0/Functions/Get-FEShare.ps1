Function Get-FEShare
{
    [CmdletBinding()]
    Param(
    [Parameter()][String]$Name,
    [Parameter()][String]$Path)

    Class _Share
    {
        [String] $Hostname
        [String] $Label
        [String] $Name
        [String] $ScopeName
        [String] $Path
        [String] $NetworkPath
        [String] $Description

        _Share([Object]$Persist)
        {
            $This.Hostname    = [Environment]::MachineName
            $This.Label       = $Persist.Name
            $This.Path        = $Persist.Path
            $This.Description = $Persist.Description
        }

        Load([Object]$Share)
        {
            $This.Name        = $Share.Name
            $This.ScopeName   = $Share.ScopeName
            $This.NetworkPath = "\\{0}\{1}$" -f $This.Hostname,$This.Name.TrimEnd("$")
        }

        [String] ToString()
        {
            Return $This.Label
        }
    }

    Import-Module (Get-MDTModule)

    [Object] $Return  = Get-MDTPersistentDrive | % { [_Share]::New($_) }

    ForEach ( $Item in $Return )
    {
        Get-SMBShare | ? Path -eq $Item.Path | % { $Item.Load($_) }
    }

    $Return
}
