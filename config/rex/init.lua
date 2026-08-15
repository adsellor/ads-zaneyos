-- Programmer Dvorak fixes
--
-- A few of Rex's default shortcuts are bound to physical (QWERTY) key
-- positions, written like cmd+[Digit2], and those win over the shortcuts
-- that follow the layout. On Programmer Dvorak the number row and QWERTY's
-- [ key type = [ ] /, so the position defaults take ⌘= ⌘[ ⌘] ⌘/ away.
-- Reported upstream and accepted:
-- https://discord.com/channels/1546797889009881158/1564378673467887859

-- Font size on the keys where QWERTY has ⌘= and ⌘- (they type ⌘# and ⌘! here)
rex.bind("cmd+[Equal]", "client.font.increase")
rex.bind("cmd+[Minus]", "client.font.decrease")
-- ⌘0 as Programmer Dvorak types it: shift on the 7 key
rex.bind("cmd+shift+[Digit7]", "client.font.reset")

-- ⌘[ ⌘] ⌘/ are typed on the 2 and 0 keys and on QWERTY's [ key. Since
-- preview.22 the defaults follow the layout, so there are no position
-- bindings on [Digit0] or [BracketLeft] left to unbind.
rex.bind("cmd+[", "pane.focus_previous")
rex.bind("cmd+]", "pane.focus_next")
rex.bind("cmd+/", "client.sidebar.toggle")

-- Since preview.22 the ⌘⇧[ ⌘⇧] tab defaults follow the layout, which moves
-- them onto the 2 and 0 keys, and the unbind of ⌘2 above now sticks. Keep
-- tabs on QWERTY positions: ⌘2 wins over ⌘[ on the 2 key, as before.
rex.bind("cmd+[Digit2]", "client.tab.goto", { index = 2 })
rex.bind("shift+cmd+[BracketLeft]", "client.tab.previous")
rex.bind("shift+cmd+[BracketRight]", "client.tab.next")

-- Vim-style nav mode on alt+s, the same leader as config/ghostty/config.
-- It stays on until Escape, alt+s or i, and swallows other keys so they
-- don't type into the terminal.
rex.mode("nav", { exclusive = true })
rex.bind("alt+s", "client.mode.enter", { name = "nav" })
rex.bind("nav/alt+s", "client.mode.exit")
rex.bind("nav/i", "client.mode.exit")

-- Leave the mode first for keys that hand you something to type into
local function leave_nav_and(name, title, action)
  rex.action{
    name = name,
    title = title,
    run = function()
      rex.client.queue("client.mode.exit")
      rex.client.queue(action)
    end,
  }
end
leave_nav_and("nav_new_tab", "New Tab and Leave Nav Mode", "client.tab.new")
leave_nav_and("nav_change_session", "Change Session and Leave Nav Mode", "session.switch")
leave_nav_and("nav_rename_tab", "Rename Tab and Leave Nav Mode", "client.tab.rename")
leave_nav_and("nav_rename_session", "Rename Session and Leave Nav Mode", "session.rename")

-- Tabs: H and L go left and right
rex.bind("nav/h", "client.tab.previous")
rex.bind("nav/l", "client.tab.next")
rex.bind("nav/x", "client.tab.close")
rex.bind("cmd+x", "client.tab.close") -- replaces Cut
rex.bind("nav/c", "nav_new_tab")
rex.bind("nav/r", "nav_rename_tab")

-- Sessions: J and K go down and up the list, S picks one
rex.bind("nav/j", "session.next")
rex.bind("nav/k", "session.previous")
rex.bind("nav/s", "nav_change_session")
rex.bind("nav/shift+r", "nav_rename_session")

-- Vi-style scroll on cmd+s (replaces Save), toggled for the focused pane.
-- It isn't a Rex mode, because modes show a panel of every key bound in
-- them: the scroll keys are functions that pass the key on to the terminal
-- unless scrolling is on, and the tab's label gets a ⇅ in front instead.
-- Other keys still type while scrolling. Rex has no action that scrolls its
-- own scrollback yet, so full-screen programs (Claude Code, nvim, lazygit)
-- get mouse wheel ticks or paging keys, and a plain shell jumps between
-- prompts.
-- https://discord.com/channels/1546797889009881158/1565009888235622462
-- https://discord.com/channels/1546797889009881158/1564056474735616010
local terminal = "com.superlogical.terminal"
local scroll_marker = "⇅ "
local scroll_block = nil
local scroll_saved = {}

local function window_of(block_id)
  local r = block_id and rex.session.describe_block{ block_id = block_id }
  return r and r.block and r.block.window_id
end

local function window_label(window_id)
  local view = rex.session.view{}
  for _, w in ipairs(view and view.windows or {}) do
    if w.window_id == window_id then return w.label end
  end
end

local function scroll_stop(ctx)
  local window_id = window_of(ctx.block_id)
  if window_id and not scroll_saved[window_id] then
    local label = window_label(window_id)
    if label and label:sub(1, #scroll_marker) == scroll_marker then
      scroll_saved[window_id] = ""
    end
  end
  for id, label in pairs(scroll_saved) do
    rex.session.set_window_label{ window_id = id, label = label }
  end
  scroll_saved = {}
  scroll_block = nil
end

local function scroll_start(ctx)
  scroll_stop(ctx)
  scroll_block = ctx.block_id
  local window_id = window_of(ctx.block_id)
  local label = window_id and window_label(window_id)
  if label and label:sub(1, #scroll_marker) ~= scroll_marker then
    -- An unrenamed tab shows the terminal's title, not its "Window <id>" label
    local renamed = label ~= "Window " .. window_id:sub(-8)
    scroll_saved[window_id] = renamed and label or ""
    local shown = label
    if not renamed then
      local t = rex.block.call(terminal, "title", { block_id = ctx.block_id })
      shown = t and t.title ~= "" and t.title or "scroll"
    end
    rex.session.set_window_label{ window_id = window_id, label = scroll_marker .. shown }
  end
end

local function scroll_toggle(ctx)
  if ctx.block_id and ctx.block_id == scroll_block then
    scroll_stop(ctx)
  else
    scroll_start(ctx)
  end
end
rex.action{ name = "scroll_toggle", title = "Toggle Scroll Mode", run = scroll_toggle }

local function mode_on(modes, number)
  for _, m in ipairs(modes or {}) do
    if m.number == number and not m.ansi then return m.set end
  end
  return false
end

-- amount is "line", "half", "page" or "end"
local function scroll_by(ctx, args)
  local up = args.direction == "up"
  local m = ctx.block_id and rex.block.call(terminal, "modes", { block_id = ctx.block_id })
  if not (m and m.screen == "alternate") then
    if args.amount ~= "end" then
      rex.client.queue(up and "client.prompt.previous" or "client.prompt.next")
    end
    return
  end

  local data
  if args.amount == "end" then
    data = up and "\27[1;5H" or "\27[1;5F" -- ctrl+home, ctrl+end
  elseif args.amount == "page" then
    data = up and "\27[5~" or "\27[6~"
  else
    local step
    if mode_on(m.modes, 1000) or mode_on(m.modes, 1002) or mode_on(m.modes, 1003) then
      local size = rex.block.call(terminal, "size", { block_id = ctx.block_id }) or {}
      local col = math.min(math.floor((size.columns or 80) / 2), 223)
      local row = math.min(math.floor((size.rows or 24) / 2), 223)
      local button = up and 64 or 65
      if mode_on(m.modes, 1006) then
        step = string.format("\27[<%d;%d;%dM", button, col, row)
      else
        step = "\27[M" .. string.char(32 + button, 32 + col, 32 + row)
      end
    else
      step = up and "\27[A" or "\27[B"
    end
    data = string.rep(step, args.amount == "half" and 5 or 1)
  end
  rex.block.call(terminal, "write", { block_id = ctx.block_id, data = data })
end
rex.action{
  name = "scroll_by",
  title = "Scroll",
  args = { direction = "string", amount = "string" },
  repeats = true,
  run = scroll_by,
}


local function while_scrolling(fn)
  return function(ctx)
    if not scroll_block or ctx.block_id ~= scroll_block then return false end
    fn(ctx)
    return true
  end
end

rex.bind("cmd+s", "scroll_toggle")
for _, key in ipairs({ "escape", "q" }) do
  rex.bind(key, while_scrolling(scroll_stop))
end
for _, b in ipairs({
  { { "k", "up" }, "up", "line" },
  { { "j", "down" }, "down", "line" },
  { { "u", "ctrl+u" }, "up", "half" },
  { { "d", "ctrl+d" }, "down", "half" },
  -- ctrl+b pages up in zj_key below, since it also opens tmux mode
  { { "b", "h", "left", "pageup" }, "up", "page" },
  { { "f", "ctrl+f", "l", "right", "pagedown" }, "down", "page" },
  { { "g" }, "up", "end" },
  { { "shift+g" }, "down", "end" },
}) do
  local args = { direction = b[2], amount = b[3] }
  for _, key in ipairs(b[1]) do
    rex.bind(key, while_scrolling(function() rex.invoke("scroll_by", args) end))
  end
end
rex.bind("ctrl+c", while_scrolling(function(ctx)
  rex.invoke("scroll_by", { direction = "down", amount = "end" })
  scroll_stop(ctx)
end))

-- Zellij's default keys (zellij 0.45; home/base/zellij.nix sets no
-- keybinds), since zellij doesn't start inside Rex. Each Zellij mode is an
-- exclusive Rex mode. Zellij switches modes where Rex stacks them, so every
-- switch leaves all modes first, and Escape or Enter lands in normal.
-- Ctrl+s is the scroll toggle above, not a mode.
-- Every Zellij key is bound to an action, not a function: rex.client.queue
-- only works in actions.
-- Left out for lack of a Rex action: stacked panes, pane frames, pinning,
-- renaming panes, sync tab, swap layouts, pane groups, detach, the session
-- plugins, Resize Increase/Decrease, MoveFocusOrTab's hop to the next tab,
-- and ctrl+q.
local zj_locked = false

local function zj_switch(ctx, name)
  if scroll_block then scroll_stop(ctx) end
  rex.client.queue("client.mode.exit_all")
  if name then rex.client.queue("client.mode.enter", { name = name }) end
end

-- Locked is a Rex mode only so the mode panel shows it's on. The Zellij keys
-- pass through because zj_key checks zj_locked: binding each one in the mode
-- instead would list them all in the panel.
local function zj_lock(ctx)
  zj_locked = true
  zj_switch(ctx, "locked")
end
local function zj_unlock(ctx)
  zj_locked = false
  zj_switch(ctx, nil)
end
rex.action{ name = "zj_lock", title = "Lock Zellij Keys", run = zj_lock }
rex.action{ name = "zj_unlock", title = "Unlock Zellij Keys", run = zj_unlock }
rex.bind("locked/ctrl+g", "zj_unlock")
rex.bind("locked/escape", "pane.send_key", { key = "escape" })

-- The keys Zellij binds outside its modes
rex.action{
  name = "zj_key",
  title = "Zellij Key",
  args = { key = "string", mode = "string?", action = "string?" },
  run = function(ctx, a)
    rex.log("info", "ZJDEBUG zj_key " .. rex.json.encode({ a = a, ctx = ctx }))
    if a.mode == "locked" then
      if zj_locked then zj_unlock(ctx) else zj_lock(ctx) end
    elseif zj_locked then
      rex.client.queue("pane.send_key", { key = a.key })
    elseif a.key == "ctrl+b" and ctx.block_id and ctx.block_id == scroll_block then
      rex.invoke("scroll_by", { direction = "up", amount = "page" })
    elseif a.mode == "scroll" then
      scroll_toggle(ctx)
    elseif a.mode then
      zj_switch(ctx, a.mode)
    else
      rex.client.queue(a.action)
    end
  end,
}

rex.action{
  name = "zj_do",
  title = "Leave Zellij Mode and Run",
  args = { action = "string", args = "object?" },
  run = function(ctx, a)
    rex.log("info", "ZJDEBUG zj_do " .. rex.json.encode({ a = a, ctx = ctx }))
    rex.client.queue("client.mode.exit_all")
    rex.client.queue(a.action, a.args)
  end,
}

rex.action{
  name = "zj_mode",
  title = "Switch Zellij Mode",
  args = { name = "string" },
  run = function(ctx, a)
    rex.log("info", "ZJDEBUG zj_mode " .. rex.json.encode({ a = a, ctx = ctx }))
    zj_switch(ctx, a.name)
  end,
}

rex.action{
  name = "zj_scroll",
  title = "Leave Zellij Mode and Scroll",
  run = function(ctx)
    rex.client.queue("client.mode.exit_all")
    scroll_start(ctx)
  end,
}

-- pane.close does nothing when init.lua binds it on recent builds:
-- https://discord.com/channels/1546797889009881158/1564039750359195830
rex.action{
  name = "zj_close_pane",
  title = "Close Pane and Leave Zellij Mode",
  run = function(ctx)
    rex.client.queue("client.mode.exit_all")
    local _, err = rex.call("block.close", { session_id = ctx.session_id, block_id = ctx.block_id })
    if err ~= nil then error(err, 0) end
  end,
}

local zj_mode_keys = {
  pane = "ctrl+p",
  tab = "ctrl+t",
  resize = "ctrl+n",
  move = "ctrl+h",
  session = "ctrl+o",
  tmux = "ctrl+b",
}
for name, key in pairs(zj_mode_keys) do
  rex.bind(key, "zj_key", { key = key, mode = name })
end
rex.bind("ctrl+s", "zj_key", { key = "ctrl+s", mode = "scroll" })
rex.bind("ctrl+g", "zj_key", { key = "ctrl+g", mode = "locked" })

-- These take alt+left and alt+right from Rex's word jumps, as zellij did
for _, b in ipairs({
  { { "alt+f" }, "pane.minimize_all_floating" },
  { { "alt+n" }, "pane.split.auto" },
  { { "alt+i" }, "client.tab.move.backward" },
  { { "alt+o" }, "client.tab.move.forward" },
  { { "alt+h", "alt+left" }, "pane.focus.left" },
  { { "alt+l", "alt+right" }, "pane.focus.right" },
  { { "alt+j", "alt+down" }, "pane.focus.down" },
  { { "alt+k", "alt+up" }, "pane.focus.up" },
}) do
  for _, key in ipairs(b[1]) do
    rex.bind(key, "zj_key", { key = key, action = b[2] })
  end
end

local function stay(action, args) return { action, args } end
local function leave(action, args) return { "zj_do", { action = action, args = args } } end

local zj_bindings = {
  pane = {
    { { "p" }, stay("pane.focus_next") },
    { { "n" }, leave("pane.split.auto") },
    { { "d" }, leave("pane.split.down") },
    { { "r" }, leave("pane.split.right") },
    { { "x" }, { "zj_close_pane" } },
    { { "f", "shift+f" }, leave("pane.zoom") },
    { { "w" }, leave("pane.minimize_all_floating") },
    { { "e" }, leave("pane.float") },
  },
  tab = {
    { { "r" }, leave("client.tab.rename") },
    { { "h", "left", "k", "up" }, stay("client.tab.previous") },
    { { "l", "right", "j", "down" }, stay("client.tab.next") },
    { { "n" }, leave("client.tab.new") },
    { { "x" }, leave("client.tab.close") },
    { { "b" }, leave("pane.move_to_new_tab") },
  },
  resize = {},
  move = {},
  session = {
    { { "w" }, leave("session.switch") },
  },
  tmux = {
    { { "[" }, { "zj_scroll" } },
    { { "ctrl+b" }, leave("pane.send_key", { key = "ctrl+b" }) },
    { { "shift+'" }, leave("pane.split.down") },
    -- % is shift on the 1 key in Programmer Dvorak
    { { "shift+[Digit1]" }, leave("pane.split.right") },
    { { "z" }, leave("pane.zoom") },
    { { "c" }, leave("client.tab.new") },
    { { "," }, leave("client.tab.rename") },
    { { "p" }, leave("client.tab.previous") },
    { { "n" }, leave("client.tab.next") },
    { { "o" }, stay("pane.focus_next") },
    { { "x" }, { "zj_close_pane" } },
  },
}

local zj_opposite = { left = "right", right = "left", up = "down", down = "up" }
for dir, keys in pairs({
  left = { "h", "left" },
  down = { "j", "down" },
  up = { "k", "up" },
  right = { "l", "right" },
}) do
  table.insert(zj_bindings.pane, { keys, stay("pane.focus." .. dir) })
  table.insert(zj_bindings.move, { keys, stay("pane.move." .. dir) })
  table.insert(zj_bindings.tmux, { keys, leave("pane.focus." .. dir) })
  table.insert(zj_bindings.resize, { keys, stay("pane.resize", { direction = dir }) })
  -- Zellij's H J K L shrink from that side, so push that edge back
  table.insert(zj_bindings.resize, { { "shift+" .. keys[1] }, stay("pane.resize", { direction = zj_opposite[dir] }) })
end

-- Programmer Dvorak types digits with shift, on these keys
for i, code in ipairs({ "Digit5", "Digit8", "Digit4", "Digit9", "Digit3", "Digit0", "Digit2", "Minus", "Digit6" }) do
  table.insert(zj_bindings.tab, { { "shift+[" .. code .. "]" }, leave("client.tab.goto", { index = i }) })
end

for name, list in pairs(zj_bindings) do
  rex.mode(name, { exclusive = true })
  local bound = {}
  local function bind(key, action, args)
    if bound[key] then return end
    bound[key] = true
    rex.bind(name .. "/" .. key, action, args)
  end
  for _, b in ipairs(list) do
    for _, key in ipairs(b[1]) do bind(key, b[2][1], b[2][2]) end
  end
  for other, key in pairs(zj_mode_keys) do
    if other == name then
      bind(key, "client.mode.exit_all")
    else
      bind(key, "zj_mode", { name = other })
    end
  end
  bind("ctrl+s", "zj_scroll")
  bind("ctrl+g", "zj_lock")
  bind("enter", "client.mode.exit_all")
end
