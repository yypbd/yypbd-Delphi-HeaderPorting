unit FirewallExampleMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NetFwTypeLib_TLB;

// reference
// http://msdn.microsoft.com/en-us/library/windows/desktop/aa366459(v=vs.85).aspx

// c++
// http://msdn.microsoft.com/en-us/library/windows/desktop/ff956128(v=vs.85).aspx

// vbs
// http://msdn.microsoft.com/en-us/library/windows/desktop/ff956129(v=vs.85).aspx

const
  NET_FW_IP_PROTOCOL_ICMPv4 = 1;
  NET_FW_IP_PROTOCOL_ICMPv6 = 58;

type
  TFormFirewallExampleMain = class(TForm)
    Button1: TButton;
    MemoLog: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
  private
    { Private declarations }
    procedure PrintRuleToMemo( const ARule: INetFwRule );
  public
    { Public declarations }
  end;

var
  FormFirewallExampleMain: TFormFirewallExampleMain;

implementation

uses
  ComObj, ActiveX;

{$R *.dfm}

procedure TFormFirewallExampleMain.Button10Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
//  CurrentProfiles: Integer;
//  InterfaceArray: Variant;
begin
  MemoLog.Clear;

  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    {
    CurrentProfiles := FwPolicy2.CurrentProfileTypes;

    InterfaceArray := VarArrayCreate( [0, 0], varVariant );
    InterfaceArray[0] := 'Local Area Connection';
//    InterfaceArray[0] := '로컬 영역 연결';

    if (CurrentProfiles and NET_FW_PROFILE2_DOMAIN) <> 0 then
      FwPolicy2.ExcludedInterfaces[NET_FW_PROFILE2_DOMAIN] := InterfaceArray;

    if (CurrentProfiles and NET_FW_PROFILE2_PRIVATE) <> 0 then
      FwPolicy2.ExcludedInterfaces[NET_FW_PROFILE2_PRIVATE] := InterfaceArray;

    if (CurrentProfiles and NET_FW_PROFILE2_PUBLIC) <> 0 then
      FwPolicy2.ExcludedInterfaces[NET_FW_PROFILE2_PUBLIC] := InterfaceArray;
    }
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button11Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
begin
  MemoLog.Clear;

  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    fwPolicy2.EnableRuleGroup( fwPolicy2.CurrentProfileTypes, 'File and Printer Sharing', True );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button12Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  CurrentProfiles: Integer;
  Rule: INetFwRule;
  Enumerator: IInterface;
  hr: HRESULT;
  pVariant: IEnumVARIANT;
  pVar: OleVariant;
  cFetched: DWORD;
begin
  MemoLog.Clear;

  MemoLog.Lines.BeginUpdate;
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));

    CurrentProfiles := fwPolicy2.CurrentProfileTypes;

    if CurrentProfiles and NET_FW_PROFILE2_DOMAIN <> 0 then
      MemoLog.Lines.Add( 'Domain Firewall Profile is active' );
    if CurrentProfiles and NET_FW_PROFILE2_PRIVATE <> 0 then
      MemoLog.Lines.Add( 'Private Firewall Profile is active' );
    if CurrentProfiles and NET_FW_PROFILE2_PUBLIC <> 0 then
      MemoLog.Lines.Add( 'Public Firewall Profile is active' );

    MemoLog.Lines.Add( '' );
    MemoLog.Lines.Add( '' );

    MemoLog.Lines.Add( 'Rules Count = ' + IntToStr(FwPolicy2.Rules.Count) );
    MemoLog.Lines.Add( '' );

    Enumerator := fwPolicy2.Rules._NewEnum;
