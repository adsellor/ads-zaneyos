{ pkgs, ... }:
let
  raddebugger = pkgs.callPackage ../../pkgs/raddebugger { };
in
{
  home.packages = [ raddebugger ];

  xdg.desktopEntries.raddbg = {
    name = "RAD Debugger";
    genericName = "Debugger";
    exec = "${raddebugger}/bin/raddbg";
    icon = "${raddebugger}/share/icons/hicolor/256x256/apps/raddbg.png";
    categories = [ "Development" "Debugger" ];
    settings.StartupWMClass = "RADDBG";
  };
}
