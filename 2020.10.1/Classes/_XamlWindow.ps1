Class _XamlWindow # Originally based on Dr. Weltner's work, but also Jason Adkinson from Pluralsight (His method wasn't able to PassThru variables)
{
    Hidden [String]        $Xaml
    [String[]]            $Names 
    [XML.XMLReader]        $Node
    [Object]               $Host

    _XamlWindow([String]$XAML)
    {   
        If ( !$Xaml )
        {
            Throw "Invalid XAML Input"
        }

        $This.Xaml               = $Xaml
        $This.Names              = ([Regex]"((Name)\s*=\s*('|`")\w+('|`"))").Matches($This.Xaml).Value | % { $_ -Replace "(Name|=|'|`"|\s)","" } | Select-Object -Unique
        $This.Node               = New-Object System.XML.XmlNodeReader([XML]$This.Xaml)
        $This.Host               = [Windows.Markup.XAMLReader]::Load($This.Node)
    
        ForEach ( $I in 0..( $This.Names.Count - 1 ) )
        {
            $This.Host           | Add-Member -MemberType NoteProperty -Name $This.Names[$I] -Value $This.Host.FindName($This.Names[$I]) -Force 
        }
    }

    Invoke()
    {
        $This.Host.Dispatcher.InvokeAsync({
        
            $Output              = $This.Host.ShowDialog()
            Set-Variable -Name Output -Value $Output -Scope Global

        }).Wait()
    }
}
