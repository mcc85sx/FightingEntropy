# https://linuxnet.ca/ieee/oui/nmap-mac-prefixes

# This file above gets updated quite often. Rather than to have a static link to a 500kb file that gets rate 
# limited if you query the file too many times (as I was able to demonstrate at the beginning of the video),
# I thought to make a script/program that could split this file and remove common denominators.
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

$Names                  = @( )
$Ranks                  = @( )
$VendorList             = @{ }
$Swap                   = ( Invoke-WebRequest "https://linuxnet.ca/ieee/oui/nmap-mac-prefixes" ).Content
$Content                = $Swap -Split "`n"

ForEach ( $I in 0..( $Content.Count - 1 ) )
{
    $Rank, $Name        = $Content[$I] -Split [Char]9 

    "{0:n2}% [{1}]" -f (($I/$Content.Count)*100),$Name
    
    If ( $Name -notin $Names )
    {
        $Names         += $Name
    }

    $Ranks             += [Int32]"0x$Rank"
}

$Names                  = $Names | Sort-Object

$VendorList = @{ }
ForEach ( $I in 0..($Names.Count - 1 ) )
{
    $VendorList.Add( $Names[$I], "{0:x}" -f $I )
}

$Output                 = @( )
ForEach ( $I in 0..( $Content.Count - 2 ) )
{
    $Step               = @{ 
    
        0               = 0 
        1               = $Rank[$I] - $Rank[$I-1] 
        
    }[[Int32]($I -gt 0)]
    
    $Name               = ( $Content[$I] -Split [Char] 9)[1]

    "{0:n2}% [{1}] [{2}]" -f (($I/$Content.Count)*100),$VendorList[$Name],$Name

    $Output += ("{0}{1}{2}" -f $Step,[Char]9,$VendorList[$Name])
}
