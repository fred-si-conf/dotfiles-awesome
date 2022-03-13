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
            caps_lock
            -- more stuff
        }
    }

    -- emit "Caps_Lock::press" event on caps lock key_press
    awful.key({}, "Caps_Lock", function() awesome.emit_signal("Caps_Lock::press")
]]

local wibox = require("wibox")

local widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    base_markup = '<span background="red"><b>%s</b></span>',
    active_text = ' CAPS LOCK ',
    inactive_text = '',
    is_active = nil
}

function widget:init()
    local stdout = io.popen("xset q")
    local xset_output = stdout:read("*all")
    stdout:close()

    self.is_active = xset_output:gsub(".*(Caps Lock:%s+)(%a+).*", "%2") == 'on'
    self:update()

    awesome.connect_signal("Caps_Lock::press", function() widget:toggle() end)
end

function widget:update()
    local text = self.is_active and self.active_text or self.inactive_text
    self.markup = string.format(self.base_markup, text)
end

function widget:toggle()
    self.is_active = not self.is_active
    self:update()
end


widget:init()
return widget
