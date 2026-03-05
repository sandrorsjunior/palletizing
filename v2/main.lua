--Lib
local inspect = require("libs.inspect")
---

require("controller")
require("setting")


--goToHome()

-- get the first box position in order to perform pick up
local box_angle_pick = 0
local box_angle_drop = (math.pi)/2
local pick_position = get_position("pick", box_angle_pick)

-- get the position of approach to pick
local approach_point = get_approach("pink", pick_position, box_angle_pick, 1.2)


print("Ange:")
print(math.deg(box_angle_pick))
print("pick_position:")
print(inspect(pick_position))
print("approach_point")
print(inspect(approach_point))

