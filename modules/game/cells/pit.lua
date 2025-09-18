prism.registerCell("Pit", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Pit"),
      prism.components.Drawable { index = " " },
      prism.components.Collider({ allowedMovetypes = { "fly" } }),
      prism.components.Void(),
   }
end)
