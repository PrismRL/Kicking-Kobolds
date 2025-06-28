local Fall = prism.Action:extend "Fall"

--- @param level Level
function Fall:canPerform(level)
   local x, y = self.owner:getPosition():decompose()
   local cell = level:getCell(x, y)

   -- We can only fall on cells that are voids.
   if not cell:has(prism.components.Void) then return false end

   local cellMask = cell:getCollisionMask()
   local mover = self.owner:get(prism.components.Mover)
   local mask = mover and mover.mask or 0 -- default to the immovable mask

   -- We have a Void component on the cell. If the actor CAN'T move here
   -- then they fall.
   return not prism.Collision.checkBitmaskOverlap(cellMask, mask)
end

--- @param level Level
function Fall:perform(level)
   level:perform(prism.actions.Die(self.owner))
end

return Fall