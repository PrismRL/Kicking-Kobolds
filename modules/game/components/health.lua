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

   --- @param amount integer
   function Health:heal(amount)
      self.hp = math.min(self.hp + amount, self.maxHP)
   end

   return Health