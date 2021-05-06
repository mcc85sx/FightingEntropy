    Class _Postal
    {
        Hidden [Object] $Line
        [String] $Postal
        [String] $City
        [String] $County

        _Postal([String]$Line)
        {
            $This.Line  = $Line -Split "\t"
            $This.Postal = $This.Line[0]
            $This.City   = $This.Line[1]
            $This.County = $This.Line[2]
        }
    }
