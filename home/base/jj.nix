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
      signing = {
        backend = "ssh";
        key = "~/.ssh/codeberg-sign.pub";
      };
      git.sign-on-push = true;
    };
  };
}
