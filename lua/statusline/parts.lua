local modes = {
  ['n'] = { 'NORMAL', 'StatusLineNormalMode' },
  ['niI'] = { 'NORMAL i', 'StatusLineNormalMode' },
  ['niR'] = { 'NORMAL r', 'StatusLineNormalMode' },
  ['niV'] = { 'NORMAL v', 'StatusLineNormalMode' },
  ['no'] = { 'N-PENDING', 'StatusLineNormalMode' },
  ['i'] = { 'INSERT', 'StatusLineInsertMode' },
  ['ic'] = { 'INSERT', 'StatusLineInsertMode' },
  ['ix'] = { 'INSERT completion', 'StatusLineInsertMode' },
  ['t'] = { 'TERMINAL', 'StatusLineTerminalMode' },
  ['nt'] = { 'NTERMINAL', 'StatusLineNTerminalMode' },
  ['v'] = { 'VISUAL', 'StatusLineVisualMode' },
  ['V'] = { 'V-LINE', 'StatusLineVisualMode' },
  [''] = { 'V-BLOCK', 'StatusLineVisualMode' },
  ['R'] = { 'REPLACE', 'StatusLineReplaceMode' },
  ['Rv'] = { 'V-REPLACE', 'StatusLineReplaceMode' },
  ['s'] = { 'SELECT', 'StatusLineSelectMode' },
  ['S'] = { 'S-LINE', 'StatusLineSelectMode' },
  [''] = { 'S-BLOCK', 'StatusLineSelectMode' },
  ['c'] = { 'COMMAND', 'StatusLineCommandMode' },
  ['cv'] = { 'COMMAND', 'StatusLineCommandMode' },
  ['ce'] = { 'COMMAND', 'StatusLineCommandMode' },
  ['r'] = { 'PROMPT', 'StatusLineConfirmMode' },
  ['rm'] = { 'MORE', 'StatusLineConfirmMode' },
  ['r?'] = { 'CONFIRM', 'StatusLineConfirmMode' },
  ['!'] = { 'SHELL', 'StatusLineTerminalMode' },
}

local cover_nvim_tree = function()
  for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    local filetype = vim.bo[vim.api.nvim_win_get_buf(win)].ft
    if filetype == 'NvimTree' or filetype == 'DiffviewFiles' then
      return '%#NvimTreeNormal#' .. string.rep(' ', vim.api.nvim_win_get_width(win) + 1)
    end
  end
  return ''
end

local mode = function()
  local mode = vim.api.nvim_get_mode().mode
  return '%#' .. modes[mode][2] .. 'Sep#%#' .. modes[mode][2] .. '#  ' .. modes[mode][1] .. '  '
end

local pwd = function()
  local dir_name = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.')
  local kek = '%#StatusLineText#' .. '  ' .. dir_name:gsub('/', ' / ') .. '  '

  return kek .. '%#StatusLineSeparator#%#StatusLineNone#'
end

local lsp_progress = function()
  local Lsp = vim.lsp.util.get_progress_messages()[1]

  if vim.o.columns < 120 or not Lsp then
    return ''
  end

  local msg = Lsp.message or ''
  local percentage = Lsp.percentage or 0
  local title = Lsp.title or ''
  local spinners = { '', '' }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  local content = string.format(' %%<%s %s %s (%s%%%%) ', spinners[frame + 1], title, msg, percentage)

  return ('%#StatusLineLspProgress# ' .. content .. ' ') or ''
end

local lsp_diagnostics = function(result)
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  local data = {}

  if errors and errors > 0 then
    table.insert(data, '%#StatusLineLspError# ' .. errors)
  end

  if warnings and warnings > 0 then
    table.insert(data, '%#StatusLineLspWarning# ' .. warnings)
  end

  if hints and hints > 0 then
    table.insert(data, '%#StatusLineLspHints#ﯧ ' .. hints)
  end

  if info and info > 0 then
    table.insert(data, '%#StatusLineLspInfo# ' .. info)
  end

  if #data > 0 then
    table.insert(result, table.concat(data, ' '))
  end

  return result
end

local lsp_status = function(result)
  local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'filetype')
  local data = {}
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name ~= 'null-ls' then
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        table.insert(data, client.name)
      end
    end
  end

  local sources = require 'null-ls.sources'

  for _, source in ipairs(sources.get_available(filetype)) do
    table.insert(data, source.name .. '*')
  end

  if next(data) ~= nil then
    table.insert(result, '%#StatusLineLspStatus#  LSP ' .. table.concat(data, ', '))
    return result
  end

  return result
end

local dap_status = function(result)
  local status, dap = pcall(require, 'dap')
  if not status then
    return ''
  end

  local session = dap.session()
  if session ~= nil then
    table.insert(result, '%#StatusLineDap# DAP ' .. session.config.name)
  end

  return result
end

local git = function(result)
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return result
  end

  local git_status = vim.b.gitsigns_status_dict

  local data = { '%#StatusLineText# ' .. git_status.head }

  if git_status.added and git_status.added ~= 0 then
    table.insert(data, '%#StatusLineGitAdded# ' .. git_status.added)
  end

  if git_status.changed and git_status.changed ~= 0 then
    table.insert(data, '%#StatusLineGitChanged# ' .. git_status.changed)
  end

  if git_status.removed and git_status.removed ~= 0 then
    table.insert(data, '%#StatusLineGitRemoved# ' .. git_status.removed)
  end

  table.insert(result, table.concat(data, ' '))
  return result
end

local project = function(result)
  table.insert(result, '%#StatusLineText# ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'))
  return result
end

return {
  cover_nvim_tree = cover_nvim_tree,
  mode = mode,
  pwd = pwd,
  lsp_progress = lsp_progress,
  lsp_diagnostics = lsp_diagnostics,
  lsp_status = lsp_status,
  dap_status = dap_status,
  git = git,
  project = project,
}
