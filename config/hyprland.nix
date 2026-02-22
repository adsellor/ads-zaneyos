{
  lib,
  username,
  host,
  config,
  ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout
    fileManager
    ;
  modifier = "SUPER";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      "$mod" = modifier;

      # Environment variables
      env = [
        "NIXOS_OZONE_WL, 1"
        "NIXPKGS_ALLOW_UNFREE, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland, x11"
        "CLUTTER_BACKEND, wayland"
        "QT_QPA_PLATFORM, wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "SDL_VIDEODRIVER, x11"
        "MOZ_ENABLE_WAYLAND, 1"
      ];

      # Monitor
      monitor = [
        ", 2560x1440@240, auto, 1"
      ]
      ++ lib.optional (extraMonitorSettings != "") extraMonitorSettings;

      # Startup applications
      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        # "killall -q swww;sleep .5 && swww-daemon"
        # "sleep 1.5 && swww img /home/${username}/Pictures/Wallpapers/galaxy.png"
        "lxqt-policykit-agent"
        "auto-dnd"
        "hyprsession"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 8;
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
        "col.active_border" =
          "rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg";
        "col.inactive_border" = "rgb(${config.stylix.base16Scheme.base01})";
      };

      input = {
        kb_layout = keyboardLayout;
        kb_variant = "dvp,phonetic";
        kb_options = "grp:ctrl_space_toggle";
        follow_mouse = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = "0.8";
        };
        sensitivity = 0;
        accel_profile = "flat";
      };

      windowrule = [
        "match:class ^(${terminal})$, workspace 2"
        "match:class ^(zen)$, workspace 1"
        "match:class ^(Signal)$, workspace special:one"
        "match:class ^(telegram-desktop)$, workspace special:one"
        "match:class ^(org.telegram.desktop)$, workspace special:one"
      ];

      misc = {
        initial_workspace_tracking = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        focus_on_activate = true;
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "fade, 1, 10, default"
          "workspaces, 0, 5, wind"
        ];
      };

      decoration = {
        rounding = 20;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = false;
        };
      };

      plugin = {
        hyprtrails = { };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Keybindings
      bind = [
        # Caelestia launcher
        "$mod SHIFT, Return, global, caelestia:launcher"

        # Application launchers
        "$mod, Return, exec, ${terminal}"
        "$mod SHIFT, W, exec, web-search"
        "$mod SHIFT, N, exec, swaync-client -rs"
        "$mod, W, exec, ${browser}"
        "$mod, E, exec, emopicker9000"
        "$mod SHIFT, S, exec, screenshootin"
        "$mod, D, exec, discord"
        "$mod, O, exec, obs"
        "$mod, C, exec, hyprpicker -a"
        "$mod, G, exec, gimp"
        "$mod SHIFT, G, exec, godot4"
        "$mod, T, exec, thunar"
        "$mod, Y, exec, ${terminal} ${fileManager}"
        "$mod, M, exec, spotify"

        # Window management
        "$mod, Q, killactive,"
        "$mod, P, pseudo,"
        "$mod SHIFT, I, togglesplit,"
        "$mod, F, fullscreen,"
        "$mod SHIFT, F, togglefloating,"

        # Move windows
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Switch workspaces (Dvorak Programmer keys)
        "$mod, ampersand, workspace, 1"
        "$mod, bracketleft, workspace, 2"
        "$mod, braceleft, workspace, 3"
        "$mod, braceright, workspace, 4"
        "$mod, parenleft, workspace, 5"
        "$mod, equal, workspace, 6"
        "$mod, asterisk, workspace, 7"
        "$mod, parenright, workspace, 8"
        "$mod, plus, workspace, 9"
        "$mod, bracketright, workspace, 10"

        # Special workspaces
        "$mod SHIFT, SPACE, movetoworkspace, special:one"
        "$mod, SPACE, togglespecialworkspace, one"
        "$mod SHIFT, Tab, movetoworkspace, special:two"
        "$mod, Tab, togglespecialworkspace, two"

        # Move to workspaces (Dvorak Programmer keys)
        "$mod SHIFT, ampersand, movetoworkspace, 1"
        "$mod SHIFT, bracketleft, movetoworkspace, 2"
        "$mod SHIFT, braceleft, movetoworkspace, 3"
        "$mod SHIFT, braceright, movetoworkspace, 4"
        "$mod SHIFT, parenleft, movetoworkspace, 5"
        "$mod SHIFT, equal, movetoworkspace, 6"
        "$mod SHIFT, asterisk, movetoworkspace, 7"
        "$mod SHIFT, parenright, movetoworkspace, 8"
        "$mod SHIFT, plus, movetoworkspace, 9"
        "$mod SHIFT, bracketright, movetoworkspace, 10"

        # Workspace scroll
        "$mod CONTROL, right, workspace, e+1"
        "$mod CONTROL, left, workspace, e-1"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Alt-tab
        "ALT, Tab, cyclenext"
        "ALT, Tab, bringactivetotop"

        # Media keys
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        # Brightness
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"

        # Lock screen
        "$mod CONTROL, L, exec, hyprlock"

        # Terminal shortcuts
        "$mod, Z, exec, ${terminal}"
        ", Scroll_Lock, exec, ${terminal}"
        "$mod, N, exec, ${terminal} newsboat"
      ];

      # Repeat binds (hold to repeat)
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

    };
  };
}
