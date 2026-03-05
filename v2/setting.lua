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
        -36.3228,
        0,
        0,
        -44.528
    }
}

-- 4. offsets
offset_vacuum = 10 -- Define quanto o gripper vai deformar sua espuma
-- 4.1 offset pl
offset_pl = {
    x = 158.4987,
    y = 126.3081,
    theta = 135.4723
}

-- 4.2 offset pr
offset_pr = {
    x = -144.9174,
    y = 121.7384,
    theta = 135.9192
}

-- 0. Controler
current_layer = max_layers
current_row = 1
current_col = 1
total_boxes_done = 0
direction = "pl" -- ("pr" | "pl") ----0.535296
