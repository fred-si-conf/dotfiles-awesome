local naughty = require("naughty")

local notify = naughty.notify
local presets = naughty.config.presets


local function notifier(a_preset)
    return function(a_title, a_text)
        notify({preset = a_preset, title = a_title, text = a_text})
    end
end

return {
    critical = notifier(presets.critical),
    normal = notifier(presets.normal), 
}
