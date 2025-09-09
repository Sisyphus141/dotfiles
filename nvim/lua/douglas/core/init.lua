require("douglas.core.keymaps")
require("douglas.core.options")


-- Make Neovim background transparent (works in Alacritty w/ compositor blur)
vim.opt.termguicolors = true

local function set_transparent()
  local hl = vim.api.nvim_set_hl
  hl(0, "Normal",      { bg = "none" })
  hl(0, "NormalFloat", { bg = "none" })  -- popups/floating windows
  hl(0, "NonText",     { bg = "none" })
  hl(0, "SignColumn",  { bg = "none" })
  hl(0, "LineNr",      { bg = "none" })
  -- optional:
  -- hl(0, "CursorLine",  { bg = "none" })
  -- hl(0, "StatusLine",  { bg = "none" })
end

-- Apply now…
set_transparent()
-- …and re-apply whenever a colorscheme changes (many set a solid bg)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_transparent,
})

