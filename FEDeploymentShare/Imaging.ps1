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

Class ImageQueue
{
    [String]  $Name
    [String]  $FullName
    [String]  $Index
    [String]  $Description
    ImageQueue([String]$FullName,[String]$Index,[String]$Description)
    {
        If (!$FullName -or !$Index)
        {
            Throw "Invalid selection"
        }

        $This.Name          = $FullName | Split-Path -Leaf
        $This.FullName      = $FullName
        $This.Index         = $Index
        $This.Description   = $Description
    }
}

Class _XamlWindow 
{
    Hidden [Object]        $XAML
    Hidden [Object]         $XML
    [String[]]            $Names
    [Object]               $Node
    [Object]                 $IO
    [String[]] FindNames()
    {
        Return @( [Regex]"((Name)\s*=\s*('|`")\w+('|`"))" | % Matches $This.Xaml | % Value | % { 
        
            ($_-Replace "(\s+)(Name|=|'|`"|\s)","").Split('"')[1] 
            
        } | Select-Object -Unique ) 
    }
    _XamlWindow([String]$XAML)
    {           
        If ( !$Xaml )
        {
            Throw "Invalid XAML Input"
        }
        
        [System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

        $This.Xaml               = $Xaml
        $This.XML                = [XML]$Xaml
        $This.Names              = $This.FindNames()
        $This.Node               = [System.XML.XmlNodeReader]::New($This.XML)
        $This.IO                 = [System.Windows.Markup.XAMLReader]::Load($This.Node)

        ForEach ( $I in 0..( $This.Names.Count - 1 ) )
        {
            $Name                = $This.Names[$I]
            $This.IO             | Add-Member -MemberType NoteProperty -Name $Name -Value $This.IO.FindName($Name) -Force 
        }
    }
    Invoke()
    {
        $This.IO.Dispatcher.InvokeAsync({ $This.IO.ShowDialog() }).Wait()
    }
}

