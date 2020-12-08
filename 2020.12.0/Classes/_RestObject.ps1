Class _RestObject
{
    [String]           $Name
    [Object]         $Object
    Hidden [String]     $URI
    Hidden [String] $Outfile
    
    _RestObject([String]$URI,[String]$Outfile)
    {
        $This.Name    = $URI.Split("/")[-1]
        $This.URI     = $URI
        $This.Outfile = $Outfile.Replace("\","/")

        Invoke-RestMethod -URI $URI -Outfile $Outfile -Verbose
        
        $This.Object  = (Get-Item $Outfile)
    }
}
