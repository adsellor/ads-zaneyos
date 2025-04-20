{
  programs.nixvim = {
    plugins.typescript-tools = {
      enable = true;
      settings = {
        tsserver_file_preferences = {
          __raw = ''
            function(ft)
              return {
                includeInlayParameterNameHints = "all",
                includeCompletionsForModuleExports = true,
                quotePreference = "auto",
              }
            end
          '';
        };
        typescript = {
          suggest = {
            enabled = true;
            autoImports = true;
          };
          validate = {
            enable = true;
          };
        };
      };
    };
  };
}
