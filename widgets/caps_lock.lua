--[[
    A simple widget to show whether Caps Lock is active.
    @Requirements:
        - Awesome 5.x
        - xset

    @usage
    caps_lock = require("caps_lock")

    -- Add widget to wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            caps_lock.widget
            -- more stuff
        }
    }

    -- Add key to globalkeys
    globalkeys = gears.table.join(globalkeys, caps_lock.key)

]]

local awful = require("awful")
local wibox = require("wibox")

local widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    base_markup = '<span background="red"><b>%s</b></span>',
    active_text = ' CAPS LOCK ',
    inactive_text = ''
}

function is_active(xset_output)
    if xset_output:gsub(".*(Caps Lock:%s+)(%a+).*", "%2") == 'on' then
        return true
    end

    return false
end

function widget:update()
    awful.spawn.easy_async('xset q', function (output)
        local text = is_active(output) and self.active_text or self.inactive_text
        self.markup = string.format(self.base_markup, text)
    end)
end

widget:update()

return {
    widget = widget,
    key = awful.key({}, "Caps_Lock", function() end, function () widget:update() end),
}
