
Class FEObject
{
    [String]                  $Name
    [Int32]                   $Mode
    [Int32]                 $Height
    [Object]                 $Theme
    [String]                $Header
    [String[]]                $Body
    [String]                $Footer
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

    Draw()
    {
        ForEach ( $I in 0..( $This.Output.Count - 1 ) )
        {
            ForEach ( $X in 0..( $This.Output[$I].Count - 1 ) )
            {
                @{  Object          = $This.Output[$I][$X].Object
                    ForegroundColor = @(10,12,15,0)[$This.Output[$I][$X].ForegroundColor]
                    BackgroundColor = $This.Output[$I][$X].BackgroundColor
                    NoNewLine       = $X -lt ( $This.Output[$I].Count - 1 )
                                
                }                   | % { Write-Host @_ } 
            }
        }
    }
    
    Select([Object]$O)
    {
        Switch($O.GetType().Name)
        {
            Hashtable     { $This.Body       += $This.Line(" ")
                              $O.GetEnumerator() | Sort-Object Name | % { 
                                $This.Body   += $This.Pair($_.Name,$_.Value) } }
            Int32         { $This.Body       += $This.Line($O) }
            String        { $This.Body       += $This.Line($O) }
            Default       { $This.Body       += $This.Line(" ")
                
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

    FEObject([Object[]]$InputObject)
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

        $This.Theme     = [FETheme]::New($This.Mode)
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
                    $This.Output.Add($OutputIndex,$Item.Mask)
                    $OutputIndex ++
                }

                $This.Theme.Body 
                {    
                    Foreach ( $X in 0..( $This.Body.Count - 1 ) ) 
                    { 
                        $Item = [FETrack]::New($NameIndex)
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
                    $This.Output.Add($OutputIndex,$Item.Mask) 
                    $OutputIndex ++
                }
            }

            $NameIndex ++
        }
    }
}

Class FETheme
{
    [ValidateSet(0,1,2)]
    Hidden [Int32]      $Mode
    [String]            $Name 
    [Int32[]]           $Span
    [Int32]           $Header
    [Int32]             $Body
    [Int32]           $Footer
    [Int32[]]         $Colors = @(10,12,15,0)
    
    Hidden [String[]]$Faces = ( "    ,____,¯¯¯¯,----,   /,\   ,   \,/   ,\__/,/¯¯\,/¯¯¯,¯¯¯\,\___,___/,[ __,__ ]" -Split "," )
    
    Hidden [String[]]$String
    Hidden [String[]]$String_ =(("0;1;@(0)*25;1;1;0 4;9;12;@(1)*23;13;9;8;7 6;8;10;@(2)*23;11;8;10;0 0;11;12;14;@(1)*21;15;13" + 
                                 ";10;0;0 0;0;@(2)*25;0;0;0 0;1;0;@(1)*25;0;0 4;9;8;10;@(2)*23;11;12;0 6;8;10;14;@(1)*21;15;0" +
                                 ";13;9;5 0;11;12;@(1)*23;13;9;8;7 0;0;@(2)*25;0;2;0 6;8;10;@(2)*23;11;8;9;5 4;9;12;14;@(1)*2" + 
                                 "1;15;13;9;8;7 6;8;10;@(2)*24;0;11;5 4;10;@(0)*26;4;7 6;5;@(0)*26;6;5 6;12;@(0)*25;13;9;5 4;" +
                                 "9;12;@(1)*23;13;10;13;7").Split(" ") | % { "@($_)" })
    Hidden [String[]]$Fore
    Hidden [String[]]$Fore_ = (( "@(0)*30 0;1;@(0)*25;1;1;0 0;1;@(1)*25;1;0;0 0;0;1;@(2)*23;1;0;0;0 @(0)*30 @(0)*30 0;1;0;@(1)" +
                                "*25;0;0 0;1;1;@(2)*23;1;1;1;0 0;0;@(1)*25;0;1;0 @(0)*30 0;@(1)*28;0 0;1;1;@(2)*23;1;0;1;0 0;" +
                                "1;@(0)*26;0;0 @(0)*30 @(0)*30 @(0)*28;1;0 0;1;@(0)*25;1;1;0").Split(" ") | % { "@($_)" })
    
    Hidden [String[]]$Back
    Hidden [String[]]$Back_ = (0..16 | % { "@({0})" -f ( @(0)*30 -join ',' ) })
    
    [FETrack[]]       $Track
    
    FETheme([Int32]$Slot)
    {
        $This.Name   = "Function Action Section Table Test".Split(" ")[$Slot]
        $This.Span   = @{ 0 = 0..4; 1 = 5..9; 2 = @( 0..1+10..16+2..4 ); 3 = $Null; 4 = $Null }[$Slot]
        $This.Header = @(3;2;3;3;3)[$Slot]
        $This.Body   = @(-1;-1;6;-1;-1)[$Slot]
        $This.Footer = @(-1,-1,10,-1,-1)[$Slot]
                    
        $This.String = $This.Span | % { $This.String_[$_] }
        $This.Fore   = $This.Span | % { $This.Fore_[$_] }
        $This.Back   = $This.Span | % { $This.Back_[$_] }
    
        $This.Track   = ForEach ( $I in 0..( $This.String.Count - 1 ) )
        {
            [FETrack]::New($I,$This.String[$I],$This.Fore[$I],$This.Back[$I]) 
        }
    }
}
    
