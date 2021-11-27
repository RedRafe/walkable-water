data:extend({
  {
    type          = "bool-setting",
    name          = "ww-enable-player",
    default_value = true,
    setting_type  = "startup",
    order         = "ww-010"
  },
  {
    type          = "bool-setting",
    name          = "ww-enable-unit",
    default_value = true,
    setting_type  = "startup",
    order         = "ww-020"
  },
  {
    type          = "bool-setting",
    name          = "ww-enable-spawner",
    default_value = false,
    setting_type  = "startup",
    order         = "ww-030"
  }
})