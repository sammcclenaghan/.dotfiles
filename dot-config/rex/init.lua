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

local nvim = "/opt/homebrew/bin/nvim"

local function viewer_block()
  for _, w in ipairs((rex.session.view{} or {}).windows or {}) do
    for _, layer in ipairs(w.layers or {}) do
      for _, b in ipairs(layer.blocks or {}) do
        if b.label == "viewer" then return b.block_id end
      end
    end
  end
end

rex.action{
  name        = "show_code",
  title       = "Show Code in Neovim",
  description = "Open a file at a line in this session's read-only Neovim viewer pane",
  args        = { path = "string", line = "integer?", block_id = "string?" },
  run = function(ctx, args)
    local from = args.block_id or ctx.block_id or focused_block()
    local path, line = args.path, args.line or 1
    if path:sub(1, 1) ~= "/" then
      local dir = from and pane_dir(from)
      if not dir then error("can't resolve a relative path without a pane", 0) end
      path = dir .. "/" .. path
    end

    local viewer = viewer_block()
    if viewer then
      local escaped = path:gsub('[ \\%%#|"]', "\\%0")
      rex.block.call(terminal, "write", {
        block_id = viewer,
        data = string.format("\27\27:view +%d %s\rzz", line, escaped),
      })
      return { block_id = viewer }
    end

    local split, err = rex.session.new_split{
      anchor_id = from,
      direction = "horizontal",
      side      = "after",
      ratio     = 0.55,
      layout    = rex.layout.block{
        flavor  = terminal .. ".shell",
        label   = "viewer",
        options = { command = { nvim, "-R", "+" .. line, "+normal! zz", path } },
      },
    }
    if split == nil then error(err, 0) end
    return { block_id = split.block_ids[1] }
  end,
}

local function collect_blocks(t, out)
  if t.block_id and t.rect then out[#out + 1] = t end
  for _, v in pairs(t) do
    if type(v) == "table" then collect_blocks(v, out) end
  end
  return out
end

local function has_neighbor(block_id, direction)
  local e = 1e-6
  for _, w in ipairs((rex.session.view{} or {}).windows or {}) do
    local blocks = collect_blocks(w.layers or {}, {})
    for _, me in ipairs(blocks) do
      if me.block_id == block_id then
        local x, y, wd, ht = me.rect[1], me.rect[2], me.rect[3], me.rect[4]
        for _, b in ipairs(blocks) do
          local r = b.rect
          local beside = r[2] < y + ht - e and r[2] + r[4] > y + e
          local stacked = r[1] < x + wd - e and r[1] + r[3] > x + e
          if (direction == "left" and beside and r[1] + r[3] <= x + e)
            or (direction == "right" and beside and r[1] >= x + wd - e)
            or (direction == "up" and stacked and r[2] + r[4] <= y + e)
            or (direction == "down" and stacked and r[2] >= y + ht - e) then
            return true
          end
        end
        return false
      end
    end
  end
  return false
end

local editors = { nvim = true, vim = true }

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, function(ctx)
    if not ctx.block_id then return false end
    local p = rex.block.call(terminal, "process", { block_id = ctx.block_id })
    if p and p.foreground and editors[p.foreground.name] then return false end
    if not has_neighbor(ctx.block_id, direction) then return false end
    rex.client.queue("pane.focus", { direction = direction })
    return true
  end)
  rex.bind("ctrl+shift+" .. key, "pane.resize", { direction = direction })
end

rex.bind("ctrl+shift+=", "pane.balance")
rex.bind("cmd+shift+enter", "pane.zoom")
rex.bind("cmd+up", "client.prompt.previous")
rex.bind("cmd+down", "client.prompt.next")

-- rexurrect (installed by mise): restore saved sessions when the server starts.
do
  local home = os.getenv("HOME")
  local r = rex.exec({ home .. "/.local/share/mise/shims/rexurrect", "auto-restore" },
    { env = { REXURRECT_STATE_DIR = home .. "/.local/state/rexurrect" } })
  if r then io.stderr:write(r.stderr) end
end
