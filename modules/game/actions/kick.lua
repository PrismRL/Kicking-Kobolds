local Log = prism.components.Log
local Name = prism.components.Name

local KickTarget = prism.Target(prism.components.Collider):range(1):sensed()

---@class KickAction : Action
local Kick = prism.Action:extend("Kick")
Kick.targets = { KickTarget }
Kick.requiredComponents = {
   prism.components.Controller,
}

--- @param level Level
--- @param kicked Actor
function Kick:perform(level, kicked)
   local direction = (kicked:getPosition() - self.owner:getPosition())

   local mask = prism.Collision.createBitmaskFromMovetypes { "fly" }

   local final = kicked:expectPosition()
   for _ = 1, 3 do
      local nextpos = final + direction
      if not level:getCellPassable(nextpos.x, nextpos.y, mask) then break end
      final = nextpos
   end
   level:moveActor(kicked, final)

   local damage = prism.actions.Damage(kicked, 1)
   level:tryPerform(damage)

   local kickName = Name.lower(kicked)
   local ownerName = Name.lower(self.owner)
   local dealt = damage.dealt or 0

   Log.addMessage(self.owner, "You kick the %s for %i damage.", kickName, dealt)
   Log.addMessage(kicked, "The %s kicks you for %i damage!", ownerName, dealt)
   Log.addMessageSensed(level, self, "The %s kicks the %s for %i damage.", ownerName, kickName, dealt)
end

return Kick
