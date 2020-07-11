## @file
# Copyright (C) 2017, vit9696.  All rights reserved.<BR>
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
##

[Defines]
  PLATFORM_NAME           = OcQuirks
  PLATFORM_GUID           = 4FBFC810-9D3C-4BF3-ABF5-89A793C235B1
  PLATFORM_VERSION        = 1.0
  SUPPORTED_ARCHITECTURES = X64
  BUILD_TARGETS           = RELEASE|DEBUG|NOOPT
  SKUID_IDENTIFIER        = DEFAULT
  DSC_SPECIFICATION       = 0x00010006

[LibraryClasses]
  BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
  # We cannot use BaseMemoryLibOptDxe since it uses SSE instructions,
  # and some firmwares fail to properly maintain MMX register contexts
  # across the timers. This results in exceptions when trying to execute
  # primitives like CopyMem in timers (e.g. AIKDataWriteEntry).
  # Reproduced on ASUS M5A97 with AMD FX8320 CPU.
  # REF: https://github.com/acidanthera/bugtracker/issues/754
  BaseMemoryLib|MdePkg/Library/BaseMemoryLibRepStr/BaseMemoryLibRepStr.inf
  BaseRngLib|MdePkg/Library/BaseRngLib/BaseRngLib.inf
  BcfgCommandLib|ShellPkg/Library/UefiShellBcfgCommandLib/UefiShellBcfgCommandLib.inf
  CpuLib|MdePkg/Library/BaseCpuLib/BaseCpuLib.inf
  DebugLib|OpenCorePkg/Library/OcDebugLogLib/OcDebugLogLib.inf
  DxeServicesLib|MdePkg/Library/DxeServicesLib/DxeServicesLib.inf
  MtrrLib|UefiCpuPkg/Library/MtrrLib/MtrrLib.inf
  DebugPrintErrorLevelLib|MdePkg/Library/BaseDebugPrintErrorLevelLib/BaseDebugPrintErrorLevelLib.inf
  DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf
  DxeServicesTableLib|MdePkg/Library/DxeServicesTableLib/DxeServicesTableLib.inf
  FileHandleLib|MdePkg/Library/UefiFileHandleLib/UefiFileHandleLib.inf
  FrameBufferBltLib|MdeModulePkg/Library/FrameBufferBltLib/FrameBufferBltLib.inf
  HandleParsingLib|ShellPkg/Library/UefiHandleParsingLib/UefiHandleParsingLib.inf
  HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf
  HobLib|MdePkg/Library/DxeHobLib/DxeHobLib.inf
  IoLib|MdePkg/Library/BaseIoLibIntrinsic/BaseIoLibIntrinsic.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  OcAcpiLib|OpenCorePkg/Library/OcAcpiLib/OcAcpiLib.inf
  OcAfterBootCompatLib|OpenCorePkg/Library/OcAfterBootCompatLib/OcAfterBootCompatLib.inf
  OcApfsLib|OpenCorePkg/Library/OcApfsLib/OcApfsLib.inf
  OcAppleBootPolicyLib|OpenCorePkg/Library/OcAppleBootPolicyLib/OcAppleBootPolicyLib.inf
  OcAppleChunklistLib|OpenCorePkg/Library/OcAppleChunklistLib/OcAppleChunklistLib.inf
  OcAppleDiskImageLib|OpenCorePkg/Library/OcAppleDiskImageLib/OcAppleDiskImageLib.inf
  OcAppleEventLib|OpenCorePkg/Library/OcAppleEventLib/OcAppleEventLib.inf
  OcAppleImageConversionLib|OpenCorePkg/Library/OcAppleImageConversionLib/OcAppleImageConversionLib.inf
  OcAppleImageVerificationLib|OpenCorePkg/Library/OcAppleImageVerificationLib/OcAppleImageVerificationLib.inf
  OcAppleImg4Lib|OpenCorePkg/Library/OcAppleImg4Lib/OcAppleImg4Lib.inf
  OcAppleKernelLib|OpenCorePkg/Library/OcAppleKernelLib/OcAppleKernelLib.inf
  OcAppleKeyMapLib|OpenCorePkg/Library/OcAppleKeyMapLib/OcAppleKeyMapLib.inf
  OcAppleKeysLib|OpenCorePkg/Library/OcAppleKeysLib/OcAppleKeysLib.inf
  OcAppleRamDiskLib|OpenCorePkg/Library/OcAppleRamDiskLib/OcAppleRamDiskLib.inf
  OcAppleSecureBootLib|OpenCorePkg/Library/OcAppleSecureBootLib/OcAppleSecureBootLib.inf
  OcAppleUserInterfaceThemeLib|OpenCorePkg/Library/OcAppleUserInterfaceThemeLib/OcAppleUserInterfaceThemeLib.inf
  OcAudioLib|OpenCorePkg/Library/OcAudioLib/OcAudioLib.inf
  OcBootManagementLib|OpenCorePkg/Library/OcBootManagementLib/OcBootManagementLib.inf
  OcBootServicesTableLib|OpenCorePkg/Library/OcBootServicesTableLib/OcBootServicesTableLib.inf
  OcCompressionLib|OpenCorePkg/Library/OcCompressionLib/OcCompressionLib.inf
  OcConfigurationLib|OpenCorePkg/Library/OcConfigurationLib/OcConfigurationLib.inf
  OcConsoleControlEntryModeGenericLib|OpenCorePkg/Library/OcConsoleControlEntryModeLib/OcConsoleControlEntryModeGenericLib.inf
  OcConsoleControlEntryModeLocalLib|OpenCorePkg/Library/OcConsoleControlEntryModeLib/OcConsoleControlEntryModeLocalLib.inf
  OcConsoleLib|OpenCorePkg/Library/OcConsoleLib/OcConsoleLib.inf
  OcCpuLib|OpenCorePkg/Library/OcCpuLib/OcCpuLib.inf
  OcCryptoLib|OpenCorePkg/Library/OcCryptoLib/OcCryptoLib.inf
  OcDataHubLib|OpenCorePkg/Library/OcDataHubLib/OcDataHubLib.inf
  OcDebugLogLib|OpenCorePkg/Library/OcDebugLogLib/OcDebugLogLib.inf
  OcDevicePathLib|OpenCorePkg/Library/OcDevicePathLib/OcDevicePathLib.inf
  OcDevicePropertyLib|OpenCorePkg/Library/OcDevicePropertyLib/OcDevicePropertyLib.inf
  OcDeviceTreeLib|OpenCorePkg/Library/OcDeviceTreeLib/OcDeviceTreeLib.inf
  OcDriverConnectionLib|OpenCorePkg/Library/OcDriverConnectionLib/OcDriverConnectionLib.inf
  OcFileLib|OpenCorePkg/Library/OcFileLib/OcFileLib.inf
  OcFirmwarePasswordLib|OpenCorePkg/Library/OcFirmwarePasswordLib/OcFirmwarePasswordLib.inf
  OcFirmwareVolumeLib|OpenCorePkg/Library/OcFirmwareVolumeLib/OcFirmwareVolumeLib.inf
  OcGuardLib|OpenCorePkg/Library/OcGuardLib/OcGuardLib.inf
  OcHashServicesLib|OpenCorePkg/Library/OcHashServicesLib/OcHashServicesLib.inf
  OcHdaDevicesLib|OpenCorePkg/Library/OcHdaDevicesLib/OcHdaDevicesLib.inf
  OcHeciLib|OpenCorePkg/Library/OcHeciLib/OcHeciLib.inf
  OcHiiDatabaseLocalLib|OpenCorePkg/Library/OcHiiDatabaseLib/OcHiiDatabaseLocalLib.inf
  OcInputLib|OpenCorePkg/Library/OcInputLib/OcInputLib.inf
  OcMachoLib|OpenCorePkg/Library/OcMachoLib/OcMachoLib.inf
  OcMacInfoLib|OpenCorePkg/Library/OcMacInfoLib/OcMacInfoLib.inf
  OcMemoryLib|OpenCorePkg/Library/OcMemoryLib/OcMemoryLib.inf
  OcMiscLib|OpenCorePkg/Library/OcMiscLib/OcMiscLib.inf
  OcOSInfoLib|OpenCorePkg/Library/OcOSInfoLib/OcOSInfoLib.inf
  OcPngLib|OpenCorePkg/Library/OcPngLib/OcPngLib.inf
  OcRngLib|OpenCorePkg/Library/OcRngLib/OcRngLib.inf
  OcRtcLib|OpenCorePkg/Library/OcRtcLib/OcRtcLib.inf
  OcSerializeLib|OpenCorePkg/Library/OcSerializeLib/OcSerializeLib.inf
  OcSmbiosLib|OpenCorePkg/Library/OcSmbiosLib/OcSmbiosLib.inf
  OcSmcLib|OpenCorePkg/Library/OcSmcLib/OcSmcLib.inf
  OcStorageLib|OpenCorePkg/Library/OcStorageLib/OcStorageLib.inf
  OcStringLib|OpenCorePkg/Library/OcStringLib/OcStringLib.inf
  OcTemplateLib|OpenCorePkg/Library/OcTemplateLib/OcTemplateLib.inf
  TimerLib|OpenCorePkg/Library/OcTimerLib/OcTimerLib.inf
  OcUnicodeCollationEngGenericLib|OpenCorePkg/Library/OcUnicodeCollationEngLib/OcUnicodeCollationEngGenericLib.inf
  OcUnicodeCollationEngLocalLib|OpenCorePkg/Library/OcUnicodeCollationEngLib/OcUnicodeCollationEngLocalLib.inf
  OcVirtualFsLib|OpenCorePkg/Library/OcVirtualFsLib/OcVirtualFsLib.inf
  OcXmlLib|OpenCorePkg/Library/OcXmlLib/OcXmlLib.inf
  PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
  PciCf8Lib|MdePkg/Library/BasePciCf8Lib/BasePciCf8Lib.inf
  PciLib|MdePkg/Library/BasePciLibCf8/BasePciLibCf8.inf
  PlatformHookLib|MdeModulePkg/Library/BasePlatformHookLibNull/BasePlatformHookLibNull.inf
  PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
  ReportStatusCodeLib|MdePkg/Library/BaseReportStatusCodeLibNull/BaseReportStatusCodeLibNull.inf
  PeCoffGetEntryPointLib|MdePkg/Library/BasePeCoffGetEntryPointLib/BasePeCoffGetEntryPointLib.inf
  PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
  SerialPortLib|MdeModulePkg/Library/BaseSerialPortLib16550/BaseSerialPortLib16550.inf
  ShellCommandLib|ShellPkg/Library/UefiShellCommandLib/UefiShellCommandLib.inf
  ShellLib|ShellPkg/Library/UefiShellLib/UefiShellLib.inf
  SortLib|MdeModulePkg/Library/UefiSortLib/UefiSortLib.inf
  SynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
  UefiApplicationEntryPoint|MdePkg/Library/UefiApplicationEntryPoint/UefiApplicationEntryPoint.inf
  UefiBootServicesTableLib|MdePkg/Library/UefiBootServicesTableLib/UefiBootServicesTableLib.inf
  UefiBootManagerLib|MdeModulePkg/Library/UefiBootManagerLib/UefiBootManagerLib.inf
  UefiDriverEntryPoint|MdePkg/Library/UefiDriverEntryPoint/UefiDriverEntryPoint.inf
  UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf
  UefiLib|MdePkg/Library/UefiLib/UefiLib.inf
  UefiRuntimeServicesTableLib|MdePkg/Library/UefiRuntimeServicesTableLib/UefiRuntimeServicesTableLib.inf
  UefiUsbLib|MdePkg/Library/UefiUsbLib/UefiUsbLib.inf

  !include NetworkPkg/NetworkLibs.dsc.inc

