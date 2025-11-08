--- @class GameCondition : Condition
--- @field duration integer?
local GameCondition = prism.condition.Condition:extend "GameStatusInstance"

--- @class GameConditionOptions : Condition
--- @field duration integer

--- @param options GameConditionOptions
function GameCondition:__new(options)
   prism.conditions.Condition.__new(self, options)
   self.duration = options.duration or nil
end

return GameCondition