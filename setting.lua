-- 5.2 Parâmetros Configuráveis (Unidade: mm)
-- =========================================================
-- ARQUIVO: setting.lua
-- DESCRIÇÃO: Parâmetros de configuração e constantes
-- =========================================================

-- 1. Dimensões da Caixa (mm)
box_length = 400
box_width = 300
box_height = 250
gap = 5 -- Folga de segurança

-- 2. Configuração do Palete
pallet_rows = 3 -- Caixas no eixo Y
pallet_cols = 2 -- Caixas no eixo X
max_layers = 4

-- 3. Pontos de Referência (World Coordinates: x, y, z, rx, ry, rz)
p_pick = {x=500, y=-200, z=100, rx=0, ry=180, rz=0} -- Ponto de pega (World)
pallet_frame_origin = {x=800, y=300, z=150, rx=0, ry=180, rz=0} -- Canto do palete

-- Fim das configurações