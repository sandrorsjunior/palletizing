-- 1. Dimensões da Caixa (mm)
box_length = 300
box_width = 250
box_height = 210

-- 2. Configuração do Palete
pallet_rows = 2 -- Caixas no eixo Y
pallet_cols = 2 -- Caixas no eixo X
max_layers = 1

PALLET_USER_6 = 6
PALLET_USER_7 = 7


home_pos = {
    user = 0,
    tool = 4,
    pose = {
        -115.0697,
        639.2179,
        -36.3228 + box_height,
        0,
        0,
        -44.528
    }
}

-- 4. offsets
offset_vacuum = 17 -- Define quanto o gripper vai deformar sua espuma
offset_static_drop = 5

-- 4.1 offset pl
offset_pl = {
    x = 150.0762, -- 150.0767
    y = 125.5334, -- 125.7994
    theta = 135.4723
}

-- 4.2 offset pr
offset_pr = {
    x = -149.646,  -- -150.3981
    y = 128.2425,   -- 128.2422
    theta = 135.9192
}

-- 0. Controler
current_layer = max_layers
current_row = 1
current_col = 1
total_boxes_done = 0
flow = {{pallet="pr", user=7},{pallet="pl", user=6}}
direction = flow[1]["pallet"]

