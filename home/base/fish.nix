{pkgs, ...}: {
  programs.fish = {
      enable = true;
      plugins = [
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "plugin-git"; src = pkgs.fishPlugins.plugin-git.src; }
        { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      ];
      interactiveShellInit = ''
        set fish_greeting
        fish_vi_key_bindings
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
    };
}
