---------------------------------------------------------------------------
-- -- -- INITIALIZATION
---------------------------------------------------------------------------
-- Mod Info
ww                               = {} 
ww.internal_name                 = "walkable-water"
ww.title_name                    = "Walkable Water"
ww.base                          = "__walkable-water__/"
ww.stage                         = "data"

-- Modules
require(ww.base     .. "lib/paths")
require(ww_path_lib .. "debugger")
require(ww_path_lib .. "data-util")
require(ww_path_lib .. "mask-util")