-- vim:foldmethod=indent: foldcolumn=4

-- Library importation
	-- Standard awesome library
		local gears = require("gears")
		local awful = require("awful")
		require("awful.autofocus")

	-- Widget and layout library
		local wibox = require("wibox")

	-- Theme handling library
		local beautiful = require("beautiful")

	-- Notification library
		local naughty = require("naughty")
		local menubar = require("menubar")
		local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Error handling
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
							 text = tostring(err) })
			in_error = false
		end)
	end

-- Variables definitions
	hostname = io.open('/etc/hostname'):read()
	--config_directory = os.getenv('HOME') .. '/.config/awesome/'
	config_directory = awful.util.getdir("config")

	-- Themes define colours, icons, font and wallpapers.
	beautiful.init(config_directory .. "themes/mytheme/theme.lua")

	io.popen('pgrep urxvtd || urxvtd -o -f -q')
	terminal = "urxvtc"

	editor = "vim"
	editor_cmd = terminal .. " -e " .. editor
	calculator = "calculator"

	file_manager = "xfe"
	alternative_file_manager = "nautilus"
	
	lock_image = os.getenv("HOME") .. "/Images/wallpapers/lock.png"
	lock_color = "605050"
	i3lock_command = "i3lock -i " .. lock_image .. " -c " .. lock_color .. " --ignore-empty-password --show-failed-attempts"
	autolock = "xautolock -time 30 -locker '" .. i3lock_command .. "' -secure"

	-- Internet
	browser = {
		default = {
			command = "firefox -p default",
			tag = "2"
		},

		clean = {
			command =  "firefox -p clean",
			tag = "3"
		},

		adopte =  {
			command =  "firefox -p adopte",
			tag = "4"
		},
		
		vol = {
			command = "firefox -p vol",
			tag = "4"
		},

		music = {
			command = "firefox -p soundcloud",
			tag = "9"
		}
	}


	mail_client = "thunderbird"
	irc_client = terminal .. " -e tmux new-session -s irc weechat" 

	if hostname == "burp" then
		suspend = i3lock_command .. ' && systemctl suspend -i'
		music_player = terminal .. " -e tmux new-session -s cmus cmus"
		torrent_client = "qbittorrent"
	end

	modkey = "Mod4"

	-- Table of layouts to cover with awful.layout.inc, order matters.
	if hostname == "lysa" then
		 awful.layout.layouts = {
			awful.layout.suit.max,
			awful.layout.suit.spiral.dwindle,
			awful.layout.suit.tile,
			awful.layout.suit.tile.bottom,
			awful.layout.suit.fair.horizontal,
			awful.layout.suit.max.fullscreen,
			awful.layout.suit.floating,
			awful.layout.suit.magnifier,
			--awful.layout.suit.tile.left,
			--awful.layout.suit.tile.top,
			--awful.layout.suit.fair,
			--awful.layout.suit.spiral,
		}

	else
		awful.layout.layouts = {
			awful.layout.suit.spiral.dwindle,
			awful.layout.suit.corner.nw,
			awful.layout.suit.tile,
			awful.layout.suit.tile.bottom,
			awful.layout.suit.fair.horizontal,
			--awful.layout.suit.max.fullscreen,
			--awful.layout.suit.floating,
			--awful.layout.suit.magnifier,
			awful.layout.suit.max,
			--awful.layout.suit.tile.left,
			--awful.layout.suit.tile.top,
			--awful.layout.suit.fair,
			--awful.layout.suit.spiral,
			--
			--awful.layout.suit.tile.bottom,
			--awful.layout.suit.corner.ne,
			--awful.layout.suit.corner.sw,
			--awful.layout.suit.corner.se,
		}

	end

-- Misc functions
	local function launch_in_shell(appName)
		awful.spawn(terminal .. " -e " .. appName)
	end

	local function test_propertie() 
		c = client.get()
		local c_type = ''
		for i, j in pairs(c) do
			c_type =  c_type .. i .. ' : ' .. type(j) .. '\n'
		end

		naughty.notify({ 
						timeout = 60,
						title = "awful.client",
						--text = c
						--text = tostring(c)
						text = c_type
		})
		naughty.notify({ 
						timeout = 60,
						title = "awful.client",
						text = type(awful.client.property.get(c[1], 'fx'))
		})
		naughty.notify({ 
						timeout = 60,
						title = "awful.client",
						text = type(c)
		})
	end

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

