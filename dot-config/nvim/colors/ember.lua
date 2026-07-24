-- Ember: gruvbox pigments, ember grammar (Daily) / vesper grammar (Weekend)
-- Variant: vim.g.ember_variant = "daily" (default) | "weekend"
-- Mode follows vim.o.background.

vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd.syntax("reset")
end
vim.g.colors_name = "ember"

local variant = vim.g.ember_variant or "daily"
local dark = vim.o.background == "dark"

local palettes = {
  daily_dark = {
    -- nvim is all editor canvas, so the whole ladder starts at Zed's editor bg
    bg0 = "#2e2a25", bg1 = "#38332b", bg2 = "#403a30", sel = "#463f34",
    fg = "#ddc7a1", muted = "#a89984", faint = "#928374", disabled = "#665c54",
    red = "#ea6962", green = "#a9b665", yellow = "#d8a657", blue = "#83a598",
    purple = "#d3869b", aqua = "#89b482", orange = "#e78a4e",
    kw = "#bf7a6a", fn = "#a9b665", str = "#89b482", num = "#d3869b",
    typ = "#d8a657", comment = "#928374",
  },
  daily_light = {
    bg0 = "#f7f3ea", bg1 = "#efeade", bg2 = "#e9e2d2", sel = "#e3dcca",
    fg = "#3c3836", muted = "#7c6f64", faint = "#928374", disabled = "#a89984",
    red = "#c14a4a", green = "#6c782e", yellow = "#b47109", blue = "#45707a",
    purple = "#945e80", aqua = "#4c7a5d", orange = "#c35e0a",
    kw = "#a0604f", fn = "#6c782e", str = "#4c7a5d", num = "#945e80",
    typ = "#b47109", comment = "#928374",
  },
  weekend_dark = {
    bg0 = "#131110", bg1 = "#1a1715", bg2 = "#221e1a", sel = "#2e2921",
    fg = "#f3e7cd", muted = "#a89984", faint = "#5f574c", disabled = "#4a443c",
    red = "#f47a72", green = "#99d8ac", yellow = "#f2cd8b", blue = "#83a598",
    purple = "#d3869b", aqua = "#89b482", orange = "#f2cd8b",
    kw = "#a89984", fn = "#f2cd8b", str = "#d9c1ff", num = "#f2cd8b",
    typ = "#f2cd8b", comment = "#5f574c",
  },
  weekend_light = {
    bg0 = "#f6f2ea", bg1 = "#eee9dd", bg2 = "#e8e1d2", sel = "#e1dac9",
    fg = "#221e18", muted = "#7c6f64", faint = "#a49a89", disabled = "#b5ac9c",
    red = "#c14a4a", green = "#2e7a58", yellow = "#96731f", blue = "#45707a",
    purple = "#945e80", aqua = "#4c7a5d", orange = "#96731f",
    kw = "#7c6f64", fn = "#96731f", str = "#6f5694", num = "#96731f",
    typ = "#96731f", comment = "#a49a89",
  },
}

local p = palettes[variant .. (dark and "_dark" or "_light")] or palettes.daily_dark
local kw_italic = variant == "daily"

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- :terminal ANSI palette (lazygit, fzf, etc.)
local term = {
  [0] = dark and p.bg2 or p.fg,
  [1] = p.red, [2] = p.green, [3] = p.yellow, [4] = p.blue,
  [5] = p.purple, [6] = p.aqua,
  [7] = dark and p.fg or p.bg1,
  [8] = dark and p.disabled or p.muted,
  [9] = p.red, [10] = p.green, [11] = p.yellow, [12] = p.blue,
  [13] = p.purple, [14] = p.aqua,
  [15] = dark and p.fg or p.bg0,
}
for i, c in pairs(term) do
  vim.g["terminal_color_" .. i] = c
end

