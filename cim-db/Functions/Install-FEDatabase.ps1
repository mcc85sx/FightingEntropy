Function Install-FEDatabase
{
    [CmdLetBinding()]Param([Parameter(Mandatory)]$Base)
    
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
        _Install([String]$Base)
        {
            If (!$Base)
            {
                Throw "No base link provided"
            }

            $This.Base    = $Base
            $This.Index   = Invoke-RestMethod "$Base/Classes/index.txt?raw=true" -Verbose
            $This.Item    = $This.Index -Replace "\s+"," " -Split " "
            $This.Class   = $This.Item | % { [ClassObject]::New($Base,$_) }
        }
    }

    [Install]::New($Base)
}
