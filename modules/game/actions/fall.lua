local Fall = prism.Action:extend "Fall"

--- @param level Level
function Fall:canPerform(level)
   local x, y = self.owner:getPosition():decompose()
   local cell = level:getCell(x, y)

   -- We can only fall on cells that are voids.
   if not cell:has(prism.components.Void) then return false end

   local cellMask = cell:getCollisionMask()
   local mover = self.owner:get(prism.components.Mover)
   if mover then
      -- We have a Void component on the cell. If the actor CAN'T move here
      -- then they fall.
      return not prism.Collision.checkBitmaskOverlap(cellMask, mover.mask)
   end

   return true
end

--- @param level Level
function Fall:perform(level)
   level:removeActor(self.owner) -- into the depths with you!
end

return Fall

