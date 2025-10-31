local Game = require "game"
local controls = require "controls"

--- @class GameLevelState : LevelState
--- A custom game level state responsible for initializing the level map,
--- handling input, and drawing the state to the screen.
---
--- @field level Level
--- @overload fun(display: Display, builder: LevelBuilder, seed: string): GameLevelState
local GameLevelState = spectrum.gamestates.LevelState:extend "GameLevelState"

--- @param display Display
--- @param builder LevelBuilder
--- @param seed string
function GameLevelState:__new(display, builder, seed)
   builder:addSeed(seed)
   builder:addSystems(
      prism.systems.SensesSystem(),
      prism.systems.SightSystem(),
      prism.systems.FallSystem()
   )

   -- Initialize with the created level and display, the heavy lifting is done by
   -- the parent class.
   self.super.__new(self, builder:build(prism.cells.Wall), display)
end

function GameLevelState:handleMessage(message)
   self.super.handleMessage(self, message)

   -- Handle any messages sent to the level state from the level. LevelState
   -- handles a few built-in messages for you, like the decision you fill out
   -- here.

   -- This is where you'd process custom messages like advancing to the next
   -- level or triggering a game over.
   if prism.messages.LoseMessage:is(message) then
      self.manager:enter(spectrum.gamestates.GameOverState(self.display))
   end

   if prism.messages.DescendMessage:is(message) then
      --- @cast message DescendMessage
      self.manager:enter(
         GameLevelState(
            self.display,
            Game:generateNextFloor(message.descender),
            Game:getLevelSeed()
         )
      )
   end
end

-- updateDecision is called whenever there's an ActionDecision to handle.
function GameLevelState:updateDecision(dt, owner, decision)
   -- Controls need to be updated each frame.
   controls:update()

   -- Controls are accessed directly via table index.
   if controls.move.pressed then
      local destination = owner:getPosition() + controls.move.vector
      local descendTarget =
         self.level:query(prism.components.Stairs):at(destination:decompose()):first()

      local descend = prism.actions.Descend(owner, descendTarget)
      if self:setAction(descend) then return end

      local move = prism.actions.Move(owner, destination)
      if self:setAction(move) then return end

      local openable =
         self.level:query(prism.components.Container):at(destination:decompose()):first()

      local openContainer = prism.actions.OpenContainer(owner, openable)
      if self.level:canPerform(openContainer) then
         self:setAction(openContainer)
         return
      end

      -- stylua: ignore
      local target = self.level
         :query() -- grab a query object
         :at(destination:decompose()) -- restrict the query to the destination
         :first() -- grab one of the kickable things, or nil

      local kick = prism.actions.Kick(owner, target)
      if self:setAction(kick) then return end
   end

   if controls.pickup.pressed then
      local target =
         self.level:query(prism.components.Item):at(owner:getPosition():decompose()):first()

      local pickup = prism.actions.Pickup(owner, target)
      if self:setAction(pickup) then return end
   end

   if controls.inventory.pressed then
      local inventory = owner:get(prism.components.Inventory)
      if inventory then
         local inventoryState =
            spectrum.gamestates.InventoryState(self.display, decision, self.level, inventory)
         self.manager:push(inventoryState)
      end
   end

   if controls.wait.pressed then self:setAction(prism.actions.Wait(owner)) end
end

function GameLevelState:draw()
   self.display:clear()

   local player = self.level:query(prism.components.PlayerController):first()
   if not player then return end

   local position = player:expectPosition()

   local x, y = self.display:getCenterOffset(position:decompose())
   self.display:setCamera(x, y)

   local primary, secondary = self:getSenses()
   -- Render the level using the player’s senses
   self.display:putSenses(primary, secondary, self.level)

   -- custom terminal drawing goes here!

   -- Say hello!
   local health = player:get(prism.components.Health)
   if health then self.display:print(1, 1, "HP: " .. health.hp .. "/" .. health.maxHP) end

   self.display:print(1, 2, "Depth: " .. Game.depth)

   local log = player:get(prism.components.Log)
   if log then
      local offset = 0
      for line in log:iterLast(5) do
         self.display:print(1, self.display.height - offset, line)
         offset = offset + 1
      end
   end

   -- Actually render the terminal out and present it to the screen.
   -- You could use love2d to translate and say center a smaller terminal or
   -- offset it for custom non-terminal UI elements. If you do scale the UI
   -- just remember that display:getCellUnderMouse expects the mouse in the
   -- display's local pixel coordinates
   self.display:draw()

   -- custom love2d drawing goes here!
end

function GameLevelState:resume()
   -- Run senses when we resume from e.g. Geometer.
   self.level:getSystem(prism.systems.SensesSystem):postInitialize(self.level)
end

return GameLevelState
