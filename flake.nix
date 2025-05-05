{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, ... }:
        {
          packages = {
            brother-mfcl8390cdw = pkgs.callPackage ./drivers/brother-mfcl8390cdw.nix { };
            # packageB = pkgs.callPackage ./pkgs/packageB { };
          };
        };
    };
}
