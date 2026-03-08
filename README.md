My NixOS development environment

```sh
sudo rm -rf /etc/nixos
sudo git clone https://github.com/ice198/nixos.git /etc/nixos
```

Modify `configuration.nix`
```nix
# Replace name with your username
users.users.name = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };
```

Modify `flake.nix`
```nix
# Replace name with your username
users.name = { pkgs, ... }: {
  imports = [ ./home.nix ];
};
```

Modify `home.nix`
```nix
# Replace name with your username
home.username = "name";
home.homeDirectory = "/home/name";

# Replace the name and email address with your own
programs.git = {
  enable = true;
  settings = {
    user = {
      name = "name";
      email = "name@gmail.com";
    };
    init.defaultBranch = "main";
  };
};

# Change the screen resolution, refresh rate, and magnification in niri config to those of your monitor.
output "eDP-1" {
  mode "1920x1080@120.030"
  scale 2
  transform "normal"
  position x=1280 y=1
}
```
