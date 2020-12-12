Function Get-XamlWindow # // Originally based on Dr. Weltner's work, but also Jason Adkinson from Pluralsight
{
    [CmdletBinding()]Param(
    [Parameter(Mandatory)]
    [String]$Type)
    
    # // Load the Assemblies (TODO: Get Unix to load these)
    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName PresentationCore
    Add-Type -AssemblyName WindowsBase

    [String]$Icon = "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico"

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
        'ox GroupBoxItem Header Height {3}{5} {3}Content{5} Label Margin Menu MenuItem Name Padding {6} {6'+
        '}Box {6}Char Property RadioButton Resources RowDefinition SelectIndex Setter Style TabControl Tar'+
        'getName TargetType TextBlock TextBox TextWrapping Title Trigger Value {4}{5} {4}Content{5} Width '+
        'Window x:Key') -f "Definition","Grid.Column","Grid.Row","Horizontal","Vertical","Alignment","Password"
        ).Split(" ")

        Hidden [String[]] $Labels = @(('BG BO BU CHK CD CB CBI CO CP CT EF G GC GCD GCS GR GRD GRS GB GBI HD' +
        ' H Hx HCx LA MA MN MNI N PA PW PWB PWC PR RB RES RD SI SE ST TC TN TT TBL TB TW TI TR VA Vx VCx W' + 
        ' WI XK') -Split " " | % { "`${0}" -f $_ } )  

        [Object] $Glossary

        _XamlGlossary()
        {
            $This.Glossary      = @( ) 
        
            ForEach ( $I in 0..($This.Names.Count - 1))
            {
                $This.Glossary += [_XamlGlossaryEntry]::New($I,$This.Labels[$I],$This.Names[$I])
            }
        }
    }

    Class _XamlWindow 
    {
        Hidden [String]        $Xaml
        [String[]]            $Names 
        [Object]               $Node
        [Object]               $Host
        [Object]             $Output

        _XamlWindow([String]$XAML)
        {           
            If ( !$Xaml )
            {
                Throw "Invalid XAML Input"
            }

            $This.Xaml               = $Xaml
            $This.Names              = ([Regex]"((Name)\s*=\s*('|`")\w+('|`"))").Matches($This.Xaml).Value | % { $_ -Replace "(Name|=|'|`"|\s)","" } | Select-Object -Unique
            $This.Node               = [System.XML.XmlNodeReader]::new([XML]$This.Xaml)
            $This.Host               = [System.Windows.Markup.XAMLReader]::Load($This.Node)
    
            ForEach ( $I in 0..( $This.Names.Count - 1 ) )
            {
                $This.Host           | Add-Member -MemberType NoteProperty -Name $This.Names[$I] -Value $This.Host.FindName($This.Names[$I]) -Force 
            }
        }

        Invoke()
        {
            $This.Output             = @( )

            $This.Host.Dispatcher.InvokeAsync(
            {
                $This.Output         = $This.Host.ShowDialog()
                Set-Variable -Name Output -Value $This.Output -Scope Global

            }).Wait()
        }
    }
    
    Class _XamlObject
    {
        [String[]]        $Names = ("Certificate ADLogin NewAccount FEDCPromo FEDCFound FERoot FEShare FEService" -Split " ")
        [Object]       $Glossary = [_XamlGlossary]::New().Glossary
        [Object]           $Xaml = @{ 

            Certificate          = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://Certificate Info" $W`="350" $H`='+
            '"200" Topmost="True" Icon="$Icon" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$GB` $HD`="Company Information / Certificate Gener'+
            'ation" $W`="330" $H`="160" $Vx`="Top"><$G`><$G`.$RD`s><$RD` $H`="2*"/><$RD` $H`="*"/></$G`.$RD`s><$G` $G`'+ 
            '.Row="0"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="2.5*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/'+
            '></$G`.$RD`s><$TBL` $G`.Row="0" $G`.Column="0" $MA`="10" TextAlignment="Right">Company:</$TBL`><$TB` $N`='+
            '"Company" $G`.Row="0" $G`.Column="1" $H`="24" $MA`="5"/><$TBL` $G`.Row="1" $G`.Column="0" $MA`="10" TextA'+ 
            'lignment="Right">Domain:</$TBL`><$TB` $N`="Domain" $G`.Row="1" $G`.Column="1" $H`="24" $MA`="5"/></$G`><$'+
            'G` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$BU` $N`="Ok" $CO`="Ok" $G`.Column="'+
            '0" $MA`="10"/><$BU` $N`="Cancel" $CO`="Cancel" $G`.Column="1" $MA`="10"/></$G`></$G`></$GB`></$WI`>')

            ADLogin              = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://AD Login" $W`="480" $H`="280" To'+
            'pmost="True" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon.ico" $Hx'+
            '`="Center" $WI`StartupLocation="CenterScreen"><$GB` $HD`="Enter Directory Services Admin Account" $W`="45'+
            '0" $H`="240" $MA`="5" $Vx`="Center"><$G`><$G`.$RD`s><$RD` $H`="2*"/><$RD` $H`="1.25*"/></$G`.$RD`s><$G` $'+
            'G`.Row="0"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="3*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/'+
            '><$RD` $H`="*"/></$G`.$RD`s><$TBL` $G`.Column="0" $G`.Row="0" $MA`="10" TextAlignment="Right"> User$N`:</'+
            '$TBL`><$TB` $N`="User$N`" $G`.Column="1" $G`.Row="0" $H`="24" $MA`="5"></$TB`><$TBL` $G`.Column="0" $G`.R'+
            'ow="1" $MA`="10" TextAlignment="Right"> $PW`:</$TBL`><$PW`Box $N`="$PW`" $G`.Column="1" $G`.Row="1" $H`="'+
            '24" $MA`="5" $PW`Char="*"></$PW`Box><$TBL` $G`.Column="0" $G`.Row="2" $MA`="10" TextAlignment="Right"> Co'+
            'nfirm:</$TBL`><$PW`Box $N`="Confirm" $G`.Column="1" $G`.Row="2" $H`="24" $MA`="5" $PW`Char="*"></$PW`Box>'+
            '</$G`><$G` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$R'+
            'D` $H`="*"/></$G`.$RD`s><Radio$BU` $N`="Switch" $G`.Row="0" $G`.Column="0" $CO`="Change" $Vx`="Center" $H'+
            'x`="Center"/><$TB` $N`="Port" $G`.Row="0" $G`.Column="1" $Vx`="Center" $Hx`="Center" $W`="120" IsEnabled='+
            '"False">389</$TB`><$BU` $N`="Ok" $CO`="Ok" $G`.Column="0" $G`.Row="1" $MA`="5"></$BU`><$BU` $N`="Cancel" '+
            '$CO`="Cancel" $G`.Column="1" $G`.Row="1" $MA`="5"></$BU`></$G`></$G`></$GB`></$WI`>' )

            NewAccount           = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            'http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://Account Designation" $W`="480" $H'+
            '`="280" Topmost="True" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\ico'+
            'n.ico" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$GB` $HD`="Enter User$N` and $PW`" $W`="450" $H`'+
            '="240" $MA`="5" $Vx`="Center"><$G`><$G`.$RD`s><$RD` $H`="2*"/><$RD` $H`="1.25*"/></$G`.$RD`s><$G` $G`.Row'+
            '="0"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="3*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/><$RD`'+
            ' $H`="*"/></$G`.$RD`s><$TBL` $G`.Column="0" $G`.Row="0" $MA`="10" TextAlignment="Right"> User$N`:</$TBL`>'+
            '<$TB` $N`="User$N`" $G`.Column="1" $G`.Row="0" $H`="24" $MA`="5"></$TB`><$TBL` $G`.Column="0" $G`.Row="1"'+
            ' $MA`="10" TextAlignment="Right"> $PW`:</$TBL`><$PW`Box $N`="$PW`" $G`.Column="1" $G`.Row="1" $H`="24" $M'+
            'A`="5" $PW`Char="*"></$PW`Box><$TBL` $G`.Column="0" $G`.Row="2" $MA`="10" TextAlignment="Right"> Confirm:'+
            '</$TBL`><$PW`Box $N`="Confirm" $G`.Column="1" $G`.Row="2" $H`="24" $MA`="5" $PW`Char="*"></$PW`Box></$G`>'+
            '<$G` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`'+
            '="*"/></$G`.$RD`s><Radio$BU` $N`="Switch" $G`.Row="0" $G`.Column="0" $CO`="Change" $Vx`="Center" $Hx`="Ce'+
            'nter" Visibility="Collapsed"/><$TB` $N`="Port" $G`.Row="0" $G`.Column="1" $Vx`="Center" $Hx`="Center" $W`'+
            '="120" IsEnabled="False" Visibility="Collapsed"> 389</$TB`><$BU` $N`="Ok" $CO`="Ok" $G`.Column="0" $G`.Ro'+
            'w="1" $MA`="5"></$BU`><$BU` $N`="Cancel" $CO`="Cancel" $G`.Column="1" $G`.Row="1" $MA`="5"></$BU`></$G`><'+
            '/$G`></$GB`></$WI`>')

            FEDCPromo            = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://Domain Controller Promotion" $W`'+
            '="800" $H`="800" Topmost="True" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Gra'+
            'phics\icon.ico" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$G`><$G`.$RD`s><$RD` $H`="20"/><$RD` $H'+
            '`="*"/></$G`.$RD`s><$MN` $G`.Row="0" $H`="20"><$MN`Item $HD`="New"><$MN`Item $N`="Forest" $HD`="Install-A'+
            'DDSForest" IsCheckable="True"/><$MN`Item $N`="Tree" $HD`="Install-ADDSDomain Tree" IsCheckable="True"/><$'+
            'MN`Item $N`="Child" $HD`="Install-ADDSDomain Child" IsCheckable="True"/><$MN`Item $N`="Clone" $HD`="Insta'+
            'll-ADDSDomainController" IsCheckable="True"/></$MN`Item></$MN`><$GB` $G`.Row="1" $HD`="[FEDCPromo://Domai'+
            'n Service Configuration ]" $Hx`="Center" $Vx`="Center" $W`="760" $H`="740"><$G`><$G` $G`.Row="1" $MA`="10'+
            '"><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="10*"/></$G`.$RD`s><$G` $G`.Row="0"><$G`.$CD`s><$CD` $W`="*"/><$CD`'+
            ' $W`="*"/></$G`.$CD`s><$GB` $N`="ForestModeBox" $HD`="ForestMode" $G`.Column="0" $MA`="5" Visibility="Col'+
            'lapsed"><$CB` $N`="ForestMode" $H`="24" SelectedIndex="0"><$CB`Item $CO`="$WI`s Server 2000 ( Default )" '+
            'IsSelected="False"/><$CB`Item $CO`="$WI`s Server 2003" IsSelected="False"/><$CB`Item $CO`="$WI`s Server 2'+
            '008" IsSelected="False"/><$CB`Item $CO`="$WI`s Server 2008 R2" IsSelected="False"/><$CB`Item $CO`="$WI`s '+
            'Server 2012" IsSelected="False"/><$CB`Item $CO`="$WI`s Server 2012 R2" IsSelected="False"/><$CB`Item $CO`'+
            '="$WI`s Server 2016" IsSelected="True"/><$CB`Item $CO`="$WI`s Server 2019" IsSelected="False"/></$CB`></$'+
            'GB`><$GB` $N`="DomainModeBox" $HD`="DomainMode" $G`.Column="1" $MA`="5" Visibility="Collapsed"><$CB` $N`='+
            '"DomainMode" $H`="24" SelectedIndex="0"><$CB`Item $CO`="$WI`s Server 2000 ( Default )" IsSelected="False"'+
            '/><$CB`Item $CO`="$WI`s Server 2003" IsSelected="False"/><$CB`Item $CO`="$WI`s Server 2008" IsSelected="F'+
            'alse"/><$CB`Item $CO`="$WI`s Server 2008 R2" IsSelected="False"/><$CB`Item $CO`="$WI`s Server 2012" IsSel'+
            'ected="False"/><$CB`Item $CO`="$WI`s Server 2012 R2" IsSelected="False"/><$CB`Item $CO`="$WI`s Server 201'+
            '6" IsSelected="True"/><$CB`Item $CO`="$WI`s Server 2019" IsSelected="False"/></$CB`></$GB`><$GB` $N`="Par'+
            'entDomain$N`Box" $HD`="Parent Domain $N`" $G`.Column="0" $MA`="5" Visibility="Collapsed"><$TB` $N`="Paren'+
            'tDomain$N`" Text="&lt;Domain $N`&gt;" $H`="20" $MA`="5"/></$GB`></$G`><$G` $G`.Row="1"><$G`.$CD`s><$CD` $'+
            'W`="*"/><$CD` $W`="2.5*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="3.5*"/><$RD` $H`="*"/></$G`.$RD`s><$GB` $HD`='+
            '"Service Options" $G`.Row="0" $G`.Column="0" $MA`="5"><$G` $G`.Row="0" $G`.Column="0"><$G`.$CD`s><$CD` $W'+
            '`="5*"/><$CD` $W`="*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/'+
            '><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/'+
            '><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$'+
            'TBL` $G`.Column="0" $G`.Row="0" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="0"'+
            ' $MA`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="1" $MA`="5" TextAlign'+
            'ment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="1" $MA`="5" $N`="" IsEnabled="True" IsChecked="False'+
            '"/><$TBL` $G`.Column="0" $G`.Row="2" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Ro'+
            'w="2" $MA`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="3" $MA`="5" Text'+
            'Alignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="3" $MA`="5" $N`="" IsEnabled="True" IsChecked="'+
            'False"/><$TBL` $G`.Column="0" $G`.Row="4" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $'+
            'G`.Row="4" $MA`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="5" $MA`="5"'+
            ' TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="5" $MA`="5" $N`="" IsEnabled="True" IsChec'+
            'ked="False"/><$TBL` $G`.Column="0" $G`.Row="6" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column='+
            '"1" $G`.Row="6" $MA`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="7" $MA'+
            '`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="7" $MA`="5" $N`="" IsEnabled="True" I'+
            'sChecked="False"/><$TBL` $G`.Column="0" $G`.Row="8" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Co'+
            'lumn="1" $G`.Row="8" $MA`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="9'+
            '" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="9" $MA`="5" $N`="" IsEnabled="Tr'+
            'ue" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="10" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` '+
            '$G`.Column="1" $G`.Row="10" $MA`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`'+
            '.Row="11" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="11" $MA`="5" $N`="" IsEn'+
            'abled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="12" $MA`="5" TextAlignment="Right">:</$TBL'+
            '`><$CHK` $G`.Column="1" $G`.Row="12" $MA`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Colum'+
            'n="0" $G`.Row="13" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="13" $MA`="5" $N'+
            '`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="14" $MA`="5" TextAlignment="Right'+
            '">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="14" $MA`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` '+
            '$G`.Column="0" $G`.Row="15" $MA`="5" TextAlignment="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="15" $M'+
            'A`="5" $N`="" IsEnabled="True" IsChecked="False"/><$TBL` $G`.Column="0" $G`.Row="16" $MA`="5" TextAlignme'+
            'nt="Right">:</$TBL`><$CHK` $G`.Column="1" $G`.Row="16" $MA`="5" $N`="" IsEnabled="True" IsChecked="False"'+
            '/></$G`></$GB`><$G` $G`.Row="0" $G`.Column="1" $MA`="10 , 0 , 10 , 0"><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`'+
            '="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`'+
            '="*"/><$RD` $H`="*"/></$G`.$RD`s><$GB` $G`.Row="0" $HD`="DatabasePath" $N`="DatabasePathBox" Visibility="'+
            'Visible" $BO`Brush="{x:Null}"><$TB` $H`="20" $MA`="10 , 0 , 10 , 0" $N`="DatabasePath"/></$GB`><$GB` $G`.'+
            'Row="1" $HD`="SysvolPath" $N`="SysvolPathBox" Visibility="Visible" $BO`Brush="{x:Null}"><$TB` $H`="20" $M'+
            'A`="10 , 0 , 10 , 0" $N`="SysvolPath"/></$GB`><$GB` $G`.Row="2" $HD`="LogPath" $N`="LogPathBox" Visibilit'+
            'y="Visible" $BO`Brush="{x:Null}"><$TB` $H`="20" $MA`="10 , 0 , 10 , 0" $N`="LogPath"/></$GB`><$GB` $G`.Ro'+
            'w="3" $HD`="Credential" $N`="CredentialBox" Visibility="Visible" $BO`Brush="{x:Null}"><$G`><$G`.$CD`s><$C'+
            'D` $W`="*"/><$CD` $W`="3*"/></$G`.$CD`s><$BU` $CO`="Credential" $N`="Credential$BU`" $G`.Column="0"/><$TB'+
            '` $H`="20" $MA`="10 , 0 , 10 , 0" $N`="Credential" $G`.Column="1"/></$G`></$GB`><$GB` $G`.Row="4" $HD`="D'+
            'omain$N`" $N`="Domain$N`Box" Visibility="Visible" $BO`Brush="{x:Null}"><$TB` $H`="20" $MA`="10 , 0 , 10 ,'+
            '0" $N`="Domain$N`"/></$GB`><$GB` $G`.Row="5" $HD`="DomainNetBIOS$N`" $N`="DomainNetBIOS$N`Box" Visibility'+
            '="Visible" $BO`Brush="{x:Null}"><$TB` $H`="20" $MA`="10 , 0 , 10 , 0" $N`="DomainNetBIOS$N`"/></$GB`><$GB'+
            '` $G`.Row="6" $HD`="NewDomain$N`" $N`="NewDomain$N`Box" Visibility="Visible" $BO`Brush="{x:Null}"><$TB` $'+
            'H`="20" $MA`="10 , 0 , 10 , 0" $N`="NewDomain$N`"/></$GB`><$GB` $G`.Row="7" $HD`="NewDomainNetBIOS$N`" $N'+
            '`="NewDomainNetBIOS$N`Box" Visibility="Visible" $BO`Brush="{x:Null}"><$TB` $H`="20" $MA`="10 , 0 , 10 , 0'+
            '" $N`="NewDomainNetBIOS$N`"/></$GB`><$GB` $G`.Row="8" $HD`="Site$N`" $N`="Site$N`Box" Visibility="Visible'+
            '" $BO`Brush="{x:Null}"><$TB` $H`="20" $MA`="10 , 0 , 10 , 0" $N`="Site$N`"/></$GB`><$GB` $G`.Row="9" $HD`'+
            '="ReplicationSourceDC" $N`="ReplicationSourceDCBox" Visibility="Visible" $BO`Brush="{x:Null}"><$TB` $H`="'+
            '20" $MA`="10 , 0 , 10 , 0" $N`="ReplicationSourceDC"/></$GB`></$G`><$GB` $G`.Row="1" $HD`="Roles" $MA`="5'+
            '"><$G`><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$G`.$CD`s><$CD'+
            '` $W`="5*"/><$CD` $W`="*"/></$G`.$CD`s><$TBL` $G`.Row="0" TextAlignment="Right" $MA`="5" IsEnabled="True"'+
            '>Install DNS:</$TBL`><$CHK` $N`="InstallDNS" $G`.Row="0" $G`.Column="1" $MA`="5" IsEnabled="True" IsCheck'+
            'ed="False"/><$TBL` $G`.Row="1" TextAlignment="Right" $MA`="5" IsEnabled="True">Create DNS Delegation:</$T'+
            'BL`><$CHK` $N`="CreateDNSDelegation" $G`.Row="1" $G`.Column="1" $MA`="5" IsEnabled="True" IsChecked="Fals'+
            'e"/><$TBL` $G`.Row="2" TextAlignment="Right" $MA`="5" IsEnabled="True">No Global Catalog:</$TBL`><$CHK` $'+
            'N`="NoGlobalCatalog" $G`.Row="2" $G`.Column="1" $MA`="5" IsEnabled="True" IsChecked="False"/><$TBL` $G`.R'+
            'ow="3" TextAlignment="Right" $MA`="5" IsEnabled="True">Critical Replication Only:</$TBL`><$CHK` $N`="Crit'+
            'icalReplicationOnly" $G`.Row="3" $G`.Column="1" $MA`="5" IsEnabled="True" IsChecked="False"/></$G`></$GB`'+
            '><$GB` $G`.Row="1" $G`.Column="1" $HD`="Initialization" $MA`="5"><$G`><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`'+
            '="*"/></$G`.$RD`s><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$GB` $G`.Row="0" $G`.Column="0" $'+
            'HD`="SafeModeAdministrator$PW`"><$PW`Box $N`="SafeModeAdministrator$PW`" $H`="20" $MA`="5" $PW`Char="*"/>'+
            '</$GB`><$GB` $G`.Row="0" $G`.Column="1" $HD`="Confirm"><$PW`Box $N`="Confirm" $H`="20" $MA`="5" $PW`Char='+
            '"*"/></$GB`><$BU` $N`="Start" $G`.Row="1" $G`.Column="0" $CO`="Start" $MA`="5" $W`="100" $H`="20"/><$BU` '+
            '$N`="Cancel" $G`.Row="1" $G`.Column="1" $CO`="Cancel" $MA`="5" $W`="100" $H`="20"/></$G`></$GB`></$G`></$'+
            'G`></$G`></$GB`></$G`></$WI`>')

            FEDCFound            = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://Domain Controller Found" $W`="35'+
            '0" $H`="200" $Hx`="Center" Topmost="True" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\202'+
            '0.12.0\Graphics\icon.ico" $WI`StartupLocation="CenterScreen"><$G`><$G`.$RD`s><$RD` $H`="3*"/><$RD` $H`="*'+
            '"/></$G`.$RD`s><$G` $G`.Row="0"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="2*"/></$G`.$CD`s><$G`.$RD`s><$RD` $H'+
            '`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$TBL` $G`.Column="0" $G`.Row="0" $MA`="10" $Vx`="Center'+
            '" $Hx`="Right"> Controller $N`:</$TBL`><$LA`="DC" $G`.Column="1" $G`.Row="0" $Vx`="Center" $H`="24" $MA`='+
            '"10"/><$TBL` $G`.Column="0" $G`.Row="1" $MA`="10" $Vx`="Center" $Hx`="Right"> DNS $N`:</$TBL`><$LA`="Doma'+
            'in" $G`.Column="1" $G`.Row="1" $Vx`="Center" $H`="24" $MA`="10"/><$TBL` $G`.Column="0" $G`.Row="2" $MA`="'+
            '10" $Vx`="Center" $Hx`="Right"> NetBIOS $N`:</$TBL`><$LA`="NetBIOS" $G`.Column="1" $G`.Row="2" $Vx`="Cent'+
            'er" $H`="24" $MA`="10"/></$G`><$G` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$BU`'+
            '="Ok" $CO`="Ok" $G`.Column="0" $G`.Row="1" $MA`="10"/><$BU`="Cancel" $CO`="Cancel" $G`.Column="1" $G`.Row'+
            '="1" $MA`="10"/></$G`></$G`></$WI`>')

            FERoot               = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://Root Installation" $W`="640" $H`'+
            '="450" Topmost="True" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\icon'+
            '.ico" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$G`><$G`.$BG`><ImageBrush Stretch="UniformToFill"'+
            ' ImageSource=""/></$G`.$BG`><$G`.$RD`s><$RD` $H`="250"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="40"/><$R'+
            'D` $H`="20"/></$G`.$RD`s><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="2*"/><$CD` $W`="2*"/><$CD` $W`="*"/></$G`.$'+
            'CD`s><Image $G`.Row="0" $G`.ColumnSpan="4" $Hx`="Center" $W`="640" $H`="250" Source=""/><$TBL` $G`.Row="1'+
            '" $G`.Column="1" $G`.ColumnSpan="2" $Hx`="Center" $PA`="5" Foreground="#00FF00" FontWeight="Bold" $Vx`="C'+
            'enter"> Hybrid - Desired State Controller - Dependency Installation Path </$TBL`><$TB` $G`.Row="2" $G`.Co'+
            'lumn="1" $G`.ColumnSpan="2" $H`="22" $TW`="Wrap" $MA`="10" Horizontal$CO`Alignment="Center" $N`="Install"'+
            '><$TB`.$EF`><DropShadow$EF`/></$TB`.$EF`></$TB`><$BU` $G`.Row="3" $G`.Column="1" $N`="Start" $CO`="Start"'+
            ' $MA`="10"/><$BU` $G`.Row="3" $G`.Column="2" $N`="Cancel" $CO`="Cancel" $MA`="10"/></$G`></$WI`>')

            FEShare              = ( '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x='+
            '"http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://New Deployment Share" $W`="640" '+
            '$H`="960" Topmost="True" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.12.0\Graphics\i'+
            'con.ico" ResizeMode="NoResize" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$WI`.$RES`><$ST` $TT`="$'+
            'LA`" $XK`="Head$LA`"><$SE` $PR`="$TBL`.TextAlignment" $VA`="Center"/><$SE` $PR`="FontWeight" $VA`="Heavy"'+
            '/><$SE` $PR`="FontSize" $VA`="18"/><$SE` $PR`="$MA`" $VA`="5"/><$SE` $PR`="Foreground" $VA`="White"/><$SE'+
            '` $PR`="Template"><$SE`.$VA`><$CT` $TT`="$LA`"><$BO` CornerRadius="2,2,2,2" $BG`="#FF0080FF" $BO`Brush="B'+
            'lack" $BO`Thickness="3"><$CO`Presenter x:$N`="$CO`Presenter" $CO`Template="{ TemplateBinding $CO`Template'+
            ' }" $MA`="5"/></$BO`></$CT`></$SE`.$VA`></$SE`></$ST`><$ST` $TT`="Radio$BU`" $XK`="Rad$BU`"><$SE` $PR`="$'+
            'Hx`" $VA`="Center"/><$SE` $PR`="$Vx`" $VA`="Center"/><$SE` $PR`="Foreground" $VA`="Black"/></$ST`><$ST` $'+
            'TT`="$TB`" $XK`="TextBro"><$SE` $PR`="Vertical$CO`Alignment" $VA`="Center"/><$SE` $PR`="$MA`" $VA`="2"/><'+
            '$SE` $PR`="$TW`" $VA`="Wrap"/><$SE` $PR`="$H`" $VA`="24"/></$ST`></$WI`.$RES`><$G`><$G`.$RD`s><$RD` $H`="'+
            '250"/><$RD` $H`="*"/><$RD` $H`="40"/></$G`.$RD`s><$G`.$BG`><ImageBrush Stretch="UniformToFill" ImageSourc'+
            'e="/$BG`.jpg"/></$G`.$BG`><Image $G`.Row="0" Source="/banner.png"/><$TC` $G`.Row="1" $BG`="{x:Null}" $BO`'+
            'Brush="{x:Null}" Foreground="{x:Null}" $Hx`="Center"><TabItem $HD`="Stage Deployment Server" $BO`Brush="{'+
            'x:Null}" $W`="280"><TabItem.$EF`><DropShadow$EF`/></TabItem.$EF`><$G`><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`'+
            '="*"/></$G`.$RD`s><$GB` $G`.Row="0" $MA`="10" $PA`="5" Foreground="Black" $BG`="White"><$G` $G`.Row="0"><'+
            '$G`.$RD`s><$RD` $H`="50"/><$RD` $H`="30"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$LA` '+
            '$CO`="Deployment Share Settings" $ST`="{ StaticResource Head$LA` }" Foreground="White" $G`.Row="0"/><$G` '+
            '$G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><Radio$BU` $G`.Column="0" $CO`="Standard'+
            ' @ MDT Share" $N`="Legacy" $ST`="{ StaticResource Rad$BU` }"/><Radio$BU` $G`.Column="1" $CO`="Enhanced @ '+
            'PSD Share" $N`="Remaster" $ST`="{ StaticResource Rad$BU` }"/></$G`><$GB` $G`.Row="2" $HD`="Directory Path'+
            '"><$TB` $ST`="{ StaticResource TextBro }" $N`="Directory"/></$GB`><$GB` $G`.Row="3" $HD`="Samba Share"><$'+
            'TB` $ST`="{ StaticResource TextBro }" $N`="Samba"/></$GB`><$G` $G`.Row="4"><$G`.$CD`s><$CD` $W`="*"/><$CD'+
            '` $W`="2*"/></$G`.$CD`s><$GB` $G`.Column="0" $HD`="PS Drive"><$TB` $ST`="{ StaticResource TextBro }" $N`='+
            '"DSDrive"/></$GB`><$GB` $G`.Column="1" $HD`="Description"><$TB` $ST`="{ StaticResource TextBro }" $N`="De'+
            'scription"/></$GB`></$G`></$G`></$GB`><$GB` $G`.Row="1" $MA`="10" $PA`="5" Foreground="Black" $BG`="White'+
            '"><$G`><$G`.$RD`s><$RD` $H`="50"/><$RD` $H`="30"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`'+
            's><$LA` $CO`="BITS / IIS Settings" $ST`="{ StaticResource Head$LA` }" Foreground="White" $G`.Row="0"/><$G'+
            '` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><Radio$BU` $G`.Column="0" $N`="IIS_Ins'+
            'tall" $CO`="Install BITS/IIS for MDT" $ST`="{ StaticResource Rad$BU` }"/><Radio$BU` $G`.Column="1" $N`="I'+
            'IS_Skip" $CO`="Do not install BITS/IIS for MDT" $ST`="{ StaticResource Rad$BU` }"/></$G`><$GB` $G`.Row="2'+
            '" $HD`="$N`"><$TB` $ST`="{ StaticResource TextBro }" $N`="IIS_$N`"/></$GB`><$GB` $G`.Row="3" $HD`="App Po'+
            'ol"><$TB` $ST`="{ StaticResource TextBro }" $N`="IIS_AppPool"/></$GB`><$GB` $G`.Row="4" $HD`="Virtual Hos'+
            't"><$TB` $ST`="{ StaticResource TextBro }" $N`="IIS_Proxy"/></$GB`></$G`></$GB`></$G`></TabItem><TabItem '+
            '$HD`="Image Info" $Hx`="Center" $W`="280" $BO`Brush="{x:Null}"><TabItem.$EF`><DropShadow$EF`/></TabItem.$'+
            'EF`><$G`><$G`.$RD`s><$RD` $H`="7*"/><$RD` $H`="5*"/></$G`.$RD`s><$GB` $G`.Row="0" $MA`="10" $PA`="5" Fore'+
            'ground="Black" $BG`="White"><$G`><$G`.$RD`s><$RD` $H`="50"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/>'+
            '<$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$LA` $G`.Row="0" $ST`="{ StaticResource Head$LA` }" $CO`="Imag'+
            'e Branding Settings"/><$GB` $G`.Row="1" $HD`="Organization"><$TB` $ST`="{ StaticResource TextBro }" $N`="'+
            'Company"/></$GB`><$GB` $G`.Row="2" $HD`="Support Website"><$TB` $ST`="{ StaticResource TextBro }" $N`="WW'+
            'W"/></$GB`><$G` $G`.Row="3"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$GB` $G`.Column="0" $HD'+
            '`="Support Phone"><$TB` $ST`="{ StaticResource TextBro }" $N`="Phone"/></$GB`><$GB` $G`.Column="1" $HD`="'+
            'Support Hours"><$TB` $ST`="{ StaticResource TextBro }" $N`="Hours"/></$GB`></$G`><$G` $G`.Row="4" $G`.Row'+
            'Span="2"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="100"/></$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/>'+
            '</$G`.$RD`s><$GB` $HD`="Logo [120x120]" $G`.Row="0" $G`.Column="0"><$TB` $ST`="{ StaticResource TextBro }'+
            '" $W`="400" $G`.Column="1" $N`="Logo"/></$GB`><$BU` $MA`="5,15,5,5" $H`="20" $G`.Row="0" $G`.Column="1" $'+
            'CO`="Logo" $N`="LogoBrowse"/><$GB` $HD`="$BG`" $G`.Row="1" $G`.Column="0"><$TB` $ST`="{ StaticResource Te'+
            'xtBro }" $W`="400" $G`.Column="1" $N`="$BG`"/></$GB`><$BU` $MA`="5,15,5,5" $H`="20" $G`.Row="1" $G`.Colum'+
            'n="1" $CO`="$BG`" $N`="$BG`Browse"/></$G`></$G`></$GB`><$GB` $G`.Row="1" $MA`="10" $PA`="5" Foreground="B'+
            'lack" $BG`="White"><$G`><$G`.$RD`s><$RD` $H`="50"/><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD'+
            '`s><$LA` $G`.Row="0" $ST`="{ StaticResource Head$LA` }" $CO`="Domain / Network Credentials"/><$GB` $G`.Ro'+
            'w="1" $HD`="Domain $N`"><$TB` $ST`="{ StaticResource TextBro }" $N`="Branch"/></$GB`><$GB` $G`.Row="2" $H'+
            'D`="NetBIOS Domain"><$TB` $ST`="{ StaticResource TextBro }" $N`="NetBIOS"/></$GB`><$G` $G`.Row="3"><$G`.$'+
            'CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$GB` $G`.Column="0" $HD`="Target/Local Administrator User'+
            '$N`"><$TB` $ST`="{ StaticResource TextBro }" $N`="LMCred_User"/></$GB`><$GB` $G`.Column="1" $HD`="Target/'+
            'Local Administrator $PW`"><$PW`Box $MA`="5" $N`="LMCred_Pass" $PW`Char="*"/></$GB`></$G`></$G`></$GB`></$'+
            'G`></TabItem></$TC`><$G` $G`.Row="2"><$G`.$CD`s><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$BU` $G`.Colum'+
            'n="0" $N`="Start" $CO`="Start" $W`="100" $H`="24"/><$BU` $G`.Column="1" $N`="Cancel" $CO`="Cancel" $W`="1'+
            '00" $H`="24"/></$G`></$G`></$WI`>')

            FEService            = (  '<$WI` xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x'+
            '="http://schemas.microsoft.com/winfx/2006/xaml" $TI`="[FightingEntropy]://ViperBomb Services" $H`="800" $'+
            'W`="800" Topmost="True" $BO`Brush="Black" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\202'+
            '0.12.0\Graphics\icon.ico" ResizeMode="NoResize" $Hx`="Center" $WI`StartupLocation="CenterScreen"><$WI`.$R'+
            'ES`><$ST` $TT`="$LA`"><$SE` $PR`="$Hx`" $VA`="Center"/><$SE` $PR`="$Vx`" $VA`="Center"/><$SE` $PR`="$PA`"'+
            ' $VA`="5"/></$ST`><$ST` $XK`="Separator$ST`1" $TT`="{x:Type Separator}"><$SE` $PR`="SnapsToDevicePixels" '+
            '$VA`="True"/><$SE` $PR`="$MA`" $VA`="0,0,0,0"/><$SE` $PR`="Template"><$SE`.$VA`><$CT` $TT`="{x:Type Separ'+
            'ator}"><$BO` $H`="24" SnapsToDevicePixels="True" $BG`="#FF4D4D4D" $BO`Brush="Azure" $BO`Thickness="1,1,1,'+
            '1" CornerRadius="5,5,5,5"/></$CT`></$SE`.$VA`></$SE`></$ST`><$ST` $TT`="{x:Type ToolTip}"><$SE` $PR`="$BG'+
            '`" $VA`="Black"/><$SE` $PR`="Foreground" $VA`="LightGreen"/></$ST`></$WI`.$RES`><$WI`.$EF`><DropShadow$EF'+
            '`/></$WI`.$EF`><$G`><$G`.$RD`s><$RD` $H`="20"/><$RD` $H`="*"/><$RD` $H`="60"/></$G`.$RD`s><$MN` $G`.Row="'+
            '0" IsMain$MN`="True"><$MN`Item $HD`="Configuration"><$MN`Item $N`="Profile_0" $HD`="0 - $WI`s 10 Home / D'+
            'efault Max"/><$MN`Item $N`="Profile_1" $HD`="1 - $WI`s 10 Home / Default Min"/><$MN`Item $N`="Profile_2" '+
            '$HD`="2 - $WI`s 10 Pro / Default Max"/><$MN`Item $N`="Profile_3" $HD`="3 - $WI`s 10 Pro / Default Min"/><'+
            '$MN`Item $N`="Profile_4" $HD`="4 - Desktop / Default Max"/><$MN`Item $N`="Profile_5" $HD`="5 - Desktop / '+
            'Default Min"/><$MN`Item $N`="Profile_6" $HD`="6 - Desktop / Default Max"/><$MN`Item $N`="Profile_7" $HD`='+
            '"7 - Desktop / Default Min"/><$MN`Item $N`="Profile_8" $HD`="8 - Laptop / Default Max"/><$MN`Item $N`="Pr'+
            'ofile_9" $HD`="9 - Laptop / Default Min"/></$MN`Item><$MN`Item $HD`="Info"><$MN`Item $N`="URL" $HD`="$RES'+
            '`"/><$MN`Item $N`="About" $HD`="About"/><$MN`Item $N`="Copyright" $HD`="Copyright"/><$MN`Item $N`="MadBom'+
            'b" $HD`="MadBomb122"/><$MN`Item $N`="BlackViper" $HD`="BlackViper"/><$MN`Item $N`="Site" $HD`="Company We'+
            'bsite"/><$MN`Item $N`="Help" $HD`="Help"/></$MN`Item></$MN`><$G` $G`.Row="1"><$G`.$CD`s><$CD` $W`="*"/></'+
            '$G`.$CD`s><$TC` $BO`Brush="Gainsboro" $G`.Row="1" $N`="$TC`"><$TC`.$RES`><$ST` $TT`="TabItem"><$SE` $PR`='+
            '"Template"><$SE`.$VA`><$CT` $TT`="TabItem"><$BO` $N`="$BO`" $BO`Thickness="1,1,1,0" $BO`Brush="Gainsboro"'+
            ' CornerRadius="4,4,0,0" $MA`="2,0"><$CO`Presenter x:$N`="$CO`Site" $Vx`="Center" $Hx`="Center" $CO`Source'+
            '="$HD`" $MA`="10,2"/></$BO`><$CT`.$TR`s><$TR` $PR`="IsSelected" $VA`="True"><$SE` Target$N`="$BO`" $PR`="'+
            '$BG`" $VA`="LightSkyBlue"/></$TR`><$TR` $PR`="IsSelected" $VA`="False"><$SE` Target$N`="$BO`" $PR`="$BG`"'+
            ' $VA`="GhostWhite"/></$TR`></$CT`.$TR`s></$CT`></$SE`.$VA`></$SE`></$ST`></$TC`.$RES`><TabItem $HD`="Serv'+
            'ice Dialog"><$G`><$G`.$RD`s><$RD` $H`="60"/><$RD` $H`="32"/><$RD` $H`="*"/></$G`.$RD`s><$G` $G`.Row="0"><'+
            '$G`.$CD`s><$CD` $W`="0.45*"/><$CD` $W`="0.15*"/><$CD` $W`="0.25*"/><$CD` $W`="0.15*"/></$G`.$CD`s><$GB` $'+
            'G`.Column="0" $HD`="Operating System" $MA`="5"><$LA` $N`="Caption"/></$GB`><$GB` $G`.Column="1" $HD`="Rel'+
            'ease ID" $MA`="5"><$LA` $N`="ReleaseID"/></$GB`><$GB` $G`.Column="2" $HD`="Version" $MA`="5"><$LA` $N`="V'+
            'ersion"/></$GB`><$GB` $G`.Column="3" $HD`="Chassis" $MA`="5"><$LA` $N`="Chassis"/></$GB`></$G`><$G` $G`.R'+
            'ow="1"><$G`.$CD`s><$CD` $W`="0.66*"/><$CD` $W`="0.33*"/><$CD` $W`="1*"/></$G`.$CD`s><$TB` $G`.Column="0" '+
            '$MA`="5" $N`="Search" $TW`="Wrap"></$TB`><$CB` $G`.Column="1" $MA`="5" $N`="Select" $Vx`="Center"><$CB`It'+
            'em $CO`="Checked"/><$CB`Item $CO`="Display $N`" IsSelected="True"/><$CB`Item $CO`="$N`"/><$CB`Item $CO`="'+
            'Current Setting"/></$CB`><$TBL` $G`.Column="2" $MA`="5" TextAlignment="Center">Service State: <Run $BG`="'+
            '#66FF66" Text="Compliant"/> / <Run $BG`="#FFFF66" Text="Unspecified"/> / <Run $BG`="#FF6666" Text="Non Co'+
            'mpliant"/></$TBL`></$G`><Data$G` $G`.Row="2" $G`.Column="0" $N`="Data$G`" FrozenColumnCount="2" AutoGener'+
            'ateColumns="False" AlternationCount="2" $HD`sVisibility="Column" CanUserResizeRows="False" CanUserAddRows'+
            '="False" IsTabStop="True" IsTextSearchEnabled="True" SelectionMode="Extended"><Data$G`.Row$ST`><$ST` $TT`'+
            '="{x:Type Data$G`Row}"><$ST`.$TR`s><$TR` $PR`="AlternationIndex" $VA`="0"><$SE` $PR`="$BG`" $VA`="White"/'+
            '></$TR`><$TR` $PR`="AlternationIndex" $VA`="1"><$SE` $PR`="$BG`" $VA`="#FFD8D8D8"/></$TR`><$TR` $PR`="IsM'+
            'ouseOver" $VA`="True"><$SE` $PR`="ToolTip"><$SE`.$VA`><$TBL` Text="{Binding Description}" $TW`="Wrap" $W`'+
            '="400" $BG`="#FFFFFFBF" Foreground="Black"/></$SE`.$VA`></$SE`><$SE` $PR`="ToolTipService.ShowDuration" $'+
            'VA`="360000000"/></$TR`><MultiData$TR`><MultiData$TR`.Conditions><Condition Binding="{Binding Scope}" $VA'+
            '`="True"/><Condition Binding="{Binding Matches}" $VA`="False"/></MultiData$TR`.Conditions><$SE` $PR`="$BG'+
            '`" $VA`="#F08080"/></MultiData$TR`><MultiData$TR`><MultiData$TR`.Conditions><Condition Binding="{Binding '+
            'Scope}" $VA`="False"/><Condition Binding="{Binding Matches}" $VA`="False"/></MultiData$TR`.Conditions><$S'+
            'E` $PR`="$BG`" $VA`="#FFFFFF64"/></MultiData$TR`><MultiData$TR`><MultiData$TR`.Conditions><Condition Bind'+
            'ing="{Binding Scope}" $VA`="True"/><Condition Binding="{Binding Matches}" $VA`="True"/></MultiData$TR`.Co'+
            'nditions><$SE` $PR`="$BG`" $VA`="LightGreen"/></MultiData$TR`></$ST`.$TR`s></$ST`></Data$G`.Row$ST`><Data'+
            '$G`.Columns><Data$G`TextColumn $HD`="Index" $W`="50" Binding="{Binding Index}" CanUserSort="True" IsReadO'+
            'nly="True"/><Data$G`TextColumn $HD`="$N`" $W`="150" Binding="{Binding $N`}" CanUserSort="True" IsReadOnly'+
            '="True"/><Data$G`TextColumn $HD`="Scoped" $W`="75" Binding="{Binding Scope}" CanUserSort="True" IsReadOnl'+
            'y="True"/><Data$G`TextColumn $HD`="Profile" $W`="100" Binding="{Binding Slot}" CanUserSort="True" IsReadO'+
            'nly="True"/><Data$G`TextColumn $HD`="Status" $W`="75" Binding="{Binding Status}" CanUserSort="True" IsRea'+
            'dOnly="True"/><Data$G`TextColumn $HD`="StartType" $W`="75" Binding="{Binding StartMode}" CanUserSort="Tru'+
            'e" IsReadOnly="True"/><Data$G`TextColumn $HD`="Display$N`" $W`="150" Binding="{Binding Display$N`}" CanUs'+
            'erSort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="Path$N`" $W`="150" Binding="{Binding Path$N`}" '+
            'CanUserSort="True" IsReadOnly="True"/><Data$G`TextColumn $HD`="Description" $W`="150" Binding="{Binding D'+
            'escription}" CanUserSort="True" IsReadOnly="True"/></Data$G`.Columns></Data$G`></$G`></TabItem><TabItem $'+
            'HD`="Preferences"><$G`><$G`.$RD`s><$RD` $H`="1.25*"/><$RD` $H`="*"/></$G`.$RD`s><$G` $G`.Row="0"><$G`.$CD'+
            '`s><$CD` $W`="*"/><$CD` $W`="*"/><$CD` $W`="*"/></$G`.$CD`s><$G` $G`.Column="2"><$G`.$RD`s><$RD` $H`="*"/'+
            '><$RD` $H`="*"/></$G`.$RD`s><$GB` $G`.Row="0" $HD`="Bypass / Checks [ Risky Options ]" $MA`="5"><$G`><$G`'+
            '.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$CHK` $G`.Row="1" $MA`="5" $N`="ByBuild"'+
            ' $CO`="Skip Build/Version Check" $Hx`="Center" $Vx`="Center"/><$CB` $G`.Row="0" $Vx`="Center" $H`="24" $N'+
            '`="ByEdition"><$CB`Item $CO`="Override Edition Check" IsSelected="True"/><$CB`Item $CO`="$WI`s 10 Home"/>'+
            '<$CB`Item $CO`="$WI`s 10 Pro"/></$CB`><$CHK` $G`.Row="2" $MA`="5" $N`="ByLaptop" $CO`="Enable Laptop Twea'+
            'ks" $Hx`="Center" $Vx`="Center"/></$G`></$GB`><$GB` $G`.Row="1" $HD`="Display" $MA`="5"><$G` $Hx`="Center'+
            '" $Vx`="Center" ><$G`.$RD`s><$RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/></$G`.$RD`s><$CHK` $G`.Row="0'+
            '" $MA`="5" $N`="DispActive" $CO`="Show Active Services" /><$CHK` $G`.Row="1" $MA`="5" $N`="DispInactive" '+
            '$CO`="Show Inactive Services" /><$CHK` $G`.Row="2" $MA`="5" $N`="DispSkipped" $CO`="Show Skipped Services'+
            '" /></$G`></$GB`></$G`><$G` $G`.Column="0"><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="2*"/></$G`.$RD`s><$GB` $G'+
            '`.Row="0" $HD`="Service Configuration" $MA`="5"><$CB` $G`.Row="1" $N`="ServiceProfile" $H`="24"><$CB`Item'+
            ' $CO`="Black Viper (Sparks v1.0)" IsSelected="True"/><$CB`Item $CO`="DevOPS (MC/SDP v1.0)" IsEnabled="Fal'+
            'se"/></$CB`></$GB`><$GB` $G`.Row="1" $HD`="Miscellaneous" $MA`="5"><$G` $Hx`="Center" $Vx`="Center"><$G`.'+
            '$RD`s><$RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/></$G`.$RD`s><$CHK` $G`.Row="0" $MA`'+
            '="5" $N`="MiscSimulate" $CO`="Simulate Changes [ Dry Run ]" /><$CHK` $G`.Row="1" $MA`="5" $N`="MiscXbox" '+
            '$CO`="Skip All Xbox Services" /><$CHK` $G`.Row="2" $MA`="5" $N`="MiscChange" $CO`="Allow Change of Servic'+
            'e State" /><$CHK` $G`.Row="3" $MA`="5" $N`="MiscStopDisabled" $CO`="Stop Disabled Services" /></$G`></$GB'+
            '`></$G`><$G` $G`.Column="1"><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="2*"/></$G`.$RD`s><$GB` $G`.Row="0" $HD`='+
            '"User Interface" $MA`="5"><$CB` $G`.Row="1" $N`="ScriptProfile" $H`="24"><$CB`Item $CO`="DevOPS (MC/SDP v'+
            '1.0)" IsSelected="True"/><$CB`Item $CO`="MadBomb (MadBomb122 v1.0)" IsEnabled="False"/></$CB`></$GB`><$GB'+
            '` $G`.Row="1" $HD`="Development" $MA`="5"><$G` $Hx`="Center" $Vx`="Center" ><$G`.$RD`s><$RD` $H`="30"/><$'+
            'RD` $H`="30"/><$RD` $H`="30"/><$RD` $H`="30"/></$G`.$RD`s><$CHK` $G`.Row="0" $MA`="5" $N`="DevErrors" $CO'+
            '`="Diagnostic Output [ On Error ]" /><$CHK` $G`.Row="1" $MA`="5" $N`="DevLog" $CO`="Enable Development Lo'+
            'gging" /><$CHK` $G`.Row="2" $MA`="5" $N`="DevConsole" $CO`="Enable Console" /><$CHK` $G`.Row="3" $MA`="5"'+
            ' $N`="DevReport" $CO`="Enable Diagnostic" /></$G`></$GB`></$G`></$G`><$G` $G`.Row="1"><$G`.$RD`s><$RD` $H'+
            '`="*"/><$RD` $H`="*"/></$G`.$RD`s><$GB` $G`.Row="0" $HD`="Logging: Create logs for all changes made via t'+
            'his utility" $MA`="5"><$G`><$G`.$CD`s><$CD` $W`="75"/><$CD` $W`="*"/><$CD` $W`="6*"/></$G`.$CD`s><$G`.$RD'+
            '`s><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$CHK` $G`.Row="0" $G`.Column="0" $MA`="5" $N`="LogSvcSwitch'+
            '" $CO`="Services" FlowDirection="RightToLeft" $Hx`="Center" $Vx`="Center"/><$BU` $G`.Row="0" $G`.Column="'+
            '1" $MA`="5" $N`="LogSvcBrowse" $CO`="Browse"/><$TB` $G`.Row="0" $G`.Column="2" $MA`="5" $N`="LogSvcFile" '+
            'IsEnabled="False" $Hx`="Stretch" $Vx`="Center" /><$CHK` $G`.Row="1" $G`.Column="0" $MA`="5" $N`="LogScrSw'+
            'itch" $CO`="Script" FlowDirection="RightToLeft" $Vx`="Center" $Hx`="Center" /><$BU` $G`.Row="1" $G`.Colum'+
            'n="1" $MA`="5" $N`="LogScrBrowse" $CO`="Browse"/><$TB` $G`.Row="1" $G`.Column="2" $MA`="5" $N`="LogScrFil'+
            'e" IsEnabled="False" $Hx`="Stretch" $Vx`="Center" /></$G`></$GB`><$GB` $G`.Row="1" $HD`="Backup: Save you'+
            'r current Service Configuration" $MA`="5"><$G`><$G`.$CD`s><$CD` $W`="75"/><$CD` $W`="*"/><$CD` $W`="6*"/>'+
            '</$G`.$CD`s><$G`.$RD`s><$RD` $H`="*"/><$RD` $H`="*"/></$G`.$RD`s><$CHK` $G`.Row="0" $G`.Column="0" $MA`="'+
            '5" $N`="RegSwitch" $CO`="reg.*" FlowDirection="RightToLeft" $Hx`="Center" $Vx`="Center"/><$BU` $G`.Row="0'+
            '" $G`.Column="1" $MA`="5" $N`="RegBrowse" $CO`="Browse"/><$TB` $G`.Row="0" $G`.Column="2" $MA`="5" $N`="R'+
            'egFile" IsEnabled="False" $Hx`="Stretch" $Vx`="Center" /><$CHK` $G`.Row="1" $G`.Column="0" $MA`="5" $N`="'+
            'CsvSwitch" $CO`="csv.*" FlowDirection="RightToLeft" $Hx`="Center" $Vx`="Center" /><$BU` $G`.Row="1" $G`.C'+
            'olumn="1" $MA`="5" $N`="CsvBrowse" $CO`="Browse"/><$TB` $G`.Row="1" $G`.Column="2" $MA`="5" $N`="CsvFile"'+
            ' IsEnabled="False" $Vx`="Center" /></$G`></$GB`></$G`></$G`></TabItem><TabItem $HD`="Console"><$G` $BG`="'+
            '#FFE5E5E5"><ScrollViewer VerticalScrollBarVisibility="Visible"><$TBL` $N`="ConsoleOutput" TextTrimming="C'+
            'haracterEllipsis" $BG`="White" FontFamily="Lucida Console"/></ScrollViewer></$G`></TabItem><TabItem $HD`='+
            '"Diagnostics"><$G` $BG`="#FFE5E5E5"><ScrollViewer VerticalScrollBarVisibility="Visible"><$TBL` $N`="Diagn'+
            'osticOutput" TextTrimming="CharacterEllipsis" $BG`="White" FontFamily="Lucida Console"/></ScrollViewer></'+
            '$G`></TabItem></$TC`></$G`><$G` $G`.Row="2"><$G`.$CD`s><$CD` $W`="2*"/><$CD` $W`="*"/><$CD` $W`="*"/><$CD'+
            '` $W`="2*"/></$G`.$CD`s><$GB` $G`.Column="0" $HD`="Service Configuration" $MA`="5"><$LA` $N`="Service$LA`'+
            '"/></$GB`><$BU` $G`.Column="1" $N`="Start" $CO`="Start" FontWeight="Bold" $MA`="10"/><$BU` $G`.Column="2"'+
            ' $N`="Cancel" $CO`="Cancel" FontWeight="Bold" $MA`="10"/><$GB` $G`.Column="3" $HD`="Module Version" $MA`='+
            '"5"><$LA` $N`="Script$LA`" /></$GB`></$G`></$G`></$WI`>')
        }

        [Object]     $Slot
        [Object]     $Swap
        [String[]]  $Stage
        [Object]   $Output

        SetStage()
        {
            ForEach ( $I in 0..( $This.Glossary.Count - 1 ) )
            {
                $Item             = $This.Glossary[$I]
                $This.Swap        = $This.Swap -Replace $Item.Name, ('{0}`' -f $Item.Variable )
            }

            $This.Stage           = $This.Swap -Split "`n" -Replace "'",'"' -join ''
        }

        _XamlObject([String]$Type)
        {
            If ( $Type -notin $This.Names )
            {
                Throw "Invalid Type"
            }

            ForEach ( $I in 0..( $This.Glossary.Count - 1 ) )
            {
                $Item             = $This.Glossary[$I]
                Invoke-Expression ( "$($Item.Variable) = '$($Item.Name)'" )
            }

            $This.Slot            = "$($This.Xaml[$Type])"
            $This.Swap            = $This.Slot -Replace "(\s+)"," " -Replace "(>\s*<)",">`n<" -Replace "(' />)","'/>" -Replace "(' >)","'>" -Replace "(\s*=\s*)","="
            $This.Stage           = $This.Swap -Split "`n" -Replace "'",'"' -join ''
            $This.Output          = @( )

            If ( $This.Stage.ToCharArray().Length -le 80 )
            {
                $This.Output     += "{0}'{1}'" -f (" "*25),$This.Stage
            }

            Else
            {
                $This.Output     += "{0}'{1}'" -f (" "*25),$This.Stage.Substring(0,80)
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

                    $Return[$X] += $Item[$I]
                }
                    
                ForEach ( $X in 0..($Return.Count - 1 ) )
                {
                    $This.Output += ( "            '$( $Return[$X] -join '')'+" )
                }
            }

            $This.Output[0] += "+"
            $This.Output[-1] = $This.Output[-1] -Replace "(\>\'\+)",">'"
        }
    }

    [_XamlObject]::New($Type)
    # Certificate
    # ADLogin
    # NewAccount
    # FEDCPromo
    # FEDCFound
    # FERoot
    # FEShare
    # FEService
}
