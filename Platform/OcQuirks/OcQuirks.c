#include <Uefi.h>

#include <Protocol/LoadedImage.h>
#include <Protocol/SimpleFileSystem.h>

#include <Protocol/OcQuirks.h>

#include <Library/BaseLib.h>
#include <Library/DevicePathLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/UefiBootServicesTableLib.h>

#include <Library/OcAfterBootCompatLib.h>
#include <Library/OcConsoleLib.h>
#include <Library/OcDebugLogLib.h>
#include <Library/OcSerializeLib.h>
#include <Library/OcStorageLib.h>
#include <Library/OcTemplateLib.h>

//

#define OCQUIRKS_OC_LAST_VER_SYNCED   L"0.5.9"
#define OCQUIRKS_CONFIG_PATH          L"OcQuirks.plist"
#define MAX_DATA_SIZE                 (10000)

EFI_GUID gOcQuirksProtocolGuid = OCQUIRKS_PROTOCOL_GUID;

//

#define OC_MMIO_WL_STRUCT_FIELDS(_, __) \
  _(BOOLEAN   , Enabled , , FALSE , ()) \
  _(UINT64    , Address , , 0     , ()) \
  _(OC_STRING , Comment , , OC_STRING_CONSTR ("", _, __), OC_DESTR (OC_STRING))
  OC_DECLARE (OC_MMIO_WL_STRUCT)

#define OC_MMIO_WL_ARRAY_FIELDS(_, __) \
  OC_ARRAY (OC_MMIO_WL_STRUCT, _, __)
  OC_DECLARE (OC_MMIO_WL_ARRAY)

#define OC_QUIRKS_FIELDS(_, __) \
  _(BOOLEAN , AvoidRuntimeDefrag      ,   , TRUE  ,()) \
  _(BOOLEAN , DevirtualiseMmio        ,   , FALSE ,()) \
  _(BOOLEAN , DisableSingleUser       ,   , FALSE ,()) \
  _(BOOLEAN , DisableVariableWrite    ,   , FALSE ,()) \
  _(BOOLEAN , DiscardHibernateMap     ,   , FALSE ,()) \
  _(BOOLEAN , EnableSafeModeSlide     ,   , TRUE  ,()) \
  _(BOOLEAN , EnableWriteUnprotector  ,   , FALSE  ,()) \
  _(BOOLEAN , ForceExitBootServices   ,   , TRUE  ,()) \
  _(OC_MMIO_WL_ARRAY , MmioWhitelist  ,   , OC_CONSTR2 (OC_MMIO_WL_ARRAY, _, __) , OC_DESTR (OC_MMIO_WL_ARRAY)) \
  _(BOOLEAN , ProtectMemoryRegions    ,   , FALSE ,()) \
  _(BOOLEAN , ProtectSecureBoot       ,   , FALSE ,()) \
  _(BOOLEAN , ProtectUefiServices     ,   , FALSE ,()) \
  _(BOOLEAN , ProvideConsoleGopEnable ,   , TRUE  ,()) \
  _(UINT8   , ProvideMaxSlide         ,   , 0     ,()) \
  _(BOOLEAN , ProvideCustomSlide      ,   , TRUE  ,()) \
  _(BOOLEAN , RebuildAppleMemoryMap   ,   , TRUE  ,()) \
  _(BOOLEAN , SetupVirtualMap         ,   , TRUE  ,()) \
  _(BOOLEAN , SignalAppleOS           ,   , FALSE ,()) \
  _(BOOLEAN , SyncRuntimePermissions  ,   , TRUE  ,())

  OC_DECLARE (OC_QUIRKS)

OC_STRUCTORS        (OC_MMIO_WL_STRUCT, ())
OC_ARRAY_STRUCTORS  (OC_MMIO_WL_ARRAY)
OC_STRUCTORS        (OC_QUIRKS, ())

STATIC
OC_SCHEMA
mMmioWhitelistEntry[] = {
  OC_SCHEMA_INTEGER_IN  ("Address", OC_MMIO_WL_STRUCT, Address),
  OC_SCHEMA_STRING_IN   ("Comment", OC_MMIO_WL_STRUCT, Comment),
  OC_SCHEMA_BOOLEAN_IN  ("Enabled", OC_MMIO_WL_STRUCT, Enabled),
};

STATIC
OC_SCHEMA
mMmioWhitelist = OC_SCHEMA_DICT (NULL, mMmioWhitelistEntry);