//    Enumerator.QueryInterface( __uuidof(IEnumVARIANT), Variant );
    hr := Enumerator.QueryInterface( StringToGUID('{00020404-0000-0000-C000-000000000046}'), pVariant );

    while Succeeded(hr) and (hr <> S_FALSE) do
    begin
      hr := pVariant.Next( 1, pVar, cFetched );

      if hr = S_OK then
      begin
        hr := IInterface(pVar).QueryInterface( StringToGUID('{AF230D27-BABA-4E42-ACED-F524F22CFCE2}'), Rule );

        if SUCCEEDED( hr ) then
        begin
          // 전체를 출력할 것인지... 부분만 출력할것인지
          if Rule.Profiles and FwPolicy2.CurrentProfileTypes <> 0 then
          // 그룹 맞는것 출력
          // if ARule.Grouping = '@firewallapi.dll,-23255' then
            PrintRuleToMemo( Rule );
        end;
      end;
    end;
  finally
    CoUninitialize;
    MemoLog.Lines.EndUpdate;
  end;
end;

procedure TFormFirewallExampleMain.Button13Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewInboundRule, NewOutboundRule: INetFwRule;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));

    // Very Very Very Danger~~!!!!
    // fwPolicy2.ServiceRestriction.RestrictService( 'TermService', '%systemDrive%\WINDOWS\system32\svchost.exe', TRUE, FALSE );
    // fwPolicy2.ServiceRestriction.RestrictService( 'TermService', '%systemDrive%\WINDOWS\system32\svchost.exe', FALSE, FALSE );

    NewInboundRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));
    NewInboundRule.Name := 'Allow only TCP 3389 inbound to service';
    NewInboundRule.ApplicationName := '%systemDrive%\WINDOWS\system32\svchost.exe';
    NewInboundRule.ServiceName := 'TermService';
    NewInboundRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewInboundRule.LocalPorts := '3389';
    NewInboundRule.Action := NET_FW_ACTION_ALLOW;
    NewInboundRule.Direction := NET_FW_RULE_DIR_IN;
    NewInboundRule.Enabled := True;
    fwPolicy2.Rules.Add( NewInboundRule );

    NewOutboundRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));
    NewOutboundRule.Name := 'Allow outbound traffic from service only from TCP 3389';
    NewOutboundRule.ApplicationName := '%systemDrive%\WINDOWS\system32\svchost.exe';
    NewOutboundRule.ServiceName := 'TermService';
    NewOutboundRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewOutboundRule.LocalPorts := '3389';
    NewOutboundRule.Action := NET_FW_ACTION_ALLOW;
    NewOutboundRule.Direction := NET_FW_RULE_DIR_OUT;
    NewOutboundRule.Enabled := True;
    FwPolicy2.Rules.Add( NewOutboundRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button14Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  CurrentProfiles: Integer;
begin
  MemoLog.Clear;

  MemoLog.Lines.BeginUpdate;
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));

    CurrentProfiles := fwPolicy2.CurrentProfileTypes;

    if CurrentProfiles and NET_FW_PROFILE2_DOMAIN <> 0 then
      if FwPolicy2.FirewallEnabled[NET_FW_PROFILE2_DOMAIN] then
        MemoLog.Lines.Add( 'Firewall is ON on domain profile.' )
      else
        MemoLog.Lines.Add( 'Firewall is OFF on domain profile.' );

    if CurrentProfiles and NET_FW_PROFILE2_PRIVATE <> 0 then
      if FwPolicy2.FirewallEnabled[NET_FW_PROFILE2_PRIVATE] then
        MemoLog.Lines.Add( 'Firewall is ON on private profile.' )
      else
        MemoLog.Lines.Add( 'Firewall is OFF on private profile.' );

    if CurrentProfiles and NET_FW_PROFILE2_PUBLIC <> 0 then
      if FwPolicy2.FirewallEnabled[NET_FW_PROFILE2_PUBLIC] then
        MemoLog.Lines.Add( 'Firewall is ON on public profile.' )
      else
        MemoLog.Lines.Add( 'Firewall is OFF on public profile.' );
  finally
    CoUninitialize;
    MemoLog.Lines.EndUpdate;
  end;
