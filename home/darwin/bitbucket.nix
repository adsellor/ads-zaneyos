{
  # Credentials for octo.nvim's Bitbucket reviews. The token stays in the login keychain
  # (service "bitbucket-api-token"), never in the nix store.
  programs.fish.interactiveShellInit = ''
    set -gx BITBUCKET_EMAIL zaven.s@prelaunch.com
    set -gx BITBUCKET_API_TOKEN (security find-generic-password -s bitbucket-api-token -w 2>/dev/null)
  '';
}
