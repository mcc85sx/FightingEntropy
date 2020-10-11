Class _Track
{
    Hidden [String[]]      $Faces = [_Faces]::New().Faces
    
    Hidden [String]         $Name
    [Int32]                $Index
    Hidden [String[]]     $Object
    
    Hidden [Int32[]]  $Foreground
    Hidden [Int32[]]  $Background
    [_Block[]]             $Mask
    
    GetMask()
    {
        $This.Mask                 = @( )
        ForEach ( $I in 0..( $This.Object.Count - 1 ) )
        {
            $This.Mask            += [_Block]::New($This.Index,$This.Object[$I],$This.Foreground[$I],$This.Background[$I])
        }
    }
    
    _Track([Int32]$Index)
    {
        $This.Index                = $Index
        $This.Name                 = $Index
        $This.Object               = $This.Faces[@(0)*30]
        $This.Foreground           = @(0)*30
        $This.Background           = @(0)*30
        $This.GetMask()
    }
    
    _Track([Int32]$Index,[String]$Mask,[String]$Foreground,[String]$Background)
    {
        $This.Index                = $Index
        $This.Name                 = $Index
        $This.Object               = $This.Faces[(Invoke-Expression $Mask)]
        $This.Foreground           = Invoke-Expression $Foreground
        $This.Background           = Invoke-Expression $Background
        $This.GetMask()
    }
    
    Load([String]$Load)
    {
        $Width                     = $This.Mask.Count - 6
        $Load                      = " $Load"
        $Offset                    = 4-($Load.Length % 4)
        $Load                      = "{0}{1}" -f $Load, (" " * $Offset)
        $Line                      = 0..( $Load.Length - 1 ) | ? { $_ % 4 -eq 0 } | % { $Load.Substring($_,4) }

        If ( $Line.Count -eq 1 )
        {
            $This.Mask[3].Object                 = $Line
            $This.Mask[3].ForegroundColor        = 2
        }
        
        If ( $Line.Count -eq $Width )
        {
            ForEach ( $X in 0..( $Line.Count - 1 ) )
            {
                $This.Mask[3+$X].Object          = $Line[$X]
                $This.Mask[3+$X].ForegroundColor = 2
            }
        }

        Else
        {
            ForEach ( $X in 0..( $Line.Count - 1 ) )
            {
                $This.Mask[3+$X].Object               = $Line[$X]
                $This.Mask[3+$X].ForegroundColor      = 2
            }

            $This.Mask[3+$Line.Count].Object          = "]___"
            $This.Mask[3+$Line.Count].Foregroundcolor = 1

            ForEach ( $X in ( $Line.Count + 1 )..( $Width - 1 ) )
            {
                $This.Mask[3+$X].Object               = "____"
                $This.Mask[3+$X].ForegroundColor      = 1
            }
        }
    }

    SetHead()
    {
        $This.Mask[2].Object                 = "\__["
        $This.Mask[26].Object                = "___/"
    }

    SetFoot()
    {
        $This.Mask[2].Object                 = "\__["
        $This.Mask[26].Object                = "___/"
    }
    
    SetBody([Int32]$Count)
    {
        $Count % 2                | % { 

            $This.Mask[0].Object  = @("   \","   /")[$_]
            $This.Mask[1].Object  = @("\   ","/   ")[$_]
            $This.Mask[-2].Object = @("   \","   /")[$_]
            $This.Mask[-1].Object = @("\   ","/   ")[$_]
        }

        -4..-3 | % { $This.Mask[$_].Object = "    " }
    }
}
