# NixOS Installation Guide
 
## 1. Download NixOS
 
Download the `Minimal ISO image` from the [NixOS download page](https://nixos.org/download/).
 
## 2. Create a Live USB

1. Check the USB drive name with `lsblk`

```sh
lsblk
```
The output will look like this:
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    1  14.5G  0 disk
├─sda1        8:1    1   1.5G  0 part 
└─sda2        8:2    1     3M  0 part
nvme0n1     259:0    0 500.0G  0 disk
```
In this case, sda is the USB drive.

2. Unmount the USB
```sh
sudo umount -l /dev/sda1
sudo umount -l /dev/sda2
```

3. Write the ISO file
```sh
sudo dd if=/home/user/Downloads/xxxxx.iso of=/dev/sda bs=4M status=progress conv=fsync
```

4. Remove the drive when done

## 3. Install
 
Boot from the live USB and launch **NixOS Installer (Linux LTS)**.
 
1. Partition the Disk
 
```sh
sudo -i          # Switch to root user
lsblk            # Check disk names
cfdisk /dev/XXX  # Replace XXX with the name of the target disk
```
 
- Select `gpt` for **Select label type**
- Select `New` → set **Partition size** to `1G` → select `Type` → set to `EFI System`
- Select `New` on free space → set **Partition size** to `4G` → select `Type` → set to `Linux swap`
- Select `New` on free space → press Enter twice to use the remaining space as the root partition
- Select `Write`, type `yes`, then select `Quit`

2. Format and Mount
 
```sh
lsblk  # Verify partitions were created correctly

mkfs.btrfs -L nixos /dev/XXX3
mkswap -L swap /dev/XXX2
mkfs.fat -F 32 -n boot /dev/XXX1
 
mount /dev/XXX3 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt

mount -o subvol=@,compress=zstd,noatime /dev/XXX3 /mnt
mount --mkdir -o subvol=@home,compress=zstd,noatime /dev/XXX3 /mnt/home
mount --mkdir /dev/XXX1 /mnt/boot
swapon /dev/XXX2

lsblk

nixos-generate-config --root /mnt  # Generate NixOS config files
vim /mnt/etc/nixos/configuration.nix
```
 
### Edit `configuration.nix`
 
```nix
# Only the sections that need to be changed
networking.hostName = "nixos";
 
time.timeZone = "Asia/Tokyo";

fileSystems."/" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "btrfs";
  options = [ "subvol=@" "compress=zstd" "noatime" ];
};

fileSystems."/home" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "btrfs";
  options = [ "subvol=@home" "compress=zstd" "noatime" ];
};
 
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
