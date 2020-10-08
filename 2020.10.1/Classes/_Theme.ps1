Class _Theme
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
    
    [_Track[]]       $Track
    
    _Theme([Int32]$Slot)
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
            [_Track]::New($I,$This.String[$I],$This.Fore[$I],$This.Back[$I]) 
        }
    }
}
