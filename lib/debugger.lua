if not ww.debug then ww.debug = {} end
ww.debug.state = false

local function print_debug_message(message)
  if ww.debug.state == true then
    log(message)
  end
end

local function serpent(table)
  if ww.debug.state == true then
    log(serpent.block(table))
  end
end

ww.debug.log = print_debug_message