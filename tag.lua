-- tag management module
--

local awful = require("awful")

local Module = {}

Module.view_tag = function(i)
    local screen = awful.screen.focused()
    local tag = screen.tags[i]

    if tag then
        tag:view_only()
    end
end

Module.toggle_tag_display = function(i)
    local screen = awful.screen.focused()
    local tag = screen.tags[i]

    if tag then
        awful.tag.viewtoggle(tag)
    end
end

Module.move_client_to_tag = function(i)
    if client.focus then
        local tag = client.focus.screen.tags[i]

        if tag then
            client.focus:move_to_tag(tag)
        end
    end
end

Module.toggle_tag_on_focused_client = function(i)
    if client.focus then
        local tag = client.focus.screen.tags[i]

        if tag then
            client.focus:toggle_tag(tag)
        end
    end
end

return Module
