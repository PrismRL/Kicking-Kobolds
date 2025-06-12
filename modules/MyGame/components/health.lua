   --- @class Health : Component
   --- @field maxHP integer
   --- @field hp integer
   --- @overload fun(maxHP: integer)
   local Health = prism.Component:extend("Health")

   --- @param maxHP integer
   function Health:__new(maxHP)
      self.maxHP = maxHP
      self.hp = maxHP
   end

   return Health