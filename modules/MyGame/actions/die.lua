---@class Die : Action
local Die = prism.Action:extend("Die")

function Die:perform(level)
    level:removeActor(self.owner)
end

return Die