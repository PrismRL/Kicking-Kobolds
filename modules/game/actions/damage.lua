local DamageTarget = prism.Target()
   :isType("number")

local Damage = prism.Action:extend("Damage")
Damage.name = "Damage"
Damage.targets = { DamageTarget }

function Damage:getRequirements()
   return prism.components.Health
end

function Damage:perform(level, damage)
   local health = self.owner:expect(prism.components.Health)
   health.hp = health.hp - damage

   if health.hp <= 0 then
      level:perform(prism.actions.Die(self.owner))
   end
end

return Damage