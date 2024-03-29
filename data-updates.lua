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
    -- Character
    applyToEntity(
      mu.addLayerToCollisionMask,
      "character",
      firstUnUsedLayer
    )
    -- Spidertrons
    applyToEntity(
      mu.addLayerToCollisionMask,
      "spider-leg",
      firstUnUsedLayer
    )
    -- Cars & Tanks
    local vehicles = du.getChildren("car")
    if mods["aai-vehicles-ironclad"] then 
      du.tableRemove(vehicles, "ironclad") 
    end
    if mods["ironclad-gunboat-and-mortar-turret"] then
      du.tableRemove(vehicles, "ironclad-gunboat")
    end
    if mods["Hovercrafts"] then 
      du.tableRemove(vehicles, "hcraft-entity")
      du.tableRemove(vehicles, "mcraft-entity")    
      du.tableRemove(vehicles, "ecraft-entity")
      du.tableRemove(vehicles, "lcraft-entity")
    end
    applyToFiltEntity(
      mu.addLayerToCollisionMask,
      "car",
      vehicles,
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
end