end;

procedure TFormFirewallExampleMain.Button15Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  CurrentProfiles: Integer;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));

    CurrentProfiles := fwPolicy2.CurrentProfileTypes;

    if CurrentProfiles and NET_FW_PROFILE2_DOMAIN <> 0 then
      fwPolicy2.FirewallEnabled[NET_FW_PROFILE2_DOMAIN] := False;
    if CurrentProfiles and NET_FW_PROFILE2_PRIVATE <> 0 then
      fwPolicy2.FirewallEnabled[NET_FW_PROFILE2_PRIVATE] := False;
    if CurrentProfiles and NET_FW_PROFILE2_PUBLIC <> 0 then
      fwPolicy2.FirewallEnabled[NET_FW_PROFILE2_PUBLIC] := False;
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button1Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewRule: INetFwRule;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    NewRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));

    NewRule.Name := 'Per_InterfaceType_Rule';
    NewRule.Description := 'Allow incoming network traffic over port 2400 coming from LAN interfcace type';
    NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewRule.LocalPorts := '2300';
    NewRule.Interfacetypes := 'LAN';
    NewRule.Enabled := TRUE;
    NewRule.Grouping := '@firewallapi.dll,-23255';
    NewRule.Profiles := FwPolicy2.CurrentProfileTypes;
    NewRule.Action := NET_FW_ACTION_ALLOW;

    FwPolicy2.Rules.Add( NewRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button2Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewRule: INetFwRule;
  InterfaceArray: Variant;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    NewRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));

    InterfaceArray := VarArrayCreate( [0, 0], varVariant );
    InterfaceArray[0] := 'Local Area Connection';
