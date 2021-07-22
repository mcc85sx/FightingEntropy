<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://New Deployment Share" Width="640" Height="780" Icon=" C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\Graphics\icon.ico" ResizeMode="NoResize" FontWeight="SemiBold" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="GroupBox" x:Key="xGroupBox">
            <Setter Property="TextBlock.TextAlignment" Value="Center"/>
            <Setter Property="Background" Value="Azure"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="GroupBox">
                        <Border CornerRadius="10" Background="Azure" BorderBrush="Black" BorderThickness="2">
                            <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="GroupBox">
            <Setter Property="Foreground" Value="Black"/>
            <Setter Property="BorderBrush" Value="DarkBlue"/>
            <Setter Property="BorderThickness" Value="2"/>
            <Setter Property="Padding" Value="2"/>
            <Setter Property="Margin" Value="2"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="TextBlock.TextAlignment" Value="Center"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="FontWeight" Value="Medium"/>
            <Setter Property="Padding" Value="5"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Margin" Value="10,0,10,0"/>
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
        <Style TargetType="TabControl">
            <Setter Property="Background" Value="Azure"/>
        </Style>
        <Style TargetType="TabItem">
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
        <Style TargetType="TextBox">
            <Setter Property="TextBlock.TextAlignment" Value="Left"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="Margin" Value="10,0,10,0"/>
            <Setter Property="TextWrapping" Value="Wrap"/>
            <Setter Property="Height" Value="24"/>
            <Setter Property="TextBlock.Effect">
                <Setter.Value>
                    <DropShadowEffect ShadowDepth="1"/>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="DataGrid">
            <Setter Property="Margin" Value="5"/>
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
            <Setter Property="TextBlock.Effect">
                <Setter.Value>
                    <DropShadowEffect ShadowDepth="1"/>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="DataGridRow">
            <Setter Property="TextBlock.HorizontalAlignment" Value="Left"/>
            <Style.Triggers>
                <Trigger Property="AlternationIndex" Value="0">
                    <Setter Property="Background" Value="White"/>
                </Trigger>
                <Trigger Property="AlternationIndex" Value="1">
                    <Setter Property="Background" Value="Azure"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style TargetType="DataGridColumnHeader">
            <Setter Property="FontSize"   Value="10"/>
        </Style>
        <Style TargetType="DataGridCell">
            <Setter Property="TextBlock.TextAlignment" Value="Left"/>
        </Style>
        <Style TargetType="PasswordBox">
            <Setter Property="Height" Value="24"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="TextBlock.HorizontalAlignment" Value="Stretch"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="PasswordChar" Value="*"/>
            <Setter Property="TextBlock.Effect">
                <Setter.Value>
                    <DropShadowEffect ShadowDepth="1"/>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="ComboBox">
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Height" Value="24"/>
            <Setter Property="TextBlock.Effect">
                <Setter.Value>
                    <DropShadowEffect ShadowDepth="1"/>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid Background="White">
        <GroupBox Style="{StaticResource xGroupBox}"  Grid.Row="0" Margin="10" Padding="10" Foreground="Black" Background="White">
            <TabControl Grid.Row="1" BorderBrush="Black" Foreground="{x:Null}">
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
                <TabItem Header="Config">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="200"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="60"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[CfgServices (Dependency Snapshot)]">
                            <DataGrid Name="CfgServices">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Name"      Binding="{Binding Name}"  Width="150"/>
                                    <DataGridTextColumn Header="Installed/Meets minimum requirements" Binding="{Binding Value}" Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </GroupBox>
                        <TabControl Grid.Row="1">
                            <TabItem Header="Dhcp">
                                <GroupBox Header="[CfgDhcp (Dynamic Host Control Protocol)]">
                                    <DataGrid Name="CfgDhcp">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </TabItem>
                            <TabItem Header="Dns">
                                <GroupBox Header="[CfgDns (Domain Name Service)]">
                                    <DataGrid Name="CfgDns">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </TabItem>
                            <TabItem Header="Adds">
                                <GroupBox Header="[CfgAdds (Active Directory Directory Service)">
                                    <DataGrid Name="CfgAdds">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </TabItem>
                            <TabItem Header="Wds">
                                <GroupBox Header="[CfgWds (Windows Deployment Services)]">
                                    <DataGrid Name="CfgWds">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </TabItem>
                            <TabItem Header="Mdt">
                                <GroupBox Header="[CfgMdt (Microsoft Deployment Toolkit)]">
                                    <DataGrid Name="CfgMdt">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </TabItem>
                            <TabItem Header="WinAdk">
                                <GroupBox Header="[CfgWinAdk (Windows Assessment and Deployment Kit)]">
                                    <DataGrid Name="CfgWinAdk">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </TabItem>
                            <TabItem Header="WinPE">
                                <GroupBox Header="[CfgWinPE (Windows Preinstallation Environment Kit)]">
                                    <DataGrid Name="CfgWinPE">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </TabItem>
                            <TabItem Header="IIS">
                                <GroupBox Header="[CfgIIS (Internet Information Services)]">
                                    <DataGrid Name="CfgIIS">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </TabItem>
                        </TabControl>
                    </Grid>
                </TabItem>
                <TabItem Header="Domain" BorderBrush="{x:Null}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="80"/>
                            <RowDefinition Height="225"/>
                            <RowDefinition Height="150"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="120"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[DcOrganization]">
                                <TextBox Name="DcOrganization"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[DcCommonName]">
                                <TextBox Name="DcCommonName"/>
                            </GroupBox>
                            <Button Grid.Column="2" Name="DcGetSitename" Content="Get Sitename"/>
                        </Grid>
                        <GroupBox Grid.Row="1" Header="[DcAggregate]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Grid.Row="0" Name="DcAggregate"
                                              ScrollViewer.CanContentScroll="True"
                                              ScrollViewer.IsDeferredScrollingEnabled="True"
                                              ScrollViewer.HorizontalScrollBarVisibility="Visible">
                                    <DataGrid.Columns>

                                        <DataGridTextColumn Header="Name"     Binding='{Binding SiteLink}' Width="120"/>
                                        <DataGridTextColumn Header="Location" Binding='{Binding Location}' Width="100"/>
                                        <DataGridTextColumn Header="Region"   Binding='{Binding Region}' Width="60"/>
                                        <DataGridTextColumn Header="Country"  Binding='{Binding Country}' Width="60"/>
                                        <DataGridTextColumn Header="Postal"   Binding='{Binding Postal}' Width="60"/>
                                        <DataGridTextColumn Header="TimeZone" Binding='{Binding TimeZone}' Width="120"/>
                                        <DataGridTextColumn Header="SiteName" Binding='{Binding SiteName}' Width="Auto"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="50"/>
                                        <ColumnDefinition Width="50"/>
                                    </Grid.ColumnDefinitions>
                                    <GroupBox Grid.Column="0" Header="[DcAddSitenameTown]" IsEnabled="False">
                                        <TextBox Name="DcAddSitenameTown"/>
                                    </GroupBox>
                                    <GroupBox Grid.Column="1" Header="[DcAddSitenameZip]">
                                        <TextBox Name="DcAddSitenameZip"/>
                                    </GroupBox>
                                    <Button Grid.Column="2" Name="DcAddSitename" Content="+"/>
                                    <Button Grid.Column="3" Name="DcRemoveSitename" Content="-"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[DcViewer]">
                            <DataGrid Name="DcViewer">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Name"  Binding='{Binding Name}'  Width="150"/>
                                    <DataGridTextColumn Header="Value" Binding='{Binding Value}' Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[DcTopography]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Grid.Row="0" Name="DcTopography"
                                              ScrollViewer.CanContentScroll="True"
                                              ScrollViewer.IsDeferredScrollingEnabled="True"
                                              ScrollViewer.HorizontalScrollBarVisibility="Visible">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding="{Binding SiteLink}" Width="150"/>
                                        <DataGridTextColumn Header="Sitename" Binding="{Binding SiteName}" Width="200"/>
                                        <DataGridTemplateColumn Header="Exists" Width="50">
                                            <DataGridTemplateColumn.CellTemplate>
                                                <DataTemplate>
                                                    <ComboBox SelectedIndex="{Binding Exists}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center">
                                                        <ComboBoxItem Content="No"/>
                                                        <ComboBoxItem Content="Yes"/>
                                                    </ComboBox>
                                                </DataTemplate>
                                            </DataGridTemplateColumn.CellTemplate>
                                        </DataGridTemplateColumn>
                                        <DataGridTextColumn Header="Distinguished Name" Binding="{Binding DistinguishedName}" Width="400"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="0" Name="DcGetTopography" Content="Get"/>
                                    <Button Grid.Column="1" Name="DcNewTopography" Content="New"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        
                    </Grid>
                </TabItem>
                <TabItem Header="Network" BorderBrush="{x:Null}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="80"/>
                            <RowDefinition Height="225"/>
                            <RowDefinition Height="150"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="100"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Row="0" Header="[NwScope]">
                                <TextBox Grid.Column="0" Name="NwScope"/>
                            </GroupBox>
                            <Button Grid.Column="1" Name="NwScopeLoad" Content="Load" IsEnabled="False"/>
                        </Grid>
                        <GroupBox Grid.Row="1" Header="[NwAggregate]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Name="NwAggregate"
                                              ScrollViewer.CanContentScroll="True" 
                                              ScrollViewer.IsDeferredScrollingEnabled="True"
                                              ScrollViewer.HorizontalScrollBarVisibility="Visible">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"      Binding="{Binding Network}"   Width="100"/>
                                        <DataGridTextColumn Header="Netmask"   Binding="{Binding Netmask}"   Width="100"/>
                                        <DataGridTextColumn Header="HostCount" Binding="{Binding HostCount}" Width="60"/>
                                        <DataGridTextColumn Header="Start"     Binding="{Binding Start}"     Width="100"/>
                                        <DataGridTextColumn Header="End"       Binding="{Binding End}"       Width="100"/>
                                        <DataGridTextColumn Header="Broadcast" Binding="{Binding Broadcast}" Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="50"/>
                                        <ColumnDefinition Width="50"/>
                                    </Grid.ColumnDefinitions>
                                    <GroupBox Grid.Column="0" Header="[NwSubnetName]">
                                        <TextBox Name="NwSubnetName"/>
                                    </GroupBox>
                                    <Button Grid.Column="1" Name="NwAddSubnetName" Content="+"/>
                                    <Button Grid.Column="2" Name="NwRemoveSubnetName" Content="-"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[NwViewer]">
                            <DataGrid Name="NwViewer">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Name"   Binding="{Binding Name}"   Width="150"/>
                                    <DataGridTextColumn Header="Value"  Binding="{Binding Value}"   Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[NwTopography]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Grid.Row="0" Name="NwTopography"
                                                  ScrollViewer.CanContentScroll="True"
                                                  ScrollViewer.IsDeferredScrollingEnabled="True"
                                                  ScrollViewer.HorizontalScrollBarVisibility="Visible">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"    Binding="{Binding Name}" Width="150"/>
                                        <DataGridTextColumn Header="Network" Binding="{Binding Network}" Width="200"/>
                                        <DataGridTemplateColumn Header="Exists" Width="50">
                                            <DataGridTemplateColumn.CellTemplate>
                                                <DataTemplate>
                                                    <ComboBox SelectedIndex="{Binding Exists}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center">
                                                        <ComboBoxItem Content="No"/>
                                                        <ComboBoxItem Content="Yes"/>
                                                    </ComboBox>
                                                </DataTemplate>
                                            </DataGridTemplateColumn.CellTemplate>
                                        </DataGridTemplateColumn>
                                        <DataGridTextColumn Header="Distinguished Name" Binding="{Binding DistinguishedName}" Width="400"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="0" Name="NwGetSubnetName" Content="Get"/>
                                    <Button Grid.Column="1" Name="NwNewSubnetName" Content="New"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </TabItem>
                <TabItem Header="Gateway" BorderBrush="{x:Null}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="80"/>
                            <RowDefinition Height="225"/>
                            <RowDefinition Height="150"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="120"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[GwSiteCount]">
                                <TextBox Name="GwSiteCount"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[GwNetworkCount]">
                                <TextBox Name="GwNetworkCount"/>
                            </GroupBox>
                            <Button Grid.Column="2" Name="GwLoadGateway" Content="Load"/>
                        </Grid>
                        <GroupBox Grid.Row="1" Header="[GwAggregate]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Name="GwAggregate"
                                              ScrollViewer.CanContentScroll="True" 
                                              ScrollViewer.IsDeferredScrollingEnabled="True"
                                              ScrollViewer.HorizontalScrollBarVisibility="Visible">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Network"   Binding="{Binding Network}"   Width="*"/>
                                        <DataGridTextColumn Header="Prefix"    Binding="{Binding Prefix}"    Width="*"/>
                                        <DataGridTextColumn Header="Netmask"   Binding="{Binding Netmask}"   Width="*"/>
                                        <DataGridTextColumn Header="HostCount" Binding="{Binding HostCount}" Width="*"/>
                                        <DataGridTextColumn Header="Start"     Binding="{Binding Start}"     Width="*"/>
                                        <DataGridTextColumn Header="End"       Binding="{Binding End}"       Width="*"/>
                                        <DataGridTextColumn Header="Range"     Binding="{Binding Range}"     Width="*"/>
                                        <DataGridTextColumn Header="Broadcast" Binding="{Binding Broadcast}" Width="Auto"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="50"/>
                                        <ColumnDefinition Width="50"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="1" Name="GwAddGateway" Content="+"/>
                                    <GroupBox Grid.Column="0" Header="[GwGatewayName]">
                                        <TextBox Name="GwGateway"/>
                                    </GroupBox>
                                    <Button Grid.Column="2" Name="GwRemoveGateway" Content="-"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[GwViewer]">
                            <DataGrid Name="GwViewer">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Name"  Binding="{Binding Name}"   Width="150"/>
                                    <DataGridTextColumn Header="Value" Binding="{Binding Value}"   Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[GwTopography]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Grid.Row="0" Name="GwTopography">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="SiteName"  Binding="{Binding SiteName}" Width="200"/>
                                        <DataGridTextColumn Header="Prefix"    Binding="{Binding Prefix}"   Width="150"/>
                                        <DataGridTemplateColumn Header="Exists" Width="50">
                                            <DataGridTemplateColumn.CellTemplate>
                                                <DataTemplate>
                                                    <ComboBox SelectedIndex="{Binding Exists}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center">
                                                        <ComboBoxItem Content="No"/>
                                                        <ComboBoxItem Content="Yes"/>
                                                    </ComboBox>
                                                </DataTemplate>
                                            </DataGridTemplateColumn.CellTemplate>
                                        </DataGridTemplateColumn>
                                        <DataGridTextColumn Header="Distinguished Name" Binding="{Binding DistinguishedName}" Width="400"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="0" Name="GwGetGateway" Content="Get"/>
                                    <Button Grid.Column="1" Name="GwNewGateway" Content="New"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </TabItem>
                <TabItem Header="Imaging" BorderBrush="{x:Null}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="80"/>
                            <RowDefinition Height="200"/>
                            <RowDefinition Height="225"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[IsoPath (Source Directory)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="100"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="100"/>
                                </Grid.ColumnDefinitions>
                                <Button Name="IsoSelect" Grid.Column="0" Content="Select"/>
                                <TextBox Name="IsoPath"  Grid.Column="1"/>
                                <Button Name="IsoScan" Grid.Column="2" Content="Scan"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[IsoList (*.iso)]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Grid.Row="0" Name="IsoList">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding='{Binding Name}' Width="*"/>
                                        <DataGridTextColumn Header="Path" Binding='{Binding Fullname}' Width="2*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="0" Name="IsoMount" Content="Mount" IsEnabled="False"/>
                                    <Button Grid.Column="1" Name="IsoDismount" Content="Dismount" IsEnabled="False"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <Grid Grid.Row="2">
                            <GroupBox Grid.Row="2" Header="[IsoView (Image Viewer)]">
                                <Grid>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height="*"/>
                                        <RowDefinition Height="80"/>
                                    </Grid.RowDefinitions>
                                    <DataGrid Grid.Row="0" Name="IsoView">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Index" Binding='{Binding Index}' Width="40"/>
                                            <DataGridTextColumn Header="Name"  Binding='{Binding Name}' Width="*"/>
                                            <DataGridTextColumn Header="Size"  Binding='{Binding Size}' Width="100"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                    <Grid Grid.Row="1">
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <Button Grid.Column="0" Name="WimQueue" Content="Queue" IsEnabled="False"/>
                                        <Button Grid.Column="1" Name="WimDequeue" Content="Dequeue" IsEnabled="False"/>
                                    </Grid>
                                </Grid>
                            </GroupBox>
                        </Grid>
                        <GroupBox Grid.Row="3" Header="[WimIso (Queue)]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height="*"/>
                                        <RowDefinition Height="*"/>
                                    </Grid.RowDefinitions>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="50"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Row="0" Name="WimIsoUp" Content="˄"/>
                                    <Button Grid.Row="1" Name="WimIsoDown" Content="˅"/>
                                    <DataGrid Grid.Column="1" Grid.Row="0" Grid.RowSpan="2" Name="WimIso">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name"  Binding='{Binding FullName}' Width="*"/>
                                            <DataGridTextColumn Header="Index" Binding='{Binding Index}' Width="100"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="100"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="100"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Name="WimSelect" Grid.Column="0" Content="Select"/>
                                    <TextBox Grid.Column="1" Name="WimPath"/>
                                    <Button Grid.Column="2" Name="WimExtract" Content="Extract"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </TabItem>
                <TabItem Header="Updates" BorderBrush="{x:Null}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="80"/>
                            <RowDefinition Height="200"/>
                            <RowDefinition Height="225"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[UpdPath (Updates)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="100"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="100"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="UpdSelect" Content="Select"/>
                                <TextBox Grid.Column="1" Name="UpdPath"/>
                                <Button Grid.Column="2" Name="UpdScan" Content="Scan"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[UpdSelected]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Grid.Row="0"  Name="UpdAggregate">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="200"/>
                                        <DataGridTextColumn Header="Value" Binding="{Binding value}" Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="0" Name="UpdAddUpdate" Content="Add"/>
                                    <Button Grid.Column="1" Name="UpdRemoveUpdate" Content="Remove"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[UpdViewer]">
                                <DataGrid Name="UpdViewer">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>
                                        <DataGridTextColumn Header="Date" Binding="{Binding Date}" Width="*"/>
                                        <DataGridCheckBoxColumn Header="Install" Binding="{Binding Install}" Width="50"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                        <GroupBox Grid.Row="3" Header="[UpdWim]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="80"/>
                                </Grid.RowDefinitions>
                                <DataGrid Grid.Row="0" Name="UpdWim">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>
                                        <DataGridTextColumn Header="Date" Binding="{Binding Date}" Width="*"/>
                                        <DataGridCheckBoxColumn Header="Install" Binding="{Binding Install}" Width="50"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="0" Name="UpdInstallUpdate" Content="Install"/>
                                    <Button Grid.Column="1" Name="UpdUninstallUpdate" Content="Uninstall"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </TabItem>
                <TabItem Header="Share">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="80"/>
                            <RowDefinition Height="80"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="100"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="150"/>
                            </Grid.ColumnDefinitions>
                            <Button Name="DsRootSelect" Grid.Column="0" Content="Select"/>
                            <GroupBox Grid.Column="1" Header="[DsRootPath (Root)]">
                                <TextBox Name="DsRootPath"/>
                            </GroupBox>
                            <GroupBox Grid.Column="2" Header="[DsShareName (SMB)]">
                                <TextBox Name="DsShareName"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Row="1">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="150"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="150"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[DsDriveName]">
                                <TextBox Name="DsDriveName"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[DsDescription]">
                                <TextBox Name="DsDescription"/>
                            </GroupBox>
                            <GroupBox Grid.Column="2" Header="[Legacy MDT/PSD]">
                                <ComboBox Name="DsType">
                                    <ComboBoxItem Content="MDT" IsSelected="True"/>
                                    <ComboBoxItem Content="PSD"/>
                                </ComboBox>
                            </GroupBox>
                        </Grid>
                        <GroupBox Grid.Row="2" Header="[DsShareConfig]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="75"/>
                                </Grid.RowDefinitions>
                                <TabControl Grid.Row="0">
                                    <TabItem Header="Domain Admin">
                                        <Grid  VerticalAlignment="Top">
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="75"/>
                                            </Grid.RowDefinitions>
                                            <GroupBox Grid.Row="0" Header="[Domain Admin Username]">
                                                <TextBox Name="DsDcUsername"/>
                                            </GroupBox>
                                            <GroupBox Grid.Row="1" Header="[Password/Confirm]">
                                                <Grid>
                                                    <Grid.ColumnDefinitions>
                                                        <ColumnDefinition Width="*"/>
                                                        <ColumnDefinition Width="*"/>
                                                    </Grid.ColumnDefinitions>
                                                    <PasswordBox Grid.Column="0" Name="DsDcPassword" HorizontalContentAlignment="Left"/>
                                                    <PasswordBox Grid.Column="1" Name="DsDcConfirm"  HorizontalContentAlignment="Left"/>
                                                </Grid>
                                            </GroupBox>
                                        </Grid>
                                    </TabItem>
                                    <TabItem Header="Local Admin">
                                        <Grid VerticalAlignment="Top">
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="75"/>
                                            </Grid.RowDefinitions>
                                            <GroupBox Grid.Row="0" Header="[Local Admin Username]">
                                                <TextBox Name="DsLmUsername"/>
                                            </GroupBox>
                                            <GroupBox Grid.Row="1" Header="[Password/Confirm]">
                                                <Grid>
                                                    <Grid.ColumnDefinitions>
                                                        <ColumnDefinition Width="*"/>
                                                        <ColumnDefinition Width="*"/>
                                                    </Grid.ColumnDefinitions>
                                                    <PasswordBox Grid.Column="0" Name="DsLmPassword"  HorizontalContentAlignment="Left"/>
                                                    <PasswordBox Grid.Column="1" Name="DsLmConfirm"  HorizontalContentAlignment="Left"/>
                                                </Grid>
                                            </GroupBox>
                                        </Grid>
                                    </TabItem>
                                    <TabItem Header="Branding">
                                        <Grid>
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="75"/>
                                            </Grid.RowDefinitions>
                                            <Grid Grid.Row="0">
                                                <Grid.ColumnDefinitions>
                                                    <ColumnDefinition Width="100"/>
                                                    <ColumnDefinition Width="*"/>
                                                    <ColumnDefinition Width="*"/>
                                                </Grid.ColumnDefinitions>
                                                <Button Name="DsBrCollect" Content="Collect" IsEnabled="True"/>
                                                <GroupBox Grid.Column="1" Header="[BrPhone (Support Phone)]">
                                                    <TextBox Name="DsBrPhone"/>
                                                </GroupBox>
                                                <GroupBox Grid.Column="2" Header="[BrHours (Support Hours)]">
                                                    <TextBox Name="DsBrHours"/>
                                                </GroupBox>
                                            </Grid>
                                            <GroupBox Grid.Row="1" Header="[BrWebsite (Support Website)]">
                                                <TextBox Name="DsBrWebsite"/>
                                            </GroupBox>
                                            <GroupBox Grid.Row="2" Header="[BrLogo (120x120 Bitmap/*.bmp)]">
                                                <Grid>
                                                    <Grid.ColumnDefinitions>
                                                        <ColumnDefinition Width="100"/>
                                                        <ColumnDefinition Width="*"/>
                                                    </Grid.ColumnDefinitions>
                                                    <Button Grid.Column="0" Name="DsBrLogoSelect" Content="Select"/>
                                                    <TextBox Grid.Column="1" Name="DsBrLogo"/>
                                                </Grid>
                                            </GroupBox>
                                            <GroupBox Grid.Row="3" Header="[BrBackground (Common Image File)]">
                                                <Grid>
                                                    <Grid.ColumnDefinitions>
                                                        <ColumnDefinition Width="100"/>
                                                        <ColumnDefinition Width="*"/>
                                                    </Grid.ColumnDefinitions>
                                                    <Button Grid.Column="0" Name="DsBrBackgroundSelect" Content="Select"/>
                                                    <TextBox Grid.Column="1" Name="DsBrBackground"/>
                                                </Grid>
                                            </GroupBox>
                                        </Grid>
                                    </TabItem>
                                    <TabItem Header="Network">
                                        <Grid VerticalAlignment="Top">
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="75"/>
                                            </Grid.RowDefinitions>
                                            <GroupBox Grid.Row="0" Header="[DsNwNetBiosName]">
                                                <TextBox Name="DsNwNetBiosName"/>
                                            </GroupBox>
                                            <GroupBox Grid.Row="1" Header="[DsNwDnsName]">
                                                <TextBox Name="DsNwDnsName"/>
                                            </GroupBox>
                                            <GroupBox Grid.Row="2" Header="[DsNwMachineOuName]">
                                                <TextBox Name="DsNwMachineOuName"/>
                                            </GroupBox>
                                        </Grid>
                                    </TabItem>
                                    <TabItem Header="Bootstrap">
                                        <Grid>
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="*"/>
                                            </Grid.RowDefinitions>
                                            <Grid Grid.Row="0">
                                                <Grid.ColumnDefinitions>
                                                    <ColumnDefinition Width="100"/>
                                                    <ColumnDefinition Width="*"/>
                                                    <ColumnDefinition Width="100"/>
                                                </Grid.ColumnDefinitions>
                                                <Button Grid.Column="0" Name="DsGenerateBootstrap" Content="Generate"/>
                                                <TextBox Grid.Column="1" Name="DsBootstrapPath"/>
                                                <Button Grid.Column="2" Name="DsSelectBootstrap" Content="Select"/>
                                            </Grid>
                                            <GroupBox Grid.Row="1" Header="[Bootstrap.ini]">
                                                <TextBlock Grid.Row="1" Background="White" Name="DsBootstrap" Margin="5" Padding="5">
                                                    <TextBlock.Effect>
                                                        <DropShadowEffect ShadowDepth="1"/>
                                                    </TextBlock.Effect>
                                                </TextBlock>
                                            </GroupBox>
                                        </Grid>
                                    </TabItem>
                                    <TabItem Header="CustomSettings">
                                        <Grid>
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height="75"/>
                                                <RowDefinition Height="*"/>
                                            </Grid.RowDefinitions>
                                            <Grid Grid.Row="0">
                                                <Grid.ColumnDefinitions>
                                                    <ColumnDefinition Width="100"/>
                                                    <ColumnDefinition Width="*"/>
                                                    <ColumnDefinition Width="100"/>
                                                </Grid.ColumnDefinitions>
                                                <Button Grid.Column="0" Name="DsGenerateCustomSettings" Content="Generate"/>
                                                <TextBox Grid.Column="1" Name="DsCustomSettingsPath"/>
                                                <Button Grid.Column="2" Name="DsSelectCustomSettings" Content="Select"/>
                                            </Grid>
                                            <GroupBox Grid.Row="1" Header="[CustomSettings.ini]">
                                                <TextBlock Grid.Row="1" Background="White" Name="DsCustomSettings" Margin="5" Padding="5">
                                                    <TextBlock.Effect>
                                                        <DropShadowEffect ShadowDepth="1"/>
                                                    </TextBlock.Effect>
                                                </TextBlock>
                                            </GroupBox>
                                        </Grid>
                                    </TabItem>
                                </TabControl>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="0" Name="DsCreate" Content="Create"/>
                                    <Button Grid.Column="1" Name="DsUpdate" Content="Update"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </TabItem>
            </TabControl>
        </GroupBox>
    </Grid>
</Window>
