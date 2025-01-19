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
        "podman"
        "docker"
      ];
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [
        signal-desktop
        telegram-desktop
        lazygit
        yazi
        obs-studio
        jq
        fzf
        grc
        go-task
        typescript
        element-desktop
        eslint_d
        eslint
        prettierd
        any-nix-shell
        zathura
        devbox
        corepack
        slack
        nodePackages_latest.graphql-language-service-cli
        zig
        fnm
        beekeeper-studio
        newsboat
        stremio
        gtypist
        podman-tui
        dive
        podman-compose
        transmission_4
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
