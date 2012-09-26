unit VirtDiskExampleMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

const
  PHYS_PATH_LEN = 1024+1;

type
  TFormVirtDiskExampleMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function CreateVHD( const AFilePath: string; const ASize: ULONG ): Boolean;
    function AttachVHD( const AFilePath: string ): Boolean;
    function DetachVHD( const AFilePath: string ): Boolean;
    function CompactVHD( const AFilePath: string ): Boolean;
    function ExpandVHD( const AFilePath: string; const ANewSize: ULONG ): Boolean;
    function MergeVHD( const AFilePath: string ): Boolean;
    function GetVHDInfo( const AFilePath: string ): Boolean;
    function SetVHDInfo( const AFilePath: string ): Boolean;
    function GetPhysVHD( const AFilePath: string ): Boolean;
  public
    { Public declarations }
  end;

var
  FormVirtDiskExampleMain: TFormVirtDiskExampleMain;

implementation

uses
  VirtDisk;

{$R *.dfm}

function TFormVirtDiskExampleMain.AttachVHD(const AFilePath: string): Boolean;
var
  oparams: TOpenVirtualDiskParameters;
  iparams: TAttachVirtualDiskParameters;
  vst: TVirtualStorageType;
  Ret: DWORD;
  hVhd: THandle;
begin
  hVhd := INVALID_HANDLE_VALUE;

  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  oparams.Version := OPEN_VIRTUAL_DISK_VERSION_1;
  oparams.Version1.RWDepth := OPEN_VIRTUAL_DISK_RW_DEPTH_DEFAULT;

  iparams.Version := ATTACH_VIRTUAL_DISK_VERSION_1;

  Ret := OpenVirtualDisk(@vst,
    PWideChar(AFilePath),
    TVIRTUAL_DISK_ACCESS_MASK(DWORD(VIRTUAL_DISK_ACCESS_ATTACH_RW) or DWORD(VIRTUAL_DISK_ACCESS_GET_INFO) or DWORD(VIRTUAL_DISK_ACCESS_DETACH)),
    OPEN_VIRTUAL_DISK_FLAG_NONE,
    @oparams,
    hVhd);

  if Ret = ERROR_SUCCESS then
  begin
    Ret := AttachVirtualDisk( hVhd,
      nil,
      ATTACH_VIRTUAL_DISK_FLAG_PERMANENT_LIFETIME,
      0,
      @iparams,
      nil );
  end;

  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

procedure TFormVirtDiskExampleMain.Button1Click(Sender: TObject);
begin
  CreateVHD( 'c:\aaa.vhd', 256 );
end;

procedure TFormVirtDiskExampleMain.Button2Click(Sender: TObject);
begin
  AttachVHD( 'c:\aaa.vhd' );
end;

procedure TFormVirtDiskExampleMain.Button3Click(Sender: TObject);
begin
  DetachVHD( 'c:\aaa.vhd' );
end;

procedure TFormVirtDiskExampleMain.Button4Click(Sender: TObject);
begin
  CompactVHD( 'c:\aaa.vhd' )
end;

procedure TFormVirtDiskExampleMain.Button5Click(Sender: TObject);
begin
  ExpandVHD( 'c:\aaa.vhd', 512 );
end;

procedure TFormVirtDiskExampleMain.Button6Click(Sender: TObject);
begin
  MergeVHD( 'c:\aaa.vhd' )
end;

procedure TFormVirtDiskExampleMain.Button7Click(Sender: TObject);
begin
  GetVHDInfo( 'c:\aaa.vhd' );
end;

procedure TFormVirtDiskExampleMain.Button8Click(Sender: TObject);
begin
  SetVHDInfo( 'c:\aaa.vhd' );
end;

procedure TFormVirtDiskExampleMain.Button9Click(Sender: TObject);
begin
  GetPhysVHD( 'c:\aaa.vhd' );
end;

function TFormVirtDiskExampleMain.CompactVHD(const AFilePath: string): Boolean;
var
  Ret: DWORD;
  hVhd: THandle;
  oparams: TOpenVirtualDiskParameters;
  parameters: TCompactVirtualDiskParameters;
  vst: TVirtualStorageType;