-- Helper functions
	local function client_menu_toggle_fn()
		local instance = nil

		return function ()
			if instance and instance.wibox.visible then
				instance:hide()
				instance = nil
			else
				instance = awful.menu.clients({ theme = { width = 250 } })
			end
		end
	end

-- Menu
	-- Create a laucher widget and a main menu
	mymainmenu = awful.menu({
		items = {
			{ "hotkeys", function() return false, hotkeys_popup.show_help end},
			{ "manual", terminal .. " -e man awesome" },
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

-- Widgets
	-- Create a textclock widget
		os.setlocale("fr_FR.UTF-8")
		mytextclock = awful.widget.textclock(" %a %d %b  %H:%M:%S ", 1)

	-- Keyboard map indicator and switcher
		mykeyboardlayout = awful.widget.keyboardlayout()

	-- Battery status
		--if hostname == "lysa" then
			--local bashets = require("bashets")

			--batterystatus = wibox.widget.textbox()
			--bashets.register( config_directory .. "battery.sh",
							--{ widget = batterystatus,
							  --separator = '|',
							  --format = "$1 $2",
							  --update_time = 60 
							--})
			--bashets.start()

			--right_layout:add(batterystatus)
		--end

	-- Create a wibox for each screen and add it
		local taglist_buttons = awful.util.table.join(
							awful.button({ }, 1, function(t) t:view_only() end),
							awful.button({ modkey }, 1, function(t)
													  if client.focus then
														  client.focus:move_to_tag(t)
													  end
												  end),
							awful.button({ }, 3, awful.tag.viewtoggle),
							awful.button({ modkey }, 3, function(t)
													  if client.focus then
														  client.focus:toggle_tag(t)
													  end
												  end),
							awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
							awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
		)

		local tasklist_buttons = awful.util.table.join(
							 awful.button({ }, 1, function (c)
													  if c == client.focus then
														  c.minimized = true
													  else
														  -- Without this, the following
														  -- :isvisible() makes no sense
														  c.minimized = false
														  if not c:isvisible() and c.first_tag then
															  c.first_tag:view_only()
														  end
														  -- This will also un-minimize
														  -- the client, if needed
														  client.focus = c
														  c:raise()
													  end
												  end),
							 awful.button({ }, 3, client_menu_toggle_fn()),
							 awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
							 awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
		)

	awful.screen.connect_for_each_screen(
		function(s)
			set_wallpaper(s)

			-- Each screen has its own tag table.
			awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

			-- Create a promptbox for each screen
			s.mypromptbox = awful.widget.prompt()
			-- Create an imagebox widget which will contains an icon indicating which layout we're using.
			-- We need one layoutbox per screen.
			s.mylayoutbox = awful.widget.layoutbox(s)
			s.mylayoutbox:buttons(
				awful.util.table.join(
					awful.button({ }, 1, function () awful.layout.inc( 1) end),
					awful.button({ }, 3, function () awful.layout.inc(-1) end),
					awful.button({ }, 4, function () awful.layout.inc( 1) end),
					awful.button({ }, 5, function () awful.layout.inc(-1) end)
				)
			)
			-- Create a taglist widget
			s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

			-- Create a tasklist widget
			s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

			-- Create the wibox
			s.mywibox = awful.wibar({ position = "top", screen = s })

			-- Add widgets to the wibox
			s.mywibox:setup {
				layout = wibox.layout.align.horizontal,
					{ -- Left widgets
						layout = wibox.layout.fixed.horizontal,
						mylauncher,
						s.mytaglist,
						s.mypromptbox,
					},
					s.mytasklist, -- Middle widget
					{ -- Right widgets
						layout = wibox.layout.fixed.horizontal,
						mykeyboardlayout,
						wibox.widget.systray(),
						mytextclock,
						s.mylayoutbox,
					},
			}
		end
	)

-- Mouse bindings
	root.buttons(awful.util.table.join(
		awful.button({ }, 3, function () mymainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
	))

-- Key bindings 
	awesomeManagingKeys = awful.util.table.join(
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
		awful.key({         "Control" }, "Print",
			function () io.popen("scrot -s -e 'mv $f ~/Images/screenshots'") end,
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

		awful.key({ modkey,           }, "s", function () awful.client.focus.byidx( 1) end),
		awful.key({ modkey,           }, "t", function () awful.client.focus.byidx(-1) end),
		awful.key({ modkey,           }, "Tab", -- Focus last active client
			function ()
				awful.client.focus.history.previous()
				if client.focus then
					client.focus:raise()
				end
			end),
		awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

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

	applicationLaunchingKeys = awful.util.table.join( 
		-- Administration
		awful.key({ modkey,           }     , "Return", function () awful.spawn(terminal) end),
		awful.key({ modkey, "Mod1"    }     , "f", function () awful.spawn(file_manager) end),
		awful.key({ modkey, "Mod1", "Shift"}, "f", function () awful.spawn(alternative_file_manager) end),
		awful.key({ modkey, "Mod1"    }     , "e", function () awful.spawn(editor) end),

		awful.key({ modkey, "Mod1"    }     , "t", function () awful.spawn("truecrypt") end),

		awful.key({ modkey, "Mod1", "Shift"}, "w", function () io.popen("systemctl poweroff -i") end),

		-- Internet and web
		awful.key({ modkey, "Mod1"    }     , "v", function () awful.spawn(browser.default.command) end),
		awful.key({ modkey, "Mod1", "Shift"}, "v", function () awful.spawn(browser.adopte.command) end),
		awful.key({ modkey, "Mod1"    }     , "d", function () awful.spawn(browser.clean.command) end),
		awful.key({ modkey, "Mod1", "Shift"}, "d", function () awful.spawn(browser.vol.command) end),

		awful.key({ modkey, "Mod1"    }     , "m", function () awful.spawn(mail_client) end),
		awful.key({ modkey, "Mod1"    }     , "i", function () awful.spawn(irc_client, {tag = "1"}) end),

		awful.key({ modkey, "Mod1"    }     , "h", function () awful.spawn("filezilla") end),

		-- Multimedia
		awful.key({ modkey, "Mod1"    }     , "s", function () awful.spawn(music_player) end),

		awful.key({ modkey, "Mod1", "Shift"}, "s",
			function ()
				awful.spawn(
					browser.music.command,
					{
						tag = browser.music.tag
					}
				)
			end
		),

		awful.key({ modkey, "Mod1"    }     , "c", function () awful.spawn("calibre") end),

		-- Divers
		awful.key({ modkey, "Mod1"    }     , "z", function () awful.spawn("zim") end),
		awful.key({ modkey, "Mod1"    }     , "l", function () awful.spawn("libreoffice") end)
	)

	-- Host specific keybinding
		if hostname == "burp" then
			hostSpecificKeys = awful.util.table.join( 
				awful.key({ modkey,"Mod1"}, "w", function () io.popen(suspend) end)
			)

		elseif hostname == "lysa" then
			hostSpecificKeys = awful.util.table.join( 
			awful.key({ modkey,"Mod1"}, "w", function () io.popen(i3lock_command) end)
			)

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

			multimediaKeys = awful.util.table.join(
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
			local touchpad = {}
					touchpad.get_state = function()
						local touchpad = io.popen("synclient -l | grep 'TouchpadOff'")
						local touchpad_state = string.match(touchpad:read("*l"), '(%d)')

						return touchpad_state
					end

					touchpad.switch_off = function()
						io.popen("synclient TouchpadOff=1")
						mouse.coords({x=0, y=0})
					end

					touchpad.switch_on = function()
						io.popen("synclient TouchpadOff=0")
					end

					touchpad.toggle_state = function()
						if touchpad.get_state() == "0" then
							touchpad.switch_off()
						else
							touchpad.switch_on()
						end
					end

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
							
				multimediaKeys = awful.util.table.join(
					awful.key({} ,"XF86AudioMute", function () touchpad.toggle_state() end),

					awful.key({} ,"XF86AudioLowerVolume", function () brightness('down') end),
					awful.key({} ,"XF86AudioRaiseVolume", function () brightness('up') end),

					awful.key({modkey} ,"XF86AudioLowerVolume", function () brightness('off') end),
					awful.key({modkey} ,"XF86AudioRaiseVolume", function () brightness('max') end)
				)

				touchpad.switch_off()
			end

	clientbuttons = awful.util.table.join(
		awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
		awful.button({ modkey }, 1, awful.mouse.client.move),
		awful.button({ modkey }, 3, awful.mouse.client.resize)
	)

	clientkeys = awful.util.table.join(
		awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
		awful.key({ modkey, "Shift"   }, "x",      function (c) c:kill()                         end),
		awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
		awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
		awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
				  {description = "move to screen", group = "client"}),
		awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
		awful.key({ modkey,           }, "n",
			function (c)
				-- The client currently has the input focus, so it cannot be
				-- minimized, since minimized clients can't have the focus.
				c.minimized = true
			end),
		awful.key({ modkey, "Shift"   }, "m",
			function (c)
				c.maximized_horizontal = not c.maximized_horizontal
				c.maximized_vertical   = not c.maximized_vertical
			end),
		awful.key({ modkey,           }, "m", function (c) c.maximized = not c.maximized end,
                  { description = "Toggle maximized", group = "client"})
	)

	globalKeys = awful.util.table.join(
		awesomeManagingKeys,
		applicationLaunchingKeys,
		hostSpecificKeys,
		multimediaKeys
	)

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it works on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, 9 do
		globalKeys = awful.util.table.join(globalKeys,
			-- View tag only.
			awful.key({ modkey }, "#" .. i + 9,
				function ()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						tag:view_only()
					end
				end,
				{description = "view tag #"..i, group = "tag"}
			),

			-- Toggle tag display.
			awful.key({ modkey, "Control" }, "#" .. i + 9,
				function ()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
					 awful.tag.viewtoggle(tag)
					end
				end,
				{description = "toggle tag #" .. i, group = "tag"}
			),

			-- Move client to tag.
			awful.key({ modkey, "Shift" }, "#" .. i + 9,
				function ()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:move_to_tag(tag)
						end
					end
				end,
				{description = "move focused client to tag #"..i, group = "tag"}
			),

			-- Toggle tag on focused client.
			awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				function ()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:toggle_tag(tag)
						end
					end
				end,
				{description = "toggle focused client on tag #" .. i, group = "tag"}
			)
		)
	end

	root.keys(globalKeys)

-- Rules to apply to new clients (through the "manage" signal).
	awful.rules.rules = {
		-- All clients will match this rule.
		{
			rule = { },
			properties = {
				border_width = beautiful.border_width,
				border_color = beautiful.border_normal,
				focus = awful.client.focus.filter,
				raise = true,
				keys = clientkeys,
				buttons = clientbuttons,
				screen = awful.screen.preferred,
				placement = awful.placement.no_overlap+awful.placement.no_offscreen
			}
		},

		-- Floating clients.
		{
			rule_any = {
				instance = {
				  "DTA",  -- Firefox addon DownThemAll.
				  "copyq",  -- Includes session name in class.
				},

				class = {
				  "Arandr",
				  "Gpick",
				  "Kruler",
				  "MessageWin",  -- kalarm.
				  "Sxiv",
				  "Wpa_gui",
				  "pinentry",
				  "veromix",
				  "xtightvncviewer"
				},

				name = {
				  "Event Tester",  -- xev.
				},

				role = {
				  "AlarmWindow",  -- Thunderbird's calendar.
				  "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
				}
			},
			properties = { floating = true }
		},

		{
			rule = { class = "Thunderbird" },
			properties = { screen = 1, tag = "1" }
		},

		{
			rule = { class = "mplayer" },
			properties = { border_width = 0 }
		}
			
	}

-- Signals
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

	-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
	screen.connect_signal("property::geometry", set_wallpaper)

-- Applications launched at startup
	if hostname == "burp" then
		--awful.spawn(browser.default.command, {tag = browser.default.tag})
		--awful.spawn(browser.adopte.command, {tag = browser.adopte.tag})
		--awful.spawn(browser.vol.command, {tag = browser.vol.tag})
		
		--awful.spawn(torrent_client)
		awful.spawn(irc_client, { tag = "1" })
		awful.spawn(browser.clean.command, {tag = browser.clean.tag})
		awful.spawn(mail_client)

		awful.spawn(music_player, {tag = "9"})
		awful.spawn(terminal .. " -e tmux new-session -s admin", {tag = "8"})

		

	elseif hostname == "lysa" then
		awful.spawn('gnome-keyring-daemon --start --foreground --componements=secrets')

	end

	awful.spawn(autolock)
	awful.spawn('owncloud')

