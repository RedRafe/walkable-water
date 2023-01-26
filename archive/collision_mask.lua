-- filter table
function filter(tableIn, excludeValue)
  local tmp = {}
  for _, tableValue in pairs(tableIn) do
    if tableValue ~= excludeValue then
      table.insert(tmp, tableValue)
    end
  end
  return tmp
end

-- remove collision mask
function removeCollisionMask(source, name, mask)
  if data.raw[source] ~= nil then
    if data.raw[source][name] ~= nil then
      if data.raw[source][name].collision_mask ~= nil then
        data.raw[source][name].collision_mask = filter(data.raw[source][name].collision_mask, mask)
      else
        log("collision_mask of " .. name .. " not found")
      end
      if data.raw[source][name].collision_mask ~= nil then
        log("This collision mask is available")
      end
    else
      log("Entity-name " .. name .. " not found")
    end
  else
    log("Entity " .. source .. " not found")
  end
end

-- set collision mask
function setCollisionMask(source, name, mask)
  if data.raw[source] ~= nil then
    if data.raw[source][name] ~= nil then
      data.raw[source][name].collision_mask = mask
      log(name .. "'s mask changed")
    else
      log("Entity-name " .. name .. " not found")
    end
  else
    log("Entity " .. source .. " not found")
  end
end

-- set collision mask for each element of a table
function setTableCollisionMask(entities)
  for _, entity in pairs(entities) do
    setCollisionMask(entity.source, entity.name, entity.mask)
  end
end

-- set collision mask from data.raw['source']
function setRawCollisionMask(source, mask)
  for _, v in pairs(data.raw[source]) do
    local entity = v.name
    setCollisionMask(source, entity, mask)
  end
end
