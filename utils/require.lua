-- Crée un importeur relatif
-- ce module renvoie une fonction qui permet de créer un importeur
-- relatif

-- Pour récupérer un importeur relatif au module courant il doit être
-- importé depuis la racine d’un module avec ... en parametre:
-- @usage
-- local require_relative = require("utils.require")(...)
-- local my_module = require_relative(".my_module")

Module = {}

setmetatable(
    Module,
    {__call = function(self, path) return require(self.current_path .. path) end}
)

--- Retourne un importeur relatif à un sous module
-- @param string base_relative_path The relative path to sub module
-- @usage
-- local require_relative = require("utils.require")(...)
-- local require_sub_module = require_relative:create_sub_module_require(".sub_module")
-- local sub_sub_module = require_sub_module("sub_module")
function Module:create_sub_module_require(base_relative_path)
    return function(name)
        return require(self.current_path .. base_relative_path .. "." .. name)
    end
end

return function(...)
    Module.current_path = select(1, ...)

    return Module
end

