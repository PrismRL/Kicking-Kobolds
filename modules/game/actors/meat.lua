prism.registerActor("MeatBrick", function ()
   return prism.Actor.fromComponents{
      prism.components.Name("Meat Brick"),
      prism.components.Drawable("%", prism.Color4.RED),
      prism.components.Item{
         stackable = true,
         stackLimit = 99
      }
   }
end)