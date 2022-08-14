{ mkSysExt
, msr-tools
, neofetch
, neovim
, reshade-shaders
, vkBasalt
, x86_energy_perf_policy
, osVersion
}:

mkSysExt {
  name = "steamos-utils";
  osId = "steamos";
  inherit osVersion;
  packages = [
    { drv = msr-tools; path = "bin/rdmsr"; }
    { drv = msr-tools; path = "bin/wrmsr"; }
    { drv = neofetch; path = "bin/neofetch"; }
    { drv = neovim; path = "bin/nvim"; prefix = "usr"; }
    { drv = reshade-shaders; prefix = "opt"; path = "share/reshade"; destpath = "reshade"; }
    { drv = vkBasalt; path = "share/vulkan/implicit_layer.d/vkBasalt.json"; }
    { drv = vkBasalt; path = "share/vulkan/implicit_layer.d/vkBasalt32.json"; }
    { drv = x86_energy_perf_policy; path = "bin/x86_energy_perf_policy"; }
  ];
}
