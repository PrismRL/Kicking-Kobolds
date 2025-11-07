--- @class TickedCondition : Condition
--- @field duration integer
--- @overload fun(duration: integer, ...: ConditionModifier): TickedCondition
local TickedCondition = prism.condition.Condition:extend "TickedCondition"

--- @param duration integer
--- @param ... ConditionModifier
function TickedCondition:__new(duration, ...)
   self.super.__new(self, ...)
   self.duration = duration
end

return TickedCondition
