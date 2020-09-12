Class FEBlock
{
    [Int32]            $Index
    [String]          $Object
    [Int32]  $ForegroundColor
    [Int32]  $BackgroundColor

    FEBlock([Int32]$Index,[String]$Object,[Int32]$ForegroundColor,[Int32]$BackgroundColor)
    {
        $This.Index             = $Index
        $This.Object            = $Object
        $This.ForegroundColor   = $ForegroundColor
        $This.BackgroundColor   = $BackgroundColor
    }
}

Class FETrack
{
    [Int32]           $Index
    [Array]           $Object

    Hidden [String]   $Header
    Hidden [Array]    $Body
    Hidden [String]   $Footer

    Hidden [String[]] $Strings
    Hidden [Int32[]]  $Masks
    Hidden [Int32[]]  $Foregrounds
    Hidden [Int32[]]  $Backgrounds

    Hidden [String]   $String
    Hidden [Int32]    $Segments
    Hidden [Object]   $Track
    Hidden [Array]    $Swap

    FETrack(){}
    
    FETrack([Int32]$Index,[String]$Mask,[String]$Foreground,[String]$Background)
    {
        $This.Index                = $Index
        $This.Masks                = IEX $Mask
        $This.Strings              = @("    ,____,¯¯¯¯,----,   /,\   ,   \,/   ,\__/,/¯¯\,/¯¯¯,¯¯¯\,\___,___/,[ __,__ ]" -Split ",")[$This.Masks]
        $This.Foregrounds          = IEX $Foreground
        $This.Backgrounds          = IEX $Background
        
        $This.Object               = @( )

        ForEach ( $I in 0..( $This.Masks.Count - 1 ) )
        {
            $This.Object          += [FEBlock]::New($I,$This.Strings[$I],$This.Foregrounds[$I],$This.Backgrounds[$I])
        }
    }

    Load([String]$String)
    {
        If ( !$String ) 
        { 
            Throw "String/Track is null" 
        }

        $This.String = $String

        If ( $String.Length % 4 -ne 0 )
        {
            $This.String           = "[ $String{0} ]" -f ( " " * ( 4 - ( $String.Length % 4 ) ) )
        }

        $This.Segments             = $This.String.Length / 4
        
        If ( $This.Segments -gt 23 ) 
        { 
            Throw "Input string too long" 
        } 

        $This.Object[3..25]        | % { $_.Object = "    " ; $_.ForegroundColor = 0 }
        $This.Swap                 = @( )
        
        ForEach ( $I in 0..( $This.Segments - 1 ) )
        {     
            $This.Swap            += [FEBlock]::New( $I,($This.String[($I*4)..(($I*4)+3)] -join '' ), 2, 0) 
        }

        ForEach ( $Z in 0..( $This.Swap.Count -  1 ) )
        {
            $This.Swap[$Z]         | % { $_.Index = $_.Index + 3 }
            $This.Object[$Z+3]     = $This.Swap[$Z]
        }
    }
}

Class FEMask
{
    [Int32]     $Index
    [Int32]     $Span
    [String]    $Mask
    [String]    $Foreground
    [String]    $Background

    FEMask([Int32]$Index,[Int32]$Span,[String]$Mask,[String]$Foreground,[String]$Background)
    {
        $This.Index                = $Index
        $This.Span                 = $Span
        $This.Mask                 = $Mask
        $This.Foreground           = $Foreground
        $This.Background           = $Background
    }
}

