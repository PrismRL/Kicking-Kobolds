local Log = prism.components.Log
local Name = prism.components.Name

local HurtZappableTarget = prism.targets.InventoryTarget(prism.components.HurtZappable)

local HurtTarget = prism.Target(prism.components.Health):range(5):sensed()

--- @class HurtZap : Zap
local HurtZap = prism.actions.Zap:extend "HurtZap"
HurtZap.name = "Zap"
HurtZap.abstract = false
HurtZap.targets = {
   HurtZappableTarget,
   HurtTarget,
}

--- @param level Level
function HurtZap:perform(level, zappable, hurtable, secondHurtable)
   self.super.perform(self, level, zappable)
   local zappableComponent = zappable:expect(prism.components.HurtZappable)
   local damage = prism.actions.Damage(hurtable, zappableComponent.damage)
   level:tryPerform(damage)

   local dealt = damage.dealt or 0
   local zapName = Name.lower(hurtable)
   local ownerName = Name.lower(self.owner)

   Log.addMessage(self.owner, "You zap the %s for %i damage!", zapName, dealt)
   Log.addMessage(hurtable, "The %s zaps you for %i damage!", ownerName, dealt)
   Log.addMessageSensed(
      level,
      self,
      "The %s kicks the %s for %i damage.",
      ownerName,
      zapName,
      dealt
   )
end

return HurtZap
