local wezterm = require 'wezterm';

return {
  font = wezterm.font("HackGenConsoleNF"),
  use_ime = false,
  font_size = 20.0,
  color_scheme = "Darcura",
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = false,
  enable_csi_u_key_encoding = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  keys = {
     {key="q",mods="CTRL",action=wezterm.action{SendString="\x11"}}, -- for macOS
     {key="x",mods="SUPER",action=wezterm.action.SendKey{key="x", mods="ALT"}},
     {key="c",mods="SUPER",action=wezterm.action.SendKey{key="c", mods="ALT"}},
     {key="v",mods="SUPER",action=wezterm.action.SendKey{key="v", mods="ALT"}},
     {key="w",mods="SUPER",action=wezterm.action.SendKey{key="w", mods="ALT"}},
     {key="y",mods="SUPER",action=wezterm.action.SendKey{key="y", mods="ALT"}},
     {key=",",mods="SUPER",action=wezterm.action.SendKey{key=",", mods="ALT"}},
     {key=".",mods="SUPER",action=wezterm.action.SendKey{key=".", mods="ALT"}},
     {key=";",mods="SUPER",action=wezterm.action.SendKey{key=";", mods="ALT"}},
     {key="/",mods="SUPER",action=wezterm.action.SendKey{key="/", mods="ALT"}},
     {key="<",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key="<", mods="ALT"}},
     {key=">",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key=">", mods="ALT"}},
     {key="?",mods="SUPER|SHIFT",action=wezterm.action.SendKey{key="?", mods="ALT"}},
     {key="Insert",mods = "SHIFT",action=wezterm.action({PasteFrom="Clipboard"})},
     {key='o',mods='CMD',action=wezterm.action.SpawnCommandInNewTab{cwd='~'},},
     {key='w',mods='CMD',action=wezterm.action.CloseCurrentTab{confirm=true},},
     {key='W',mods='CTRL',action=wezterm.action.Nop},
  },
}
