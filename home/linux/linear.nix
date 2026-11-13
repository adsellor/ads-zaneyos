{ pkgs, ... }:

let
  linearApp = pkgs.writeShellScriptBin "linear-webapp" ''
    exec ${pkgs.chromium}/bin/chromium \
      --app=https://linear.app \
      --user-data-dir="$HOME/.local/share/chromium-webapps/linear" \
      "$@"
  '';

  linearIcon = pkgs.fetchurl {
    url = "https://linear.app";
    sha256 = "sha256-aaRqdK5bV+8sn1WTQZFefv8xvVxvnu4XNkBBz93sGQU=";
  };
in
{
  home.packages = [ linearApp ];

  xdg.desktopEntries.linear = {
    name = "Linear";
    genericName = "Issue Tracker";
    exec = "${linearApp}/bin/linear-webapp";
    icon = "${linearIcon}";
    categories = [ "Development" ];
    settings = {
      StartupWMClass = "chrome-linear.app__-Default";
    };
  };
}

