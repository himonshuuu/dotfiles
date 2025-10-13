local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
"███    ██ ███████  ██████  ██    ██ ██ ███    ███",
"████   ██ ██      ██    ██ ██    ██ ██ ████  ████",
"██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██",
"██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██",
"██   ████ ███████  ██████    ████   ██ ██      ██"
}

dashboard.section.buttons.val = {
  dashboard.button("e", "📄  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("r", "📂  Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("f", "🔍  Find file", ":Telescope find_files <CR>"),
  dashboard.button("q", "❌  Quit", ":qa<CR>"),
}

dashboard.section.footer.val = "Happy Coding! 💻"

alpha.setup(dashboard.config)


