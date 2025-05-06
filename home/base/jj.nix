{...}:
  let
    inherit (import ../../hosts/fern/variables.nix) gitUsername gitEmail;
  in
  {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name  = "${gitUsername}";
        email  = "${gitEmail}";
      };
      ui = {
        pager = "bat";
      };
    };
  };
}
