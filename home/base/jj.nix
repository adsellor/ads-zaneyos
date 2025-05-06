{...}:
  let
    inherit (import ../../hosts/fern/variables.nix) gitUsername gitEmail;
  in
  {
  programs.jujutsu = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
    extraConfig = {
      user.signingkey = "~/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
      commit.gpgsign = "true";
      tag.gpgsign = "true";
    };
  };
}
