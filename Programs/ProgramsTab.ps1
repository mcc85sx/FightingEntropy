class Program
{
    Hidden [Object] $Item
    [String] $DisplayName
    [String] $DisplayVersion
    [String] $InstallDate
    [String] $InstallSource
    [String] $UninstallString
    [String[]] $IdentifyingNumber
    Program([Object]$Item)
    {
        $This.Item              = $Item | Select *
        $This.DisplayName       = $Item.DisplayName
        $This.DisplayVersion    = $Item.DisplayVersion
        $This.InstallDate       = $Item.InstallDate
        $This.InstallSource     = $Item.InstallSource
        $This.UninstallString   = $Item.UninstallString
    }
}

Class DGList
{
    [String] $Name
    [Object] $Value
    DGList([String]$Name,[Object[]]$Value)
    {
        $This.Name  = $Name
        $This.Value = Switch -Regex ($Value.GetType().Name)
        {
            "(\w+\[\])" { $Value -join ', ' } Default { $Value }
        }
    }
}

Class ProgramTab
{
    Static [String] $Tab = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Applications" Width="960" Height="720" FontWeight="600" Icon=" C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\\Graphics\icon.ico" ResizeMode="NoResize" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
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
        <Style TargetType="GroupBox">
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Padding" Value="5"/>
        </Style>
        <Style TargetType="Button">
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
        <Style TargetType="TextBox">
            <Setter Property="TextBlock.TextAlignment" Value="Left"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="TextWrapping" Value="Wrap"/>
            <Setter Property="Height" Value="24"/>
        </Style>
        <Style TargetType="DataGrid">
            <Setter Property="HorizontalAlignment" Value="Center"/>
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
                    <Setter Property="Foreground" Value="Black"/>
                </Trigger>
                <Trigger Property="AlternationIndex" Value="1">
                    <Setter Property="Background" Value="LightGray"/>
                    <Setter Property="Foreground" Value="Black"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style TargetType="DataGridCell">
            <Setter Property="TextBlock.TextAlignment" Value="Left" />
        </Style>
    </Window.Resources>
    <GroupBox Style="{StaticResource xGroupBox}" Grid.Row="0" Margin="10" Padding="5" Foreground="Black" Background="White">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="200"/>
                <RowDefinition Height="200"/>
                <RowDefinition Height="200"/>
                <RowDefinition Height="50"/>
            </Grid.RowDefinitions>
            <GroupBox Header="[Program (List)]" Grid.Row="0">
                <DataGrid Name="ProgramList">
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="DisplayName" Binding="{Binding DisplayName}" Width="*"/>
                        <DataGridTextColumn Header="DisplayVersion" Binding="{Binding DisplayVersion}" Width="100"/>
                        <DataGridTextColumn Header="InstallDate" Binding="{Binding InstallDate}" Width="100"/>
                    </DataGrid.Columns>
                </DataGrid>
            </GroupBox>
            <GroupBox Header="[Program (Selected)]" Grid.Row="1">
                <DataGrid Name="ProgramSelected" Grid.Row="1">
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="175"/>
                        <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                    </DataGrid.Columns>
                </DataGrid>
            </GroupBox>
            <GroupBox Header="[Program (Registry)]" Grid.Row="2">
                <DataGrid Name="ProgramRegistry" Grid.Row="1">
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="175"/>
                        <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                    </DataGrid.Columns>
                </DataGrid>
            </GroupBox>
            <Grid Grid.Row="3">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Name="Start" Content="Start"/>
                <Button Grid.Column="1" Name="Cancel" Content="Cancel"/>
            </Grid>
        </Grid>
    </GroupBox>
</Window>
'@
}

Class XamlWindow
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
    XamlWindow([String]$XAML)
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

