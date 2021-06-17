# ------------- #
# The Situation #
# ------------- #

# A fellow company network administrator needs someone to flush all of the 
# certificates for a domain. These certificates are used for a number of 
# devices on the network, the website, email, DNS, printers, etc.

# You're the leading (wizard/security engineer) that's been tasked with 
# quelling the flame ASAP.

# With this how-to guide, you'll make quick work in updating the certificates.

# The certificate server is located at "cp.securedigitsplus.com"
# The certificate account is certsrv
# The certificate files are under /var/etc/acme-client/cert
# SSH Keys are already assigned and dispatched to the equipment

# ----------- #
# SSH Version # For parallel demonstration only
# ----------- #

# 1) Login
ssh certsrv@cp.securedigitsplus.com

# 2) Set variable for the path
set a=/var/etc/acme-client/certs

# 3) Get/Set the name of the chain
set b=`ls $a | tail -n 1`

# 4) Set the childitem to swap file
ls $a/$b > swap

# 5) Get values in swap file to loop
set d=`cat swap`

# 6) Initiate print loop
foreach e ($d)
echo \[$e\]
echo \[$c\/$e\]
openssl x509 -in $c/$e -text
end

rm swap

# ------------------ #
# PowerShell Version #
# ------------------ #

# Here's the PowerShell version of the same thing... 
# ...except the files and objects are parsed and imported/reported.

# Update-Certificate function
IRM https://github.com/mcc85sx/FightingEntropy/blob/master/Win32_Server/Update-Certificate.ps1?raw=true | IEX

# Write-Theme 2021.6.0
IRM https://github.com/mcc85s/FightingEntropy/blob/main//Functions/Write-Theme.ps1?raw=true | IEX

Write-Theme "Write-Theme [+] function loaded" 10,2,15,0

$ComputerName = "cp.securedigitsplus.com"
$KeyFile="$home\.ssh\putty_key"
$Root="/var/etc/acme-client/certs"
$Credential=Get-Credential
$FilePath="$home\desktop"

$Cert = Update-Certificate -ComputerName $ComputerName -KeyFile $KeyFile -Root $Root -Credential $Credential
GCI $FilePath | ? Name -in $Cert.Files.Name | Remove-Item -Verbose -Force
$Cert.Import($FilePath)

ForEach ( $File in $Cert.Files )
{
    Write-Theme $File.Report 14,6,15,0
}
