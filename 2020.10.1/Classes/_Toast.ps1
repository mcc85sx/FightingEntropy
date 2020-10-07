# _Cache

Class _Toast
{
    [Validateset(1,2,3,4)]
    [Int32]             $Type

    [Object]         $Message
    [String]            $GUID
    [String]            $Time = (Get-Date)
    [_Cache]             $File

    [String]          $Header
    [String]            $Body
    [String]          $Footer

    Hidden [Hashtable]  $Temp
    Hidden [Int32] $TempCount
    [String]        $Template
    [Object]             $XML
    [Object]           $Toast
        
    _Toast([Int32]$Type,[Object]$Message,[String]$GUID)
    {
        $This.Type       = $Type
        $This.Message    = $Message
        $This.GUID       = $GUID
        $This.File       = $Null
        $This.Load()
    }

    _Toast([Int32]$Type,[Object]$Message,[String]$GUID,[String]$File)
    {
        $This.Type       = $Type
        $This.Message    = $Message
        $This.GUID       = $GUID
        $This.File       = [_Cache]::New($File)
        $This.Load()
    }

    Load()
    {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
        [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime]
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

        $This.Temp            = @{ }
        $This.TempCount       = 0

        $This.Temp.Add($This.TempCount++,"<toast>")
        $This.Temp.Add($This.TempCount++,"_<visual>")

        @( Switch ([Int32]($This.File -ne $Null))
        {  
            0 { $This.Temp.Add($This.TempCount++,"__<binding template=`"ToastText0$($This.Type)`">;")  }
            1 { $This.Temp.Add($This.TempCount++,"__<binding template=`"ToastImageAndText0$($This.Type)`">;")
                    $This.Temp.Add($This.TempCount++,"___<image id=`"1`" src=`"$($This.File.Path)`" alt=`"$($This.File.Path)`"/>;") }
        })

        @( Switch ([Int32]($This.Type))
        {
            1 { 1 } 
            2 { 1,2 } 
            3 { 1,2,3 } 
            4 { 1,2,3 } 
            
        }) | % { $This.Temp.Add($This.TempCount++,"___<text id=`"$_`">{$($_-1)}</text>" ) } 

        $This.Temp.Add($This.TempCount++,"__</binding>")
        $This.Temp.Add($This.TempCount++,"_</visual>")
        $This.Temp.Add($This.TempCount++,"</toast>")
            
        $This.Template        = ( $This.Temp.GetEnumerator() | Sort Name | % Value ).Replace("_","    ") -join "`n"
    }

    GetXML()
    {
        $This.XML             = [Windows.Data.Xml.Dom.XmlDocument]::new()
        $This.XML.LoadXml($This.Template)
        $This.Toast           = [Windows.UI.Notifications.ToastNotification]::new($This.XML)
    }

    ShowMessage()
    {
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($This.GUID).Show($This.Toast)
    }
}