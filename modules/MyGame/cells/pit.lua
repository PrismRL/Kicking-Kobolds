prism.registerCell("Pit", function()
   return prism.Cell.fromComponents {
      prism.components.Drawable(" ", nil, prism.Color4.WHITE * 0.25),
      prism.components.Collider({ allowedMovetypes = { "fly" } }),
      prism.components.Void()
   }
end)
