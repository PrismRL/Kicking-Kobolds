prism.registerActor("MeatBrick", function()
   return prism.Actor.fromComponents {
      prism.components.Position(),
      prism.components.Name("Meat Brick"),
      prism.components.Drawable { index = "%", color = prism.Color4.RED },
      prism.components.Item {
         stackable = "MeatBrick",
         stackLimit = 99,
      },
      prism.components.Edible(1),
   }
end)
