local CollisionMaskUtil = require("collision-mask-util")

-- @ tableIn: Table
-- @ element: any
local function tableContains(tableIn, element)
  for ___, value in pairs(tableIn) do
    if value == element then
      return true
    end
  end
  return false
end

-- @ tableIn: Table
-- @ element: any
local function tableFind(tableIn, element)
  for key, value in pairs(tableIn) do
    if value == element then
      return key
    end
  end
  return nil
end

-- @ tableIn1, tableIn2: Table
local function tableMerge(tableIn1, tableIn2)
  for key, value in pairs(tableIn2) do 
    tableIn1[key] = value
  end
  return tableIn2
end

-- @ tableIn: Table
-- @ element: any
local function tableFilterElement(tableIn, element)
  local tableOut = {}
  for ___, value in pairs(tableIn) do
    if value ~= element then
      table.insert(tableOut, value)
    end
  end
  return tableOut
end

-- @ tableIn, elements: Table
local function tableFilterElements(tableIn, elements)
  for ___, element in pairs(elements) do
    tableFilterElement(tab, element)
  end
end

-- @ tableIn: Table
-- @ element: any
local function tableRemoveElement(tableIn, element)
  local index = tableFind(tableIn, element)
  if index ~= nil then
    table.remove(tableIn, index)
  end
end

-- @ tableIn, tableToExclude: Table
local function tableRemoveElements(tableIn, tableToExclude)
  for ___, element in pairs(tableToExclude) do
    tableRemoveElement(tableIn, element)
  end
end


------------

-- @ layer: String
local function checkLayer(layer)
  if layer == nil then wb.debug.log("Attempt to assign empty layer") end
end

-- @ entity: PrototypeEntity
local function hasCollisionMask(entity)
  return (entity.collision_mask ~= nil)
end

-- @ entity: PrototypeEntity
local function createCollisionMask(entity)
  entity.collision_mask = CollisionMaskUtil.get_mask(entity) or {}
end

-- @ entity: PrototypeEntity
local function guaranteeCollisionMask(entity)
  if not hasCollisionMask(entity) then createCollisionMask(entity) end
end

-- @ entity: PrototypeEntity
local function getCollisionMask(entity)
  guaranteeCollisionMask(entity)
  return entity.collision_mask
end

-- @ entity: PrototypeEntity
-- @ mask: Table<String>
local function setCollisionMask(entity, mask)
  entity.collision_mask = mask
end

-- @ entity: PrototypeEntity
local function removeCollisionMask(entity)
  entity.collision_mask = {}
end

-- @ entity: PrototypeEntity
-- @ layer: String
local function isLayerInCollisionMask(entity, layer)
  checkLayer(layer)
  guaranteeCollisionMask(entity)
  return tableContains(entity.collision_mask, layer)
end

-- @ entity: PrototypeEntity
-- @ layers: Table<String>
local function anyLayerInCollisionMask(entity, layers)
  guaranteeCollisionMask(entity)
  local ans = false
  for ___, layer in pairs(layers) do
    ans = (ans or isLayerInCollisionMask(entity, layer))
  end
  return ans
end

-- @ entity: PrototypeEntity
-- @ layers: Table<String>
local function eachLayerInCollisionMask(entity, layers)
  guaranteeCollisionMask(entity)
  local ans = true
  for ___, layer in pairs(layers) do
    ans = (ans and isLayerInCollisionMask(entity, layer))
  end
  return ans
end

-- @ entity: PrototypeEntity
-- @ layer: String
local function addLayerToCollisionMask(entity, layer)
  checkLayer(layer)
  guaranteeCollisionMask(entity)
  if not isLayerInCollisionMask(entity, layer) then
    table.insert(entity.collision_mask, layer)
  end
end

-- @ entity: PrototypeEntity
-- @ layers: Table<String>
local function addLayersToCollisionMask(entity, layers)
  for ___, layer in pairs(layers) do
    addLayerToCollisionMask(entity, layer)
  end
end

-- @ entity: PrototypeEntity
-- @ layer: String
local function removeLayerFromCollisionMask(entity, layer)
  checkLayer(layer)
  guaranteeCollisionMask(entity)
  if isLayerInCollisionMask(entity, layer) then
    tableRemoveElement(entity.collision_mask, layer)
  end
end

-- @ entity: PrototypeEntity
-- @ layers: Table<String>
local function removeLayersFromCollisionMask(entity, layers)
  for ___, layer in pairs(layers) do
    removeLayerFromCollisionMask(entity, layer)
  end
end

-- @ entity: PrototypeEntity
-- @ layer: String
local function setLayerOfCollisionMask(entity, layer)
  checkLayer(layer)
  setCollisionMask(entity, {layer})
end

-- @ entity: PrototypeEntity
-- @ layer: String
local function replaceLayerOfCollisionMask(entity, layerOld, layerNew)
  checkLayer(layerOld)
  checkLayer(layerNew)
  guaranteeCollisionMask(entity)
  removeLayerFromCollisionMask(entity, layerOld)
  addLayerToCollisionMask(entity, layerNew)
end

-- @ entity: PrototypeEntity
-- @ layers: Table<String>
local function replaceLayersOfCollisionMask(entity, layers)
  for ___, layer in pairs(layers) do
      replaceLayerOfCollisionMask(entity, layer)
  end
end


-- @ entity: PrototypeEntity
-- @ layers: Table<String>
-- XOR between collision_mask and Table<layers>,
-- if layer is present in the collision_mask
-- removes the layer, otherwise adds it
local function layers_XOR_collisionMask(entity, layers)
  guaranteeCollisionMask(entity)
  for ___, layer in pairs(layers) do
    if isLayerInCollisionMask(entity, layer) then
      removeLayerFromCollisionMask(entity, layer)
    else
      addLayerToCollisionMask(entity, layer)
    end
  end
end

------------

if not ww.mask_util then ww.mask_util = {} end

ww.mask_util.checkLayer                     = checkLayer
ww.mask_util.tableContains                  = tableContains
ww.mask_util.tableFind                      = tableFind
ww.mask_util.tableMerge                     = tableMerge
ww.mask_util.tableFilterElement             = tableFilterElement
ww.mask_util.tableFilterElements            = tableFilterElements
ww.mask_util.tableRemoveElement             = tableRemoveElement
ww.mask_util.tableRemoveElements            = tableRemoveElements
ww.mask_util.hasCollisionMask               = hasCollisionMask
ww.mask_util.createCollisionMask            = createCollisionMask
ww.mask_util.getCollisionMask               = getCollisionMask
ww.mask_util.setCollisionMask               = setCollisionMask
ww.mask_util.removeCollisionMask            = removeCollisionMask
ww.mask_util.isLayerInCollisionMask         = isLayerInCollisionMask
ww.mask_util.anyLayerInCollisionMask        = anyLayerInCollisionMask
ww.mask_util.eachLayerInCollisionMask       = eachLayerInCollisionMask
ww.mask_util.addLayerToCollisionMask        = addLayerToCollisionMask
ww.mask_util.addLayersToCollisionMask       = addLayersToCollisionMask
ww.mask_util.removeLayerFromCollisionMask   = removeLayerFromCollisionMask
ww.mask_util.removeLayersFromCollisionMask  = removeLayersFromCollisionMask
ww.mask_util.setLayerOfCollisionMask        = setLayerOfCollisionMask
ww.mask_util.replaceLayerOfCollisionMask    = replaceLayerOfCollisionMask
ww.mask_util.replaceLayersOfCollisionMask   = replaceLayersOfCollisionMask
ww.mask_util.exclusiveLayersOrCollisionMask = layers_XOR_collisionMask
