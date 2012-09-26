unit VirtDisk;

interface

// Microsoft SDKs v7.0 - VirtDisk.h convert to pascal
// http://msdn.microsoft.com/en-us/library/windows/desktop/dd323654(v=vs.85).aspx

// kyypbd@gmail.com
// http://yypbd.tistory.com

uses
  Windows;

{$MINENUMSIZE 4}

// OpenVirtualDisk & CreateVirtualDisk
type
  PVirtualStorageType = ^TVirtualStorageType;
  _VIRTUAL_STORAGE_TYPE = record
    DeviceId: ULONG;
    VendorId: TGUID;
  end;
  TVirtualStorageType = _VIRTUAL_STORAGE_TYPE;
  VIRTUAL_STORAGE_TYPE = _VIRTUAL_STORAGE_TYPE;

const
  VIRTUAL_STORAGE_TYPE_VENDOR_UNKNOWN: TGUID =
    '{00000000-0000-0000-0000-000000000000}';
  VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT: TGUID =
    '{EC984AEC-A0F9-47e9-901F-71415A66345B}';

  VIRTUAL_STORAGE_TYPE_DEVICE_UNKNOWN = 0;
  VIRTUAL_STORAGE_TYPE_DEVICE_ISO = 1;
  VIRTUAL_STORAGE_TYPE_DEVICE_VHD = 2;

  CREATE_VIRTUAL_DISK_PARAMETERS_DEFAULT_BLOCK_SIZE = 0;
  CREATE_VIRTUAL_DISK_PARAMETERS_DEFAULT_SECTOR_SIZE = $200;

type
  TCREATE_VIRTUAL_DISK_VERSION = (
    CREATE_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0,
    CREATE_VIRTUAL_DISK_VERSION_1           = 1
  );

  TCreateVirtualDiskParametersVersion1 = record
    UniqueId: TGUID;
    MaximumSize: ULONGLONG;
    BlockSizeInBytes: ULONG;
    SectorSizeInBytes: ULONG;
    ParentPath: LPCWSTR;
    SourcePath: LPCWSTR;
  end;

  PCreateVirtualDiskParameters = ^TCreateVirtualDiskParameters;
  _CREATE_VIRTUAL_DISK_PARAMETERS = record
    Version: TCREATE_VIRTUAL_DISK_VERSION;
    case Integer of
      0: ( Version1: TCreateVirtualDiskParametersVersion1; );
  end;
  TCreateVirtualDiskParameters = _CREATE_VIRTUAL_DISK_PARAMETERS;
  CREATE_VIRTUAL_DISK_PARAMETERS = _CREATE_VIRTUAL_DISK_PARAMETERS;

  TCREATE_VIRTUAL_DISK_FLAG = (
    CREATE_VIRTUAL_DISK_FLAG_NONE = $00000000,
    CREATE_VIRTUAL_DISK_FLAG_FULL_PHYSICAL_ALLOCATION = $00000001
  );

const
  OPEN_VIRTUAL_DISK_RW_DEPTH_DEFAULT = 1;

