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

-- @ parent: String
local function isParentValid(parent)
  return (data.raw[parent] ~= nil)
end

-- @ parent children: String
local function isChildrenValid(parent, children)
  return (data.raw[parent][children] ~= nil)
end

-- @ method: Function of [1-2] args
-- @ parent: String
-- @ (optional) args: any, nil
local function applyToChildren(method, parent, args)
  if not isParentValid(parent) then
    wb.debug.log("Error: ".. parent .. " not found as source")
    return
  end
  if args ~= nil then
    for ___, children in pairs(data.raw[parent]) do
      if children ~= nil then
        method(children, args)
      end
    end
  else
    for ___, children in pairs(data.raw[parent]) do
      if children ~= nil then
        method(children)
      end
    end
  end
end

-- @ method: Function of [1-2] args
-- @ parent: String
-- @ filterTable: Table<String>
-- @ (optional) args: any, nil
local function applyToFilteredChildren(method, parent, filterTable, args)
  if not isParentValid(parent) then
    wb.debug.log("Error: " .. " not found as source")
    return
  end
  if args ~= nil then
    for ___, children in pairs(data.raw[parent]) do
      if (children ~= nil) and (tableContains(filterTable, children.name)) then
        method(children, args)
      end
    end
  else
    for ___, children in pairs(data.raw[parent]) do
      if (children ~= nil) and (tableContains(filterTable, children.name)) then
        method(children)
      end
    end
  end
end

-- @ key: String
local function getStartupSettingByKey(key)
  return settings.startup[key].value
end

------------

if not ww.data_util then ww.data_util = {} end

ww.data_util.getStartupSettingByKey = getStartupSettingByKey
ww.data_util.applyToChildren = applyToChildren
ww.data_util.applyToFilteredChildren = applyToFilteredChildren
