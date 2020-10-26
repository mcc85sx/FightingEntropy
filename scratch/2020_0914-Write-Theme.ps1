

Class FEObject
{
    [String]                  $Name
    [Int32]                 $Height
    [Object[]]             $Content
    [Object[]]              $Output

    [String] Line ([String]$L)
    {
        Return @{ Line  = If ( $L.Length -ge 89 ) { "$($L.Substring(0,88))..." } Else { "$L$(" "*(92-$L.Length))" } } | % Line
    }

    [String] Pair ([String]$K,[String]$V)
    {
        Return @{ Key   = If ( $K.Length -ge 25 ) { "$($K.Substring(0,20))..." } Else { "$K$(" "*(25-$K.Length))" }
                  Value = If ( $V.Length -ge 64 ) { "$($V.Substring(0,59))..." } Else { "$V$(" "*(64-$V.Length))" }
        
        }         | % { "{0} : {1}" -f $_.Key, $_.Value }
    }
    
    [String[]] Names ([Object]$N)
    {
        Return @( $N | Get-Member | ? MemberType -eq Property | % { $This.Pair($_.Name, $N.($_.Name)) } )
    }

    Select([Object]$Object)
    {
        Switch($Object.GetType().Name)
        {
            Hashtable { $Object.GetEnumerator() | Sort Name | % { 
                        $This.Content += $This.Pair($_.Name,$_.Value) } }
            Int       { $This.Content += $This.Line($Object)  }
            String    { $This.Content += $This.Line($Object)  }
            Object    { $This.Content += $This.Names($Object) }
            Default   { $This.Content += $This.Names($Object) }
        }
    }

    FEObject([Object]$InputObject)
    {
        $This.Name             = $InputObject.GetType().Name
        $This.Content          = @( )
        
        If ( $This.Name -Match "(\w.\[\])" )
        {
            ForEach ( $I in 0..( $InputObject.Count - 1 ) )
            {
                $This.Name     = $InputObject[$I].GetType().Name
                $This.Select($InputObject[$I])
            }
        }

        If ( $This.Name -Notmatch "(\w.\[\])" )
        {
            $This.Select($InputObject)
        }

        $This.Height           = $This.Content.Count
    }
}

