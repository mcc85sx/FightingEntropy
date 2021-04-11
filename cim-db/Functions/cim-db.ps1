Function cim-db
{
    Class _UID
    {
        [Object] $UID
        [UInt32] $Index
        [Object] $Slot
        [Object] $Type
        [Object] $Date
        [Object] $Time
        [Object] $Record

        _UID([UInt32]$Slot)
        {
            $This.UID    = New-GUID | % GUID
            $This.Slot   = $Slot
            $This.Date   = Get-Date -UFormat "%m/%d/%Y"
            $This.Time   = Get-Date -UFormat "%H:%M:%S"
        }

        [String] ToString()
        {
            Return $This.Slot
        }
    }

    Class _Client
    {
        [Object]         $UID
        [Object]       $Index
        [Object]        $Slot
        [Object]        $Type
        [Object]        $Date
        [Object]        $Time
        [UInt32]        $Rank
        [Object]        $Name
        [String]       $First
        [String]          $MI
        [String]        $Last
        [Object]     $Address
        [Object]        $City
        [Object]      $Region
        [Object]     $Country
        [Object]      $Postal
        [UInt32]       $Month
        [UInt32]         $Day
        [UInt32]        $Year
        [String]         $DOB
        [Object]       $Image
        [Object[]]     $Phone
        [Object[]]     $Email
        [Object[]]    $Device
        [Object[]]   $Invoice

        _Client([Object]$UID)
        {
            $This.UID  = $UID.UID
            $This.Slot = 0
            $This.Type = "Client"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        
        GetStage()
        {
            $This.Phone   = @( )
            $This.Email   = @( )
            $This.Device  = @( )
            $This.Invoice = @( )
        }
        
        AddPhone([Object]$Phone)
        {
            $This.Phone  += $Phone
        }
        
        AddEmail([Object]$Email)
        {
            $This.Email  += $Email
        }

        SetStage([String]$First,[String]$Last,[Object]$DOB,[Object]$Phone,[Object]$Email)
        {
            $This.First   = $First
            $This.Last    = $Last
            $This.DOB     = $DOB
        
            $This.AddPhone($Phone)
            $This.AddEmail($Email)
        }
        
        [String] GetName()
        {
            If (!$This.First -or !$This.Last)
            {
                If (!$This.First) 
                { 
                    Throw "Missing first name" 
                }

                If (!$This.Last) 
                {
                    Throw "Missing last name"  
                }
            }

            Return "{0}, {1}" -f $This.Last, $This.First
        }

        SetName([String]$First,[String]$Last)
        {
            $This.Name = $This.GetName($First,$Last)
        }
    }

    Class _Service
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
        [String]          $Name
        [String[]] $Description
        [Float]           $Cost

        _Service([Object]$UID) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = 1
            $This.Type = "Service"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        
        [Object] GetName([String]$Name)
        {
            If ( $Name -in $This.Service.Name )
            {
                Return @( $This.Service | ? Name -eq $Name )
            }

            Else 
            {
                Return $Null    
            }
        }

        [Object] GetUID([Object]$UID)
        {
            If ( $UID -in $This.Service.UID )
            {
                Return @( $This.Service | ? UID -eq $UID )
            }

            Else 
            {
                Return $Null
            }
        }
    }

    Class _Device
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [String]          $Rank

        [String]       $Chassis
        [String]        $Vendor
        [String]         $Model
        [String] $Specification
        [String]        $Serial
        [Object]         $Title
        [Object]        $Client
        [Object]         $Issue
        [Object]      $Purchase
        [Object]       $Invoice

        _Device([Object]$UID) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = 2
            $This.Type = "Device"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
    }

    Class _Issue
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [Object]        $Client
        [Object]        $Device
        [String[]] $Description
        [Object]        $Status
        [Object]      $Purchase
        [Object]       $Service
        [Object]       $Invoice

        _Issue([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 3
            $This.Type = "Issue"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
    }

    Class _Inventory
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
            
        [String]        $Vendor
        [String]        $Serial
        [String]         $Model
        [Object]         $Title
        [Bool]        $IsDevice
        [Object[]]      $Device
        [Object]          $Cost

        _Inventory([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 4
            $This.Type = "Inventory"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
    }

    Class _Purchase
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [Object]   $Distributor
        [Object]   $DisplayName
        [String]        $Vendor
        [String]        $Serial
        [String]         $Model
        [Object]         $Title
        [Object]       $Invoice
        [Object]          $Cost
        
        _Purchase([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 5
            $This.Type = "Purchase"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
    }

    Class _Expense
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [Object]     $Recipient
        [Object]   $DisplayName
        [Object]       $Account
        [UInt32]          $Cost

        _Expense([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 6
            $This.Type = "Expense"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
    }

    Class _Account
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [Object]        $Object

        _Account([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 7
            $This.Type = "Account"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
    }

    Class _DB
    {
        [Object[]]         $UID
        [Object[]]      $Client
        [Object[]]     $Service
        [Object[]]      $Device
        [Object[]]       $Issue
        [Object[]]   $Inventory
        [Object[]]    $Purchase
        [Object[]]     $Expense
        [Object[]]     $Account
        
        _DB()
        {
            $This.UID       = @( )
            $This.Client    = @( )
            $This.Service   = @( )
            $This.Device    = @( )
            $This.Issue     = @( )
            $This.Inventory = @( )
            $This.Purchase  = @( )
            $This.Expense   = @( )
            $This.Account   = @( )  
        }

        [UInt32] GetCount([UInt32]$X)
        {
            Return ( $X + 1 )
        }

        [UInt32] GetIndex()
        {
            Return ($This.GetCount($This.UID.Count) - 1)
        }

        [UInt32] GetRank([UInt32]$Slot)
        {
            Return $This.GetCount(
            @(  
                $This.Client.Count    ,
                $This.Service.Count   ,
                $This.Device.Count    ,
                $This.Issue.Count     , 
                $This.Inventory.Count ,
                $This.Purchase.Count  ,
                $This.Expense.Count   ,
                $This.Account.Count   
            
            )[$Slot]) - 1
        }

        AddUID([Object]$Slot)
        {
            If ($Slot -notin 0..7)
            {
                Throw "Invalid entry"
            }

            $Item                = [_UID]::New($Slot)
            $Item.Type           = @("Client Service Device Issue Inventory Purchase Expense Account" -Split " ")[$Slot]
            $Item.Index          = $This.GetIndex()
            $Item.Record         = Switch ($Slot)
            {
                0 { [_Client    ]::New($Item) }
                1 { [_Service   ]::New($Item) }
                2 { [_Device    ]::New($Item) }
                3 { [_Issue     ]::New($Item) }
                4 { [_Inventory ]::New($Item) } 
                5 { [_Purchase  ]::New($Item) }
                6 { [_Expense   ]::New($Item) }
                7 { [_Account   ]::New($Item) }
            }

            $Item.Record.Index   = $Item.Index
            $Item.Record.Rank    = $This.GetRank($Slot)

            Switch($Slot)
            {
                0 { $This.Client     += $Item }
                1 { $This.Service    += $Item }
                2 { $This.Device     += $Item }
                3 { $This.Issue      += $Item }
                4 { $This.Inventory  += $Item }
                5 { $This.Purchase   += $Item }
                6 { $This.Expense    += $Item }
                7 { $This.Account    += $Item }
            }

            $This.UID            += $Item
        }
    }

    Class _GFX
    {
        [String] $Base = "https://github.com/mcc85sx/FightingEntropy/blob/master/Graphics"
        [String] $Path = "$Env:ProgramData\Secure Digits Plus LLC\Graphics"
        [String] $Logo 
        [String] $Icon
        [String] $Background

        _GFX()
        {
            $Root            = ""

            ForEach ( $Item in $This.Path.Split("\") )
            {
                $Root       += $Item

                If (!(Test-Path $Root))
                {
                    New-Item $Root -ItemType Directory -Verbose
                }

                $Root        = "$Root\"
            }

            $Root            = $Root.TrimEnd("\")

            $This.Logo       = "$Root\sdplogo.png"
            $This.Icon       = "$Root\icon.ico"
            $This.Background = "$Root\background.jpg"

            If (!(Test-Path $This.Logo))
            {
                Invoke-WebRequest -URI "$($This.Base)/sdplogo.png?raw=true"    -OutFile $This.Logo       -Verbose
            }

            If (!(Test-Path $This.Icon))
            {
                Invoke-WebRequest -URI "$($This.Base)/icon.ico?raw=true"       -OutFile $This.Icon       -Verbose
            }

            If (!(Test-Path $This.Background))
            {
                Invoke-WebRequest -URI "$($This.Base)/background.jpg?raw=true" -OutFile $This.Background -Verbose
            }
        }
    }

    Class _Xaml
    {
        Hidden [Object]        $Xaml
        [String[]]            $Names
        Hidden [Object]         $XML
        [Object]               $Node
        [Object]                 $IO

        [String[]] FindNames()
        {
            $ID   = [Regex]"((Name)\s*=\s*('|`")\w+('|`"))" | % Matches $This.Xaml | % Value | % { $_.Split('"')[1] }

            Return ( $ID | Select-Object -Unique )
        }

        _Xaml([String]$Xaml)
        {           
            [System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

            $This.Xaml               = $Xaml
            $This.Names              = $This.FindNames()
            $This.XML                = [XML]$This.Xaml
            $This.Node               = [System.Xml.XmlNodeReader]::New($This.XML)
            $This.IO                 = [System.Windows.Markup.XamlReader]::Load($This.Node)

            $This.Names              | % { 

                $This.IO             | Add-Member -MemberType NoteProperty -Name $_ -Value $This.IO.FindName($_) -Force

            }
        }

        Invoke()
        {
            $This.IO.Dispatcher.InvokeAsync{$This.IO.ShowDialog()}.Wait()
        }
    }

    Class cimdb
    {
        [Object] $Window
        [Object]     $IO
        [Object]     $DB

        cimdb([String]$Xaml)
        {
            $This.Window = [_Xaml]::New($Xaml)
            $This.IO     = $This.Window.IO
            $This.DB     = [_DB]::New()
        }
    }

    $GFX  = [_Gfx]::New()
    $Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
            Title="Company Information Management Database [FightingEntropy]://(cim-db)" 
            Height="600" 
            Width="800"
            Topmost="True" 
            ResizeMode="NoResize" 
            Icon="$($GFX.Icon)" 
            HorizontalAlignment="Center" 
            WindowStartupLocation="CenterScreen"
            FontFamily="Consolas">
        <Window.Resources>
            <Style TargetType="TabItem">
                <Setter Property="FontSize" Value="15"/>
                <Setter Property="FontWeight" Value="Heavy"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="TabItem">
                            <Border Name="Border" BorderThickness="2,2,2,2" BorderBrush="Black" CornerRadius="2" Margin="2">
                                <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Right" ContentSource="Header" Margin="5"/>
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsSelected" Value="True">
                                    <Setter TargetName="Border" Property="Background" Value="#4444FF"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                </Trigger>
                                <Trigger Property="IsSelected" Value="False">
                                    <Setter TargetName="Border" Property="Background" Value="#DFFFBA"/>
                                    <Setter Property="Foreground" Value="#000000"/>
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType="Button">
                <Setter Property="FontSize" Value="16"/>
                <Setter Property="FontWeight" Value="Heavy"/>
                <Setter Property="Foreground" Value="Black"/>
                <Setter Property="BorderThickness" Value="2"/>
                <Style.Resources>
                    <Style TargetType="Border">
                        <Setter Property="CornerRadius" Value="2"/>
                    </Style>
                </Style.Resources>
            </Style>
            <Style TargetType="TextBox">
                <Setter Property="Height" Value="24"/>
                <Setter Property="Margin" Value="4"/>
                <Setter Property="FontSize" Value="12"/>
                <Setter Property="BorderThickness" Value="2"/>
                <Setter Property="Foreground" Value="#000000"/>
                <Style.Resources>
                    <Style TargetType="Border">
                        <Setter Property="CornerRadius" Value="2"/>
                    </Style>
                </Style.Resources>
            </Style>
            <Style TargetType="ComboBox">
                <Setter Property="Height" Value="24"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="FontSize" Value="12"/>
                <Setter Property="FontWeight" Value="Normal"/>
            </Style>
            <Style TargetType="DataGridColumnHeader">
                <Setter Property="FontSize"   Value="12"/>
                <Setter Property="FontWeight" Value="Normal"/>
            </Style>
        </Window.Resources>
        <TabControl TabStripPlacement="Left" HorizontalContentAlignment="Right">
            <TabControl.Resources>
                <Style TargetType="GroupBox">
                    <Setter Property="Foreground" Value="Black"/>
                    <Setter Property="Margin" Value="5"/>
                    <Setter Property="FontSize" Value="12"/>
                    <Setter Property="FontWeight" Value="Normal"/>
                </Style>
            </TabControl.Resources>
            <TabItem>
                <TabItem.Header>
                    <Image Width="80" Source="$($GFX.Logo)"/>
                </TabItem.Header>
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetUIDSearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="UID"/>
                                    <ComboBoxItem Content="Index"/>
                                    <ComboBoxItem Content="Date"/>
                                </ComboBox>
                                <TextBox Grid.Column="1" >
                                </TextBox>
                                <TextBox Grid.Column="1" Name="_GetUIDSearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetUIDSearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="UID"    Binding='{Binding UID}'    Width="160"/>
                                    <DataGridTextColumn Header="Index"  Binding='{Binding Index}'  Width="60"/>
                                    <DataGridTextColumn Header="Slot"   Binding='{Binding Slot}'   Width="40"/>
                                    <DataGridTextColumn Header="Date"   Binding='{Binding Date}'   Width="*"/>
                                    <DataGridTextColumn Header="Time"   Binding='{Binding Time}'   Width="0.25*"/>
                                    <DataGridTextColumn Header="Record" Binding='{Binding Record}' Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="200"/>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[UID]">
                                    <TextBox Name="_ViewUIDUID" IsEnabled="False"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Index]">
                                    <TextBox Name="_ViewUIDIndex" IsEnabled="False"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Slot]">
                                    <TextBox Name="_ViewUIDSlot" IsEnabled="False"/>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Type]">
                                    <TextBox Name="_ViewUIDType" IsEnabled="False"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Date]">
                                    <TextBox Name="_ViewUIDDate" IsEnabled="False"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Date]">
                                    <TextBox Name="_ViewUIDTime" IsEnabled="False"/>
                                </GroupBox>
                            </Grid>
                            <DataGrid Grid.Row="2" Margin="5" Name="_ViewUIDRecord">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Name" Width="*"/>
                                    <DataGridTextColumn Header="Value" Width="2*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Client">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetClientSearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="Name"/>
                                    <ComboBoxItem Content="Phone Number"/>
                                    <ComboBoxItem Content="Email Address"/>
                                </ComboBox>
                                <TextBox Grid.Column="1" >
                                </TextBox>
                                <TextBox Grid.Column="1" Name="_GetClientSearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetClientSearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Name"  Binding='{Binding Name}'  Width="*"/>
                                    <DataGridTextColumn Header="Last"  Binding='{Binding Last}'  Width="*"/>
                                    <DataGridTextColumn Header="First" Binding='{Binding First}' Width="*"/>
                                    <DataGridTextColumn Header="MI"    Binding='{Binding MI}'    Width="0.25*"/>
                                    <DataGridTextColumn Header="DOB"   Binding='{Binding DOB}'   Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="3*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="0.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Last]">
                                    <TextBox Name="_ViewClientLast"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[First]">
                                    <TextBox Name="_ViewClientFirst"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[MI]">
                                    <TextBox Name="_ViewClientMI"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="1" Header="[Address]">
                                <TextBox Name="_ViewClientAddress"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="3*"/>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="1.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[City]">
                                    <TextBox Name="_ViewClientCity"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Region]">
                                    <TextBox Name="_ViewClientRegion"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Country]">
                                    <TextBox Name="_ViewClientCountry"/>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Postal]">
                                    <TextBox Name="_ViewClientPostal"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Column="0" Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="2.5*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                        <Grid>
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="0.5*"/>
                                                <ColumnDefinition Width="0.5*"/>
                                                <ColumnDefinition Width="*"/>
                                            </Grid.ColumnDefinitions>
                                            <TextBox Grid.Column="0" Name="_ViewClientMonth"/>
                                            <TextBox Grid.Column="1" Name="_ViewClientDay"/>
                                            <TextBox Grid.Column="2" Name="_ViewClientYear"/>
                                        </Grid>
                                    </GroupBox>
                                    <GroupBox Grid.Column="3" Header="[Gender]">
                                        <ComboBox Name="_ViewClientGender" SelectedIndex="2">
                                            <ComboBoxItem Content="Male"/>
                                            <ComboBoxItem Content="Female"/>
                                            <ComboBoxItem Content="-"/>
                                        </ComboBox>
                                    </GroupBox>
                                </Grid>
                                <GroupBox Header="[Phone Number(s)]" Grid.Column="0" Grid.Row="1">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="40"/>
                                            <ColumnDefinition Width="40"/>
                                        </Grid.ColumnDefinitions>
                                        <ComboBox Grid.Column="0"/>
                                        <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddPhone"/>
                                        <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemovePhone"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="40"/>
                                            <ColumnDefinition Width="40"/>
                                        </Grid.ColumnDefinitions>
                                        <ComboBox Grid.Column="0"/>
                                        <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddEmail"/>
                                        <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveEmail"/>
                                    </Grid>
                                </GroupBox>
                                <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                            </Grid>
                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="240"/>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                            </Grid>
                            <GroupBox Grid.Row="4" Header="[Device(s)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddDevice"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Margin="5"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddInvoice"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveInvoice"/>
                                </Grid>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Edit">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="3*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="0.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="1" Header="[First]">
                                    <TextBox Name="_EditClientFirst"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[MI]">
                                    <TextBox Name="_EditClientMI"/>
                                </GroupBox>
                                <GroupBox Grid.Column="0" Header="[Last]">
                                    <TextBox Name="_EditClientLast"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="1" Header="[Address]">
                                <TextBox Name="_EditClientAddress"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="3*"/>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="1.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[City]">
                                    <TextBox Name="_EditClientCity"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Region]">
                                    <TextBox Name="_EditClientRegion"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Country]">
                                    <TextBox Name="_EditClientCountry"/>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Postal]">
                                    <TextBox Name="_EditClientPostal"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Column="0" Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="2.5*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                        <Grid>
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="0.5*"/>
                                                <ColumnDefinition Width="0.5*"/>
                                                <ColumnDefinition Width="*"/>
                                            </Grid.ColumnDefinitions>
                                            <TextBox Grid.Column="0" Name="_EditClientMonth"/>
                                            <TextBox Grid.Column="1" Name="_EditClientDay"/>
                                            <TextBox Grid.Column="2" Name="_EditClientYear"/>
                                        </Grid>
                                    </GroupBox>
                                    <GroupBox Grid.Column="3" Header="[Gender]">
                                        <ComboBox Name="_EditClientGender" Height="24" Margin="5" SelectedIndex="2">
                                            <ComboBoxItem Content="Male"/>
                                            <ComboBoxItem Content="Female"/>
                                            <ComboBoxItem Content="-"/>
                                        </ComboBox>
                                    </GroupBox>
                                </Grid>
                                <GroupBox Header="[Phone Number(s)]"  Grid.Column="0" Grid.Row="1">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="40"/>
                                            <ColumnDefinition Width="40"/>
                                        </Grid.ColumnDefinitions>
                                        <ComboBox Grid.Column="0" Margin="5"/>
                                        <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddPhone"/>
                                        <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemovePhone"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="40"/>
                                            <ColumnDefinition Width="40"/>
                                        </Grid.ColumnDefinitions>
                                        <ComboBox Grid.Column="0" Margin="5"/>
                                        <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddEmail"/>
                                        <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveEmail"/>
                                    </Grid>
                                </GroupBox>
                                <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                            </Grid>
                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="240"/>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                            </Grid>
                            <GroupBox Grid.Row="4" Header="[Device(s)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Margin="5"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddDevice"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Margin="5"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddInvoice"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveInvoice"/>
                                </Grid>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="New">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="3*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="0.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="1" Header="[First]">
                                    <TextBox Name="_NewClientFirst"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[MI]">
                                    <TextBox Name="_NewClientMI"/>
                                </GroupBox>
                                <GroupBox Grid.Column="0" Header="[Last]">
                                    <TextBox Name="_NewClientLast"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="1" Header="[Address]">
                                <TextBox Name="_NewClientAddress"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="3*"/>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="1.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[City]">
                                    <TextBox Name="_NewClientCity"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Region]">
                                    <TextBox Name="_NewClientRegion"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Country]">
                                    <TextBox Name="_NewClientCountry"/>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Postal]">
                                    <TextBox Name="_NewClientPostal"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Column="0" Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="2.5*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                        <Grid>
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="0.5*"/>
                                                <ColumnDefinition Width="0.5*"/>
                                                <ColumnDefinition Width="*"/>
                                            </Grid.ColumnDefinitions>
                                            <TextBox Grid.Column="0" Name="_NewClientMonth"/>
                                            <TextBox Grid.Column="1" Name="_NewClientDay"/>
                                            <TextBox Grid.Column="2" Name="_NewClientYear"/>
                                        </Grid>
                                    </GroupBox>
                                    <GroupBox Grid.Column="3" Header="[Gender]">
                                        <ComboBox Name="_NewClientGender" Height="24" Margin="5" SelectedIndex="2">
                                            <ComboBoxItem Content="Male"/>
                                            <ComboBoxItem Content="Female"/>
                                            <ComboBoxItem Content="-"/>
                                        </ComboBox>
                                    </GroupBox>
                                </Grid>
                                <GroupBox Header="[Phone Number(s)]"  Grid.Column="0" Grid.Row="1">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="40"/>
                                            <ColumnDefinition Width="40"/>
                                        </Grid.ColumnDefinitions>
                                        <ComboBox Grid.Column="0" Margin="5"/>
                                        <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddPhone"/>
                                        <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemovePhone"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="40"/>
                                            <ColumnDefinition Width="40"/>
                                        </Grid.ColumnDefinitions>
                                        <ComboBox Grid.Column="0" Margin="5"/>
                                        <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddEmail"/>
                                        <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveEmail"/>
                                    </Grid>
                                </GroupBox>
                                <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                            </Grid>
                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="240"/>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                            </Grid>
                            <GroupBox Grid.Row="4" Header="[Device(s)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Margin="5"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddDevice"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Margin="5"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddInvoice"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveInvoice"/>
                                </Grid>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Service">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetServiceSearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="Name"/>
                                    <ComboBoxItem Content="Description"/>
                                </ComboBox>
                                <TextBox Grid.Column="1" >
                                </TextBox>
                                <TextBox Grid.Column="1" Name="_GetServiceSearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetServiceSearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Name" Binding='{Binding Name}' Width="*"/>
                                    <DataGridTextColumn Header="Description" Binding='{Binding Description}' Width="*"/>
                                    <DataGridTextColumn Header="Cost" Binding='{Binding Cost}' Width="0.5*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Name]">
                                <TextBox Name="_ViewServiceName"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Description]">
                                <TextBox Name="_ViewServiceDescription"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Cost]">
                                <TextBox Name="_ViewServiceCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Edit">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Name]">
                                <TextBox Name="_EditServiceName"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Description]">
                                <TextBox Name="_EditServiceDescription"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Cost]">
                                <TextBox Name="_EditServiceCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="New">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Name]">
                                <TextBox Name="_NewServiceName"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Description]">
                                <TextBox Name="_NewServiceDescription"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Cost]">
                                <TextBox Name="_NewServiceCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Device">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetDeviceSearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="Vendor"/>
                                    <ComboBoxItem Content="Model"/>
                                    <ComboBoxItem Content="Specification"/>
                                </ComboBox>
                                <TextBox Grid.Column="1" Name="_GetDeviceSearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetDeviceSearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Vendor"        Binding='{Binding Vendor}'        Width="*"/>
                                    <DataGridTextColumn Header="Model"         Binding='{Binding Model}'         Width="*"/>
                                    <DataGridTextColumn Header="Specification" Binding='{Binding Specification}' Width="*"/>
                                    <DataGridTextColumn Header="Serial"        Binding='{Binding Serial}'        Width="*"/>
                                    <DataGridTextColumn Header="Title"         Binding='{Binding Title}'         Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="1.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Chassis]">
                                    <ComboBox Name="_ViewDeviceChassis" SelectedIndex="8">
                                        <ComboBoxItem Content="Desktop"/>
                                        <ComboBoxItem Content="Laptop"/>
                                        <ComboBoxItem Content="Smartphone"/>
                                        <ComboBoxItem Content="Tablet"/>
                                        <ComboBoxItem Content="Console"/>
                                        <ComboBoxItem Content="Server"/>
                                        <ComboBoxItem Content="Network"/>
                                        <ComboBoxItem Content="Other"/>
                                        <ComboBoxItem Content="-"/>
                                    </ComboBox>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Vendor]">
                                    <TextBox Name="_ViewDeviceVendor"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Model]">
                                    <TextBox Name="_ViewDeviceModel"/>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Specification]">
                                    <TextBox Name="_ViewDeviceSpecification"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Serial]">
                                    <TextBox Name="_ViewDeviceSerial"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Title]">
                                    <TextBox Name="_ViewDeviceTitle"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="2" Header="[Client(s)]">
                                <ComboBox Name="_ViewDeviceClient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Issue(s)]">
                                <ComboBox Name="_ViewDeviceIssue"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                                <ComboBox Name="_ViewDevicePurchase"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                                <ComboBox Name="_ViewDeviceInvoice"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Edit">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="1.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Chassis]">
                                    <ComboBox Name="_EditDeviceChassis" SelectedIndex="8">
                                        <ComboBoxItem Content="Desktop"/>
                                        <ComboBoxItem Content="Laptop"/>
                                        <ComboBoxItem Content="Smartphone"/>
                                        <ComboBoxItem Content="Tablet"/>
                                        <ComboBoxItem Content="Console"/>
                                        <ComboBoxItem Content="Server"/>
                                        <ComboBoxItem Content="Network"/>
                                        <ComboBoxItem Content="Other"/>
                                        <ComboBoxItem Content="-"/>
                                    </ComboBox>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Vendor]">
                                    <TextBox Name="_EditDeviceVendor"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Model]">
                                    <TextBox Name="_EditDeviceModel"/>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Specification]">
                                    <TextBox Name="_EditDeviceSpecification"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Serial]">
                                    <TextBox Name="_EditDeviceSerial"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Title]">
                                    <TextBox Name="_EditDeviceTitle"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="2" Header="[Client(s)]">
                                <ComboBox Name="_EditDeviceClient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Issue(s)]">
                                <ComboBox Name="_EditDeviceIssue"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                                <ComboBox Name="_EditDevicePurchase"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                                <ComboBox Name="_EditDeviceInvoice"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="New">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="1.5*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Chassis]">
                                    <ComboBox Name="_NewDeviceChassis" SelectedIndex="8">
                                        <ComboBoxItem Content="Desktop"/>
                                        <ComboBoxItem Content="Laptop"/>
                                        <ComboBoxItem Content="Smartphone"/>
                                        <ComboBoxItem Content="Tablet"/>
                                        <ComboBoxItem Content="Console"/>
                                        <ComboBoxItem Content="Server"/>
                                        <ComboBoxItem Content="Network"/>
                                        <ComboBoxItem Content="Other"/>
                                        <ComboBoxItem Content="-"/>
                                    </ComboBox>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Vendor]">
                                    <TextBox Name="_NewDeviceVendor"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Model]">
                                    <TextBox Name="_NewDeviceModel"/>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Specification]">
                                    <TextBox Name="_NewDeviceSpecification"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Serial]">
                                    <TextBox Name="_NewDeviceSerial"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Title]">
                                    <TextBox Name="_NewDeviceTitle"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="2" Header="[Client(s)]">
                                <ComboBox Name="_NewDeviceClient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Issue(s)]">
                                <ComboBox Name="_NewDeviceIssue"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                                <ComboBox Name="_NewDevicePurchase"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                                <ComboBox Name="_NewDeviceInvoice"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Issue">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetIssueSearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="Client"/>
                                    <ComboBoxItem Content="Device"/>
                                </ComboBox>
                                <TextBox Grid.Column="1"/>
                                <TextBox Grid.Column="1" Name="_GetIssueSearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetIssueSearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Client"   Binding='{Binding Client}'   Width="*"/>
                                    <DataGridTextColumn Header="Device"   Binding='{Binding Device}'   Width="*"/>
                                    <DataGridTextColumn Header="Status"   Binding='{Binding Status}'   Width="*"/>
                                    <DataGridTextColumn Header="Purchase" Binding='{Binding Purchase}' Width="*"/>
                                    <DataGridTextColumn Header="Service"  Binding='{Binding Service}'  Width="*"/>
                                    <DataGridTextColumn Header="Invoice"  Binding='{Binding Invoice}'  Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Client]">
                                <ComboBox  Name="_ViewIssueClient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Device]">
                                <ComboBox Name="_ViewIssueDevice"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Description]">
                                <TextBox Name="_ViewIssueDescription"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Status]">
                                <ComboBox Name="_ViewIssueStatus"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Purchase]">
                                <ComboBox Name="_ViewIssuePurchase"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Service]">
                                <ComboBox Name="_ViewIssueService"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[Invoice]">
                                <ComboBox Name="_ViewIssueInvoice"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Edit">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Client]">
                                <ComboBox  Name="_EditIssueClient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Device]">
                                <ComboBox Name="_EditIssueDevice"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Description]">
                                <TextBox Name="_EditIssueDescription"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Status]">
                                <ComboBox Name="_EditIssueStatus"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Purchase]">
                                <ComboBox Name="_EditIssuePurchase"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Service]">
                                <ComboBox Name="_EditIssueService"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[Invoice]">
                                <ComboBox Name="_EditIssueInvoice"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="New">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Client]">
                                <ComboBox  Name="_NewIssueClient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Device]">
                                <ComboBox Name="_NewIssueDevice"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Description]">
                                <TextBox Name="_NewIssueDescription"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Status]">
                                <ComboBox Name="_NewIssueStatus"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Purchase]">
                                <ComboBox Name="_NewIssuePurchase"/>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Service]">
                                <ComboBox Name="_NewIssueService"/>
                            </GroupBox>
                            <GroupBox Grid.Row="6" Header="[Invoice]">
                                <ComboBox Name="_NewIssueInvoice"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Inventory">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetInventorySearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="Client"/>
                                    <ComboBoxItem Content="Device"/>
                                </ComboBox>
                                <TextBox Grid.Column="1"/>
                                <TextBox Grid.Column="1" Name="_GetInventorySearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetInventorySearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Vendor"     Binding='{Binding Vendor}'   Width="*"/>
                                    <DataGridTextColumn Header="Serial"     Binding='{Binding Serial}'   Width="*"/>
                                    <DataGridTextColumn Header="Model"      Binding='{Binding Model}'    Width="*"/>
                                    <DataGridTextColumn Header="Title"      Binding='{Binding Title}'    Width="2*"/>
                                    <DataGridTemplateColumn Header="Device" Binding='{Binding IsDevice}' Width="60">
                                        <DataGridTemplateColumn.CellTemplate>
                                            <DataTemplate>
                                                <ComboBox SelectedIndex="2">
                                                    <ComboBoxItem Content="N"/>
                                                    <ComboBoxItem Content="Y"/>
                                                    <ComboBoxItem Content="-"/>
                                                </ComboBox>
                                            </DataTemplate>
                                        </DataGridTemplateColumn.CellTemplate>
                                    </DataGridTemplateColumn>
                                    <DataGridTextColumn Header="Cost"  Binding='{Binding Cost}' Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Vendor]">
                                <ComboBox Name="_ViewInventoryVendor"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Serial]">
                                <ComboBox Name="_ViewInventorySerial"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Model]">
                                <ComboBox Name="_ViewInventoryModel"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Title]">
                                <ComboBox Name="_ViewInventoryTitle"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Device]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="3*"/>
                                    </Grid.ColumnDefinitions>
                                    <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_ViewInventoryIsDevice"/>
                                    <ComboBox Grid.Column="1" Name="_ViewInventoryDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Cost]">
                                <ComboBox Name="_ViewInventoryCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Edit">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Vendor]">
                                <ComboBox Name="_EditInventoryVendor"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Serial]">
                                <ComboBox Name="_EditInventorySerial"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Model]">
                                <ComboBox Name="_EditInventoryModel"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Title]">
                                <ComboBox Name="_EditInventoryTitle"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Device]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="3*"/>
                                    </Grid.ColumnDefinitions>
                                    <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_EditInventoryIsDevice"/>
                                    <ComboBox Grid.Column="1" Name="_EditInventoryDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Cost]">
                                <ComboBox Name="_EditInventoryCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="New">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Vendor]">
                                <ComboBox Name="_NewInventoryVendor"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Serial]">
                                <ComboBox Name="_NewInventorySerial"/>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[Model]">
                                <ComboBox Name="_NewInventoryModel"/>
                            </GroupBox>
                            <GroupBox Grid.Row="3" Header="[Title]">
                                <ComboBox Name="_NewInventoryTitle"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Device]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="3*"/>
                                    </Grid.ColumnDefinitions>
                                    <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_NewInventoryIsDevice"/>
                                    <ComboBox Grid.Column="1" Name="_NewInventoryDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Cost]">
                                <ComboBox Name="_NewInventoryCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Purchase">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetPurchaseSearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="Distributor"/>
                                    <ComboBoxItem Content="DisplayName"/>
                                    <ComboBoxItem Content="Vendor"/>
                                    <ComboBoxItem Content="Serial"/>
                                    <ComboBoxItem Content="Model"/>
                                    <ComboBoxItem Content="Title"/>
                                    <ComboBoxItem Content="Invoice"/>
                                </ComboBox>
                                <TextBox Grid.Column="1"/>
                                <TextBox Grid.Column="1" Name="_GetPurchaseSearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetPurchaseSearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Distributor"  Binding='{Binding Distributor}' Width="*"/>
                                    <DataGridTextColumn Header="DisplayName"  Binding='{Binding DisplayName}' Width="*"/>
                                    <DataGridTextColumn Header="Vendor"       Binding='{Binding Vendor}'      Width="*"/>
                                    <DataGridTextColumn Header="Serial"       Binding='{Binding Serial}'      Width="2*"/>
                                    <DataGridTextColumn Header="Model"        Binding='{Binding Model}'       Width="*"/>
                                    <DataGridTemplateColumn Header="Device"   Binding='{Binding IsDevice}' Width="60">
                                        <DataGridTemplateColumn.CellTemplate>
                                            <DataTemplate>
                                                <ComboBox SelectedIndex="2">
                                                    <ComboBoxItem Content="N"/>
                                                    <ComboBoxItem Content="Y"/>
                                                    <ComboBoxItem Content="-"/>
                                                </ComboBox>
                                            </DataTemplate>
                                        </DataGridTemplateColumn.CellTemplate>
                                    </DataGridTemplateColumn>
                                    <DataGridTextColumn Header="Cost"  Binding='{Binding Cost}' Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Distributor]">
                                <TextBox Name="_ViewPurchaseDistributor"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Display Name]">
                                <TextBox Name="_ViewPurchaseDisplayName"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="2*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Vendor]">
                                    <TextBox Name="_ViewPurchaseVendor"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Model]">
                                    <TextBox Name="_ViewPurchaseModel"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Specification]">
                                    <TextBox Name="_ViewPurchaseSpecification"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="3" Header="[Serial]">
                                <TextBox Name="_ViewPurchaseSerial"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Device]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="3*"/>
                                    </Grid.ColumnDefinitions>
                                    <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_ViewPurchaseIsDevice"/>
                                    <ComboBox Grid.Column="1" Name="_ViewPurchaseDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Cost]">
                                <TextBox Name="_ViewPurchaseCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Edit">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Distributor]">
                                <TextBox Name="_EditPurchaseDistributor"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Display Name]">
                                <TextBox Name="_EditPurchaseDisplayName"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="2*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Vendor]">
                                    <TextBox Name="_EditPurchaseVendor"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Model]">
                                    <TextBox Name="_EditPurchaseModel"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Specification]">
                                    <TextBox Name="_EditPurchaseSpecification"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="3" Header="[Serial]">
                                <TextBox Name="_EditPurchaseSerial"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Device]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="3*"/>
                                    </Grid.ColumnDefinitions>
                                    <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_EditPurchaseIsDevice"/>
                                    <ComboBox Grid.Column="1" Name="_EditPurchaseDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Cost]">
                                <TextBox Name="_EditPurchaseCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="New">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Distributor]">
                                <TextBox Name="_NewPurchaseDistributor"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Display Name]">
                                <TextBox Name="_NewPurchaseDisplayName"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="2*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Vendor]">
                                    <TextBox Name="_NewPurchaseVendor"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Model]">
                                    <TextBox Name="_NewPurchaseModel"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Specification]">
                                    <TextBox Name="_NewPurchaseSpecification"/>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="3" Header="[Serial]">
                                <TextBox Name="_NewPurchaseSerial"/>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[Device]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="3*"/>
                                    </Grid.ColumnDefinitions>
                                    <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_NewPurchaseIsDevice"/>
                                    <ComboBox Grid.Column="1" Name="_NewPurchaseDevice"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="5" Header="[Cost]">
                                <TextBox Name="_NewPurchaseCost"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Expense">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetExpenseSearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="Recipient"/>
                                    <ComboBoxItem Content="DisplayName"/>
                                    <ComboBoxItem Content="Account"/>
                                    <ComboBoxItem Content="Cost"/>
                                </ComboBox>
                                <TextBox Grid.Column="1"/>
                                <TextBox Grid.Column="1" Name="_GetExpenseSearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetExpenseSearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Recipient"    Binding='{Binding Recipient}'   Width="*"/>
                                    <DataGridTextColumn Header="DisplayName"  Binding='{Binding DisplayName}' Width="1.5*"/>
                                    <DataGridTextColumn Header="Account"      Binding='{Binding Account}'     Width="*"/>
                                    <DataGridTextColumn Header="Cost"         Binding='{Binding Cost}'        Width="0.5*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Recipient]">
                                <TextBox Name="_ViewExpenseRecipient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Display Name]">
                                <TextBox Name="_ViewExpenseDisplayName"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Account]">
                                    <ComboBox Name="_ViewExpenseAccount"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Cost]">
                                    <TextBox Name="_ViewExpenseCost"/>
                                </GroupBox>
                            </Grid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Edit">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Recipient]">
                                <TextBox Name="_EditExpenseRecipient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Display Name]">
                                <TextBox Name="_EditExpenseDisplayName"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Account]">
                                    <ComboBox Name="_EditExpenseAccount"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Cost]">
                                    <TextBox Name="_EditExpenseCost"/>
                                </GroupBox>
                            </Grid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="New">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[Recipient]">
                                <TextBox Name="_NewExpenseRecipient"/>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[Display Name]">
                                <TextBox Name="_NewExpenseDisplayName"/>
                            </GroupBox>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[Account]">
                                    <ComboBox Name="_NewExpenseAccount"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[Cost]">
                                    <TextBox Name="_NewExpenseCost"/>
                                </GroupBox>
                            </Grid>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Account">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="35"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="35"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="4*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_GetAccountSearchType" SelectedIndex="0" BorderThickness="1">
                                    <ComboBoxItem Content="Object"/>
                                </ComboBox>
                                <TextBox Grid.Column="1"/>
                                <TextBox Grid.Column="1" Name="_GetAccountSearchFilter"/>
                            </Grid>
                            <DataGrid Grid.Row="1" Margin="5" Name="_GetAccountSearchBox">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Object"  Binding='{Binding Object}' Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="View">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Column="0" Header="[Object]">
                                <ComboBox Name="_ViewAccountObject"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Edit">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Column="0" Header="[Object]">
                                <ComboBox Name="_EditAccountObject"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="New">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="70"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Column="0" Header="[Object]">
                                <ComboBox Name="_NewAccountObject"/>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem Header="Invoice">
                <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
                    <TabItem Header="Get"/>
                    <TabItem Header="View"/>
                    <TabItem Header="Edit"/>
                    <TabItem Header="New"/>
                </TabControl>
            </TabItem>
        </TabControl>
    </Window>
"@

    [Cimdb]::New($Xaml)
}
