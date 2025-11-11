-- some abbreviations for our log work
local Log = prism.components.Log
local Name = prism.components.Name

local EatTarget = prism.targets.InventoryTarget(prism.components.Edible)

---@class Eat : Action
---@overload fun(owner: Actor, food: Actor): Eat
local Eat = prism.Action:extend("Eat")

Eat.requiredComponents = {
   prism.components.Health,
}

Eat.targets = {
   EatTarget,
}

--- @param level Level
---@param food Actor
function Eat:perform(level, food)
   local edible = food:expect(prism.components.Edible)
   local health = self.owner:expect(prism.components.Health)
   health:heal(edible.healing)

   local inventory = self.owner:expect(prism.components.Inventory)
   inventory:removeQuantity(food, 1)

   Log.addMessage(self.owner, "You eat the %s", Name.get(food))
   Log.addMessageSensed(level, self, "%s eats the %s", Name.get(self.owner), Name.get(food))
end

return Eat
