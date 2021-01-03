Function Get-XamlWindow # // Originally based on Dr. Weltner's work, but also Jason Adkinson from Pluralsight
{
    [CmdletBinding()]Param(
    [Parameter(Mandatory)]
    [ValidateSet("Certificate","ADLogin","NewAccount","FEDCPromo","FEDCFound","FERoot","FEShare","FEService","MBWin10","Test")]
    [String]$Type,
    [Parameter()]
    [Switch]$Return)
    
    # // Load the Assemblies (TODO: Get Unix to load these)
    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName PresentationCore
    Add-Type -AssemblyName WindowsBase

    Class _XamlGFX
    {
        [String] $GFX
        [String] $Icon
        [String] $Background
        [String] $Banner

        _XamlGFX([String]$Base)
        {
            If ( ! ( Test-Path $Base ) )
            {
                Throw "Invalid Path"
            }

            $This.GFX        = $Base
            $This.Icon       = "$Base\icon.ico"
            $This.Background = "$Base\background.jpg"
            $This.Banner     = "$Base\banner.png"
        }
    }

    # // Load Classes...
    Class _XamlGlossaryEntry
    {
        [Int32]     $Index
        [String] $Variable
        [String]     $Name

        _XamlGlossaryEntry([Int32]$Index,[String]$Variable,[String]$Name)
        {
            $This.Index    = $Index
            $This.Variable = $Variable
            $This.Name     = $Name
        }
    }

    Class _XamlGlossary
    {
        Hidden [String[]] $Names  = @(('Background Border Button CheckBox Column{0} ComboBox ComboBoxItem Co'+
        'ntent ContentPresenter ControlTemplate Effect Grid {1} {1}{0}s {1}Span {2} {2}{0}s {2}Span GroupB'+
        'ox GroupBoxItem Header Height {3}{5} {3}Content{5} Label Margin Menu MenuItem Padding {6} {6'+
        '}Box {6}Char Property RadioButton Resources RowDefinition SelectIndex Setter Style TabControl Tar'+
        'getName TargetType TextBlock TextBox TextWrapping Title Trigger Value {4}{5} {4}Content{5} Width '+
        'Window x:Key') -f "Definition","Grid.Column","Grid.Row","Horizontal","Vertical","Alignment","Password"
        ).Split(" ")

        Hidden [String[]] $Labels = @(('BG BO BU CHK CD CB CBI CO CP CT EF G GC GCD GCS GR GRD GRS GB GBI HD' +
        ' H Hx HCx LA MA MN MNI PA PW PWB PWC PR RB RES RD SI SE ST TC TN TT TBL TB TW TI TR VA Vx VCx W' + 
        ' WI XK') -Split " " | % { "`${0}" -f $_ } )  

        [Object] $Output

        _XamlGlossary()
        {
            $This.Output      = @( ) 
        
            ForEach ( $I in 0..($This.Names.Count - 1))
            {
                $This.Output += [_XamlGlossaryEntry]::New($I,$This.Labels[$I],$This.Names[$I])
            }
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
    
    Class _XamlObject
    {
        [String[]]        $Names = ("Certificate ADLogin NewAccount FEDCPromo FEDCFound FERoot FEShare FEService MBWin10 Test" -Split " ")
        [Object]       $Glossary = [_XamlGlossary]::New().Output
        [Object]            $GFX = [_XamlGFX]::New("C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics")
        [Object]           $Xaml = @{ 

        ADLogin                  = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://AD Login" Width="400" Height="260" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
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
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Margin" Value="10"/>
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
    </Window.Resources>
    <Grid>
        <Grid.Background>
            <ImageBrush Stretch="None" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
        </Grid.Background>
        <GroupBox Style="{StaticResource xGroupBox}" Width="380" Height="220" Margin="5" VerticalAlignment="Center">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <GroupBox Grid.Row="0" Header="User Name">
                    <TextBox Name="UserName" Margin="5"/>
                </GroupBox>
                <GroupBox Grid.Row="1" Header="Password / Confirm">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <PasswordBox Grid.Column="0" Name="Password" Margin="5"/>
                        <PasswordBox Grid.Column="1" Name="Confirm" Margin="5"/>
                    </Grid>
                </GroupBox>
                <Grid Grid.Row="2">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <RadioButton Name="Switch" Grid.Column="0" Content="Change Login Port" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                    <TextBox Name="Port" Grid.Row="0" Grid.Column="1" VerticalAlignment="Center" HorizontalAlignment="Center" Width="120" IsEnabled="False">389</TextBox>
                </Grid>
                <Grid Grid.Row="3">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Button Name="Ok" Style="{StaticResource xButton}" Content="Ok" Grid.Column="0" Grid.Row="1" Margin="5"/>
                    <Button Name="Cancel" Style="{StaticResource xButton}" Content="Cancel" Grid.Column="1" Grid.Row="1" Margin="5"/>
                </Grid>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@
            Certificate          = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Certificate Info" Width="380" Height="260" Topmost="True" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="GroupBox" x:Key="xGroupBox">
            <Setter Property="Margin" Value="10"/>
            <Setter Property="TextBlock.TextAlignment" Value="Center"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Margin" Value="10"/>
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
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Margin" Value="10"/>
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
    </Window.Resources>
    <Grid>
        <Grid.Background>
            <ImageBrush Stretch="None" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
        </Grid.Background>
        <GroupBox Header="Company Information / Certificate Generation" Style="{StaticResource xGroupBox}" Width="330" Height="200" VerticalAlignment="Top">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <GroupBox Header="Organization" Grid.Row="0">
                    <TextBox Name="Company" Grid.Row="0" Grid.Column="1" Height="24" Margin="5"/>
                </GroupBox>
                <GroupBox Header="Domain Name" Grid.Row="1">
                    <TextBox Name="Domain" Grid.Row="1" Grid.Column="1" Height="24" Margin="5"/>
                </GroupBox>
                <Grid Grid.Row="2">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Button Name="Ok" Style="{StaticResource xButton}" Content="Ok" Grid.Column="0" Margin="10"/>
                    <Button Name="Cancel" Style="{StaticResource xButton}" Content="Cancel" Grid.Column="1" Margin="10"/>
                </Grid>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@
            FEDCFound            = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Domain Controller Found" Width="500" Height="260" HorizontalAlignment="Center" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="GroupBox" x:Key="xGroupBox">
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Padding" Value="10"/>
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
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Margin" Value="10"/>
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
    </Window.Resources>
    <Grid>
        <Grid.Background>
            <ImageBrush Stretch="None" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
        </Grid.Background>
        <GroupBox Style="{StaticResource xGroupBox}">
            <Grid Margin="5">
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="50"/>
                </Grid.RowDefinitions>
                <DataGrid Grid.Row="0" Grid.Column="0" Name="DataGrid" FrozenColumnCount="2" AutoGenerateColumns="False" AlternationCount="2" HeadersVisibility="Column" CanUserResizeRows="False" CanUserAddRows="False" IsTabStop="True" IsTextSearchEnabled="True" SelectionMode="Extended">
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Address" Width="140" Binding="{Binding IPAddress}" CanUserSort="True" IsReadOnly="True"/>
                        <DataGridTextColumn Header="Hostname" Width="200" Binding="{Binding HostName}" CanUserSort="True" IsReadOnly="True"/>
                        <DataGridTextColumn Header="NetBIOS" Width="140" Binding="{Binding NetBIOS}" CanUserSort="True" IsReadOnly="True"/>
                    </DataGrid.Columns>
                </DataGrid>
                <Grid Grid.Row="1">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Button Name="Ok" Style="{StaticResource xButton}" Content="Ok" Grid.Column="0" Grid.Row="1" Margin="10"/>
                    <Button Name="Cancel" Style="{StaticResource xButton}" Content="Cancel" Grid.Column="1" Grid.Row="1" Margin="10"/>
                </Grid>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@

            FEDCPromo            = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Domain Controller Promotion" Width="800" Height="800" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="GroupBox" x:Key="xGroupBox">
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Padding" Value="10"/>
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
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Margin" Value="3"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border CornerRadius="5" Background="#007bff" BorderBrush="Black" BorderThickness="3">
                            <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="{x:Type ToolTip}">
            <Setter Property="Background" Value="Black"/>
            <Setter Property="Foreground" Value="LightGreen"/>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.Background>
            <ImageBrush Stretch="UniformToFill" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
        </Grid.Background>
        <Grid.RowDefinitions>
            <RowDefinition Height="24"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Menu Grid.Row="0" Height="20">
            <MenuItem Header="Command">
                <MenuItem Name="Forest" Header="Install-ADDSForest" IsCheckable="True"/>
                <MenuItem Name="Tree" Header="Install-ADDSDomain(Tree)" IsCheckable="True"/>
                <MenuItem Name="Child" Header="Install-ADDSDomain(Child)" IsCheckable="True"/>
                <MenuItem Name="Clone" Header="Install-ADDSDomainController" IsCheckable="True"/>
            </MenuItem>
        </Menu>
        <Grid Grid.Row="1">
            <Grid.Background>
                <ImageBrush Stretch="None" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
            </Grid.Background>
            <GroupBox Style="{StaticResource xGroupBox}">
                <Grid Margin="5">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="10*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Name="_ForestMode" Header="[Forest Mode]" Grid.Column="0" Margin="5">
                            <ComboBox Name="ForestMode" Height="24" SelectedIndex="0">
                                <ComboBoxItem Content="Windows Server 2000 (Default)"/>
                                <ComboBoxItem Content="Windows Server 2003"/>
                                <ComboBoxItem Content="Windows Server 2008"/>
                                <ComboBoxItem Content="Windows Server 2008 R2"/>
                                <ComboBoxItem Content="Windows Server 2012"/>
                                <ComboBoxItem Content="Windows Server 2012 R2"/>
                                <ComboBoxItem Content="Windows Server 2016"/>
                                <ComboBoxItem Content="Windows Server 2019"/>
                            </ComboBox>
                        </GroupBox>
                        <GroupBox Header="[Domain Mode]" Name="_DomainMode" Grid.Column="1" Margin="5">
                            <ComboBox Name="DomainMode" Height="24" SelectedIndex="0">
                                <ComboBoxItem Content="Windows Server 2000 (Default)"/>
                                <ComboBoxItem Content="Windows Server 2003"/>
                                <ComboBoxItem Content="Windows Server 2008"/>
                                <ComboBoxItem Content="Windows Server 2008 R2"/>
                                <ComboBoxItem Content="Windows Server 2012"/>
                                <ComboBoxItem Content="Windows Server 2012 R2"/>
                                <ComboBoxItem Content="Windows Server 2016"/>
                                <ComboBoxItem Content="Windows Server 2019"/>
                            </ComboBox>
                        </GroupBox>
                        <GroupBox Header="[Parent Domain Name]" Name="_ParentDomainName" Grid.Column="0" Margin="5">
                            <TextBox Name="ParentDomainName" Text="&lt;Domain Name&gt;" Height="20" Margin="5"/>
                        </GroupBox>
                        <GroupBox Header="[Replication Source DC]" Name="_ReplicationSourceDC" Grid.Column="1" Margin="5">
                            <TextBox Name="ReplicationSourceDC" Text="&lt;Any&gt;" Height="20" Margin="5"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="2.5*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Header="[Required Features]" Grid.Row="0" Margin="5">
                                <DataGrid Grid.Row="0" Grid.Column="0" Margin="5" Name="DataGrid" AutoGenerateColumns="False" HeadersVisibility="Column" AlternationCount="2" CanUserResizeRows="False" CanUserAddRows="False" IsTabStop="True" IsTextSearchEnabled="True" SelectionMode="Single">
                                    <DataGrid.RowStyle>
                                        <Style TargetType="{x:Type DataGridRow}">
                                            <Style.Triggers>
                                                <Trigger Property="AlternationIndex" Value="0">
                                                    <Setter Property="Background" Value="White"/>
                                                </Trigger>
                                                <Trigger Property="AlternationIndex" Value="1">
                                                    <Setter Property="Background" Value="SkyBlue"/>
                                                </Trigger>
                                                <Trigger Property="IsMouseOver" Value="True">
                                                    <Setter Property="ToolTip">
                                                        <Setter.Value>
                                                            <TextBlock Text="{Binding DisplayName}" TextWrapping="Wrap" Width="400" Background="#000000" Foreground="#00FF00"/>
                                                        </Setter.Value>
                                                    </Setter>
                                                    <Setter Property="ToolTipService.ShowDuration" Value="360000000"/>
                                                </Trigger>
                                            </Style.Triggers>
                                        </Style>
                                    </DataGrid.RowStyle>
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Width="200" Binding="{Binding Name}" CanUserSort="True" IsReadOnly="True"/>
                                        <DataGridTemplateColumn Header="Install" Width="65">
                                            <DataGridTemplateColumn.CellTemplate>
                                                <DataTemplate>
                                                    <CheckBox IsEnabled="{Binding Installed}" IsChecked="True"/>
                                                </DataTemplate>
                                            </DataGridTemplateColumn.CellTemplate>
                                        </DataGridTemplateColumn>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Roles]" Margin="5">
                                <Grid>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height="*"/>
                                        <RowDefinition Height="*"/>
                                        <RowDefinition Height="*"/>
                                        <RowDefinition Height="*"/>
                                    </Grid.RowDefinitions>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="5*"/>
                                    </Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="1" Grid.Row="0" Margin="5" TextAlignment="Left" VerticalAlignment="Center" Text="Install DNS"/>
                                    <TextBlock Grid.Column="1" Grid.Row="1" Margin="5" TextAlignment="Left" VerticalAlignment="Center" Text="Create DNS Delegation"/>
                                    <TextBlock Grid.Column="1" Grid.Row="2" Margin="5" TextAlignment="Left" VerticalAlignment="Center" Text="No Global Catalog"/>
                                    <TextBlock Grid.Column="1" Grid.Row="3" Margin="5" TextAlignment="Left" VerticalAlignment="Center" Text="Critical Replication Only"/>
                                    <CheckBox Grid.Column="0" Grid.Row="0" Margin="5" HorizontalAlignment="Right" VerticalAlignment="Center" Name="InstallDNS"/>
                                    <CheckBox Grid.Column="0" Grid.Row="1" Margin="5" HorizontalAlignment="Right" VerticalAlignment="Center" Name="CreateDNSDelegation"/>
                                    <CheckBox Grid.Column="0" Grid.Row="2" Margin="5" HorizontalAlignment="Right" VerticalAlignment="Center" Name="NoGlobalCatalog"/>
                                    <CheckBox Grid.Column="0" Grid.Row="3" Margin="5" HorizontalAlignment="Right" VerticalAlignment="Center" Name="CriticalReplicationOnly"/>
                                </Grid>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Column="1">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Domain Name]" Name="_DomainName">
                                <TextBox Height="20" Margin="5" Name="DomainName"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Domain NetBIOS Name]" Name="_DomainNetBIOSName">
                                <TextBox Height="20" Margin="5" Name="DomainNetBIOSName"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[New Domain Name]" Name="_NewDomainName">
                                <TextBox Height="20" Margin="5" Name="NewDomainName"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[New Domain NetBIOS Name]" Name="_NewDomainNetBIOSName">
                                <TextBox Height="20" Margin="5" Name="NewDomainNetBIOSName"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Site Name]" Name="_SiteName">
                                <TextBox Height="20" Margin="5" Name="SiteName"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Database Path]" Name="_DatabasePath">
                                <TextBox Height="20" Margin="5" Name="DatabasePath"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[Sysvol Path]" Name="_SysvolPath">
                                <TextBox Height="20" Margin="5" Name="SysvolPath"/>
                            </GroupBox>
                            <GroupBox Grid.Row="7" Header="[Log Path]" Name="_LogPath">
                                <TextBox Height="20" Margin="5" Name="LogPath"/>
                            </GroupBox>
                            <GroupBox Grid.Row="8" Header="[Credential]" Name="_Credential">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="3*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Content="Credential" Style="{StaticResource xButton}" Name="CredentialButton" Grid.Column="0"/>
                                    <TextBox Height="20" Margin="5" Name="Credential" Grid.Column="1"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="9" Header="[Directory Services Recovery Mode Administrator (Password/Confirm)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <PasswordBox Grid.Column="0" Name="SafeModeAdministratorPassword" Margin="5,0,5,0" Height="20" PasswordChar="*"/>
                                    <PasswordBox Grid.Column="1" Name="Confirm" Height="20" Margin="5,0,5,0" PasswordChar="*"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="10" Header="[Initialize]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Name="Start" Style="{StaticResource xButton}" Grid.Column="0" Content="Start" />
                                    <Button Name="Cancel" Style="{StaticResource xButton}" Grid.Column="1" Content="Cancel"/>
                                </Grid>
                            </GroupBox>
                        </Grid>
                    </Grid>
                </Grid>
            </GroupBox>
        </Grid>
    </Grid>