type
  TOPEN_VIRTUAL_DISK_VERSION = (
    OPEN_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0,
    OPEN_VIRTUAL_DISK_VERSION_1           = 1
  );

  TOPEN_VIRTUAL_DISK_PARAMETERS_VERSION1 = record
    RWDepth: ULONG;
  end;

  POpenVirtualDiskParameters = ^TOpenVirtualDiskParameters;
  _OPEN_VIRTUAL_DISK_PARAMETERS = record
    Version: TOPEN_VIRTUAL_DISK_VERSION;
    case Integer of
      0: ( Version1: TOPEN_VIRTUAL_DISK_PARAMETERS_VERSION1;
        );
  end;
  TOpenVirtualDiskParameters = _OPEN_VIRTUAL_DISK_PARAMETERS;
  OPEN_VIRTUAL_DISK_PARAMETERS = _OPEN_VIRTUAL_DISK_PARAMETERS;

  TVIRTUAL_DISK_ACCESS_MASK = (
    VIRTUAL_DISK_ACCESS_ATTACH_RO           = $00010000,
    VIRTUAL_DISK_ACCESS_ATTACH_RW           = $00020000,
    VIRTUAL_DISK_ACCESS_DETACH              = $00040000,
    VIRTUAL_DISK_ACCESS_GET_INFO            = $00080000,
    VIRTUAL_DISK_ACCESS_CREATE              = $00100000,
    VIRTUAL_DISK_ACCESS_METAOPS             = $00200000,
    VIRTUAL_DISK_ACCESS_READ                = $000d0000,
    VIRTUAL_DISK_ACCESS_ALL                 = $003f0000,
    VIRTUAL_DISK_ACCESS_WRITABLE            = $00320000
  );

  TOPEN_VIRTUAL_DISK_FLAG = (
    OPEN_VIRTUAL_DISK_FLAG_NONE                = $00000000,
    OPEN_VIRTUAL_DISK_FLAG_NO_PARENTS          = $00000001,
    OPEN_VIRTUAL_DISK_FLAG_BLANK_FILE          = $00000002,
    OPEN_VIRTUAL_DISK_FLAG_BOOT_DRIVE          = $00000004
  );

  function OpenVirtualDisk(
    VirtualStorageType: PVirtualStorageType;
    Path: LPCWSTR;
    VirtualDiskAccessMask: TVIRTUAL_DISK_ACCESS_MASK;
    Flags: TOPEN_VIRTUAL_DISK_FLAG;
    Parameters: POpenVirtualDiskParameters;
    var Handle: THandle
  ): DWORD; stdcall;

  function CreateVirtualDisk(
    VirtualStorageType: PVirtualStorageType;
    Path: LPCWSTR;
    VirtualDiskAccessMask: TVIRTUAL_DISK_ACCESS_MASK;
    SecurityDescriptor: PSECURITY_DESCRIPTOR;
    Flags: TCREATE_VIRTUAL_DISK_FLAG;
    ProviderSpecificFlags: ULONG;
    Parameters: PCreateVirtualDiskParameters;
    Overlapped: POverlapped;
    var Handle: THandle
  ): DWORD; stdcall;


// AttachVirtualDisk
type
  TATTACH_VIRTUAL_DISK_VERSION = (
    ATTACH_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0,
    ATTACH_VIRTUAL_DISK_VERSION_1           = 1
  );

  TAttachVirtualDiskParametersVersion1 = record
    Reserved: ULONG;
  end;

  PAttachVirtualDiskParameters = ^TAttachVirtualDiskParameters;
  _ATTACH_VIRTUAL_DISK_PARAMETERS = record
    Version: TATTACH_VIRTUAL_DISK_VERSION;
    case Integer of
      0: ( Version1: TAttachVirtualDiskParametersVersion1; );
  end;
  TAttachVirtualDiskParameters = _ATTACH_VIRTUAL_DISK_PARAMETERS;
  ATTACH_VIRTUAL_DISK_PARAMETERS = _ATTACH_VIRTUAL_DISK_PARAMETERS;

  TATTACH_VIRTUAL_DISK_FLAG = (
    ATTACH_VIRTUAL_DISK_FLAG_NONE                = $00000000,
    ATTACH_VIRTUAL_DISK_FLAG_READ_ONLY           = $00000001,
    ATTACH_VIRTUAL_DISK_FLAG_NO_DRIVE_LETTER     = $00000002,
    ATTACH_VIRTUAL_DISK_FLAG_PERMANENT_LIFETIME  = $00000004,
    ATTACH_VIRTUAL_DISK_FLAG_NO_LOCAL_HOST       = $00000008
  );

  function AttachVirtualDisk(
    VirtualDiskHandle: THandle;
    SecurityDescriptor: PSECURITY_DESCRIPTOR;
    Flags: TATTACH_VIRTUAL_DISK_FLAG;
    ProviderSpecificFlags: ULONG;
    Parameters: PAttachVirtualDiskParameters;
    Overlapped: POverlapped
  ): DWORD; stdcall;


// DetachVirtualDisk
type
  TDETACH_VIRTUAL_DISK_FLAG = (
    DETACH_VIRTUAL_DISK_FLAG_NONE                = $00000000
  );

  function DetachVirtualDisk(
    VirtualDiskHandle: THandle;
    Flags: TDETACH_VIRTUAL_DISK_FLAG;
    ProviderSpecificFlags: ULONG
  ): DWORD; stdcall;


// GetVirtualDiskPhysicalPath
  function GetVirtualDiskPhysicalPath(
    VirtualDiskHandle: THandle;
    DiskPathSizeInBytes: PULONG;
    DiskPath: LPWSTR
  ): DWORD; stdcall;


