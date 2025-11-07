--- @class Tick : Action
local Tick = prism.Action:extend "Tick"
Tick.requiredComponents = { prism.components.ConditionHolder }

--- @param level Level
function Tick:perform(level)
   -- Handle status effect durations
   self.owner
      :expect(prism.components.ConditionHolder)
      :each(function(condition)
         if prism.conditions.TickedCondition:is(condition) then
            --- @cast condition TickedCondition
            condition.duration = condition.duration - 1
         end
      end)
      :removeIf(function(condition)
         --- @cast condition TickedCondition
         return prism.conditions.TickedCondition:is(condition) and condition.duration <= 0
      end)

   -- Validate components
   local health = self.owner:get(prism.components.Health)
   if health then health:enforceBounds() end
end

return Tick
