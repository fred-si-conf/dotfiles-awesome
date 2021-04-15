local awful = require("awful")
local gears = require("gears")
local client_tools = require("utils.client")

local LEFT_BUTTON = 1
local RIGHT_BUTTON = 3

local modkey = "Mod4"

return {
    taglist = gears.table.join(
        awful.button({}, LEFT_BUTTON, function(t) t:view_only() end),
        awful.button({modkey}, LEFT_BUTTON, client_tools.move_focused_to_tag),
        awful.button({}, RIGHT_BUTTON, awful.tag.viewtoggle),
        awful.button({modkey}, RIGHT_BUTTON, client_tools.display_focused_on_tag)
    ),

    tasklist = gears.table.join(
        awful.button({}, LEFT_BUTTON, client_tools.focus_or_minimize),
        awful.button({}, RIGHT_BUTTON, client_tools.menu_toggle())
    ),
    
    layoutbox = gears.table.join(
        awful.button({ }, LEFT_BUTTON, function () awful.layout.inc( 1) end),
        awful.button({ }, RIGHT_BUTTON, function () awful.layout.inc(-1) end)
    ),
}
