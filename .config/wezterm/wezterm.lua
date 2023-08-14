local wezterm = require 'wezterm';

-- cf. https://zenn.dev/yutakatay/articles/wezterm-intro
wezterm.on('trigger-vim-with-scrollback', function(window, pane)
  local scrollback = pane:get_logical_lines_as_text(1024)
  local name = os.tmpname()
  local f = io.open(name, 'w+')
  f:write(scrollback)
  f:flush()
  f:close()
  window:perform_action(
    wezterm.action({ SpawnCommandInNewTab = {
      args = { 'vim', '-c', 'set nospell', name },
    } }),
    pane
  )
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

return {
  font = wezterm.font('HackGenConsoleNF'),
  font_size = 20.0,
  use_ime = false,
  color_scheme = 'Dracula',
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = false,
  enable_csi_u_key_encoding = true,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0, },

  -- key mappings
  keys = {
    {key='q',mods='CTRL',action=wezterm.action{SendString="\x11"}}, -- for macOS
    {key='x',mods='SUPER',action=wezterm.action.SendKey{key='x', mods='ALT'}},
    {key='c',mods='SUPER',action=wezterm.action.SendKey{key='c', mods='ALT'}},
    {key='v',mods='SUPER',action=wezterm.action.SendKey{key='v', mods='ALT'}},
    {key='w',mods='SUPER',action=wezterm.action.SendKey{key='w', mods='ALT'}},
    {key='y',mods='SUPER',action=wezterm.action.SendKey{key='y', mods='ALT'}},
    {key=',',mods='SUPER',action=wezterm.action.SendKey{key=',', mods='ALT'}},
    {key='.',mods='SUPER',action=wezterm.action.SendKey{key='.', mods='ALT'}},
    {key=';',mods='SUPER',action=wezterm.action.SendKey{key=';', mods='ALT'}},
    {key='/',mods='SUPER',action=wezterm.action.SendKey{key='/', mods='ALT'}},
    {key='<',mods='SUPER|SHIFT',action=wezterm.action.SendKey{key='<', mods='ALT'}},
    {key='>',mods='SUPER|SHIFT',action=wezterm.action.SendKey{key='>', mods='ALT'}},
    {key='?',mods='SUPER|SHIFT',action=wezterm.action.SendKey{key='?', mods='ALT'}},
    {key='Insert',mods = 'SHIFT',action=wezterm.action({PasteFrom='Clipboard'})},
    {key='o',mods='ALT',action=wezterm.action.SpawnCommandInNewTab{cwd='~'},},
    {key='w',mods='ALT',action=wezterm.action.CloseCurrentTab{confirm=true},},
    {key='W',mods='CTRL',action=wezterm.action.Nop},
    {key='p',mods='ALT',action=wezterm.action{EmitEvent='trigger-vim-with-scrollback'}},
  },
}

