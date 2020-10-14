Function Show-ToastNotification
{
    [CmdLetBinding(DefaultParameterSetName="Text")]Param(
        [ValidateSet(1,2,3,4)]
        [Parameter(ParameterSetName= "Text",Position=0)]
        [Parameter(ParameterSetName="Image",Position=0)]                                 [Int32]    $Type ,
        [Parameter(ParameterSetName="Image",Position=1,HelpMessage=     "Web/File Path")][String]  $Image ,
        [Parameter(ParameterSetName= "Text",Position=1,HelpMessage= "New/Existing GUID")]
        [Parameter(ParameterSetName="Image",Position=2,HelpMessage= "New/Existing GUID")][String]   $GUID = (New-GUID),
        [Parameter(ParameterSetName= "Text",Position=2,HelpMessage=            "Header")]
        [Parameter(ParameterSetName="Image",Position=3,HelpMessage=            "Header")][String] $Header ,
        [Parameter(ParameterSetName= "Text",Position=3,HelpMessage=              "Body")]
        [Parameter(ParameterSetName="Image",Position=4,HelpMessage=              "Body")][String]   $Body ,
        [Parameter(ParameterSetName= "Text",Position=4,HelpMessage=              "Foot")]
        [Parameter(ParameterSetName="Image",Position=5,HelpMessage=              "Foot")][String] $Footer )

    $Return                       = Switch([Int32]($Image -eq $Null)) 
    { 
        0 { [_Toast]::New($Type,$Message,$GUID,$Image) } 
        1 { [_Toast]::New($Type,$Message,$GUID) }
    }
    
    $Return.Header                = If ( $Header -eq $Null ) {    "Message" } Else { $Header }
    $Return.Body                  = If ( $Body   -eq $Null ) {        $GUID } Else { $Body   }
    $Return.Footer                = If ( $Footer -eq $Null ) { $Return.Time } Else { $Footer }

    $Return.Template              = $Return.Template -f $Return.Header, $Return.Body, $Return.Footer
    $Return.GetXML()
    $Return.ShowMessage()
}