</Window>
'@

            FERoot               = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Root Installation" Width="640" Height="500" Topmost="True" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="GroupBox" x:Key="xGroupBox">
            <Setter Property="TextBlock.TextAlignment" Value="Center"/>
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Foreground" Value="White"/>
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
        <Style TargetType="Label" x:Key="xLabel">
            <Setter Property="TextBlock.TextAlignment" Value="Center"/>
            <Setter Property="FontWeight" Value="Medium"/>
            <Setter Property="FontSize" Value="18"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Label">
                        <Border CornerRadius="5" Background="#FF0080FF" BorderBrush="Black" BorderThickness="3">
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
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border CornerRadius="5" Background="#FF5F3F3F" BorderBrush="Black" BorderThickness="3">
                            <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.Background>
            <ImageBrush Stretch="UniformToFill" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
        </Grid.Background>
        <Grid.RowDefinitions>
            <RowDefinition Height="250"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Image Grid.Row="0" Source="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\banner.png"/>
        <GroupBox Grid.Row="1" Style="{StaticResource xGroupBox}">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="1.25*"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <Label Grid.Row="0" Content="[Root Installation]" Style="{StaticResource xLabel}">
                </Label>
                <GroupBox Grid.Row="1" Header="[Designate an installation path for (Apps/Drivers/Packages/Features/Updates/Images)]" Foreground="Black">
                    <TextBox Name="FilePath" Grid.Row="0" Grid.Column="1" Height="20" Background="White" Margin="10" Foreground="Black"/>
                </GroupBox>
                <Grid Grid.Row="2">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Button Name="Start" Grid.Column="0" Style="{StaticResource xButton}" Content="Start"/>
                    <Button Name="Cancel" Grid.Column="1" Style="{StaticResource xButton}" Content="Cancel"/>
                </Grid>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@

            FEService            = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://ViperBomb Services" Height="800" Width="800" Topmost="True" BorderBrush="Black" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" ResizeMode="NoResize" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="Label">
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Padding" Value="5"/>
        </Style>
        <Style x:Key="SeparatorStyle1" TargetType="{x:Type Separator}">
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="Margin" Value="0,0,0,0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type Separator}">
                        <Border Height="24" SnapsToDevicePixels="True" Background="#FF4D4D4D" BorderBrush="Azure" BorderThickness="1,1,1,1" CornerRadius="5,5,5,5"/>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="{x:Type ToolTip}">
            <Setter Property="Background" Value="Black"/>
            <Setter Property="Foreground" Value="LightGreen"/>
        </Style>
        <Style TargetType="GroupBox" x:Key="xGroupBox">
            <Setter Property="TextBlock.TextAlignment" Value="Center"/>
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Foreground" Value="White"/>
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
        <Style TargetType="CheckBox" x:Key="xCheckBox">
            <Setter Property="HorizontalAlignment" Value="Left"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="5"/>
        </Style>
        <Style TargetType="Label" x:Key="xLabel">
            <Setter Property="TextBlock.TextAlignment" Value="Center"/>
            <Setter Property="FontWeight" Value="Medium"/>
            <Setter Property="FontSize" Value="18"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Label">
                        <Border CornerRadius="5" Background="#FF0080FF" BorderBrush="Black" BorderThickness="3">
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
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border CornerRadius="5" Background="#FF0080FF" BorderBrush="Black" BorderThickness="3">
                            <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.Background>
            <ImageBrush Stretch="UniformToFill" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
        </Grid.Background>
        <Grid.RowDefinitions>
            <RowDefinition Height="20"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="100"/>
        </Grid.RowDefinitions>
        <Menu Grid.Row="0" IsMainMenu="True">
            <MenuItem Header="Configuration">
                <MenuItem Name="Profile_0" Header="0 - Windows 10 Home / Default Max"/>
                <MenuItem Name="Profile_1" Header="1 - Windows 10 Home / Default Min"/>
                <MenuItem Name="Profile_2" Header="2 - Windows 10 Pro / Default Max"/>
                <MenuItem Name="Profile_3" Header="3 - Windows 10 Pro / Default Min"/>
                <MenuItem Name="Profile_4" Header="4 - Desktop / Default Max"/>
                <MenuItem Name="Profile_5" Header="5 - Desktop / Default Min"/>
                <MenuItem Name="Profile_6" Header="6 - Desktop / Default Max"/>
                <MenuItem Name="Profile_7" Header="7 - Desktop / Default Min"/>
                <MenuItem Name="Profile_8" Header="8 - Laptop / Default Max"/>
                <MenuItem Name="Profile_9" Header="9 - Laptop / Default Min"/>
            </MenuItem>
            <MenuItem Header="Info">
                <MenuItem Name="URL" Header="Resources"/>
                <MenuItem Name="About" Header="About"/>
                <MenuItem Name="Copyright" Header="Copyright"/>
                <MenuItem Name="MadBomb" Header="MadBomb122"/>
                <MenuItem Name="BlackViper" Header="BlackViper"/>
                <MenuItem Name="Site" Header="Company Website"/>
                <MenuItem Name="Help" Header="Help"/>
            </MenuItem>
        </Menu>
        <GroupBox Grid.Row="1" Style="{StaticResource xGroupBox}">
            <Grid>
                <TabControl BorderBrush="Gainsboro" Name="TabControl">
                    <TabControl.Resources>
                        <Style TargetType="TabItem">
                            <Setter Property="Template">
                                <Setter.Value>
                                    <ControlTemplate TargetType="TabItem">
                                        <Border Name="Border" BorderThickness="1,1,1,0" BorderBrush="Gainsboro" CornerRadius="4,4,0,0" Margin="2,0">
                                            <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Center" ContentSource="Header" Margin="10,2"/>
                                        </Border>
                                        <ControlTemplate.Triggers>
                                            <Trigger Property="IsSelected" Value="True">
                                                <Setter TargetName="Border" Property="Background" Value="LightSkyBlue"/>
                                            </Trigger>
                                            <Trigger Property="IsSelected" Value="False">
                                                <Setter TargetName="Border" Property="Background" Value="GhostWhite"/>
                                            </Trigger>
                                        </ControlTemplate.Triggers>
                                    </ControlTemplate>
                                </Setter.Value>
                            </Setter>
                        </Style>
                    </TabControl.Resources>
                    <TabItem Header="Main">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="60"/>
                                <RowDefinition Height="32"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="0.45*"/>
                                    <ColumnDefinition Width="0.15*"/>
                                    <ColumnDefinition Width="0.25*"/>
                                    <ColumnDefinition Width="0.15*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="Operating System" Margin="5">
                                    <Label Name="Caption"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="Release ID" Margin="5">
                                    <Label Name="ReleaseID"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="Version" Margin="5">
                                    <Label Name="Version"/>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="Chassis" Margin="5">
                                    <Label Name="Chassis"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="0.66*"/>
                                    <ColumnDefinition Width="0.33*"/>
                                    <ColumnDefinition Width="1*"/>
                                </Grid.ColumnDefinitions>
                                <TextBox Grid.Column="0" Margin="5" Name="Search" TextWrapping="Wrap">
                                </TextBox>
                                <ComboBox Grid.Column="1" Margin="5" Name="Select" VerticalAlignment="Center">
                                    <ComboBoxItem Content="Checked"/>
                                    <ComboBoxItem Content="DisplayName" IsSelected="True"/>
                                    <ComboBoxItem Content="Name"/>
                                </ComboBox>
                                <TextBlock Grid.Column="2" Margin="5" TextAlignment="Center">Service State: <Run Background="#66FF66" Text="Compliant"/> / <Run Background="#FFFF66" Text="Unspecified"/> / <Run Background="#FF6666" Text="Non Compliant"/>
                                </TextBlock>
                            </Grid>
                            <DataGrid Grid.Row="2" Grid.Column="0" Name="DataGrid" AutoGenerateColumns="False" AlternationCount="2" HeadersVisibility="Column" CanUserResizeRows="False" CanUserAddRows="False" IsTabStop="True" IsTextSearchEnabled="True" SelectionMode="Extended">
                                <DataGrid.RowStyle>
                                    <Style TargetType="{x:Type DataGridRow}">
                                        <Style.Triggers>
                                            <Trigger Property="AlternationIndex" Value="0">
                                                <Setter Property="Background" Value="White"/>
                                            </Trigger>
                                            <Trigger Property="AlternationIndex" Value="1">
                                                <Setter Property="Background" Value="SkyBlue"/>
                                            </Trigger>
                                            <Trigger Property="IsMouseOver" Value="True">
                                                <Setter Property="ToolTip">
                                                    <Setter.Value>
                                                        <TextBlock Text="{Binding Description}" TextWrapping="Wrap" Width="400" Background="#000000" Foreground="#00FF00"/>
                                                    </Setter.Value>
                                                </Setter>
                                                <Setter Property="ToolTipService.ShowDuration" Value="360000000"/>
                                            </Trigger>
                                            <MultiDataTrigger>
                                                <MultiDataTrigger.Conditions>
                                                    <Condition Binding="{Binding Scope}" Value="True"/>
                                                    <Condition Binding="{Binding Matches}" Value="False"/>
                                                </MultiDataTrigger.Conditions>
                                                <Setter Property="Background" Value="#F08080"/>
                                            </MultiDataTrigger>
                                            <MultiDataTrigger>
                                                <MultiDataTrigger.Conditions>
                                                    <Condition Binding="{Binding Scope}" Value="False"/>
                                                    <Condition Binding="{Binding Matches}" Value="False"/>
                                                </MultiDataTrigger.Conditions>
                                                <Setter Property="Background" Value="#FFFFFF64"/>
                                            </MultiDataTrigger>
                                            <MultiDataTrigger>
                                                <MultiDataTrigger.Conditions>
                                                    <Condition Binding="{Binding Scope}" Value="True"/>
                                                    <Condition Binding="{Binding Matches}" Value="True"/>
                                                </MultiDataTrigger.Conditions>
                                                <Setter Property="Background" Value="LightGreen"/>
                                            </MultiDataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </DataGrid.RowStyle>
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Index" Width="50" Binding="{Binding Index}" CanUserSort="True" IsReadOnly="True"/>
                                    <DataGridTextColumn Header="Name" Width="150" Binding="{Binding Name}" CanUserSort="True" IsReadOnly="True"/>
                                    <DataGridTextColumn Header="Scoped" Width="75" Binding="{Binding Scope}" CanUserSort="True" IsReadOnly="True"/>
                                    <DataGridTemplateColumn Header="Profile" Width="100">
                                        <DataGridTemplateColumn.CellTemplate>
                                            <DataTemplate>
                                                <ComboBox SelectedIndex="{Binding Slot}">
                                                    <ComboBoxItem Content="Skip"/>
                                                    <ComboBoxItem Content="Disabled"/>
                                                    <ComboBoxItem Content="Manual"/>
                                                    <ComboBoxItem Content="Auto"/>
                                                    <ComboBoxItem Content="Auto (Delayed)"/>
                                                </ComboBox>
                                            </DataTemplate>
                                        </DataGridTemplateColumn.CellTemplate>
                                    </DataGridTemplateColumn>
                                    <DataGridTextColumn Header="Status" Width="75" Binding="{Binding Status}" CanUserSort="True" IsReadOnly="True"/>
                                    <DataGridTextColumn Header="StartType" Width="75" Binding="{Binding StartMode}" CanUserSort="True" IsReadOnly="True"/>
                                    <DataGridTextColumn Header="DisplayName" Width="150" Binding="{Binding DisplayName}" CanUserSort="True" IsReadOnly="True"/>
                                    <DataGridTextColumn Header="PathName" Width="150" Binding="{Binding PathName}" CanUserSort="True" IsReadOnly="True"/>
                                    <DataGridTextColumn Header="Description" Width="150" Binding="{Binding Description}" CanUserSort="True" IsReadOnly="True"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Preferences">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="2*"/>
                            </Grid.ColumnDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="0.75*"/>
                                    <RowDefinition Height="0.75*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row="0" Header="[Bypass]" Margin="5">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <CheckBox Grid.Row="1" Margin="5" Name="ByBuild" Content="Skip Build/Version Check" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                                        <ComboBox Grid.Row="0" VerticalAlignment="Center" Height="24" Name="ByEdition">
                                            <ComboBoxItem Content="Override Edition Check" IsSelected="True"/>
                                            <ComboBoxItem Content="Windows 10 Home"/>
                                            <ComboBoxItem Content="Windows 10 Pro"/>
                                        </ComboBox>
                                        <CheckBox Grid.Row="2" Margin="5" Name="ByLaptop" Content="Enable Laptop Tweaks" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Row="1" Header="[Display]" Margin="5">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <CheckBox Grid.Row="0" Margin="5" Name="DispActive" Content="Show Active Services" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                                        <CheckBox Grid.Row="1" Margin="5" Name="DispInactive" Content="Show Inactive Services" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                                        <CheckBox Grid.Row="2" Margin="5" Name="DispSkipped" Content="Show Skipped Services" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Row="2" Header="[Miscellaneous]" Margin="5">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <CheckBox Grid.Row="0" Margin="5" Name="MiscSimulate" Content="Simulate Changes [Dry Run]" />
                                        <CheckBox Grid.Row="1" Margin="5" Name="MiscXbox" Content="Skip All Xbox Services" />
                                        <CheckBox Grid.Row="2" Margin="5" Name="MiscChange" Content="Allow Change of Service State" />
                                        <CheckBox Grid.Row="3" Margin="5" Name="MiscStopDisabled" Content="Stop Disabled Services" />
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Row="3" Header="[Development]" Margin="5">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <CheckBox Grid.Row="0" Style="{StaticResource xCheckBox}" Name="DevErrors" Content="Diagnostic Output [ On Error ]" />
                                        <CheckBox Grid.Row="1" Margin="5" Name="DevLog" Content="Enable Development Logging" />
                                        <CheckBox Grid.Row="2" Margin="5" Name="DevConsole" Content="Enable Console" />
                                        <CheckBox Grid.Row="3" Margin="5" Name="DevReport" Content="Enable Diagnostic" />
                                    </Grid>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Column="1">
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="3*"/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row="0" Header="[Logging] - Create logs for all changes made via this utility" Margin="5">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="80"/>
                                            <ColumnDefinition Width="80"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <CheckBox Style="{StaticResource xCheckBox}" Grid.Row="0" Grid.Column="0" Name="LogSvcSwitch" Content="Services" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        <Button Style="{StaticResource xButton}" Grid.Row="0" Grid.Column="1" Margin="5" Name="LogSvcBrowse" Content="Browse"/>
                                        <TextBox Grid.Row="0" Grid.Column="2" Margin="5" Name="LogSvcFile" IsEnabled="False" HorizontalAlignment="Stretch" VerticalAlignment="Center" />
                                        <CheckBox Style="{StaticResource xCheckBox}" Grid.Row="1" Grid.Column="0" Margin="5" Name="LogScrSwitch" Content="Script" VerticalAlignment="Center" HorizontalAlignment="Center" />
                                        <Button Style="{StaticResource xButton}" Grid.Row="1" Grid.Column="1" Margin="5" Name="LogScrBrowse" Content="Browse"/>
                                        <TextBox Grid.Row="1" Grid.Column="2" Margin="5" Name="LogScrFile" IsEnabled="False" HorizontalAlignment="Stretch" VerticalAlignment="Center" />
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Row="1" Header="[Backup] - Save your current Service Configuration" Margin="5">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="80"/>
                                            <ColumnDefinition Width="80"/>
                                            <ColumnDefinition Width="5*"/>
                                        </Grid.ColumnDefinitions>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <CheckBox Style="{StaticResource xCheckBox}" Grid.Row="0" Grid.Column="0" Margin="5" Name="RegSwitch" Content="*.reg" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        <Button Style="{StaticResource xButton}" Grid.Row="0" Grid.Column="1" Margin="5" Name="RegBrowse" Content="Browse"/>
                                        <TextBox Grid.Row="0" Grid.Column="2" Margin="5" Name="RegFile" IsEnabled="False" HorizontalAlignment="Stretch" VerticalAlignment="Center" />
                                        <CheckBox Style="{StaticResource xCheckBox}" Grid.Row="1" Grid.Column="0" Margin="5" Name="CsvSwitch" Content="*.csv" HorizontalAlignment="Center" VerticalAlignment="Center" />
                                        <Button Style="{StaticResource xButton}" Grid.Row="1" Grid.Column="1" Margin="5" Name="CsvBrowse" Content="Browse"/>
                                        <TextBox Grid.Row="1" Grid.Column="2" Margin="5" Name="CsvFile" IsEnabled="False" VerticalAlignment="Center" />
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Row="2" Header="[(Console/Diagnostics)]">
                                    <TextBlock  Margin="5" TextAlignment="Left">Not yet implemented</TextBlock>
                                </GroupBox>
                            </Grid>
                        </Grid>
                    </TabItem>
                </TabControl>
            </Grid>
        </GroupBox>
        <GroupBox Grid.Row="2" Style="{StaticResource xGroupBox}">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="2*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="2*"/>
                </Grid.ColumnDefinitions>
                <GroupBox Grid.Column="0" Header="[Service Configuration]" Foreground="Black" Margin="5">
                    <ComboBox Name="ServiceCfg" Margin="5" SelectedIndex="0" IsEnabled="False">
                        <ComboBoxItem Content="Black Viper (Sparks v1.0)" IsSelected="True"/>
                        <ComboBoxItem Content="DevOPS (MC/SDP v1.0)" IsSelected="False"/>
                    </ComboBox>
                </GroupBox>
                <Button Grid.Column="1" Style="{StaticResource xButton}" Name="Start" Content="Start"/>
                <Button Grid.Column="2" Style="{StaticResource xButton}" Name="Cancel" Content="Cancel"/>
                <GroupBox Grid.Column="3" Header="[Module Version]" Foreground="Black" Margin="5">
                    <ComboBox Name="ModuleCfg" Height="24" SelectedIndex="0" IsEnabled="False">
                        <ComboBoxItem Content="DevOPS (MC/SDP v1.0)" IsSelected="True"/>
                    </ComboBox>
                </GroupBox>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@
            FEShare              = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://New Deployment Share" Width="640" Height="960" Topmost="True" Icon="
