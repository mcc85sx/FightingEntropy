Class _RestObject
{
    [Object] $Object
    [String] $URI
    [String] $Outfile
    
    _RestObject([String]$URI,[String]$Outfile)
    {
        $This.URI     = $URI
        $This.Outfile = $Outfile
        $This.Object  = Invoke-RestMethod -URI $URI -Outfile $Outfile -Verbose -Force
    }
}
