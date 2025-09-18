prism.registerActor("Stairs", function()
   return prism.Actor.fromComponents {
      prism.components.Position(),
      prism.components.Stair(),
      prism.components.Remembered(),
      prism.components.Drawable({ index = ">" }),
   }
end)
