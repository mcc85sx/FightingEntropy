Class ImageFile
{
    [ValidateSet("Client","Server")]
    [String]        $Type
    [String]        $Name
    [String] $DisplayName
    [String]        $Path
    [UInt32[]]     $Index
    ImageFile([String]$Type,[String]$Path)
    {
        $This.Type  = $Type
    
        If ( ! ( Test-Path $Path ) )
        {
            Throw "Invalid Path"
        }

        $This.Name        = ($Path -Split "\\")[-1]
        $This.DisplayName = "($Type)($($This.Name))"
        $This.Path        = $Path
        $This.Index       = @( )
    }
    AddMap([UInt32[]]$Index)
    {
        ForEach ( $I in $Index )
        {
            $This.Index  += $I
        }
    }
}