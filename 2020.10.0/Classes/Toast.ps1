Class Cache
{
    [String] $Path
    [Object] $File

    Cache([Object]$Image)
    {
        Switch -Regex ($Image)
        {
            "http[s]*://" 
            {
                [Net.ServicePointManager]::SecurityProtocol = 3072
                $This.Path            = $Image
                $This.File            = "$Env:Temp{0}" -f (Split-Path -Leaf $Image)
                Invoke-WebRequest -URI $This.Path -OutFile $This.File #| ? StatusDescription -ne OK | % { Throw "Exception" }
                $This.Path            = "file:///{0}" -f $This.File.Replace("\","/")
            }
                
            "(\w+:\\\w+)"
            {
                If ( ! ( Test-Path $Image ) )
                {
                    Throw "Invalid path to image" 
                }

                $This.Path            = "file:///{0}" -f $Image.Replace("\","/")
            }

            "(ms-app)+([x|data])+(:///)"
            {
                Throw "ms-app* Not yet implemented"
            }
        }
    }
}

Class Toast
{
    [Validateset(1,2,3,4)]
    [Int32]             $Type

    [Object]         $Message
    [String]            $GUID
    [String]            $Time = (Get-Date)
    [Cache]             $File

    [String]          $Header
    [String]            $Body
    [String]          $Footer

    Hidden [Hashtable]  $Temp
    Hidden [Int32] $TempCount
    [String]        $Template
    [Object]             $XML
    [Object]           $Toast
        
    Toast([Int32]$Type,[Object]$Message,[String]$GUID)
    {
        $This.Type       = $Type
        $This.Message    = $Message
        $This.GUID       = $GUID
        $This.File       = $Null
        $This.Load()
    }

    Toast([Int32]$Type,[Object]$Message,[String]$GUID,[String]$File)
    {
        $This.Type       = $Type
        $This.Message    = $Message
        $This.GUID       = $GUID
        $This.File       = [Cache]::New($File)
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