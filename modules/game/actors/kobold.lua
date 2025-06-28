prism.registerActor("Kobold", function()
   return prism.Actor.fromComponents {
      prism.components.Position(),
      prism.components.Collider(),
      prism.components.Drawable("k", prism.Color4.RED),
      prism.components.Senses(),
      prism.components.Sight{ range = 12, fov = true },
      prism.components.Mover{ "walk" },
      prism.components.KoboldController(),
      prism.components.Health(3)
   }
end)
