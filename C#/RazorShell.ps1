
    class Element
    {
        [String]   $String
        [Object]   $Object
        [String]     $Name
        [String] $Property
        [String]    $Value

        Element([String]$String,[Object]$Object,[String]$Name,[String]$Property)
        {   
            $This.String      = $String
            $This.Object      = $Object
            $This.Name        = $Name
            $This.Property    = $Property
        }

        _Value([Object]$Value)
        {
            $This.Value = $Value
        }
    }

    class Stage
    {
        [Object]       $Sheet
        [Object]          $ID
        [String[]]   $Element = "--root","--side","--main","--pixel"
        [Double[]]      $Unit 
        [String[]]      $Name = "#top","#side","body","#main"
        [String[]]  $Property = "display","display","flex-direction","--content"
        [String[]]     $Value
        [Object]      $Output

        Fill([String]$ID)
        {
            $This.Output = @( )

            ForEach ( $X in 0..3 )
            {
                $This.Output += [Element]::New($This.Element[$X],$This.Unit[$X],$This.Name[$X],$This.Property[$X])
            }
        }

        Stage([Object]$Window)
        {
            $This.Sheet       = $Window.Sheet
            $This.ID          = $Window.Sheet.ID
            $This.Unit        = $Window.Width, $Window.Side, $Window.Main, $Window.Pixel

            $This.Fill($This.ID)
        }
    }

    class Sheet
    {
        [Object]     $Stage
		[string]        $ID
        [object[]] $Element

        Sheet([string] $ID)
        {
			$this.ID      = $ID;
            $This.Stage   = [Stage]::New($ID)
            $this.Element = $This.Stage.Output
        }
    }

    class Window
    {
		[uint]       $Wx0 = 0
        [float]    $width = 0
        [uint]       $Hx0 = 0
        [float]   $height = 0
        [float]     $side = 0
        [float]     $main = 0
        [float]    $pixel = 0
        [object]   $Sheet = $Null
        [Object] $Element = $Null
        [Object]    $Unit = $Null

        Window([double]$width, [double]$height)
        {
			$this.Set($width,$height);
        }
		
		[void] Set([double]$width, [double]$height)
		{
			$this.width   = $this.Wx0 = $width;
			$this.height  = $this.Hx0 = $height;
			$this.side    = $width * 0.15;
			$this.main    = $width * 0.85;
			$this.pixel   = $width / 1920;

            $This.Get()
        }

        [void] Get()
        {
            $This.Sheet   = @("Full","Compact")[$This.Width -le 720] | % { [Sheet]::New($_) }
            $This.Element = $This.Sheet.Element
            $This.Unit    = @( )

            ForEach ( $X in 0..($This.Element.Count - 1 ) )
            {
                $Item = $This.Element[$X]

                Switch($This.Sheet.ID)
                {
                    Compact
                    {
                        $Item._Value(@("none","flex","row","$($This.Main)px")[$X])
                    }

                    Full
                    {
                        $Item._Value(@("flex","none","column","$($This.Width)px")[$X])
                    }
                }

                $This.Unit += $Item
            }
        }

		[void] Print()
		{
			[Console]::WriteLine("     [Width] = [" + $this.width +"]");
			[Console]::WriteLine("    [Height] = [" + $this.height +"]");
			[Console]::WriteLine("      [Side] = [" + $this.side +"]");
			[Console]::WriteLine("      [Main] = [" + $this.main +"]");
			[Console]::WriteLine("     [Pixel] = [" + $this.pixel +"]");
		}
}
