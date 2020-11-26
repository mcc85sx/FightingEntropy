
Class Content # Gets content, makes replacements, and sets the updated content back to source
{
    [String]      $Path
    [Object]   $Content
    [String[]]  $Search
    [String[]]  $Target

    Content([String]$Path,[String[]]$Search,[String[]]$Target)
    {
        If ( $Search.Count -ne $Target.Count -or $Search.Count -eq 0 -or $Target.Count -eq 0 )
        {
            Throw "Invalid input" 
        }

        $This.Path    = $Path
        $This.Content = Get-Content $This.Path
        $This.Search  = $Search
        $This.Target  = $Target

        Switch($This.Search.Count)
        {
            Default 
            {
                ForEach ( $I in 0..( $This.Search.Count - 1 ) )
                { 
                    $This.Content = $This.Content -Replace $This.Search[$I], $This.Target[$I] 
                }
            }

            1 
            {
                $This.Content = $This.Content -Replace $This.Search, $This.Target
            }
        }

        Set-Content $This.Path $This.Content
    }
}
