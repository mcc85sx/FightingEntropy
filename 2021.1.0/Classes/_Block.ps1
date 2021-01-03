Class _Block 
{
    [String]              $Name
    [Int32]              $Index
    [Object]            $Object
    
    [Int32]    $ForegroundColor
    [Int32]    $BackgroundColor
    [Int32]          $NoNewLine = 1
    
    _Block([Int32]$Index,[String]$Object,[Int32]$ForegroundColor,[Int32]$BackgroundColor)
    {
        $This.Name              = $Index
        $This.Index             = $Index
        $This.Object            = $Object
        $This.ForegroundColor   = $ForegroundColor
        $This.BackgroundColor   = $BackgroundColor
    }
}
