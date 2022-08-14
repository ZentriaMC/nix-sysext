{
  description = "nix-sysext";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      lib = {
        mkSysExt = import ./make-sysext.nix;
      } // nixpkgs.lib.genAttrs supportedSystems (system: {
        mkSysExt = args@{ name, packages, osId, ... }: nixpkgs.legacyPackages.${system}.callPackage (self.lib.mkSysExt args) { };
      });

      packages = nixpkgs.lib.genAttrs supportedSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          reshade-shaders = pkgs.callPackage ./examples/reshade-shaders.nix { };
          exampleExt = pkgs.callPackage ./examples/steamos-utils.nix {
            inherit (self.lib.${system}) mkSysExt;
            inherit (pkgs.linuxPackages) x86_energy_perf_policy;
            inherit (self.packages.${system}) reshade-shaders;
            osVersion = "3.3.1"; # required by systemd-sysext. See /etc/os-release
          };
        });
    };
}