begin
  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  oparams.Version := OPEN_VIRTUAL_DISK_VERSION_1;
  oparams.Version1.RWDepth := OPEN_VIRTUAL_DISK_RW_DEPTH_DEFAULT;

  Ret := OpenVirtualDisk(@vst,
    PWideChar(AFilePath),
    VIRTUAL_DISK_ACCESS_METAOPS,
    OPEN_VIRTUAL_DISK_FLAG_NONE,
    @oparams,
    hVhd);

  if Ret = ERROR_SUCCESS then
  begin
    { TODO : Need test }
    parameters.Version := COMPACT_VIRTUAL_DISK_VERSION_1;
    parameters.Version1.Reserved := 0;

    Ret := CompactVirtualDisk( hVhd,
      COMPACT_VIRTUAL_DISK_FLAG_NONE,
      @parameters,
      nil );
  end;

  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

function TFormVirtDiskExampleMain.CreateVHD(const AFilePath: string; const ASize: ULONG): Boolean;
var
  params: TCreateVirtualDiskParameters;
  mask: TVIRTUAL_DISK_ACCESS_MASK;
  vst: TVirtualStorageType;
  Ret: DWORD;
  hvhd: THandle;
begin
  hVhd := INVALID_HANDLE_VALUE;

  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  params.Version:= CREATE_VIRTUAL_DISK_VERSION_1;
  params.Version1.UniqueId := TGUID.Empty;
  params.Version1.BlockSizeInBytes := 0;
  params.Version1.MaximumSize:= ASize * 1024 * 1024;
  params.Version1.ParentPath	:= nil;
  params.Version1.SourcePath := nil;
  params.Version1.BlockSizeInBytes := CREATE_VIRTUAL_DISK_PARAMETERS_DEFAULT_BLOCK_SIZE;
  params.Version1.SectorSizeInBytes := CREATE_VIRTUAL_DISK_PARAMETERS_DEFAULT_SECTOR_SIZE;
  mask := VIRTUAL_DISK_ACCESS_CREATE;

  Ret := CreateVirtualDisk(
    @vst,
    PChar(AFilePath),
    mask,
    nil,
    CREATE_VIRTUAL_DISK_FLAG_FULL_PHYSICAL_ALLOCATION,
    0,
    @params,
    nil,
    hvhd);
  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

function TFormVirtDiskExampleMain.DetachVHD(const AFilePath: string): Boolean;
var
  oparams: TOpenVirtualDiskParameters;
  vst: TVirtualStorageType;
  Ret: DWORD;
  hVhd: THandle;
  Flags: TDETACH_VIRTUAL_DISK_FLAG;
begin
  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  oparams.Version := OPEN_VIRTUAL_DISK_VERSION_1;
  oparams.Version1.RWDepth := OPEN_VIRTUAL_DISK_RW_DEPTH_DEFAULT;

  Ret := OpenVirtualDisk(@vst,
    PWideChar(AFilePath),
    VIRTUAL_DISK_ACCESS_DETACH,
    OPEN_VIRTUAL_DISK_FLAG_NONE,
    nil,
    hVhd);

  if Ret = ERROR_SUCCESS then
  begin
    Flags := DETACH_VIRTUAL_DISK_FLAG_NONE;
    Ret := DetachVirtualDisk(hVhd, Flags, 0);
  end;

  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

function TFormVirtDiskExampleMain.ExpandVHD(const AFilePath: string;
  const ANewSize: ULONG): Boolean;
var
  Ret: DWORD;
  hVhd: THandle;
  xparams: TExpandVirtualDiskParameters;
  vst: TVirtualStorageType;
begin
  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  Ret := OpenVirtualDisk(@vst,
    PWideChar(AFilePath),
    VIRTUAL_DISK_ACCESS_METAOPS,
    OPEN_VIRTUAL_DISK_FLAG_NONE,
    nil,
    hVhd);

  if Ret = ERROR_SUCCESS then
  begin
    xparams.Version := EXPAND_VIRTUAL_DISK_VERSION_1;
    xparams.Version1.NewSize := ANewSize * 1024 * 1024;

    Ret := ExpandVirtualDisk( hVhd,
      EXPAND_VIRTUAL_DISK_FLAG_NONE,
      @xparams,
      nil );
  end;

  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

procedure TFormVirtDiskExampleMain.FormCreate(Sender: TObject);
begin
  //
end;

function TFormVirtDiskExampleMain.GetPhysVHD(const AFilePath: string): Boolean;
var
  oparams: TOpenVirtualDiskParameters;
  iparams: TAttachVirtualDiskParameters;
  vst: TVirtualStorageType;
  Ret: DWORD;
  hVhd: THandle;
  sizePhysicalDisk: ULONG;
  pszPhysicalDiskPath: PWideChar;
