{ config, lib, ... }: {
    programs.zellij = {
      enable = true;
      settings = {
        default_layout = "compact";
      };
      # Auto-start is set up below so it can skip Rex, which is already a multiplexer.
      enableFishIntegration = false;
    };

    programs.fish.interactiveShellInit = lib.mkAfter ''
      if test "$TERM" != dumb; and test "$TERM_PROGRAM" != rex
        eval (${lib.getExe config.programs.zellij.package} setup --generate-auto-start fish | string collect)
      end
    '';
}
