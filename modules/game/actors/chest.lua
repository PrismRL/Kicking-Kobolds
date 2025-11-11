prism.registerActor("Chest", function(contents)
   local inventory = prism.components.Inventory()
   local chest = prism.Actor.fromComponents {
      prism.components.Name("Chest"),
      prism.components.Position(),
      prism.components.Drawable { index = "(", color = prism.Color4.YELLOW },
      inventory,
      prism.components.Container(),
      prism.components.Collider(),
   }
   inventory:addItems(contents or {})

   return chest
end)