STATIC
OC_SCHEMA
mConfigNodes[] = {
  OC_SCHEMA_BOOLEAN_IN ("AvoidRuntimeDefrag"      , OC_QUIRKS, AvoidRuntimeDefrag),
  OC_SCHEMA_BOOLEAN_IN ("DevirtualiseMmio"        , OC_QUIRKS, DevirtualiseMmio),
  OC_SCHEMA_BOOLEAN_IN ("DisableSingleUser"       , OC_QUIRKS, DisableSingleUser),
  OC_SCHEMA_BOOLEAN_IN ("DisableVariableWrite"    , OC_QUIRKS, DisableVariableWrite),
  OC_SCHEMA_BOOLEAN_IN ("DiscardHibernateMap"     , OC_QUIRKS, DiscardHibernateMap),
  OC_SCHEMA_BOOLEAN_IN ("EnableSafeModeSlide"     , OC_QUIRKS, EnableSafeModeSlide),
  OC_SCHEMA_BOOLEAN_IN ("EnableWriteUnprotector"  , OC_QUIRKS, EnableWriteUnprotector),
  OC_SCHEMA_BOOLEAN_IN ("ForceExitBootServices"   , OC_QUIRKS, ForceExitBootServices),
  OC_SCHEMA_ARRAY_IN   ("MmioWhitelist"           , OC_QUIRKS, MmioWhitelist, &mMmioWhitelist),
  OC_SCHEMA_BOOLEAN_IN ("ProtectMemoryRegions"    , OC_QUIRKS, ProtectMemoryRegions),
  OC_SCHEMA_BOOLEAN_IN ("ProtectSecureBoot"       , OC_QUIRKS, ProtectSecureBoot),
  OC_SCHEMA_BOOLEAN_IN ("ProtectUefiServices"     , OC_QUIRKS, ProtectUefiServices),
  OC_SCHEMA_BOOLEAN_IN ("ProvideConsoleGopEnable" , OC_QUIRKS, ProvideConsoleGopEnable),
  OC_SCHEMA_BOOLEAN_IN ("ProvideCustomSlide"      , OC_QUIRKS, ProvideCustomSlide),
  OC_SCHEMA_INTEGER_IN ("ProvideMaxSlide"         , OC_QUIRKS, ProvideMaxSlide),
  OC_SCHEMA_BOOLEAN_IN ("RebuildAppleMemoryMap"   , OC_QUIRKS, RebuildAppleMemoryMap),
  OC_SCHEMA_BOOLEAN_IN ("SetupVirtualMap"         , OC_QUIRKS, SetupVirtualMap),
  OC_SCHEMA_BOOLEAN_IN ("SignalAppleOS"           , OC_QUIRKS, SignalAppleOS),
  OC_SCHEMA_BOOLEAN_IN ("SyncRuntimePermissions"  , OC_QUIRKS, SyncRuntimePermissions)
};

STATIC
OC_SCHEMA_INFO
mConfigInfo = {
  .Dict = {mConfigNodes, ARRAY_SIZE (mConfigNodes)}
};

STATIC
BOOLEAN
OcQuirksProvideConfig (
  OUT OC_QUIRKS *Config,
  IN EFI_HANDLE Handle
  )
{
  EFI_STATUS                        Status;
  EFI_LOADED_IMAGE_PROTOCOL         *LoadedImage;
  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL   *FileSystem;
  OC_STORAGE_CONTEXT                Storage;
  CHAR8                             *ConfigData;
  BOOLEAN                           IsSuccess;
  UINT32                            ConfigDataSize;
  CHAR16                            *DirectoryName;

  IsSuccess = FALSE;

  // Load SimpleFileSystem Protocol
  Status = gBS->HandleProtocol (
    Handle,
    &gEfiLoadedImageProtocolGuid,
    (VOID **) &LoadedImage
    );

  if (EFI_ERROR (Status)) {
    return IsSuccess;
  }

  FileSystem = LocateFileSystem (
    LoadedImage->DeviceHandle,
    LoadedImage->FilePath
    );

  if (FileSystem == NULL) {
    return IsSuccess;
  }

  // Attempt to get self-directory path

  DebugPrintDevicePath (DEBUG_INFO, "OQ: Self path", LoadedImage->FilePath);

  DirectoryName = ConvertDevicePathToText (LoadedImage->FilePath, TRUE, FALSE);

  if (DirectoryName != NULL) {
    UINTN   i;
    UINTN   Len;

    //

    Len = StrLen (DirectoryName);

    for (i = Len; ((i > 0) && (DirectoryName[i] != L'\\')); i--);

    if (i > 0) {
      DirectoryName[i] = L'\0';
    } else {
      DirectoryName[0] = L'\\';
      DirectoryName[1] = L'\0';
    }
  } else {
    return IsSuccess;
  }

  DEBUG ((DEBUG_INFO, "OQ: Dir path %s\n", DirectoryName));

  // Init OcStorage as it already handles
  // reading Unicode files
  Status = OcStorageInitFromFs (
    &Storage,
    FileSystem,
    DirectoryName,
    NULL
    );

  FreePool (DirectoryName);

  if (EFI_ERROR (Status)) {
    return IsSuccess;
  }

  ConfigData = OcStorageReadFileUnicode (
    &Storage,
    OCQUIRKS_CONFIG_PATH,
    &ConfigDataSize
    );

  // If no config data or greater than max size, fail and use defaults
  if (ConfigData != NULL) {
    if ((ConfigDataSize > 0) && (ConfigDataSize <= MAX_DATA_SIZE)) {
      IsSuccess = ParseSerialized (Config, &mConfigInfo, ConfigData, ConfigDataSize);
    }
    FreePool (ConfigData);
  }

  return IsSuccess;
}

