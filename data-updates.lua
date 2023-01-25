require("collision_mask")

ww = {}

ww.enable_player  = settings.startup["ww-enable-player"].value
ww.enable_unit    = settings.startup["ww-enable-unit"].value
ww.enable_spawner = settings.startup["ww-enable-spawner"].value

--if ww.enable_spawner then
--  ww.enable_unit = true
--end

local collision_mask_util = require("collision-mask-util")
ww.fist_unused_layer = collision_mask_util.get_first_unused_layer()

ww.tiles = {"water", "water-green", "deepwater", "deepwater-green", "water-wube"}

ww.collision_masks = {
  ["water"] = {
    "water-tile",
    "resource-layer",
    "item-layer",
    --"player-layer",
    "doodad-layer"
  },
  ["character"] = {
    "player-layer",
    "train-layer",
    "consider-tile-transitions"
  },
  ["unit"] = {
    "player-layer",
    "train-layer",
    "not-colliding-with-itself"
  },
  ["spawner"] = {
    "item-layer",
    "object-layer",
    "player-layer",
    "water-tile"
  }
}

-- any of the conditions must be true
if (ww.enable_player or ww.enable_unit or ww.enable_spawners) then

  -- -- set masks
  -- water
  table.insert(ww.collision_masks.water, ww.fist_unused_layer)

  -- character
  if not ww.enable_player then
    table.insert(ww.collision_masks.character, ww.fist_unused_layer)
  end

  -- unit
  if not ww.enable_unit then
    table.insert(ww.collision_masks.unit, ww.fist_unused_layer)
  end

  -- spawner
  if ww.enable_spawner then
    ww.collision_masks.spawner = { "object-layer", "player-layer" }
  end

  -- -- apply masks
  -- water
  for _, tileName in pairs(ww.tiles) do
    setCollisionMask("tile", tileName, ww.collision_masks.water)
  end

  -- character
  if data.raw.character.character.collision_mask then
    collision_mask_util.add_layer(data.raw.character.character.collision_mask, ww.fist_unused_layer)
  else
    setCollisionMask("character", "character", ww.collision_masks.character)
  end

  -- unit
  setRawCollisionMask("unit", ww.collision_masks.unit)

  -- spawner & worms
  setRawCollisionMask("unit-spawner", ww.collision_masks.spawner)
  setRawCollisionMask("turret", ww.collision_masks.spawner)
end