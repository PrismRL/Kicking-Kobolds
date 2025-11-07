--- @class DrinkableOptions
--- @field healing integer?
--- @field status Condition?

--- @class Drinkable : Component
--- @field healing integer
--- @field condition Condition?
--- @overload fun(options: DrinkableOptions): Drinkable
local Drinkable = prism.Component:extend "Drinkable"

function Drinkable:__new(options)
   self.healing = options.healing
   self.condition = options.condition
end

return Drinkable
