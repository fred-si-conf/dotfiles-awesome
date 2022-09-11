local wibox = require("wibox")
local wibar = require("awful.wibar")
local screen = require("awful.screen")
local gears = require("gears")
local dump = require("utils.dump_table")
local theme = require("theme.theme")
local naughty = require("naughty")
local notify = require("utils.notify")

local function factory(title, text)
    return {
        {
            {
                {
                    {
                        markup = '<span weight="heavy">' .. title .. '</span>',
                        widget = wibox.widget.textbox,
                        valign = top,
                    },
                    {
                        text = text,
                        widget = wibox.widget.textbox,
                        valign = 'top',
                    },
                    layout = wibox.layout.fixed.vertical,
                    spacing = 5,
                },
                margins = 10,
                widget = wibox.container.margin
            },
            bg     = theme.bg_focus,
            widget = wibox.container.background,
        },
        height = 100,
        strategy = 'min',
        widget = wibox.container.constraint,
    }
end

local function a()
    o = notify.normal('toto', 'tata')

    return dump(naughty.config)
end

local notifications = {
    factory('test', 'salut'),
    factory('test', 'les'),
    factory('test', 'gens'),
    factory('test', a()),
    spacing = 10,
    layout = wibox.layout.fixed.vertical,
}

--naughty.config.notify_callback = function()
  --  table.insert(notifications, 1, factory('test', 'test'))
--end

local popup = awful.popup {
    widget = {
        {
            {
                {
                    text   = 'foobar',
                    widget = wibox.widget.textbox
                },
                notifications,
                layout = wibox.layout.fixed.vertical,
                spacing = 10
            },
            margins = 10,
            widget = wibox.container.margin,
        },
        margins = 10,
        width = 300,
        strategy = 'min',
        widget  = wibox.container.constraint,
    },
    placement = awful.placement.top_right + awful.placement.stretch_down,
    visible      = true,
    ontop        = true
}


function toggle()
    wibox.layout.fixed:add(notifications, factory('a','a'))
    popup.visible = not popup.visible
end

return setmetatable(
    {},
    {__call = toggle}
)
