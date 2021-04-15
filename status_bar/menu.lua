local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local menu_items = {{"hotkeys", function() return false, hotkeys_popup.show_help end}}
local main_menu = awful.menu({items = menu_items})

return main_menu
