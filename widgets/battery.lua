-- This module provide a simple battery_widget for use it simple add widget to
-- your statusbar

vicious = require("vicious")

local wibox = require("wibox")
local beautiful = require("beautiful")

local battery_widget = wibox.widget.progressbar()
local batbox = wibox.widget {
    {
        max_value     = 1,
        widget        = battery_widget,
        forced_width  = 30,
        direction     = 'east',
        color         = {
            type = "linear",
            from = {0, 0},
            to = {0, 30},
            stops = {
                {0, "#AECF96"},
                {1, "#FF5656"}
            }
        }
    },
    {
        text = 'battery',
        widget = wibox.widget.textbox
    },
    color = beautiful.fg_widget,
    layout = wibox.layout.stack
}

batbox = wibox.container.margin(batbox, 4, 4, 4, 4)

vicious.register(widget, vicious.widgets.bat, "$2", 120, "BATC")

return batbox
