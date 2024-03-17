{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jayghoshter";
  home.homeDirectory = "/home/jayghoshter";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # nixpkgs.overlays = [];

  home.packages = with pkgs; [ 
    nix-direnv
    cachix

    vscode-extensions.ms-vscode.cpptools

    neomutt
    # rr

    # glibc
    gmsh_with_libs
    comma
    ffsend

    nix-info

    # Global python packages for my scripts
    (python311.withPackages(ps: with ps; [ 
      argcomplete
      beautifulsoup4
      deepdiff
      gpgme
      i3-py
      i3ipc
      icalendar # For use with mutt-ics
      ipython 
      joblib
      lz4
      magic
      markdownify
      numpy
      pip
      pdfrw
      plumbum
      pulsectl
      pyfzf
      pygithub
      python-gnupg
      requests
      rich
      ruamel_yaml
      scipy
      spotipy
      wget
      xdg
    ]))

  ];

  programs.bat.enable = true;

  targets.genericLinux.enable = true;

}