Class ImageTab
{
    [String] $Tab
    ImageTab()
    {
        $This.Tab = @"
        <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://New Deployment Share" Width="640" Height="780" Topmost="True" Icon=" C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\\Graphics\icon.ico" ResizeMode="NoResize" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
        <Window.Resources>
            <Style TargetType="GroupBox" x:Key="xGroupBox">
                <Setter Property="TextBlock.TextAlignment" Value="Center"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="GroupBox">
                            <Border CornerRadius="10" Background="White" BorderBrush="Black" BorderThickness="3">
                                <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType="Button" x:Key="xButton">
                <Setter Property="TextBlock.TextAlignment" Value="Center"/>
                <Setter Property="VerticalAlignment" Value="Center"/>
                <Setter Property="FontWeight" Value="Medium"/>
                <Setter Property="Padding" Value="10"/>
                <Setter Property="Margin" Value="10"/>
                <Setter Property="Foreground" Value="White"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="Button">
                            <Border CornerRadius="10" Background="#007bff" BorderBrush="Black" BorderThickness="3">
                                <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType="Label" x:Key="HeadLabel">
                <Setter Property="TextBlock.TextAlignment" Value="Center"/>
                <Setter Property="FontWeight" Value="Medium"/>
                <Setter Property="FontSize" Value="18"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="Foreground" Value="White"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="Label">
                            <Border CornerRadius="5" Background="#FF0080FF" BorderBrush="Black" BorderThickness="3">
                                <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{ TemplateBinding ContentTemplate }" Margin="5"/>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType="TabItem" x:Key="xTabItem">
                <Setter Property="TextBlock.TextAlignment" Value="Center"/>
                <Setter Property="VerticalAlignment" Value="Center"/>
                <Setter Property="FontWeight" Value="Medium"/>
                <Setter Property="Padding" Value="10"/>
                <Setter Property="Margin" Value="10"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="TabItem">
                            <Border CornerRadius="10" Background="#007bff" BorderBrush="Black" BorderThickness="3">
                                <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType="RadioButton" x:Key="RadButton">
                <Setter Property="HorizontalAlignment" Value="Center"/>
                <Setter Property="VerticalAlignment" Value="Center"/>
                <Setter Property="Foreground" Value="Black"/>
            </Style>
            <Style TargetType="TextBox" x:Key="TextBro">
                <Setter Property="TextBlock.TextAlignment" Value="Left"/>
                <Setter Property="VerticalContentAlignment" Value="Center"/>
                <Setter Property="HorizontalContentAlignment" Value="Left"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="TextWrapping" Value="Wrap"/>
                <Setter Property="Height" Value="24"/>
            </Style>
            <Style TargetType="DataGrid">
                <Setter Property="AutoGenerateColumns" Value="False"/>
                <Setter Property="AlternationCount" Value="2"/>
                <Setter Property="HeadersVisibility" Value="Column"/>
                <Setter Property="CanUserResizeRows" Value="False"/>
                <Setter Property="CanUserAddRows" Value="False"/>
                <Setter Property="IsTabStop" Value="True" />
                <Setter Property="IsTextSearchEnabled" Value="True"/>
                <Setter Property="IsReadOnly" Value="True"/>
                <Setter Property="TextBlock.HorizontalAlignment" Value="Left"/>
            </Style>
            <Style TargetType="DataGridRow">
                <Setter Property="TextBlock.HorizontalAlignment" Value="Left"/>
                <Style.Triggers>
                    <Trigger Property="AlternationIndex" Value="0">
                        <Setter Property="Background" Value="White"/>
                    </Trigger>
                    <Trigger Property="AlternationIndex" Value="1">
                        <Setter Property="Background" Value="#FFD6FFFB"/>
                    </Trigger>
                </Style.Triggers>
            </Style>
            <Style TargetType="DataGridColumnHeader">
                <Setter Property="FontSize"   Value="12"/>
                <Setter Property="FontWeight" Value="Normal"/>
            </Style>
            <Style TargetType="DataGridCell">
                <Setter Property="TextBlock.TextAlignment" Value="Left" />
            </Style>
        </Window.Resources>
        <GroupBox Style="{StaticResource xGroupBox}" Margin="5" Padding="5" Foreground="Black" Background="White">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="80"/>
                    <RowDefinition Height="120"/>
                    <RowDefinition Height="60"/>
                    <RowDefinition Height="120"/>
                    <RowDefinition Height="60"/>
                    <RowDefinition Height="120"/>
                    <RowDefinition Height="80"/>
                    <RowDefinition Height="70"/>
                </Grid.RowDefinitions>
                <GroupBox Grid.Row="0" Header="[ISO Path (Source Directory)]">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="100"/>
                        </Grid.ColumnDefinitions>
                        <TextBox Style="{StaticResource TextBro}" Name="IsoPath"/>
                        <Button Name="IsoScan" Grid.Column="1" Style="{StaticResource xButton}" Height="30" Content="Scan" IsEnabled="False"/>
                    </Grid>
                </GroupBox>
                <Grid Grid.Row="1">
                    <GroupBox Header="[ISO List (Detected)]">
                        <DataGrid Name="IsoList" Margin="5">
                            <DataGrid.Columns>
                                <DataGridTextColumn Header="Name" Binding='{Binding Name}' Width="*"/>
                                <DataGridTextColumn Header="Path" Binding='{Binding Fullname}' Width="2*"/>
                            </DataGrid.Columns>
                        </DataGrid>
                    </GroupBox>
                </Grid>
                <Grid Grid.Row="2">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Button Grid.Column="0" Style="{StaticResource xButton}" Name="IsoMount" Content="Mount" IsEnabled="False"/>
                    <Button Grid.Column="1" Style="{StaticResource xButton}" Name="IsoDismount" Content="Dismount" IsEnabled="False"/>
                </Grid>
                <Grid Grid.Row="3">
                    <GroupBox Header="[Windows ISO (Viewer)]">
                        <DataGrid Name="IsoView" Margin="5">
                            <DataGrid.Columns>
                                <DataGridTextColumn Header="Index" Binding='{Binding Index}' Width="40"/>
                                <DataGridTextColumn Header="Name"  Binding='{Binding Name}' Width="*"/>
                                <DataGridTextColumn Header="Size"  Binding='{Binding Size}' Width="100"/>
                            </DataGrid.Columns>
                        </DataGrid>
                    </GroupBox>
                </Grid>
                <Grid Grid.Row="4">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Button Grid.Column="0" Style="{StaticResource xButton}" Name="WimQueue" Content="Queue" IsEnabled="False"/>
                    <Button Grid.Column="1" Style="{StaticResource xButton}" Name="WimDequeue" Content="Dequeue" IsEnabled="False"/>
                </Grid>
                <Grid Grid.Row="5">
                    <GroupBox Header="[Windows Image (Extraction Queue)]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Grid Margin="5">
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Button Grid.Row="0" Name="WimIsoUp" Style="{StaticResource xButton}" Content="˄" Margin="0"/>
                                <Button Grid.Row="1" Name="WimIsoDown" Style="{StaticResource xButton}" Content="˅" Margin="0"/>
                            </Grid>
                            <DataGrid Grid.Column="1" Name="WimIso" Margin="5">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Name"  Binding='{Binding FullName}' Width="*"/>
                                    <DataGridTextColumn Header="Index" Binding='{Binding Index}' Width="100"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <GroupBox Grid.Row="6" Header="[ISO Swap (Target Directory)]">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="100"/>
                        </Grid.ColumnDefinitions>
                        <TextBox Grid.Column="0" Style="{StaticResource TextBro}" Name="WimSwap"/>
                        <Button Grid.Column="1" Style="{StaticResource xButton}" Name="WimExtract" Content="Extract"/>
                    </Grid>
                </GroupBox>
                <Grid Grid.Row="7">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <GroupBox Grid.Column="0" Header="[Local Admin Username]">
                        <TextBox Style="{StaticResource TextBro}" Name="_LMUsername"/>
                    </GroupBox>
                    <GroupBox Grid.Column="1" Header="[Password]">
                        <PasswordBox Name="_LMPassword" Height="24" HorizontalContentAlignment="Left" Margin="5" PasswordChar="*"/>
                    </GroupBox>
                    <GroupBox Grid.Column="2" Header="[Confirm]">
                        <PasswordBox Name="_LMConfirm" Height="24" HorizontalContentAlignment="Left" Margin="5" PasswordChar="*"/>
                    </GroupBox>
                </Grid>
            </Grid>
        </GroupBox>
    </Window>
"@
    }
}

