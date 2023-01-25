if not ww.debug then ww.debug = {} end
ww.debug.state = false

local function print_debug_message(message)
  if ww.debug.state == true then
    log(message)
  end
end

ww.debug.log = print_debug_message