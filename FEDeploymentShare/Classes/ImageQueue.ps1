Class ImageQueue
{
    [String]  $Name
    [String]  $FullName
    [String]  $Index
    [String]  $Description
    ImageQueue([String]$FullName,[String]$Index,[String]$Description)
    {
        If (!$FullName -or !$Index)
        {
            Throw "Invalid selection"
        }

        $This.Name          = $FullName | Split-Path -Leaf
        $This.FullName      = $FullName
        $This.Index         = $Index
        $This.Description   = $Description
    }
}