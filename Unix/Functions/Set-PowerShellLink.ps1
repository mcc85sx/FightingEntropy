Function Set-PowerShellLink
{
    [String] $User  = (who).Split("  :")[0]
    [String] $Path  = "/home/$User/Desktop/pwsh.desktop"
    [Object] $Value = @("[Desktop Entry]",
                        "Version=1.0",
                        "Type=Application",
                        "Terminal=true",
                        "Exec=/opt/microsoft/powershell/7/pwsh",
                        "Name=pwsh",
                        "Comment=",
                        "Icon=")  
     
    New-Item -Path $Path -ItemType File -Verbose
    Set-Content -Path $Path -Value @($Value)
    chmod 755 $Path
}
