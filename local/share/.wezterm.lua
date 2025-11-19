local wezterm = require 'wezterm'

local config = {}

-- to get it to work in Windows VMs.
-- See: https://github.com/wezterm/wezterm/issues/1813
-- config.prefer_egl = true

-- Disable the title bar (use fancy tab bar instead)
config.window_decorations = "RESIZE" -- Removes title bar but keeps resize border

-- Use a nice font (Hack Nerd Font suggested since user installed nerdfont)
config.font = wezterm.font_with_fallback({
  "Hack Nerd Font",
  "JetBrainsMono Nerd Font",
})
config.font_size = 12.5

-- TrueColor + nice appearance
config.color_scheme = "Tokyo Night"

-- Hide tab bar when only one tab
config.hide_tab_bar_if_only_one_tab = true

-- Padding
config.window_padding = {
  left = 2,
  right = 2,
  top = 1,
  bottom = 1,
}

-- Enable WSL profiles automatically
config.wsl_domains = wezterm.default_wsl_domains()

-- Default to Windows PowerShell
config.default_prog = { "pwsh.exe" }

-- Keybindings similar to tmux / neovim workflows
config.keys = {
  {key="t", mods="CTRL|SHIFT", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
  {key="w", mods="CTRL|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
  {key="h", mods="CTRL|ALT", action=wezterm.action{ActivatePaneDirection="Left"}},
  {key="j", mods="CTRL|ALT", action=wezterm.action{ActivatePaneDirection="Down"}},
  {key="k", mods="CTRL|ALT", action=wezterm.action{ActivatePaneDirection="Up"}},
  {key="l", mods="CTRL|ALT", action=wezterm.action{ActivatePaneDirection="Right"}},
  {key="v", mods="CTRL|ALT", action=wezterm.action{SplitPane={direction="Right", size={Percent=50}}}},
  {key="s", mods="CTRL|ALT", action=wezterm.action{SplitPane={direction="Down", size={Percent=50}}}},
}

-- Smooth scrollback behavior
config.scrollback_lines = 5000

return config
