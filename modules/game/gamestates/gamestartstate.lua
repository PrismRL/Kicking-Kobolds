local controls = require "controls"

--- @class GameStartState : GameState
--- @field display Display
--- @overload fun(display: Display): GameStartState
local GameStartState = spectrum.GameState:extend("GameStartState")

function GameStartState:__new(display)
   self.display = display

   self.save = love.filesystem.read("save.lz4")
end

function GameStartState:draw()
   local midpoint = math.floor(self.display.height / 2)

   -- stylua: ignore start
   self.display:clear()
   self.display:print(1, midpoint, "Kicking Kobolds", nil, nil, nil, "center", self.display.width)

   self.display:print(1, midpoint + 3, "[n] for new game", nil, nil, nil, "center", self.display.width)

   local i = 0
   if self.save then
      i = i + 1
      self.display:print(1, midpoint + 3 + i, "[l] to load game", nil, nil, nil, "center", self.display.width)
   end

   self.display:print(1, midpoint + 4 + i, "[q] to quit", nil, nil, nil, "center", self.display.width)
   -- stylua: ignore end
   self.display:draw()
end

function GameStartState:update(dt)
   controls:update()

   if controls.newgame.pressed then
      love.filesystem.remove("save.lz4")
      local builder = Game:generateNextFloor(prism.actors.Player())
      self.manager:enter(
         spectrum.gamestates.GameLevelState(self.display, builder, Game:getLevelSeed())
      )
   elseif controls.loadgame.pressed and self.save then
      local mp = love.data.decompress("string", "lz4", self.save)
      local save = prism.Object.deserialize(prism.messagepack.unpack(mp))
      Game = save

      assert(Game.level)
      self.manager:enter(spectrum.gamestates.GameLevelState(self.display, Game.level))
   elseif controls.quit.pressed then
      love.quit()
   end
end

return GameStartState
