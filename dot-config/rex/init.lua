-- The defaults put pane focus and pane move on Option. Use Ctrl instead.
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  rex.bind("cmd+ctrl+" .. dir, "pane.focus", { direction = dir })
  rex.bind("cmd+ctrl+shift+" .. dir, "pane.move", { direction = dir })
end

-- Restore sessions from the last run (rexurrect, installed with mise).
rex.exec{ os.getenv("HOME") .. "/.local/share/mise/shims/rexurrect", "auto-restore" }
