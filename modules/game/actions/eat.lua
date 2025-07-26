local EatTarget = prism.InventoryTarget(prism.components.Edible)
   :inInventory()

---@class Eat : Action
---@overload fun(owner: Actor, food: Actor): Eat
local Eat = prism.Action:extend("Eat")

Eat.requiredComponents = {
   prism.components.Health
}

Eat.targets = {
   EatTarget
}

--- @param level Level
---@param food Actor
function Eat:perform(level, food)
   local edible = food:expect(prism.components.Edible)
   local health = self.owner:expect(prism.components.Health)
   health:heal(edible.healing)

   local inventory = self.owner:expect(prism.components.Inventory)
   inventory:removeQuantity(food, 1)
end

return Eat