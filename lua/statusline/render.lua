local parts = require 'statusline.parts'

local left = function()
  return table.concat {
    parts.cover_nvim_tree(),
    parts.mode(),
    parts.pwd(),
  }
end

local center = function()
  local lsp_progress = parts.lsp_progress()
  local content = lsp_progress ~= ''
      and '%#StatusLineSeparator#' .. lsp_progress .. '%#StatusLineSeparator#%#StatusLineNone#'
    or ''
  return '%=' .. content .. '%='
end

local right = function()
  local result = {}
  parts.lsp_diagnostics(result)
  parts.lsp_status(result)
  parts.dap_status(result)
  parts.git(result)
  parts.project(result)

  return table.concat {
    '%#StatusLineSeparator#%#StatusLineText#  ',
    table.concat(result, '%#StatusLineText#  |  '),
    '%#StatusLineText#  %#StatusLineSeparator#',
  }
end

return function()
  return table.concat {
    left(),
    center(),
    right(),
  }
end
