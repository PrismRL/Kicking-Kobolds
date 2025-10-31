require "debugger"
require "prism"

prism.loadModule("prism/spectrum")
prism.loadModule("prism/geometer")
prism.loadModule("prism/extra/sight")
prism.loadModule("prism/extra/log")
prism.loadModule("prism/extra/inventory")
prism.loadModule("prism/extra/droptable")
prism.loadModule("prism/extra/statuseffects")
prism.loadModule("modules/base")
prism.loadModule("modules/game")

love.keyboard.setKeyRepeat(true)

local Game = require("game")

-- Load a sprite atlas and configure the terminal-style display,
local spriteAtlas = spectrum.SpriteAtlas.fromASCIIGrid("display/wanderlust_16x16.png", 16, 16)
local display = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(16, 16))

-- Automatically size the window to match the terminal dimensions
display:fitWindowToTerminal()

-- spin up our state machine
--- @type GameStateManager
local manager = spectrum.StateManager()

-- we put out levelstate on top here, but you could create a main menu
--- @diagnostic disable-next-line
function love.load(args)
   if args[1] == "--debug" then
      local builder = prism.LevelBuilder(prism.cells.Pit)
      local function generator()
         Game:generateNextFloor(prism.actors.Player(), builder)
      end

      manager:push(spectrum.gamestates.MapGeneratorState(generator, builder, display))
   else
      local builder = Game:generateNextFloor(prism.actors.Player())
      manager:push(spectrum.gamestates.GameLevelState(display, builder, Game:getLevelSeed()))
   end
   manager:hook()
   spectrum.Input:hook()
end