//    InterfaceArray[0] := '로컬 영역 연결';

    NewRule.Name := 'Per_Interface_Rule';
    NewRule.Description := 'Add a Per Interface Rule';
    NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewRule.LocalPorts := '2300';
    NewRule.Enabled := TRUE;
    NewRule.Grouping := '@firewallapi.dll,-23255';
    NewRule.Profiles := FwPolicy2.CurrentProfileTypes;
    NewRule.Interfaces := InterfaceArray;
    NewRule.Action := NET_FW_ACTION_ALLOW;

    FwPolicy2.Rules.Add( NewRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button3Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewRule: INetFwRule;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    NewRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));

    NewRule.Name := 'GRE_RULE';
    NewRule.Description := 'Allow GRE Traffic';
    NewRule.Protocol := 47;
    NewRule.Enabled := TRUE;
    NewRule.Grouping := '@firewallapi.dll,-23255';
    NewRule.Profiles := FwPolicy2.CurrentProfileTypes;
    NewRule.Action := NET_FW_ACTION_ALLOW;

    FwPolicy2.Rules.Add( NewRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button4Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewRule: INetFwRule;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    NewRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));

    NewRule.Name := 'My Application Name with Edge Traversal';
    NewRule.Description := 'Allow my application network traffic with Edge Traversal';
    NewRule.Applicationname := '%systemDrive%\Program Files\MyApplication.exe';
    NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewRule.LocalPorts := '5000';
    NewRule.Enabled := TRUE;
    NewRule.Grouping := '@firewallapi.dll,-23255';
    NewRule.Profiles := FwPolicy2.CurrentProfileTypes;
    NewRule.Action := NET_FW_ACTION_ALLOW;
    NewRule.EdgeTraversal := TRUE;

    FwPolicy2.Rules.Add( NewRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button5Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewRule: INetFwRule;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    NewRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));

    NewRule.Name := 'Service_Rule';
    NewRule.Description := 'Allow incoming network traffic to myservice';
    NewRule.Applicationname := '%SystemDrive%\Windows\system32\myservice.exe';
    NewRule.Servicename := 'myservicename';
    NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewRule.LocalPorts := '135';
    NewRule.Grouping := '@firewallapi.dll,-23255';
    NewRule.Profiles := FwPolicy2.CurrentProfileTypes;
    NewRule.Enabled := TRUE;
    NewRule.Action := NET_FW_ACTION_ALLOW;

    FwPolicy2.Rules.Add( NewRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button6Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewRule: INetFwRule;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    NewRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));

    NewRule.Name := 'ICMP_Rule';
    NewRule.Description := 'Allow ICMP network traffic';
    NewRule.Protocol := NET_FW_IP_PROTOCOL_ICMPv4;
    NewRule.IcmpTypesAndCodes := '1:1';
    NewRule.Enabled := TRUE;
    NewRule.Grouping := '@firewallapi.dll,-23255';
    NewRule.Profiles := FwPolicy2.CurrentProfileTypes;
    NewRule.Action := NET_FW_ACTION_ALLOW;

    FwPolicy2.Rules.Add( NewRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button7Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewRule: INetFwRule;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    NewRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));

    NewRule.Name := 'My Application Name';
    NewRule.Description := 'Allow my application network traffic';
    NewRule.Applicationname := '%systemDrive%\Program Files\MyApplication.exe';
    NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewRule.LocalPorts := '4000';
    NewRule.Enabled := TRUE;
    NewRule.Grouping := '@firewallapi.dll,-23255';
    NewRule.Profiles := FwPolicy2.CurrentProfileTypes;
    NewRule.Action := NET_FW_ACTION_ALLOW;

    FwPolicy2.Rules.Add( NewRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button8Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
  NewRule: INetFwRule;
begin
  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
    NewRule := INetFwRule(CreateOleObject( 'HNetCfg.FWRule' ));

    NewRule.Name := 'Outbound_Rule';
    NewRule.Description := 'Allow outbound network traffic from my Application over TCP port 4000';
    NewRule.Applicationname := '%systemDrive%\Program Files\MyApplication.exe';
    NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewRule.LocalPorts := '4000';
    NewRule.Direction := NET_FW_RULE_DIR_OUT;
    NewRule.Enabled := TRUE;
    NewRule.Grouping := '@firewallapi.dll,-23255';
    NewRule.Profiles := FwPolicy2.CurrentProfileTypes;
    NewRule.Action := NET_FW_ACTION_ALLOW;

    FwPolicy2.Rules.Add( NewRule );
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.Button9Click(Sender: TObject);
var
  FwPolicy2: INetFwPolicy2;
begin
  MemoLog.Clear;

  CoInitialize( nil );
  try
    FwPolicy2 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));

    if FwPolicy2.IsRuleGroupCurrentlyEnabled[ 'File and Printer Sharing' ] then
      MemoLog.Lines.Add( 'File and Printer Sharing is currently enabled on at least one of the current profiles' )
    else
      MemoLog.Lines.Add( 'File and Printer Sharing is currently not enabled on any of the current profiles' );

    MemoLog.Lines.Add( '' );
    MemoLog.Lines.Add( '' );

    case fwPolicy2.LocalPolicyModifyState of
      NET_FW_MODIFY_STATE_OK: MemoLog.Lines.Add( 'Changing or adding a firewall rule (or group) will take effect on at least one of the current profiles.' );
      NET_FW_MODIFY_STATE_GP_OVERRIDE: MemoLog.Lines.Add( 'Changing or adding a firewall rule (or group) to the current profiles will not take effect because group policy overrides it on at least one of the current profiles.' );
      NET_FW_MODIFY_STATE_INBOUND_BLOCKED: MemoLog.Lines.Add( 'Changing or adding an inbound firewall rule (or group) to the current profiles will not take effect because inbound rules are not allowed on at least one of the current profiles.' );
      else
        MemoLog.Lines.Add( 'Invalid Modify State returned by LocalPolicyModifyState.' );
    end;
  finally
    CoUninitialize;
  end;