Class FEBlock 
{
    [String]              $Name
    [Int32]              $Index
    [Object]            $Object
    
    [Int32]    $ForegroundColor
    [Int32]    $BackgroundColor
    [Int32]          $NoNewLine = 1
    
    FEBlock([Int32]$Index,[String]$Object,[Int32]$ForegroundColor,[Int32]$BackgroundColor)
    {
        $This.Name              = $Index
        $This.Index             = $Index
        $This.Object            = $Object
        $This.ForegroundColor   = $ForegroundColor
        $This.BackgroundColor   = $BackgroundColor
    }
}
    
Class FETrack
{
    Hidden [String[]]      $Faces = @("    ,____,¯¯¯¯,----,   /,\   ,   \,/   ,\__/,/¯¯\,/¯¯¯,¯¯¯\,\___,___/,[ __,__ ]" -Split ",")
    
    Hidden [String]         $Name
    [Int32]                $Index
    Hidden [String[]]     $Object
    
    Hidden [Int32[]]  $Foreground
    Hidden [Int32[]]  $Background
    [FEBlock[]]             $Mask
    
    GetMask()
    {
        $This.Mask                 = @( )
        ForEach ( $I in 0..( $This.Object.Count - 1 ) )
        {
            $This.Mask            += [FEBlock]::New($This.Index,$This.Object[$I],$This.Foreground[$I],$This.Background[$I])
        }
    }
    
    FETrack([Int32]$Index)
    {
        $This.Index                = $Index
        $This.Name                 = $Index
        $This.Object               = $This.Faces[@(0)*30]
        $This.Foreground           = @(0)*30
        $This.Background           = @(0)*30
        $This.GetMask()
    }
    
    FETrack([Int32]$Index,[String]$Mask,[String]$Foreground,[String]$Background)
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
        $Offset        = 4-($Load.Length % 4)
        $Load          = "{0}{1}" -f $Load, (" " * $Offset)
        $Line          = 0..( $Load.Length - 1 ) | ? { $_ % 4 -eq 0 } | % { $Load.Substring($_,4) }
                            
        If ( $Line.Count -gt 1 )
        {
            ForEach ( $X in 0..( $Line.Count - 1 ) )
            {
                $This.Mask[$X+3].Object          = $Line[$X]
                $This.Mask[$X+3].ForegroundColor = 2
            }
        }
    
        If ( $Line.Count -eq 1 )
        {      
            $This.Mask[3].Object             = $Line
            $This.Mask[3].ForegroundColor    = 2
        }
    }
    
    SetBody([Int32]$Count)
    {
        $Count % 2 | % { 
            $This.Mask[0].Object  = @("   \","   /")[$_]
            $This.Mask[1].Object  = @("\   ","/   ")[$_]
            $This.Mask[-2].Object = @("   \","   /")[$_]
            $This.Mask[-1].Object = @("\   ","/   ")[$_]
        }
    }
}

    Function Write-Theme # Cross Platform
    {
        [CmdLetBinding()]Param([Parameter(Mandatory)][Object]$InputObject,[Parameter()][Int32[]]$Palette = @(10,12,15,0))
        [FEObject]::New($InputObject).Draw()
    }

    # Examples
    # Write-Theme (Get-PSDrive)
    # Write-Theme "String Hello 1" 
    # Write-Theme "String [:] Hello 1"
    # Write-Theme @("String Hello 1","String Hello2")
    # Write-Theme @("String hello 1","String hello 2";(PSDrive);"String hello 3")
