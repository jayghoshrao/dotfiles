{ config, pkgs, ... }:

let
  # Pin to a commit for reproducibility (grab the latest from the repo).
  nixgl = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/nixGL/archive/main.tar.gz";
    # sha256 = "...";  # add after first build: nix will print the expected hash
  }) { inherit pkgs; };

  # Wrap every binary in a package so it launches through nixGL,
  # while keeping share/ (desktop files, icons, terminfo) intact.
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    for bin in ${pkg}/bin/*; do
      makeWrapper ${nixgl.nixGLIntel}/bin/nixGLIntel "$out/bin/$(basename "$bin")" \
        --add-flags "$bin"
    done
    for sub in $(ls ${pkg} | grep -v '^bin$'); do
      ln -s ${pkg}/$sub $out/$sub
    done
  '';
  # NVIDIA ai-pim-utils CLI suite (repackaged from the official release archive).
  # See ./pkgs/ai-pim-utils.nix for the update procedure.
  ai-pim-utils = pkgs.callPackage ./pkgs/ai-pim-utils.nix { };
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jayghoshsubo";
  home.homeDirectory = "/home/jayghoshsubo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    nix-direnv
    cachix
    neovim
    hello
    nix-info 
    autorandr
    python3
    nix-search-cli
    claude-code
    yazi
    fzf
    tmux
    lazygit
    nnn
    ripgrep
    xclip
    xsel
    font-awesome
    moreutils
    ai-pim-utils
    # zsh
    (nixGLWrap kitty)
    (nixGLWrap zathura)
    (nixGLWrap obsidian)

    (nixGLWrap v4l-utils)

    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jayghoshsubo/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
