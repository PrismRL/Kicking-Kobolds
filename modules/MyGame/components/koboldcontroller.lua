--- @class KoboldController : Controller
--- @overload fun(): KoboldController
local KoboldController = prism.components.Controller:extend("KoboldController")
KoboldController.name = "KoboldController"

function KoboldController:act(level, actor)
   local senses = actor:get(prism.components.Senses)
   if not senses then return prism.actions.Wait() end -- we can't see!

   local player = senses:query(prism.components.PlayerController):first()
   if not player then return prism.actions.Wait() end -- no player nearby!

   local mover = actor:get(prism.components.Mover)
   if not mover then return prism.actions.Wait() end -- we can't move!

   local path = level:findPath(actor:getPosition(), player:getPosition(), actor, mover.mask, 1)

   if path then
      local move = prism.actions.Move(actor, path:pop())
      if level:canPerform(move) then
         return move
      end
   end

   return prism.actions.Wait(actor)
end

return KoboldController