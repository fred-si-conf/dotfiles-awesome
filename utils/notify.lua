local naughty = require("naughty")

local notify = naughty.notify
local presets = naughty.config.presets

local Notification = {}
function Notification:init(args)
    self.notification = notify(args)
    return self.notification
end

function Notification:destroy()
    naughty.destroy(self.notification)
end


local function create_notifier(preset)
    return function(title, text)
        return Notification:init({preset = preset, title = title, text = text})
    end
end

return {
    critical = create_notifier(presets.critical),
    normal = create_notifier(presets.normal), 
}
