{
  description = "NixiOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #dms = {
    #  url = "github:AvengeMedia/DankMaterialShell/stable";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    awww.url = "git+https://codeberg.org/LGFae/awww";

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.sam = { pkgs, ... }: {
              imports = [
                ./home.nix
                # 👇 ironbar の Home Manager module を追加
                inputs.ironbar.homeManagerModules.default
              ];

	      programs.ironbar = {
                enable = true;
                systemd = true;

                config = {
                  monitors = {
                    DP-1 = {
                      anchor_to_edges = true;
                      position = "top";
                      height = 24;

                      start = [
                        { type = "clock"; }
                      ];

                      end = [
                        { type = "tray"; icon_size = 16; }
                      ];
                    };
                  };
                };

                style = ''
                  * {
                    font-family: Noto Sans Nerd Font, sans-serif;
                    font-size: 16px;
                  }
                '';

                package = inputs.ironbar.packages.${pkgs.system}.default;
              };
            };

	    extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  };
}
