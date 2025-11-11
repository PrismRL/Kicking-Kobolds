local ZappableTarget = prism.targets.InventoryTarget(prism.components.Zappable)

--- @class Zap : Action
local Zap = prism.Action:extend "Zap"
Zap.abstract = true
Zap.targets = { ZappableTarget }
Zap.ZappableTarget = ZappableTarget

--- @param zappable Actor
function Zap:canPerform(level, zappable)
   return zappable:expect(prism.components.Zappable):canZap()
end

--- @param zappable Actor
function Zap:perform(level, zappable)
   zappable:expect(prism.components.Zappable):reduceCharges()
end

return Zap
