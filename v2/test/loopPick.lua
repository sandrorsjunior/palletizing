--Lib
local inspect = require("..libs.inspect")
---

require("..controller")
require("..setting")

local pick_position = nil

while current_layer > 0 do
    local pick_position = get_pick_position((math.pi)/2)
    print(inspect(pick_position))
    update_counters()
end