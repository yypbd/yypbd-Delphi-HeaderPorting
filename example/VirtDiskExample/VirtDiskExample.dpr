program VirtDiskExample;

uses
  Vcl.Forms,
  VirtDiskExampleMainForm in 'VirtDiskExampleMainForm.pas' {FormVirtDiskExampleMain},
  VirtDisk in '..\..\lib\VirtDisk.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'VirtDisk Example';
  Application.CreateForm(TFormVirtDiskExampleMain, FormVirtDiskExampleMain);
  Application.Run;
end.
