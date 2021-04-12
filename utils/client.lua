awful = require("awful")

local mod = {}

-- display the client menu
mod.menu_toggle = function ()
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

mod.move_focused_to_tag = function(t)
    if client.focus then
        client.focus:move_to_tag(t)
    end
end

mod.display_focused_on_tag =  function(t)
    if client.focus then
        client.focus:toggle_tag(t)
    end
end

mod.focus_or_minimize = function (c)
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
end

return mod
