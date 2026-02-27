-- 5.2 Parâmetros Configuráveis (Unidade: mm)
-- =========================================================
-- ARQUIVO: setting.lua
-- DESCRIÇÃO: Parâmetros de configuração e constantes
-- =========================================================
turned_pick = true
turned_drop = true
-- 1. Dimensões da Caixa (mm)
box_length = 300
box_width = 250
box_height = 210
gap = 2 -- Folga de segurança

-- 2. Configuração do Palete
pallet_rows = 1-- Caixas no eixo Y
pallet_cols = 1 -- Caixas no eixo X
max_layers = 1

-- 3. Pontos de Referência (World Coordinates: x, y, z, rx, ry, rz)
pallet_frame_origin = P8["pose"] 
pallet_frame_drop = P9["pose"] 


home_pos = P1

-- Fim das configurações
