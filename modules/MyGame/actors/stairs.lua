prism.registerActor("Stairs", function()
   return prism.Actor.fromComponents {
      prism.components.Position(),
      prism.components.Drawable("<"),
      prism.components.Stair(),
      prism.components.Remembered(),
   }
end)
