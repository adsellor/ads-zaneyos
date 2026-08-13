{
  lib,
  host,
  config,
  ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    keyboardLayout
    fileManager
    ;

  mkLuaInline = lib.generators.mkLuaInline;
  toLua = lib.generators.toLua;
  mkArgs = args: { _args = args; };

  bind =
    keys: dispatcher: options:
    mkArgs [
      keys
      dispatcher
      options
    ];

  dsp = {
    exec_cmd = app: mkLuaInline "hl.dsp.exec_cmd(${toLua { } app})";
    focus = arg: mkLuaInline "hl.dsp.focus(${toLua { } arg})";
    global = arg: mkLuaInline "hl.dsp.global(${toLua { } arg})";
    layout = arg: mkLuaInline "hl.dsp.layout(${toLua { } arg})";
    window = {
      move = arg: mkLuaInline "hl.dsp.window.move(${toLua { } arg})";
      drag = mkLuaInline "hl.dsp.window.drag()";
      resize = mkLuaInline "hl.dsp.window.resize()";
      close = mkLuaInline "hl.dsp.window.close()";
      pseudo = mkLuaInline "hl.dsp.window.pseudo()";
      fullscreen = mkLuaInline "hl.dsp.window.fullscreen()";
      float = mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'';
      cycle_next = mkLuaInline "hl.dsp.window.cycle_next()";
      bring_to_top = mkLuaInline "hl.dsp.window.bring_to_top()";
    };
    workspace = {
      toggle_special = arg: mkLuaInline "hl.dsp.workspace.toggle_special(${toLua { } arg})";
    };
  };

  mod = "SUPER";

  wsKeys = [
    "ampersand"
    "bracketleft"
    "braceleft"
    "braceright"
    "parenleft"
    "equal"
    "asterisk"
    "parenright"
    "plus"
    "bracketright"
  ];
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    xwayland.enable = true;
    systemd.enable = true;

    settings =
      {
        monitor = [
          {
            output = "";
            mode = "2560x1440@240";
            position = "auto";
            scale = 1;
          }
        ];

        env = [
          (mkArgs [ "NIXOS_OZONE_WL" "1" ])
          (mkArgs [ "NIXPKGS_ALLOW_UNFREE" "1" ])
          (mkArgs [ "GDK_BACKEND" "wayland, x11" ])
          (mkArgs [ "CLUTTER_BACKEND" "wayland" ])
          (mkArgs [ "QT_QPA_PLATFORM" "wayland;xcb" ])
          (mkArgs [ "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1" ])
          (mkArgs [ "QT_AUTO_SCREEN_SCALE_FACTOR" "1" ])
          (mkArgs [ "SDL_VIDEODRIVER" "x11" ])
          (mkArgs [ "MOZ_ENABLE_WAYLAND" "1" ])
        ];

        config = {
          general = {
            gaps_in = 6;
            gaps_out = 8;
            border_size = 2;
            layout = "dwindle";
            resize_on_border = true;
            col = {
              active_border = {
                colors = [
                  "rgb(${config.stylix.base16Scheme.base08})"
                  "rgb(${config.stylix.base16Scheme.base0C})"
                ];
                angle = 45;
              };
              inactive_border = "rgb(${config.stylix.base16Scheme.base01})";
            };
          };

          input = {
            kb_layout = keyboardLayout;
            kb_variant = "dvp,phonetic";
            kb_options = "grp:ctrl_space_toggle";
            follow_mouse = 0;
            touchpad = {
              natural_scroll = true;
              disable_while_typing = true;
              scroll_factor = 0.8;
            };
            sensitivity = 0;
            accel_profile = "flat";
          };

          misc = {
            initial_workspace_tracking = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = false;
            focus_on_activate = false;
          };

          animations.enabled = true;

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

          dwindle.preserve_split = true;
        };

        curve = [
          (mkArgs [
            "wind"
            {
              type = "bezier";
              points = mkLuaInline "{ { 0.05, 0.9 }, { 0.1, 1.05 } }";
            }
          ])
          (mkArgs [
            "winIn"
            {
              type = "bezier";
              points = mkLuaInline "{ { 0.1, 1.1 }, { 0.1, 1.1 } }";
            }
          ])
          (mkArgs [
            "winOut"
            {
              type = "bezier";
              points = mkLuaInline "{ { 0.3, -0.3 }, { 0, 1 } }";
            }
          ])
          (mkArgs [
            "liner"
            {
              type = "bezier";
              points = mkLuaInline "{ { 1, 1 }, { 1, 1 } }";
            }
          ])
        ];

        animation = [
          { leaf = "windows"; enabled = true; speed = 6; bezier = "wind"; style = "slide"; }
          { leaf = "windowsIn"; enabled = true; speed = 6; bezier = "winIn"; style = "slide"; }
          { leaf = "windowsOut"; enabled = true; speed = 5; bezier = "winOut"; style = "slide"; }
          { leaf = "windowsMove"; enabled = true; speed = 5; bezier = "wind"; style = "slide"; }
          { leaf = "border"; enabled = true; speed = 1; bezier = "liner"; }
          { leaf = "fade"; enabled = true; speed = 10; bezier = "default"; }
          { leaf = "workspaces"; enabled = true; speed = 5; bezier = "wind"; }
        ];

        window_rule = [
          { match.class = "^(${terminal})$"; workspace = 2; }
          { match.class = "^(zen)$"; workspace = 1; }
          { match.class = "^(Signal)$"; workspace = "special:one"; }
          { match.class = "^(telegram-desktop)$"; workspace = "special:one"; }
          { match.class = "^(org.telegram.desktop)$"; workspace = "special:one"; }
        ];

        on = mkArgs [
          "hyprland.start"
          (mkLuaInline ''
            function()
              hl.exec_cmd("caelestia-shell")
              hl.exec_cmd("lxqt-policykit-agent")
              hl.exec_cmd("auto-dnd")
              hl.exec_cmd("hyprsession")
            end'')
        ];

        bind = lib.flatten [
          # Caelestia launcher
          (bind "${mod} + SHIFT + Return" (dsp.global "caelestia:launcher") { })

          # Application launchers
          (bind "${mod} + Return" (dsp.exec_cmd "${terminal}") { })
          (bind "${mod} + SHIFT + W" (dsp.exec_cmd "web-search") { })
          (bind "${mod} + SHIFT + N" (dsp.exec_cmd "swaync-client -rs") { })
          (bind "${mod} + W" (dsp.exec_cmd "${browser}") { })
          (bind "${mod} + E" (dsp.exec_cmd "emopicker9000") { })
          (bind "${mod} + SHIFT + S" (dsp.exec_cmd "screenshootin") { })
          (bind "${mod} + D" (dsp.exec_cmd "discord") { })
          (bind "${mod} + O" (dsp.exec_cmd "obs") { })
          (bind "${mod} + C" (dsp.exec_cmd "hyprpicker -a") { })
          (bind "${mod} + G" (dsp.exec_cmd "gimp") { })
          (bind "${mod} + SHIFT + G" (dsp.exec_cmd "godot4") { })
          (bind "${mod} + T" (dsp.exec_cmd "thunar") { })
          (bind "${mod} + Y" (dsp.exec_cmd "${terminal} -e ${fileManager}") { })
          (bind "${mod} + M" (dsp.exec_cmd "spotify") { })

          # Window management
          (bind "${mod} + Q" dsp.window.close { })
          (bind "${mod} + P" dsp.window.pseudo { })
          (bind "${mod} + SHIFT + I" (dsp.layout "togglesplit") { })
          (bind "${mod} + F" dsp.window.fullscreen { })
          (bind "${mod} + SHIFT + F" dsp.window.float { })

          # Move windows
          (bind "${mod} + SHIFT + left" (dsp.window.move { direction = "l"; }) { })
          (bind "${mod} + SHIFT + right" (dsp.window.move { direction = "r"; }) { })
          (bind "${mod} + SHIFT + up" (dsp.window.move { direction = "u"; }) { })
          (bind "${mod} + SHIFT + down" (dsp.window.move { direction = "d"; }) { })
          (bind "${mod} + SHIFT + H" (dsp.window.move { direction = "l"; }) { })
          (bind "${mod} + SHIFT + L" (dsp.window.move { direction = "r"; }) { })
          (bind "${mod} + SHIFT + K" (dsp.window.move { direction = "u"; }) { })
          (bind "${mod} + SHIFT + J" (dsp.window.move { direction = "d"; }) { })

          # Move focus
          (bind "${mod} + left" (dsp.focus { direction = "l"; }) { })
          (bind "${mod} + right" (dsp.focus { direction = "r"; }) { })
          (bind "${mod} + up" (dsp.focus { direction = "u"; }) { })
          (bind "${mod} + down" (dsp.focus { direction = "d"; }) { })
          (bind "${mod} + H" (dsp.focus { direction = "l"; }) { })
          (bind "${mod} + L" (dsp.focus { direction = "r"; }) { })
          (bind "${mod} + K" (dsp.focus { direction = "u"; }) { })
          (bind "${mod} + J" (dsp.focus { direction = "d"; }) { })

          # Switch workspaces (Dvorak Programmer keys)
          (lib.imap1 (i: key: bind "${mod} + ${key}" (dsp.focus { workspace = "${toString i}"; }) { }) wsKeys)

          # Special workspaces
          (bind "${mod} + SHIFT + SPACE" (dsp.window.move { workspace = "special:one"; }) { })
          (bind "${mod} + SPACE" (dsp.workspace.toggle_special "one") { })
          (bind "${mod} + SHIFT + Tab" (dsp.window.move { workspace = "special:two"; }) { })
          (bind "${mod} + Tab" (dsp.workspace.toggle_special "two") { })

          # Move to workspaces (Dvorak Programmer keys)
          (lib.imap1 (i: key: bind "${mod} + SHIFT + ${key}" (dsp.window.move { workspace = "${toString i}"; }) { }) wsKeys)

          # Workspace scroll
          (bind "${mod} + CONTROL + right" (dsp.focus { workspace = "e+1"; }) { })
          (bind "${mod} + CONTROL + left" (dsp.focus { workspace = "e-1"; }) { })
          (bind "${mod} + mouse_down" (dsp.focus { workspace = "e+1"; }) { })
          (bind "${mod} + mouse_up" (dsp.focus { workspace = "e-1"; }) { })

          # Alt-tab
          (bind "ALT + Tab" dsp.window.cycle_next { })
          (bind "ALT + Tab" dsp.window.bring_to_top { })

          # Media keys
          (bind "XF86AudioPlay" (dsp.exec_cmd "playerctl play-pause") { locked = true; })
          (bind "XF86AudioPause" (dsp.exec_cmd "playerctl play-pause") { locked = true; })
          (bind "XF86AudioNext" (dsp.exec_cmd "playerctl next") { locked = true; })
          (bind "XF86AudioPrev" (dsp.exec_cmd "playerctl previous") { locked = true; })

          # Brightness
          (bind "XF86MonBrightnessDown" (dsp.exec_cmd "brightnessctl set 5%-") { locked = true; repeating = true; })
          (bind "XF86MonBrightnessUp" (dsp.exec_cmd "brightnessctl set +5%") { locked = true; repeating = true; })

          # Lock screen
          (bind "${mod} + CONTROL + L" (dsp.exec_cmd "loginctl lock-session") { })

          # Terminal shortcuts
          (bind "${mod} + Z" (dsp.exec_cmd "${terminal}") { })
          (bind "Scroll_Lock" (dsp.exec_cmd "${terminal}") { })

          # Volume
          (bind "XF86AudioRaiseVolume" (dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") { locked = true; repeating = true; })
          (bind "XF86AudioLowerVolume" (dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") { locked = true; repeating = true; })
          (bind "XF86AudioMute" (dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") { locked = true; })

          # Mouse bindings
          (bind "${mod} + mouse:272" dsp.window.drag { mouse = true; })
          (bind "${mod} + mouse:273" dsp.window.resize { mouse = true; })
        ];
      };
  };
}
