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
        mkSysExt = args@{ name, packages }: nixpkgs.legacyPackages.${system}.callPackage (self.lib.mkSysExt args) { };
      });
    };
}