-- UI
hl("Normal", { fg = p.fg, bg = p.bg0 })
hl("NormalNC", { fg = p.fg, bg = p.bg0 })
hl("NormalFloat", { fg = p.fg, bg = p.bg1 })
hl("FloatBorder", { fg = p.muted, bg = p.bg1 })
hl("FloatTitle", { fg = p.typ, bg = p.bg1, bold = true })
hl("Pmenu", { fg = p.fg, bg = p.bg1 })
hl("PmenuSel", { bg = p.sel })
hl("PmenuSbar", { bg = p.bg2 })
hl("PmenuThumb", { bg = p.muted })
hl("PmenuMatch", { fg = p.fn, bold = true })
hl("PmenuMatchSel", { fg = p.fn, bg = p.sel, bold = true })
hl("Cursor", { fg = p.bg0, bg = p.fg })
hl("lCursor", { fg = p.bg0, bg = p.fg })
hl("TermCursor", { fg = p.bg0, bg = p.fg })
hl("WinBar", { fg = p.muted, bg = p.bg0 })
hl("WinBarNC", { fg = p.disabled, bg = p.bg0 })
hl("CursorLine", { bg = p.bg1 })
hl("CursorColumn", { bg = p.bg1 })
hl("ColorColumn", { bg = p.bg1 })
hl("CursorLineNr", { fg = p.fg, bold = true })
hl("LineNr", { fg = p.disabled })
hl("SignColumn", { bg = p.bg0 })
hl("Visual", { bg = p.sel })
hl("VisualNOS", { bg = p.sel })
hl("Search", { fg = p.bg0, bg = p.yellow })
hl("IncSearch", { fg = p.bg0, bg = p.orange })
hl("CurSearch", { fg = p.bg0, bg = p.orange })
hl("MatchParen", { bg = p.bg2, bold = true })
hl("StatusLine", { fg = p.fg, bg = p.bg1 })
hl("StatusLineNC", { fg = p.muted, bg = p.bg1 })
hl("WinSeparator", { fg = p.bg2 })
hl("TabLine", { fg = p.muted, bg = p.bg1 })
hl("TabLineSel", { fg = p.fg, bg = p.bg0 })
hl("TabLineFill", { bg = p.bg1 })
hl("Folded", { fg = p.muted, bg = p.bg1, italic = true })
hl("FoldColumn", { fg = p.disabled, bg = p.bg0 })
hl("NonText", { fg = p.disabled })
hl("Whitespace", { fg = p.bg2 })
hl("SpecialKey", { fg = p.disabled })
hl("EndOfBuffer", { fg = p.bg0 })
hl("Directory", { fg = p.blue })
hl("Title", { fg = p.typ, bold = true })
hl("ErrorMsg", { fg = p.red, bold = true })
hl("WarningMsg", { fg = p.yellow })
hl("MoreMsg", { fg = p.green })
hl("Question", { fg = p.green })
hl("ModeMsg", { fg = p.fg, bold = true })
hl("QuickFixLine", { bg = p.sel })
hl("WildMenu", { fg = p.bg0, bg = p.yellow })

-- diffs
hl("DiffAdd", { bg = dark and "#2a3225" or "#e2e8ce" })
hl("DiffChange", { bg = dark and "#33301f" or "#ede3c3" })
hl("DiffDelete", { fg = p.red, bg = dark and "#372423" or "#f0dad4" })
hl("DiffText", { bg = dark and "#4a4222" or "#e6d5a3" })
hl("Added", { fg = p.green })
hl("Changed", { fg = p.yellow })
hl("Removed", { fg = p.red })

-- spell
hl("SpellBad", { undercurl = true, sp = p.red })
hl("SpellCap", { undercurl = true, sp = p.yellow })
hl("SpellLocal", { undercurl = true, sp = p.aqua })
hl("SpellRare", { undercurl = true, sp = p.purple })

