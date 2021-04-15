local awful = require("awful")
local widget = awful.widget
local beautiful = require("beautiful")
local wibox = require("wibox")

local require_relative = require("utils.require")(...)
local require_widget = require_relative:create_sub_module_require(".widgets")

local caps_lock = require_widget("caps_lock")
local buttons = require_relative(".buttons")

local main_menu = require_relative(".menu")

local function create_left_layout(screen)
    screen.mypromptbox = widget.prompt()

    -- Si on construit le launcher dans le module menu cela ne fonctionne pas.
    -- Je n’ai pas encore réussi à trouver la cause de ce problème.
    local menu_launcher = awful.widget.launcher({
        image = beautiful.awesome_icon,
        menu = main_menu
    })

    return {
        layout = wibox.layout.fixed.horizontal,

        menu_launcher,
        widget.taglist(screen, widget.taglist.filter.all, buttons.taglist),
        screen.mypromptbox,
    }
end

local function create_right_layout(screen)
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    local layoutbox = widget.layoutbox(screen)
    layoutbox:buttons(buttons.layoutbox)

    local spacer = require_widget("spacer")

    return { 
        layout = wibox.layout.fixed.horizontal,

        spacer,
        caps_lock.widget, spacer,

        require_widget("cpu"), spacer,
        require_widget("memory"), spacer,
        require_widget("cmus"), spacer,
        wibox.widget.systray(), spacer,
        require_widget("clock"), spacer,

        layoutbox,
    }
end

local function new(screen)
    screen.mypromptbox = widget.prompt()

    local status_bar = awful.wibar({ position = "top", screen = screen })
    status_bar:setup({
        layout = wibox.layout.align.horizontal,

        create_left_layout(screen),
        widget.tasklist(screen, widget.tasklist.filter.currenttags, buttons.tasklist),
        create_right_layout(screen),
    })
end

return setmetatable(
    {caps_lock_key = caps_lock.key},
    {__call = function(_, ...) new(...) end}
)
    
