return function()
  local colors = {
    base00 = '#1e222a',
    base01 = '#252931',
    base02 = '#3e4451',
    base03 = '#545862',
    base04 = '#565c64',
    base05 = '#abb2bf',
    base06 = '#b6bdca',
    base07 = '#eeffff',
    base08 = '#f78c6c',
    base09 = '#d19a66',
    base0A = '#ecc48d',
    base0B = '#addb67',
    base0C = '#7fdbca',
    base0D = '#82aaff',
    base0E = '#c792ea',
    base0F = '#be5046',
  }

  local defaultHighlight = {
    { 'StatusLine', { bg = colors.base00 } },
    { 'StatusLineText', { fg = colors.base04, bg = colors.base01 } },
    { 'StatusLineSeparator', { fg = colors.base01, bg = colors.base00 } },

    { 'StatusLineNormalMode', { bg = colors.base0D, fg = colors.base00, bold = true } },
    { 'StatusLineInsertMode', { bg = colors.base0E, fg = colors.base00, bold = true } },
    { 'StatusLineTerminalMode', { bg = colors.base0B, fg = colors.base00, bold = true } },
    { 'StatusLineNTerminalMode', { bg = colors.base0A, fg = colors.base00, bold = true } },
    { 'StatusLineVisualMode', { bg = colors.base0C, fg = colors.base00, bold = true } },
    { 'StatusLineReplaceMode', { bg = colors.base08, fg = colors.base00, bold = true } },
    { 'StatusLineConfirmMode', { bg = colors.base09, fg = colors.base00, bold = true } },
    { 'StatusLineCommandMode', { bg = colors.base0B, fg = colors.base00, bold = true } },
    { 'StatusLineSelectMode', { bg = colors.base0D, fg = colors.base00, bold = true } },

    { 'StatusLineNormalModeSep', { fg = colors.base0D, bg = colors.base00 } },
    { 'StatusLineInsertModeSep', { fg = colors.base0E, bg = colors.base00 } },
    { 'StatusLineTerminalModeSep', { fg = colors.base0B, bg = colors.base00 } },
    { 'StatusLineNTerminalModeSep', { fg = colors.base0A, bg = colors.base00 } },
    { 'StatusLineVisualModeSep', { fg = colors.base0C, bg = colors.base00 } },
    { 'StatusLineReplaceModeSep', { fg = colors.base08, bg = colors.base00 } },
    { 'StatusLineConfirmModeSep', { fg = colors.base09, bg = colors.base00 } },
    { 'StatusLineCommandModeSep', { fg = colors.base0B, bg = colors.base00 } },
    { 'StatusLineSelectModeSep', { fg = colors.base0D, bg = colors.base00 } },

    { 'StatusLineLspError', { fg = colors.base0F, bg = colors.base01 } },
    { 'StatusLineLspWarning', { fg = colors.base0A, bg = colors.base01 } },
    { 'StatusLineLspHints', { fg = colors.base0E, bg = colors.base01 } },
    { 'StatusLineLspInfo', { fg = colors.base0B, bg = colors.base01 } },
    { 'StatusLineLspStatus', { fg = colors.base0D, bg = colors.base01 } },
    { 'StatusLineLspProgress', { fg = colors.base0B, bg = colors.base01 } },

    { 'StatusLineDap', { fg = colors.base0B, bg = colors.base01 } },
  }

  for _, data in pairs(defaultHighlight) do
    vim.api.nvim_set_hl(0, data[1], data[2])
  end
end