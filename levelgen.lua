local PARTITIONS = 3

--- @param rng RNG
--- @param player Actor
--- @param width integer
--- @param height integer
return function(rng, player, width, height)
   local builder = prism.MapBuilder(prism.cells.Wall)

   -- Fill the map with random noise of pits and walls.
   local nox, noy = rng:getUniformInt(1, 10000), rng:getUniformInt(1, 10000)
   for x = 1, width do
      for y = 1, height do
         local noise = love.math.perlinNoise(x / 5 + nox, y / 5 + noy)
         local cell = noise > 0.5 and prism.cells.Wall or prism.cells.Pit
         builder:set(x, y, cell())
      end
   end

   -- Create rooms in each of the partitions.
   --- @type table<number, Rectangle>
   local rooms = {}

   local missing = prism.Vector2(rng:getUniformInt(0, PARTITIONS - 1), rng:getUniformInt(0, PARTITIONS - 1))
   local pw, ph = math.floor(width / PARTITIONS), math.floor(height / PARTITIONS)
   local minrw, minrh = math.floor(pw / 3), math.floor(ph / 3)
   local maxrw, maxrh = pw - 2, ph - 2 -- Subtract 2 to ensure there's a margin.
   for px = 0, PARTITIONS - 1 do
      for py = 0, PARTITIONS - 1 do
         if missing ~= prism.Vector2(px, py) then
            local rw, rh = rng:getUniformInt(minrw, maxrw), rng:getUniformInt(minrh, maxrh)
            local x = rng:getUniformInt(px * pw + 1, (px + 1) * pw - rw - 1)
            local y = rng:getUniformInt(py * ph + 1, (py + 1) * ph - rh - 1)

            local roomRect = prism.Rectangle(x, y, rw, rh)
            rooms[prism.Vector2._hash(px, py)] = roomRect

            builder:drawRectangle(x, y, x + rw, y + rh, prism.cells.Floor)
         end
      end
   end

   -- Helper function to connect two points with an L-shaped hallway.
   --- @param a Rectangle
   --- @param b Rectangle
   local function createLShapedHallway(a, b)
      if not a or not b then return end

      local ax, ay = a:center():floor():decompose()
      local bx, by = b:center():floor():decompose()
      -- Randomly choose one of two L-shaped tunnel patterns for variety.
      if rng:getUniform() > 0.5 then
         builder:drawLine(ax, ay, bx, ay, prism.cells.Floor)
         builder:drawLine(bx, ay, bx, by, prism.cells.Floor)
      else
         builder:drawLine(ax, ay, ax, by, prism.cells.Floor)
         builder:drawLine(ax, by, bx, by, prism.cells.Floor)
      end
   end

   for hash, currentRoom in pairs(rooms) do
      local px, py = prism.Vector2._unhash(hash)

      createLShapedHallway(currentRoom, rooms[prism.Vector2._hash(px + 1, py)])
      createLShapedHallway(currentRoom, rooms[prism.Vector2._hash(px, py + 1)])
   end

   -- Choose the first room (top-left partition) to place the player.
   local startRoom
   while not startRoom do
      local x, y = rng:getUniformInt(0, PARTITIONS - 1), rng:getUniformInt(0, PARTITIONS - 1)
      startRoom = rooms[prism.Vector2._hash(x, y)]
   end

   local playerPos = startRoom:center():floor()

   for _, room in pairs(rooms) do
      if room ~= startRoom then
         local cx, cy = room:center():floor():decompose()

         builder:addActor(prism.actors.Kobold(), cx, cy)
      end
   end

   builder:addActor(player, playerPos.x, playerPos.y)
   builder:addPadding(1, prism.cells.Wall)

   return builder
end