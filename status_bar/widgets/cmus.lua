local vicious = require("vicious")
local helpers = require("vicious.helpers")

text_format = "$status: $artist - $title"

local function to_string(args)
    return args.status ~= "stopped" and helpers.format(text_format, args) or ""
end

local widget = require("wibox").widget.textbox() 

vicious.register(widget, vicious.widgets.cmus, "${status}: ${artist} - ${title}", 1)

return widget