// GetStorageDependencyInformation
type
  TDEPENDENT_DISK_FLAG = (
    DEPENDENT_DISK_FLAG_NONE                 = $00000000,
    DEPENDENT_DISK_FLAG_MULT_BACKING_FILES   = $00000001,
    DEPENDENT_DISK_FLAG_FULLY_ALLOCATED      = $00000002,
    DEPENDENT_DISK_FLAG_READ_ONLY            = $00000004,
    DEPENDENT_DISK_FLAG_REMOTE               = $00000008,
    DEPENDENT_DISK_FLAG_SYSTEM_VOLUME        = $00000010,
    DEPENDENT_DISK_FLAG_SYSTEM_VOLUME_PARENT = $00000020,
    DEPENDENT_DISK_FLAG_REMOVABLE            = $00000040,
    DEPENDENT_DISK_FLAG_NO_DRIVE_LETTER      = $00000080,
    DEPENDENT_DISK_FLAG_PARENT               = $00000100,
    DEPENDENT_DISK_FLAG_NO_HOST_DISK         = $00000200,
    DEPENDENT_DISK_FLAG_PERMANENT_LIFETIME   = $00000400
  );

  TSTORAGE_DEPENDENCY_INFO_VERSION = (
    STORAGE_DEPENDENCY_INFO_VERSION_UNSPECIFIED = 0,
    STORAGE_DEPENDENCY_INFO_VERSION_1           = 1,
    STORAGE_DEPENDENCY_INFO_VERSION_2           = 2
  );

  PStorageDependencyInfoType1 = ^TStorageDependencyInfoType1;
  _STORAGE_DEPENDENCY_INFO_TYPE_1 = record
    DependencyTypeFlags: TDEPENDENT_DISK_FLAG;
    ProviderSpecificFlags: ULONG;
    VirtualStorageType: TVirtualStorageType;
  end;
  TStorageDependencyInfoType1 = _STORAGE_DEPENDENCY_INFO_TYPE_1;
  STORAGE_DEPENDENCY_INFO_TYPE_1 = _STORAGE_DEPENDENCY_INFO_TYPE_1;

  PStorageDependencyInfoType2 = ^TStorageDependencyInfoType2;
  _STORAGE_DEPENDENCY_INFO_TYPE_2 = record
    DependencyTypeFlags: TDEPENDENT_DISK_FLAG;
    ProviderSpecificFlags: ULONG;
    VirtualStorageType: TVirtualStorageType;
    AncestorLevel: ULONG;
    DependencyDeviceName: LPWSTR;
    HostVolumeName: LPWSTR;
    DependentVolumeName: LPWSTR;
    DependentVolumeRelativePath: LPWSTR;
  end;
  TStorageDependencyInfoType2 = _STORAGE_DEPENDENCY_INFO_TYPE_2;
  STORAGE_DEPENDENCY_INFO_TYPE_2 = _STORAGE_DEPENDENCY_INFO_TYPE_2;

  PStorageDependencyInfo = ^TStorageDependencyInfo;
  _STORAGE_DEPENDENCY_INFO = record
    Version: TSTORAGE_DEPENDENCY_INFO_VERSION;
    NumberEntries: ULONG;
    case Integer of
      0: (
        Version1Entries: PStorageDependencyInfoType1;
        Version2Entries: PStorageDependencyInfoType2;
      );
  end;
  TStorageDependencyInfo = _STORAGE_DEPENDENCY_INFO;
  STORAGE_DEPENDENCY_INFO = _STORAGE_DEPENDENCY_INFO;

  TGET_STORAGE_DEPENDENCY_FLAG = (
    GET_STORAGE_DEPENDENCY_FLAG_NONE         = $00000000,
    GET_STORAGE_DEPENDENCY_FLAG_HOST_VOLUMES = $00000001,
    GET_STORAGE_DEPENDENCY_FLAG_DISK_HANDLE  = $00000002
  );
const
  GET_STORAGE_DEPENDENCY_FLAG_PARENTS = GET_STORAGE_DEPENDENCY_FLAG_HOST_VOLUMES;

  function GetStorageDependencyInformation(
    ObjectHandle: THandle;
    Flags: TGET_STORAGE_DEPENDENCY_FLAG;
    StorageDependencyInfoSize: ULONG;
    var StorageDependencyInfo: TStorageDependencyInfo;
    var SizeUsed: ULONG
  ): DWORD; stdcall;


