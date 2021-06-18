Class _Item
{
    [String]$Type
    [String]$Path
    [String]$Name
    [Object]$Content
    _Item([Object]$Type,[String]$Path,[Object]$Name)
    {
        $This.Type = $Type
        $This.Path = "$Path/$Name"
        $This.Name = $Name
    }
}

$Credential   = Get-Credential
$Computername = Read-Host "Enter computername"
$Keyfile      = Read-Host "Enter keyfile path"

new-sshsession -computername $ComputerName -keyfile $Keyfile -Credential $Credential
$ID = Get-SSHSession | % SessionID
Invoke-SSHCommand -SessionID $ID -Command "cd .."
Invoke-SSHCommand -SessionID $ID -Command "cd .."

$List = Invoke-SSHCommand -SessionID $ID -Command "ls -R /" | % Output

$Stack = @( ) 

ForEach ( $X in 0..($List.Count - 1 ) )
{
    $Item = $List[$X]
    Write-Progress -Activity "Checking $($Item.Name)" -PercentComplete (($X/$List.Count)*100)

    If ( $Item.Length -gt 0 )
    {
        Switch -regex ($Item)
        {
            "(\w+\:)"
            {
                $Path = $Item -Replace ":",""
                $File = [_Item]::New("Folder",$Path,$Item)
            }
            Default
            {   
                $File = [_Item]::New("File",$Path,$Item)
            }
        }

        Write-Host $File.Path
        $Stack += $File
    }
}

Set-Content "$Home\Desktop\test.txt" -Value @( 
ForEach ($X in 0..($Stack.Count-1))
{
    $Item = $Stack[$X]
    "0x{0:X6}" -f $X
    $Item.Type

    Switch($Item.Type)
    {
        Folder
        {
            $Item.Path = $Item.Name
            $Item.Name = $Item.Name.Split("/")[-1]
        }

        Default 
        {

        }
    }
    $Item.Name,
    $Item.Path,
    " "
})
