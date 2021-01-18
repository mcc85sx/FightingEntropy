Class _Install
{
    [Object]                 $OS
    [Object]           $Manifest
    [Object]               $Hive

    [String]               $Name = "FightingEntropy"
    [String]            $Version
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Date = (Get-Date -UFormat %Y_%m%d-%H%M%S)
    [String]             $Status = "Initialized"
    [Object]               $Type
    
    [String]           $Resource
    [Object[]]          $Classes
    [Object[]]        $Functions
    [Object[]]          $Control
    [Object[]]         $Graphics

    Hidden [String[]]      $Load
    Hidden [String]      $Output

    [Object[]] BuildType([String]$Type)
    {
        Return @( ForEach ( $X in $This.Manifest.$($Type) )
        {
            [_RestObject]::New("$($This.Resource)/$Type/$X","$($This.Hive.Path)/$Type/$X")
        })
    }

    BuildTree()
    {
        ForEach ( $Path in $This.Manifest.Folders )
        {
            $Item = $This.Hive.Path,$Path -join "\"

            If ( ! ( Test-Path $Item ) )
            {
                New-Item $Item -ItemType Directory -Force -Verbose
            }
            
            Switch ($Path)
            {
                Classes    { $This.Classes   = $This.BuildType($Path) }
                Functions  { $This.Functions = $This.BuildType($Path) } 
                Control    { $This.Control   = $This.BuildType($Path) }
                Graphics   { $This.Graphics  = $This.BuildType($Path) }
                Default    {}
            }
        }
    }
    
    BuildModule()
    {
        $This.Load              += "# FightingEntropy.psm1 [Module]"
        $This.Load              += ""

            "{0}.AccessControl {0}.Principal Management.Automation DirectoryServices" -f "Security" -Split " " | % { 

            $This.Load          += "using namespace System.$_" 
        }

        $This.Load              += "using namespace Windows.UI.Notifications"
        $This.Load              += ""
        $This.Load              += "Add-Type -AssemblyName PresentationFramework"
        $This.Load              += ""

        ForEach ( $Class in $This.Manifest.Classes )
        { 
            $This.Load          += "<#     Class: $Class"

            $This.Classes        | ? Name -eq $Class | % {
            
                $This.Load      += " #       URI: $( $_.URI  ) "
                $This.Load      += " #      Path: $( $_.Path ) #>"

                $This.Load      += ""
                $This.Load      += $_.Object
            }
        }

        ForEach ( $Function in $This.Manifest.Functions ) 
        {
            $This.Load          += "<#  Function: $Function"

            $This.Functions      | ? Name -eq $Function | % {
            
                $This.Load      += " #       URI: $( $_.URI  ) "
                $This.Load      += " #      Path: $( $_.Path ) #>"
                
                $This.Load      += ""
                $This.Load      += $_.Object
            }
        }

        $This.Output             = $This.Load -join "`n"
        
        Set-Content -Path $This.Hive.Module -Value $This.Output -Force -Verbose
    }
   
    BuildManifest()
    {
        @{  GUID                 = "d2402c18-0529-4e55-919f-ac477c49d4fe"
            Path                 = $This.Hive.Manifest
            ModuleVersion        = $This.Hive.Version
            Copyright            = "(c) 2021 mcc85sx. All rights reserved."
            CompanyName          = "Secure Digits Plus LLC" 
            Author               = "mcc85sx / Michael C. Cook Sr."
            Description          = "Beginning the fight against Identity Theft, and Cybercriminal Activities"
            RootModule           = $This.Hive.Module
            
        }                        | % { New-ModuleManifest @_ }
        
        Switch -Regex ($This.Type)
        {
            "Win32"      { $This.Scaffold("Program Files") } "RHELCentOS" { $This.Scaffold("microsoft") }
        }
    }
    
    Scaffold([String]$String)
    {
        $Tree = "FightingEntropy\{0}" -f $This.Version
        $Path = $This.Hive.PSModule | ? { $_ -match $String }

        $Path, "$Path\FightingEntropy", "$Path\$Tree" | % { 

            If (!(Test-Path $_))
            {
                New-Item -Path $_ -ItemType Directory -Verbose
            }
        }

        Copy-Item $This.Hive.Module   -Destination "$Path\$Tree" -Verbose -Force
        Copy-Item $This.Hive.Manifest -Destination "$Path\$Tree" -Verbose -Force
    }

    _Install([String]$Version)
    {
        $This.Version            = $Version
        $This.OS                 = [_OS]::New()
        $This.Type               = $This.OS.Type
        $This.Manifest           = [_Manifest]::New($Version)
        $This.Hive               = [_Hive]::New([_OS]::New().Type,$Version)

        If ( !(Get-ItemProperty -Path $This.Hive.Root))
        {
            [_Root]::New($This.Hive.Root,$This.Type,"FightingEntropy",$Version,"FEModule",$This.Hive.Path)
        }

        $This.Resource           = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/{0}" -f $Version

        New-PSDrive -Name $This.Name -PSProvider FileSystem -Root $This.Hive.Path -Description $This.Name -Verbose
        
        ForEach ( $Item in "Classes Functions Control Graphics Role" -Split " " )
        {
            If ( ! ( Test-Path FightingEntropy:\$Item ) )
            { 
                New-Item -Path FightingEntropy:\$Item -ItemType Directory -Force -Verbose
            }

            Switch ($Item)
            {
                Classes    { $This.Classes   = $This.BuildType($Item) }
                Functions  { $This.Functions = $This.BuildType($Item) }
                Control    { $This.Control   = $This.BuildType($Item) }
                Graphics   { $This.Graphics  = $This.BuildType($Item) }
            }
        }
       
        $This.BuildModule()
        $This.BuildManifest()
    }
}
