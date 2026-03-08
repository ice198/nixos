My development environment

## 1. NixOSをダウンロード
[NixOSのダウンロードページ](https://nixos.org/download/)から`Minimal ISO image`をダウンロード

## 2. balenaEtcherをダウンロード
[balenaEtcher](https://etcher.balena.io/#download-etcher)から`Etcher`をダウンロード

## 3. Live USBを作成
Etcherを使ってNixOS isoファイルをUSBに焼く

## 4. インストール
ライブUSBを読み込んでNixOS Installer(LTS)を起動
```sh
sudo -i  # ルートユーザーに移動
lsblk  # ディスクの名前を確認
cfdisk /dev/XXX  # XXXにはインストール先のディスク名を指定
```
Select label typeはgptを選択

Newを選択してPartition sizeを1Gに設定
Typeを選択してEFI Systemに設定

Free spaceのNewを選択してPartition sizeを4Gに設定
Typeを選択してLinux swapに設定

Free spaceのNewを選択してエンターキーを2回押し、残りのスペースをルートパーティションに使用

Writeを選択し、yesと入力
Quitを選択して終了

```sh
lsblk  # 正しくパーティションを作成できてるか確認
mkfs.ext4 -L nixos /dev/XXX3  # ルートパーティションを初期化
mkswap -L swap /dev/XXX2  # スワップ領域を初期化
mkfs.fat -F 32 -n boot /dev/XXX1  # ブートパーティションを初期化

# マウント
mount /dev/XXX3 /mnt  # ルートパーティション
mount --mkdir /dev/XXX1 /mnt/boot  # ブートパーティション
swapon /dev/XXX2  # スワップ
lsblk  # 確認

nixos-generate-config --root /mnt  # NixOSの設定ファイルを作成
vim /mnt/etc/nixos/configuration.nix
```

configuration.nixを編集
```nix
# 変更箇所のみ
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

networking.hostName = "nixos";
networking.networkmanager.enable = true;
 
time.timeZone = "Asia/Tokyo";

# 名前を変更して有効化
users.users.name = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
        tree
    ];
  };
 
# Login Manager
services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
};
  
programs.firefox.enable = true;  # 有効化
programs.niri.enable = true;

# アプリを追加
environment.systemPackages = with pkgs; [
    helix
    wget
    ghostty
    git
];

system.stateVersion = "26.05";
```

```sh
nixos-install
```

`New password:`と表示されるのでパスワードを設定
```sh
nixos-enter --root /mnt -c 'passwd name'  # 設定したパスワードを入力
reboot
```

---


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

And build
```sh
nixos-rebuild switch --flake /etc/nixos#nixos
reboot
```

```sh
# Wallpaper
# https://github.com/basecamp/omarchy/blob/master/themes/everforest/backgrounds/1-tree-tops.jpg

# blur wallpaper command
# magick input.jpg -gaussian-blur 0x8 output.jpg

# and copy
# sudo cp ~/Desktop/wallpaper.jpg /etc/nixos/
```
