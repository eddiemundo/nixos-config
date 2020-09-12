self: super: {
  neovim = super.neovim.override {
    configure = {
      # for vim-plug
      # plug.plugins = with self.vimPlugins; []; 
    };
  };
}
