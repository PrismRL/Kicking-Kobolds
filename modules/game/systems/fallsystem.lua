--- @class FallSystem : System
local FallSystem = prism.System:extend "FallSystem"

function FallSystem:onMove(level, actor)
   level:tryPerform(prism.actions.Fall(actor))
end

return FallSystem

