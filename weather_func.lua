weather_on = true

-- {{{ Weather
function weather(mode, widget)
    --local code = "\"frankfurt-oder-germany\""
    local code = "dresden-germany"
    local tempuri = "/tmp/weather.tmp"

    if mode == "update" and weather_on then
        awful.util.spawn_with_shell("python $HOME/.config/awesome/weather.sh "..code)
        local it = io.lines(tempuri)
        temperature = it()
        symbol = it()
        if temperature and symbol then
            widget.text = symbol..temperature
        end
    elseif mode == "toggle" then
        if weather_on then
            widget.text = "⨂"
            weather_on = false
        else
            widget.text = "?"
            weather_on = true
        end
    elseif weather_on then
        awful.util.spawn("xdg-open http://www.niederschlagsradar.de/h3.aspx")
        awful.util.spawn("xdg-open http://www.wetteronline.de/wetter/dresden")
        awful.util.spawn("xdg-open http://www.wetteronline.de/?pcid=pc_blitze_map&gid=DL")
    end
end
-- }}}
