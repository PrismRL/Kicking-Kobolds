prism.registerActor("RingofVitality", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Ring of Vitality"),
      prism.components.Drawable {
         index = "o",
         color = prism.Color4.YELLOW,
      },
      prism.components.Item(),
      prism.components.Equipment(
         { "ring", "ring" },
         prism.condition.Condition(prism.modifiers.HealthModifier(5))
      ),
      prism.components.Position(),
   }
end)
