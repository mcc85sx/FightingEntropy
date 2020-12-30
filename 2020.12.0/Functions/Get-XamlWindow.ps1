Function Get-XamlWindow # // Originally based on Dr. Weltner's work, but also Jason Adkinson from Pluralsight
{
    [CmdletBinding()]Param(
    [Parameter(Mandatory)]
    [ValidateSet("Certificate","ADLogin","NewAccount","FEDCPromo","FEDCFound","FERoot","FEShare","FEService","Test")]
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
        [String[]]        $Names = ("Certificate ADLogin NewAccount FEDCPromo FEDCFound FERoot FEShare FEService Test" -Split " ")
        [Object]       $Glossary = [_XamlGlossary]::New().Output
        [Object]            $GFX = [_XamlGFX]::New("C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics")
        [Object]           $Xaml = @{ 

            Certificate          = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://Certificate Info" $W`="350" $H`='+
            '"200" Topmost="True" Icon="{0}" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$GB` $HD`="Company Information / Certificate Gener'+
            'ation" $W`="330" $H`="160" $Vx`="Top"><$G`><$G`.$RD`s><$RD` $H`="2*"/><$RD` $H`="*"/></$G`.$RD`s><$G` $G`'+ 
            '.Row="0"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="2.5*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/'+
            '></$G`.$RD`s><$TBL` $G`.Row="0" $G`.Column="0" $MA`="10" TextAlignment="Right">Company:</$TBL`><$TB` Name='+
            '"Company" $G`.Row="0" $G`.Column="1" $H`="24" $MA`="5"/><$TBL` $G`.Row="1" $G`.Column="0" $MA`="10" TextA'+ 
            'lignment="Right">Domain:</$TBL`><$TB` Name="Domain" $G`.Row="1" $G`.Column="1" $H`="24" $MA`="5"/></$G`><$'+
            'G` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$BU` Name="Ok" $CO`="Ok" $G`.Column="'+
            '0" $MA`="10"/><$BU` Name="Cancel" $CO`="Cancel" $G`.Column="1" $MA`="10"/></$G`></$G`></$GB`></$WI`>')
            ADLogin              = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://AD Login" Width="400" Height="240" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
    <GroupBox Header="Enter AD Domain Administrator Account Credentials" Width="380" Height="200" Margin="5" VerticalAlignment="Center">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="0.5*"/>
                <RowDefinition Height="0.5*"/>
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
                <Button Name="Ok" Content="Ok" Grid.Column="0" Grid.Row="1" Margin="5"/>
                <Button Name="Cancel" Content="Cancel" Grid.Column="1" Grid.Row="1" Margin="5"/>
            </Grid>
        </Grid>
    </GroupBox>
</Window>
'@
            NewAccount           = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://Account Designation" $W`="480" $H'+
            '`="280" Topmost="True" Icon="{0}" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$GB` $HD`="Enter UserName and $PW`" $W`="450" $H`'+
            '="240" $MA`="5" $Vx`="Center"><$G`><$G`.$RD`s><$RD` $H`="2*"/><$RD` $H`="1.25*"/></$G`.$RD`s><$G` $G`.Row'+
            '="0"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="3*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/><$RD`'+
            ' $H`="*"/></$G`.$RD`s><$TBL` $G`.Column="0" $G`.Row="0" $MA`="10" TextAlignment="Right"> UserName:</$TBL`>'+
            '<$TB` Name="UserName" $G`.Column="1" $G`.Row="0" $H`="24" $MA`="5"></$TB`><$TBL` $G`.Column="0" $G`.Row="1"'+
            ' $MA`="10" TextAlignment="Right"> $PW`:</$TBL`><$PW`Box Name="$PW`" $G`.Column="1" $G`.Row="1" $H`="24" $M'+
            'A`="5" $PW`Char="*"></$PW`Box><$TBL` $G`.Column="0" $G`.Row="2" $MA`="10" TextAlignment="Right"> Confirm:'+
            '</$TBL`><$PW`Box Name="Confirm" $G`.Column="1" $G`.Row="2" $H`="24" $MA`="5" $PW`Char="*"></$PW`Box></$G`>'+
            '<$G` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`'+
            '="*"/></$G`.$RD`s><Radio$BU` Name="Switch" $G`.Row="0" $G`.Column="0" $CO`="Change" $Vx`="Center" $Hx`="Ce'+
            'nter" Visibility="Collapsed"/><$TB` Name="Port" $G`.Row="0" $G`.Column="1" $Vx`="Center" $Hx`="Center" $W`'+
            '="120" IsEnabled="False" Visibility="Collapsed"> 389</$TB`><$BU` Name="Ok" $CO`="Ok" $G`.Column="0" $G`.Ro'+
            'w="1" $MA`="5"></$BU`><$BU` Name="Cancel" $CO`="Cancel" $G`.Column="1" $G`.Row="1" $MA`="5"></$BU`></$G`><'+
            '/$G`></$GB`></$WI`>')
            FEDCPromo            = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Domain Controller Promotion" Width="800" Height="800" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="20"/>
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
        <GroupBox Grid.Row="1" Header="[FEDCPromo://Domain Service Configuration]" HorizontalAlignment="Center" VerticalAlignment="Center" Width="760" Height="740">
            <Grid Margin="10">
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
                                                <Setter Property="Background" Value="#FFD8D8D8"/>
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
                                    <DataGridTemplateColumn Header="Installed" Width="57">
                                        <DataGridTemplateColumn.CellTemplate>
                                            <DataTemplate>
                                                <CheckBox IsChecked="{Binding Installed}"/>
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
                                <Button Content="Credential" Name="CredentialButton" Grid.Column="0"/>
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
                                <Button Name="Start" Grid.Column="0" Content="Start" Margin="5" Width="100" Height="20"/>
                                <Button Name="Cancel" Grid.Column="1" Content="Cancel" Margin="5" Width="100" Height="20"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </Grid>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@
            FEDCFound            = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Domain Controller Found" Width="500" Height="200" HorizontalAlignment="Center" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" WindowStartupLocation="CenterScreen">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="3*"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <DataGrid Grid.Row="0" Grid.Column="0" Name="DataGrid" FrozenColumnCount="2" AutoGenerateColumns="False" AlternationCount="2" HeadersVisibility="Column" CanUserResizeRows="False" CanUserAddRows="False" IsTabStop="True" IsTextSearchEnabled="True" SelectionMode="Extended">
            <DataGrid.Columns>
                <DataGridTextColumn Header="Address"  Width="140" Binding="{Binding IPAddress}" CanUserSort="True" IsReadOnly="True"/>
                <DataGridTextColumn Header="Hostname" Width="240" Binding="{Binding HostName}" CanUserSort="True" IsReadOnly="True"/>
                <DataGridTextColumn Header="NetBIOS"  Width="100" Binding="{Binding NetBIOS}" CanUserSort="True" IsReadOnly="True"/>
            </DataGrid.Columns>
        </DataGrid>
        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Button Name="Ok" Content="Ok" Grid.Column="0" Grid.Row="1" Margin="10"/>
            <Button Name="Cancel" Content="Cancel" Grid.Column="1" Grid.Row="1" Margin="10"/>
        </Grid>
    </Grid>
</Window>
'@
            FERoot               = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://Root Installation" Width="640" Height="480" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
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
            <Setter Property="FontWeight" Value="Heavy"/>
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
            <Setter Property="FontWeight" Value="Heavy"/>
            <Setter Property="FontSize" Value="18"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Foreground" Value="White"/>
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
                    <RowDefinition Height="50"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <Label Grid.Row="0" Content="[Root Installation]" Style="{StaticResource xLabel}"></Label>
                <Grid Grid.Row="1">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="50"/>
                    </Grid.RowDefinitions>
                    <TextBlock Grid.Row="0" Grid.Column="0" Margin="5" VerticalAlignment="Center" Text="Enter a local filepath to install, store, and deploy [Apps/Features/Drivers/Packages/Updates/Images]" TextWrapping="Wrap" Foreground="Black"/>
                    <TextBox Name="FilePath" Grid.Row="0" Grid.Column="1" Height="20" Background="White" Margin="10" TextAlignment="Left" Foreground="Black"></TextBox>
                    <Button Name="Start"  Grid.Row="1" Grid.Column="0" Style="{StaticResource xButton}" Content="Start"></Button>
                    <Button Name="Cancel" Grid.Row="1" Grid.Column="1" Style="{StaticResource xButton}" Content="Cancel"></Button>
                </Grid>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
'@
            FEShare              = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://New Deployment Share" $W`="640" '+
            '$H`="960" Topmost="True" Icon="{0}" ResizeMode="NoResize" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$WI`.$RES`><$ST` $TT`="$'+
            'LA`" $XK`="Head$LA`"><$SE` $PR`="$TBL`.TextAlignment" $VA`="Center"/><$SE` $PR`="FontWeight" $VA`="Heavy"'+
            '/><$SE` $PR`="FontSize" $VA`="18"/><$SE` $PR`="$MA`" $VA`="5"/><$SE` $PR`="Foreground" $VA`="White"/><$SE'+
            '` $PR`="Template"><$SE`.$VA`><$CT` $TT`="$LA`"><$BO` CornerRadius="2,2,2,2" $BG`="#FF0080FF" $BO`Brush="B'+
            'lack" $BO`Thickness="3"><$CO`Presenter x:Name="$CO`Presenter" $CO`Template="{ TemplateBinding $CO`Template'+
            ' }" $MA`="5"/></$BO`></$CT`></$SE`.$VA`></$SE`></$ST`><$ST` $TT`="Radio$BU`" $XK`="Rad$BU`"><$SE` $PR`="$'+
            'Hx`" $VA`="Center"/><$SE` $PR`="$Vx`" $VA`="Center"/><$SE` $PR`="Foreground" $VA`="Black"/></$ST`><$ST` $'+
            'TT`="$TB`" $XK`="TextBro"><$SE` $PR`="Vertical$CO`Alignment" $VA`="Center"/><$SE` $PR`="$MA`" $VA`="2"/><'+
            '$SE` $PR`="$TW`" $VA`="Wrap"/><$SE` $PR`="$H`" $VA`="24"/></$ST`></$WI`.$RES`><$G`><$G`.$RD`s><$RD` $H`="'+
            '250"/><$RD` $H`="*"/><$RD` $H`="40"/></$G`.$RD`s><$G`.$BG`><ImageBrush Stretch="UniformToFill" ImageSourc'+
            'e="{1}"/></$G`.$BG`><Image $G`.Row="0" Source="{2}"/><$TC` $G`.Row="1" $BG`="{x:Null}" $BO`'+
            'Brush="{x:Null}" Foreground="{x:Null}" $Hx`="Center"><TabItem $HD`="Stage Deployment Server" $BO`Brush="{'+
            'x:Null}" $W`="280"><TabItem.$EF`><DropShadow$EF`/></TabItem.$EF`><$G`><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`'+
            '="*"/></$G`.$RD`s><$GB` $G`.Row="0" $MA`="10" $PA`="5" Foreground="Black" $BG`="White"><$G` $G`.Row="0"><'+
            '$G`.$RD`s><$RD` $H`="50"/><$RD` $H`="30"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$LA` '+
            '$CO`="Deployment Share Settings" $ST`="{ StaticResource Head$LA` }" Foreground="White" $G`.Row="0"/><$G` '+
            '$G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><Radio$BU` $G`.Column="0" $CO`="Standard'+
            ' @ MDT Share" Name="Legacy" $ST`="{ StaticResource Rad$BU` }"/><Radio$BU` $G`.Column="1" $CO`="Enhanced @ '+
            'PSD Share" Name="Remaster" $ST`="{ StaticResource Rad$BU` }"/></$G`><$GB` $G`.Row="2" $HD`="Directory Path'+
            '"><$TB` $ST`="{ StaticResource TextBro }" Name="Directory"/></$GB`><$GB` $G`.Row="3" $HD`="Samba Share"><$'+
            'TB` $ST`="{ StaticResource TextBro }" Name="Samba"/></$GB`><$G` $G`.Row="4"><$G`.$CD`s><$CD` $W`="*"/><$CD'+
            '` $W`="2*"/></$G`.$CD`s><$GB` $G`.Column="0" $HD`="PS Drive"><$TB` $ST`="{ StaticResource TextBro }" Name='+
            '"DSDrive"/></$GB`><$GB` $G`.Column="1" $HD`="Description"><$TB` $ST`="{ StaticResource TextBro }" Name="De'+
            'scription"/></$GB`></$G`></$G`></$GB`><$GB` $G`.Row="1" $MA`="10" $PA`="5" Foreground="Black" $BG`="White'+
            '"><$G`><$G`.$RD`s><$RD` $H`="50"/><$RD` $H`="30"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`'+
            's><$LA` $CO`="BITS / IIS Settings" $ST`="{ StaticResource Head$LA` }" Foreground="White" $G`.Row="0"/><$G'+
            '` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><Radio$BU` $G`.Column="0" Name="IIS_Ins'+
            'tall" $CO`="Install BITS/IIS for MDT" $ST`="{ StaticResource Rad$BU` }"/><Radio$BU` $G`.Column="1" Name="I'+
            'IS_Skip" $CO`="Do not install BITS/IIS for MDT" $ST`="{ StaticResource Rad$BU` }"/></$G`><$GB` $G`.Row="2'+
            '" $HD`="Name"><$TB` $ST`="{ StaticResource TextBro }" Name="IIS_Name"/></$GB`><$GB` $G`.Row="3" $HD`="App Po'+
            'ol"><$TB` $ST`="{ StaticResource TextBro }" Name="IIS_AppPool"/></$GB`><$GB` $G`.Row="4" $HD`="Virtual Hos'+
            't"><$TB` $ST`="{ StaticResource TextBro }" Name="IIS_Proxy"/></$GB`></$G`></$GB`></$G`></TabItem><TabItem '+
            '$HD`="Image Info" $Hx`="Center" $W`="280" $BO`Brush="{x:Null}"><TabItem.$EF`><DropShadow$EF`/></TabItem.$'+
            'EF`><$G`><$G`.$RD`s><$RD` $H`="7*"/><$RD` $H`="5*"/></$G`.$RD`s><$GB` $G`.Row="0" $MA`="10" $PA`="5" Fore'+
            'ground="Black" $BG`="White"><$G`><$G`.$RD`s><$RD` $H`="50"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/>'+
            '<$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$LA` $G`.Row="0" $ST`="{ StaticResource Head$LA` }" $CO`="Imag'+
            'e Branding Settings"/><$GB` $G`.Row="1" $HD`="Organization"><$TB` $ST`="{ StaticResource TextBro }" Name="'+
            'Company"/></$GB`><$GB` $G`.Row="2" $HD`="Support Website"><$TB` $ST`="{ StaticResource TextBro }" Name="WW'+
            'W"/></$GB`><$G` $G`.Row="3"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$GB` $G`.Column="0" $HD'+
            '`="Support Phone"><$TB` $ST`="{ StaticResource TextBro }" Name="Phone"/></$GB`><$GB` $G`.Column="1" $HD`="'+
            'Support Hours"><$TB` $ST`="{ StaticResource TextBro }" Name="Hours"/></$GB`></$G`><$G` $G`.Row="4" $G`.Row'+
            'Span="2"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="100"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/>'+
            '</$G`.$RD`s><$GB` $HD`="Logo [120x120]" $G`.Row="0" $G`.Column="0"><$TB` $ST`="{ StaticResource TextBro }'+
            '" $W`="400" $G`.Column="1" Name="Logo"/></$GB`><$BU` $MA`="5,15,5,5" $H`="20" $G`.Row="0" $G`.Column="1" $'+
            'CO`="Logo" Name="LogoBrowse"/><$GB` $HD`="$BG`" $G`.Row="1" $G`.Column="0"><$TB` $ST`="{ StaticResource Te'+
            'xtBro }" $W`="400" $G`.Column="1" Name="$BG`"/></$GB`><$BU` $MA`="5,15,5,5" $H`="20" $G`.Row="1" $G`.Colum'+
            'n="1" $CO`="$BG`" Name="$BG`Browse"/></$G`></$G`></$GB`><$GB` $G`.Row="1" $MA`="10" $PA`="5" Foreground="B'+
            'lack" $BG`="White"><$G`><$G`.$RD`s><$RD` $H`="50"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD'+
            '`s><$LA` $G`.Row="0" $ST`="{ StaticResource Head$LA` }" $CO`="Domain / Network Credentials"/><$GB` $G`.Ro'+
            'w="1" $HD`="Domain Name"><$TB` $ST`="{ StaticResource TextBro }" Name="Branch"/></$GB`><$GB` $G`.Row="2" $H'+
            'D`="NetBIOS Domain"><$TB` $ST`="{ StaticResource TextBro }" Name="NetBIOS"/></$GB`><$G` $G`.Row="3"><$G`.$'+
            'CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$GB` $G`.Column="0" $HD`="Target/Local Administrator User'+
            'Name"><$TB` $ST`="{ StaticResource TextBro }" Name="LMCred_User"/></$GB`><$GB` $G`.Column="1" $HD`="Target/'+
            'Local Administrator $PW`"><$PW`Box $MA`="5" Name="LMCred_Pass" $PW`Char="*"/></$GB`></$G`></$G`></$GB`></$'+
            'G`></TabItem></$TC`><$G` $G`.Row="2"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$BU` $G`.Colum'+
            'n="0" Name="Start" $CO`="Start" $W`="100" $H`="24"/><$BU` $G`.Column="1" Name="Cancel" $CO`="Cancel" $W`="1'+
            '00" $H`="24"/></$G`></$G`></$WI`>')
            FEService            = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://ViperBomb Services" $H`="800" $W'+
            '`="800" Topmost="True" $BO`Brush="Black" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020'+
            '.12.0\Graphics\icon.ico" ResizeMode="NoResize" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$WI`.$RE'+
            'S`><$ST` $TT`="$LA`"><$SE` $PR`="$Hx`" $VA`="Center"/><$SE` $PR`="$Vx`" $VA`="Center"/><$SE` $PR`="$PA`" '+
            '$VA`="5"/></$ST`><$ST` $XK`="Separator$ST`1" $TT`="{x:Type Separator}"><$SE` $PR`="SnapsToDevicePixels" $'+
            'VA`="True"/><$SE` $PR`="$MA`" $VA`="0,0,0,0"/><$SE` $PR`="Template"><$SE`.$VA`><$CT` $TT`="{x:Type Separa'+
            'tor}"><$BO` $H`="24" SnapsToDevicePixels="True" $BG`="#FF4D4D4D" $BO`Brush="Azure" $BO`Thickness="1,1,1,1'+
            '" CornerRadius="5,5,5,5"/></$CT`></$SE`.$VA`></$SE`></$ST`><$ST` $TT`="{x:Type ToolTip}"><$SE` $PR`="$BG`'+
            '" $VA`="Black"/><$SE` $PR`="Foreground" $VA`="LightGreen"/></$ST`></$WI`.$RES`><$WI`.$EF`><DropShadow$EF`'+
            '/></$WI`.$EF`><$G`><$G`.$RD`s><$RD` $H`="20"/><$RD` $H`="*"/><$RD` $H`="60"/></$G`.$RD`s><$MN` $G`.Row="0'+
            '" IsMain$MN`="True"><$MN`Item $HD`="Configuration"><$MN`Item Name="Profile_0" $HD`="0 - $WI`s 10 Home / D'+
            'efault Max"/><$MN`Item Name="Profile_1" $HD`="1 - $WI`s 10 Home / Default Min"/><$MN`Item Name="Profile_2'+
            '" $HD`="2 - $WI`s 10 Pro / Default Max"/><$MN`Item Name="Profile_3" $HD`="3 - $WI`s 10 Pro / Default Min"'+
            '/><$MN`Item Name="Profile_4" $HD`="4 - Desktop / Default Max"/><$MN`Item Name="Profile_5" $HD`="5 - Deskt'+
            'op / Default Min"/><$MN`Item Name="Profile_6" $HD`="6 - Desktop / Default Max"/><$MN`Item Name="Profile_7'+
            '" $HD`="7 - Desktop / Default Min"/><$MN`Item Name="Profile_8" $HD`="8 - Laptop / Default Max"/><$MN`Item'+
            ' Name="Profile_9" $HD`="9 - Laptop / Default Min"/></$MN`Item><$MN`Item $HD`="Info"><$MN`Item Name="URL" '+
            '$HD`="$RES`"/><$MN`Item Name="About" $HD`="About"/><$MN`Item Name="Copyright" $HD`="Copyright"/><$MN`Item'+
            ' Name="MadBomb" $HD`="MadBomb122"/><$MN`Item Name="BlackViper" $HD`="BlackViper"/><$MN`Item Name="Site" $'+
            'HD`="Company Website"/><$MN`Item Name="Help" $HD`="Help"/></$MN`Item></$MN`><$G` $G`.Row="1"><$G`.$CD`s><'+
            '$CD` $W`="*"/></$G`.$CD`s><$TC` $BO`Brush="Gainsboro" $G`.Row="1" Name="$TC`"><$TC`.$RES`><$ST` $TT`="Tab'+
            'Item"><$SE` $PR`="Template"><$SE`.$VA`><$CT` $TT`="TabItem"><$BO` Name="$BO`" $BO`Thickness="1,1,1,0" $BO'+
            '`Brush="Gainsboro" CornerRadius="4,4,0,0" $MA`="2,0"><$CO`Presenter x:Name="$CO`Site" $Vx`="Center" $Hx`='+
            '"Center" $CO`Source="$HD`" $MA`="10,2"/></$BO`><$CT`.$TR`s><$TR` $PR`="IsSelected" $VA`="True"><$SE` $TN`'+
            '="$BO`" $PR`="$BG`" $VA`="LightSkyBlue"/></$TR`><$TR` $PR`="IsSelected" $VA`="False"><$SE` $TN`="$BO`" $P'+
            'R`="$BG`" $VA`="GhostWhite"/></$TR`></$CT`.$TR`s></$CT`></$SE`.$VA`></$SE`></$ST`></$TC`.$RES`><TabItem $'+
            'HD`="Service Dialog"><$G`><$G`.$RD`s><$RD` $H`="60"/><$RD` $H`="32"/><$RD` $H`="*"/></$G`.$RD`s><$G` $G`.'+
            'Row="0"><$G`.$CD`s><$CD` $W`="0.45*"/><$CD` $W`="0.15*"/><$CD` $W`="0.25*"/><$CD` $W`="0.15*"/></$G`.$CD`'+
            's><$GB` $G`.Column="0" $HD`="Operating System" $MA`="5"><$LA` Name="Caption"/></$GB`><$GB` $G`.Column="1"'+
            ' $HD`="Release ID" $MA`="5"><$LA` Name="ReleaseID"/></$GB`><$GB` $G`.Column="2" $HD`="Version" $MA`="5"><'+
            '$LA` Name="Version"/></$GB`><$GB` $G`.Column="3" $HD`="Chassis" $MA`="5"><$LA` Name="Chassis"/></$GB`></$'+
            'G`><$G` $G`.Row="1"><$G`.$CD`s><$CD` $W`="0.66*"/><$CD` $W`="0.33*"/><$CD` $W`="1*"/></$G`.$CD`s><$TB` $G'+
            '`.Column="0" $MA`="5" Name="Search" $TW`="Wrap"></$TB`><$CB` $G`.Column="1" $MA`="5" Name="Select" $Vx`="'+
            'Center"><$CB`Item $CO`="Checked"/><$CB`Item $CO`="Display Name" IsSelected="True"/><$CB`Item $CO`="Name"/'+
            '><$CB`Item $CO`="Current Setting"/></$CB`><$TBL` $G`.Column="2" $MA`="5" TextAlignment="Center">Service S'+
            'tate: <Run $BG`="#66FF66" Text="Compliant"/> / <Run $BG`="#FFFF66" Text="Unspecified"/> / <Run $BG`="#FF6'+
            '666" Text="Non Compliant"/></$TBL`></$G`><Data$G` $G`.Row="2" $G`.Column="0" Name="Data$G`" FrozenColumnC'+
            'ount="2" AutoGenerateColumns="False" AlternationCount="2" $HD`sVisibility="Column" CanUserResizeRows="Fal'+
            'se" CanUserAddRows="False" IsTabStop="True" IsTextSearchEnabled="True" SelectionMode="Extended"><Data$G`.'+
            'Row$ST`><$ST` $TT`="{x:Type Data$G`Row}"><$ST`.$TR`s><$TR` $PR`="AlternationIndex" $VA`="0"><$SE` $PR`="$'+
            'BG`" $VA`="White"/></$TR`><$TR` $PR`="AlternationIndex" $VA`="1"><$SE` $PR`="$BG`" $VA`="#FFD8D8D8"/></$T'+
            'R`><$TR` $PR`="IsMouseOver" $VA`="True"><$SE` $PR`="ToolTip"><$SE`.$VA`><$TBL` Text="{Binding Description'+
            '}" $TW`="Wrap" $W`="400" $BG`="#000000" Foreground="#00FF00"/></$SE`.$VA`></$SE`><$SE` $PR`="ToolTipServi'+
            'ce.ShowDuration" $VA`="360000000"/></$TR`><MultiData$TR`><MultiData$TR`.Conditions><Condition Binding="{B'+
            'inding Scope}" $VA`="True"/><Condition Binding="{Binding Matches}" $VA`="False"/></MultiData$TR`.Conditio'+
            'ns><$SE` $PR`="$BG`" $VA`="#F08080"/></MultiData$TR`><MultiData$TR`><MultiData$TR`.Conditions><Condition '+
            'Binding="{Binding Scope}" $VA`="False"/><Condition Binding="{Binding Matches}" $VA`="False"/></MultiData$'+
            'TR`.Conditions><$SE` $PR`="$BG`" $VA`="#FFFFFF64"/></MultiData$TR`><MultiData$TR`><MultiData$TR`.Conditio'+
            'ns><Condition Binding="{Binding Scope}" $VA`="True"/><Condition Binding="{Binding Matches}" $VA`="True"/>'+
            '</MultiData$TR`.Conditions><$SE` $PR`="$BG`" $VA`="LightGreen"/></MultiData$TR`></$ST`.$TR`s></$ST`></Dat'+
            'a$G`.Row$ST`><Data$G`.Columns><Data$G`TextColumn $HD`="Index" $W`="50" Binding="{Binding Index}" CanUserS'+
            'ort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="Name" $W`="150" Binding="{Binding Name}" CanUserSo'+
            'rt="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="Scoped" $W`="75" Binding="{Binding Scope}" CanUserS'+
            'ort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="Profile" $W`="100" Binding="{Binding Slot}" CanUse'+
            'rSort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="Status" $W`="75" Binding="{Binding Status}" CanU'+
            'serSort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="StartType" $W`="75" Binding="{Binding StartMod'+
            'e}" CanUserSort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="DisplayName" $W`="150" Binding="{Bindi'+
            'ng DisplayName}" CanUserSort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="PathName" $W`="150" Bindi'+
            'ng="{Binding PathName}" CanUserSort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="Description" $W`="'+
            '150" Binding="{Binding Description}" CanUserSort="True" IsReadOnly="True"/></Data$G`.Columns></Data$G`></'+
            '$G`></TabItem><TabItem $HD`="Preferences"><$G`><$G`.$RD`s><$RD` $H`="1.25*"/><$RD` $H`="*"/></$G`.$RD`s><'+
            '$G` $G`.Row="0"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$G` $G`.Column="2"><'+
            '$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$GB` $G`.Row="0" $HD`="Bypass / Checks [Risky Option'+
            's]" $MA`="5"><$G`><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$CHK` $G`.Row="1" '+
            '$MA`="5" Name="ByBuild" $CO`="Skip Build/Version Check" $Hx`="Center" $Vx`="Center"/><$CB` $G`.Row="0" $V'+
            'x`="Center" $H`="24" Name="ByEdition"><$CB`Item $CO`="Override Edition Check" IsSelected="True"/><$CB`Ite'+
            'm $CO`="$WI`s 10 Home"/><$CB`Item $CO`="$WI`s 10 Pro"/></$CB`><$CHK` $G`.Row="2" $MA`="5" Name="ByLaptop"'+
            ' $CO`="Enable Laptop Tweaks" $Hx`="Center" $Vx`="Center"/></$G`></$GB`><$GB` $G`.Row="1" $HD`="Display" $'+
            'MA`="5"><$G` $Hx`="Center" $Vx`="Center" ><$G`.$RD`s><$RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/></$G'+
            '`.$RD`s><$CHK` $G`.Row="0" $MA`="5" Name="DispActive" $CO`="Show Active Services" /><$CHK` $G`.Row="1" $M'+
            'A`="5" Name="DispInactive" $CO`="Show Inactive Services" /><$CHK` $G`.Row="2" $MA`="5" Name="DispSkipped"'+
            ' $CO`="Show Skipped Services" /></$G`></$GB`></$G`><$G` $G`.Column="0"><$G`.$RD`s><$RD` $H`="*"/><$RD` $H'+
            '`="2*"/></$G`.$RD`s><$GB` $G`.Row="0" $HD`="Service Configuration" $MA`="5"><$CB` $G`.Row="1" Name="Servi'+
            'ceProfile" $H`="24"><$CB`Item $CO`="Black Viper (Sparks v1.0)" IsSelected="True"/><$CB`Item $CO`="DevOPS '+
            '(MC/SDP v1.0)" IsEnabled="False"/></$CB`></$GB`><$GB` $G`.Row="1" $HD`="Miscellaneous" $MA`="5"><$G` $Hx`'+
            '="Center" $Vx`="Center"><$G`.$RD`s><$RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/></$G`.'+
            '$RD`s><$CHK` $G`.Row="0" $MA`="5" Name="MiscSimulate" $CO`="Simulate Changes [Dry Run]" /><$CHK` $G`.Row='+
            '"1" $MA`="5" Name="MiscXbox" $CO`="Skip All Xbox Services" /><$CHK` $G`.Row="2" $MA`="5" Name="MiscChange'+
            '" $CO`="Allow Change of Service State" /><$CHK` $G`.Row="3" $MA`="5" Name="MiscStopDisabled" $CO`="Stop D'+
            'isabled Services" /></$G`></$GB`></$G`><$G` $G`.Column="1"><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="2*"/></$G'+
            '`.$RD`s><$GB` $G`.Row="0" $HD`="User Interface" $MA`="5"><$CB` $G`.Row="1" Name="ScriptProfile" $H`="24">'+
            '<$CB`Item $CO`="DevOPS (MC/SDP v1.0)" IsSelected="True"/><$CB`Item $CO`="MadBomb (MadBomb122 v1.0)" IsEna'+
            'bled="False"/></$CB`></$GB`><$GB` $G`.Row="1" $HD`="Development" $MA`="5"><$G` $Hx`="Center" $Vx`="Center'+
            '" ><$G`.$RD`s><$RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/></$G`.$RD`s><$CHK` $G`.Row='+
            '"0" $MA`="5" Name="DevErrors" $CO`="Diagnostic Output [ On Error ]" /><$CHK` $G`.Row="1" $MA`="5" Name="D'+
            'evLog" $CO`="Enable Development Logging" /><$CHK` $G`.Row="2" $MA`="5" Name="DevConsole" $CO`="Enable Con'+
            'sole" /><$CHK` $G`.Row="3" $MA`="5" Name="DevReport" $CO`="Enable Diagnostic" /></$G`></$GB`></$G`></$G`>'+
            '<$G` $G`.Row="1"><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$GB` $G`.Row="0" $HD`="Logging: Cr'+
            'eate logs for all changes made via this utility" $MA`="5"><$G`><$G`.$CD`s><$CD` $W`="75"/><$CD` $W`="*"/>'+
            '<$CD` $W`="6*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$CHK` $G`.Row="0" $G`.C'+
            'olumn="0" $MA`="5" Name="LogSvcSwitch" $CO`="Services" $Hx`="Center" $Vx`="Center"/><$BU` $G`.Row="0" $G`'+
            '.Column="1" $MA`="5" Name="LogSvcBrowse" $CO`="Browse"/><$TB` $G`.Row="0" $G`.Column="2" $MA`="5" Name="L'+
            'ogSvcFile" IsEnabled="False" $Hx`="Stretch" $Vx`="Center" /><$CHK` $G`.Row="1" $G`.Column="0" $MA`="5" Na'+
            'me="LogScrSwitch" $CO`="Script" $Vx`="Center" $Hx`="Center" /><$BU` $G`.Row="1" $G`.Column="1" $MA`="5" N'+
            'ame="LogScrBrowse" $CO`="Browse"/><$TB` $G`.Row="1" $G`.Column="2" $MA`="5" Name="LogScrFile" IsEnabled="'+
            'False" $Hx`="Stretch" $Vx`="Center" /></$G`></$GB`><$GB` $G`.Row="1" $HD`="Backup: Save your current Serv'+
            'ice Configuration" $MA`="5"><$G`><$G`.$CD`s><$CD` $W`="75"/><$CD` $W`="*"/><$CD` $W`="6*"/></$G`.$CD`s><$'+
            'G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$CHK` $G`.Row="0" $G`.Column="0" $MA`="5" Name="RegSw'+
            'itch" $CO`="reg.*" $Hx`="Center" $Vx`="Center"/><$BU` $G`.Row="0" $G`.Column="1" $MA`="5" Name="RegBrowse'+
            '" $CO`="Browse"/><$TB` $G`.Row="0" $G`.Column="2" $MA`="5" Name="RegFile" IsEnabled="False" $Hx`="Stretch'+
            '" $Vx`="Center" /><$CHK` $G`.Row="1" $G`.Column="0" $MA`="5" Name="CsvSwitch" $CO`="csv.*" $Hx`="Center" '+
            '$Vx`="Center" /><$BU` $G`.Row="1" $G`.Column="1" $MA`="5" Name="CsvBrowse" $CO`="Browse"/><$TB` $G`.Row="'+
            '1" $G`.Column="2" $MA`="5" Name="CsvFile" IsEnabled="False" $Vx`="Center" /></$G`></$GB`></$G`></$G`></Ta'+
            'bItem><TabItem $HD`="Console"><$G` $BG`="#FFE5E5E5"><ScrollViewer VerticalScrollBarVisibility="Visible"><'+
            '$TBL` Name="ConsoleOutput" TextTrimming="CharacterEllipsis" $BG`="White" FontFamily="Lucida Console"/></S'+
            'crollViewer></$G`></TabItem><TabItem $HD`="Diagnostics"><$G` $BG`="#FFE5E5E5"><ScrollViewer VerticalScrol'+
            'lBarVisibility="Visible"><$TBL` Name="DiagnosticOutput" TextTrimming="CharacterEllipsis" $BG`="White" Fon'+
            'tFamily="Lucida Console"/></ScrollViewer></$G`></TabItem></$TC`></$G`><$G` $G`.Row="2"><$G`.$CD`s><$CD` $'+
            'W`="2*"/><$CD` $W`="*"/><$CD` $W`="*"/><$CD` $W`="2*"/></$G`.$CD`s><$GB` $G`.Column="0" $HD`="Service Con'+
            'figuration" $MA`="5"><$LA` Name="Service$LA`"/></$GB`><$BU` $G`.Column="1" Name="Start" $CO`="Start" Font'+
            'Weight="Bold" $MA`="10"/><$BU` $G`.Column="2" Name="Cancel" $CO`="Cancel" FontWeight="Bold" $MA`="10"/><$'+
            'GB` $G`.Column="3" $HD`="Module Version" $MA`="5"><$LA` Name="Script$LA`" /></$GB`></$G`></$G`></$WI`>')

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
