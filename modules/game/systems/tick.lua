--- @class TickSystem : System
local TickSystem = prism.System:extend "TickSystem"

function TickSystem:onTurn(level, actor)
   level:tryPerform(prism.actions.Tick(actor))
end

return TickSystem