local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')


dashboard.section.header.val = {
"Himonshu's",
"███    ██ ███████  ██████  ██    ██ ██ ███    ███",
"████   ██ ██      ██    ██ ██    ██ ██ ████  ████",
"██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██",
"██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██",
"██   ████ ███████  ██████    ████   ██ ██      ██"
}

dashboard.section.buttons.val = {
  dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
  dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("g", "  Find word", ":Telescope live_grep <CR>"),
  dashboard.button("s", "  Last session", ":lua require('persistence').load({ last = true })<CR>"),
  dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

dashboard.section.footer.val = {
  "",
  "  Happy coding!",
}

dashboard.section.footer.opts = {
  position = "center",
  hl = "Comment",
}

alpha.setup(dashboard.opts)
