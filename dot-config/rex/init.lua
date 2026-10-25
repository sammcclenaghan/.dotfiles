-- Rex configuration. Reload with `rex config reload`, check with `rex config check`.

local terminal = "com.superlogical.terminal"
local zed = "/opt/homebrew/bin/zed"

-- Turn a file:// URL from OSC 7 into a plain path.
local function url_to_path(url)
  local path = url:gsub("^file://[^/]*", "")
  return (path:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end))
end

-- The directory a pane is in: what the shell reported, or else the
-- working directory of the program in the foreground.
local function pane_dir(block_id)
  local r = rex.block.call(terminal, "pwd", { block_id = block_id })
  if r and r.pwd and r.pwd ~= "" then
    return url_to_path(r.pwd)
  end
  local p = rex.block.call(terminal, "process", { block_id = block_id })
  if p and p.foreground and p.foreground.cwd then
    return p.foreground.cwd
  end
  for _, a in ipairs(p and p.ancestors or {}) do
    if a.cwd then return a.cwd end
  end
  return nil
end

-- The focused pane of the session's active tab, for when an action is
-- run from the CLI and has no pane of its own.
local function focused_block()
  local view = rex.session.view{}
  for _, w in ipairs(view and view.windows or {}) do
    if w.window_id == view.active_window_id then return w.focused_block_id end
  end
  return nil
end

rex.action{
  name        = "open_in_zed",
  title       = "Open Directory in Zed",
  description = "Open the focused pane's directory in Zed",
  keywords    = "zed editor project",
  args        = { block_id = "string?" },
  run = function(ctx, args)
    local block_id = args.block_id or ctx.block_id or focused_block()
    if not block_id then error("no focused pane", 0) end
    local dir = pane_dir(block_id)
    if not dir then error("couldn't tell which directory this pane is in", 0) end
    local r, err = rex.exec({ zed, dir }, { timeout = 10 })
    if r == nil then error(err, 0) end
    if not r.ok then error(r.stderr, 0) end
    return { opened = dir }
  end,
}

rex.bind("cmd+shift+e", "open_in_zed")

-- The repository root above dir (a .git or .jj entry), or dir itself.
local function project_root(dir)
  local home = os.getenv("HOME")
  local d = dir
  while d and d ~= "" and d ~= "/" and d ~= home do
    for _, marker in ipairs({ "/.jj", "/.git" }) do
      local f = io.open(d .. marker, "r")
      if f then f:close() return d end
    end
    d = d:match("^(.*)/[^/]+$")
  end
  return dir
end

-- One session per project, named after the repository. Switches to the
-- project's session if it's already open, otherwise creates it with a shell
-- in the repository root.
rex.action{
  name        = "project_session",
  title       = "Open Project Session",
  description = "Switch to the focused pane's project session, creating it if needed",
  keywords    = "project workspace repo",
  args        = { dir = "string?" },
  run = function(ctx, args)
    local dir = args.dir
    if not dir then
      local block_id = ctx.block_id or focused_block()
      dir = block_id and pane_dir(block_id)
    end
    if not dir then error("couldn't tell which directory to use", 0) end
    local root = project_root(dir)
    local name = root:match("([^/]+)/?$")

    local session_id, created
    local list = rex.call("session.list") or {}
    for _, s in ipairs(list.sessions or {}) do
      if s.label == name then session_id = s.session_id break end
    end
    if not session_id then
      local s, err = rex.call("session.create", {
        label = name,
        initial_windows = {
          { layout = rex.layout.block{
              flavor  = "com.superlogical.terminal.shell",
              options = { cwd = root },
          } },
        },
      })
      if s == nil then error(err, 0) end
      session_id, created = s.session_id, true
    end

    -- Show it in the app. From the CLI there is no client to ask, so the
    -- session is only created. The app drops a select for a session made in
    -- the same action unless the action waits a moment, hence the sleep.
    if ctx.client_id then
      rex.client.queue("session.select", { session_id = session_id })
      if created then rex.exec{ "sleep", "0" } end
    end
    return { session_id = session_id, label = name, created = created or false }
  end,
}

rex.bind("cmd+shift+o", "project_session")

-- Pane movement carried over from tmux: ctrl+a, then h/j/k/l.
-- Press ctrl+a twice to send ctrl+a to the terminal.
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+a>" .. key, "pane.focus", { direction = direction })
end
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- rexurrect: restore saved sessions when the server starts.
do
  local home = os.getenv("HOME")
  local r = rex.exec({ home .. "/.cargo/bin/rexurrect", "auto-restore" },
    { env = { REXURRECT_STATE_DIR = home .. "/.local/state/rexurrect" } })
  if r then io.stderr:write(r.stderr) end
end
