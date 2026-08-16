{
  description = "system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = {nixpkgs, nixos-wsl, ...}: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nixos-wsl.nixosModules.default {
            system.stateVersion = "24.11";
            wsl.enable = true;
          }
        ];
      };
    };
  };
}
