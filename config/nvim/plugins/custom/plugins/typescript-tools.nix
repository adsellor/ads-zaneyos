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
              # Ensure the server uses the workspace TypeScript version
        typescript.tsdk = "node_modules/typescript/lib";
        tsserver_format_options = {
          __raw = ''
            function(ft)
              return {
                allowIncompleteCompletions = false,
                allowRenameOfImportPath = false,
              }
            end
          '';
        };
        tsserver_plugins = [
          "@styled/typescript-styled-plugin"
        ];
      };
    };
  };
}
