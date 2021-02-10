# Sample MDT "View Script" ...
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "FE001" -PSProvider MDTProvider -Root "C:\TestFlight"
new-item -path "FE001:\Operating Systems" -enable "True" -Name "Server" -Comments "[2021-0209 MCC/SDP]" -ItemType "folder" -Verbose
