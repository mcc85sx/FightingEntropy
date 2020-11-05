Class _XamlGlossaryItem
{
    [Int32]                   $Index
    [String]               $Variable
    [String]                   $Name

    _XamlGlossaryItem (
    [Int32]                   $Index ,
    [String]               $Variable ,
    [String]                   $Name )
    {
        $This.Index    =      $Index
        $This.Variable =   $Variable
        $This.Name     =       $Name
    }
}
