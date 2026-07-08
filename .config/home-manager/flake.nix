{
  description = "jayghoshsubo home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AI tools flake — do NOT add inputs.nixpkgs.follows here;
    # it would break binary cache hits from cache.numtide.com.
    llm-agents.url = "github:numtide/llm-agents.nix";

    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";

    whisrs = {
      url = "github:y0sif/whisrs/19da7ab0e6f2c0af4bc34291e439ca363d3489c2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    build-system-pkgs = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not a flake upstream; tracked via flake.lock against main so
    # `nix flake update` bumps it like any other input.
    lathe = {
      url = "github:devenjarvis/lathe/main";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  outputs = { nixpkgs, home-manager, nixgl, llm-agents, whisrs, uv2nix, pyproject-nix, build-system-pkgs, lathe, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "claude-code"
          "obsidian"
        ];
      };
    in {
      homeConfigurations."jayghoshsubo" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit system nixgl llm-agents whisrs uv2nix pyproject-nix build-system-pkgs;
          lathe-src = lathe;
        };
        modules = [ ./home.nix ];
      };
    };
}
