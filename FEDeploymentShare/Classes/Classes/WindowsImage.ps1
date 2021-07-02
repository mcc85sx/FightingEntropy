Class WindowsImage
{
    [Uint32] $Index
    [String] $Name
    [String] $Description
    Hidden [Float]   $FileSize
    [String] $Size
    WindowsImage([Object]$Image)
    {
        If (!$Image)
        {
            Throw "No image input"
        }

        $This.Index       = $Image.ImageIndex
        $This.Name        = $Image.ImageName
        $This.Description = $Image.ImageDescription
        $This.FileSize    = $Image.ImageSize/1GB
        $This.Size        = "{0:n3} GB" -f $This.FileSize 
    }
}