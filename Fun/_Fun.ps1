Class _Fun
{
    [String] $Name
    [String] $Url
    [Object] $Content

    _Fun([String]$Name)
    {
        $This.Name = $Name
        $This.Url  = "https://github.com/mcc85sx/FightingEntropy/blob/master/Fun/$Name.txt?raw=true"
        $This.Content = Invoke-WebRequest $This.Url -UseBasicParsing | % Content
    }
}