Class _ImageIndex
{
    Hidden [UInt32] $Rank
    Hidden [UInt32] $SourceIndex
    Hidden [String] $SourceImagePath
    Hidden [String] $Path
    Hidden [String] $DestinationImagePath
    Hidden [String] $DestinationName
    Hidden [Object] $Disk
    [Object] $Label
    [UInt32] $ImageIndex            = 1
    [String] $ImageName
    [String] $ImageDescription
    [String] $Version
    [String] $Architecture
    [String] $InstallationType
    _ImageIndex([Object]$Iso)
    {
        $This.SourceIndex           = $Iso.SourceIndex
        $This.SourceImagePath       = $Iso.SourceImagePath
        $This.DestinationImagePath  = $Iso.DestinationImagePath
        $This.DestinationName       = $Iso.DestinationName
        $This.Disk                  = Get-DiskImage -ImagePath $This.SourceImagePath
    }
    Load([String]$Target)
    {
        Get-WindowsImage -ImagePath $This.Path -Index $This.SourceIndex | % {

            $This.ImageName         = $_.ImageName
            $This.ImageDescription  = $_.ImageDescription
            $This.Architecture      = Switch ([UInt32]($_.Architecture -eq 9)) { 0 { 86 } 1 { 64 } }
            $This.Version           = $_.Version
            $This.InstallationType  = $_.InstallationType.Split(" ")[0]
        }

        Switch($This.InstallationType)
        {
            Server
            {
                $Year    = [Regex]::Matches($This.ImageName,"(\d{4})").Value
                $Edition = Switch -Regex ($This.ImageName) { STANDARD { "Standard" } DATACENTER { "Datacenter" } }
                $This.DestinationName = "Windows Server $Year $Edition (x64)"
                $This.Label           = "{0}{1}" -f $(Switch -Regex ($This.ImageName){Standard{"SD"}Datacenter{"DC"}}),[Regex]::Matches($This.ImageName,"(\d{4})").Value
            }

            Client
            {
                $This.DestinationName = "{0} (x{1})" -f $This.ImageName, $This.Architecture
                $This.Label           = "10{0}{1}"   -f $(Switch -Regex ($This.ImageName) { Pro {"P"} Edu {"E"} Home {"H"} }),$This.Architecture
            }
        }

        $This.DestinationImagePath    = "{0}\({1}){2}\{2}.wim" -f $Target,$This.Rank,$This.Label

        $Folder                       = $This.DestinationImagePath | Split-Path -Parent

        If (!(Test-Path $Folder))
        {
            New-Item -Path $Folder -ItemType Directory -Verbose
        }
    }
}

