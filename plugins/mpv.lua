local awful = require("awful")
local notify = require("utils.notify")

local MPV_YTDL_COMMAND = "mpv --ytdl -- '%s'"
local YOUTUBEDL_TITLE_COMMAND = "youtube-dl -e -- '%s'"

local function get_clipboard_content()
    local clipboard = io.popen("xclip -selection c -o")
    local content = clipboard:read()

    if not clipboard:close() then
        error({name = 'ClipboardError', message = "Unable to get xclip content"})
    end

    return content
end

local function get_url_from_clipboard()
    return string.gsub(get_clipboard_content(), '^http:', 'https:')
end

local function get_yt_video_title(url)
    local ytdl = io.popen(YOUTUBEDL_TITLE_COMMAND:format(url))
    local title = ytdl:read()

    if not ytdl:close() then
        error({name = "YtdlError", message = "Unable to get title from ytdl"})
    end

    return title
end

local function ytdl_from_clipboard()
    local status, output, url, title
    status, output = pcall(get_url_from_clipboard)

    if not status then
        notify.critical(output.name, output.message)
        return
    else
        url = output
    end

    notify.normal("Launch mpv", url)
    awful.spawn.easy_async(
        MPV_YTDL_COMMAND:format(url),
        function(stdout, _, _, exit_code)
            if exit_code ~= 0 then
                local text = ('exit code: %s\nstdout: %s'):format(exit_code, stdout)
                notify.critical('Unable to launch MPV', text)
            end
        end
    )
end

return {
    ytdl_from_clipboard = ytdl_from_clipboard
}