Class FETheme
{
    [String]            $Name 
    [Int32[]]           $Span
    [Int32]           $Header
    [Int32]             $Body
    [Int32]           $Footer
    [Int32[]]         $Colors = @(10,12,15,0)

    [String[]]         $Faces = ( "    ,____,¯¯¯¯,----,   /,\   ,   \,/   ,\__/,/¯¯\,/¯¯¯,¯¯¯\,\___,___/,[ __,__ ]" -Split "," )

    [String[]]       $String
    Hidden [String[]]$String_ = (("0;1;@(0)*25;1;1;0!4;9;12;@(1)*23;13;9;8;7!6;8;10;@(2)*23;11;8;10;0!0;11;12;14;@(1)*21;15;" +
                                "13;10;0;0!0;0;@(2)*25;0;0;0!0;1;0;@(1)*25;0;0!4;9;8;10;@(2)*23;11;12;0!6;8;10;14;@(1)*21;" +
                                "15;0;13;9;5!0;11;12;@(1)*23;13;9;8;7!0;0;@(2)*25;0;2;0!6;8;10;@(2)*23;11;8;9;5!4;9;12;14;" + 
                                "@(1)*21;15;13;9;8;7!6;8;10;@(2)*24;0;11;5!4;10;@(0)*26;4;7!6;5;@(0)*26;6;5!4;7;@(0)*26;13" + 
                                ";7!6;12;@(0)*25;13;9;5!4;9;12;@(1)*23;13;10;13;7").Split("!") | % { "@($_)" } )
    [String[]]         $Fore
    Hidden [String[]]  $Fore_ = (("@(0)*30!0;1;@(0)*25;1;1;0!0;1;@(1)*25;1;0;0!0;0;1;@(2)*23;1;0;0;0!@(0)*30!@(0)*30!0;1;0;@" + 
                                "(1)*25;0;0!0;1;1;@(2)*23;1;1;1;0!0;0;@(1)*25;0;1;0!@(0)*30!0;@(1)*28;0!0;1;1;@(2)*23;1;0;" + 
                                "1;0!0;1;@(0)*26;0;0!@(0)*30!@(0)*30!@(0)*30!@(0)*28;1;0!0;1;@(0)*25;1;1;0").Split("!") | % { "@($_)" })

    [String[]]         $Back
    Hidden [String[]]  $Back_ = (0..17 | % { "@({0})" -f ( @(0)*30 -join ',' ) })

    [FETrack[]]       $Track

    FETheme([Int32]$Slot)
    {
        $This.Name   = "Function Action Section Table Test".Split(" ")[$Slot]
        $This.Span   = @{ 0 = 0..4; 1 = 5..9; 2 = @( 0..1+10..17+2..4 ); 3 = $Null; 4 = $Null }[$Slot]
        $This.Header = @(3,2,3,3,3)[$Slot]
        $This.Body   = @(-1,-1,6,-1,1)[$Slot]
        $This.Footer = @(-1,-1,11,-1,-1)[$Slot]
                
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

Class FEFill
{
    [String]    $Load
    [Int32]   $Offset
    [Int32[]]  $Range
    [Int32[]]   $Step 
    [String[]]  $Line
           
    FEFill(){}
}

Class FETrack
{
    Hidden [String[]]    $Faces = @("    ,____,¯¯¯¯,----,   /,\   ,   \,/   ,\__/,/¯¯\,/¯¯¯,¯¯¯\,\___,___/,[ __,__ ]" -Split ",")

    [String]              $Name
    [Int32]              $Index
    [String[]]          $Object

    [Int32[]]       $Foreground
    [Int32[]]       $Background
    [FEBlock[]]           $Mask

    GetMask()
    {
        $This.Mask                 = @( )
        ForEach ( $I in 0..( $This.Object.Count - 1 ) )
        {
            $This.Mask            += [FEBlock]::New($This.Index,$This.Object[$I],$This.Foreground[$I],$This.Background[$I])
        }
    }

    FETrack()
    {
        $This.Index                = -1
        $This.Name                 = -1
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

    [FETrack] Load([FETrack]$Track,[String]$Load)
    {
        $This.Load          = $Load -Replace "(\s+)"," "
        $This.Offset        = 4-($This.Load.Length % 4)
        $This.Load          = "{0}{1}" -f $This.Load, (" " * $This.Offset)
        $This.Range         = 0..( ( $This.Line.Length / 4 ) - 1 )
        $This.Step          = $This.Range | % { $_ * 4 }
        $This.Line          = $This.Step | % { $This.Line.Substring($_,4) }
        $X                  = 0
                
        If ( $This.Line.Count -gt 1 )
        {
            ForEach ( $X in 0..( $This.Line.Count - 1 ) )
            {
                $Track.Mask[$X+3].Object          = $This.Line[$X]
                $Track.Mask[$X+3].ForegroundColor = 2
            }
        }

        If ( $This.Line.Count -eq 1 )
        {      
            $Track.Mask[$X+3].Object             = $This.Line
            $Track.Mask[$X+3].ForegroundColor    = 2
        }

        Return $Track
    }
}

Class FEStack
{
    [Object[]]          $Stack
    [String]             $Last
            [String]             $Name
            [FETheme]           $Theme
            [Int32]              $Slot
            [Int32]            $Height
            [Object[]]          $Slack
            [String]           $Header
            [String[]]           $Body
            [String]           $Footer
            [Hashtable]         $Track
            [Hashtable]        $Output

            FEStack([FEObject[]]$InputObject)
            {
                If ( $InputObject.Count -eq 1 ) { If ( $InputObject -notmatch "(\[\w.\])" ) { 0 } Else { 1 } } Else { 2 } 

                $This.Stack        = $InputObject | % { [FEObject]$_ }
                $This.Height       = $InputObject | Measure-Object -Property Height -Sum | % Sum

                If ( $This.Height -eq 1 ) 
                {
                    $This.Slot     = 0

                    If ( $This.Stack.Content -match "(\[\w.\])" )
                    {
                        $This.Slot = 1
                    }
                }

                If ( $This.Height -gt 1 )
                {
                    $This.Slot     = 2
                }

                $This.Theme        = [FETheme]::New($This.Slot)
                $This.GetSlack()
            }

            GetSlack()
            {
                ForEach ( $I in 0..( $This.Stack.Count - 1 ) )
                {
                    $This.Name     = $This.Stack[$I].Name

                    If ( $This.Last -eq "String" -and $This.Name -eq "Hashtable" )
                    {
                        $This.Slack += ([FEObject]" ").Content
                    }

                    ElseIf ( $This.Last -eq "Hashtable" -or $This.Name -eq "Hashtable" )
                    {
                         $This.Slack += ([FEObject]" ").Content
                    }

                    ElseIf ( $This.Last -ne "String" -or $This.Name -eq "Hashtable" )
                    {
                         $This.Slack += ([FEObject]" ").Content
                    }

                    If ( $This.Stack[$I].Content.Count -gt 1 )
                    {
                        ForEach ( $X in 0..( $This.Stack[$I].Content.Count - 1 ) )
                        {
                            $This.Slack += $This.Stack[$I].Content[$X]
                        }
                    }

                    If ( $This.Stack[$I].Content.Count -eq 1 )
                    {
                        $This.Slack += $This.Stack[$I].Content
                    }

                    $This.Last     = $This.Name
                }

                $This.Height       = $This.Slack.Count
                $This.Name         = $This.Theme.Name

                If ( $This.Slot -gt 1 )
                {
                    $This.Header       = "Section"
                    $This.Body         = $This.Slack
                    $This.Footer       = "Press Enter to Continue"
                }

                If ( $This.Slot -lt 2 )
                {
                    $This.Header       = $This.Slack
                    $This.Body         = $Null
                    $This.Footer       = $Null
                }

                $This.GetStack()
            }

            GetStack()
            {
                $This.Track            = @{ }
                $Buffer                = 0
                
                ForEach ( $I in 0..( $This.Theme.Track.Count - 1 ) )
                {
                    $Item              = $This.Theme.Track[$I]

                    Switch ([Int32]$Item.Name)
                    {
                        $This.Theme.Header
                        {
                            $Item.Load($This.Header)
                            $This.Track.Add($Buffer,$Item)
                            $Buffer ++
                        }
                        
                        $This.Theme.Body   
                        {
                            $Y = 0
                            $Item = $This.Theme.Track[$I]
                            While ( $Y -le $This.Body.Count )
                            {
                                
                                $This.Theme.Track[$I]
                                $Item.Load($This.Body[$Y])
                                $This.Track.Add($Buffer,$Item)
                                $Y      ++
                                $Buffer ++
                            }
                        }

                        $This.Theme.Footer 
                        {
                            $Item.Load($This.Footer)
                            $This.Track.Add($Buffer,$Item)
                            $Buffer ++
                        }

                        Default 
                        {                
                            $This.Track.Add($Buffer,$Item)
                            $Buffer ++
                        }
                    }
                }
            }

            Draw()
            {
                ForEach ( $I in 0..( $This.Track.Count - 1 ) )
                {
                    ForEach ( $X in 0..( $This.Track[$I].Mask.Count - 1 ) )
                    {
                        @{  Object          = $This.Track[$I].Mask[$X].Object
                            ForegroundColor = @(10,12,15,0)[$This.Track[$I].Mask[$X].ForegroundColor]
                            BackgroundColor = $This.Track[$I].Mask[$X].BackgroundColor
                            NoNewLine       = $X -lt ( $This.Track[$I].Mask.Count - 1 )
                                
                        }                   | % { Write-Host @_ } 
                    }
                }
            }
        }


        
        $String         = "Name Things Place Happening"
        $Hashtable      = @{ Name ="Things"; Place = "Happening" }
        $StringArray    = "Name Things Place Happening" -Split " "
        $HashtableArray = $Hashtable | % { $_ , $_ }

        $ObjectList     = $String, $Hashtable, $StringArray, $HashtableArray

        $ObjectList     = Get-PSDrive

        $Stack          = [FEStack]::New($ObjectList).Draw()
