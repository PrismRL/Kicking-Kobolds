prism.registerActor("Player", function()
   return prism.Actor.fromComponents {
      prism.components.Position(),
      prism.components.Drawable("@", prism.Color4.GREEN),
      prism.components.Collider(),
      prism.components.PlayerController(),
      prism.components.Senses(),
      prism.components.Sight { range = 12, fov = true },
      prism.components.Mover { "walk" },
      prism.components.Health(10),
      prism.components.Log(),
   }
end)
