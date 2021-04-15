local wibox = require("wibox")
local vicious = require("vicious")

local mem_bar = wibox.widget.progressbar()

local widget = wibox.widget {
    {
        max_value = 1,
        widget    = mem_bar,
        color     = "red",
        background_color = "#494B4F",
    },
    forced_width = 7,
    direction = 'east',
    layout = wibox.container.rotate,
}

vicious.register(mem_bar, vicious.widgets.mem, "$1", 2)

return widget
