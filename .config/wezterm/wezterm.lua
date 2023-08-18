local wezterm = require 'wezterm';

-- cf. https://zenn.dev/yutakatay/articles/wezterm-intro
wezterm.on('trigger-vim-with-scrollback', function(window, pane)
  local scrollback = pane:get_logical_lines_as_text(10000)
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


function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

function omit_path(s)
  return s:gsub('^[^:]*://[^/]*', ''):gsub('^' .. wezterm.home_dir, '~'):gsub('([^/])[^/]*/', '%1/')
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = basename(tab_info.active_pane.foreground_process_name)
  if title == 'fish' or title == 'bash' then
    title = omit_path(tab_info.active_pane.current_working_dir)
  end
  return title == '' and tab_info_.tab_index + 1 or tab_info.tab_index + 1 .. ':' .. title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#100020'
    local background = '#201030'
    local foreground = '#80f080'

    if tab.is_active then
      background = '#80f080'
      foreground = '#201030'
    elseif hover then
      background = '#80f080'
      foreground = '#201030'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = ' ' .. title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = wezterm.nerdfonts.pl_left_hard_divider },
    }
  end
)


return {
  font = wezterm.font('HackGenConsoleNF'),
  font_size = 20.0,
  command_palette_font_size = 18.0,
  use_ime = false,
  color_scheme = 'Dracula',
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = false,
  enable_csi_u_key_encoding = true,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0, },
  use_fancy_tab_bar = false,

  -- key mappings
  keys = {
    {key='q',mods='CTRL',action=wezterm.action{SendString="\x11"}}, -- for macOS
    {key='x',mods='SUPER',action=wezterm.action.SendKey{key='x',mods='ALT'}},
    {key='c',mods='SUPER',action=wezterm.action.SendKey{key='c',mods='ALT'}},
    {key='v',mods='SUPER',action=wezterm.action.SendKey{key='v',mods='ALT'}},
    {key='w',mods='SUPER',action=wezterm.action.SendKey{key='w',mods='ALT'}},
    {key='y',mods='SUPER',action=wezterm.action.SendKey{key='y',mods='ALT'}},
    {key=',',mods='SUPER',action=wezterm.action.SendKey{key=',',mods='ALT'}},
    {key='.',mods='SUPER',action=wezterm.action.SendKey{key='.',mods='ALT'}},
    {key=';',mods='SUPER',action=wezterm.action.SendKey{key=';',mods='ALT'}},
    {key='/',mods='SUPER',action=wezterm.action.SendKey{key='/',mods='ALT'}},
    {key='<',mods='SUPER|SHIFT',action=wezterm.action.SendKey{key='<',mods='ALT'}},
    {key='>',mods='SUPER|SHIFT',action=wezterm.action.SendKey{key='>',mods='ALT'}},
    {key='?',mods='SUPER|SHIFT',action=wezterm.action.SendKey{key='?',mods='ALT'}},
    {key='Insert',mods='SHIFT',action=wezterm.action({PasteFrom='Clipboard'})},
    {key='o',mods='ALT',action=wezterm.action.SpawnCommandInNewTab{cwd='~'}},
    {key='w',mods='ALT',action=wezterm.action.CloseCurrentTab{confirm=true}},
    {key=',',mods='ALT',action=wezterm.action.MoveTabRelative(-1)},
    {key='.',mods='ALT',action=wezterm.action.MoveTabRelative(1)},
    {key='W',mods='CTRL',action=wezterm.action.Nop},
    {key='p',mods='ALT',action=wezterm.action{EmitEvent='trigger-vim-with-scrollback'}},
    {key='Enter',mods='ALT',action=wezterm.action.ActivateCopyMode},
    {key='?',mods='ALT|SHIFT',action=wezterm.action.ActivateCommandPalette},
  },
}

