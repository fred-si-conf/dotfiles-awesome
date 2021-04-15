------------------------------------------------------------------------------
-- Library importation
------------------------------------------------------------------------------
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local status_bar = require("status_bar")

local notify = require("utils.notify")
local env = require("utils.env")

local charcodes_popup = require("plugins.charcodes")
local browser = require("browser")
------------------------------------------------------------------------------
-- Error handling
------------------------------------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    notify.critical("Oops, there were errors during startup!", awesome.startup_errors)
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function (err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end

            in_error = true
            notify.critical("Oops, an error happened!", tostring(err))
            in_error = false
        end
    )
end

------------------------------------------------------------------------------
-- Variables definitions
------------------------------------------------------------------------------
modkey = "Mod4"
os.setlocale("fr_FR.UTF-8")

hostname = env:hostname()
config_directory = awful.util.getdir("config")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(config_directory .. "theme/theme.lua")

io.popen('pgrep urxvtd || urxvtd -o -f -q')
terminal = "urxvtc"

editor = "vim"
editor_cmd = terminal .. " -e " .. editor
calculator = "gnome-calculator"

if hostname == "burp" then
    file_manager = "nautilus"
    alternative_file_manager = "nautilus"

elseif hostname == "lysa" then
    file_manager = "xfe"
    alternative_file_manager = "nautilus"

end

lock_image = os.getenv("HOME") .. "/Images/wallpapers/lock.png"
lock_color = "605050"
lock_cmd = "i3lock -i %s -c %s --ignore-empty-password --show-failed-attempts"
i3lock_command = string.format(lock_cmd, lock_image, lock_color)
autolock = "xautolock -time 30 -locker '" .. i3lock_command .. "' -secure"

-- Internet
mail_client = "thunderbird"
irc_client = terminal .. " -e tmux new-session -AD -s irc weechat" 

if hostname == "burp" then
    suspend = i3lock_command .. ' && systemctl suspend -i'
    music_player = terminal .. " -e tmux new-session -AD -s cmus cmus"
    torrent_client = "qbittorrent"
end


-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
------------------------------------------------------------------------------
-- Table of layouts to cover with awful.layout.inc, order matters.
------------------------------------------------------------------------------
awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair.horizontal,
}

------------------------------------------------------------------------------
-- Misc functions
------------------------------------------------------------------------------
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

------------------------------------------------------------------------------
-- status bar
------------------------------------------------------------------------------
awful.screen.connect_for_each_screen(
    function(s)
        set_wallpaper(s)

        -- Each screen has its own tag table.
        awful.tag({ "1", "2", "3", "4", "5", "6", "7"}, s, awful.layout.layouts[1])
        awful.tag.new({"8", "9"}, s, awful.layout.suit.max)
        s.tags[8]:view_only() -- focus le tag 8 au démarrage

        status_bar(s)
    end
)

------------------------------------------------------------------------------
-- Key bindings 
------------------------------------------------------------------------------
awesomeManagingKeys = gears.table.join(
    awful.key({ modkey,"Mod1"}, "w", function () io.popen(i3lock_command) end),
    awful.key({ modkey, }, "o", function () charcodes_popup.show() end,
                                function () charcodes_popup.hidde() end,
                                {description="Affiche un popup ASCII",
                                 group="awesome"}),
    awful.key({ modkey,           }, "j",
        hotkeys_popup.show_help,
        {
            description="show help",
            group="awesome"
        }),

    awful.key({                   }, "Print",
        function () io.popen("scrot -e 'mv $f ~/Images/screenshots'") end,
        {
            description="Take screenshot of active window",
            group="applications"
        }),
    awful.key({         "Shift"   }, "Print",
        function () io.popen("scrot -u -e 'mv $f ~/Images/screenshots'") end,
        {
            description="Take screenshot of active window",
            group="applications"
        }),
    awful.key({         "Control" }, "Print", nil,
        function () awful.spawn("scrot -s -e 'mv $f ~/Images/screenshots'") end,
        {
            description="Take screenshot of interactive selection with the mouse",
            group="applications"
        }),

    awful.key({                   }, "XF86Calculator",
        function() awful.spawn(calculator, {floating = true}) end,
        {
            description="open the calculator application",
            group="applications"
        }),
    
    awful.key({ modkey,           }, "Left",  awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right", awful.tag.viewnext       ),
    awful.key({ modkey, "Control" }, "t", awful.tag.viewprev       ),
    awful.key({ modkey, "Control" }, "s", awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "v", awful.tag.history.restore),

    awful.key({ modkey,           }, "s", function () awful.client.focus.byidx( 1) end),
    awful.key({ modkey,           }, "t", function () awful.client.focus.byidx(-1) end),
    awful.key({ modkey,           }, "Tab", -- Focus last active client
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey, "Control", "shift" }, "t", awful.screen.focus_relative(1)),
    awful.key({ modkey, "Control", "shift" }, "s", awful.screen.focus_relative(-1)),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "s", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "t", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Standard program
    awful.key({ modkey, "Control" }, "h", awesome.restart),
    awful.key({ modkey, "Control" }, "q", awesome.quit),

    awful.key({ modkey,           }, "r",     function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey,           }, "c",     function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift"   }, "c",     function () awful.tag.incnmaster( 1)   end),
    awful.key({ modkey, "Shift"   }, "r",     function () awful.tag.incnmaster(-1)   end),
    awful.key({ modkey, "Control" }, "c",     function () awful.tag.incncol( 1)      end),
    awful.key({ modkey, "Control" }, "r",     function () awful.tag.incncol(-1)      end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)       end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)       end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey,           }, "h",     function () awful.screen.focused().mypromptbox:run() end,
        {description = "run prompt", group = "launcher"}),

    awful.key({ modkey,           }, "x", -- Open lua prompt
            function ()
                awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            {description = "lua execute prompt", group = "awesome"}),

    -- Menubar
    awful.key({ modkey,           }, "p", function() menubar.show() end)
)

