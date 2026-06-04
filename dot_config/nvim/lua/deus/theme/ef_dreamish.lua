-- ef_dreamish.lua — a minimal Neovim theme inspired by Emacs ef-dream
-- Palette
local P = {
  bg         = "#131015",
  fg         = "#eaeaea",
  cursorline = "#232224",
  comment    = "#8a8a8a",
  string     = "#d9c6a3",
  keyword    = "#ebdbb2",
  func       = "#f6a46f",
  type       = "#d1b88c",
  const      = "#caa6ff",
  number     = "#ffae57",
  error      = "#ff6b6b",
  warn       = "#ffb86b",
  info       = "#6cc1ff",
  hint       = "#7dd3a7",
  line_nr    = "#6a6a6a",
  nontext    = "#4a444e",

  -- statusline (mode-line)
  stl_bg     = "#472b00",
  stl_fg     = "#f2ddcf",
  stl_bg_nc  = "#2b1a00",
  stl_fg_nc  = "#bcae9f",
  visual_bg  = "#3b2a12",
  matchparen = "#6b4b1a",
  pmenu_bg   = "#1c1a1f",
  pmenu_sel  = "#2a2730",
  search_bg  = "#6b4b1a",
  search_fg  = "#ffffff",
}

local function HI(group, opts) vim.api.nvim_set_hl(0, group, opts) end

local function apply()
  vim.o.termguicolors = true
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
  vim.g.colors_name = "ef_dreamish"

  -- Core
  HI("Normal", { fg = P.fg, bg = P.bg })
  HI("NormalFloat", { fg = P.fg, bg = P.bg })
  HI("ColorColumn", { bg = "#1b181e" })
  HI("NonText", { fg = P.nontext })
  HI("CursorLine", { bg = P.cursorline })
  HI("Visual", { bg = P.visual_bg })
  HI("MatchParen", { bg = P.matchparen })
  HI("Search", { fg = P.search_fg, bg = P.search_bg })
  HI("IncSearch", { fg = P.search_fg, bg = P.search_bg })

  -- Fighting for left padding
  HI("LineNr", { fg = P.line_nr, bg = P.bg })
  HI("CursorLineNr", { fg = P.fg, bg = P.cursorline })
  HI("FoldColumn", { bg = P.bg })
  HI("SignColumn", { bg = P.bg })

  -- Popup/menu
  HI("Pmenu", { fg = P.fg, bg = P.pmenu_bg })
  HI("PmenuSel", { fg = P.fg, bg = P.pmenu_sel })
  HI("PmenuSbar", { bg = P.pmenu_sel })
  HI("PmenuThumb", { bg = P.pmenu_sel })

  -- Syntax (disable bold/italic everywhere)
  local nobi = { bold = false, italic = false }
  HI("Comment", vim.tbl_extend("force", { fg = P.comment }, nobi))
  HI("String", vim.tbl_extend("force", { fg = P.string }, nobi))
  HI("Constant", vim.tbl_extend("force", { fg = P.const }, nobi))
  HI("Number", vim.tbl_extend("force", { fg = P.number }, nobi))
  HI("Boolean", vim.tbl_extend("force", { fg = P.number }, nobi))
  HI("Identifier", vim.tbl_extend("force", { fg = P.fg }, nobi))
  HI("Function", vim.tbl_extend("force", { fg = P.func }, nobi))
  HI("Statement", vim.tbl_extend("force", { fg = P.keyword }, nobi))
  HI("Keyword", vim.tbl_extend("force", { fg = P.keyword }, nobi))
  HI("Type", vim.tbl_extend("force", { fg = P.type }, nobi))
  HI("Operator", vim.tbl_extend("force", { fg = P.fg }, nobi))
  HI("Delimiter", vim.tbl_extend("force", { fg = P.fg }, nobi))
  HI("Special", vim.tbl_extend("force", { fg = P.const }, nobi))

  -- Treesitter (link to basic groups)
  local links = {
    ["@comment"]          = "Comment",
    ["@string"]           = "String",
    ["@number"]           = "Number",
    ["@boolean"]          = "Boolean",
    ["@constant"]         = "Constant",
    ["@constant.builtin"] = "Constant",
    ["@function"]         = "Function",
    ["@function.call"]    = "Function",
    ["@method"]           = "Function",
    ["@field"]            = "Identifier",
    ["@property"]         = "Identifier",
    ["@type"]             = "Type",
    ["@type.builtin"]     = "Type",
    ["@keyword"]          = "Keyword",
    ["@keyword.function"] = "Keyword",
    ["@operator"]         = "Operator",
    ["@punctuation"]      = "Delimiter",
  }
  for ts, base in pairs(links) do vim.api.nvim_set_hl(0, ts, { link = base }) end

  -- Diagnostics
  HI("DiagnosticError", { fg = P.error })
  HI("DiagnosticWarn", { fg = P.warn })
  HI("DiagnosticInfo", { fg = P.info })
  HI("DiagnosticHint", { fg = P.hint })
  HI("DiagnosticUnderlineError", { undercurl = true, sp = P.error })
  HI("DiagnosticUnderlineWarn", { undercurl = true, sp = P.warn })
  HI("DiagnosticUnderlineInfo", { undercurl = true, sp = P.info })
  HI("DiagnosticUnderlineHint", { undercurl = true, sp = P.hint })

  -- Statusline (if you use vanilla ‘statusline’)
  HI("StatusLine", { fg = P.stl_fg, bg = P.stl_bg })
  HI("StatusLineNC", { fg = P.stl_fg_nc, bg = P.stl_bg_nc })
end

apply()
return {}
