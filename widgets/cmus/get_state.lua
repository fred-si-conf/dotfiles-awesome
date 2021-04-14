local helpers = require("vicious.helpers")

return function()
    local state  = {}

    local f = io.popen("cmus-remote -Q")
    for line in f:lines() do
        for i, j, k in line:gmatch('(%w+) (%S+)(.*)') do
            -- line can have 2 or 3 columns, when line have 3 columns, the firsg
            -- column is unwanted
            if k:len() > 0 then
                i, j = j, k
            end

            state[i] = helpers.escape(j:match('^%s*(.-)%s*$'))
        end
    end
    f:close()

    return state
end

