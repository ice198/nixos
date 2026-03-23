NixOSをインストールする手順をまとめたもの
## 1. NixOSをダウンロード
[NixOSのダウンロードページ](https://nixos.org/download/)から`Minimal ISO image`をダウンロード

## 2. Live USBを作成
Linuxディストロを使っている場合は[[LinuxでCLIからライブUSBを作成する]]を参照。その他のOSを使ってる人やGUIで作業したい場合は[balenaEtcher](https://etcher.balena.io/#download-etcher)を使うと良い。Windowsだと[Rufus](https://rufus.ie)も有名。

## 3. インストール
ライブUSBを読み込んでNixOS Installer(Linux LTS)を起動
```sh
sudo -i  # ルートユーザーに移動
lsblk  # ディスクの名前を確認
cfdisk /dev/XXX  # XXXにはインストール先のディスク名を指定
```
`Select label type`は`gpt`を選択

`New`を選択して`Partition size`を1Gに設定
`Type`を選択して`EFI System`に設定

`Free space`の`New`を選択して`Partition size`を4Gに設定
`Type`を選択して`Linux swap`に設定

`Free space`の`New`を選択してエンターキーを2回押し、残りのスペースをルートパーティションに使用

`Write`を選択し、`yes`と入力
`Quit`を選択して終了

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
networking.hostName = "nixos";

time.timeZone = "Asia/Tokyo";

# nameの部分は自分の名前に置き換える
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

```sh
nixos-install
```

`New password:`と表示されるのでパスワードを設定
```sh
nixos-enter --root /mnt -c 'passwd name'  
# 設定したパスワードを入力
reboot
```

## 4. カスタム

```sh
sudo rm -rf /etc/nixos
sudo git clone https://github.com/ice198/nixos.git /etc/nixos
```

`configuration.nix`を書き換える
```nix
# nameの部分を自分の名前に書き換える
users.users.name = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };
```

`flake.nix`を書き換える
```nix
# nameの部分を自分の名前に書き換える
users.name = { pkgs, ... }: {
  imports = [ ./home.nix ];
};
```

`home.nix`を書き換える
```nix
# nameの部分を自分の名前に書き換える
home.username = "name";
home.homeDirectory = "/home/name";

# nameとemailを自分のものに書き換える
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

# niri configの以下のnameを自分の名前に変更
spawn-at-startup "/home/name/.local/bin/eww-start"

# モニターの解像度、リフレッシュレート、拡大率を設定
output "eDP-1" {
  mode "1920x1080@120.030"
  scale 2
  transform "normal"
  position x=1280 y=1
}
```

以下のコマンドを実行してビルド
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

---
以下、雑記

壁紙は[このリポジトリ](https://github.com/basecamp/omarchy/blob/master/themes/everforest/backgrounds/1-tree-tops.jpg)からダウンロードした。他にも[Omarchy hub](https://omarchy.deepakness.com/themes)にはよさげなものがたくさんあった。

壁紙はawwwを使って表示しているが、niriのオーバービュー時の壁紙はブラーをかけた背景を作成して別に設定する必要がある。imagemagickで壁紙にブラーをかけるコマンドは以下
```sh
magick input.jpg -gaussian-blur 0x8 output.jpg
```

壁紙を変更するには`/etc/nixos/wallpaper.jpg`と`/etc/nixos/blur-wallpaper.jpg`を以下のコマンドで置き換える
```sh
sudo cp ~/Desktop/wallpaper.jpg /etc/nixos/
sudo cp ~/Desktop/blur-wallpaper.jpg /etc/nixos/
```
