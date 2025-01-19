{
  programs.nixvim = {
    plugins.leap = {
      enable = true;
    };
    
    extraConfigLua = ''
      local leap = require 'leap'
      leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
      vim.keymap.set({ 'n', 'x', 'o' }, ',', '<Plug>(leap-forward)')
      vim.keymap.set({ 'n', 'x', 'o' }, ',,', '<Plug>(leap-backward)')
      vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          leap.init_highlight(true)
          vim.api.nvim_set_hl(0, 'LeapLabel', {
            -- For light themes, set to 'black' or similar.
            fg = 'red',
            bg = 'bg',
          })
        end,
      })
   '';
  };
}
