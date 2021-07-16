class Program 
{
    Hidden [Object] $Item
    [String] $DisplayName
    [String] $DisplayVersion
    [String] $InstallDate
    [String] $InstallSource
    [String] $UninstallString
    [Object] $IdentifyingNumber
    Program([Object]$Item)
    {
        $This.Item              = $Item | Select *
        $This.DisplayName       = $Item.DisplayName
        $This.DisplayVersion    = $Item.DisplayVersion
        $This.InstallDate       = $Item.InstallDate
        $This.InstallSource     = $Item.InstallSource
        $This.UninstallString   = $Item.UninstallString
        $This.IdentifyingNumber = @( )
    }
}

Class DGList
{
    [String] $Name
    [Object] $Value
    DGList([String]$Name,[Object]$Value)
    {
        $This.Name  = $Name
        $This.Value = $Value
    }
}

Class ProgramTab
{
    Static [String] $Tab = @'
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Applications" Width="960" Height="600" Topmost="True" Icon=" C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\\Graphics\icon.ico" ResizeMode="NoResize" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
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
                </Trigger>
                <Trigger Property="AlternationIndex" Value="1">
                    <Setter Property="Background" Value="#FFCDF7F7"/>
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
    <GroupBox Style="{StaticResource xGroupBox}" Grid.Row="0" Margin="10" Padding="5" Foreground="Black" Background="White">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="50"/>
            </Grid.RowDefinitions>
            <GroupBox Header="[Program (List)]" Grid.Row="0" Margin="5" Padding="5">
                <DataGrid Name="ProgramList">
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Name" Binding="{Binding DisplayName}" Width="*"/>
                        <DataGridTextColumn Header="Version" Binding="{Binding DisplayVersion}" Width="100"/>
                        <DataGridTextColumn Header="Date" Binding="{Binding InstallDate}" Width="100"/>
                    </DataGrid.Columns>
                </DataGrid>
            </GroupBox>
            <GroupBox Header="[Program (Selected)]" Grid.Row="1" Margin="5" Padding="5">
                <DataGrid Name="ProgramSelected" Grid.Row="1">
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="250"/>
                        <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                    </DataGrid.Columns>
                </DataGrid>
            </GroupBox>
            <Grid Grid.Row="2">
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

$Xaml                                = [XamlWindow][ProgramTab]::Tab
$Xaml.IO.ProgramList.ItemsSource     = @( )
$Xaml.IO.ProgramSelected.ItemsSource = @( )

$Xaml.IO.Start.Add_Click(
{
    Write-Host "Getting [~] WMIObject: Win32_Product"
    $Product = @{ }
    ForEach ( $Item in Get-WMIObject -Class Win32_Product)
    {
        If ( $Item.Name -ne $Null )
        {
            $Product.Add($Product.Count,$Item)
        }
    }

    $Stack   = $Product[0..($Product.Count-1)]

    Write-Host "Indexing [~] WMIObject: Win32_Product"
    $Names   = @{ }
    ForEach ( $X in 0..($Stack.Count - 1))
    {
        $Item = $Stack[$X]

        If ($Item.Name -notin $Names.Keys)
        {
            $Names.Add($Item.Name,@( ))
        }

        $Names[$Item.Name] += $X
    }

    Write-Host "Querying [~] Registry: Uninstall Path"
    $Arch    = @{ AMD64 = 0..1; x86 = 0 }[$Env:Processor_Architecture]
    $Path    = @("","\WOW6432Node" | % {"HKLM:\Software$_\Microsoft\Windows\CurrentVersion\Uninstall"})[$Arch]
    $Reg     = $Path | % { Get-ItemProperty "$_\*" }

    Write-Host "Priming [~] Installed program list"
    $List    = $Reg | ? DisplayName -in $Stack.Name | % { [Program]$_ }

    $Out     = @( )
    ForEach ( $X in 0..($List.Count-1))
    {
        $Item = $List[$X]
        $Item.IdentifyingNumber = $Stack | ? Name -eq $Item.DisplayName | % IdentifyingNumber
        $Out += $Item
    }

    $Xaml.IO.ProgramList.ItemsSource = @( )
    $Xaml.IO.ProgramList.ItemsSource = $Out
})

$Xaml.IO.ProgramList.Add_MouseDoubleClick(
{
    If ( $Xaml.IO.ProgramList.SelectedIndex -gt -1 )
    {
        $Item = $Xaml.IO.ProgramList.SelectedItem 
        $Tmp  = @( )
        ForEach ( $ID in "DisplayName DisplayVersion InstallDate InstallSource UninstallString IdentifyingNumber".Split(" ") )
        {
            $Tmp += [DGList]::New($ID,$Item.$ID)
        }

        $Xaml.IO.ProgramSelected.ItemsSource = @( )
        $Xaml.IO.ProgramSelected.ItemsSource = @( $Tmp )
    }
})

$Xaml.IO.Cancel.Add_Click(
{
    $Xaml.IO.DialogResult = $False
})

$Xaml.Invoke()
