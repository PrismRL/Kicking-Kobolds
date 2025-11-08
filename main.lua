require "debugger"
require "prism"
require "game"

prism.loadModule("prism/spectrum")
prism.loadModule("prism/geometer")
prism.loadModule("prism/extra/sight")
prism.loadModule("prism/extra/log")
prism.loadModule("prism/extra/inventory")
prism.loadModule("prism/extra/droptable")
prism.loadModule("prism/extra/condition")
prism.loadModule("prism/extra/equipment")
prism.loadModule("modules/base")
prism.loadModule("modules/game")

love.keyboard.setKeyRepeat(true)


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
   local lz = love.filesystem.read("save.lz4")
   if lz then
      local mp = love.data.decompress("string", "lz4", lz)
      local save = prism.Object.deserialize(prism.messagepack.unpack(mp))
      if save.level then
         Game = save
      end
   end

   if args[1] == "--debug" then
      local builder = prism.LevelBuilder()
      local function generator()
         Game:generateNegamextFloor(prism.actors.Player(), builder)
      end

      manager:push(spectrum.gamestates.MapGeneratorState(generator, builder, display))
   else
      if Game.level then
         manager:push(spectrum.gamestates.GameLevelState(display, Game.level))
      else
         local builder = Game:generateNextFloor(prism.actors.Player())
         manager:push(spectrum.gamestates.GameLevelState(display, builder, Game:getLevelSeed()))
      end
   end
   manager:hook()
   spectrum.Input:hook()
end

function love.quit()
   if Game.lost then love.filesystem.remove("save.lz4") return end
   local save = Game:serialize()
   local mp = prism.messagepack.pack(save)
   local lz = love.data.compress("string", "lz4", mp)

   love.filesystem.write("save.lz4", lz)
end