[Components]
  OcQuirks/Platform/OcQuirks/OcQuirks.inf
  OpenCorePkg/Platform/OpenRuntime/OpenRuntime.inf

[LibraryClasses]
  NULL|OpenCorePkg/Library/OcCompilerIntrinsicsLib/OcCompilerIntrinsicsLib.inf

[PcdsFixedAtBuild]
  gEfiMdePkgTokenSpaceGuid.PcdMaximumAsciiStringLength|0
!if $(TARGET) == RELEASE
  # DEBUG_PRINT_ENABLED
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|2
  # DEBUG_ERROR | DEBUG_WARN
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000002
  gEfiMdePkgTokenSpaceGuid.PcdFixedDebugPrintErrorLevel|0x80000002
!else
  # DEBUG_ASSERT_ENABLED | DEBUG_PRINT_ENABLED | DEBUG_CODE_ENABLED | CLEAR_MEMORY_ENABLED | ASSERT_DEADLOOP_ENABLED
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x2f
  # DEBUG_ERROR | DEBUG_WARN | DEBUG_INFO
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000042
  gEfiMdePkgTokenSpaceGuid.PcdFixedDebugPrintErrorLevel|0x80000042
!endif

[BuildOptions.common.EDKII.DXE_RUNTIME_DRIVER]
  GCC:*_*_*_DLINK_FLAGS = -z common-page-size=0x1000
  XCODE:*_*_*_DLINK_FLAGS = -seg1addr 0x1000 -segalign 0x1000
  XCODE:*_*_*_MTOC_FLAGS = -align 0x1000
  CLANGPDB:*_*_*_DLINK_FLAGS = /ALIGN:4096

