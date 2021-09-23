
$ID   = "ws3-12065"
$Vm   = Get-VM -Name $ID
$Ctrl = Get-WMIObject -Class MSVM_ComputerSystem -NameSpace Root\Virtualization\V2 | ? ElementName -eq $ID
$Kb   = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.Path.Path)} WHERE resultClass = Msvm_Keyboard" -Namespace root\virtualization\v2

$Kb.TypeKey(119)
Start-Sleep 1
$kb.TypeText("powershell")
$Kb.TypeKey(13)
Start-Sleep 1

$KB.TypeText('$ScriptRoot="X:\Deploy\Scripts";$DeployRoot=$ScriptRoot | Split-Path;$env:PSModulePath="$env:PSModulePath;$DeployRoot\Tools\Modules"')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('Import-Module Storage;Import-Module Microsoft.BDD.TaskSequenceModule;Import-Module PSDDeploymentShare')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('Import-Module PSDGather;Import-Module PSDUtility;Add-Type -AssemblyName PresentationFramework')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('Get-PSDLocalInfo;$mf="X:\Deploy\Tools\Modules\PSDGather\ZTIGather.xml"')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('Invoke-PSDRules -FilePath "X:\Deploy\Scripts\Bootstrap.ini" -MappingFile $mf')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('$tsenv:deployroot=$tsenv:psddeployroots.Split(",")[0];$DeployRoot=$tsenv:deployroot')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('$Connect=@{DeployRoot=$tsenv:deployroot;Username="$tsenv:userdomain\$tsenv:userid";Password=$tsenv:UserPassword}')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('Get-PSDConnection @Connect;$Control=Get-PSDContent -Content Control')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('Invoke-PSDRules -FilePath "$Control\CustomSettings.ini" -mappingfile $mf')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('$Scripts=Get-PSDContent -Content Scripts;$env:ScriptRoot=$Scripts')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('$Modules= Get-PSDContent -Content Tools\Modules;$env:PSModulePath  = "$env:PSModulePath;$Modules"')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('$Drive=Get-PSDrive | ? Provider -match FileSystem | ? Root -eq $DeployRoot.ToString()')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('$TSEnv=@{ };Get-ChildItem TSEnv: | % { $TSEnv.Add($_.Name,$_.Value) }')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('$Root=@{DS=Get-ChildItem DeploymentShare: -Recurse;TSEnv=$TSEnv;Control="$($Drive.Name):\Control";Scripts="$($Drive.Name):\Scripts"}')
$KB.TypeKey(13)
Start-Sleep 3

$KB.TypeText('(Get-Content "$($Root.Scripts)\Invoke-FEWizard.ps1") -join "`n" | IEX;$Result=Invoke-FEWizard $Root')
$KB.TypeKey(13)
Start-Sleep 3
