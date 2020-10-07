Class _Master
{
    [String]               $Name
    [String]            $Version
    [String]           $Provider
    [Object]             $Module

    [Object[]]          $Classes
    [Object[]]        $Functions
    [Object[]]         $Graphics

    [Object]               $Path

    _Master()
    {
        $This.Module        = [_Module]::New()
        
        $This.Module        | % { 

            $This.Name      = $_.Name
            $This.Version   = $_.Version
            $This.Provider  = $_.Provider
            $This.Classes   = $_.Base | ? Name -eq Classes    | Get-ChildItem
            $This.Functions = $_.Base | ? Name -eq Functions  | Get-ChildItem
            $This.Graphics  = $_.Base | ? Name -eq Graphics   | Get-ChildItem
            $This.Path      = $_.Path
        }

        # TODO: Set Background, Icons, System Badge/Info, Group Policy, etc.
        # "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        # "ClassicStartMenu" , "NewStartPanel"
    }

    LoadNetworking()
    {
        $This.Network       = [_Network]::New()
    }

    LoadServices()
    {
        $This.Services      = [_ViperBomb]::New()
    }
}