{ pkgs
, username
, ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "docker"
      ];
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [
        signal-desktop
        telegram-desktop
        lazygit
        gpu-screen-recorder
        gpu-screen-recorder-gtk
        nodejs
        yazi
        obs-studio
        jq
        fishPlugins.fzf-fish
        fishPlugins.forgit
        fzf
        fishPlugins.grc
        grc
        go-task
        prettierd
        eslint_d
        typescript
        element-desktop
      ];
    };
    # "newuser" = {
    #   homeMode = "755";
    #   isNormalUser = true;
    #   description = "New user account";
    #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    #   shell = pkgs.bash;
    #   ignoreShellProgramCheck = true;
    #   packages = with pkgs; [];
    # };
  };
}
