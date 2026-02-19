-- 5.2 Parâmetros Configuráveis (Unidade: mm)
-- =========================================================
-- ARQUIVO: setting.lua
-- DESCRIÇÃO: Parâmetros de configuração e constantes
-- =========================================================

-- 1. Dimensões da Caixa (mm)
box_length = 400
box_width = 400
box_height = 400
gap = 10 -- Folga de segurança

-- 2. Configuração do Palete
pallet_rows = 1 -- Caixas no eixo Y
pallet_cols = 3 -- Caixas no eixo X
max_layers = 2

-- 3. Pontos de Referência (World Coordinates: x, y, z, rx, ry, rz)
pallet_frame_origin = P5["pose"] 
pallet_frame_drop = P6["pose"] 

-- Fim das configurações
