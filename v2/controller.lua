--Lib
local inspect = require("libs.inspect")
---

require("setting")


function rotateZ(x, y, theta)
    local cos_t = math.cos(theta)
    local sin_t = math.sin(theta)
    
    local newX = x * sin_t - y * cos_t
    local newY = x * cos_t + y * sin_t
    
    return newX, newY
end


function get_vector_offset(col, row, layer, angle, gap)
    local gap =  gap or 0
    local offset_pallet = (direction=="pl") and offset_pl or offset_pr
    local offset_x = (col - 1) * (box_length+ gap) + (box_length / 2)
    local offset_y = (row - 1) * (box_width+ gap) + (box_width / 2)
    local offset_z = (layer - 1) * box_height - offset_vacuum


    local temp_x = (math.abs(offset_pallet["x"]) - math.abs((box_length/2))) + offset_x

    response = {
      x = (direction=="pr") and (temp_x * -1) or temp_x, 
      y = (math.abs(offset_pallet["y"]) - math.abs((box_width/2))) + offset_y, 
      z = offset_z + box_height,
      theta = offset_pallet["theta"] + angle
    }
    print("-----------get_vector_offset----------------")
    print(inspect(response))
    print(rotateZ(response["x"], response["y"], angle))
    print("----------------END----------------")

    return response
end

function get_pick_position(theta_gripper)
    local theta_gripper = theta_gripper or 0
    local offset = get_vector_offset(current_col, current_row, current_layer, theta_gripper)
    return {
        pose={
            offset["x"],
            offset["y"],
            offset["z"],
            0,
            0,
            offset["theta"]
        }
    }
end
