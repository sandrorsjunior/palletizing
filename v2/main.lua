--Lib
local inspect = require("libs.inspect")
---

require("controller")
require("setting")


local pick_position = get_pick_position(0)

print(inspect(pick_position))




