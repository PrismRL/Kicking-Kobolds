prism.registerActor("Player", function()
   return prism.Actor.fromComponents {
      prism.components.Position(),
      prism.components.Drawable { index = "@", color = prism.Color4.BLUE },
      prism.components.Collider(),
      prism.components.PlayerController(),
      prism.components.Senses(),
      prism.components.Sight { range = 12, fov = true },
      prism.components.Mover { "walk" },
      prism.components.Health(10),
      prism.components.Log(),
      prism.components.Inventory {
         limitCount = 26,
      },
      prism.components.ConditionHolder(),
      prism.components.Equipper{
         "head",
         "cape",
         "chest",
         "pants",
         "boots",
         "gloves",
         "ring",
         "ring",
         "necklace"
      }
   }
end)
