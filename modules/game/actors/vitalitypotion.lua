prism.registerActor("VitalityPotion", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Potion of Vitality"),
      prism.components.Drawable { index = "!", color = prism.Color4.RED },
      prism.components.Item { stackable = "VitalityPotion", stackLimit = 5 },
      prism.components.Drinkable {
         healing = 5,
         condition = prism.conditions.TickedCondition(10, prism.modifiers.HealthModifier(5)),
      },
      prism.components.Position(),
   }
end)
