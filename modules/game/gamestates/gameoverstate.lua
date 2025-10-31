local controls = require "controls"

--- @class GameOverState : GameState
--- @field display Display
--- @overload fun(display: Display): GameOverState
local GameOverState = spectrum.GameState:extend("GameOverState")

function GameOverState:__new(display)
   self.display = display
end

function GameOverState:draw()
   local midpoint = math.floor(self.display.height / 2)

   self.display:clear()
   self.display:putString(1, midpoint, "Game over!", nil, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 3, "[r] to restart", nil, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 4, "[q] to quit", nil, nil, nil, "center", self.display.width)
   self.display:draw()
end

function GameOverState:update(dt)
   controls:update()

   if controls.quit.pressed then
      love.event.quit()
   elseif controls.restart.pressed then
      love.event.restart()
   end
end

return GameOverState
