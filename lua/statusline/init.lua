return {
  setup = function()
    vim.opt.laststatus = 3
    vim.opt.statusline = "%!v:lua.require('statusline.render')()"
  end,
}