EFI_STATUS
EFIAPI
OcQuirksEntryPoint (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  EFI_STATUS        Status;
  EFI_HANDLE        Handle;
  VOID              *Interface;
  OC_QUIRKS         Config;
  OC_ABC_SETTINGS   AbcSettings;

  // OcQuirks protocol lookup

  Status = gBS->LocateProtocol (
    &gOcQuirksProtocolGuid,
    NULL,
    &Interface
    );

  if (!EFI_ERROR (Status)) {
    //
    // In case for whatever reason one tried to reload the driver.
    //
    return EFI_ALREADY_STARTED;
  }

  // Install OcQuirks protocol

  Handle    = NULL;
  Interface = NULL;
  Status    = gBS->InstallMultipleProtocolInterfaces (
    &Handle,
    &gOcQuirksProtocolGuid,
    &Interface,
    NULL
    );

  ASSERT_EFI_ERROR (Status);

  DEBUG ((DEBUG_INFO, "OQ: Installed rev%d w/ OC rev%s\n", OCQUIRKS_PROTOCOL_REVISION, OCQUIRKS_OC_LAST_VER_SYNCED));

  OC_QUIRKS_CONSTRUCT (&Config, sizeof (Config));
  OcQuirksProvideConfig (&Config, ImageHandle);

  ZeroMem (&AbcSettings, sizeof (AbcSettings));

  AbcSettings.AvoidRuntimeDefrag     = Config.AvoidRuntimeDefrag;
  AbcSettings.DevirtualiseMmio       = Config.DevirtualiseMmio;
  AbcSettings.DisableSingleUser      = Config.DisableSingleUser;
  AbcSettings.DisableVariableWrite   = Config.DisableVariableWrite;
  AbcSettings.ProtectSecureBoot      = Config.ProtectSecureBoot;
  AbcSettings.DiscardHibernateMap    = Config.DiscardHibernateMap;
  AbcSettings.EnableSafeModeSlide    = Config.EnableSafeModeSlide;
  AbcSettings.EnableWriteUnprotector = Config.EnableWriteUnprotector;
  AbcSettings.ForceExitBootServices  = Config.ForceExitBootServices;
  AbcSettings.ProtectMemoryRegions   = Config.ProtectMemoryRegions;
  AbcSettings.ProvideCustomSlide     = Config.ProvideCustomSlide;
  AbcSettings.ProvideMaxSlide        = Config.ProvideMaxSlide;
  AbcSettings.ProtectUefiServices    = Config.ProtectUefiServices;
  AbcSettings.RebuildAppleMemoryMap  = Config.RebuildAppleMemoryMap;
  AbcSettings.SetupVirtualMap        = Config.SetupVirtualMap;
  AbcSettings.SignalAppleOS          = Config.SignalAppleOS;
  AbcSettings.SyncRuntimePermissions = Config.SyncRuntimePermissions;

  if (AbcSettings.DevirtualiseMmio && (Config.MmioWhitelist.Count > 0)) {
    AbcSettings.MmioWhitelist = AllocatePool (
      Config.MmioWhitelist.Count * sizeof (AbcSettings.MmioWhitelist[0])
      );

    if (AbcSettings.MmioWhitelist != NULL) {
      UINT32  Index;
      UINT32  NextIndex;

      NextIndex = 0;
      for (Index = 0; Index < Config.MmioWhitelist.Count; ++Index) {
        if (Config.MmioWhitelist.Values[Index]->Enabled) {
          AbcSettings.MmioWhitelist[NextIndex] = Config.MmioWhitelist.Values[Index]->Address;
          ++NextIndex;
        }
      }
      AbcSettings.MmioWhitelistSize = NextIndex;
    } else {
      DEBUG ((
        DEBUG_ERROR,
        "OC: Failed to allocate %u slots for mmio addresses\n",
        (UINT32) Config.MmioWhitelist.Count
        ));
    }
  }

  if (Config.ProvideConsoleGopEnable) {
    OcProvideConsoleGop (TRUE);
  }

  OC_QUIRKS_DESTRUCT (&Config, sizeof (Config));

  return OcAbcInitialize (&AbcSettings);
}
