-- 1. Dimensões da Caixa (mm)
box_length = 300
box_width = 250
box_height = 210

-- 2. Configuração do Palete
pallet_rows = 2-- Caixas no eixo Y
pallet_cols = 2 -- Caixas no eixo X
max_layers = 1

PALLET_USER_6 = 6
PALLET_USER_7 = 7



-- 4. offsets
offset_vacuum = 5 -- Define quanto o gripper vai deformar sua espuma
-- 4.1 offset pl
offset_pl = {
  x= 143.2746,
  y= 147.9543,
  theta= 135.4924
}

-- 4.2 offset pr
offset_pr = {
  x= -161.453,
  y= 146.6447,
  theta= 135.7475
}

-- 0. Controler 
current_layer = max_layers
current_row = 1
current_col = 2
total_boxes_done = 0
direction = "pl" -- ("pr" | "pl")