local controls = require "controls"
local Name = prism.components.Name

--- @class GeneralTargetHandler : TargetHandler
--- @field selectorPosition Vector2
local GeneralTargetHandler = spectrum.gamestates.TargetHandler:extend("GeneralTargetHandler")

function GeneralTargetHandler:init()
   self.super.init(self)
   self.curTarget = self.validTargets[1]
   self:setSelectorPosition()
end

function GeneralTargetHandler:getValidTargets()
   local valid = {}

   for foundTarget in
      self.level:query():target(self.target, self.level, self.owner, self.targetList):iter()
   do
      table.insert(valid, foundTarget)
   end

   if not (self.target.type and self.target.type ~= prism.Vector2) then
      for x, y in self.level.map:each() do
         local vec = prism.Vector2(x, y)
         if self.target:validate(self.level, self.owner, vec, self.targetList) then
            table.insert(valid, vec)
         end
      end
   end

   return valid
end

function GeneralTargetHandler:setSelectorPosition()
   if prism.Vector2.is(self.curTarget) then
      self.selectorPosition = self.curTarget
   elseif self.curTarget then
      self.selectorPosition = self.curTarget:getPosition()
   end
end

function GeneralTargetHandler:draw()
   local cameraPos = self.selectorPosition

   self.display:clear()
   -- set the camera position on the display
   local ox, oy = self.display:getCenterOffset(cameraPos:decompose())
   self.display:setCamera(ox, oy)

   -- draw the level
   local primary, secondary = self.levelState:getSenses()
   self.display:putSenses(primary, secondary, self.level)

   -- put a string to let the player know what's happening
   self.display:print(1, 1, "Select a target!")
   self.display:print(
      self.selectorPosition.x + ox,
      self.selectorPosition.y + oy,
      "X",
      prism.Color4.RED
   )

   -- if there's a target then we should draw it's name!
   if self.curTarget then
      local x, y = cameraPos:decompose()
      self.display:print(x + ox + 1, y + oy, Name.get(self.curTarget))
   end
   self.display:draw()
end

function GeneralTargetHandler:update(dt)
   controls:update()

   if controls.tab.pressed then
      local lastTarget = self.curTarget
      self.index, self.curTarget = next(self.validTargets, self.index)

      while
         (not self.index and #self.validTargets > 0)
         or (lastTarget == self.curTarget and #self.validTargets > 1)
      do
         self.index, self.curTarget = next(self.validTargets, self.index)
      end

      self:setSelectorPosition()
   end

   if controls.select.pressed and self.curTarget then
      table.insert(self.targetList, self.curTarget)
      self.manager:pop()
   end

   if controls["return"].pressed then self.manager:pop("pop") end

   if controls.move.pressed then
      self.selectorPosition = self.selectorPosition + controls.move.vector
      self.curTarget = nil

      if self.target:validate(self.level, self.owner, self.selectorPosition, self.targetList) then
         self.curTarget = self.selectorPosition
      end

      local validTarget = self.level
         :query()
         :at(self.selectorPosition:decompose())
         :target(self.target, self.level, self.owner, self.targetList)
         :first()

      if validTarget then self.curTarget = validTarget end
   end
end

return GeneralTargetHandler
