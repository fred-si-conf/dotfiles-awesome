-- Une simple fonction pour afficher le contenue d’une table en phase
-- de debogage
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = k end
         s = s .. k .. ' = ' .. dump(v) .. ', '
      end
      return s .. '}'
   else
      return tostring(o)
   end
end

return dump
