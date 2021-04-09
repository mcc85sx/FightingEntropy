Function init.cim-db ([String]$Base)
{   
    If (!$Base)
    {
        Throw "No base link provided"
    }

    Class _ClassObject
    {
        Hidden [String] $Base
        [String] $Name
        [String] $URL
        [Object] $Content
        _ClassObject([String]$Base,[String]$Name)
        {
            $This.Base    = $Base
            $This.Name    = $Name
            $This.URL     = ("$Base/Classes/_{0}.ps1?raw=true" -f $Name)
            $This.Content = Invoke-RestMethod $This.URL -Verbose 
        }
    }

    Class _Install
    {
        [String]          $Base
        [String]         $Index
        Hidden [Object[]] $Item
        [Object[]]       $Class
        [Object]          $Xaml
        Hidden [Object] $Module
        _Install([String]$Base)
        {
            $This.Base    = $Base
            $This.Index   = Invoke-RestMethod "$Base/Classes/index.txt?raw=true" -Verbose
            $This.Item    = $This.Index -Replace "\s+"," " -Split " "
            $This.Class   = $This.Item | % { [_ClassObject]::New($Base,$_) }
        }

        [String] ToString()
        {
            Return ( "init.cim-db -> {0}" -f $This.Index )
        }

        BuildModule()
        {
            $This.Module = @( ) 
            $This.Class | % { 
                
                Write-Host ("Loading [+] {0}" -f $_.Name )
                $This.Module += $_.Content 
            }

            $This.Module = ( $This.Module -join "`n" )
        }
    }

    $DB = [_Install]::New($Base)
    $DB.BuildModule()

    Invoke-Expression $DB.Module

    [_DB]::New($DB)
}
