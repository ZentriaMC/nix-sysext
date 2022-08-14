{ mkSysExt
, age
, neofetch
, yq
, osVersion
}:

mkSysExt {
  name = "ubuntu-utils";
  osId = "ubuntu";
  inherit osVersion;
  packages = [
    { drv = age; path = "bin/age"; }
    { drv = neofetch; path = "bin/neofetch"; }
    { drv = yq; path = "bin/yq"; }
  ];
}
