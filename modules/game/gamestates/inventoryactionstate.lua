local controls = require "controls"
local Name = prism.components.Name

--- @class InventoryActionState : GameState
--- @field decision ActionDecision
--- @field previousState GameState
--- @overload fun(display: Display, decision: ActionDecision, level: Level, item: Actor): self
local InventoryActionState = spectrum.GameState:extend "InventoryActionState"

--- @param display Display
--- @param decision ActionDecision
--- @param level Level
--- @param item Actor
function InventoryActionState:__new(display, decision, level, item)
   self.display = display
   self.decision = decision
   self.level = level
   self.item = item

   self.actions = {}

   for _, Action in ipairs(self.decision.actor:getActions()) do
      if Action:validateTarget(1, level, self.decision.actor, item) and not Action:isAbstract() then
         table.insert(self.actions, Action)
      end
   end
end

function InventoryActionState:load(previous)
   --- @cast previous InventoryState
   self.previousState = previous.previousState
end

function InventoryActionState:draw()
   self.previousState:draw()
   self.display:clear()
   self.display:print(1, 1, Name.get(self.item), nil, nil, 2, "right")

   for i, action in ipairs(self.actions) do
      local letter = string.char(96 + i)
      local name = string.gsub(action.name or action.className, "Action", "")
      self.display:print(1, 1 + i, string.format("[%s] %s", letter, name), nil, nil, nil, "right")
   end

   self.display:draw()
end

function InventoryActionState:update(dt)
   controls:update()
   for i, action in ipairs(self.actions) do
      if spectrum.Input.key[string.char(i + 96)].pressed then
         if self.decision:setAction(action(self.decision.actor, self.item), self.level) then
            self.manager:pop()
            return
         end

         self.selectedAction = action
         self.targets = { self.item }
         print(action.className)
         for i = action:getNumTargets(), 2, -1 do
            self.manager:push(
               spectrum.gamestates.GeneralTargetHandler(
                  self.display,
                  self.previousState,
                  self.targets,
                  action:getTarget(i),
                  self.targets
               )
            )
         end
      end
   end

   if controls.inventory.pressed or controls["return"].pressed then self.manager:pop() end
end

function InventoryActionState:resume()
   if self.targets then
      local action = self.selectedAction(self.decision.actor, unpack(self.targets))
      local success, err = self.level:canPerform(action)
      if success then
         self.decision:setAction(action, self.level)
      else
         prism.components.Log.addMessage(self.decision.actor, err)
      end

      self.manager:pop()
   end
end

return InventoryActionState
