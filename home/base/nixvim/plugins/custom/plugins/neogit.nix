{
  programs.nixvim = {
    plugins.neogit = {
      enable = true;
      keymaps = [
        {
          mode = "n";
          key = "<leader>ng";
          action = "<cmd>Neogit<CR>";
          options = {
            desc = "Open Neogit";
          };
        }
      ];
    };
  };
}
