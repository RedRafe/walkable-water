---------------------------------------------------------------------------
-- -- Function import
---------------------------------------------------------------------------

local CollisionMaskUtil = require("collision-mask-util")
local insert = table.insert
local mu = ww.mask_util
local du = ww.data_util
local startup           = du.getStartupSettingByKey
local applyToEntity     = du.applyToChildren
local applyToFiltEntity = du.applyToFilteredChildren

---------------------------------------------------------------------------

local water_tiles = {"water", "water-green", "deepwater", "deepwater-green", "water-wube"}
--TODO: check alien biomes compatibility

---------------------------------------------------------------------------
-- -- Load sartup settings
---------------------------------------------------------------------------
--["water"] = { "water-tile", "resource-layer", "item-layer", "player-layer", "doodad-layer" },
--["character"] = {"player-layer", "train-layer", "consider-tile-transitions"},
--["unit-spawner"] = {"item-layer", "object-layer", "player-layer", "water-tile"},
--["unit"] = {"player-layer", "train-layer", "not-colliding-with-itself"},


local player  = startup("ww-enable-player")
local spawner = startup("ww-enable-spawner")
local unit    = startup("ww-enable-unit")

if (player or spawner or unit) then
  -- Get 1st unused layer
  local firstUnUsedLayer = CollisionMaskUtil.get_first_unused_layer()
  ww.debug.log("First layer: " .. firstUnUsedLayer)

  -- Add layer to Water tiles
  applyToFiltEntity(
    mu.addLayerToCollisionMask,
    "tile",
    water_tiles,
    firstUnUsedLayer
  )
  -- & remove player layer
  applyToFiltEntity(
    mu.removeLayerFromCollisionMask,
    "tile",
    water_tiles,
    "player-layer"
  )

  -- Add new dummy "player-layer" AKA 1st Unused to entities not selected
  if not character then
    applyToEntity(
      mu.addLayerToCollisionMask,
      "character",
      firstUnUsedLayer
    )
  end

  if not spawner then
    applyToEntity(
      mu.addLayerToCollisionMask,
      "unit-spawner",
      firstUnUsedLayer
    )
    applyToEntity(
      mu.addLayerToCollisionMask,
      "turret",
      firstUnUsedLayer
    )
  else
    applyToEntity(
      mu.removeLayersFromCollisionMask,
      "unit-spawner",
      {
        "item-layer",
        "water-tile"
      }
    )
    applyToEntity(
      mu.removeLayersFromCollisionMask,
      "turret",
      {
        "item-layer",
        "water-tile"
      }
    )
  end

  if not unit then
    applyToEntity(
      mu.addLayerToCollisionMask,
      "unit",
      firstUnUsedLayer
    )
  end

  for ___, v in pairs(data.raw["unit-spawner"]) do
    log("-- " .. v.name)
    log(serpent.block(v.collision_mask))
  end
  for ___, v in pairs(data.raw["unit-spawner"]) do
    log("-- " .. v.name)
    log(serpent.block(v.collision_mask))
  end
  for ___, v in pairs(data.raw["unit"]) do
    log("-- " .. v.name)
    log(serpent.block(v.collision_mask))
  end
  for ___, v in pairs(data.raw["character"]) do
    log("-- " .. v.name)
    log(serpent.block(v.collision_mask))
  end
  for ___, v in pairs(water_tiles) do
    log("-- " .. v)
    log(serpent.block(data.raw.tile[v].collision_mask))
  end
end