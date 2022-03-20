-- this file contain web browser configuration
--
--
DEFAULT_EXECUTABLE = 'firefox'

browsers = {
    default = {
        profile = 'default',
        autolaunch = true,
        tag = '2'
    },
    clean = {
        profile = 'clean',
        autolaunch = true,
        tag = '3'
    },
    vol = {
        profile = 'vol',
        tag = '4'
    },
    afpa = {
        profile = 'afpa',
        tag = '4'
    },
    music = {
        profile = 'soundcloud',
        tag = '9'
    },
    dev = {
        profile = 'dev-edition-default',
        executable = 'firefox-developer-edition',
        tag = '6'
    },
}

function get_wm_class(profile_name)
    return 'browser-' .. profile_name
end

Mod = {}
function Mod:list_profiles()
    profiles_names = {}
    for k, _ in pairs(browsers) do
        table.insert(profiles_names, k)
    end

    return profiles_names
end

function Mod:get_rules()
    rules = {
        {
            rule = { role = "About" },
            properties = { floating = true },
        }

    }
    for k, v in pairs(browsers) do
        table.insert(rules, {
                rule = {class = get_wm_class(k)},
                properties = {tag = v.tag},
            })
    end

    return rules
end

function Mod:get_command(name)
    config = browsers[name]
    command = {}

    if config.executable then
        table.insert(command, config.executable)
    else
        table.insert(command, DEFAULT_EXECUTABLE)
    end

    table.insert(command, '-p ' .. config.profile)
    table.insert(command, '--class ' .. get_wm_class(name))

    return table.concat(command, ' ')
end

function Mod:get_autolaunch()
    commands = {}
    for k, v in pairs(browsers) do
        if v.autolaunch then
            table.insert(commands, Mod:get_command(k))
        end
    end

    return commands
end

return Mod
