-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Easier widgetting
require("vicious")
-- Notification library
require("naughty")
require("keydoc")

require("awful.remote")
require("screenful")

require("eminent") -- Dynamic Tag list
require("sysctrl") -- Shutdown, Reboot, Hibernate
require("volume_func")
require("weather_func")
require("pomodoro_func")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
---}}}

screens = {
    ['default'] = {
        ['connected'] = function (xrandrOutput)
            return '--output ' .. xrandrOutput .. ' --auto --same-as LVDS1'
        end,
        ['disconnected'] = function (xrandrOutput)
            return '--output ' .. xrandrOutput .. ' --off --output LVDS1 --auto'
        end
    },
    ['99999999999'] = {
        ['connected'] = function (xrandrOutput)
            return '--output ' .. xrandrOutput .. ' --auto --above LVDS1'
        end,
    }
};

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.right,
    --awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    --                       1      2      3      4      5      6      7      8      9
    tags[s] = awful.tag({ "  ✎ ","  ☯ ","  😄 ","  ✉ ","  ➄ ","  ➅ ","  ➆ ","  ✇ ","  ♬ "}, s, awful.layout.suit.floating)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "Manual", terminal .. " -e man awesome" },
   { "Keydoc", keydoc.display },
   { "Edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "Restart", awesome.restart },
   { "Quit", awesome.quit }
}

mybumblebeemenu = {
   { "Run", terminal .. " -e \"sudo systemctl start bumblebeed.service\"" },
   { "Permanent", terminal .. " -e \"sudo systemctl start bumblebeed.service\"" },
   { "Non-permanent", terminal .. " -e \"sudo systemctl start bumblebeed.service\"" },
}

mysysmenu = {
   { "Lock", lock },
   { "Reboot", reboot},
   { "Hibernate", hibernate },
   { "Shutdown", shutdown }
}

mymainmenu = awful.menu({ items = { { "System", mysysmenu },
                                    { "Rewall", rewall },
                                    { "Bumblebee", mybumblebeemenu, },
                                    { "Open terminal", terminal },
                                    { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })
mytextclock:buttons(awful.util.table.join(
    -- awful.button({ }, 1, function () awful.util.spawn("orage -t") end)
))

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(
      function(c)
        --return awful.widget.tasklist.label.currenttags(c, s)
        return awful.widget.tasklist.label.alltags(c, s)
      end,
      mytasklist.buttons
      )

    -- Create a Weather Box
    if not myweather then
      myweather = widget({type = "textbox"})
      myweather.text = "…"
      myweather:buttons(awful.util.table.join(
          awful.button({ }, 1, function () weather("browse", myweather) end),
          awful.button({ }, 2, function () weather("update", myweather) end),
          awful.button({ }, 3, function () weather("toggle", myweather) end)
      ))
      weathertimer = timer({ timeout = 30 })
      weathertimer:add_signal("timeout", function() weather("update", myweather) end)
      weathertimer:start()
    end

    -- Create Countdown
    if not mytime then
      mytime = widget({type = "textbox"})
      mytime.text = "…"
      mytime:buttons(awful.util.table.join(
        --awful.button({ }, 1, function() count_time("reset", mytime) end),
        awful.button({ }, 1, function() count_time("click", mytime) end),
        awful.button({ }, 4, function() count_time("up5", mytime) end),
        awful.button({ }, 5, function() count_time("down5", mytime) end),
        awful.button({ "Shift" }, 4, function() count_time("up", mytime) end),
        awful.button({ "Shift" }, 5, function() count_time("down", mytime) end),
        awful.button({ "Control" }, 4, function() count_time("set10", mytime) end),
        awful.button({ "Control" }, 5, function() count_time("set50", mytime) end)
      ))
      count_time("reset", mytime)
      if not countdowntimer then
        countdowntimer = timer({ timeout = 60 })
        countdowntimer:add_signal("timeout", function() count_time("up", mytime) end)
        countdowntimer:start()
      end
    end

    -- Create a Volume Button
    if not myvolume then
      myvolume = widget({type = "textbox"})
      myvolume:buttons(awful.util.table.join(
         awful.button({ }, 1, function () volume("settings", myvolume) end),
         awful.button({ }, 4, function () volume("up", myvolume) end),
         awful.button({ }, 5, function () volume("down", myvolume) end)
      ))
      volume("update", myvolume)
    end

    -- Separator
    myseparator = widget({type = "textbox"})
    myseparator.text = "     "

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            --mylauncher,
            mytaglist[s],
            s == 1 and mysystray or nil,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        myvolume,
        myseparator,
        mylayoutbox[s],
        myseparator,
        mytextclock,
        myseparator,
        mytime,
        myseparator,
        myweather,
        myseparator,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- lock screen
    awful.key({ modkey, "Control" }, "l", lock),
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    -- Quodlibet Control
    awful.key({ modkey, "Control"  }, "Home",   function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Pause"); awful.util.spawn("quodlibet --play-pause"); awful.util.spawn("spotify-cli playpause") end),
    awful.key({ modkey, "Control"  }, "Prior", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Prev"); awful.util.spawn("quodlibet --previous"); awful.util.spawn("spotify-cli previous") end),
    awful.key({ modkey, "Control"  }, "Next", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Next"); awful.util.spawn("quodlibet --next"); awful.util.spawn("spotify-cli next") end),
    -- XFCE bindings
    awful.key({ }, "Print", function() awful.util.spawn("xfce4-screenshooter") end),
    -- Volume keys
    awful.key({ }, "XF86AudioRaiseVolume", function () volume("up", myvolume) end),
    awful.key({ }, "XF86AudioLowerVolume", function () volume("down", myvolume) end),
    -- Default Key bindings
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),
    awful.key({ modkey,           }, "d", function () rewall() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Put Quodlibet at tag 9
    { rule = { class = "Quod" },
      properties = { tag = tags[1][9] },
    },
    { rule = { class = "Clementine" },
      properties = { tag = tags[1][9] },
    },
    { rule = { class = "Spotify" },
      properties = { tag = tags[1][9] },
    },
    -- Set Pidgin (it will be on tag 3)
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][3] },
      callback = function(c) 
        awful.client.setslave(c); 
        awful.layout.set(awful.layout.suit.tile.left, tags[1][3]);
        awful.tag.setmwfact (0.2, tags[1][3])
      end },
    -- Put Browsers to tag 2
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][2] },
    },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] },
    },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][4] },
    },
    { rule = { class = "VLC" },
      properties = { tag = tags[1][8] },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    --awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

require("autostart")