Class Control
{
    [Object]$Time
    [Object]$WMI
    [Object]$Product
    [Object]$Stack
    [Object]$Names
    [Object]$Arch
    [Object]$Path
    [Object]$Reg
    Control()
    {
        $This.Time = [System.Diagnostics.Stopwatch]::StartNew()
        Write-Theme "wmic.exe [~] Scanning Win32/Product (~20s)"

        # Object[] for installed programs
        $This.WMI  = Get-WMIObject -Class Win32_Product
        Write-Host "[$($This.Time.Elapsed)] WMI Stack [+]"

        # Hashtable for program names
        $This.Product = @{ }
        ForEach ( $Item in $This.WMI)
        {
            If ( $Item.Name -ne $Null )
            {
                $This.Product.Add($This.Product.Count,$Item)
            }
        }
        Write-Host "[$($This.Time.Elapsed)]"

        # Index the values
        $This.Stack   = $This.Product[0..($This.Product.Count-1)]

        Write-Theme "wmic.exe [~] Get-WMIObject Win32-Product for installed programs/MSI applications"
        $This.Names   = @{ }
        ForEach ( $X in 0..($This.Stack.Count - 1))
        {
            $Item = $This.Stack[$X]

            If ($Item.Name -notin $This.Names.Keys)
            {
                $This.Names.Add($Item.Name,@( ))
            }

            $This.Names[$Item.Name] += $X
        }

        Write-Theme "HKLM:\Software [~] Registry Uninstall Path"
        $This.Arch    = @{ AMD64 = 0..1; x86 = 0 }[$Env:Processor_Architecture]
        $This.Path    = @("","\WOW6432Node" | % {"HKLM:\Software$_\Microsoft\Windows\CurrentVersion\Uninstall"})[$This.Arch]
        $This.Reg     = $This.Path | % { Get-ItemProperty "$_\*" } | % { [Program]$_ }

        ForEach ( $Item in $This.Reg )
        {
            If ($Item.DisplayName -in $This.Names.Keys)
            {
                $Item.IdentifyingNumber += $This.Stack[$This.Names[$Item.DisplayName]] | % IdentifyingNumber
            }
        }
    }
    SelectProgram([Object]$Xaml)
    {
        If ( $Xaml.IO.ProgramList.SelectedIndex -gt -1 )
        {
            $Item = $Xaml.IO.ProgramList.SelectedItem
            $Tmp  = @( )
            ForEach ( $ID in $Item | GM | ? Membertype -match Property | % Name )
            {
                If ( $Item.$ID.Count -gt 0 )
                {
                    $Tmp += [DGList]::New($ID,$Item.$ID)
                }
            }

            $Xaml.IO.ProgramSelected.ItemsSource = @( )
            $Xaml.IO.ProgramSelected.ItemsSource = @( $Tmp )

            $Tmp  = @( )
            ForEach ( $ID in $Item.Item | GM | ? Membertype -match Property | % Name )
            {
                If ( $Item.Item.$ID.Count -gt 0 )
                {
                    $Tmp += [DGList]::New($ID,$Item.Item.$ID)
                }
            }

            $Xaml.IO.ProgramRegistry.ItemsSource = @( )
            $Xaml.IO.ProgramRegistry.ItemsSource = @( $Tmp )
        }
    }
}

$Ctrl                                = [Control]::New()
$Xaml                                = [XamlWindow][ProgramTab]::Tab

$Xaml.IO.ProgramList.ItemsSource     = @( $Ctrl.Reg )
$Xaml.IO.ProgramSelected.ItemsSource = @( )
$Xaml.IO.ProgramRegistry.ItemsSource = @( )

$Xaml.IO.Start.Add_Click(
{
    $Xaml.IO.ProgramList.ItemsSource = @( )
    $Xaml.IO.ProgramList.ItemsSource = @( $Ctrl.Reg )
})

$Xaml.IO.ProgramList.Add_MouseDoubleClick(
{
    $Ctrl.SelectProgram($Xaml)
})

$Xaml.IO.ProgramList.Add_SelectionChanged(
{
    $Ctrl.SelectProgram($Xaml)
})

$Xaml.IO.Cancel.Add_Click(
{
    $Xaml.IO.DialogResult = $False
})

$Xaml.Invoke()
