local awful = require("awful")
local beautiful = require("beautiful")

return function (client_keys, client_buttons)
    return {
        -- All clients will match this rule.
        {
            rule = { },
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                keys = client_keys,
                buttons = client_buttons,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen
            }
        },

        -- Floating clients.
        {
            properties = { floating = true },
            rule_any = {
                class = {
                  "Arandr",
                  "Sxiv",
                  "pinentry",
                  "copyq",  -- Includes session name in class.
                  "Gnome-calculator",
                },

                name = {
                  "Event Tester",  -- xev.
                },

                role = {
                  "AlarmWindow",  -- Thunderbird's calendar.
                  "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
        },
        {
            rule = { class = "copyq" },
            properties = {
                placement = awful.placement.top_right,
                height = awful.screen.focused().workarea.height,
            },
        },

        {
            properties = { screen = 1, tag = "1" },
            rule_any = {
                class = {
                    "thunderbird",
                    "discord",
                    "Signal",
                }
            },
        },
        {
            properties = { screen = 1, tag = "5" },
            rule_any = {
                class = {
                    "jetbrains-idea-ce",
                    "jetbrains-phpstorm",
                    "code-oss",
                }
            },
        },

        {
            rule = { class = "mplayer" },
            properties = { border_width = 0 }
        },

        -- Jetbrains
        {
            -- start popups
            properties = {
                floating = true,
                placement = awful.placement.centered,
            },
            rule_any = {
                name = {
                    "Welcome to PyCharm",
                    "Trust and Open Project.*",
                    "Cannot execute command",
                    "win0"
                },
            }
        },
    }
end

