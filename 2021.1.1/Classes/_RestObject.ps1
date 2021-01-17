Class _RestObject
{
    [String]           $Type
    [String]           $Name
    [Object]         $Object
    [String]           $Path
    Hidden [String]     $URI
    
    _RestObject([String]$URI,[String]$Outfile)
    {
        $This.Type    = $URI.Split("/")[-2]
        $This.Name    = $URI.Split("/")[-1]
        $This.URI     = $URI
        $This.Object  = Invoke-RestMethod -URI $This.URI -Verbose
        $This.Path    = $Outfile.Replace("\","/")
    }

    Content()
    {
        Set-Content -Path $This.Path -Value $This.Object -Verbose
    }
}
