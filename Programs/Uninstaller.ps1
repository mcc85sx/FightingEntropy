# Testing... 
Write-Host "Querying [~] Registry: Uninstall Path"
$Arch     = @{AMD64 = 0..1; x86 = 0}[$Env:Processor_Architecture]
$Path     = @("","\WOW6432Node" | % {"HKLM:\Software$_\Microsoft\Windows\CurrentVersion\Uninstall"})[$Arch]
$Reg      = $Path | % { Get-ItemProperty "$_\*" }

$Search   = "Teamviewer" # or whatever program...
$Result   = $Reg | ? DisplayName -match $Search
$FilePath = @(If (!$Result.QuietUninstallString) {$Result.UninstallString} Else {$Result.QuietUninstallString})

If ( $FilePath -imatch "(msiexec).(exe)*" )
{
    $Argument = [Regex]::Matches($FilePath,"(\/\w\{.+\})").Value
    $Strip    = $FilePath.Replace($Argument,"").TrimEnd(" ")
    $Argument = "/X{0} /qn /passive /norestart" -f [Regex]::Matches($Argument,"(\{.+\})").Value
    $FilePath = $Strip
}

If ( $FilePath -notmatch "msiexec" )
{
    $Strip    = [Regex]::Matches($FilePath,"(\'|\`").+(\'|\`")").Value
    $Argument = $FilePath.Replace($Strip,"").TrimStart(" ")
    If ($Argument -ne "" )
    {
        $FilePath = $Filepath.Replace($Argument,"")
    }

    If (!$Argument)
    {
        $Argument = "/S"
    }
}

If ($Argument)
{
    $Time                         = [System.Diagnostics.Stopwatch]::StartNew()
    
    Write-Host "Starting [~] [$Filepath]/[$Argument]"

    $Process                      = Start-Process -FilePath "$($FilePath)" -ArgumentList $Argument -PassThru 
    While(!$Process.HasExited)
    {
        Write-Progress -Activity $Result.DisplayName -Status Removing
        Start-Sleep 1
    }

    Write-Host "[$($Time.Elapsed)] Complete"
}

If (!$Argument)
{
    $Process                      = Start-Process -FilePath "$($FilePath)" -PassThru
    Do
    {
        Write-Progress -Activity $Result.DisplayName -Status Removing
        Start-Sleep 1
        
    }
    Until($Process)
}
