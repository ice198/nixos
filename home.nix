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

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "26.05";

  # Set dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # dconf.settings = {
  #   "org/gnome/desktop/wm/preferences" = {
  #     button-layout = ":minimize,maximize,close";
  #   };
  # };

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
    reaper
    spotify
    inkscape
    obsidian
    godot
    go
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
    config = {
      theme = "default";
    };
  };

  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Git
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

  # Terminal
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Everforest Dark Hard";
      background-opacity = 0.95;
      background-blur = true;
      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;
      font-family = "JetBrainsMonoNL Nerd Font Mono";
      font-size = 12;
      font-style-bold = false;
      font-style-italic = false;
      font-style-bold-italic = false;
    };
  };

  # or Alacritty
  #programs.alacritty = {
  #  enable = true;
  #  settings = {
  #    window = {
  #      decorations = "none";
  #	     opacity = 0.8;
  #        padding = {
  #          x = 8;
  #          y = 8;
  #        };
  #      };
  #      font = {
  #        normal = {
  #          family = "JetBrainsMono Nerd Font";
  #          style = "Regular";
  #        };
  #      size = 12.0;
  #    };
  #  };
  #};

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      scan_timeout = 100;
    };
  };

  # Text Editor
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
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
  # Youtube
  xdg.desktopEntries.youtube = {
    name = "YouTube";
    exec = "google-chrome --app=https://www.youtube.com";
    icon = "/etc/nixos/icons/youtube.png";
    type = "Application";
    categories = [ "Network" ];
  };

  # ChatGPT
  xdg.desktopEntries.chatgpt = {
    name = "ChatGPT";
    exec = "google-chrome --app=https://chatgpt.com";
    icon = "/etc/nixos/icons/chatgpt.png";
    type = "Application";
    categories = [ "Utility" ];
  };

  # X
  xdg.desktopEntries.x = {
    name = "X";
    exec = "google-chrome --app=https://x.com";
    icon = "/etc/nixos/icons/x.png";
    type = "Application";
    categories = [ "Network" ];
  };

  # Bluesky
  xdg.desktopEntries.bluesky = {
    name = "Bluesky";
    exec = "google-chrome --app=https://bsky.app";
    icon = "/etc/nixos/icons/bluesky.png";
    type = "Application";
    categories = [ "Network" ];
  };

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
      name = "Yaru-blue";
      package = pkgs.yaru-theme;
    };
    iconTheme = {
      name = "Yaru-blue";
      package = pkgs.yaru-theme;
    };
  };

  # WM config (niri)
  xdg.configFile."niri/config.kdl" = {
    force = true;
    text = ''
      spawn-at-startup "awww-daemon"
      spawn-at-startup "awww" "img" "/etc/nixos/wallpaper.jpg" "--transition-type" "none"
      spawn-at-startup "awww-daemon" "-n" "overlay"
      spawn-at-startup "awww" "img" "-n" "overlay" "/etc/nixos/blur-wallpaper.jpg" "--transition-type" "none"
      spawn-at-startup "eww" "daemon"
      spawn-at-startup "/home/user/.local/bin/eww-start"

      prefer-no-csd

      // Make workspaces four times smaller than normal in the overview.
      overview {
        zoom 0.6
      }

      cursor {
        xcursor-theme "Yaru"
        xcursor-size 24
      }

      input {
        keyboard {
            xkb {
            }
            numlock
        }

        touchpad {
            tap
            natural-scroll
        }

        mouse {
        }

        trackpoint {
        }
        focus-follows-mouse max-scroll-amount="0%"
      }

        output "eDP-1" {
          mode "1920x1080@120.030"
          scale 2
          transform "normal"
          position x=1280 y=1
        }

        layout {
          gaps 8
          center-focused-column "never"

          preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
          }

          default-column-width { proportion 0.5; }

          focus-ring {
            width 1
            active-color "#00000096"
            inactive-color "#00000096"
          }

          border {
            // off
            width 2
            active-color "#83c092CC"
            inactive-color "#475258CC"
            urgent-color "#9b000096"
          }

          shadow {
            softness 30
            spread 5
            offset x=0 y=5
            color "#0007"
          }

          // Custom
          struts {
            top 28
          }

          tab-indicator {
            on
            corner-radius 5
          }

          background-color "transparent" // to show wallpaper when overview
        }

        hotkey-overlay {
        }

        screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

        animations {
        }

        // Open the Firefox picture-in-picture player as floating by default.
        window-rule {
          match app-id=r#"firefox$"# title="^Picture-in-Picture$"
          open-floating true
        }

        window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          match app-id=r#"^org\.gnome\.World\.Secrets$"#

          block-out-from "screen-capture"
        }

        window-rule {
          geometry-corner-radius 10
          clip-to-geometry true
          draw-border-with-background false // Remove window background color
        }

        layer-rule {
          match namespace="^awww-daemonoverlay$"
          place-within-backdrop true
        }

        binds {
          Mod+B hotkey-overlay-title="Open a Browser: firefox" { spawn "firefox"; }
          Mod+N hotkey-overlay-title="Open a File Explorer" { spawn "nautilus"; }

          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+T hotkey-overlay-title="Open a Terminal: ghostty" { spawn "ghostty"; }
          Mod+Space hotkey-overlay-title="Run an Application: walker" { spawn "walker"; }
          Mod+Alt+L hotkey-overlay-title="Lock the Screen: hyprlock" { spawn "hyprlock"; }

          Super+Alt+S allow-when-locked=true hotkey-overlay-title=null { spawn-sh "pkill orca || exec orca"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
          XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

          XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
          XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
          XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
          XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }

          XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

          Mod+O repeat=false { toggle-overview; }

          Mod+C repeat=false { close-window; }

          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-down; }
          Mod+K     { focus-window-up; }
          Mod+L     { focus-column-right; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Down  { move-window-down; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+H     { move-column-left; }
          Mod+Ctrl+J     { move-window-down; }
          Mod+Ctrl+K     { move-window-up; }
          Mod+Ctrl+L     { move-column-right; }

          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }

          Mod+Shift+Left  { focus-monitor-left; }
          Mod+Shift+Down  { focus-monitor-down; }
          Mod+Shift+Up    { focus-monitor-up; }
          Mod+Shift+Right { focus-monitor-right; }
          Mod+Shift+H     { focus-monitor-left; }
          Mod+Shift+J     { focus-monitor-down; }
          Mod+Shift+K     { focus-monitor-up; }
          Mod+Shift+L     { focus-monitor-right; }

          Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+U              { focus-workspace-down; }
          Mod+I              { focus-workspace-up; }
          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
          Mod+Ctrl+U         { move-column-to-workspace-down; }
          Mod+Ctrl+I         { move-column-to-workspace-up; }

          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Shift+Page_Up   { move-workspace-up; }
          Mod+Shift+U         { move-workspace-down; }
          Mod+Shift+I         { move-workspace-up; }

          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight      { focus-column-right; }
          Mod+WheelScrollLeft       { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft  { move-column-left; }

          Mod+Shift+WheelScrollDown      { focus-column-right; }
          Mod+Shift+WheelScrollUp        { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }

          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          Mod+Comma  { consume-window-into-column; }

          Mod+Period { expel-window-from-column; }

          Mod+R { switch-preset-column-width; }

          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }

          Mod+Ctrl+F { expand-column-to-available-width; }

          Mod+Q { center-column; }

          Mod+Ctrl+C { center-visible-columns; }

          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }

          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          Mod+V       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }

          Mod+W { toggle-column-tabbed-display; }

          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }

          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

          Mod+Shift+E { quit; }
          Ctrl+Alt+Delete { quit; }

          Mod+Shift+P { power-off-monitors; }
        }
    '';
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
