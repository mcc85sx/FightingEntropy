# Backs up user profiles. Searches for potential user accounts, and then looks through environment variables to obtain user profile paths
Class UserItem
{
    Hidden [Object] $Item
    [String] $Name
    [String] $Type
    [String] $Date
    [String] $Label
    [String] $Source
    [String] $Destination
    UserItem([Object]$Item,[String]$Destination)
    {
        $This.Item  = $Item
        $This.Name  = $Item.Name
        $This.Type  = $Item.GetType().Name
        $This.Date  = $Item.Date
        $This.Label = $Item.Label
    }
}

Class UserProfile
{
    [String]        $Name 
    [String]        $Path 
    [String]        $Date
    [String]    $Hostname
    [String]    $UserName
    [String]       $Label
    [Object]     $Profile
    [Object]      $Hidden
    [Object]       $Story
    [Object]     $DirList
    [String]        $Dest
    Hidden [Object] $Size_
    [Object]        $Size
    [Object]        $Fail
    UserProfile([String]$Path)
    {
        If (!(Test-Path $Path))
        {
            Throw "Invalid path"
        }

        $This.Name      = $Path | Split-Path -Leaf
        $This.Path      = $Path
        $This.Date      = Get-Date -UFormat %Y_%m%d_%H%M%S
        $This.Hostname  = $Env:ComputerName
        $This.UserName  = "{0}_{1}" -f $Env:UserDomain,$This.Name
        $This.Label     = "({0})({1})({2})" -f $This.Date,$This.HostName,$This.Username
        $This.Profile   = Get-ChildItem $Path -Recurse
        $This.Hidden    = Get-Item $Path\* | ? Name -match ^\.\w+$ | % Fullname
        $This.Story     = Get-Item $Path\* | ? FullName -notin $This.Hidden | Get-ChildItem -Recurse
        $This.DirList   = $This.Story.DirectoryName | Select-Object -Unique
        $This.Size_     = $This.Profile | Measure-Object -Property Length -Sum | % Sum
        $This.Size      = "{0:n2}MB" -f ([Double]$This.Size_/1MB)
        $This.Fail      = @()
    }
    Copy([String]$From,[String]$To)
    {
        If ( Get-Item $From | ? Length -gt 1MB )
        {
            $FrFile = [System.IO.File]::OpenRead($From)
            $ToFile = [System.IO.File]::OpenWrite($To)
            Write-Progress -Activity Copying -Status "$From -> $To" -PercentComplete 0
            Try
            {
                [Byte[]]$Buff = [Byte[]]::New(4096)
                [Long] $Total = [Int]$Count = 0
                Do
                {
                    $Count    = $FrFile.Read($Buff,0,$Buff.Length)
                    $ToFile.Write($Buff,0,$Count)
                    $Total += $Count
                    If ( $Total % 1mb -eq 0)
                    {
                        Write-Progress -Activity Copying -Status "$From -> $To" -PercentComplete ([Long]($Total*100/$FrFile.Length))
                    } 
                }
                While ($Count -gt 0)
            }
            Finally
            {
                $FrFile.Dispose()
                $ToFile.Dispose()
                Write-Progress -Activity Copying -Status "$From -> $To" -Completed
            }
        }
        Else
        {
            Copy-Item -LiteralPath $From -Destination $To -Verbose
        }
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

        $Store = "$Root\$($This.Label)"

        If (!(Test-Path $Store))
        {
            New-Item -Path $Root -Name $This.Label -ItemType Directory -Verbose
        }

        ForEach ( $Directory in $This.DirList )
        {
            $xDest = $Directory.Replace($This.Path,$Store)
            New-Item -Path $xDest -ItemType Directory -Verbose
        }

        ForEach ( $File in $This.Story | ? { $_.GetType().Name -eq "FileInfo" } | % FullName )
        {
            $xDest = $File.Replace($This.Path,$Store)
            $this.Copy($File,$xDest)
        }
    }
}

If ( Get-CimInstance Win32_ComputerSystem | % PartOfDomain )
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

# To transfer everything, use this function, replace "DESTINATION" with a SMB/FileSystem path
# $List[$X].Create("DESTINATION")