Class _ImageFile
{
    [ValidateSet("Client","Server")]
    [String]        $Type
    [String]        $Name
    [String] $DisplayName
    [String]        $Path
    [UInt32[]]     $Index
    _ImageFile([String]$Type,[String]$Path)
    {
        $This.Type  = $Type
    
        If ( ! ( Test-Path $Path ) )
        {
            Throw "Invalid Path"
        }

        $This.Name        = ($Path -Split "\\")[-1]
        $This.DisplayName = "($Type)($($This.Name))"
        $This.Path        = $Path
        $This.Index       = @( )
    }
    AddMap([UInt32[]]$Index)
    {
        ForEach ( $I in $Index )
        {
            $This.Index  += $I
        }
    }
}

Class _ImageStore
{
    [String]   $Source
    [String]   $Target
    [Object[]]  $Store
    [Object[]]   $Swap
    [Object[]] $Output
    _ImageStore([String]$Source,[String]$Target)
    {
        If ( ! ( Test-Path $Source ) )
        {
            Throw "Invalid image base path"
        }

        If ( !(Test-Path $Target) )
        {
            New-Item -Path $Target -ItemType Directory -Verbose
        }

        $This.Source = $Source
        $This.Target = $Target
        $This.Store  = @( )
    }
    AddImage([String]$Type,[String]$Name)
    {
        $This.Store += [_ImageFile]::New($Type,"$($This.Source)\$Name")
    }
    GetSwap()
    {
        $This.Swap = @( )
        $Ct        = 0

        ForEach ( $Image in $This.Store )
        {
            ForEach ( $Index in $Image.Index )
            {
                $Iso                     = @{ 

                    SourceIndex          = $Index
                    SourceImagePath      = $Image.Path
                    DestinationImagePath = ("{0}\({1}){2}({3}).wim" -f $This.Target, $Ct, $Image.DisplayName, $Index)
                    DestinationName      = "{0}({1})" -f $Image.DisplayName,$Index
                }

                $Item                    = [_ImageIndex]::New($Iso)
                $Item.Rank               = $Ct
                $This.Swap              += $Item
                $Ct                     ++
            }
        }
    }
    GetOutput()
    {
        $Last = $Null

        ForEach ( $X in 0..( $This.Swap.Count - 1 ) )
        {
            $Image       = $This.Swap[$X]

            If ( $Last -ne $Null -and $Last -ne $Image.SourceImagePath )
            {
                Write-Theme "Dismounting... $Last" 12,4,15,0
                Dismount-DiskImage -ImagePath $Last -Verbose
            }

            If (!(Get-DiskImage -ImagePath $Image.SourceImagePath).Attached)
            {
                Write-Theme ("Mounting [+] {0}" -f $Image.SourceImagePath) 14,6,15,0
                Mount-DiskImage -ImagePath $Image.SourceImagePath
            }
            
            $Image.Path = "{0}:\sources\install.wim" -f (Get-DiskImage -ImagePath $Image.SourceImagePath | Get-Volume | % DriveLetter)
            
            $Image.Load($This.Target)

            $ISO                        = @{
    
                SourceIndex             = $Image.SourceIndex
                SourceImagePath         = $Image.Path
                DestinationImagePath    = $Image.DestinationImagePath
                DestinationName         = $Image.DestinationName
            }
            
            Write-Theme "Extracting [~] $($Iso.DestinationImagePath)" 11,7,15,0
            Export-WindowsImage @ISO
            Write-Theme "Extracted [+] $($Iso.DestinationName)" 10,10,15,0

            $Last                       = $Image.SourceImagePath
            $This.Output               += $Image
        }

        Dismount-DiskImage -ImagePath $Last
    }
}

$Xaml  = [_XamlWindow]::New([ImageTab]::New().Tab)

$Xaml.IO.WimIso.ItemsSource = @()

$Xaml.IO.IsoPath.Add_TextChanged(
{
    If ( $Xaml.IO.IsoPath.Text -ne "" )
    {
        $Xaml.IO.IsoScan.IsEnabled = 1
    }

    Else
    {
        $Xaml.IO.IsoScan.IsEnabled = 0
    }
})

