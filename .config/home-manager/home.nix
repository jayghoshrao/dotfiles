# Updating this stack
# --------------------
#   nix flake update            # bump every input in flake.lock
#   nix flake update nixpkgs    # bump just one input (pinned tools stay put)
#   hh                          # rebuild + activate (home-manager switch)
#
# Shell shortcuts (defined in ~/.zshrc):
#   hhu [input]   update inputs then switch  (no arg = all inputs)
#   hhr           roll back to previous generation
#   hg            list generations
#
# Pinning: inputs whose URL names a commit (whisrs, tsync deps via commit)
# won't advance on `nix flake update`; nixpkgs tracks nixpkgs-unstable and
# moves freely. Commit flake.lock after a successful switch.
#
# tsync's Python deps are locked independently of the flake: edit
# pkgs/tsync/pyproject.toml and run `uv lock` there to bump them, then hh.
#
# Rollback also works manually: `hg` to list, then run the chosen
# /nix/store/...-home-manager-generation/activate script.

{ config, pkgs, system, nixgl, llm-agents, whisrs, uv2nix, pyproject-nix, build-system-pkgs, lathe-src, ... }:

let
  # nixGL packages come from the flake input; pinned via flake.lock.
  nixglPkgs = nixgl.packages.${system};

  # Wrap every binary in a package so it launches through nixGL,
  # while keeping share/ (desktop files, icons, terminfo) intact.
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    for bin in ${pkg}/bin/*; do
      makeWrapper ${nixglPkgs.nixGLIntel}/bin/nixGLIntel "$out/bin/$(basename "$bin")" \
        --add-flags "$bin"
    done
    for sub in $(ls ${pkg} | grep -v '^bin$'); do
      ln -s ${pkg}/$sub $out/$sub
    done
  '';

  # Like nixGLWrap but also passes --no-sandbox, required for Electron apps whose
  # chrome-sandbox binary cannot be chowned to root in the immutable Nix store.
  nixGLWrapElectron = pkg: pkgs.runCommand "${pkg.name}-nixgl" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    for bin in ${pkg}/bin/*; do
      makeWrapper ${nixglPkgs.nixGLIntel}/bin/nixGLIntel "$out/bin/$(basename "$bin")" \
        --add-flags "$bin" \
        --append-flags "--no-sandbox"
    done
    for sub in $(ls ${pkg} | grep -v '^bin$'); do
      ln -s ${pkg}/$sub $out/$sub
    done
  '';
  # NVIDIA ai-pim-utils CLI suite (repackaged from the official release archive).
  # See ./pkgs/ai-pim-utils.nix for the update procedure.
  ai-pim-utils = pkgs.callPackage ./pkgs/ai-pim-utils.nix { };
  lathe = pkgs.callPackage ./pkgs/lathe.nix { src = lathe-src; };
  tsync = pkgs.callPackage ./pkgs/tsync.nix { inherit uv2nix pyproject-nix build-system-pkgs; };
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
    nix-direnv
    cachix
    neovim
    gnupg
    hello
    nix-info 
    autorandr
    python3
    uv
    nix-search-cli
    yazi
    fzf
    tmux
    lazygit
    nnn
    ripgrep
    xclip
    xsel
    xdotool
    font-awesome
    moreutils
    snixembed
    pavucontrol
    scrot
    # dunst
    playerctl
    pdd
    # gcc
    file
    pass
    mise

    # autojump
    # zoxide
    shellcheck
    tree-sitter

    glab

    aerc
    notmuch
    isync # mbsync

    mpv
    yt-dlp
    alsa-utils

    ai-pim-utils
    lathe
    tsync
    whisrs.packages.${system}.default

    # claude-code
    # codex
    llm-agents.packages.${system}.rtk
    llm-agents.packages.${system}.claude-code
    llm-agents.packages.${system}.codex
    llm-agents.packages.${system}.ccusage
    llm-agents.packages.${system}.tuicr
    bubblewrap
    socat

    # zsh
    
    (nixGLWrap kitty)
    (nixGLWrap zathura)
    (nixGLWrapElectron obsidian)
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

  # Bridge StatusNotifierItem (SNI) tray icons into i3bar's XEmbed tray.
  # i3bar only speaks the legacy XEmbed systemtray protocol, while modern apps
  # (e.g. whisrs) publish via SNI / org.kde.StatusNotifierWatcher. snixembed
  # registers as the watcher and proxies SNI items into the XEmbed tray.
  # Bound to default.target (not graphical-session.target, which is inactive
  # under this GDM-launched i3 session). The user manager already carries
  # DISPLAY/XAUTHORITY, so snixembed reaches the X server without PassEnvironment.
  systemd.user.services.snixembed = {
    Unit.Description = "Proxy StatusNotifierItems as XEmbed systemtray icons";
    Service = {
      ExecStart = "${pkgs.snixembed}/bin/snixembed";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "default.target" ];
  };

  # whisrs voice-dictation daemon.
  # The Nix-built whisrs links its own alsa-lib, which ships no plugin dir, so
  # it cannot load libasound_module_pcm_pipewire.so to open the "default"
  # (PipeWire-routed) capture device. ALSA_PLUGIN_DIR points it at the matching
  # Nix PipeWire ALSA plugin. Computing the path from ${pkgs.pipewire} keeps it
  # correct across rebuilds (the whisrs flake follows this nixpkgs, so this is
  # the same pipewire). Bound to default.target like snixembed above, since
  # graphical-session.target is inactive under this GDM-launched i3 session.
  systemd.user.services.whisrs = {
    Unit = {
      Description = "whisrs dictation daemon";
      Documentation = "https://github.com/whisrs/whisrs";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${whisrs.packages.${system}.default}/bin/whisrsd";
      Restart = "on-failure";
      RestartSec = 3;
      Environment = "ALSA_PLUGIN_DIR=${pkgs.pipewire}/lib/alsa-lib";
      # Import compositor environment so window tracking works.
      PassEnvironment = "HYPRLAND_INSTANCE_SIGNATURE NIRI_SOCKET SWAYSOCK WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP XDG_RUNTIME_DIR";
    };
    Install.WantedBy = [ "default.target" ];
  };

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
