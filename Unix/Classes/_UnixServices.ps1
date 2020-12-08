Class _UnixServices
{
    Hidden [Object] $Services = (systemctl list-units --type=service)
    [Object] $Output

    _UnixServices()
    {
        $This.Output = @( )

        ForEach ( $Index in 0..( $This.Services.Count - 1 ) )
        {
            $Item = $This.Services[$Index] 
            If ( $Item -match "(.service)" )
            {
                $This.Output += [_UnixService]::New($Item)
            }
        }
    } 
}
