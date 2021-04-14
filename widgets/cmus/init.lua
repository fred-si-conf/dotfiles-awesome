local vicious = require("vicious")
local helpers = require("vicious.helpers")

local get_state = require(select(1, ...) .. ".get_state")

local icons_dir = select(2, ...):gsub('/[^/]+$', '') .. '/icons'

text_format = "$status: $artist - $title"

local function to_string(args)
    return args.status ~= "stopped" and helpers.format(text_format, args) or ""
end

local widget = require("wibox").widget.textbox() 

vicious.register(widget, function() return to_string(get_state()) end, "$1", 1)

return widget

