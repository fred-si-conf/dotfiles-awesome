-- Une simple fonction pour afficher le contenue d’une table en phase
-- de debogage
function dump(o, indent_level)
   t = type(o)
   if t == 'table' then
      return dump_table(o, indent_level)
   elseif t == 'client' then
      return dump_client_properties(o)
   else
      return tostring(o)
   end
end

function dump_table(table, indent_level, indent_size)
   indent_level = indent_level or 1
   local base_indent = string.rep(' ', indent_size or 4)
   local indent = string.rep(base_indent, indent_level)

   local s = '{\n'
   for k,v in pairs(table) do
      s = s .. indent .. k .. ' = ' .. dump(v, indent_level + 1) .. ',\n'
   end
   return s .. string.rep(base_indent, indent_level - 1) .. '}'
end

function dump_client_properties(client)
   props_to_dump = {
      'window',
      'leader_window',
      'name',
      'class',
      'instance',
      'type',
      'role',
   }

   local t = {}
   for _, prop in ipairs(props_to_dump) do
      t[prop] = client[prop]
   end

   return dump_table(t)
end

return dump