begin
  hVhd := INVALID_HANDLE_VALUE;

  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  oparams.Version := OPEN_VIRTUAL_DISK_VERSION_1;
  oparams.Version1.RWDepth := OPEN_VIRTUAL_DISK_RW_DEPTH_DEFAULT;

  iparams.Version := ATTACH_VIRTUAL_DISK_VERSION_1;

  Ret := OpenVirtualDisk(@vst,
    PWideChar(AFilePath),
    TVIRTUAL_DISK_ACCESS_MASK(DWORD(VIRTUAL_DISK_ACCESS_ATTACH_RW) or DWORD(VIRTUAL_DISK_ACCESS_GET_INFO) or DWORD(VIRTUAL_DISK_ACCESS_DETACH)),
    OPEN_VIRTUAL_DISK_FLAG_NONE,
    @oparams,
    hVhd);

  if Ret = ERROR_SUCCESS then
  begin
    sizePhysicalDisk := (PHYS_PATH_LEN * sizeof(WideChar)) * 256;
    GetMem(pszPhysicalDiskPath, PHYS_PATH_LEN * sizeof(WideChar));
    Ret := GetVirtualDiskPhysicalPath( hVhd, @sizePhysicalDisk, pszPhysicalDiskPath );

    if Ret = ERROR_SUCCESS then
    begin
      ShowMessage( pszPhysicalDiskPath );
    end;

    FreeMem( pszPhysicalDiskPath );
  end;

  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

function TFormVirtDiskExampleMain.GetVHDInfo(const AFilePath: string): Boolean;
var
  Ret: DWORD;
  hVhd: THandle;
  vst: TVirtualStorageType;
  Info: TGetVirtualDiskInfo;
  InfoSize, SizeUsed: ULONG;
begin
  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  Ret := OpenVirtualDisk(@vst,
    PWideChar(AFilePath),
    VIRTUAL_DISK_ACCESS_ALL,
    OPEN_VIRTUAL_DISK_FLAG_NONE,
    nil,
    hVhd);

  if Ret = ERROR_SUCCESS then
  begin
    Info.Version := GET_VIRTUAL_DISK_INFO_SIZE;
    InfoSize := sizeof(Info);

    Ret := GetVirtualDiskInformation(hVhd,
        InfoSize,
        Info,
        SizeUsed);
  end;

  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

function TFormVirtDiskExampleMain.MergeVHD(const AFilePath: string): Boolean;
var
  Ret: DWORD;
  hVhd: THandle;
  oparams: TOpenVirtualDiskParameters;
  mparms: TMergeVirtualDiskParameters;
  vst: TVirtualStorageType;
begin
  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  oparams.Version := OPEN_VIRTUAL_DISK_VERSION_1;
  oparams.Version1.RWDepth := 2;

  Ret := OpenVirtualDisk(@vst,
    PWideChar(AFilePath),
    TVIRTUAL_DISK_ACCESS_MASK(DWORD(VIRTUAL_DISK_ACCESS_METAOPS) or DWORD(VIRTUAL_DISK_ACCESS_GET_INFO)),
    OPEN_VIRTUAL_DISK_FLAG_NONE,
    @oparams,
    hVhd);

  if Ret = ERROR_SUCCESS then
  begin
    { TODO : Need Test }
    mparms.Version := MERGE_VIRTUAL_DISK_VERSION_1;
    mparms.Version1.MergeDepth := oparams.Version1.RWDepth - 1; //MERGE_VIRTUAL_DISK_DEFAULT_MERGE_DEPTH;

    Ret := MergeVirtualDisk( hVhd,
      MERGE_VIRTUAL_DISK_FLAG_NONE,
      @mparms,
      nil );
  end;

  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

function TFormVirtDiskExampleMain.SetVHDInfo(const AFilePath: string): Boolean;
var
  Ret: DWORD;
  hVhd: THandle;
  vst: TVirtualStorageType;
  SetInfo: TSetVirtualDiskInfo;
begin
  vst.DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
  vst.VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;

  Ret := OpenVirtualDisk(@vst,
    PWideChar(AFilePath),
    VIRTUAL_DISK_ACCESS_ALL,
    OPEN_VIRTUAL_DISK_FLAG_NONE,
    nil,
    hVhd);

  if Ret = ERROR_SUCCESS then
  begin
    SetInfo.Version := SET_VIRTUAL_DISK_INFO_IDENTIFIER;
    SetInfo.UniqueIdentifier := TGuid.Empty;

    Ret := SetVirtualDiskInformation(hVhd,
        @SetInfo );
  end;

  Result := Ret = ERROR_SUCCESS;

  if hvhd <> INVALID_HANDLE_VALUE then
    CloseHandle( hvhd )
end;

end.
