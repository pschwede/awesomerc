-- time counter {{{
function count_time(message, widget)
  local alertfunc = 'quodlibet --play-pause;'
  local alertfunc2 = 'spotify-cli playpause'
  local clickfunc = 'hamster-time-tracker edit'
  if not widget.text then
    widget.text = "…"
  end

  local current_time = 0 
  if string.find(widget.text, '-?%d+') then
    current_time = tonumber(string.match(widget.text, '-?%d+'))
  end
  local alert_prefix = "%s"

  if message == "up" then
    current_time = current_time + 1
    if current_time == 0 then
      awful.util.spawn(alertfunc)
      awful.util.spawn(alertfunc2)
    end
  elseif message == "down" then
    current_time = current_time - 1
  elseif message == "up5" then
    current_time = current_time + 5
  elseif message == "down5" then
    current_time = current_time - 5
  elseif message == "set50" then
    current_time = -50
  elseif message == "set10" then
    current_time = -10
  elseif message == "click" then
    awful.util.spawn(clickfunc)
    current_time = -50
  else
    current_time = 0
  end
  if current_time > 0 then
    alert_prefix = "<span foreground='red'>%s</span>"
  end
  widget.text = string.format(string.format(alert_prefix,"⌛%i"), current_time)
end
-- }}}
