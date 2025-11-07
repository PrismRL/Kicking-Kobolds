local DrinkTarget = prism.targets.InventoryTarget(prism.components.Drinkable)

--- @class Drink : Action
local Drink = prism.Action:extend "Drink"
Drink.targets = {
   DrinkTarget,
}

--- @param level Level
function Drink:perform(level, drink)
   self.owner:expect(prism.components.Inventory):removeItem(drink)
   local drinkable = drink:expect(prism.components.Drinkable)

   local conditions = self.owner:get(prism.components.ConditionHolder)
   if conditions and drinkable.condition then conditions:add(drinkable.condition) end

   local health = self.owner:get(prism.components.Health)
   if health and drinkable.healing then health:heal(drinkable.healing) end
end

return Drink
