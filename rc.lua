-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
hostname = io.open('/etc/hostname'):read()

-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
open_in_term = terminal .. " -e "
open_in_multiplexer = open_in_term .. "screen "
editor = "gvim"
editor_cmd = open_in_term .. editor
file_manager = "thunar"

mail_client = "thunderbird"
irc_client = open_in_multiplexer .. "-S weechat weechat" 

browser = "firefox"
torrent_client = "qbittorrent"

music_player = open_in_multiplexer .. "-S cmus cmus"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
if hostname == "lysa" then
	 layouts = {
		awful.layout.suit.max,
		awful.layout.suit.spiral.dwindle,
		awful.layout.suit.tile,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.floating,
		awful.layout.suit.magnifier,
	 --   awful.layout.suit.tile.left,
	--    awful.layout.suit.tile.top,
	--    awful.layout.suit.fair,
	--    awful.layout.suit.spiral,
	}

else
	layouts = {
		awful.layout.suit.spiral.dwindle,
		awful.layout.suit.tile,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.floating,
		awful.layout.suit.magnifier,
		awful.layout.suit.max,
	 --   awful.layout.suit.tile.left,
	--    awful.layout.suit.tile.top,
	--    awful.layout.suit.fair,
	--    awful.layout.suit.spiral,
	}

end

	 --layouts = {
		--awful.layout.suit.max,
		--awful.layout.suit.spiral.dwindle,
		--awful.layout.suit.tile,
		--awful.layout.suit.tile.bottom,
		--awful.layout.suit.fair.horizontal,
		--awful.layout.suit.max.fullscreen,
		--awful.layout.suit.floating,
		--awful.layout.suit.magnifier,
	 --   awful.layout.suit.tile.left,
	--    awful.layout.suit.tile.top,
	--    awful.layout.suit.fair,
	--    awful.layout.suit.spiral,
	--}


-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
mymainmenu = awful.menu({ items = { { "manual", terminal .. " -e man awesome" },
                                    { "edit config", editor_cmd .. " " .. awesome.conffile },
                                    { "open terminal", terminal },
                                    { "restart", awesome.restart },
                                    { "quit", awesome.quit }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
os.setlocale("fr_FR.UTF-8")
mytextclock = awful.widget.textclock(" %a %d %b  %H:%M:%S ", 1)

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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
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
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
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
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey, "Control" }, "t",   awful.tag.viewprev       ),
    awful.key({ modkey, "Control" }, "s",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "s",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "t",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "s", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "t", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey,           }, "a", function () awful.util.spawn(terminal .. " -e man awesome") end),
	awful.key({ modkey, "Control" }, "h", awesome.restart),
	awful.key({ modkey, "Control"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "r",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "c",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "c",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "r",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "c",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "r",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "h",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "x",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

	-- Sound keys {{{
	if hostname == "burp" then -- {{{
		local sound = {}
		sound.card = ",0"
		sound.control = " Master"
		sound.step = " 10%"
		sound.command = "amixer " .. " set" .. sound.control .. sound.card
		sound.toggle = sound.command .. " toggle"
		sound.down = sound.command .. sound.step .. "-"
		sound.up = sound.command .. sound.step .. "+"


		sound_keys = awful.util.table.join(
			awful.key({} ,"XF86AudioMute", function () awful.util.spawn(sound.toggle) end),
			awful.key({} ,"XF86AudioLowerVolume", function () awful.util.spawn(sound.down) end),
			awful.key({} ,"XF86AudioRaiseVolume", function () awful.util.spawn_with_shell(sound.up) end)
		)

		globalkeys = awful.util.table.join(
			globalkeys,
			sound_keys
		)

		local music_player_controls = {
			play = "cmus-remote -u",
			stop = "cmus-remote -s",
			previous_track = "cmus-remote -r",
			next_track = "cmus-remote -n"
		}

		music_player_controls_keys = awful.util.table.join(
			awful.key({} ,"XF86AudioPlay", function () awful.util.spawn(music_player_controls.play) end),
			awful.key({} ,"XF86AudioStop", function () awful.util.spawn(music_player_controls.stop) end),
			awful.key({} ,"XF86AudioPrev", function () awful.util.spawn_with_shell(music_player_controls.previous_track) end),
			awful.key({} ,"XF86AudioNext", function () awful.util.spawn_with_shell(music_player_controls.next_track) end)
		)

		globalkeys = awful.util.table.join(
			globalkeys,
			music_player_controls_keys
		)
	-- }}}
	--
	elseif hostname == "lysa" then -- {{{
		local function touchpad_on()
			io.popen("synclient TouchpadOff=0")
		end

		local function touchpad_off()
			io.popen("synclient TouchpadOff=1")
			mouse.coords({x=0, y=0})
		end

		local function touchpad_toggle()
			local touchpad = io.popen("synclient -l | grep 'TouchpadOff'")
			local touchpad_state = string.match(touchpad:read("*l"), '(%d)')

			if touchpad_state == "0" then
				touchpad_off()
			else
				touchpad_on()
			end
			
		end
					
		sound_keys = awful.util.table.join(
			awful.key({} ,"XF86AudioMute", function () touchpad_toggle() end),
			awful.key({} ,"XF86AudioLowerVolume", function () io.popen("xbacklight -dec 10") end),
			awful.key({} ,"XF86AudioRaiseVolume", function () io.popen("xbacklight -inc 10") end)
		)

		globalkeys = awful.util.table.join(
			globalkeys,
			sound_keys
		)

	end
	-- }}}

	-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
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

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Applications launchers keybinding {{{
appLauncherKey = awful.util.table.join( 
	-- Administration
	awful.key({ modkey,"Mod1"}, "f", function () awful.util.spawn(file_manager) end),
	awful.key({ modkey,"Mod1"}, "e", function () awful.util.spawn(editor) end),

	awful.key({ modkey,"Mod1"}, "t", function () awful.util.spawn("truecrypt") end),

	-- Internet and web
	awful.key({ modkey,"Mod1"}, "b", function () awful.util.spawn(browser .. " -p default") end),
	awful.key({ modkey,"Mod1"}, "p", function () awful.util.spawn(browser .. " -p clean") end),
	awful.key({ modkey,"Mod1"}, "o", function () awful.util.spawn(browser .. " -P") end),

	awful.key({ modkey,"Mod1"}, "m", function () awful.util.spawn(mail_client) end),
	awful.key({ modkey,"Mod1"}, "i", function () awful.util.spawn(irc_client) end),

	awful.key({ modkey,"Mod1"}, "h", function () awful.util.spawn("filezilla") end),

	-- Multimedia
	awful.key({ modkey,"Mod1"}, "s", function () awful.util.spawn(music_player) end),
	awful.key({ modkey,"Mod1"}, "c", function () awful.util.spawn("calibre") end),

	-- Divers
	awful.key({ modkey,"Mod1"}, "z", function () awful.util.spawn("zim") end)
	
)

globalkeys = awful.util.table.join(
	globalkeys,
	appLauncherKey
)

root.keys(globalkeys)
-- }}}

-- Applications launched at startup {{{
if hostname == "burp" then
	--awful.util.spawn(torrent_client)
	awful.util.spawn(irc_client)

elseif hostname == "lysa" then
	awful.util.spawn(terminal)

end
-- }}}

-- vim:foldmethod=marker
