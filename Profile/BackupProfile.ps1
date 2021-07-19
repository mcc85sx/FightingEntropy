Class UserProfile
{
    [String]        $Name 
    [String]        $Path 
    [String]        $Date
    [Object]        $File
    [Object]        $Hash
    [String]    $Hostname
    [Object]      $Hidden
    [Object]        $Tree
    [Object]       $Stack
    Hidden [Object] $Size_
    [Object]        $Size
    [Object]        $Fail
    UserProfile([String]$Path)
    {
        If (!(Test-Path $Path))
        {
            Throw "Invalid path"
        }

        $This.Hash      = @{ }
        $This.Name      = $Path | Split-Path -Leaf
        $This.Path      = $Path
        $This.Date      = Get-Date -UFormat %Y_%m%d_%H%M%S
        $This.File      = "({0})({1})({2}_{3})" -f $This.Date,$Env:ComputerName,$Env:UserDomain,$This.Name

        $This.Hostname  = $Env:ComputerName
        $This.Hidden    = Get-ChildItem $Path -Directory | ? Name -match "^\.\w+$"
        $This.Tree      = Get-ChildItem $Path -Directory | ? Name -notin $This.Hidden.Name
        $This.Size_     = $This.Tree | Get-ChildItem -Recurse | Measure-Object -Property Length -Sum | % Sum
        $This.Size      = "{0:n2}MB" -f ([Double]$This.Size_/1MB)
        $This.Fail      = @()
    }
    Create([String]$NewPath)
    {
        Write-Host "Creating [~] Temp folder"

        If ( $NewPath -match "^\\\\.+" )
        {
            If (!(Get-PSDrive | ? Root -ieq $NewPath))
            {
                New-PSDrive -Name Profile -PSProvider Filesystem -Root $NewPath
            } 

            $Root = Get-PSDrive | ? Root -eq $NewPath | % { "{0}:" -f $_.Name }
        }

        Else
        {
            $Root = $NewPath
        }

        $Store = "$Root\$($This.File)"

        If (!(Test-Path $Store))
        {
            New-Item -Path $Root -Name $This.File -ItemType Directory -Verbose
        }

        $Paths = $This.Tree | Get-ChildItem -Directory -Recurse
        ForEach ( $Item in $Paths )
        {
            New-Item -Path $Item.FullName.Replace($This.Path,$Store) -ItemType Directory -Verbose
        }

        $X     = -1
        $Files = $This.Tree | Get-ChildItem -File -Recurse
        ForEach ( $Item in $Files )
        {
            $X ++
            $Dest = $Item.FullName.Replace($This.Path,$Store)
            Write-Progress -Activity Copying -Status $Item.Name -PercentComplete (($X/$Files.Count)*100)
            Write-Host "File: $($Item.FullName)"
            Write-Host "Dest: $Dest"
            Try 
            {
                Copy-Item -Path $Item.Fullname -Destination $Dest -Verbose -EA 0
            }

            Catch
            {
                $this.Fail += "[-] $($Item.FullName)"
            }
        }
    }
}

If ( Get-CimInstance Win32_ComputerSystem | % PartOfDomain -eq $True )
{
    $Local  = Get-ADUser -Filter * | % SamAccountName
}
Else
{
    $Local  = Get-LocalUser
}

$Users  = $Env:Userprofile.Replace("\$Env:Username","")
$Names  = Get-ChildItem $Users | ? Name -in $Local | % { "($_\.*\w*)"}
$Search = $Names | % { Get-ChildItem $Users | ? Name -match $_ }
$List   = $Search.FullName | % { [UserProfile]::New($_) }
