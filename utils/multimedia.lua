local notify = require("utils.notify")

function in_table(needle, haystack)
    for _, v in ipairs(haystack) do
        if v == needle then
            return true
        end
    end

    return false
end

function player_control(command)
    if not in_table(command, {"play-pause", "stop", "previous", "next"}) then
        notify.critical(
            "Multimedia player control",
            "Unknown command '" .. command .. "'"
        )
        return
    end

    awful.spawn("playerctl " .. command)
end

volume_step = "5%"
volume_commands = {
    base = "amixer set Master %s",
    mute = "toggle",
    up = volume_step .. "+",
    down = volume_step .. "-",
}

function volume_control(command)
    if not in_table(command, {"up", "down", "mute"}) then
        notify.critical("Volume control", "Unknown command '" .. command .. "'")
    end

    cmd = string.format(volume_commands.base, volume_commands[command])
    awful.spawn(cmd)
end

return {
    player = {
        toggle_play_pause = function() player_control("play-pause") end,
        stop = function() player_control("stop") end,
        previous = function() player_control("previous") end,
        next = function() player_control("next") end,
    },
    volume = {
        up = function() volume_control("up") end,
        down = function() volume_control("down") end,
        mute = function() volume_control("mute") end,
    }
}