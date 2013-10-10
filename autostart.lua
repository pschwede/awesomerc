runonce = require("runonce")
run_once = runonce.run

-- {{{ Start up 
run_once("urxvtd")
run_once("wmname LG3D")             -- let WM pretend to be compatible
run_once("xset r rate 160 60")      -- speed up keyboard auto repeat
run_once("xset b off")              -- mute bell
run_once("xfsettingsd")             -- will do correct antialiasing
run_once("thunar --daemon")         -- #! does it by default
run_once("xfce4-power-manager")     -- battery stuff
--run_once("orage")                   -- pretty simple gui calendar
--run_once("zim --plugin trayicon") -- a gtk desktop wiki
run_once("kupfer --no-splash")      -- pretty neat and fast starter tool, configured to be summoned with Alt+F2
--run_once("conky")      		        -- nice sys info viewer on desktop
--run_once("/home/peter/winlogger/winlogger.py -s")   -- my personal work flow profiler
run_once("jupiter")                 -- energy manager
run_once("hamster-time-tracker")
--run_once("update-notifier")
run_once("compton -C -f -D 5")
run_once("nm-applet")               -- network manager

-- regular uses
run_once("thunderbird")
--run_once("pidgin")
run_once("firefox")
--run_once("quodlibet")
run_once("spotify")
-- }}}
