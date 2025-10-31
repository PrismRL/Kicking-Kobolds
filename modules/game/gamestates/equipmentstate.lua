local controls = require "controls"

--- @class EquipmentState : GameState
--- @field previousState GameState
--- @overload fun(display: Display, decision: ActionDecision, level: Level, equipper: Equipper): self
local EquipmentState = spectrum.GameState:extend "EquipmentState"

--- @param display Display
--- @param decision ActionDecision
--- @param level Level
--- @param equipper Equipper
function EquipmentState:__new(display, decision, level, equipper)
   self.display  = display
   self.decision = decision
   self.level    = level
   self.equipper = equipper

   self.entries = {}
   self.letters = {}

   for i, slot in ipairs(equipper.slots or {}) do
      self.entries[i] = {
         slot  = slot,
         actor = equipper.equipped[i],
      }
      self.letters[i] = string.char(96 + i) -- a, b, c, ...
   end
end

function EquipmentState:load(previous)
   self.previousState = previous
end

function EquipmentState:draw()
   self.previousState:draw()
   self.display:clear()
   self.display:print(self.display.width - 28, 1, "Equipment", nil, nil, 2)

   for i, entry in ipairs(self.entries) do
      local letter = self.letters[i]
      local slot   = entry.slot
      local name   = entry.actor and prism.components.Name.get(entry.actor) or "(empty)"
      local line   = ("[%s] %s - %s"):format(letter, slot, name)
      self.display:print(self.display.width - 28, 1 + i, line, nil, nil, 2)
      if entry.actor then
         local drawable = entry.actor:get(prism.components.Drawable)
         if drawable then
            self.display:putDrawable(self.display.width - 28 + #line, 1 + i, drawable)
         end
      end
   end

   self.display:draw()
end

function EquipmentState:update(dt)
   controls:update()

   for i, letter in ipairs(self.letters) do
      if spectrum.Input.key[letter].pressed then
         self.decision:setAction(prism.actions.Unequip(self.decision.actor, self.entries[i].actor), self.level)
         self.manager:pop()
      end
   end


   -- No equipment interaction yet—just allow closing
   if controls.equipment.pressed or controls["return"].pressed then
      self.manager:pop()
      return
   end
end

function EquipmentState:resume()
   if self.decision and self.decision.validateResponse and self.decision:validateResponse() then
      self.manager:pop()
   end
end

return EquipmentState