// GetVirtualDiskInformation
type
  TGET_VIRTUAL_DISK_INFO_VERSION = (
    GET_VIRTUAL_DISK_INFO_UNSPECIFIED       = 0,
    GET_VIRTUAL_DISK_INFO_SIZE              = 1,
    GET_VIRTUAL_DISK_INFO_IDENTIFIER        = 2,
    GET_VIRTUAL_DISK_INFO_PARENT_LOCATION   = 3,
    GET_VIRTUAL_DISK_INFO_PARENT_IDENTIFIER = 4,
    GET_VIRTUAL_DISK_INFO_PARENT_TIMESTAMP  = 5,
    GET_VIRTUAL_DISK_INFO_VIRTUAL_STORAGE_TYPE  = 6,
    GET_VIRTUAL_DISK_INFO_PROVIDER_SUBTYPE  = 7
  );

  TSize = record
    VirtualSize: ULONGLONG;
    PhysicalSize: ULONGLONG;
    BlockSize: ULONG;
    SectorSize: ULONG;
  end;

  TParentLocation = record
    ParentResolved: BOOL;
    ParentLocationBuffer: array[0..0] of WCHAR;  // MultiSz string
  end;

  PGetVirtualDiskInfo = ^TGetVirtualDiskInfo;
  _GET_VIRTUAL_DISK_INFO = record
    Version: TGET_VIRTUAL_DISK_INFO_VERSION;
    case Integer of
      0: (
        Size: TSize;
        Identifier: TGUID;
        ParentLocation: TParentLocation;
        ParentIdentifier: TGUID;
        ParentTimestamp: ULONG;
        VirtualStorageType: TVirtualStorageType;
        ProviderSubtype: ULONG;
      );
  end;
  TGetVirtualDiskInfo = _GET_VIRTUAL_DISK_INFO;
  GET_VIRTUAL_DISK_INFO = _GET_VIRTUAL_DISK_INFO;

  function GetVirtualDiskInformation(
    VirtualDiskHandle: THandle;
    var VirtualDiskInfoSize: ULONG;
    var VirtualDiskInfo: TGetVirtualDiskInfo;
    var SizeUsed: ULONG
  ): DWORD; stdcall;


// SetVirtualDiskInformation
type
  TSET_VIRTUAL_DISK_INFO_VERSION = (
    SET_VIRTUAL_DISK_INFO_UNSPECIFIED       = 0,
    SET_VIRTUAL_DISK_INFO_PARENT_PATH       = 1,
    SET_VIRTUAL_DISK_INFO_IDENTIFIER        = 2
  );

  PSetVirtualDiskInfo = ^TSetVirtualDiskInfo;
  _SET_VIRTUAL_DISK_INFO = record
    Version: TSET_VIRTUAL_DISK_INFO_VERSION;
    case Integer of
      0: (
        ParentFilePath: LPWSTR;
        UniqueIdentifier: TGUID;
      );
  end;
  TSetVirtualDiskInfo = _SET_VIRTUAL_DISK_INFO;
  SET_VIRTUAL_DISK_INFO = _SET_VIRTUAL_DISK_INFO;

  function SetVirtualDiskInformation(
    VirtualDiskHandle: THandle;
    VirtualDiskInfo: PSetVirtualDiskInfo
  ): DWORD; stdcall;


// GetVirtualDiskOperationProgress
type
  PVirtualDiskProgress = ^TVirtualDiskProgress;
  _VIRTUAL_DISK_PROGRESS = record
    OperationStatus: DWORD;
    CurrentValue: ULONGLONG;
    CompletionValue: ULONGLONG;
  end;
  TVirtualDiskProgress = _VIRTUAL_DISK_PROGRESS;
  VIRTUAL_DISK_PROGRESS = _VIRTUAL_DISK_PROGRESS;

  function GetVirtualDiskOperationProgress(
    VirtualDiskHandle: THandle;
    Overlapped: POverlapped;
    var Progress: TVirtualDiskProgress
  ): DWORD; stdcall;


// CompactVirtualDisk
type
  TCOMPACT_VIRTUAL_DISK_VERSION = (
    COMPACT_VIRTUAL_DISK_VERSION_UNSPECIFIED    = 0,
    COMPACT_VIRTUAL_DISK_VERSION_1              = 1
  );

  TCOMPACT_VIRTUAL_DISK_PARAMETERS_VERSION1 = record
    Reserved: ULONG;
  end;

  PCompactVirtualDiskParameters = ^TCompactVirtualDiskParameters;
  _COMPACT_VIRTUAL_DISK_PARAMETERS = record
    Version: TCOMPACT_VIRTUAL_DISK_VERSION;
    case Integer of
      0: ( Version1: TCOMPACT_VIRTUAL_DISK_PARAMETERS_VERSION1; );
  end;
  TCompactVirtualDiskParameters = _COMPACT_VIRTUAL_DISK_PARAMETERS;
  COMPACT_VIRTUAL_DISK_PARAMETERS = _COMPACT_VIRTUAL_DISK_PARAMETERS;

  TCOMPACT_VIRTUAL_DISK_FLAG = (
    COMPACT_VIRTUAL_DISK_FLAG_NONE                 = $00000000
  );

  function CompactVirtualDisk(
    VirtualDiskHandle: THandle;
    Flags: TCOMPACT_VIRTUAL_DISK_FLAG;
    Parameters: PCompactVirtualDiskParameters;
    Overlapped: POverlapped
  ): DWORD; stdcall;


