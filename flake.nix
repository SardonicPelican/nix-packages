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
      ];
      perSystem =
        { pkgs, ... }:
        {
          packages = {
            brother-mfc-l8390cdw = pkgs.callPackage ./drivers/brother-mfc-l8390cdw.nix { };
            gamescope_3_16_2 = pkgs.callPackage ./pkgs/gamescope_3.16.2/package.nix { };
            # packageB = pkgs.callPackage ./pkgs/packageB { };
          };
        };
    };
}
