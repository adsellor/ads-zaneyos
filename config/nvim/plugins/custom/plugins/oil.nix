{
  programs.nixvim = {
    plugins.oil = {
      enable = true;
    };

    extraConfigLua = ''
    local oil = require 'oil'
    oil.setup {
      experimental_watch_for_changs = true,
      view_options = {
        show_hidden = true,
      },
    }
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directiory' })
    '';
  };
}
