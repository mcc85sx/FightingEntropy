Class _Object
{
    [String]                  $Name
    [Int32]                   $Mode
    [Int32]                 $Height
    [Object]                 $Theme
    [String]                $Header
    [String[]]                $Body
    [String]                $Footer
    [Int32[]]              $Palette
    [Hashtable]             $Output
    
    [String] Line ([String]$L)
    {
        Return @{   Line  = If ( $L.Length -ge 89 ) { $L.Substring(0,88) + "..." } Else { $L + (" " * (92-$L.Length)) } } | % Line
    }
    
    [String] Pair ([String]$K,[String]$V)
    {
        Return @{   Key   = If ( $K.Length -ge 25 ) { $K.Substring(0,20) + "..." } Else { $K + (" "*(25-$K.Length)) }
                    Value = If ( $V.Length -ge 64 ) { $V.Substring(0,59) + "..." } Else { $V + (" "*(64-$V.Length)) }
                
                }         | % { "{0} : {1}" -f $_.Key, $_.Value }
    }
        
    [String[]] Names ([Object]$N)
    {
        Return ( $N | Get-Member | ? MemberType -eq Property | Sort-Object Name | % Name )
    }

    Draw([Int32[]]$Palette)
    {   
        ForEach ( $I in 0..( $This.Output.Count - 1 ) )
        {
            ForEach ( $X in 0..( $This.Output[$I].Count - 1 ) )
            {
                (Get-Host).UI.Write($Palette[$This.Output[$I][$X].ForegroundColor],$This.Output[$I][$X].BackgroundColor,$This.Output[$I][$X].Object.Replace("Â¯","¯"))
            }

            (Get-Host).UI.Write("`n")
        }
    }
    
    Select([Object]$O)
    {
        Switch($O.GetType().Name)
        {
            OrderedDictionary { $This.Body += $This.Line(" ")
                $O.GetEnumerator()          | % { 
                                $This.Body += $This.Pair($_.Name,$_.Value) } }
            Hashtable         { $This.Body += $This.Line(" ")
                $O.GetEnumerator()          | Sort-Object Name | % { 
                    $This.Body             += $This.Pair($_.Name,$_.Value) } }
            Int32             { $This.Body += $This.Line($O) }
            String            { $This.Body += $This.Line($O) }
            Default           { $This.Body += $This.Line(" ")
                
                ForEach ( $X in $This.Names($O) )
                { 
                    $This.Body += $This.Pair($X,$O.$($X))
                }
            }
        }
    }

    Load([Object]$InputObject)
    {
        $This.Name             = $InputObject.GetType().Name

        Switch([Int]($InputObject.GetType().Name -match "(\[\])"))
        {
            0 { $This.Select($InputObject) }
            1 { ForEach ( $I in 0..( $InputObject.Count - 1 ) )
                {
                    $This.Name    = $InputObject[$I].GetType().Name 
                    $This.Select($InputObject[$I])
                }
            }
        }
    }

    Load([Object[]]$InputObject)
    {
        ForEach ( $I in 0..( $InputObject.Count - 1 ) )
        {
            $This.Name = $InputObject[$I].GetType().Name

            Switch([Int]($This.Name -match "(\[\])"))
            {
                0 { $This.Select($InputObject[$I]) }
                1 { ForEach ( $X in 0..( $InputObject[$I].Count - 1 ) )
                    {
                        $This.Name    = $InputObject[$I].GetType().Name 
                        $This.Select($InputObject[$I])
                    }
                }
            }
        }
    }

    _Object([Object[]]$InputObject)
    {
        $This.Body             = @()
        $This.Load($InputObject)

        If ( $This.Body.Count -eq 1 )
        {
            If ( $This.Body -notmatch "(\[\:\])" ) 
            { 
                $This.Name   = "Function"
                $This.Mode   = 0 
            }
            Else                                   
            { 
                $This.Name   = "Action"
                $This.Mode   = 1 
            } 
        }

        Else                                       
        { 
            $This.Name      = "Section"
            $This.Mode      = 2
            $This.Header    = "Section"
            $This.Footer    = "Press Enter to Continue"
            
            Switch ($This.Body.Count % 2)
            { 
                1 { $This.Body += $This.Line("    " )}
            }
        }

        $This.Theme     = [_Theme]::New($This.Mode)
        $This.Height    = Switch($This.Name) { Function {5} Action {5} Section { $This.Height + 10 } }
        $This.Header    = Switch($This.Mode) { 0 { $InputObject } 1 { $InputObject } 2 { "Section" } }

        $This.Output    = @{ }
        $OutputIndex    = 0

        $NameIndex      = 0
        While ( $NameIndex -lt $This.Theme.Track.Count )
        {
            $Item       = $This.Theme.Track[$NameIndex]
            
            Switch($NameIndex)
            {
                Default 
                {
                    $This.Output.Add($OutputIndex,$Item.Mask)
                    $OutputIndex ++
                }

                $This.Theme.Header  
                {
                    $Item.Load($This.Header)
                    $Item.SetHead()
                    $This.Output.Add($OutputIndex,$Item.Mask)
                    $OutputIndex ++
                }

                $This.Theme.Body 
                {    
                    Foreach ( $X in 0..( $This.Body.Count - 1 ) ) 
                    { 
                        $Item = [_Track]::New($NameIndex)
                        $Item.Load($This.Body[$X])
                        $Item.SetBody($X)

                        If ( $X -eq ( $This.Body.Count - 1 ) )
                        {
                            $Item.Mask[-2].Object = "___/"
                        }
                        $This.Output.Add($OutputIndex,$Item.Mask)
                        $OutputIndex ++
                    }
                }

                $This.Theme.Footer  
                {  
                    $Item.Load(" Press Enter to Continue ")
                    $Item.SetFoot()
                    $This.Output.Add($OutputIndex,$Item.Mask)
                    $OutputIndex ++
                }
            }

            $NameIndex ++
        }
    }
}
