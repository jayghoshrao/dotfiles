{ pkgs, uv2nix, pyproject-nix, build-system-pkgs }:

let
  workspace = uv2nix.lib.workspace.loadWorkspace {
    workspaceRoot = ./tsync;
  };

  overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

  python = pkgs.python313;

  pythonSet = pkgs.callPackage pyproject-nix.build.packages { inherit python; };

  pythonSetOverridden = pythonSet.overrideScope (
    pkgs.lib.composeManyExtensions [
      build-system-pkgs.overlays.default
      overlay
    ]
  );

  venv = pythonSetOverridden.mkVirtualEnv "tsync-env" workspace.deps.default;
in
  pkgs.writeShellScriptBin "tsync" ''
    export LD_LIBRARY_PATH="${pkgs.file}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec ${venv}/bin/tsync "$@"
  ''
