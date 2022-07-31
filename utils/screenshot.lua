-- Screenshot module wrapper
local awful = require("awful")
local notify = require("utils.notify")
local dependency_checker = require("utils.dependency_checker")

local SCREENSHOT_EXECUTABLE_NAME = 'scrot'
local SCROT_BASE_COMMAND = SCREENSHOT_EXECUTABLE_NAME .. " %s -e '%s'"

local MV_BASE_COMMAND = 'mv $f %s'
local XCLIP_BASE_COMMAND = 'xclip -selection clipboard -target image/png %s/$n'

local Screenshot = {
    destination_folder = nil,
}

function Screenshot:take(option)
    local option = option or ''
    awful.spawn(
        string.format(SCROT_BASE_COMMAND, option, self.post_screenshot_command)
    )
end

function Screenshot:screen()
    self:take('')
end

function Screenshot:focused_window()
    self:take('--focused')
end

function Screenshot:selection()
    self:take('--select')
end

return function(destination_folder)
    if not destination_folder then
        error({
            name = 'ValueError',
            message = 'destination_folder must given at module initialisation'
        })
    end

    dependency_checker.notify_if_not_exist(SCREENSHOT_EXECUTABLE_NAME)

    local mv = string.format(MV_BASE_COMMAND, destination_folder)
    local xclip = string.format(XCLIP_BASE_COMMAND, destination_folder)
    local post_screenshot_command = string.format('%s && %s', mv, xclip)

    return setmetatable(
        {
            post_screenshot_command = post_screenshot_command
        },
        {__index = Screenshot}
    )
end