Class FEStock
{
    Hidden [Object]  $Object
    [String]           $Name
    [Int32]            $Slot

    Hidden [Int32]     $Head
    Hidden [Int32]     $Main
    Hidden [Int32]     $Foot

    [String]         $Header
    [Array]            $Body
    [String]         $Footer

    Hidden [String[]] $Names  = @("Function","Action","Section","Table","Test")
    Hidden [Array]    $Theme 

    Hidden [Int32[]]   $Span 
    [Int32]          $Height 

    Hidden [Hashtable] $Hash  = @{ 

        Head                  =  3, 2, 3, 3, 3
        Main                  = -1,-1, 6,-1,-1
        Foot                  = -1,-1,11,-1,-1
        Colors                = $Palette
        Faces                 = @("    ,____,¯¯¯¯,----,   /,\   ,   \,/   ,\__/,/¯¯\,/¯¯¯,¯¯¯\,\___,___/,[ __,__ ]" -Split ",")

        String                = ("0;1;@(0)*25;1;1;0!4;9;12;@(1)*23;13;9;8;7!6;8;10;@(2)*23;11;8;10;0!0;11;12;14;@(1)*21;15;13;10;0;0!0;0;@(2)*25;0;0;0"+
                                "!0;1;0;@(1)*25;0;0!4;9;8;10;@(2)*23;11;12;0!6;8;10;14;@(1)*21;15;0;13;9;5!0;11;12;@(1)*23;13;9;8;7!0;0;@(2)*25;0;2;0!"+
                                "6;8;10;@(2)*23;11;8;9;5!4;9;12;14;@(1)*21;15;13;9;8;7!6;8;10;@(2)*24;0;11;5!4;10;@(0)*26;4;7!6;5;@(0)*26;6;5!4;7;@(0)"+
                                "*26;13;7!6;12;@(0)*25;13;9;5!4;9;12;@(1)*23;13;10;13;7").Split("!") | % { "@($_)" } 

        Fore                  = ("@(0)*30!0;1;@(0)*25;1;1;0!0;1;@(1)*25;1;0;0!0;0;1;@(2)*23;1;0;0;0!@(0)*30!@(0)*30!0;1;0;@(1)*25;0;0!0;1;1;@(2)*23;1;"+
                                "1;1;0!0;0;@(1)*25;0;1;0!@(0)*30!0;@(1)*28;0!0;1;1;@(2)*23;1;0;1;0!0;1;@(0)*26;0;0!@(0)*30!@(0)*30!@(0)*30!@(0)*28;1;0"+
                                "!0;1;@(0)*25;1;1;0")

        Back                   = 0..17 | % { "@({0})" -f ( @(0)*30 -join ',' ) }
        Span                   = @{ 0 = 0..4; 1 = 5..9; 2 = @( 0..1;10..17;2..4 ); 3 = $Null; 4 = $Null }
    }

    [Hashtable]         $Process
    [Hashtable]          $Output      

    FEStock([Object]$Object)
    {
        If ( !$Object ) { Throw "Object is null" }

        $This.Object          = $Object
        $This.Slot            = If ( $Object.Count -eq 1 ) { If ( $Object -match "\[\:\]" ) {0} Else {1}} Else {2}
        $This.Name            = $This.Names[$This.Slot]

        $This.Hash            | % { 

            $This.Head        = $_.Head[$This.Slot]
            $This.Main        = $_.Main[$This.Slot]
            $This.Foot        = $_.Foot[$This.Slot]
            $This.Span        = $_.Span[$This.Slot]
        }

        $This.Body           = @(
            
            If ( $Object.Count -gt 1 )
            {
                ForEach ( $I in 0..( $Object.Count - 1 ) )
                {
                    If ( $Object[$I].GetType().Name -ne "String" )
                    {
                        $This.Line( "-" * 84 )
                        $Object[$I].GetEnumerator() | Sort Name | % { $This.Pair( $_.Name, $_.Value ) }
                    }

                    Else
                    {
                        $This.Line($Object[$I])
                    }
                }
            }

            Else
            {
                If ( $Object.GetType().Name -eq "Hashtable" )
                {
                    $This.Line( "-" * 84 )
                    $Object.GetEnumerator() | Sort Name | % { $This.Pair( $_.Name, $_.Value ) }
                }
                    
                Else
                {
                    $This.Line($Object)
                }
            }
        )

        $This.Theme           = @( )
        ForEach ( $I in 0..( $This.Span.Count - 1 ) )
        {
            $X                = $This.Span[$I]
            $This.Theme      += [FEMask]::New( $I , $X , $This.Hash.String[$X], $This.Hash.Fore[$X], $This.Hash.Back[$X] )
        }

        If ( $This.Slot -in 0,1 )
        {
            $This.Header      = $This.Body
            $This.Height      = 5
        }

        If ( $This.Slot -eq 2 )
        {
            $This.Header      = "Section"
            $This.Footer      = "Press Enter to Continue"
            $This.Height      = ( $This.Body.Count + $This.Span.Count ) - 1
        }

        $This.Process         = @{ }
        $Sort                 = $This.Head, $This.Main, $This.Foot
        $P                    = 0

        ForEach ( $I in 0..( $This.Theme.Count - 1 ) )
        {
            $Item = [Track]::New($I,$This.Theme[$I].Mask,$This.Theme[$I].Foreground,$This.Theme[$I].Background)

            If ( $I -eq $This.Head )
            {
                $Item.Load($This.Header)
                $This.Process.Add($P,$Item)
                $P ++
            }

            If ( $I -eq $This.Foot )
            {
                $Item.Load($This.Footer)
                $This.Process.Add($P,$Item)
                $P ++
            }

            If ( $I -eq $This.Main )
            {
                ForEach ( $Z in 0..( $This.Body.Count - 1 ) )
                {
                    $Item = [FETrack]::New($I,$This.Theme[$I].Mask,$This.Theme[$I].Foreground,$This.Theme[$I].Background)

                    ForEach ( $Q in 0,1,-2,-1)
                    {
                        $Item.Object[$Q] | % { $_.Object = $_.Object.Replace( @("/","\")[$Z % 2], @("\","/")[$Z % 2]) }
                    }

                    $Item.Load($This.Body[$Z])
                    $This.Process.Add($P,$Item)
                    $P ++

                    If ( $This.Body.Count % 2 -eq 0 )
                    {
                        $Item = [FETrack]::New($I,$This.Theme[$I].Mask,$This.Theme[$I].Foreground,$This.Theme[$I].Background)
                        $This.Process.Add($P,$Item)
                        $P ++
                    }
                }
            }

            If ( $I -notin $Sort )
            {
                $Item = [FETrack]::New($I,$This.Theme[$I].Mask,$This.Theme[$I].Foreground,$This.Theme[$I].Background)
                $This.Process.Add($P,$Item)
                $P ++
            }
        }
    }

    [String] Line([String]$Line)
    {
        Return @{          0  = "{0}{1}" -f    $Line, ( " " * (92 -  $Line.Length))
                           1  = "{0}..." -f (  $Line[0..88] -join '') }[[Int]($Line.Length -ge 89)]
    }
    
    [String] Pair([String]$Key,[String]$Value)
    {
        Return @{   0 = @{ 0  = "{0}{1}" -f    $Key,( " " * ( 25 -   $Key.Length ) ) 
                           1  = "{0}..." -f   ($Key[0..21] -join '')}[[Int]($Key.Length -ge 25)]
                    1 = @{ 0  = "{0}{1}" -f  $Value,( " " * ( 64 - $Value.Length ) )
                           1  = "{0}..." -f ($Value[0..60] -join '' ) }[[Int]($Value.Length -ge 64)] } | % { "{0} : {1}" -f $_[0,1] }
    }

    [Void] Draw([Object]$Object)
    {
        ForEach ( $I in 0..( $Object.Count - 1 ) )
        {
            $Track          = $Object[$I].Object
    
            ForEach ( $X in 0..( $Track.Count - 1 ) )
            { 
                @{  
                        Object          = $Track[$X].Object
                        ForegroundColor = @($This.Hash.Colors)[$Track[$X].ForegroundColor]
                        BackgroundColor = $Track[$X].BackgroundColor
                        NoNewLine       = [Bool]( $X -ne ( $Track.Count - 1 ) )
        
                }                       | % { Write-Host @_ }
            }
        }
    }
}