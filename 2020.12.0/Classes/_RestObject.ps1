Class _RestObject
{
    [Object] $Object
    [String] $Name
    [String] $URI
    [String] $Outfile
    
    _RestObject([String]$URI,[String]$Outfile)
    {
        $This.URI     = $URI
        $This.Outfile = $Outfile
        Invoke-RestMethod -URI $URI -Outfile $Outfile -Verbose
        
        $This.Object  = (Get-Item $Outfile)
        $This.Name    = $URI.Split("/")[-1] 
    }
}
