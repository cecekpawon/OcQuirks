#!/bin/bash

# @cecekpawon - Mon Aug 31 02:53:04 2020
# To copy "OpenCorePkg.dsc" and adjust to "OcQuirks.dsc"
# Usage: ./cpdsc.sh <path-to-OpenCorePkg.dsc> <path-to-OcQuirks.dsc>

SCRIPT_OC_PATH="$1"
SCRIPT_DSC_PATH="$2"

[ -f "${SCRIPT_OC_PATH}" ] || exit 1
[ -z "${SCRIPT_DSC_PATH}" ] && exit 1

# https://stackoverflow.com/a/32170281

cat "${SCRIPT_OC_PATH}" | \
awk 'x&&/\[LibraryClasses\]/{print \
"  OpenCorePkg/Platform/OpenRuntime/OpenRuntime.inf\
  OcQuirks/Platform/OcQuirks/OcQuirks.inf\
";x=0} !x; /\[Components\]/{x=1}' > "${SCRIPT_DSC_PATH}"
