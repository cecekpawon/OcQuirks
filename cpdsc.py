#!/usr/bin/env python

# @cecekpawon - 8/31/2020 3:29:59 PM

# Copy and adjust "OpenCorePkg.dsc" to "OcQuirks.dsc"
# Usage: ./cpdsc.py <path-to-OpenCorePkg.dsc>

import os, re, sys

components_str = """
  OpenCorePkg/Platform/OpenRuntime/OpenRuntime.inf
  OcQuirks/Platform/OcQuirks/OcQuirks.inf

"""

if len(sys.argv) != 2:
  print("{} <path-to-OpenCorePkg.dsc>".format(sys.argv[0]))
  exit()

opencorepkg_dsc = sys.argv[1]

if not os.path.exists(opencorepkg_dsc):
  print ("{} not exist".format(opencorepkg_dsc))
  exit()

with open(opencorepkg_dsc, "r" ) as f:
  content = f.read()
  content = (re.sub(r"(PLATFORM_NAME.*)(=.*[a-zA-Z]+)", r"\1= OcQuirks", content, flags=re.M))
  content = (re.sub(r"(PLATFORM_GUID.*)(=.*[\-\da-zA-Z]+)", r"\1= F68E7A14-7521-4698-AE3B-9EF553F892EB", content, flags=re.M))
  content = (re.sub(r"(\[Components\]).*(\[LibraryClasses\])", r"\1" + components_str + r"\2", content, flags=re.DOTALL | re.M))
  f.close()

with open("OcQuirks.dsc", "w+" ) as f:
  f.write(content)
  f.close()
