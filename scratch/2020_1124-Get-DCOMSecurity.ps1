Function Get-DCOMSecurity # Cause who likes looking at MMC -> Add-SnapIn -> Component Services...?
{
    <#
        .SYNOPSIS

            Enumerate DCOM Security Settings
            Original Author: Matt Pichelmayer
            Current Author: Michael C. Cook Sr.
          
        .DESCRIPTION
            
            This script is used to enumerate security settings based on WMI information from the Win32_DCOMApplication, 
            Win32_DCOMApplicationAccessAllowedSetting, and Win32_DCOMApplicationLaunchAllowedSetting for detecting 
            lateral movement avenues.  
            
            You can also use it to prove what grade of badass you are, at detecting threats.
            This version has optimized the process created by the original author, Picheljitsu.
            The process used to take several minutes.
            Now it takes like 6 seconds.
            Because process optimization is key to efficiency.
            
            For more information on DCOM-based lateral movement concept, refer to the 
            following article: https://enigma0x3.net/2017/01/23/lateral-movement-via-dcom-round-2/

        .PARAMETER ComputerName

            If using this script locally, you can direct it to run against a remote workstation using the ComputerName 
            argument.  If omitted, the local workstation is assumed.
  
        .EXAMPLE
    
            PS C:\> Get-DCOMSecurity
    		
            Enumerates DCOM security settings on the local computer
   
        .EXAMPLE
    
            PS C:\> Get-DCOMSecurity -ComputerName <hostname>
    		
            Enumerates DCOM security settings on a remote computer
    #>

    [CmdletBinding()]
    param([parameter(Mandatory=$false)][string]$ComputerName='.')

    Class Principal
    {
        [String]            $AppID
        [String]             $Name
        [Object[]]         $Access
        [Object[]]         $Launch

        Principal([String]$Name,[String]$AppID)
        {
            $This.Name             = $Name
            $This.AppID            = $AppID.ToUpper()
            $This.Access           = @( )
            $This.Launch           = @( )
        }
    }

    Class Setting
    {
        Hidden [Int32]      $Index
        Hidden [Object]      $Base
        [String]            $AppID
        [String]              $SID
        [String]        $Principal

        [String] Strip([String]$Input)
        {
            Return ( $Input.Split("=")[1] -Replace '"',"" )
        }

        [Object] GetSID ([String]$SID)
        {
            Return @( Try {[System.Security.Principal.SecurityIdentifier]::New($SID).Translate([System.Security.Principal.NTAccount]).Value } Catch {"-"} )
        }

        Setting([Int32]$Index,[Object]$Base)
        {
            $This.Index     = $Index
            $This.Base      = $Base
            $This.AppID     = $This.Strip($Base.Element).ToUpper()
            $This.SID       = $This.Strip($Base.Setting)
            $This.Principal = $This.GetSID($This.SID)
        }
    }

    Class DCOM
    {
        [String[]]  $Names = ( "{0};{0}Access{1};{0}Launch{1}" -f "dcomapplication","AllowedSetting" -Split ";" )
        [String]    $ComputerName
        [Object[]]  $Apps_
        [Object[]]  $Apps
        [Object[]]  $Access_
        [Hashtable] $Access__
        [Object[]]  $Access
        [Object[]]  $Launch_
        [Hashtable] $Launch__
        [Object[]]  $Launch
        [Object[]]  $Output

        DCOM([String]$ComputerName)
        {
            [Console]::WriteLine("   Host: {0}" -f $ComputerName)
            $This.ComputerName   = $ComputerName

            [Console]::WriteLine("   Apps: {0}" -f $This.Names[0])
            $This.Apps_          = $This.WMI(0)
            $This.Apps           = $This.Apps_   | % { [Principal]::New($_.Name, $_.AppID) }

            [Console]::WriteLine(" Access: {0}" -f $This.Names[1])
            $This.Access_        = $This.WMI(1) 
            $This.Access         = $This.SetIndex($This.Access_)

            $This.Access__       = @{ }
            ForEach ( $App in $This.Access )
            {
                If ( ! ($This.Access__["$( $App.AppID )"]) ) { $This.Access__.Add($App.AppID,@( )) }
                $This.Access__["$($App.AppID)"] += $App
            }       

            [Console]::WriteLine(" Launch: {0}" -f $This.Names[2])
            $This.Launch_        = $This.WMI(2)
            $This.Launch         = $This.SetIndex($This.Launch_)

            $This.Launch__       = @{ }
            ForEach ( $App in $This.Launch )
            {
                If ( ! ($This.Launch__["$( $App.AppID )"]) ) { $This.Launch__.Add($App.AppID,@( )) }
                $This.Launch__["$($App.AppID)"] += $App
            }   

            [Console]::WriteLine("   Sorting...")
            ForEach ( $I in 0..( $This.Apps.Count - 1 ) )
            {
                $Item            = $This.Apps[$I]
                If ( $Item.AppID -in $This.Access__.Keys ) { $This.Access__["$($Item.AppID)"] | % { $Item.Access += $_ } }
                If ( $Item.AppID -in $This.Launch__.Keys ) { $This.Launch__["$($Item.AppID)"] | % { $Item.Launch += $_ } }
                $This.Output    += $Item
            }
        }

        [Object] GetSID ([String]$SID)
        {
            Return @( Try {[System.Security.Principal.SecurityIdentifier]::New($SID).Translate([System.Security.Principal.NTAccount]).Value } Catch {"-"} )
        }

        [Object[]] SetIndex ([Object[]]$Object)
        {
            Return @( ForEach ( $I in 0..( $Object.Count - 1 ) ) { [Setting]::New($I,$Object[$I]) } )
        }

        [Object[]] WMI ([Int32]$Slot)
        {
            $Item              = "\\{0}\ROOT\CIMV2:win32_{1}" -f $This.ComputerName, $This.Names[$Slot]
            Return ([WMIClass]$Item).GetInstances()
        }
    }

    [DCOM]::New($ComputerName).Output
}
