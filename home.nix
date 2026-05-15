{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  home.username = "apotail";
  home.homeDirectory = "/home/apotail";
  home.stateVersion = "26.05";

  # Notification
  services.dunst = {
    enable = true;

    settings = {
      global = {
        font = "Noto Sans";
        corner_radius = 12;
        frame_width = 1;
        padding = 16;
        horizontal_padding = 16;
        icon_size = 48;
        origin = "top-right";
        offset = "8x35";
        width = 350;
        height = 300;
        transparency = 10;
        stack_duplicates = false;
        gap_size = 5;
        notification_limit = 12;
        show_indicators = false;
        icon_corner_radius = 6;
      };

      urgency_low = {
        background = "#2D353B";
        foreground = "#D3C6AA";
        frame_color = "#859289";
        timeout = 6;
      };

      urgency_normal = {
        background = "#2D353B";
        foreground = "#D3C6AA";
        frame_color = "#859289";
        timeout = 8;
      };

      urgency_critical = {
        background = "#2D353B";
        foreground = "#D3C6AA";
        frame_color = "#E67E80";
        timeout = 0;
      };
    };
  };

  # Set dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Hide titlebar buttons
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
    };
  };

  # Packages
  home.packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    cargo-watch
    cargo-edit
    restic
    hdparm
    typst
    python3
    inkscape
    obsidian
    godot
    go
    drawio
    deno
    brave
    claude-code
    opencode
    zellij
    discord-ptb
    slack
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Cursor theme
  home.pointerCursor = {
    name = "Yaru";
    package = pkgs.yaru-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Launcher
  programs.walker = {
    enable = true;
    runAsService = true;
    config.theme = "everforest";
    themes."everforest" = {
      style = ''
        @define-color window_bg_color #2D353B;
        @define-color accent_bg_color #859289;
        @define-color theme_fg_color #D3C6AA;
        @define-color error_bg_color #E67E80;
        @define-color error_fg_color #514045;

        * {
          all: unset;
        }

        popover {
          background: lighter(@window_bg_color);
          border: 1px solid darker(@accent_bg_color);
          border-radius: 18px;
          padding: 10px;
        }

        .normal-icons {
          -gtk-icon-size: 16px;
        }

        .large-icons {
          -gtk-icon-size: 32px;
        }

        scrollbar {
          opacity: 0;
        }

        .box-wrapper {
          box-shadow:
            0 19px 38px rgba(0, 0, 0, 0.3),
            0 15px 12px rgba(0, 0, 0, 0.22);
          background: @window_bg_color;
          padding: 20px;
          border-radius: 20px;
          border: 1px solid darker(@accent_bg_color);
        }

        .preview-box,
        .elephant-hint,
        .placeholder {
          color: @theme_fg_color;
        }

        .box {
        }

        .search-container {
          border-radius: 10px;
        }

        .input placeholder {
          opacity: 0.5;
        }

        .input selection {
          background: lighter(lighter(lighter(@window_bg_color)));
        }

        .input {
          caret-color: @theme_fg_color;
          background: lighter(@window_bg_color);
          padding: 10px;
          color: @theme_fg_color;
        }

        .input:focus,
        .input:active {
        }

        .content-container {
        }

        .placeholder {
        }

        .scroll {
        }

        .list {
          color: @theme_fg_color;
        }

        child {
        }

        .item-box {
          border-radius: 10px;
          padding: 10px;
        }

        .item-quick-activation {
          background: alpha(@accent_bg_color, 0.25);
          border-radius: 5px;
          padding: 10px;
        }

        /* child:hover .item-box, */
        child:selected .item-box,
        row:selected .item-box {
          background: alpha(@accent_bg_color, 0.25);
        }

        .item-text-box {
        }

        .item-subtext {
          font-size: 12px;
          opacity: 0.5;
        }

        .providerlist .item-subtext {
          font-size: unset;
          opacity: 0.75;
        }

        .item-image-text {
          font-size: 28px;
        }

        .preview {
          border: 1px solid alpha(@accent_bg_color, 0.25);
          /* padding: 10px; */
          border-radius: 10px;
          color: @theme_fg_color;
        }

        .calc .item-text {
          font-size: 24px;
        }

        .calc .item-subtext {
        }

        .symbols .item-image {
          font-size: 24px;
        }

        .todo.done .item-text-box {
          opacity: 0.25;
        }

        .todo.urgent {
          font-size: 24px;
        }

        .todo.active {
          font-weight: bold;
        }

        .bluetooth.disconnected {
          opacity: 0.5;
        }

        .preview .large-icons {
          -gtk-icon-size: 64px;
        }

        .keybinds {
          padding-top: 10px;
          border-top: 1px solid lighter(@window_bg_color);
          font-size: 12px;
          color: @theme_fg_color;
        }

        .global-keybinds {
        }

        .item-keybinds {
        }

        .keybind {
        }

        .keybind-button {
          opacity: 0.5;
        }

        .keybind-button:hover {
          opacity: 0.75;
        }

        .keybind-bind {
          text-transform: lowercase;
          opacity: 0.35;
        }

        .keybind-label {
          padding: 2px 4px;
          border-radius: 4px;
          border: 1px solid @theme_fg_color;
        }

        .error {
          padding: 10px;
          background: @error_bg_color;
          color: @error_fg_color;
        }

        :not(.calc).current {
          font-style: italic;
        }

        .preview-content.archlinuxpkgs,
        .preview-content.dnfpackages {
          font-family: monospace;
        }
      '';
    };
  };

  # Shell
  #programs.zsh = {
  #  enable = true;
  #  enableCompletion = true;
  #  autosuggestion.enable = true;
  #  syntaxHighlighting.enable = true;
  #};

  programs = {
    nushell = {
      enable = true;
      extraConfig = ''
        let carapace_completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
        }
        $env.config = {
         show_banner: false,
         completions: {
         case_sensitive: false # case-sensitive completions
         quick: true    # set to false to prevent auto-selecting completions
         partial: true    # set to false to prevent partial filling of the prompt
         algorithm: "fuzzy"    # prefix or fuzzy
         external: {
         # set to false to prevent nushell looking into $env.PATH to find more suggestions
             enable: true 
         # set to lower can improve completion performance at the cost of omitting some options
             max_results: 100 
             completer: $carapace_completer # check 'carapace_completer' 
           }
         }
        } 
        $env.PATH = ($env.PATH | 
        split row (char esep) |
        prepend /home/myuser/.apps |
        append /usr/bin/env
        )
      '';
      shellAliases = {
        vi = "hx";
        vim = "hx";
        nano = "hx";
      };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
      };
    };
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
    };
  };

  # Terminal
  #programs.ghostty = {
  #  enable = true;
  #  settings = {
  #    theme = "Everforest Dark Hard";
  #theme = "Everblush";
  #    background-opacity = 0.85;
  #    background-blur = true;
  #    window-padding-x = 8;
  #    window-padding-y = 8;
  #    window-padding-balance = true;
  #    font-family = [
  #      "JetBrainsMonoNL Nerd Font Mono"
  #      "IPAexGothic"
  #      "Noto Sans CJK JP"
  #    ];
  #    font-size = 12;
  #    font-style-bold = false;
  #    font-style-italic = false;
  #    font-style-bold-italic = false;
  #  };
  #};

  # or Alacritty
  programs.alacritty = {
    enable = true;
    theme = "everforest_dark_hard";
    settings = {
      window = {
        decorations = "none";
        opacity = 0.95;
        padding = {
          x = 8;
          y = 8;
        };
      };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 12.0;
      };
    };
  };

  # Hide icons for walker
  xdg.desktopEntries."org.fcitx.fcitx5-qt6-gui-wrapper" = {
    name = "fcitx5-qt6-gui-wrapper";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."org.fcitx.Fcitx5" = {
    name = "Fcitx 5";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."org.fcitx.fcitx5-migrator" = {
    name = "fcitx5-migrator";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."kcm_fcitx5" = {
    name = "kcm_fcitx5";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."fcitx5-configtool" = {
    name = "Fcitx5 Config";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."org.fcitx.fcitx5-config-qt" = {
    name = "fcitx5-config-qt";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."org.fcitx.fcitx5-qt5-gui-wrapper" = {
    name = "fcitx5-qt5-gui-wrapper";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."fcitx5-wayland-launcher" = {
    name = "fcitx5-wayland-launcher";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."kbd-layout-viewer5" = {
    name = "kbd-layout-viewer5";
    noDisplay = true;
    exec = "false";
  };
  xdg.desktopEntries."discord-ptb" = {
    name = "Discord";
    exec = "DiscordPTB";
    icon = "discord-ptb";
    terminal = false;
    categories = [
      "Network"
      "InstantMessaging"
    ];
  };

  # Text Editor
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";
      editor = {
        auto-format = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt;
      }
      {
        name = "rust";
        auto-format = true;
        formatter.command = lib.getExe pkgs.rustfmt;
        language-servers = [ "rust-analyzer" ];
      }
      {
        name = "kdl";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.kdlfmt;
          args = [
            "format"
            "-"
          ];
        };
      }
    ];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };

  # OBS
  programs.obs-studio = {
    enable = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi # optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };

  # Code Editor
  programs.zed-editor.enable = true;

  # Web Apps
  programs.google-chrome.enable = true;

  # Hide icon
  xdg = {
    enable = true;
    desktopEntries = {
      btop = {
        name = "btop";
        noDisplay = true;
      };
    };
  };

  # icon theme
  gtk = {
    enable = true;
    theme = {
      name = "Yaru-prussiangreen";
      package = pkgs.yaru-theme;
    };
    iconTheme = {
      name = "Yaru-prussiangreen";
      package = pkgs.yaru-theme;
    };
  };

  # niri
  xdg.configFile."niri/config.kdl" = {
    force = true;
    source = ./niri/config.kdl;
  };

  # eww script for niri
  home.file.".local/bin/eww-start" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      eww open-many clock cpu-window mem-window launcher-window workspaces-window date-window volume-window net-window cputemp-window
      sleep 0.3
      eww update volume_text="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{v=int($2*100); print v "%"}')"
      eww update volume_icon="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '0\.00' && echo '󰖁' || echo '󰕾')"
    '';
  };

  # Fcitx config
  xdg.configFile."fcitx5/profile" = {
    force = true;
    text = ''
      [Groups/0]
      Name=Default
      Default Layout=jp
      DefaultIM=mozc

      [Groups/0/Items/0]
      Name=keyboard-jp
      Layout=

      [Groups/0/Items/1]
      Name=mozc
      Layout=

      [GroupOrder]
      0=Default
    '';
  };

  xdg.configFile."fcitx5/conf/classicui.conf" = {
    force = true;
    text = ''
      # Vertical Candidate List
      Vertical Candidate List=False
      # Use mouse wheel to go to prev or next page
      WheelForPaging=True
      # Font
      Font="Sans 10"
      # Menu Font
      MenuFont="Sans 10"
      # Tray Font
      TrayFont="Sans Bold 10"
      # Tray Label Outline Color
      TrayOutlineColor=#000000
      # Tray Label Text Color
      TrayTextColor=#ffffff
      # Prefer Text Icon
      PreferTextIcon=False
      # Show Layout Name In Icon
      ShowLayoutNameInIcon=True
      # Use input method language to display text
      UseInputMethodLanguageToDisplayText=True
      # Theme
      Theme=plasma
      # Dark Theme
      DarkTheme=plasma
      # Follow system light/dark color scheme
      UseDarkTheme=False
      # Follow system accent color if it is supported by theme and desktop
      UseAccentColor=True
      # Use Per Screen DPI on X11
      PerScreenDPI=False
      # Force font DPI on Wayland
      ForceWaylandDPI=0
      # Enable fractional scale under Wayland
      EnableFractionalScale=True
    '';
  };

  # Bar
  xdg.configFile."eww/eww.yuck" = {
    force = true;
    text = ''
      (deflisten workspaces
        "~/.local/bin/eww-workspaces")

      (defpoll time :interval "1s"
        "date '+%-H:%M'")

      (deflisten volume_icon :initial "󰖁" "~/.local/bin/eww-volume-icon")
        (deflisten volume_text :initial "0%" "~/.local/bin/eww-volume-text")
        (defpoll volume_visible :interval "99999s" "echo false")

      (defpoll cpu :interval "2s"
        "top -bn1 | grep 'Cpu(s)' | awk '{printf \"%d%%\", $2}'")

      (defpoll mem :interval "2s"
        "free | grep Mem | awk '{printf \"%d%%\", $3/$2 * 100}'")

      (defpoll net_icon :interval "3s"
        "~/.local/bin/eww-net-icon")



      (defwidget workspace-btn [ws]
        (eventbox
          :onclick {"niri msg action focus-workspace " + jq(ws, ".id")}
          (label
            :class {jq(ws, ".is_active") == "true" ? "ws-label-active" : "ws-label"}
            :text {jq(ws, ".idx")})))

      (defwidget workspaces []
        (box :class "ws-box"
          :orientation "h"
          :spacing 8
          :space-evenly false
          (for ws in {workspaces}
            (workspace-btn :ws {ws}))))

      (defwidget clock []
        (centerbox :orientation "h"
          :class "clock-box"
          (box)
          {time}
          (box)))

      (defwidget volume-widget []
        (eventbox
          :onclick "eww open-many --toggle volume-overlay-window volume-popup-window"
          (box :class "vol-box" :spacing 6 :space-evenly false
            (label :class "vol-icon" :text {volume_icon})
            (label :class "sysinfo-text" :text {volume_text}))))

      (defwidget volume-popup []
        (box :class "vol-popup" :orientation "h" :spacing 8 :space-evenly false
          (label :class "vol-icon" :text {volume_icon})
            (scale
              :class "vol-slider"
              :orientation "h"
              :min 0
              :max 101
              :value {replace(volume_text, "%", "")}
              :onchange "wpctl set-volume @DEFAULT_AUDIO_SINK@ {}%")))

      (defwidget volume-overlay []
        (eventbox :onclick "eww close volume-popup-window && eww close volume-overlay-window"))

      (defwidget cpu-widget []
        (box :class "cpu-box" :spacing 6 :space-evenly false
          (label :class "cpu-icon" :text "󰍛")
          (label :class "sysinfo-text" :text {cpu})))

      (defwidget mem-widget []
        (box :class "mem-box" :spacing 6 :space-evenly false
          (label :class "mem-icon" :text "")
          (label :class "sysinfo-text" :text {mem})))

      (defwidget net-widget []
        (box :class "net-box" :spacing 6 :space-evenly false
        (label :class "net-icon" :text {net_icon})))

      (defwidget launcher []
        (button :class "launcher-btn"
          :onclick "eww open-many --toggle power-menu-overlay-window power-menu-window"
          (label :text "󰐥" :halign "center" :valign "center")))

      (defwidget power-menu []
        (box :class "power-menu" :orientation "v" :spacing 0 :space-evenly false
          (button :class "power-menu-item"
            :onclick "eww close power-menu-window && eww close power-menu-overlay-window && walker &"
            (box :spacing 10 :space-evenly false
              (label :class "power-menu-icon" :text "󰀻")
              (label :class "power-menu-text" :text "Show Apps")))
          (box :class "power-menu-sep" :halign "fill")
          (button :class "power-menu-item"
            :onclick "eww close power-menu-window&& eww close power-menu-overlay-window && systemctl suspend"
              (box :spacing 10 :space-evenly false
                (label :class "power-menu-icon" :text "")
                (label :class "power-menu-text" :text "Sleep")))
          (button :class "power-menu-item"
            :onclick "eww close power-menu-window && eww close power-menu-overlay-window && hyprlock &"
              (box :spacing 10 :space-evenly false
                (label :class "power-menu-icon" :text "󰌾")
                (label :class "power-menu-text" :text "Lock Screen")))
          (button :class "power-menu-item"
            :onclick "eww close power-menu-window && eww close power-menu-overlay-window && reboot"
              (box :spacing 10 :space-evenly false
                (label :class "power-menu-icon" :text "")
                (label :class "power-menu-text" :text "Restart")))
          (button :class "power-menu-item power-menu-item-shutdown"
            :onclick "eww close power-menu-window && eww close power-menu-overlay-window && shutdown now"
            (box :spacing 10 :space-evenly false
              (label :class "power-menu-icon" :text "󰐥")
              (label :class "power-menu-text" :text "Shut Down")))))

      (defwidget power-menu-overlay []
        (eventbox :onclick "eww close power-menu-window && eww close power-menu-overlay-window"))



      (defwindow workspaces-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "10px" :y "0%" :width "10px" :height "34px" :anchor "top left")
        :reserve (struts :side "top" :distance "20px")
        (workspaces))

      (defwindow clock
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "0%" :y "0%" :width "65px" :height "34px" :anchor "top center")
        :reserve (struts :side "top" :distance "20px")
        (clock))

      (defwindow volume-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "266px" :y "0%" :width "70px" :height "34px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (volume-widget))

      (defwindow volume-popup-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "200px" :y "35px" :width "200px" :height "40px" :anchor "top right")
        (volume-popup))

      (defwindow volume-overlay-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "0" :y "0" :width "100%" :height "100%")
        (volume-overlay))

      (defwindow cpu-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "188px" :y "0%" :width "70px" :height "34px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (cpu-widget))

      (defwindow mem-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "106px" :y "0%" :width "70px" :height "34px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (mem-widget))

      (defwindow net-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "58px" :y "0%" :width "40px" :height "34px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (net-widget))

      (defwindow launcher-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "10px" :y "0%" :width "40px" :height "34px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (launcher))

      (defwindow power-menu-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "6px" :y "35px" :width "220px" :height "10px" :anchor "top right")
        (power-menu))

      (defwindow power-menu-overlay-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "0" :y "0" :width "100%" :height "100%")
        (power-menu-overlay))
    '';
  };

  xdg.configFile."eww/eww.css" = {
    force = true;
    text = ''
      window {
        background: transparent;
      }

      .sysinfo-text {
        font-family: 'Inter', sans-serif;
        font-size: 13px;
        color: #e0e0e0;
      }

      .ws-box {
        margin: 4px 0;
        padding: 0 10px;
        background-color: rgba(20, 20, 20, 0.80);
        border: 1px solid rgba(255, 255, 255, 0.10);
        border-radius: 16px;
      }

      .ws-label {
        min-width: 20px;
        color: rgba(224, 224, 224, 0.5);
        font-family: 'JetBrainsMono Nerd Font', monospace;
        font-size: 13px;
        padding: 2px 8px;
        border-radius: 50%;
      }

      .ws-label-active {
        min-width: 20px;
        color: #e0e0e0;
        font-family: 'JetBrainsMono Nerd Font', monospace;
        font-size: 13px;
        padding: 2px 8px;
      }

      .clock-box {
        margin: 4px 0;
        background-color: rgba(20, 20, 20, 0.80);
        color: #e0e0e0;
        font-family: 'Roboto', sans-serif;
        font-size: 16px;
        border: 1px solid rgba(255, 255, 255, 0.10);
        border-radius: 16px;
      }

      centerbox {
        padding: 0 10px;
      }

      .vol-box {
        margin: 4px 0;
        padding: 0 12px;
        background-color: rgba(20, 20, 20, 0.80);
        border: 1px solid rgba(255, 255, 255, 0.10);
        border-radius: 16px;
      }

      .vol-icon {
        font-family: 'JetBrainsMono Nerd Font', monospace;
        font-size: 16px;
        color: #e0e0e0;
        padding-right: 2px;
      }

      .vol-popup {
        background-color: #30302e;
        border: 1px solid #64635f;
        border-radius: 12px;
        padding: 8px 12px;
      }

      .vol-slider {
        min-width: 120px;
      }

      .vol-slider trough {
        background-color: #3a3a47;
        border-radius: 4px;
        min-height: 6px;
        min-width: 120px;
      }

      .vol-slider trough highlight {
        background-color: #7aa2f7;
        border-radius: 4px;
        min-height: 6px;
      }

      .vol-slider slider {
        background-color: #ffffff;
        border-radius: 50%;
        min-width: 14px;
        min-height: 14px;
        margin: -4px 0;
      }

      .cpu-box {
        margin: 4px 0;
        padding: 0 12px;
        background-color: rgba(20, 20, 20, 0.80);
        border: 1px solid rgba(255, 255, 255, 0.10);
        border-radius: 16px;
      }

      .cpu-icon {
        font-family: 'JetBrainsMono Nerd Font', monospace;
        font-size: 17px;
        color: #e0e0e0;
        padding-right: 2px;
      }

      .mem-box {
        margin: 4px 0;
        padding: 0 12px;
        background-color: rgba(20, 20, 20, 0.80);
        border: 1px solid rgba(255, 255, 255, 0.10);
        border-radius: 16px;
      }

      .mem-icon {
        font-family: 'JetBrainsMono Nerd Font', monospace;
        font-size: 14px;
        color: #e0e0e0;
        padding-right: 7px;
      }

      .net-box {
        margin: 4px 0;
        padding: 0 12px;
        background-color: rgba(20, 20, 20, 0.80);
        border: 1px solid rgba(255, 255, 255, 0.10);
        border-radius: 16px;
      }

      .net-icon {
        font-family: 'JetBrainsMono Nerd Font', monospace;
        font-size: 16px;
        color: #e0e0e0;
      }

      .launcher-btn {
        background: rgba(20, 20, 20, 0.80);
        border: 1px solid rgba(255, 255, 255, 0.10);
        border-radius: 16px;
        border: none;
        padding: 0 2px;
        margin: 4px 0;
        box-shadow: none;
        outline: none;
        -gtk-outline-radius: 0;
        font-size: 17px;
        font-family: 'JetBrainsMono Nerd Font', monospace;
        color: #e0e0e0;
      }

      .power-menu {
        background-color: #30302e;
        border: 1px solid #64635f;
        border-radius: 14px;
        padding: 4px 4px;

            }

      .power-menu-item {
        background: transparent;
        border: none;
        border-radius: 9px;
        padding: 3px 8px;
        box-shadow: none;
        outline: none;
        -gtk-outline-radius: 0;
        min-width: 160px;
      }

      .power-menu-item:hover {
        background-color: #1f1e1d;
      }

      .power-menu-icon {
        font-family: 'JetBrainsMono Nerd Font', monospace;
        font-size: 14px;
        color: #E6E6E6;
        min-width: 20px;
      }

      .power-menu-text {
        font-family: 'Noto Sans', sans-serif;
        font-size: 14px;
        color: #faf9f5;
      }

      .power-menu-item-shutdown .power-menu-icon,
      .power-menu-item-shutdown .power-menu-text {
        color: #FF6B6B;
      }

      .power-menu-sep {
        background-color: #3a3a47;
        min-height: 1px;
        margin: 4px 10px;
        padding: 0;
      }
    '';
  };

  # eww sh files
  home.file.".local/bin/eww-net-icon" = {
    executable = true;
    text = ''
      #!/bin/sh
      iface=$(ip route get 8.8.8.8 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')
      if [ -z "$iface" ]; then
        echo ""
      elif echo "$iface" | grep -qE '^(eth|en|eno|enp)'; then
        echo "󰌗"
      else
        echo ""
      fi
    '';
  };
  home.file.".local/bin/eww-workspaces" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      get_workspaces() {
        niri msg -j workspaces | jq -c '[.[] | {id: .id, idx: .idx, is_active: .is_active}] | sort_by(.idx)'
      }

      get_workspaces

      niri msg -j event-stream | while IFS= read -r line; do
        if echo "$line" | grep -qE '"WorkspaceActivated"|"WorkspacesChanged"|"WorkspaceActiveWindowChanged"'; then
          get_workspaces
        fi
      done
    '';
  };
  home.file.".local/bin/eww-volume-icon" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '0\.00' && echo '󰖁' || echo '󰕾'
      pactl subscribe 2>/dev/null | grep --line-buffered "Event 'change' on sink" | while read -r _; do
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '0\.00' && echo '󰖁' || echo '󰕾'
      done
    '';
  };
  home.file.".local/bin/eww-volume-text" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{v=int($2*100); print v "%"}'
      pactl subscribe 2>/dev/null | grep --line-buffered "Event 'change' on sink" | while read -r _; do
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{v=int($2*100); print v "%"}'
      done
    '';
  };

  # lock screen
  xdg.configFile."hypr/hyprlock.conf" = {
    force = true;
    text = ''
      general {
        disable_loading_bar = false
        hide_cursor = true
        grace = 0
        no_fade_in = false
      }

      background {
        monitor =
        path = /etc/nixos/wallpaper.jpg
        brightness = 0.8
        contrast = 1.0
        vibrancy = 0.2
        vibrancy_darkness = 0.0
      }

      label {
        monitor =
          text = cmd[update:1000] echo "$(date +"%-H:%M")"
          color = rgba(255, 255, 255, 1.0)
          font_size = 120
          font_family = Roboto Medium
          position = 0, 500
          halign = center
          valign = center
      }
      input-field {
        size = 350, 50
        position = 0, -500
        halign = center
        valign = center
        rounding = 16
        dots_center = true
        outer_color = rgba(255, 255, 255, 0.5)
        inner_color = rgba(0, 0, 0, 0.2)
        font_color = rgba(255, 255, 255, 1.0)
        outline_thickness = 2
      }
    '';
  };
}
