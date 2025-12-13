# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  #HACK to reduce memory usage of nixpkgs-review
  nixpkgs.overlays = [
    (final: prev: {
      nixpkgs-review = prev.nixpkgs-review.overrideAttrs (old: {
        version = "3.5.1";
        src = pkgs.fetchFromGitHub {
          owner = "Mic92";
          repo = "nixpkgs-review";
          rev = "pull/568/head";
          hash = "sha256-HC2HyAHRgNHDOHUSFzeoYLOLD3ltX+EMWE+kr5RLx8c=";
        };
      });
    })
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  #Integrate with Docker Desktop on Windows
  wsl.docker-desktop.enable = true;
  users.users.nixos.extraGroups = [ "docker" ];

  #Speed up autotools ./configure
  wsl.interop.includePath = false;

  # I use a custom resolv.conf so I don't want WSL generating it for me.
  # The generated resolv.conf breaks networking in WSL even though the host networking works.
  wsl.wslConf.network.generateResolvConf = false;
  networking.resolvconf.enable = false; # Turn off resolvconf systemd service

  #Enable OpenGL
  hardware.graphics.enable = true;

  #Necessary for VSCode
  programs.nix-ld.enable = true;

  documentation.dev.enable = true;

  nix.extraOptions = ''
  experimental-features = nix-command flakes
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    #Fuzzing
    aflplusplus
    patchelf # To run NixOS executables in Docker

    #Building
    clang
    lld #Fast linker
    gcc
    cmake
    scons
    gnumake
    autoconf
    automake

    man-pages
    man-pages-posix

    #Utilities
    silver-searcher
    git
    neovim
    wget # VSCode needs this to download updates
    universal-ctags #Jump to functions in (n)vim

    #Programming languages
    python3
    ruby #for rondevera/twig

    #Static analysis
    ##Cyclomatic complexity
    python3Packages.lizard
    flawfinder

    nixpkgs-review
  ];
}
