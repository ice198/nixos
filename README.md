# NixOS Installation Guide
 
## 1. Download NixOS
 
Download the `Minimal ISO image` from the [NixOS download page](https://nixos.org/download/).
 
---
 
## 2. Create a Live USB
 
If you are on a Linux distro, refer to the section on creating a live USB from the CLI on Linux.
For other operating systems or if you prefer a GUI, [balenaEtcher](https://etcher.balena.io/#download-etcher) is a good option.
On Windows, [Rufus](https://rufus.ie/) is also well known.
 
---
 
## 3. Install
 
Boot from the live USB and launch **NixOS Installer (Linux LTS)**.
 
### Partition the Disk
 
```sh
sudo -i        # Switch to root user
lsblk          # Check disk names
cfdisk /dev/XXX  # Replace XXX with the name of the target disk
```
 
- Select `gpt` for **Select label type**
- Select `New` → set **Partition size** to `1G` → select `Type` → set to `EFI System`
- Select `New` on free space → set **Partition size** to `4G` → select `Type` → set to `Linux swap`
- Select `New` on free space → press Enter twice to use the remaining space as the root partition
- Select `Write`, type `yes`, then select `Quit`
### Format and Mount
 
```sh
lsblk                          # Verify partitions were created correctly
mkfs.ext4 -L nixos /dev/XXX3   # Format root partition
mkswap -L swap /dev/XXX2        # Initialize swap
mkfs.fat -F 32 -n boot /dev/XXX1  # Format boot partition
 
# Mount
mount /dev/XXX3 /mnt            # Root partition
mount --mkdir /dev/XXX1 /mnt/boot  # Boot partition
swapon /dev/XXX2                # Swap
lsblk                          # Verify
 
nixos-generate-config --root /mnt  # Generate NixOS config files
vim /mnt/etc/nixos/configuration.nix
```
 
### Edit `configuration.nix`
 
```nix
# Only the sections that need to be changed
networking.hostName = "nixos";
 
time.timeZone = "Asia/Tokyo";
 
# Replace "name" with your username
users.users.name = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
        tree
    ];
  };
 
services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
};
 
programs.firefox.enable = true;
programs.niri.enable = true;
 
environment.systemPackages = with pkgs; [
    helix
    wget
    alacritty
    git
];
```
 
### Run the Installer
 
```sh
nixos-install
```
 
When prompted with `New password:`, set a password for root.
 
```sh
nixos-enter --root /mnt -c 'passwd name'
# Enter the password you want to set
reboot
```
 
---
 
## 4. Customize
 
```sh
sudo rm -rf /etc/nixos
sudo git clone https://github.com/ice198/nixos.git /etc/nixos
```
 
### Edit `configuration.nix`
 
```nix
# Replace "name" with your username
users.users.name = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };
```
 
### Edit `flake.nix`
 
```nix
# Replace "name" with your username
users.name = { pkgs, ... }: {
  imports = [ ./home.nix ];
};
```
 
### Edit `home.nix`
 
```nix
# Replace "name" with your username
home.username = "name";
home.homeDirectory = "/home/name";
 
# Replace name and email with your own
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
 
# Change "name" in the niri config below to your username
spawn-at-startup "/home/name/.local/bin/eww-start"
 
# Set your monitor resolution, refresh rate, and scale
output "eDP-1" {
  mode "1920x1080@120.030"
  scale 2
  transform "normal"
  position x=1280 y=1
}
```
 
### Build
 
Run the following commands to build:
 
```sh
su
cd /etc/nixos
nixos-generate-config
git config --global user.name "myname"
git config --global user.email "myname@gmail.com"
git add .
git commit -m "first commit"
nixos-rebuild switch --flake /etc/nixos#nixos
reboot
```
