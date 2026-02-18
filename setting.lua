-- 5.2 Parâmetros Configuráveis (Unidade: mm)
box_length = 400
box_width = 300
box_height = 250
gap = 5 -- Folga de segurança

pallet_rows = 3 -- Caixas no eixo Y
pallet_cols = 2 -- Caixas no eixo X
max_layers = 4

p_pick = {x=500, y=-200, z=100, rx=0, ry=180, rz=0} -- Ponto de pega (World)
pallet_frame_origin = {x=800, y=300, z=150, rx=0, ry=180, rz=0} -- Canto do palete

-- Variáveis de Estado
current_layer = 1
current_row = 1
current_col = 1