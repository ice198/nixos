{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Launcher
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    # Wallpaper
    awww.url = "git+https://codeberg.org/LGFae/awww";
    # niri
    niri.url = "github:sodiboo/niri-flake";
    # Codex CLI
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      niri,
      codex-cli-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # NixOS system configuration
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          niri.nixosModules.niri
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.apotail = import ./home.nix;
            };
          }
        ];
      };

      # Dev shell with Codex CLI
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          codex-cli-nix.packages.${system}.default
        ];
      };
    };
}