applicationLaunchingKeys = gears.table.join( 
    -- Administration
    awful.key({ modkey,           }     , "Return", function () awful.spawn(terminal) end),
    awful.key({ modkey, "Mod1"    }     , "f", function () awful.spawn(file_manager) end),
    awful.key({ modkey, "Mod1", "Shift"}, "f", function () awful.spawn(alternative_file_manager) end),

    awful.key({ modkey, "Mod1"    }     , "t", function () awful.spawn("veracrypt") end),

    -- Internet and web
    awful.key({ modkey, "Mod1"    }     , "v", function () awful.spawn(browser:get_command('default')) end),
    awful.key({ modkey, "Mod1", "Shift"}, "v", function () awful.spawn(browser:get_command('afpa')) end),

    awful.key({ modkey, "Mod1",        }, "j", function () awful.spawn(browser:get_command('dev')) end),

    awful.key({ modkey, "Mod1"    }     , "d", function () awful.spawn(browser:get_command('clean')) end),
    awful.key({ modkey, "Mod1", "Shift"}, "d", function () awful.spawn(browser:get_command('vol')) end),

    awful.key({ modkey, "Mod1"    }     , "m", function () awful.spawn(mail_client) end),
    awful.key({ modkey, "Mod1"    }     , "i", function () awful.spawn(irc_client, {tag = "1"}) end),

    awful.key({ modkey, "Mod1"    }     , "h", function () awful.spawn("filezilla") end),

    -- Multimedia
    awful.key({ modkey, "Mod1"    }     , "s", function () awful.spawn(music_player) end),

    awful.key({ modkey, "Mod1", "Shift"}, "s", function () awful.spawn(browser:get_command('music')) end),

    awful.key({ modkey, "Mod1"    }     , "c", function () awful.spawn("calibre") end),

    -- Divers
    awful.key({ modkey, "Mod1"    }     , "z", function () awful.spawn("zim") end),
    awful.key({ modkey, "Mod1"    }     , "l", function () awful.spawn("libreoffice") end),
    awful.key({ modkey,           }     , "y", require("plugins.mpv").ytdl_from_clipboard)
)

-- Host specific keybinding
    if hostname == "burp" then
        hostSpecificKeys = gears.table.join( 
            awful.key({ modkey,"Mod1"}, "w", function () io.popen(suspend) end)
        )

    elseif hostname == "lysa" then
        local function brightness(target)
            if target == 'max' then
                io.popen("xbacklight -set 100")
            elseif target == 'off' then
                io.popen("xbacklight -set 0")
            elseif target == 'up' then
                io.popen("xbacklight -inc 10")
            elseif target == 'down' then
                io.popen("xbacklight -dec 10")
            end
        end

        local touchpad = {}
            function touchpad.get_state()
                local touchpad = io.popen("synclient -l | grep 'TouchpadOff'")
                local touchpad_state = string.match(touchpad:read("*l"), '(%d)')

                return touchpad_state
            end

            function touchpad.switch_off()
                io.popen("synclient TouchpadOff=1")
                mouse.coords({x=0, y=0})
            end

            function touchpad.switch_on()
                io.popen("synclient TouchpadOff=0")
            end

            function touchpad.toggle_state()
                if touchpad.get_state() == "0" then
                    touchpad.switch_off()
                else
                    touchpad.switch_on()
                end
            end
                        
        hostSpecificKeys = gears.table.join( 
            awful.key({} ,"XF86TouchpadToggle", function () touchpad.toggle_state() end),

            awful.key({} ,"XF86MonBrightnessDown", function () brightness('down') end),
            awful.key({} ,"XF86MonBrightnessUp", function () brightness('up') end),

            awful.key({modkey} ,"XF86MonBrightnessDown", function () brightness('off') end),
            awful.key({modkey} ,"XF86MonBrightnessUp", function () brightness('max') end)
        )

        touchpad.switch_off()
    end