-- syntax (ember grammar: quiet keywords, distinct roles)
hl("Comment", { fg = p.comment, italic = true })
hl("Constant", { fg = kw_italic and p.blue or p.num })
hl("String", { fg = p.str })
hl("Character", { fg = p.str })
hl("Number", { fg = p.num })
hl("Boolean", { fg = kw_italic and p.blue or p.num })
hl("Float", { fg = p.num })
hl("Identifier", { fg = p.fg })
hl("Function", { fg = p.fn })
hl("Statement", { fg = p.kw, italic = kw_italic })
hl("Conditional", { fg = p.kw, italic = kw_italic })
hl("Repeat", { fg = p.kw, italic = kw_italic })
hl("Label", { fg = p.orange })
hl("Operator", { fg = p.muted })
hl("Keyword", { fg = p.kw, italic = kw_italic })
hl("Exception", { fg = p.kw, italic = kw_italic })
hl("PreProc", { fg = p.kw })
hl("Include", { fg = p.kw, italic = kw_italic })
hl("Define", { fg = p.kw })
hl("Macro", { fg = p.orange })
hl("PreCondit", { fg = p.kw })
hl("Type", { fg = p.typ })
hl("StorageClass", { fg = p.kw, italic = kw_italic })
hl("Structure", { fg = p.typ })
hl("Typedef", { fg = p.typ })
hl("Special", { fg = p.orange })
hl("SpecialChar", { fg = p.orange })
hl("Tag", { fg = p.typ })
hl("Delimiter", { fg = p.muted })
hl("SpecialComment", { fg = p.comment, bold = true })
hl("Todo", { fg = p.bg0, bg = p.yellow, bold = true })
hl("Underlined", { fg = p.blue, underline = true })
hl("Error", { fg = p.red, bold = true })
hl("Debug", { fg = p.orange })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@comment.documentation", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.operator", { fg = p.kw })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.import", { link = "Include" })
hl("@keyword.conditional", { link = "Conditional" })
hl("@keyword.repeat", { link = "Repeat" })
hl("@keyword.exception", { link = "Exception" })
hl("@function", { link = "Function" })
hl("@function.call", { link = "Function" })
hl("@function.builtin", { fg = kw_italic and p.orange or p.fn })
hl("@function.method", { link = "Function" })
hl("@function.method.call", { link = "Function" })
hl("@function.macro", { fg = p.orange })
hl("@constructor", { fg = p.typ })
hl("@string", { link = "String" })
hl("@string.documentation", { link = "String" })
hl("@string.escape", { fg = p.orange })
hl("@string.regexp", { fg = p.orange })
hl("@string.special", { fg = p.orange })
hl("@string.special.symbol", { fg = kw_italic and p.blue or p.num })
hl("@string.special.url", { fg = p.blue, underline = true })
hl("@character", { link = "Character" })
hl("@number", { link = "Number" })
hl("@number.float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { link = "Constant" })
hl("@constant.builtin", { fg = kw_italic and p.blue or p.num })
hl("@constant.macro", { fg = p.orange })
hl("@type", { link = "Type" })
hl("@type.builtin", { fg = p.typ })
hl("@type.definition", { link = "Type" })
hl("@attribute", { fg = p.kw })
hl("@property", { fg = kw_italic and p.blue or p.fg })
hl("@field", { fg = kw_italic and p.blue or p.fg })
hl("@variable", { fg = p.fg })
hl("@variable.builtin", { fg = p.num, italic = true })
hl("@variable.parameter", { fg = p.fg, italic = true })
hl("@variable.member", { fg = kw_italic and p.blue or p.fg })
hl("@module", { fg = p.fg })
hl("@namespace", { fg = p.fg })
hl("@label", { fg = p.orange })
hl("@operator", { link = "Operator" })
hl("@punctuation.bracket", { fg = p.muted })
hl("@punctuation.delimiter", { fg = p.muted })
hl("@punctuation.special", { fg = p.orange })
hl("@tag", { fg = p.typ })
hl("@tag.attribute", { fg = p.fg })
hl("@tag.delimiter", { fg = p.muted })
hl("@markup.heading", { fg = p.typ, bold = true })
hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })
hl("@markup.quote", { fg = p.muted, italic = true })
hl("@markup.link", { fg = p.blue })
hl("@markup.link.url", { fg = p.blue, underline = true })
hl("@markup.raw", { fg = p.str })
hl("@markup.list", { fg = p.orange })
hl("@diff.plus", { fg = p.green })
hl("@diff.minus", { fg = p.red })
hl("@diff.delta", { fg = p.yellow })

-- diagnostics (bright red means error, nothing else)
hl("DiagnosticError", { fg = p.red })
hl("DiagnosticWarn", { fg = p.yellow })
hl("DiagnosticInfo", { fg = p.blue })
hl("DiagnosticHint", { fg = p.muted })
hl("DiagnosticOk", { fg = p.green })
hl("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.yellow })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.muted })
hl("DiagnosticVirtualTextError", { fg = p.red, bg = dark and "#2c1d1c" or "#f0dad4" })
hl("DiagnosticVirtualTextWarn", { fg = p.yellow, bg = dark and "#2b2519" or "#ede3c3" })
hl("DiagnosticVirtualTextInfo", { fg = p.blue, bg = dark and "#1f2523" or "#dfe5dc" })
hl("DiagnosticVirtualTextHint", { fg = p.muted, bg = p.bg1 })
hl("LspReferenceText", { bg = p.bg2 })
hl("LspReferenceRead", { bg = p.bg2 })
hl("LspReferenceWrite", { bg = p.bg2, underline = true })
hl("LspInlayHint", { fg = p.disabled, bg = p.bg1 })

-- git signs
hl("GitSignsAdd", { fg = p.green })
hl("GitSignsChange", { fg = p.yellow })
hl("GitSignsDelete", { fg = p.red })

-- which-key
hl("WhichKey", { fg = p.fn })
hl("WhichKeyGroup", { fg = p.blue })
hl("WhichKeyDesc", { fg = p.fg })
hl("WhichKeySeparator", { fg = p.disabled })
