Class _UnixService
{
    Hidden [String]   $Input
    Hidden [String[]] $Array
    [String] $Unit
    [String] $Load
    [String] $Active
    [String] $Sub
    [String] $Description

    _UnixService([String]$InputObject)
    {
        $This.Input       = $InputObject
        $This.Array       = $This.Input -Split " " | ? Length -gt 0
        $This.Unit        = $This.Array[0]
        $This.Load        = $This.Array[1]
        $This.Active      = $This.Array[2]
        $This.Sub         = $This.Array[3]
        $This.Description = @( 
            
            If ( $This.Array.Count -gt 4 ) 
            {
                $This.Array[4..( $This.Array.Count - 1 )] -join " " 
            }

            Else 
            {
                $This.Array[4]
            }
        )
    }
}
