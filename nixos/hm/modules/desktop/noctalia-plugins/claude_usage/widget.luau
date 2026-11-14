-- Port of the Claude usage block in linux/sway_bar.sh.
--
-- `claude -p /usage` reports rate-limit status without spending model tokens.
-- runAsync runs it off the UI thread, so the bar never blocks; `inflight`
-- plays the role of the old flock, and the last good text simply stays on the
-- widget instead of living in a cache file.

local REFRESH_MS = 120000
local TIMEOUT_MS = 60000 -- default is 5 s, too short for `claude -p`

local inflight = false
local started = false

local function refresh()
  if inflight then
    return
  end
  inflight = true
  local ok = noctalia.runAsync({ "claude", "-p", "/usage" }, function(r)
    inflight = false
    if r.timedOut or r.exitCode ~= 0 then
      noctalia.log("claude_usage: claude -p /usage failed: " .. tostring(r.stderr))
      return
    end
    local out = r.stdout or ""
    local s = out:match("Current session: (%d+)%% used")
    local w = out:match("Current week[^:\n]*: (%d+)%% used")
    local reset = out:match("Current session:[^\n]-resets [^,]+, (%d%d?:%d%d[ap]m)")
    if not s then
      return
    end
    barWidget.setText(s .. "% (" .. (reset or "?") .. ") - " .. (w or "?") .. "%")
    barWidget.setTooltip({
      { "Session", s .. "%" },
      { "Resets", reset or "?" },
      { "Week", (w or "?") .. "%" },
    })
  end, TIMEOUT_MS)
  if not ok then
    inflight = false
  end
end

function update()
  if not started then
    started = true
    noctalia.setUpdateInterval(REFRESH_MS)
    barWidget.setGlyph("robot")
    barWidget.setText("…")
  end
  refresh()
end

function onClick()
  refresh()
end
