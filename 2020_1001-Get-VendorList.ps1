# https://linuxnet.ca/ieee/oui/nmap-mac-prefixes

# This file gets updated quite often, rather than to have a static link to a 500kb file that gets rate 
# limited if you query the file too many times (as I was able to demonstrate at the beginning of the 
# video I made when I wrote this) I thought to make a script/program that could split this file and 
# remove common denominators.
#
# To the untrained programmer, probably doesn't seem like much of a big deal, link to the 500KB file, call it
# a day. To the seasoned programmer... that just won't do! 
#
# Call it attention to detail, or call it 'wanting to cram that 500kb file into as small of a footprint as 
# possible...'... I've achieved 200KB, that's about 60% of the original file size.

# Now, bragging about a small file size...? Probably a dumb idea unless of course, you weigh the idea..

# Smaller file sizes mean that the computer has to work less hard.
# Depending on how you want the program to tax a system... you can 'hide' the work in the CPU, the Memory, or
# the hard drive. Rarely will a program like this run 'faster' if you save it to a file...

# But, the manner in which you could save the file.

# Sample "nmap-mac-prefixes.txt" output
# 000000  Xerox

# What if I want to reference a vendor name that's listed in this file multiple times?
# That would make a huge impact on the file size, if it can be offset and somehow massively reduce the number 
# of characters saved in the text file.

# I made this script to parse the objects and STILL get the correct translations, 27,000 lines is not a real
# small number to work with. Might as well pretend as if it is infinity, and then, try to work with the object
# as a string, because regex is awesome like that. Which is what I did.

  $Path                   = #"https://linuxnet.ca/ieee/oui/nmap-mac-prefixes"
                              "C:\Users\User\nmap-mac-prefixes.txt"

    If ( $Path -match "(http[s]*)" )
    {
        $File = Invoke-WebRequest -URI $Path
        
        If ( ! $File )
        {
            Throw "Invalid URL"
        }

        $File = $File.Content
    }

    Else
    {
        If ( ! ( Test-Path -Path $Path ) )
        {
            Throw "Invalid Path"
        }

        $File = (Get-Content -Path $Path) -join "`n"
    }

    Class Vendor 
    { 
        [Int32]      $Index
        [String]   $Address
        [Int32]       $Rank
        [String]      $Name
        [String] $Reference
        [Int32]       $Step

        
        Vendor([Int32]$Index,[String]$Address,[Int32]$Rank,[String]$Name,[String]$Reference,[Int32]$Step)
        {
            $This.Index     = $Index
            $This.Address   = $Address
            $This.Rank      = $Rank
            $This.Name      = $Name
            $This.Reference = $Reference
            $This.Step      = $Step
        }
    }

    Class VendorList
    {
        Hidden [Object] $Swap
        [String[]] $Addresses
        [Int32[]]      $Ranks
        [Hashtable]    $Steps
        [String[]]     $Names
        [String[]]        $ID
        [Hashtable]  $Vendors
        [Hashtable]   $Output
        [Object]      $Return

        GetSteps()
        {
            $This.Steps          = @{ }

            ForEach ( $I in 0..( $This.Ranks.Count - 1 ) )
            {
                $This.Steps.Add($I,$This.Ranks[$I+([Int32]($I -lt $This.Ranks.Count - 1))] - $This.Ranks[$I])
            }
        }

        GetNames()
        {
            $This.Vendors        = @{ }

            ForEach ( $I in 0..( $This.ID.Count - 1 ) )
            {
                $This.Vendors.Add($This.ID[$I],"{0:x4}" -f $I)
            }
        }

        GetOutput()
        {
            $This.Output         = @{ }

            ForEach ( $I in 0..( $This.Ranks.Count - 1 ) )
            {
                $This.Output.Add($I,[Vendor]::New($I,$This.Addresses[$I],$This.Ranks[$I],$This.Names[$I],$This.Vendors[$This.Names[$I]],$This.Steps[$I]))
            }

            $This.Return         = $This.Output.GetEnumerator() | Sort-Object Name | % Value
        }


        VendorList([String]$Swap)
        {
            $This.Swap           = $Swap
            $This.Addresses      = $This.Swap -Replace "(\t){1}.*","" -Split "`n"
            $This.Ranks          = $This.Addresses | % { [Int32]"0x$_" }
            $This.Names          = $This.Swap -Replace "([A-F0-9]){6}\t",""  -Split "`n" 
            $This.ID             = $This.Names | Sort-Object -Unique
            $This.GetSteps()
            $This.GetNames()
            $This.GetOutput()
        }
    }

    # [VendorList]::New($File).Return | Format-Table

    # Addresses : {000000, 000001, 000002, 000003...}
    # Ranks     : {0, 1, 2, 3...}
    # Steps     : {28665, 28664, 28663, 28662...}
    # Names     : {Xerox, Xerox, Xerox, Xerox...}
    # ID        : {@pos.com, @Track, +plugg srl, 01DB-Metravib...}
    # Vendors   : {NX, Beijing Ctimes Digital, Shanghai Surveillance, Ramix...}
    # Output    : {28665, 28664, 28663, 28662...}
    # Return    : {Vendor, Vendor, Vendor, Vendor...}
