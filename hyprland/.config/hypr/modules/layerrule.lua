-- Named layer rule
local swaync_blur = hl.layer_rule({
  name      = "swaync blur",
  match     = { namespace = "swaync-control-center" },
  blur = true,
  ignore_alpha = 0.5,
  no_anim   = true,
})

-- Enable blur and ignore_alpha for rofi
hl.layer_rule({
  match        = { namespace = "rofi" },
  blur         = true,
 ignore_alpha = 0.1,
})

-- Named layer rule for wlogout
local wlogout_blur = hl.layer_rule({
  name         = "wlogout blur",
  match        = { namespace = "logout_dialog" },
  blur         = true,
  ignore_alpha = 0.0,
  no_anim      = true,
})