C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" ResizeMode="NoResize" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
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
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="Margin" Value="2"/>
            <Setter Property="TextWrapping" Value="Wrap"/>
            <Setter Property="Height" Value="24"/>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="250"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="50"/>
        </Grid.RowDefinitions>
        <Grid.Background>
            <ImageBrush Stretch="UniformToFill" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
        </Grid.Background>
        <Image Grid.Row="0" Source="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\banner.png"/>
        <TabControl Grid.Row="1" Background="{x:Null}" BorderBrush="Black" Foreground="{x:Null}" HorizontalAlignment="Center">
            <TabControl.Resources>
                <Style TargetType="TabItem">
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="TabItem">
                                <Border Name="Border" BorderThickness="1,1,1,0" BorderBrush="Gainsboro" CornerRadius="4,4,0,0" Margin="2,0">
                                    <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Center" ContentSource="Header" Margin="10,2"/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <Trigger Property="IsSelected" Value="True">
                                        <Setter TargetName="Border" Property="Background" Value="LightSkyBlue"/>
                                    </Trigger>
                                    <Trigger Property="IsSelected" Value="False">
                                        <Setter TargetName="Border" Property="Background" Value="GhostWhite"/>
                                    </Trigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </TabControl.Resources>
            <TabItem Header="Stage Deployment Server" BorderBrush="{x:Null}" Width="280">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <GroupBox Style="{StaticResource xGroupBox}" Grid.Row="0" Margin="10" Padding="5" Foreground="Black" Background="White">
                        <Grid Grid.Row="0">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="50"/>
                                <RowDefinition Height="30"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Label Content="[Deployment Share]" Style="{StaticResource HeadLabel}" Foreground="White" Grid.Row="0"/>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <RadioButton Grid.Column="0" Content="Standard @ MDT Share" Name="Legacy" Style="{StaticResource RadButton}"/>
                                <RadioButton Grid.Column="1" Content="Enhanced @ PSD Share" Name="Remaster" Style="{StaticResource RadButton}"/>
                            </Grid>
                            <GroupBox Grid.Row="2" Header="[Directory Path]">
                                <TextBox Style="{StaticResource TextBro}" Name="Directory"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Samba Share]">
                                <TextBox Style="{StaticResource TextBro}" Name="Samba"/>
                            </GroupBox>
                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="2*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[PS Drive]">
                                    <TextBox Style="{StaticResource TextBro}" Name="DSDrive"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Description]">
                                    <TextBox Style="{StaticResource TextBro}" Name="Description"/>
                                </GroupBox>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox  Style="{StaticResource xGroupBox}" Grid.Row="1" Margin="10" Padding="5" Foreground="Black" Background="White">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="50"/>
                                <RowDefinition Height="30"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Label Content="[BITS/IIS]" Style="{StaticResource HeadLabel}" Foreground="White" Grid.Row="0"/>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <RadioButton Grid.Column="0" Name="IIS_Install" Content="Install BITS/IIS for MDT" Style="{ StaticResource RadButton }"/>
                                <RadioButton Grid.Column="1" Name="IIS_Skip" Content="Do not install BITS/IIS for MDT" Style="{ StaticResource RadButton }"/>
                            </Grid>
                            <GroupBox Grid.Row="2" Header="[Name]">
                                <TextBox Style="{StaticResource TextBro}" Name="IIS_Name"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[App Pool]">
                                <TextBox Style="{StaticResource TextBro}" Name="IIS_AppPool"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Virtual Host]">
                                <TextBox Style="{StaticResource TextBro}" Name="IIS_Proxy"/>
                            </GroupBox>
                        </Grid>
                    </GroupBox>
                </Grid>
            </TabItem>
            <TabItem Header="Image Info" HorizontalAlignment="Center" Width="280" BorderBrush="{x:Null}" Height="22" Margin="0,-2,0,0" VerticalAlignment="Top">
                <TabItem.Effect>
                    <DropShadowEffect/>
                </TabItem.Effect>
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="7*"/>
                        <RowDefinition Height="5*"/>
                    </Grid.RowDefinitions>
                    <GroupBox Style="{StaticResource xGroupBox}" Grid.Row="0" Margin="10" Padding="5" Foreground="Black" Background="White">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="50"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Label Grid.Row="0" Style="{StaticResource HeadLabel}" Content="[Branding]"/>
                            <GroupBox Grid.Row="1" Header="[Organization]">
                                <TextBox Style="{StaticResource TextBro}" Name="Company"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Support Website]">
                                <TextBox Style="{StaticResource TextBro}" Name="WWW"/>
                            </GroupBox>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Support Phone]">
                                    <TextBox Style="{StaticResource TextBro}" Name="Phone"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Support Hours]">
                                    <TextBox Style="{StaticResource TextBro}" Name="Hours"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="4" Grid.RowSpan="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="100"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Button Style="{StaticResource xButton}" Grid.Row="0" Grid.Column="0" Content="Logo" Name="LogoBrowse"/>
                                <GroupBox Header="[Logo (120x120) Bitmap/*.bmp]" Grid.Row="0" Grid.Column="1">
                                    <TextBox Style="{StaticResource TextBro}" Margin="5" Name="Logo"/>
                                </GroupBox>
                                <Button Style="{StaticResource xButton}" Grid.Row="1" Grid.Column="0" Content="Background" Name="BackgroundBrowse"/>
                                <GroupBox Header="Background (Common Image File)" Grid.Row="1" Grid.Column="1">
                                    <TextBox Style="{StaticResource TextBro}" Width="400" Grid.Column="1" Name="Background"/>
                                </GroupBox>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox  Style="{StaticResource xGroupBox}" Grid.Row="1" Margin="10" Padding="5" Foreground="Black" Background="White">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="50"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Label Grid.Row="0" Style="{StaticResource HeadLabel}" Content="[Domain/Network]"/>
                            <GroupBox Grid.Row="1" Header="Domain Name">
                                <TextBox Style="{StaticResource TextBro}" Name="Branch"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="NetBIOS Domain">
                                <TextBox Style="{StaticResource TextBro}" Name="NetBIOS"/>
                            </GroupBox>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="Target/Local Administrator UserName">
                                    <TextBox Style="{StaticResource TextBro}" Name="LMCred_User"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="Target/Local Administrator Password">
                                    <PasswordBox Margin="5" Name="LMCred_Pass" PasswordChar="*"/>
                                </GroupBox>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
            </TabItem>
        </TabControl>
        <Grid Grid.Row="2">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Button Style="{StaticResource xButton}" Grid.Column="0" Name="Start" Content="Start" Width="100" Height="32"/>
            <Button Style="{StaticResource xButton}" Grid.Column="1" Name="Cancel" Content="Cancel" Width="100" Height="32"/>
        </Grid>
    </Grid>
