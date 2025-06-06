{...}: 
  let
    inherit (import ../../hosts/fern/variables.nix) gitUsername gitEmail;
  in
  {
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
    extraConfig = {
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