[BuildOptions]
  # While there are no PCDs as of now, there at least are some custom macros.
  DEFINE OCPKG_BUILD_OPTIONS_GEN = -D DISABLE_NEW_DEPRECATED_INTERFACES $(OCPKG_BUILD_OPTIONS)
  DEFINE OCPKG_ANAL_OPTIONS_GEN = "-DANALYZER_UNREACHABLE=__builtin_unreachable" "-DANALYZER_NORETURN=__attribute__((noreturn))"

  GCC:DEBUG_*_*_CC_FLAGS     = -D OC_TARGET_DEBUG=1 $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN)
  GCC:NOOPT_*_*_CC_FLAGS     = -D OC_TARGET_NOOPT=1 $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN)
  GCC:RELEASE_*_*_CC_FLAGS   = -D OC_TARGET_RELEASE=1 $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN)
  MSFT:DEBUG_*_*_CC_FLAGS    = -D OC_TARGET_DEBUG=1 $(OCPKG_BUILD_OPTIONS_GEN) /wd4723
  MSFT:NOOPT_*_*_CC_FLAGS    = -D OC_TARGET_NOOPT=1 $(OCPKG_BUILD_OPTIONS_GEN) /wd4723
  MSFT:RELEASE_*_*_CC_FLAGS  = -D OC_TARGET_RELEASE=1 $(OCPKG_BUILD_OPTIONS_GEN) /wd4723
  XCODE:DEBUG_*_*_CC_FLAGS   = -D OC_TARGET_DEBUG=1 $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN)
  XCODE:NOOPT_*_*_CC_FLAGS   = -D OC_TARGET_NOOPT=1 $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN)
  XCODE:RELEASE_*_*_CC_FLAGS = -D OC_TARGET_RELEASE=1 $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -Oz -flto