$Xaml.IO.IsoScan.Add_Click(
{
    If (!(Test-Path $Xaml.IO.IsoPath.Text))
    {
        [System.Windows.MessageBox]::Show("Invalid image root path","Error")
    }

    $Tmp = Get-ChildItem $Xaml.IO.IsoPath.Text *.iso

    If (!$Tmp)
    {
        [System.Windows.MessageBox]::Show("No images detected","Error")
    }
    
    $Xaml.IO.IsoList.ItemsSource = $Tmp | Select-Object Name, Fullname
})

$Xaml.IO.IsoList.Add_SelectionChanged(
{
    If ( $Xaml.IO.IsoList.SelectedIndex -gt -1 )
    {
        $Xaml.IO.IsoMount.IsEnabled = 1
    }

    Else
    {
        $Xaml.IO.IsoMount.IsEnabled = 0
    }
})

$Xaml.IO.IsoMount.Add_Click(
{
    If ( $Xaml.IO.IsoList.SelectedIndex -eq -1)
    {
        [System.Windows.MessageBox]::Show("No image selected","Error")
    }

    $ImagePath  = $Xaml.IO.IsoList.SelectedItem.FullName
    Write-Host "Mounting [~] [$ImagePath]"

    Mount-DiskImage -ImagePath $ImagePath -Verbose

    $Letter    = Get-DiskImage $ImagePath | Get-Volume | % DriveLetter
    
    If (!$Letter)
    {
        [System.Windows.MessageBox]::Show("Image failed mounting to drive letter","Error")
    }

    ElseIf (!(Test-Path "${Letter}:\sources\install.wim"))
    {
        [System.Windows.MessageBox]::Show("Not a valid Windows disc/image","Error")
        Dismount-Diskimage -ImagePath $ImagePath
    }

    Else
    {
        $Xaml.IO.IsoView.ItemsSource     = Get-WindowsImage -ImagePath "${Letter}:\sources\install.wim" | % { [WindowsImage]$_ }
        $Xaml.IO.IsoList.IsEnabled       = 0
        $Xaml.IO.IsoDismount.IsEnabled   = 1
        Write-Host "Mounted [+] [$ImagePath]"
    }
})

$Xaml.IO.IsoDismount.Add_Click(
{
    $ImagePath                           = $Xaml.IO.IsoList.SelectedItem.FullName
    Dismount-DiskImage -ImagePath $ImagePath
    $Xaml.IO.IsoView.ItemsSource         = $Null
    $Xaml.IO.IsoList.IsEnabled           = 1

    Write-Host "Dismounted [+] [$ImagePath]"
    $ImagePath                           = $Null

    $Xaml.IO.IsoDismount.IsEnabled       = 0
})

$Xaml.IO.IsoView.Add_SelectionChanged(
{
    If ( $Xaml.IO.IsoView.Items.Count -eq 0 )
    {
        $Xaml.IO.WimQueue.IsEnabled     = 0
    }

    If ( $Xaml.IO.IsoView.Items.Count -gt 0 )
    {
        $Xaml.IO.WimQueue.IsEnabled     = 1
    }
})

$Xaml.IO.WimIso.Add_SelectionChanged(
{
    If ( $Xaml.IO.WimIso.Items.Count -eq 0 )
    {
        $Xaml.IO.WimDequeue.IsEnabled   = 0
        $Xaml.IO.WimIsoUp.IsEnabled     = 0
        $xaml.IO.WimIsoDown.IsEnabled   = 0
    }

    If ( $Xaml.IO.WimIso.Items.Count -gt 0 )
    {
        $Xaml.IO.WimDequeue.IsEnabled   = 1
        $Xaml.IO.WimIsoUp.IsEnabled     = 1
        $xaml.IO.WimIsoDown.IsEnabled   = 1
    }
})

$Xaml.IO.WimQueue.Add_Click(
{
    If ($Xaml.IO.IsoList.SelectedItem.Fullname -in $Xaml.IO.WimIso.Items.Name)
    {
        [System.Windows.MessageBox]::Show("Image already selected","Error")
    }

    Else
    {
        $Indexes      = $Xaml.IO.IsoView.SelectedItems.Index -join ","
        $Descriptions = $Xaml.IO.IsoView.SelectedItems.Description -join ","
        $Xaml.IO.WimIso.ItemsSource += [ImageQueue]::New($Xaml.IO.IsoList.SelectedItem.Fullname,$Indexes,$Descriptions)
    }
})

