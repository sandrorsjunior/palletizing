--Lib
local inspect = require("libs.inspect")
---

require("setting")


function rotateZ(x, y, theta)
    local x_signal = math.abs(x) / x
    local y_signal = math.abs(y) / y
    local cos_t = math.cos(theta)
    local sin_t = math.sin(theta)

    local newX = x * cos_t - y * sin_t
    local newY = x * sin_t + y * cos_t

    return x_signal * math.abs(newX), y_signal * math.abs(newY)
end

-- status ("pick" or "drop")
function get_z_offset(status, layer)
    local pick = (layer - 1) * box_height - offset_vacuum
    local drop = (-layer + max_layers) * box_height
    return (status == "pick") and pick or drop
end

-- status ("pick" | "drop")
function get_approach(status, point, theta, factor)
    factor = factor or { factorX = 1, factorY = 1, factorZ = 1 }
    point = point["pose"]
    local approach_offset = { x = box_length * factor["factorX"], y = box_width * factor["factorY"] }
    approach_offset["x"], approach_offset["y"] = rotateZ(approach_offset["x"], approach_offset["y"], theta)
    local offsetX = (approach_offset["x"] * (math.abs(point[1]) / point[1]) * -1)
    local offsetY = (approach_offset["y"] * (math.abs(point[2]) / point[2]) * -1)
    local offsetZ = (box_height * factor["factorZ"])
    local approach_point = {
        x = point[1] + ((status == "pick") and offsetX or offsetX * -1),
        y = point[2] + ((status == "pick") and offsetY or offsetY * -1),
        z = point[3] + offsetZ
    }
    if (status == "pick") then
        return { pose = { approach_point["x"], point[2], approach_point["z"], point[4], point[5], point[6] } }
    elseif (status == "drop") then
        return { pose = { approach_point["x"], approach_point["y"], approach_point["z"], point[4], point[5], point[6] } }
    else
        print("Fudeu -> eu dediquei-me neste código mas você pôs um status invalido!")
    end
end

function get_approach_soft(point, factor)
    factor = factor or 2
    point = point["pose"]
    return {
        pose = {
            point[1],
            point[2],
            point[3] + (box_height / factor),
            point[4],
            point[5],
            point[6]
        }
    }
end

function get_vector_offset(status, col, row, layer, angle, gap)
    local gap = gap or 0
    local offset_pallet = (direction == "pl") and offset_pl or offset_pr
    local offset_x = (col - 1) * (box_length + gap) + (box_length / 2)
    local offset_y = (row - 1) * (box_width + gap) + (box_width / 2)
    local offset_z = get_z_offset(status, layer)
    print("*******", status, direction, inspect(offset_pallet))


    local temp_x = (math.abs(offset_pallet["x"]) - math.abs((box_length / 2))) + offset_x

    response = {
        x = (direction == "pr") and (temp_x * -1) or temp_x,
        y = (math.abs(offset_pallet["y"]) - math.abs((box_width / 2))) + offset_y,
        z = offset_z + box_height,
        theta = offset_pallet["theta"] + math.deg(angle)
    }
    response["x"], response["y"] = rotateZ(response["x"], response["y"], angle)

    return response
end

function get_position(status, theta_gripper, gap)
    local theta_gripper = theta_gripper or 0
    local offset = get_vector_offset(status, current_col, current_row, current_layer, theta_gripper, gap)
    return {
        pose = {
            offset["x"],
            offset["y"],
            offset["z"],
            0,
            0,
            offset["theta"]
        }
    }
end

-- Atualiza os índices da matriz do palete
function update_counters()
    current_col = current_col + 1

    if current_col > pallet_cols then
        current_col = 1
        current_row = current_row + 1
    end

    if current_row > pallet_rows then
        current_row = 1
        current_layer = current_layer - 1
    end

    total_boxes_done = total_boxes_done + 1
end
