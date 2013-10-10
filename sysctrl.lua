function rewall()
    awful.util.spawn_with_shell("$HOME/.config/awesome/rewall.sh")
end

function shutdown()
  awful.util.spawn_with_shell("zenity --question --text='Shutdown?' && dbus-send --system --print-reply --dest='org.freedesktop.ConsoleKit' /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop");
end

function hibernate()
    awful.util.spawn_with_shell("zenity --question --text='Hibernate?' && dbus-send --system --print-reply --dest='org.freedesktop.UPower' /org/freedesktop/UPower org.freedesktop.UPower.Hibernate");
end

function lock()
    awful.util.spawn_with_shell('slock');
end

function reboot()
    awful.util.spawn_with_shell("zenity --question --text='Reboot?' && dbus-send --system --print-reply --dest='org.freedesktop.ConsoleKit' /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart");
end
