{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    #inputs.dms.homeModules.dank-material-shell
    inputs.walker.homeManagerModules.default
  ];

  home.username = "sam";
  home.homeDirectory = "/home/sam";
  home.stateVersion = "26.05";

  # Launcher
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "default";
    };
  };

  # Dank Linux
  #xdg.configFile."DankMaterialShell/settings.json".force = true;
  #xdg.stateFile."DankMaterialShell/session.json".force = true;
  #programs.dank-material-shell = {
  #  enable = true;

  # systemd = {
  #   enable = true;
  #   restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
  # };

  # settings = {
  #   theme = "dark";
  #   enableVPN = true;
  #   dynamicTheming = true;
  #   enableCalendarEvents = false;
  #   showLauncherButton = false;
  #   showCpuTemp = true;
  # };

  #session = {
  #  isLightMode = false;
  #};
  #};

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sam";
        email = "sam@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "TokyoNight";
      background-opacity = 0.9;
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
  #xdg.configFile."alacritty/alacritty.toml".force = true;
  #programs.alacritty = {
  #  enable = true;
  #  settings = {
  #    window = {
  #      decorations = "none";
  #	opacity = 0.8;
  #     padding = {
  #        x = 8;
  #        y = 8;
  #      };
  #    };
  #    font = {
  #      normal = {
  #        family = "JetBrainsMono Nerd Font";
  #        style = "Regular";
  #      };
  #      size = 12.0;
  #    };
  #  };
  #};

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
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
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
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

  programs.zed-editor.enable = true;
  programs.google-chrome.enable = true;

  # disable icon for Launcher
  #xdg.desktopEntries = {
  #  btop = {
  #    name = "btop";
  #    noDisplay = true;
  #  };
  #};
  xdg = {
    enable = true;

    desktopEntries = {
      btop = {
        name = "btop";
        noDisplay = true;
      };

      fcitx5 = {
        name = "fcitx5";
        noDisplay = true;
        comment = "Input method framework";
        exec = "fcitx5";
        terminal = false;
        type = "Application";
      };

      ikhal = {
        name = "ikhal";
        noDisplay = true;
      };
    };
  };

  # icon theme
  #dconf.settings = {
  #  "org/gnome/desktop/interface" = {
  #    icon-theme = "Yaru";
  #    gtk-theme = "Yaru";
  #  };
  #};

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

  #  xdg.configFile."gtk-4.0/gtk.css" = {
  #  source = pkgs.yaru-theme + "/share/themes/Yaru-blue/gtk-4.0/gtk.css";
  #  force = true;
  #};

  xdg.configFile."niri/config.kdl" = {
    force = true;
    text = ''
      spawn-at-startup "awww-daemon"
      spawn-at-startup "awww" "img" "/home/sam/Pictures/01-Purple_DM-4K.png" "--transition-type" "none"
      spawn-at-startup "awww-daemon" "-n" "overlay"
      spawn-at-startup "awww" "img" "-n" "overlay" "/home/sam/Pictures/blur-Purple_DM-4K.png"
      spawn-at-startup "eww" "daemon"
      spawn-at-startup "eww" "open-many" "bar" "cpu-window" "mem-window" "launcher-window" "workspaces-window" "date-window" "volume-window" "net-window" "cputemp-window"

      prefer-no-csd

      // Make workspaces four times smaller than normal in the overview.
      overview {
        zoom 0.6
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
          active-color "#f0f0f0"
          inactive-color "#f0f0f0"
        }

        border {
          off
          width 4
          active-color "#ffc87f"
          inactive-color "#505050"
          urgent-color "#9b0000"
        }

        shadow {
          softness 30
          spread 5
          offset x=0 y=5
          color "#0007"
        }

        // Custom
        struts {
          top 30
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

      // window-rule {
      //   match app-id=r#"^org\.wezfurlong\.wezterm$"#
      //   default-column-width {}
      // }

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
        geometry-corner-radius 12
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
        Mod+Z hotkey-overlay-title="Open a Code Editor" { spawn "zed"; }

        Mod+Shift+Slash { show-hotkey-overlay; }

        Mod+T hotkey-overlay-title="Open a Terminal: ghostty" { spawn "ghostty"; }
        Mod+Space hotkey-overlay-title="Run an Application: walker" { spawn "walker"; }
        // Mod+Alt+L hotkey-overlay-title="Lock the Screen: dms" { spawn "dms ipc call lock lock"; }

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

  xdg.configFile."ghostty/config" = {
    force = true;
    text = ''
      font-size = 24
      window-padding-x = 25
      window-padding-y = 25
    '';
  };

  # Bar
  xdg.configFile."eww/eww.yuck" = {
    force = true;
    text = ''
      (defpoll time :interval "0.1s"
        "date '+%-H:%M'")

      (defpoll cpu :interval "2s"
        "top -bn1 | grep 'Cpu(s)' | awk '{printf \"%d%%\", $2}'")

      (defpoll mem :interval "2s"
        "free | grep Mem | awk '{printf \"%d%%\", $3/$2 * 100}'")

      (defpoll workspaces :interval "0.1s"
        "~/.local/bin/eww-workspaces")

      (defpoll date :interval "60s"
        "date '+%Y/%m/%d'")

      (defpoll volume_icon :interval "0.1s"
        "wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '0\\.00' && echo '󰖁' || echo '󰕾'")

      (defpoll volume_text :interval "0.1s"
        "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{v=int($2*100); print v \"%\"}'")

      (defpoll volume_visible :interval "99999s" "echo false")

      (defpoll net_icon :interval "3s"
        "~/.local/bin/eww-net-icon")

      (defpoll cpu_temp :interval "2s"
        "sensors | grep -A2 'k10temp\\|coretemp' | grep 'Tctl\\|Package id 0\\|Core 0' | head -1 | awk '{gsub(/[+°C]/,\"\",$2); printf \"%d℃\", $2}'")



      (defwidget launcher []
        (button :class "launcher-btn"
          :onclick "walker &"
          :halign "center"
          :valign "center"
          (label :text "" :halign "center" :valign "center")))

      (defwidget workspace-btn [ws]
        (eventbox
          :onclick {"niri msg action focus-workspace " + jq(ws, ".id")}
        (label
          :class {jq(ws, ".label_class") == "ws-label ws-label-active" ? "ws-label-active" : "ws-label"}
          :text {jq(ws, ".idx")})))

      (defwidget workspaces []
        (box :class "ws-box"
             :orientation "h"
             :spacing 8
             :space-evenly false
        (for ws in {workspaces}
          (workspace-btn :ws {ws}))))

      (defwidget bar []
        (centerbox :orientation "h"
          :class "clock-box"
          (box)
          {time}
          (box)))

      (defwidget cpu-widget []
          (box :class "cpu-box" :spacing 6 :space-evenly false
          (label :class "cpu-icon" :text "󰍛")
          (label :class "sysinfo-text" :text {cpu})))

      (defwidget mem-widget []
        (box :class "mem-box" :spacing 6 :space-evenly false
          (label :class "mem-icon" :text "")
          (label :class "sysinfo-text" :text {mem})))

      (defwidget date-widget []
        (box :class "date-box" :spacing 6 :space-evenly false
        (label :class "sysinfo-text" :text {date})))

      (defwidget volume-widget []
        (eventbox
        :onclick "eww open-many --toggle volume-popup-window"
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

      (defwidget net-widget []
        (box :class "net-box" :spacing 6 :space-evenly false
        (label :class "net-icon" :text {net_icon})))

      (defwidget cputemp-widget []
        (box :class "cputemp-box" :spacing 6 :space-evenly false
        (label :class "cputemp-icon" :text "")
        (label :class "sysinfo-text" :text {cpu_temp})))



      (defwindow launcher-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "2px" :y "0%" :width "30px" :height "30px" :anchor "top left")
        :reserve (struts :side "top" :distance "20px")
        (launcher))

      (defwindow workspaces-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "38px" :y "0%" :width "10px" :height "30px" :anchor "top left")
        :reserve (struts :side "top" :distance "20px")
        (workspaces))

      (defwindow bar
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "0%" :y "0%" :width "65px" :height "30px" :anchor "top center")
        :reserve (struts :side "top" :distance "20px")
        (bar))

      (defwindow volume-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "388px" :y "0%" :width "70px" :height "30px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (volume-widget))

      (defwindow volume-popup-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "260px" :y "35px" :width "200px" :height "40px" :anchor "top right")
        (volume-popup))

      (defwindow cpu-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "236px" :y "0%" :width "70px" :height "30px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (cpu-widget))

      (defwindow mem-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "156px" :y "0%" :width "70px" :height "30px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (mem-widget))

      (defwindow date-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "2px" :y "0%" :width "100px" :height "30px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (date-widget))

      (defwindow net-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "110px" :y "0%" :width "40px" :height "30px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (net-widget))

      (defwindow cputemp-window
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "312px" :y "0%" :width "70px" :height "30px" :anchor "top right")
        :reserve (struts :side "top" :distance "20px")
        (cputemp-widget))
    '';
  };

  xdg.configFile."eww/eww.css" = {
    force = true;
    text = ''
       window {
         background: transparent;
       }

      .clock-box {
         margin: 2px 0;
         background-color: #1f1f28;
         color: #ffffff;
         font-family: 'Roboto', sans-serif;
         font-size: 16px;
         border: 1px solid #3a3a47;
         border-radius: 16px;
      }

      centerbox {
         padding: 0 10px;
      }

      .cpu-box {
         margin: 2px 0;
         padding: 0 12px;
         background-color: #1f1f28;
         border: 1px solid #3a3a47;
         border-radius: 16px;
       }

       .mem-box {
         margin: 2px 0;
         padding: 0 12px;
         background-color: #1f1f28;
         border: 1px solid #3a3a47;
         border-radius: 16px;
       }

       .cpu-icon {
         font-family: 'JetBrainsMono Nerd Font', monospace;
         font-size: 17px;
         color: #ffffff;
         padding-right: 2px;
       }

       .mem-icon {
         font-family: 'JetBrainsMono Nerd Font', monospace;
         font-size: 14px;
         color: #ffffff;
         padding-right: 7px;
       }

       .sysinfo-text {
         font-family: 'Roboto', sans-serif;
         font-size: 14px;
         color: #ffffff;
       }

       .launcher-btn {
         background: transparent;
         border: none;
         padding: 0;
         margin: 0;
         font-family: 'JetBrainsMono Nerd Font', monospace;
         font-size: 22px;
         color: #40b7fe;
         box-shadow: none;
         outline: none;
         -gtk-outline-radius: 0;
         min-width: 30px;
         min-height: 30px;
       }

       .date-box {
         margin: 2px 0;
         padding: 0 12px;
         background-color: #1f1f28;
         border: 1px solid #3a3a47;
         border-radius: 16px;
       }

       .vol-box {
         margin: 2px 0;
         padding: 0 12px;
         background-color: #1f1f28;
         border: 1px solid #3a3a47;
         border-radius: 16px;
       }

       .vol-icon {
         font-family: 'JetBrainsMono Nerd Font', monospace;
         font-size: 16px;
         color: #ffffff;
         padding-right: 2px;
       }

       .net-box {
         margin: 2px 0;
         padding: 0 12px;
         background-color: #1f1f28;
         border: 1px solid #3a3a47;
         border-radius: 16px;
       }

       .net-icon {
         font-family: 'JetBrainsMono Nerd Font', monospace;
         font-size: 16px;
         color: #ffffff;
       }

       .cputemp-box {
         margin: 2px 0;
         padding: 0 12px;
         background-color: #1f1f28;
         border: 1px solid #3a3a47;
         border-radius: 16px;
       }

       .cputemp-icon {
         font-family: 'JetBrainsMono Nerd Font', monospace;
         font-size: 14px;
         color: #ffffff;
       }

       .ws-box {
         margin: 2px 0;
         padding: 0 10px;
         background-color: #1f1f28;
         border: 1px solid #3a3a47;
         border-radius: 16px;
       }

       .ws-label {
         min-width: 20px;
         color: #ffffff;
         font-family: 'JetBrainsMono Nerd Font', monospace;
         font-size: 13px;
         padding: 2px 8px;
       }

       .ws-label-active {
         min-width: 20px;
         color: #7aa2f7;
         font-family: 'JetBrainsMono Nerd Font', monospace;
         font-size: 13px;
         padding: 2px 8px;
       }

      .vol-popup {
        background-color: #1f1f28;
        border: 1px solid #3a3a47;
        border-radius: 12px;
        padding: 4px 12px;
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
      #!/bin/sh
      niri msg -j workspaces | jq '[.[] | {id: .id, idx: .idx, label_class: (if .is_active then "ws-label ws-label-active" else "ws-label" end)}] | sort_by(.idx)'
    '';
  };
}
