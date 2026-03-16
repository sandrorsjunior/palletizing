--Lib
local inspect = require("libs.inspect")
---

require("controller")
require("setting")



while true do
    print("-----START-----")

    -- get the first box position in order to perform pick up
    local box_angle_pick = 0
    local box_angle_drop = math.pi     --math.pi

    direction = flow[1]["pallet"]
    local pick_position = get_position("pick", box_angle_pick)
    -- get the position of approach to pick
    local approach_pick_point = get_approach("pick", pick_position, box_angle_pick,
        { factorX = 1.1, factorY = 1, factorZ = 1.1 })
    -- get the position over correct position but add few height
    local approach_pick_soft = get_approach_soft(pick_position, 2)

    direction = flow[2]["pallet"]
    local drop_position = get_position("drop", box_angle_drop, 25)
    -- get the position of approach to pick
    local approach_drop_point = get_approach("drop", drop_position, box_angle_drop,
        { factorX = 0.3, factorY = 1.1, factorZ = 1.3 })
    -- get the position over correct position but add few height
    local approach_drop_soft = get_approach_soft(drop_position, 2)


    ------> PICK


    MovJ({ pose = home_pos["pose"] }, { user = 0, tool = 5, a = 40, v = 40 })

    --MovJ({pose=approach_pick_point["pose"]}, {user=flow[1]["user"], tool=5, a = 30, v = 30 , cp = 50})

    MovJ({ pose = approach_pick_soft["pose"] }, { user = flow[1]["user"], tool = 5, a = 30, v = 30, cp = 50 })

    MovL({ pose = pick_position["pose"] }, { user = flow[1]["user"], tool = 5, a = 10, v = 10 })

    DO(14, ON)

    Wait(600)

    MovL({ pose = approach_pick_soft["pose"] }, { user = flow[1]["user"], tool = 5, a = 10, v = 10 })

    MovJ({ pose = approach_pick_point["pose"] }, { user = flow[1]["user"], tool = 5, a = 30, v = 30, cp = 50 })

    MovJ({ pose = home_pos["pose"] }, { user = 0, tool = 5, a = 30, v = 30, cp = 50 })



    ------> DROP

    print("++++++", approach_drop_point["pose"])
    MovJ({ pose = approach_drop_point["pose"] }, { user = flow[2]["user"], tool = 5, a = 30, v = 30, cp = 50 })


    MovJ({ pose = approach_drop_soft["pose"] }, { user = flow[2]["user"], tool = 5, a = 10, v = 10 })

    MovL({ pose = drop_position["pose"] }, { user = flow[2]["user"], tool = 5, a = 10, v = 10 })

    DO(14, OFF)
    Wait(800)
    MovL(RelPointUser({ pose = drop_position["pose"] }, { 0, 0, 25, 0, 0, 0 }),
        { user = flow[2]["user"], tool = 5, a = 5, v = 30, cp = 50 })
    Wait(100)


    MovJ({ pose = home_pos["pose"] }, { user = 0, tool = 5, a = 10, v = 30 })

    print(string.format("Caixa depositada. Camada: %d, Linha: %d, Coluna: %d", current_layer, current_row,
        current_col))


    update_counters()

    -- D. Verifica se o palete está completo
    if current_layer == 0 then
        reset()
        --break
    end
end
print("-----END-----")