-- Multimedia keys
    if hostname == "burp" then
        local sound = {}
            sound.card = ",0"
            sound.control = " Master"
            sound.step = " 10%"
            sound.command = "amixer set" .. sound.control .. sound.card
            sound.toggle = sound.command .. " toggle"
            sound.down = sound.command .. sound.step .. "-"
            sound.up = sound.command .. sound.step .. "+"

        local music_player_controls = {
            play = "cmus-remote -u",
            stop = "cmus-remote -s",
            previous_track = "cmus-remote -r",
            next_track = "cmus-remote -n"
        }

        multimediaKeys = gears.table.join(
            -- Sound control
            awful.key({} ,"XF86AudioMute", function () io.popen(sound.toggle) end),
            awful.key({} ,"XF86AudioLowerVolume", function () io.popen(sound.down) end),
            awful.key({} ,"XF86AudioRaiseVolume", function () io.popen(sound.up) end),

            -- Music player control
            awful.key({} ,"XF86AudioPlay", function () io.popen(music_player_controls.play) end),
            awful.key({} ,"XF86AudioStop", function () io.popen(music_player_controls.stop) end),
            awful.key({} ,"XF86AudioPrev", function () io.popen(music_player_controls.previous_track) end),
            awful.key({} ,"XF86AudioNext", function () io.popen(music_player_controls.next_track) end)
        )

    elseif hostname == "lysa" then
        multimediaKeys = gears.table.join(
            awful.key({} ,"XF86AudioMute", function () end),

            awful.key({} ,"XF86AudioLowerVolume", function () end),
            awful.key({} ,"XF86AudioRaiseVolume", function () end),

            awful.key({modkey} ,"XF86AudioLowerVolume", function () end),
            awful.key({modkey} ,"XF86AudioRaiseVolume", function () end)
        )
    end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end,
              { description = "Toggle fullscreen", group = "client"}),

    awful.key({ modkey, "Shift"   }, "x",      function (c) c:kill() end,
              { description = "Kill client", group = "client"}),

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
              { description = "Toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              { description = "Swap with master client", group = "client"}),

    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),

    awful.key({ modkey,           }, "q",      function (c) c.sticky = not c.sticky          end,
              { description = "Toggle sticky (collant)", group = "client"}),

    awful.key({ modkey,           }, "n", function (c) c.minimized = true end,
              { description = "Minimize client", group = "client"}),

    awful.key({ modkey,           }, "m", function (c) c.maximized = not c.maximized end,
              { description = "Toggle maximized", group = "client"})
)

globalKeys = gears.table.join(
    awesomeManagingKeys,
    applicationLaunchingKeys,
    hostSpecificKeys,
    multimediaKeys,
    status_bar.caps_lock_key
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local tag = require("tag")
for i = 1, 9 do
    globalKeys = gears.table.join(globalKeys,
        awful.key(
            { modkey }, "#" .. i + 9,
            function () tag.view_tag(i) end,
            {description = "view tag #"..i, group = "tag"}
        ),
        awful.key(
            { modkey, "Control" }, "#" .. i + 9,
            function () tag.toggle_tag_display(i) end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),
        awful.key(
            { modkey, "Shift" }, "#" .. i + 9,
            function () tag.move_client_to_tag(i) end,
            {description = "move focused client to tag #"..i,ggroup = "tag"}
        ),
        awful.key(
            { modkey, "Control", "Shift" }, "#" .. i + 9,
            function () tag.toggle_tag_on_focused_client(i) end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end

root.keys(globalKeys)

------------------------------------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
------------------------------------------------------------------------------
awful.rules.rules = gears.table.join(
    require("clients_rules")(clientkeys, clientbuttons),
    browser:get_rules()
)
--------------------------------------------------------------------------------
-- Signals
------------------------------------------------------------------------------
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

------------------------------------------------------------------------------
-- Applications launched at startup
------------------------------------------------------------------------------
for _, command in pairs(browser:get_autolaunch()) do
    awful.spawn.once(command, {})
end

awful.spawn.once(torrent_client, {})
awful.spawn.once("discord", {})
-- awful.spawn(irc_client, { tag = "1" })
awful.spawn.once(mail_client, {})

awful.spawn.once(terminal .. " -e tmux new-session -AD -s admin", {tag = "8"})
awful.spawn.once(music_player, {tag = "9"})

awful.spawn.once(autolock, {})
awful.spawn.once('nextcloud', {})
awful.spawn.once('copyq', {})

-- vim:foldmethod=indent: foldcolumn=4: expandtab
