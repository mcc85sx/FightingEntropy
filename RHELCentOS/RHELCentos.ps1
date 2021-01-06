Class RHELCentOS
{
    [Object] $Apache
    [Object] $PostFix
    [Object] $RoundCube

    RHELCentOS()
    {
        $This.Apache    = [Apache]::New()
        $This.PostFix   = [PostFix]::New("192.168.1.0/24")
        $This.RoundCube = [RoundCube]::New()
    }
}
