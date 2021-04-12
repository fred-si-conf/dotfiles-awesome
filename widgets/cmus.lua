local get_state = require("..plugins.cmus")
local vicious = require("vicious")

local function to_string(args)
    if args.status == "Stopped" then
        return " - "
    else
        return args.status .. ': ' .. args.artist .. ' - ' .. args.title
    end
end

local widget = require("wibox").widget.textbox() 

vicious.register(widget, function(...) return to_string(get_state()) end, "$1", 1)

return widget

