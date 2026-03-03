--Lib
local inspect = require("libs.inspect")
---

require("controller")
require("setting")


local pick_position = get_pick_position((math.pi)/2)

print(inspect(pick_position))




