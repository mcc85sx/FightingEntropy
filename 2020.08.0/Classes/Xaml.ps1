

Class XamlNames
{
    [String]   $Xaml
    [String[]] $Names

    XamlNames([String]$Xaml)
    {
        If ( !$Xaml )
        {
            Throw "Xaml invalid/null"
        }

        $This.Xaml  = $Xaml
        $This.Names = ([Regex]"((Name)\s*=\s*('|`")\w+('|`"))").Matches($This.Xaml).Value | % { $_ -Replace "(Name|=|'|`"|\s)","" }
    }
}

Class XamlObject
{
    [String]           $Xaml
    [String[]]        $Stack
    [Array]           $Array

    [String]          $Drive = "FE:"
    [String]         $Parent
    [String]           $Path

    [String]          $Track
    [String]           $Last = "@"
    [String]           $Type

    [String]            $Tag
    [String]           $Name

    Hidden [Int32]    $Index        
    Hidden [Hashtable] $Hash = @{
        
        FormatStart          = "(\s*=\s*),(\s+),(> <),(`"\s*/>),([*])" -Split ","
        FormatEnd            = "=, ,>`n<,`"/>,&star;" -Split ","
        CharStart            = "quot amp apos star lt gt" -Split " " | % { "&$_;" }
        CharEnd              = 34,38,39,42,60,62 | % { "&#$_;" }
        SpaceStart           = '"\s+,`"\s+/>,"\s+[>]' -Split ","
        SpaceEnd             = '" ,"/>,">' -Split ","
    }

    [String] GetName([String]$Track)
    {
        Return $Track.Split(" ")[0] -Replace "<","" -Replace "/","" -Replace ">",""
    }

    XamlObject([String]$Xaml)
    {
        $This.Xaml           = $( If ( ([Regex]'"').Matches($Xaml).Count -gt ([Regex]"'").Matches($Xaml).Count )
        {
            $Xaml -Replace "'","&apos;"
        }

        Else
        {
            $Xaml -Replace "'",'"'
        })

        ForEach ( $I in 0..( $This.Hash.FormatStart.Count - 1  ) )
        {
            $This.Xaml       = $This.Xaml -Replace $This.Hash.FormatStart[$I], $This.Hash.FormatEnd[$I] 
        }
        
        ForEach ( $I in 0..( $This.Hash.CharStart.Count - 1  ) )
        {
            $This.Xaml       = $This.Xaml -Replace $This.Hash.CharStart[$I], $This.Hash.CharEnd[$I]
        }

        ([Regex]"(&#x)+([0-9A-Fa-f]*;)").Matches($This.Xaml).Value | Select -Unique | % { 

            $This.Xaml       = $This.Xaml -Replace $_, ( "&#{0};" -f ( IEX ( $_.Replace( "&#","0" ).Replace( ";" , "" ) ) ) )
        }

        ForEach ( $I in 0..( $This.Hash.SpaceStart.Count - 1 ) )
        {
            $This.Xaml       = $This.Xaml -Replace $This.Hash.SpaceStart[$I] , $This.Hash.SpaceEnd[$I]
        }

        $This.Xaml           = $This.Xaml | ? { $_.Length -gt 0 }
        $This.Stack          = $This.Xaml -Split "`n"
        $This.Array          = @( )

        ForEach ( $I in 0..( $This.Stack.Count - 1 ) )
        {
            $This.Track      = $This.Stack[$I]

            $This.Type       = Switch -Regex ($This.Track) { "(<[^/].+[^/]>)" { "+" } "(/>)" { "/" } "(</)" { "-" } }

            $This.Tag        = $This.Track.Split(" ")[0]

            $This.Name       = $This.Tag -Replace "<","" -Replace "/","" -Replace ">",""

            $This.Parent     = Switch ($This.Last)
            { 
                "@"            {            $This.Drive  }
                "+"            {            $This.Path   }
                "/"            {            $This.Parent }
                "-"            { Try { Split-Path $This.Parent } Catch { $This.Drive } }
            }

            If ( $This.Type -eq "-" )
            {
                If ( $This.Tag -match "(</)" )
                {
                    $This.Parent = Try { Split-Path $This.Parent } Catch { "FE:" }
                }

                If ( $This.Tag -match "(/>)" )
                {
                    $This.Parent = Try { Split-Path $This.Path } Catch { "FE:\Window" }
                }
            }

            $This.Path       = "{0}\{1}" -f $This.Parent, $This.Name

            $This.Array     += [XamlTrack]::New($I,$This.Drive,$This.Parent,$This.Path,$This.Track,$This.Tag,$This.Last,$This.Type,$This.Name)

            $This.Last       = $This.Type
        }
    }
}

Class XamlTrack
{
    [Int32]           $Index
    [String]          $Drive
    [String]         $Parent
    [Object]           $Path
    [Object]          $Track
    [String]            $Tag
    [String]           $Name
    [String]           $Last
    [String]           $Type
    [Int32]           $Depth
    [Object]       $Property

    XamlTrack([Int32]$Index,[String]$Drive,[String]$Parent,[String]$Path,[String]$Track,[String]$Tag,[String]$Last,[String]$Type,[String]$Name)
    {
        If ( $Index.GetType().Name -ne "Int32" )
        {
            Throw "Invalid Index"
        }

        $This.Index          = $Index
        $This.Drive          = $Drive
        $This.Parent         = $Parent
        $This.Path           = $Path
        $This.Track          = $Track
        $This.Tag            = $Tag
        $This.Last           = $Last
        $This.Type           = $Type
        $This.Name           = $Name
        $This.Depth          = $This.Path.Split("\").Count - 2
        $This.Property       = $This.Prop($Track,$Tag)
        
    }

    [Hashtable] Prop([String]$Track,[String]$Tag)
    {
        $Item                = $Track.Replace("$Tag ","").Replace("`">","`"").Replace("`" ","`"`n").Split("`n")

        $Prop                = @{ }

        If ( $Item.Count -eq 1 )
        {
            $Key             = $Item.Split("=")[0]
            $Value           = $Item.Replace("$Key=","")

            $Prop.Add($Key,$Value)
        }

        If ( $Item.Count -gt 1 )
        {
            ForEach ( $I in 0..( $Item.Count - 1 ) )
            {
                $Key         = $Item[$I].Split("=")[0]
                $Value       = $Item[$I].Replace("$Key=","")
                
                If ( $Key -notin $Prop.Keys )
                {
                    $Prop.Add($Key,$Value)
                }
            }
        }

        Else
        {
            $Prop            = $Null
        }

        Return $Prop
    }
}


Class XamlWindow
{
    [Object]           $Window
    [Object]             $Xaml
    [Object]       $NodeReader
    [String[]]       $Assembly = ("{0}Framework {0}Core WindowsBase" -f "Presentation").Split(" ")
    [Object]           $Output
    [Object]           $Window
    
    XamlWindow([String]$Xaml,[String[]]$NamedElements)
    {
        If ( !$NamedElements )
        {
            Throw "Named Elements is null"
        }

        $This.Assembly         | % { Add-Type -AssemblyName $_ }
        $This.Xaml             = ([IO.StringReader]$Xaml)
        $This.NodeReader       = [XML.XMLReader]::Create($This.Xaml)
        $This.Output           = [Windows.Markup.XAMLReader]::Load($This.NodeReader)

        $NamedElements         | % { $This.Output | Add-Member -MemberType NoteProperty -Name $_ -Value $This.Output.FindName($_) -Force }

        $This.Window           = [Windows.Window]::Load($This.Output)

        [Void]$This.Window.Dispatcher.InvokeAsync{$This.Window.ShowDialog()}.Wait() 
    }
}