</Window>
'@
            MBWin10 = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Windows 10 Settings/Tweaks Script By Madbomb122" Height="500" Width="700" BorderBrush="Black" Background="White">
    <Window.Resources>
        <Style x:Key="SeparatorStyle1" TargetType="{x:Type Separator}">
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="Margin" Value="0,0,0,0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type Separator}">
                        <Border Height="24" SnapsToDevicePixels="True" Background="#FF4D4D4D" BorderBrush="#FF4D4D4D" BorderThickness="0,0,0,1"/>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="{x:Type ToolTip}">
            <Setter Property="Background" Value="#FFFFFFBF"/>
        </Style>
        <Style TargetType="CheckBox" x:Key="xCheckBox">
            <Setter Property="HorizontalAlignment" Value="Left"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="5"/>
        </Style>
        <Style TargetType="Button" x:Key="xButton">
            <Setter Property="TextBlock.TextAlignment" Value="Center"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="FontWeight" Value="Medium"/>
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border CornerRadius="5" Background="#FF0080FF" BorderBrush="Black" BorderThickness="3">
                            <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
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
    </Window.Resources>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="20"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="24"/>
        </Grid.RowDefinitions>
        <Menu Grid.Row="0" VerticalAlignment="Top">
            <MenuItem Header="Help">
                <MenuItem Name="UI_Feedback"  Header="Feedback/Bug Report"/>
                <MenuItem Name="UI_FAQ"       Header="FAQ"/>
                <MenuItem Name="UI_About"     Header="About"/>
                <MenuItem Name="UI_Copyright" Header="Copyright"/>
                <MenuItem Name="UI_Contact"   Header="Contact Me"/>
            </MenuItem>
            <MenuItem Name="UI_Donation"      Header="Donate to Me" Background="#FFFFAD2F" FontWeight="Bold"/>
            <MenuItem Name="UI_Madbomb"       Header="Madbomb122&apos;s GitHub" Background="#FFFFDF4F" FontWeight="Bold"/>
        </Menu>
        <TabControl Name="TabControl" Grid.Row="1" BorderBrush="Gainsboro" TabStripPlacement="Left">
            <TabControl.Resources>
                <Style TargetType="TabItem">
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="TabItem">
                                <Border Name="Border" BorderThickness="1,1,1,0" BorderBrush="Gainsboro" CornerRadius="4" Margin="2">
                                    <ContentPresenter x:Name="ContentSite"  VerticalAlignment="Center" HorizontalAlignment="Right" ContentSource="Header" Margin="5"/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <Trigger Property="IsSelected" Value="True">
                                        <Setter TargetName="Border" Property="Background" Value="LightSkyBlue" />
                                    </Trigger>
                                    <Trigger Property="IsSelected" Value="False">
                                        <Setter TargetName="Border" Property="Background" Value="GhostWhite" />
                                    </Trigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </TabControl.Resources>
            <TabItem Header="Preferences">
                <GroupBox Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="160"/>
                            <RowDefinition Height="90"/>
                            <RowDefinition Height="90"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="Global" Margin="5">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <CheckBox Grid.Row="0" Style="{StaticResource xCheckBox}" Name="UI_RestorePoint"  Content="Create Restore Point"/>
                                <CheckBox Grid.Row="1" Style="{StaticResource xCheckBox}" Name="UI_ShowSkipped"   Content="Show Skipped Items"/>
                                <CheckBox Grid.Row="2" Style="{StaticResource xCheckBox}" Name="UI_Restart"       Content="Restart When Done (Restart is Recommended)"/>
                                <CheckBox Grid.Row="3" Style="{StaticResource xCheckBox}" Name="UI_VersionCheck"  Content="Check for Update (If found, will run with current settings)"/>
                                <CheckBox Grid.Row="4" Style="{StaticResource xCheckBox}" Name="UI_InternetCheck" Content="Skip Internet Check"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="Backup" Margin="5">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Style="{StaticResource xButton}" Name="UI_Save"         Content="Save Settings"/>
                                <Button Grid.Column="1" Style="{StaticResource xButton}" Name="UI_Load"         Content="Load Settings"/>
                                <Button Grid.Column="2" Style="{StaticResource xButton}" Name="UI_WinDefault"   Content="Windows Default"/>
                                <Button Grid.Column="3" Style="{StaticResource xButton}" Name="UI_ResetDefault" Content="Reset All Items"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="Script" Margin="5">
                            <ComboBox Margin="5" Height="24" IsEnabled="False">
                                <ComboBoxItem Content="Rewrite Module Version" IsSelected="True"/>
                            </ComboBox>
                        </GroupBox>
                    </Grid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Privacy">
                <GroupBox Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid Grid.Column="0">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Telemetry]">
                                <ComboBox Name="_Telemetry"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Wi-Fi Sense]">
                                <ComboBox Name="_WiFiSense"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[SmartScreen]">
                                <ComboBox Name="_SmartScreen"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Location Tracking]">
                                <ComboBox Name="_LocationTracking"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Feedback]">
                                <ComboBox Name="_Feedback"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Advertising ID]">
                                <ComboBox Name="_AdvertisingID"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Column="1">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Cortana]">
                                <ComboBox Name="_Cortana"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Cortana Search]">
                                <ComboBox Name="_CortanaSearch"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Error Reporting]">
                                <ComboBox Name="_ErrorReporting"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Automatic Logging]">
                                <ComboBox Name="_AutoLogging"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Diagnostics Tracking]">
                                <ComboBox Name="_DiagnosticsTracking"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Windows App]">
                                <ComboBox Name="_WindowsApp"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[Windows Store Auto Download]">
                                <ComboBox Name="_WindowsAppAutoDL"/>
                            </GroupBox>
                        </Grid>
                    </Grid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Services">
                <GroupBox Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid Grid.Column="0">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[UAC Level]">
                                <ComboBox Name="_UAC"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Share Mapped Drives]">
                                <ComboBox Name="_SMBDrives"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Administrative Shares]">
                                <ComboBox Name="_AdminShares"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Firewall]">
                                <ComboBox Name="_Firewall"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Column="1">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Windows Defender]">
                                <ComboBox Name="_WinDefender"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[HomeGroups]">
                                <ComboBox Name="_HomeGroups"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Remote Assistance]">
                                <ComboBox Name="_RemoteAssistance"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Remote Desktop w/ Network Authentication]">
                                <ComboBox Name="_RemoteDesktop"/>
                            </GroupBox>
                        </Grid>
                    </Grid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Context/Start">
                <GroupBox  Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid Grid.Column="0">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Cast to Device]">
                                <ComboBox Name="_CastToDevice"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Previous Versions]">
                                <ComboBox Name="_PreviousVersions"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Include in Library]">
                                <ComboBox Name="_IncludeinLibrary"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Pin to Start]">
                                <ComboBox Name="_PinToStart"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Pin to Quick Access]">
                                <ComboBox Name="_PinToQuickAccess"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Share w/...]">
                                <ComboBox Name="_ShareWith"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[Send To...]">
                                <ComboBox Name="_SendTo"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Column="1">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Bing Search]">
                                <ComboBox Name="_StartMenuWebSearch"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Start Suggestions]">
                                <ComboBox Name="_StartSuggestions"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Most Used Apps]">
                                <ComboBox Name="_MostUsedAppStartMenu"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Recent Items/Frequent Places]">
                                <ComboBox Name="_RecentItemsFrequent"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Unpin All Items]">
                                <ComboBox Name="_UnpinItems"/>
                            </GroupBox>
                        </Grid>
                    </Grid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Taskbar">
                <GroupBox Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid Grid.Column="0">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Battery UI Bar]">
                                <ComboBox Name="_BatteryUIBar"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Clock UI Bar]">
                                <ComboBox Name="_ClockUIBar"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Volume Control Bar]">
                                <ComboBox Name="_VolumeControlBar"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Taskbar Search Box]">
                                <ComboBox Name="_TaskbarSearchBox"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Task View Button]">
                                <ComboBox Name="_TaskViewButton"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Taskbar Icon Size]">
                                <ComboBox Name="_TaskbarIconSize"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Column="1">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Taskbar Item Grouping]">
                                <ComboBox Name="_TaskbarGrouping"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Tray Icons]">
                                <ComboBox Name="_TrayIcons"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Seconds In Clock]">
                                <ComboBox Name="_SecondsInClock"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Last Active Click]">
                                <ComboBox Name="_LastActiveClick"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Taskbar on Multi-Display]">
                                <ComboBox Name="_TaskBarMultiDisplay"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Taskbar button on Multi-Display]">
                                <ComboBox Name="_TaskbarButtonMultiDisplay"/>
                            </GroupBox>
                        </Grid>
                    </Grid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Explorer">
                <GroupBox Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid Grid.Column="0">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Quick Access/recent files]">
                                <ComboBox Name="_RecentFileQuickAccess"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Quick Access/frequent folders]">
                                <ComboBox Name="_FrequentFoldersQuickAccess"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Show window while dragging]">
                                <ComboBox Name="_WinContentWhileDrag"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Search unknown file extensions]">
                                <ComboBox Name="_StoreOpenWith"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Show long file path(s)]">
                                <ComboBox Name="_LongFilePath"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Default Explorer View]">
                                <ComboBox Name="_ExplorerOpenLoc"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[PowerShell -> Command-X]">
                                <ComboBox Name="_WinXPowerShell" />
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Column="1">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[App hibernation file]">
                                <ComboBox Name="_AppHibernationFile"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Process ID on title bar]">
                                <ComboBox Name="_PidTitleBar"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Accessibility key prompt]">
                                <ComboBox Name="_AccessKeyPrompt"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Window Timeline]">
                                <ComboBox Name="_Timeline"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Aero Snap]">
                                <ComboBox Name="_AeroSnap"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Aero Shake]">
                                <ComboBox Name="_AeroShake"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[Known Extentions]">
                                <ComboBox Name="_KnownExtensions"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Column="2">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Hidden Files]">
                                <ComboBox Name="_HiddenFiles"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[System Files]">
                                <ComboBox Name="_SystemFiles"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Auto-Play]">
                                <ComboBox Name="_AutoPlay"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[AutoRun]">
                                <ComboBox Name="_AutoRun"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Task Manager Details]">
                                <ComboBox Name="_TaskManager"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[F1 Help Key]">
                                <ComboBox Name="_F1HelpKey"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[Reopen apps after reboot]">
                                <ComboBox Name="_ReopenApps"/>
                            </GroupBox>
                        </Grid>
                    </Grid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Desktop/PC">
                <GroupBox Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="Desktop" Margin="5">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row="0" Header="[This PC]">
                                    <ComboBox Name="_ThisPC_Icon"/>
                                </GroupBox>
                                <GroupBox Grid.Row="1" Header="[Network]">
                                    <ComboBox Name="_Network_Icon"/>
                                </GroupBox>
                                <GroupBox Grid.Row="2" Header="[Recycle Bin]">
                                    <ComboBox Name="_RecycleBin_Icon"/>
                                </GroupBox>
                                <GroupBox Grid.Row="3" Header="[Documents]">
                                    <ComboBox Name="_Documents_Icon"/>
                                </GroupBox>
                                <GroupBox Grid.Row="4" Header="[Control Panel]">
                                    <ComboBox Name="_ControlPanel_Icon"/>
                                </GroupBox>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="This PC" Margin="5">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row="0" Header="[Desktop]">
                                    <ComboBox Name="_Desktop_Folder"/>
                                </GroupBox>
                                <GroupBox Grid.Row="1" Header="[Documents]">
                                    <ComboBox Name="_Documents_Folder"/>
                                </GroupBox>
                                <GroupBox Grid.Row="2" Header="[Downloads]">
                                    <ComboBox Name="_Downloads_Folder"/>
                                </GroupBox>
                                <GroupBox Grid.Row="3" Header="[Music]">
                                    <ComboBox Name="_Music_Folder"/>
                                </GroupBox>
                                <GroupBox Grid.Row="4" Header="[Pictures]">
                                    <ComboBox Name="_Pictures_Folder"/>
                                </GroupBox>
                                <GroupBox Grid.Row="5" Header="[Videos]">
                                    <ComboBox Name="_Videos_Folder"/>
                                </GroupBox>
                                <GroupBox Grid.Row="6" Header="[3D Objects]">
                                    <ComboBox Name="_3DObjects_Folder"/>
                                </GroupBox>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Miscellaneous">
                <GroupBox Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid>
                            <Grid Grid.Column="0">
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="120"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row="0" Header="Photo Viewer" Margin="5">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <GroupBox Grid.Row="0" Header="[File Association]">
                                            <ComboBox Name="_PhotoViewerFileAssociation"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="1" Header="[Add (Open with...)]">
                                            <ComboBox Name="_PhotoViewerOpenWithMenu"/>
                                        </GroupBox>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Row="1" Header="Lockscreen" Margin="5">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <GroupBox Grid.Row="0" Header="[Lockscreen]">
                                            <ComboBox Name="_LockScreen"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="1" Header="[Power Menu]">
                                            <ComboBox Name="_PowerMenuLockScreen"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="2" Header="[Camera]">
                                            <ComboBox Name="_CameraLockScreen"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="3" Header="[Account protection warning]">
                                            <ComboBox Name="_AccountProtection"/>
                                        </GroupBox>
                                    </Grid>
                                </GroupBox>
                            </Grid>
                        </Grid>
                        <GroupBox Grid.Column="1" Header="Miscellaneous" Margin="5">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row="0" Header="[Action Center]">
                                    <ComboBox Name="_ActionCenter"/>
                                </GroupBox>
                                <GroupBox Grid.Row="1" Header="[Sticky Key Prompt]">
                                    <ComboBox Name="_StickyKeyPrompt"/>
                                </GroupBox>
                                <GroupBox Grid.Row="2" Header="[NumLock on startup]">
                                    <ComboBox Name="_NumLockStart"/>
                                </GroupBox>
                                <GroupBox Grid.Row="3" Header="[F8 Boot Menu]">
                                    <ComboBox Name="_F8BootMenu"/>
                                </GroupBox>
                                <GroupBox Grid.Row="4" Header="[Remote UAC Local Account Token Filter]">
                                    <ComboBox Name="_RemoteUACAccountToken"/>
                                </GroupBox>
                                <GroupBox Grid.Row="5" Header="[Hibernate Option]">
                                    <ComboBox Name="_HibernatePower"/>
                                </GroupBox>
                                <GroupBox Grid.Row="6" Header="[Sleep Option]">
                                    <ComboBox Name="_SleepPower"/>
                                </GroupBox>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Windows Store">
                <GroupBox Style="{StaticResource xGroupBox}">
                <DataGrid Name="DataGrid" FrozenColumnCount="2" AutoGenerateColumns="False" AlternationCount="2" HeadersVisibility="Column" CanUserResizeRows="False" CanUserAddRows="False" IsTabStop="True" IsTextSearchEnabled="True" SelectionMode="Extended" Margin="5">
                    <DataGrid.RowStyle>
                        <Style TargetType="{x:Type DataGridRow}">
                            <Style.Triggers>
                                <Trigger Property="AlternationIndex" Value="0">
                                    <Setter Property="Background" Value="White"/>
                                </Trigger>
                                <Trigger Property="AlternationIndex" Value="1">
                                    <Setter Property="Background" Value="#FFD8D8D8"/>
                                </Trigger>
                            </Style.Triggers>
                        </Style>
                    </DataGrid.RowStyle>
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Display Name" Width="150" Binding="{Binding CName}" CanUserSort="True" IsReadOnly="True"/>
                        <DataGridTemplateColumn Header="Option" Width="80" SortMemberPath="AppSelected" CanUserSort="True">
                            <DataGridTemplateColumn.CellTemplate>
                                <DataTemplate>
                                    <ComboBox ItemsSource="{Binding AppOptions}" Text="{Binding Path=AppSelected, Mode=TwoWay, UpdateSourceTrigger=PropertyChanged}"/>
                                </DataTemplate>
                            </DataGridTemplateColumn.CellTemplate>
                        </DataGridTemplateColumn>
                        <DataGridTextColumn Header="Appx Name" Width="180" Binding="{Binding AppxName}" IsReadOnly="True"/>
                    </DataGrid.Columns>
                </DataGrid>
                </GroupBox>
            </TabItem>
            <TabItem Header="Windows Update">
                <GroupBox Style="{StaticResource xGroupBox}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="Application/Feature" Margin="5">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row="0" Header="[OneDrive]">
                                    <ComboBox Name="_OneDrive"/>
                                </GroupBox>
                                <GroupBox Grid.Row="1" Header="[OneDrive Install]">
                                    <ComboBox Name="_OneDriveInstall"/>
                                </GroupBox>
                                <GroupBox Grid.Row="2" Header="[Xbox DVR]">
                                    <ComboBox Name="_XboxDVR"/>
                                </GroupBox>
                                <GroupBox Grid.Row="3" Header="[Media Player]">
                                    <ComboBox Name="_MediaPlayer"/>
                                </GroupBox>
                                <GroupBox Grid.Row="4" Header="[Work Folders]">
                                    <ComboBox Name="_WorkFolders"/>
                                </GroupBox>
                                <GroupBox Grid.Row="5" Header="[Fax and Scan]">
                                    <ComboBox Name="_FaxAndScan"/>
                                </GroupBox>
                                <GroupBox Grid.Row="6" Header="[Windows Subsystem for Linux]">
                                    <ComboBox Name="_LinuxSubsystem"/>
                                </GroupBox>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="Windows Update" Margin="5">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row="0" Header="[Check for Update]">
                                    <ComboBox Name="_CheckForWinUpdate"/>
                                </GroupBox>
                                <GroupBox Grid.Row="1" Header="[Update Check Type]">
                                    <ComboBox Name="_WinUpdateType"/>
                                </GroupBox>
                                <GroupBox Grid.Row="2" Header="[Update P2P]">
                                    <ComboBox Name="_WinUpdateDownload"/>
                                </GroupBox>
                                <GroupBox Grid.Row="3" Header="[Update MSRT]">
                                    <ComboBox Name="_UpdateMSRT"/>
                                </GroupBox>
                                <GroupBox Grid.Row="4" Header="[Update Driver]">
                                    <ComboBox Name="_UpdateDriver"/>
                                </GroupBox>
                                <GroupBox Grid.Row="5" Header="[Restart on Update]">
                                    <ComboBox Name="_RestartOnUpdate"/>
                                </GroupBox>
                                <GroupBox Grid.Row="6" Header="[Update Available Popup]">
                                    <ComboBox Name="_UpdateAvailablePopup"/>
                                </GroupBox>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </GroupBox>
            </TabItem>
        </TabControl>
        <Button Name="RunScriptButton" Grid.Row="2" Content="Run Script" VerticalAlignment="Bottom" Height="20" FontWeight="Bold"/>
    </Grid>
