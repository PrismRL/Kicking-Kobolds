local levelgen = require "levelgen"

--- @class Game : Object
--- @field depth integer
--- @field lost boolean
--- @overload fun(seed: string): Game
local Game = prism.Object:extend("Game")

--- @param seed string
function Game:__new(seed)
   self.depth = 0
   self.rng = prism.RNG(seed)
end

--- @return string
function Game:getLevelSeed()
   return tostring(self.rng:random())
end

--- @param player Actor
--- @param builder? LevelBuilder
--- @return LevelBuilder builder
function Game:generateNextFloor(player, builder)
   self.depth = self.depth + 1

   local genRNG = prism.RNG(self:getLevelSeed())
   return levelgen(genRNG, player, 60, 30, builder)
end

_G.Game = Game(tostring(os.time()))
