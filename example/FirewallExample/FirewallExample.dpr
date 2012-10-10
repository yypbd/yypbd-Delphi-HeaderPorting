program FirewallExample;

uses
  Vcl.Forms,
  FirewallExampleMainForm in 'FirewallExampleMainForm.pas' {FormFirewallExampleMain},
  NetFwTypeLib_TLB in '..\..\lib\NetFwTypeLib_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormFirewallExampleMain, FormFirewallExampleMain);
  Application.Run;
end.
