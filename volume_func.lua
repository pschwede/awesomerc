-- Farhavens volume widget {{{
cardid = 0
channel = "\"Master\""
function volume (mode, widget)
   if mode == "update" then
       local fd = io.popen("amixer -c " .. cardid .. " -- sget " .. channel)
       local status = fd:read("*all")
       fd:close()

       local volume = string.match(status, "(%d?%d?%d)%%")
       if volume then
           --volume = string.format("% 3d", volume)

           status = string.match(status, "%[(o[^%]]*)%]")

           if string.find(status, "on", 1, true) then
               volume = volume .. "%"
           else
               volume = "⦸"
           end
           widget.text = " ♫ " .. volume
       end
   elseif mode == "up" then
       io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 1%+"):read("*all")
       volume("update", widget)
   elseif mode == "down" then
       io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 1%-"):read("*all")
       volume("update", widget)
   else
       awful.util.spawn("pavucontrol")
   end
end
-- }}} End Volume function for Farhaves volume widget
