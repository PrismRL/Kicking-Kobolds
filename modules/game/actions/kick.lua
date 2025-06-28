local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

local KickTarget = prism.Target()
   :with(prism.components.Collider)
   :range(1)
   :sensed()

---@class KickAction : Action
local Kick = prism.Action:extend("KickAction")
Kick.name = "Kick"
Kick.targets = { KickTarget }
Kick.requiredComponents = {
   prism.components.Controller
}

--- @param level Level
--- @param kicked Actor
function Kick:perform(level, kicked)
   local direction = (kicked:getPosition() - self.owner:getPosition())

   local mask = prism.Collision.createBitmaskFromMovetypes{ "fly" }

   for _ = 1, 3 do
      local nextpos = kicked:getPosition() + direction

      if not level:getCellPassable(nextpos.x, nextpos.y, mask) then break end
      if not level:hasActor(kicked) then break end

      level:moveActor(kicked, nextpos)
   end

   local damage = prism.actions.Damage(kicked, 1)
   if level:canPerform(damage) then
      level:perform(damage)
   end

   local dmgstr = ""
   if damage.dealt then
      dmgstr = sf("Dealing %i damage.", damage.dealt)
   end
   
   local kickName = Name.lower(kicked)
   local ownerName = Name.lower(self.owner)
   Log.addMessage(self.owner, sf("You kick the %s. %s", kickName, dmgstr))
   Log.addMessage(kicked, sf("The %s kicks you! %s", ownerName, dmgstr))
   Log.addMessageSensed(level, self, sf("The %s kicks the %s. %s", ownerName, kickName, dmgstr))
end

return Kick