end;

procedure TFormFirewallExampleMain.PrintRuleToMemo(const ARule: INetFwRule);
var
  InterfaceArray: Variant;
  I: Integer;
begin
  MemoLog.Lines.Add('  Rule Name:          ' + ARule.Name);
  MemoLog.Lines.Add('   ----------------------------------------------');
  MemoLog.Lines.Add('  Description:        ' + ARule.Description);
  MemoLog.Lines.Add('  Application Name:   ' + ARule.ApplicationName);
  MemoLog.Lines.Add('  Service Name:       ' + ARule.ServiceName);
  case ARule.Protocol of
    NET_FW_IP_PROTOCOL_TCP:    MemoLog.Lines.Add('  IP Protocol:        TCP.');
    NET_FW_IP_PROTOCOL_UDP:    MemoLog.Lines.Add('  IP Protocol:        UDP.');
    NET_FW_IP_PROTOCOL_ICMPv4: MemoLog.Lines.Add('  IP Protocol:        UDP.');
    NET_FW_IP_PROTOCOL_ICMPv6: MemoLog.Lines.Add('  IP Protocol:        UDP.');
    else                      MemoLog.Lines.Add('  IP Protocol:        ' + IntToStr(ARule.Protocol));
  end;

  if (ARule.Protocol = NET_FW_IP_PROTOCOL_TCP) or (ARule.Protocol = NET_FW_IP_PROTOCOL_UDP) then
  begin
      MemoLog.Lines.Add('  Local Ports:        ' + ARule.LocalPorts);
      MemoLog.Lines.Add('  Remote Ports:       ' + ARule.RemotePorts);
      MemoLog.Lines.Add('  LocalAddresses:     ' + ARule.LocalAddresses);
      MemoLog.Lines.Add('  RemoteAddresses:    ' + ARule.RemoteAddresses);
  end;

  if (ARule.Protocol = NET_FW_IP_PROTOCOL_ICMPv4) or (ARule.Protocol = NET_FW_IP_PROTOCOL_ICMPv6) then
    MemoLog.Lines.Add('  ICMP Type and Code:    ' + ARule.IcmpTypesAndCodes);

  case ARule.Direction of
    NET_FW_RULE_DIR_IN:  MemoLog.Lines.Add('  Direction:          In');
    NET_FW_RULE_DIR_OUT: MemoLog.Lines.Add('  Direction:          Out');
  end;

  MemoLog.Lines.Add('  Enabled:            ' + BoolToStr(ARule.Enabled, True));
  MemoLog.Lines.Add('  Edge:               ' + BoolToStr(ARule.EdgeTraversal, True));
  case ARule.Action of
    NET_FW_ACTION_ALLOW:  MemoLog.Lines.Add('  Action:             Allow');
    NET_FW_ACTION_BLOCk:  MemoLog.Lines.Add('  Action:             Block');
  end;
  MemoLog.Lines.Add('  Grouping:           ' + ARule.Grouping);
  MemoLog.Lines.Add('  Interface Types:    ' + ARule.InterfaceTypes);

  InterfaceArray := ARule.Interfaces;
  if VarIsEmpty(InterfaceArray) then
    MemoLog.Lines.Add('  Interfaces:         All')
  else
  begin
    { TODO : Interfaces 출력 }
    for I := VarArrayLowBound(InterfaceArray, 0) to VarArrayHighBound(InterfaceArray, 0) do
    begin
      MemoLog.Lines.Add('       ' + InterfaceArray[i]);
    end;

    {
    LowerBound = LBound(InterfaceArray);
    UpperBound = UBound(InterfaceArray);
    MemoLog.Lines.Add('  Interfaces:     ');
    for iterate = LowerBound To UpperBound
        MemoLog.Lines.Add('       ' + InterfaceArray(iterate););
    Next
    }
  end;

  MemoLog.Lines.Add('');
end;

end.
