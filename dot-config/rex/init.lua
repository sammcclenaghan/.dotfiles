local terminal = "com.superlogical.terminal"
local home = os.getenv("HOME")

local function cwd(block_id)
  local p = rex.block.call(terminal, "process", { block_id = block_id })
  return assert(p and p.foreground and p.foreground.cwd, "no working directory")
end

local function repo_root(dir)
  local d = dir
  while d do
    for _, marker in ipairs({ "/.jj", "/.git" }) do
      local f = io.open(d .. marker)
      if f then f:close() return d end
    end
    d = d:match("^(.+)/[^/]+$")
  end
  return dir
end

local function blocks(node, found)
  found = found or {}
  if node.block_id and node.rect then found[node.block_id] = node.rect end
  for _, child in pairs(node) do
    if type(child) == "table" then blocks(child, found) end
  end
  return found
end

local function block_labeled(label)
  for _, window in ipairs(rex.session.view{}.windows) do
    for _, layer in ipairs(window.layers) do
      for _, b in ipairs(layer.blocks) do
        if b.label == label then return b.block_id end
      end
    end
  end
end

local step = {
  left  = function(r) return r[1] - 0.01, r[2] + r[4] / 2 end,
  right = function(r) return r[1] + r[3] + 0.01, r[2] + r[4] / 2 end,
  up    = function(r) return r[1] + r[3] / 2, r[2] - 0.01 end,
  down  = function(r) return r[1] + r[3] / 2, r[2] + r[4] + 0.01 end,
}

local function has_neighbor(block_id, direction)
  for _, window in ipairs(rex.session.view{}.windows) do
    local rects = blocks(window)
    if rects[block_id] then
      local x, y = step[direction](rects[block_id])
      for _, r in pairs(rects) do
        if x > r[1] and x < r[1] + r[3] and y > r[2] and y < r[2] + r[4] then return true end
      end
      return false
    end
  end
end

rex.action{
  name  = "open_in_zed",
  title = "Open Directory in Zed",
  run   = function(ctx)
    assert(rex.exec({ "/opt/homebrew/bin/zed", cwd(ctx.block_id) }))
  end,
}

rex.action{
  name  = "project_session",
  title = "Open Project Session",
  run   = function(ctx)
    local root = repo_root(cwd(ctx.block_id))
    local name = root:match("[^/]+$")
    local id
    for _, s in ipairs(assert(rex.call("session.list")).sessions) do
      if s.label == name then id = s.session_id end
    end
    if not id then
      id = assert(rex.call("session.create", {
        label = name,
        initial_windows = { { layout = rex.layout.block{ flavor = terminal .. ".shell", options = { cwd = root } } } },
      })).session_id
      rex.exec{ "sleep", "0" } -- otherwise the app drops the select for a brand-new session
    end
    rex.client.queue("session.select", { session_id = id })
  end,
}

rex.action{
  name  = "show_code",
  title = "Show Code in Neovim",
  args  = { path = "string", line = "integer?", block_id = "string?" },
  run   = function(ctx, args)
    local from = args.block_id or ctx.block_id
    local path = args.path:sub(1, 1) == "/" and args.path or cwd(from) .. "/" .. args.path
    local line = args.line or 1
    local viewer = block_labeled("viewer")
    if viewer then
      local escaped = path:gsub('[ \\%%#|"]', "\\%0")
      rex.block.call(terminal, "write", { block_id = viewer, data = ("\27\27:view +%d %s\rzz"):format(line, escaped) })
    else
      assert(rex.session.new_split{
        anchor_id = from,
        direction = "horizontal",
        side      = "after",
        layout    = rex.layout.block{
          flavor  = terminal .. ".shell",
          label   = "viewer",
          options = { command = { "/opt/homebrew/bin/nvim", "-R", "+" .. line, "+normal! zz", path } },
        },
      })
    end
  end,
}

rex.action{
  name  = "focus_or_send",
  title = "Focus Pane or Send Key",
  args  = { direction = "string", key = "string" },
  run   = function(ctx, args)
    if has_neighbor(ctx.block_id, args.direction) then
      rex.client.queue("pane.focus", { direction = args.direction })
    else
      rex.client.queue("pane.send_key", { key = args.key })
    end
  end,
}

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, "focus_or_send", { direction = direction, key = "ctrl+" .. key })
  rex.bind("ctrl+shift+" .. key, "pane.resize", { direction = direction })
end
rex.bind("ctrl+shift+=", "pane.balance")
rex.bind("cmd+shift+enter", "pane.zoom")
rex.bind("cmd+up", "client.prompt.previous")
rex.bind("cmd+down", "client.prompt.next")
rex.bind("cmd+shift+e", "open_in_zed")
rex.bind("cmd+shift+o", "project_session")

rex.exec{ home .. "/.local/share/mise/shims/rexurrect", "auto-restore" }
