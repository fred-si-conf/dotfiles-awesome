local awful = require('awful')
local notify = require('utils.notify')

local function notify_if_not_exist(command_name)
    awful.spawn.easy_async(
        'which ' .. command_name,
        function(stdout, stderr, exit_reason, exit_code)
            if exit_code ~= 0 then
                notify.critical(
                    'Dependecy check fail',
                    'The Program "' .. command_name .. '" is not found in PATH'
                )
            end
        end
    )
end

return {
    notify_if_not_exist = notify_if_not_exist
}