// MergeVirtualDisk
type
  TMERGE_VIRTUAL_DISK_VERSION = (
    MERGE_VIRTUAL_DISK_VERSION_UNSPECIFIED    = 0,
    MERGE_VIRTUAL_DISK_VERSION_1              = 1
  );

const
  MERGE_VIRTUAL_DISK_DEFAULT_MERGE_DEPTH = 1;

type
  TMergeVirtualDiskParametersVersion1 = record
    MergeDepth: ULONG;
  end;

  PMergeVirtualDiskParameters = ^TMergeVirtualDiskParameters;
  _MERGE_VIRTUAL_DISK_PARAMETERS = record
    Version: TMERGE_VIRTUAL_DISK_VERSION;
    case Integer of
      0: ( Version1: TMergeVirtualDiskParametersVersion1; );
  end;
  TMergeVirtualDiskParameters = _MERGE_VIRTUAL_DISK_PARAMETERS;
  MERGE_VIRTUAL_DISK_PARAMETERS = _MERGE_VIRTUAL_DISK_PARAMETERS;

  TMERGE_VIRTUAL_DISK_FLAG = (
    MERGE_VIRTUAL_DISK_FLAG_NONE                 = $00000000
  );

  function MergeVirtualDisk(
    VirtualDiskHandle: THandle;
    Flags: TMERGE_VIRTUAL_DISK_FLAG;
    Parameters: PMergeVirtualDiskParameters;
    Overlapped: POverlapped
  ): DWORD; stdcall;


// ExpandVirtualDisk
type
  TEXPAND_VIRTUAL_DISK_VERSION = (
    EXPAND_VIRTUAL_DISK_VERSION_UNSPECIFIED    = 0,
    EXPAND_VIRTUAL_DISK_VERSION_1              = 1
  );

  TExpandVirtualDiskParametersVersion1 = record
    NewSize: ULONGLONG;
  end;

  PExpandVirtualDiskParameters = ^TExpandVirtualDiskParameters;
  _EXPAND_VIRTUAL_DISK_PARAMETERS = record
    Version: TEXPAND_VIRTUAL_DISK_VERSION;
    case Integer of
      0: ( Version1: TExpandVirtualDiskParametersVersion1; );
  end;
  TExpandVirtualDiskParameters = _EXPAND_VIRTUAL_DISK_PARAMETERS;
  EXPAND_VIRTUAL_DISK_PARAMETERS = _EXPAND_VIRTUAL_DISK_PARAMETERS;

  TEXPAND_VIRTUAL_DISK_FLAG = (
    EXPAND_VIRTUAL_DISK_FLAG_NONE                 = $00000000
  );

  function ExpandVirtualDisk(
    VirtualDiskHandle: THANDLE;
    Flags: TEXPAND_VIRTUAL_DISK_FLAG;
    Parameters: PExpandVirtualDiskParameters;
    Overlapped: POverlapped
  ): DWORD; stdcall;


implementation

const
  VirtDiskDLLName    = 'VirtDisk.dll';

function OpenVirtualDisk; external VirtDiskDLLName name 'OpenVirtualDisk';
function CreateVirtualDisk; external VirtDiskDLLName name 'CreateVirtualDisk';
function AttachVirtualDisk; external VirtDiskDLLName name 'AttachVirtualDisk';
function DetachVirtualDisk; external VirtDiskDLLName name 'DetachVirtualDisk';
function GetVirtualDiskPhysicalPath; external VirtDiskDLLName name 'GetVirtualDiskPhysicalPath';
function GetStorageDependencyInformation; external VirtDiskDLLName name 'GetStorageDependencyInformation';
function GetVirtualDiskInformation; external VirtDiskDLLName name 'GetVirtualDiskInformation';
function SetVirtualDiskInformation; external VirtDiskDLLName name 'SetVirtualDiskInformation';
function GetVirtualDiskOperationProgress; external VirtDiskDLLName name 'GetVirtualDiskOperationProgress';
function CompactVirtualDisk; external VirtDiskDLLName name 'CompactVirtualDisk';
function MergeVirtualDisk; external VirtDiskDLLName name 'MergeVirtualDisk';
function ExpandVirtualDisk; external VirtDiskDLLName name 'ExpandVirtualDisk';

end.
