{...}:
  let
    inherit (import ../../hosts/fern/variables.nix) gitUsername gitEmail;
  in
  {
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "${gitEmail}";
        name = "${gitUsername}";
      };
      init = {
        defaultBranch = "main";
      };
      user.signingkey = "~/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
      commit.gpgsign = "true";
      tag.gpgsign = "true";
    };
  };
}
