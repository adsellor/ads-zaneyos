{ lib
, username
, host
, config
, ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout
    fileManager
    ;
in
with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
          env = NIXOS_OZONE_WL, 1
          env = NIXPKGS_ALLOW_UNFREE, 1
          env = XDG_CURRENT_DESKTOP, Hyprland
          env = XDG_SESSION_TYPE, wayland
          env = XDG_SESSION_DESKTOP, Hyprland
          env = GDK_BACKEND, wayland, x11
          env = CLUTTER_BACKEND, wayland
          env = QT_QPA_PLATFORM=wayland;xcb
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
          env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
          env = SDL_VIDEODRIVER, x11
          env = MOZ_ENABLE_WAYLAND, 1
          exec-once = dbus-update-activation-environment --systemd --all
          exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once = killall -q swww;sleep .5 && swww-daemon
          # exec-once = killall -q waybar;sleep .5 && waybar
          # exec-once = killall -q swaync;sleep .5 && swaync
          # exec-once = nm-applet --indicator
          exec-once = lxqt-policykit-agent
          exec-once = sleep 1.5 && swww img /home/${username}/Pictures/Wallpapers/galaxy.png
          exec-once = auto-dnd
          monitor=,2560x1440@240,auto,1
          exec-once = hyprsession
          ${extraMonitorSettings}
          general {
            gaps_in = 6
            gaps_out = 8
            border_size = 2
            layout = dwindle
            resize_on_border = true
            col.active_border = rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg
            col.inactive_border = rgb(${config.stylix.base16Scheme.base01})
          }
          input {
            kb_layout = ${keyboardLayout}
            kb_variant = dvp,phonetic
            kb_options = grp:ctrl_space_toggle
            follow_mouse = 0
            touchpad {
              natural_scroll = true
              disable_while_typing = true
              scroll_factor = 0.8
            }
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            accel_profile = flat
          }
          windowrulev2 = float, silent, title:^(Picture-in-Picture)$
          windowrulev2 = pin, silent, title:^(Picture-in-Picture)$
          windowrulev2 = opacity 1.0 override, title:^(Picture-in-Picture)$
          windowrulev2 = size 20% 20%, title:^(Picture-in-Picture)$
          windowrulev2 = move 100%-20% 60, title:^(Picture-in-Picture)$
          windowrulev2 = noinitialfocus, title:^(Picture-in-Picture)$
          windowrulev2 = keepaspectratio, title:^(Picture-in-Picture)$
          windowrulev2 = workspace 2, class:^(${terminal})$
          windowrulev2 = workspace 1, class:^(zen)$
          windowrulev2 = workspace 1, class:^(zen)$
          windowrulev2 = workspace special:one, class:^(Signal)$
          windowrulev2 = workspace special:one, class:^(telegram-desktop)$
          windowrulev2 = workspace special:one, class:^(org.telegram.desktop)$
          windowrulev2 = workspace special:two, class:^(slack)$
          misc {
            initial_workspace_tracking = true
            mouse_move_enables_dpms = true
            key_press_enables_dpms = false
            focus_on_activate = true
          }
          animations {
            enabled = yes
            bezier = wind, 0.05, 0.9, 0.1, 1.05
            bezier = winIn, 0.1, 1.1, 0.1, 1.1
            bezier = winOut, 0.3, -0.3, 0, 1
            bezier = liner, 1, 1, 1, 1
            animation = windows, 1, 6, wind, slide
            animation = windowsIn, 1, 6, winIn, slide
            animation = windowsOut, 1, 5, winOut, slide
            animation = windowsMove, 1, 5, wind, slide
            animation = border, 1, 1, liner
            animation = fade, 1, 10, default
            animation = workspaces, 0, 5, wind
          }
          decoration {
            rounding = 20
            shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
            }
            blur {
                enabled = true
                size = 5
                passes = 3
                new_optimizations = on
                ignore_opacity = off
            }
          }
          plugin {
            hyprtrails {
            }
          }
          plugin {
            csgo-vulkan-fix {
              res_w = 1920
              res_h = 1440
            }
          }

          dwindle {
            pseudotile = true
            preserve_split = true
          }
          bind = ${modifier},Return,exec,${terminal}
          bind = ${modifier}SHIFT,Return,exec,rofi-launcher
          bind = ${modifier}SHIFT,W,exec,web-search
          bind = ${modifier}ALT,W,exec,wallsetter
          bind = ${modifier}SHIFT,N,exec,swaync-client -rs
          bind = ${modifier},W,exec,${browser}
          bind = ${modifier},E,exec,emopicker9000
          bind = ${modifier}SHIFT,S,exec,screenshootin
          bind = ${modifier},D,exec,discord
          bind = ${modifier},O,exec,obs
          bind = ${modifier},C,exec,hyprpicker -a
          bind = ${modifier},G,exec,gimp
          bind = ${modifier}SHIFT,G,exec,godot4
          bind = ${modifier},T,exec,thunar
          bind = ${modifier},Y,exec, ${terminal} ${fileManager}
          bind = ${modifier},M,exec,spotify
          bind = ${modifier},Q,killactive,
          bind = ${modifier},P,pseudo,
          bind = ${modifier}SHIFT,I,togglesplit,
          bind = ${modifier},F,fullscreen,
          bind = ${modifier}SHIFT,F,togglefloating,
          bind = ${modifier}SHIFT,left,movewindow,l
          bind = ${modifier}SHIFT,right,movewindow,r
          bind = ${modifier}SHIFT,up,movewindow,u
          bind = ${modifier}SHIFT,down,movewindow,d
          bind = ${modifier}SHIFT,h,movewindow,l
          bind = ${modifier}SHIFT,l,movewindow,r
          bind = ${modifier}SHIFT,k,movewindow,u
          bind = ${modifier}SHIFT,j,movewindow,d
          bind = ${modifier},left,movefocus,l
          bind = ${modifier},right,movefocus,r
          bind = ${modifier},up,movefocus,u
          bind = ${modifier},down,movefocus,d
          bind = ${modifier},h,movefocus,l
          bind = ${modifier},l,movefocus,r
          bind = ${modifier},k,movefocus,u
          bind = ${modifier},j,movefocus,d
          bind = ${modifier},ampersand,workspace,1
          bind = ${modifier},bracketleft,workspace,2
          bind = ${modifier},braceleft,workspace,3
          bind = ${modifier},braceright,workspace,4
          bind = ${modifier},parenleft,workspace,5
          bind = ${modifier},equal,workspace,6
          bind = ${modifier},asterisk,workspace,7
          bind = ${modifier},parenright,workspace,8
          bind = ${modifier},plus,workspace,9
          bind = ${modifier},bracketright,workspace,10
          bind = ${modifier}SHIFT,SPACE,movetoworkspace,special:one
          bind = ${modifier},SPACE,togglespecialworkspace,one
          bind = ${modifier}SHIFT,Tab,movetoworkspace,special:two
          bind = ${modifier},Tab,togglespecialworkspace,two
          bind = ${modifier}SHIFT,ampersand,movetoworkspace,1
          bind = ${modifier}SHIFT,bracketleft,movetoworkspace,2
          bind = ${modifier}SHIFT,braceleft,movetoworkspace,3
          bind = ${modifier}SHIFT,braceright,movetoworkspace,4
          bind = ${modifier}SHIFT,parenleft,movetoworkspace,5
          bind = ${modifier}SHIFT,equal,movetoworkspace,6
          bind = ${modifier}SHIFT,asterisk,movetoworkspace,7
          bind = ${modifier}SHIFT,parenright,movetoworkspace,8
          bind = ${modifier}SHIFT,plus,movetoworkspace,9
          bind = ${modifier}SHIFT,bracketright,movetoworkspace,10
          bind = ${modifier}CONTROL,right,workspace,e+1
          bind = ${modifier}CONTROL,left,workspace,e-1
          bind = ${modifier},mouse_down,workspace, e+1
          bind = ${modifier},mouse_up,workspace, e-1
          bindm = ${modifier},mouse:272,movewindow
          bindm = ${modifier},mouse:273,resizewindow
          bind = ALT,Tab,cyclenext
          bind = ALT,Tab,bringactivetotop
          binde = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          binde = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = ,XF86AudioPlay, exec, playerctl play-pause
          bind = ,XF86AudioPause, exec, playerctl play-pause
          bind = ,XF86AudioNext, exec, playerctl next
          bind = ,XF86AudioPrev, exec, playerctl previous
          bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
          bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
          bind = ${modifier}CONTROL,L, exec, hyprlock
          bind = ${modifier},Z,exec,${terminal}
          bind = ,Scroll_Lock,exec,${terminal}
          bind = ${modifier},N,exec,${terminal} newsboat
        ''
      ];
  };
}
