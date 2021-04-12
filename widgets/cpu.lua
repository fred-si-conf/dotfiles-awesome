local wibox = require("wibox")
local vicious = require("vicious")

local widget = wibox.widget.graph()

widget:set_width(25)
widget:set_background_color("#494B4F")
widget:set_color{
    type = "linear",
    from = {0, 0},
    to = {0, 20},
    stops = {{0, "red"}, {0.5, "yellow"}, {1, "green"}}
}

vicious.register(widget, vicious.widgets.cpu, "$1", 1)

return widget
