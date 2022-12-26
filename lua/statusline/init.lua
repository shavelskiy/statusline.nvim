return {
  setup = function(config)
    if config.highlight == true then
      require 'statusline.highlight'()
    end

    vim.opt.laststatus = 3
    vim.opt.statusline = "%!v:lua.require('statusline.render')()"
  end,
}
