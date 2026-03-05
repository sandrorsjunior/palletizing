--Lib
local inspect = require("libs.inspect")
---

require("controller")
require("setting")


--goToHome()

-- get the first box position in order to perform pick up
local box_angle_pick = 0
local box_angle_drop = 0

direction = "pr"
local pick_position = get_position("pick", box_angle_pick)
-- get the position of approach to pick
local approach_pick_point = get_approach(pick_position, box_angle_pick, {factorX = 1.1, factorY=1, factorZ=1.1})
-- get the position over correct position but add few height
local approach_pick_soft =  get_approach_soft(pick_position, 2)

direction = "pl"
local drop_position = get_position("drop", box_angle_drop)
-- get the position of approach to pick
local approach_drop_point = get_approach(drop_position, box_angle_drop, {factorX = 1.1, factorY=1, factorZ=1.1})
-- get the position over correct position but add few height
local approach_drop_soft =  get_approach_soft(drop_position, 2)

--[[
print("Ange:")
print(math.deg(box_angle_pick))
print("pick_position:")
print(inspect(pick_position))
print("approach_pick_point:")
print(inspect(approach_pick_point))
print("approach_pick_soft:")
print(inspect(approach_pick_soft))
]]

------> PICK


MovJ({pose=home_pos["pose"]}, {user=0, tool=4, a = 10, v = 10})

MovJ({pose=approach_pick_point["pose"]}, {user=7, tool=4, a = 10, v = 10})

MovJ({pose=approach_pick_soft["pose"]}, {user = 7, tool=4, a = 10, v = 10})

MovL({pose=pick_position["pose"]}, {user = 7, tool = 4, a = 10, v = 10 })

DO(14, ON)

MovL({pose=approach_pick_soft["pose"]}, {user = 7, tool=4, a = 10, v = 10})

Wait(500)

MovJ({pose=approach_pick_point["pose"]}, {user=7, tool=4, a = 10, v = 10})

MovJ({pose=home_pos["pose"]}, {user=0, tool=4, a = 10, v = 10})



------> DROP
--[[print("drop_position:")
print(inspect(drop_position))
print("approach_drop_point:")
print(inspect(approach_drop_point))
print("approach_drop_soft:")
print(inspect(approach_drop_soft))
]]

MovJ({pose=approach_drop_point["pose"]}, {user=6, tool=4, a = 10, v = 10})

MovJ({pose=approach_drop_soft["pose"]}, {user = 6, tool=4, a = 10, v = 10})

MovL({pose=drop_position["pose"]}, {user = 6, tool = 4, a = 10, v = 10 })

DO(14, OFF)

Wait(1000)

MovL({pose=approach_drop_soft["pose"]}, {user = 6, tool=4, a = 10, v = 10})

Wait(1000)

MovJ({pose=approach_drop_point["pose"]}, {user=6, tool=4, a = 10, v = 10})

MovJ({pose=home_pos["pose"]}, {user=0, tool=4, a = 10, v = 10})
