-- 5.2 Parâmetros Configuráveis (Unidade: mm)
-- =========================================================
-- ARQUIVO: setting.lua
-- DESCRIÇÃO: Parâmetros de configuração e constantes
-- =========================================================

-- 1. Dimensões da Caixa (mm)
box_length = 250
box_width = 300
box_height = 210
gap = 5 -- Folga de segurança

-- 2. Configuração do Palete
pallet_rows = 2 -- Caixas no eixo Y
pallet_cols = 2 -- Caixas no eixo X
max_layers = 3

-- 3. Pontos de Referência (World Coordinates: x, y, z, rx, ry, rz)
pallet_frame_origin = P5["pose"] 
pallet_frame_drop = P6["pose"] 


home_pos = P7
-- Fim das configurações
