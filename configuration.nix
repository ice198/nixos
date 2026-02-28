{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    #inputs.noctalia.nixosModules.default
    #inputs.dms.nixosModules.dank-material-shell
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.kernelParams = [ "quiet" ];
  boot.loader.timeout = 0; # Hide generation

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # For Noctalia shell
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # For Nautilus
  services.gvfs.enable = true;

  # Install Gnome Apps
  #services.gnome.core-apps.enable = true;

  time.timeZone = "Asia/Tokyo";

  # Enable Japanese
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };
  #i18n.defaultLocale = "en_US.UTF-8";
  i18n = {
    supportedLocales = [
      "ja_JP.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF8";
      LC_ADDRESS = "en_US.UTF8";
      LC_IDENTIFICATION = "en_US.UTF8";
      LC_MEASUREMENT = "en_US.UTF8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF8";
      LC_NAME = "en_US.UTF8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF8";
      LC_TELEPHONE = "en_US.UTF8";
      LC_TIME = "en_US.UTF8";
      LC_COLLATE = "en_US.UTF8";
    };
  };

  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "jp106";
  };

  # Dank Linux
  #programs.dms-shell = {
  #enable = true;

  #systemd = {
  #  enable = true;             # Systemd service for auto-start
  #  restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
  #};

  # Core features
  #enableSystemMonitoring = true;     # System monitoring widgets (dgop)
  #enableClipboard = true;            # Clipboard history manager
  #enableVPN = true;                  # VPN management widget
  #enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
  #enableAudioWavelength = true;      # Audio visualizer (cava)
  #enableCalendarEvents = true;       # Calendar integration (khal)
  #};

  programs.regreet.enable = true;
  programs.niri.enable = true;

  # lock screen
  programs.hyprlock.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.sam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };

  # For steam
  programs.xwayland.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;
  documentation.nixos.enable = false; # Hide document
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    helix
    wget
    curl
    git
    ripgrep
    btop
    fastfetch
    godot
    nautilus
    nodejs
    pnpm
    spotify
    blender
    proton-pass
    inkscape
    discord-ptb
    signal-desktop
    obsidian
    davinci-resolve
    yaru-theme
    gnome-calculator
    gnome-system-monitor
    gnome-disk-utility
    gnome-characters
    gnome-font-viewer
    libreoffice-qt
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    imagemagick
    eww
    lm_sensors
    jq
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      roboto
    ];

    fontDir.enable = true;

    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
