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
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.loader.timeout = 0; # Hide generation

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # firewallを開放
  networking.firewall.allowedTCPPorts = [
    5173
    3000
  ];

  # MariaDB
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "testdb" ];
    ensureUsers = [
      {
        name = "testuser";
        ensurePermissions = {
          "testdb.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.opencl.enable = true;
  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };

  # For Nautilus
  services.gvfs.enable = true;

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

  # Login Manager
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/etc/nixos/wallpaper.jpg";
        fit = "Cover";
      };
    };
  };

  # Window Manager
  programs.niri.enable = true;

  # or GNOME
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;
  #services.gnome.core-apps.enable = false;
  #services.gnome.core-developer-tools.enable = false;
  #services.gnome.games.enable = false;

  # lock screen
  programs.hyprlock.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # User
  users.users.apotail = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };

  # For steam
  programs.xwayland.enable = true;

  # Apps
  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;
  documentation.nixos.enable = false; # Hide document
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    wayland
    pulseaudio
    helix
    wget
    curl
    git
    ripgrep
    btop
    fastfetch
    nautilus
    nodejs
    pnpm
    yaru-theme
    gnome-text-editor
    gnome-calculator
    gnome-system-monitor
    gnome-disk-utility
    gnome-characters
    gnome-font-viewer
    loupe
    evince
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    imagemagick
    eww
    lm_sensors
    jq
    gcc
    wine64
    steam-run
    amberol
  ];

  # LLM
  services.ollama = {
    enable = true;
    loadModels = [
      "llama3.2:3b"
      "deepseek-r1:14b"
    ];
  };

  # Set dafault Apps
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
    "application/pdf" = "org.gnome.Evince.desktop";
    "image/png" = "org.gnome.Loupe.desktop";
    "image/jpeg" = "org.gnome.Loupe.desktop";
    "image/jpg" = "org.gnome.Loupe.desktop";
    "image/gif" = "org.gnome.Loupe.desktop";
    "image/bmp" = "org.gnome.Loupe.desktop";
    "image/tiff" = "org.gnome.Loupe.desktop";
    "image/webp" = "org.gnome.Loupe.desktop";
    "audio/wav" = [ "amberol.desktop" ];
    "audio/x-wav" = [ "amberol.desktop" ];
    "audio/mpeg" = [ "amberol.desktop" ];
    "audio/mp3" = [ "amberol.desktop" ];
    "audio/flac" = [ "amberol.desktop" ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      roboto
      inter
      google-fonts
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