</Window>
'@

            NewAccount           = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://New Account" Width="400" Height="220" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
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
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Margin" Value="10"/>
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
    </Window.Resources>
    <Grid>
        <Grid.Background>
            <ImageBrush Stretch="None" ImageSource="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\background.jpg"/>
        </Grid.Background>
        <GroupBox Style="{StaticResource xGroupBox}" Width="380" Height="180" Margin="5" VerticalAlignment="Center">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <GroupBox Grid.Row="0" Header="User Name">
                    <TextBox Name="UserName" Margin="5"/>
                </GroupBox>
                <GroupBox Grid.Row="1" Header="[Password/Confirm]">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <PasswordBox Grid.Column="0" Name="Password" Margin="5"/>
                        <PasswordBox Grid.Column="1" Name="Confirm" Margin="5"/>
                    </Grid>
                </GroupBox>
                <Grid Grid.Row="2">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Button Name="Ok" Style="{StaticResource xButton}" Content="Ok" Grid.Column="0" Grid.Row="1" Margin="5"/>
                    <Button Name="Cancel" Style="{StaticResource xButton}" Content="Cancel" Grid.Column="1" Grid.Row="1" Margin="5"/>
                </Grid>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@
            Test = ""

        }

        Hidden [Object]     $Slot
        Hidden [Object]     $Swap
        Hidden [String[]]  $Stage
        Hidden [Object] $Internal 
        [Object]          $Output

        SetStage()
        {
            ForEach ( $I in 0..( $This.Glossary.Count - 1 ) )
            {
                $Item             = $This.Glossary[$I]
                $This.Swap        = $This.Swap -Replace $Item.Name, ('{0}`' -f $Item.Variable )
            }

            $This.Stage           = $This.Swap -Split "`n" -Replace "'",'"' -join ''
            $This.Internal        = @( )

            If ( $This.Stage.ToCharArray().Length -le 80 )
            {
                $This.Internal   += "{0}'{1}'" -f (" "*25),$This.Stage
            }

            Else
            {
                $This.Internal   += "{0}'{1}'" -f (" "*25),$This.Stage.Substring(0,80)
                $Item             = $This.Stage.Substring(80)
                $Return           = @{ }
                $X                = -1
                    
                ForEach ($I in 0..($Item.ToCharArray().Count - 1))
                {
                    If ( $I % 105 -eq 0 )
                    {
                        $X ++
                        $Return.Add($X,@())
                    }

                    $Return[$X]  += $Item[$I]
                }
                    
                ForEach ( $X in 0..($Return.Count - 1 ) )
                {
                    $This.Internal += ( "            '$( $Return[$X] -join '')'+" )
                }
            }

            $This.Internal[0]    += "+"
            $This.Internal[-1]    = $This.Internal[-1] -Replace "(\>\'\+)",">'"
        }

        _XamlObject([String]$Type)
        {
            If ( $Type -notin $This.Names )
            {
                Throw "Invalid Type"
            }

            $This.Slot            = $This.Xaml[$Type]

            Switch ($Type)
            {
                Default 
                {
                    $This.Slot = $This.Slot.Replace("{0}",$This.GFX.Icon)
                }
                
                FEDCPromo
                {
                    $This.Slot = $This.Slot.Replace("{0}",$This.GFX.Icon)
                }

                FERoot
                {
                    $This.Slot = $This.Slot.Replace("{0}",$This.GFX.Icon).Replace("{1}",$This.GFX.Background)
                }

                FEShare
                {
                    $This.Slot = $This.Slot.Replace("{0}",$This.GFX.Icon).Replace("{1}",$This.GFX.Background).Replace("{2}",$This.GFX.Banner)
                }

                FEService
                {
                    $This.Slot = $This.Slot.Replace("{0}",$This.GFX.Icon)
                }
            }

            $This.Swap            = $This.Slot -Replace "(\s+)"," " -Replace "(>\s*<)",">`n<" -Replace "(' />)","'/>" -Replace "(' >)","'>" -Replace "(\s*=\s*)","="
            $This.Stage           = $This.Swap -Split "`n" -Replace "'",'"' -join ''

            ForEach ( $I in 0..( $This.Glossary.Count - 1 ) )
            {
                $Item             = $This.Glossary[$I]
                $This.Stage       = $This.Stage.Replace($Item.Variable + '`', $Item.Name)
            }

            $This.Output          = $This.Stage -Replace "(\>\s*\<)",">`n<"
        }
    }

    $Xaml   = [_XamlObject]::New($Type).Output

    If ( $Return )
    {
        $Xaml
    }
    
    Else
    {
        [_XamlWindow]::New($Xaml)
    }
}

# Test
# Get-XamlWindow -Type MBWin10