$Xaml.IO.WimDequeue.Add_Click(
{
    $Grid = $Xaml.IO.WimIso.ItemsSource
    $Items = @( )

    ForEach ( $Item in $Grid )
    {
        If ( $Item -ne $Xaml.IO.WimIso.SelectedItem )
        {
            $Items += $Item
        }
    }

    $Xaml.IO.WimIso.ItemsSource = @( )
    $Xaml.IO.WimIso.ItemsSource = $Items
    $Grid                       = $Null
    $Items                      = $Null

    If ( $Xaml.IO.WimIso.Items.Count -eq 0 )
    {
        $Xaml.IO.WimDequeue.IsEnabled = 0
    }
})

$Xaml.IO.WimIsoUp.Add_Click(
{
    If ( $Xaml.IO.WimIso.Items.Count -gt 1 )
    {
        $Rank  = $Xaml.IO.WimIso.SelectedIndex
        $Grid  = $Xaml.IO.WimIso.ItemsSource
        $Items = 0..($Grid.Count-1)

        If ($Rank -ne 0)
        {
            ForEach ($I in 0..($Grid.Count-1))
            {
                If ( $I -eq $Rank - 1 )
                {
                    $Items[$I] = $Grid[$I+1]
                }

                ElseIf ( $I -eq $Rank )
                {
                    $Items[$I] = $Grid[$I-1]   
                }

                Else
                {
                    $Items[$I] = $Grid[$I]
                }
            }

            $Xaml.IO.WimIso.ItemsSource = @( )
            $Xaml.IO.WimIso.ItemsSource = $Items
            $Items = $Null
            $Rank  = $Null
            $Grid  = $Null
        }
    }
})

$Xaml.IO.WimIsoDown.Add_Click(
{
    If ( $Xaml.IO.WimIso.Items.Count -gt 1 )
    {
        $Rank  = $Xaml.IO.WimIso.SelectedIndex
        $Grid  = $Xaml.IO.WimIso.ItemsSource
        $Items = 0..($Grid.Count - 1)

        If ($Rank -ne $Grid.Count - 1)
        {
            ForEach ($I in 0..($Grid.Count-1))
            {
                If ( $I -eq $Rank )
                {
                    $Items[$I] = $Grid[$I+1]   
                }

                ElseIf ( $I -eq $Rank + 1 )
                {
                    $Items[$I] = $Grid[$I-1]
                }

                Else
                {
                    $Items[$I] = $Grid[$I]
                }
            }
            
            $Xaml.IO.WimIso.ItemsSource = @( )
            $Xaml.IO.WimIso.ItemsSource = $Items
            $Items = $Null
            $Rank  = $Null
            $Grid  = $Null
        }
    }
})

$Xaml.IO.WimExtract.Add_Click(
{
    If (Test-Path $Xaml.IO.WimSwap.Text)
    {
        Switch([System.Windows.MessageBox]::Show("Path [!] exists!","The path already exists, delete?","YesNo"))
        {
            Yes 
            { 
                Write-Host "Removing path... [$($Xaml.IO.WimSwap.Text)]"
                Remove-Item -Path $Xaml.IO.WimSwap.Text -Recurse -Force -Verbose
            }
            
            No
            { 
                Write-Host "No action taken"
                Break
            }
        }
    }

    $Images = [_ImageStore]::New($Xaml.IO.IsoPath.Text,$Xaml.IO.WimSwap.Text)

    $X      = 0
    ForEach ( $Item in $Xaml.IO.WimIso.Items )
    {
        $Type = Switch -Regex ($Item.Description)
        {
            Server { "Server" } Default { "Client" }
        }

        $Images.AddImage($Type,$Item.Name)
        $Images.Store[$X].AddMap($Item.Index.Split(","))
        $X ++
    }

    $Images.GetSwap()
    $Images.GetOutput()
    Write-Theme "Complete [+] Images Collected"
})

$Xaml.IO.WimSwap.Add_TextChanged(
{
    If ( $Xaml.IO.WimSwap.Text -ne "" )
    {
        $Xaml.IO.WimExtract.IsEnabled = 1
    }

    If ( $Xaml.IO.WimSwap.Text -eq "" )
    {
        $Xaml.IO.WimExtract.IsEnabled = 0
    }
})

$Xaml.Invoke()
