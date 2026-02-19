-- =========================================================
-- ARQUIVO: controller.lua
-- DESCRIÇÃO: Lógica de controle, matemática e movimento
-- =========================================================

-- 1. FUNÇÕES AUXILIARES

-- Cria um ponto deslocado em Z para aproximação (Offset)
function get_approach(point, z_offset)
    local z_offset = z_offset or 100
    local point = point["pose"]
    return {
        point[1],
        point[2],
        point[3] + z_offset,
        point[4],
        point[5],
        point[6]
    }
end

-- =========================================================
-- 2. INICIALIZAÇÃO DO ROBÔ
-- =========================================================
function initialize_robot()
    print("Inicializando robô...")

    -- 1.1 Configurações de Movimento
    VelJ(10) -- Velocidade global 50%
    AccJ(10) -- Aceleração 30% (suave)

    -- 1.2 Configurações de Coordenadas e Ferramenta
    Tool(2) -- Usa o TCP calibrado da garra
    --User(4) -- Inicia referenciado na base do robô

    -- 1.3 Configuração de Carga (Payload)
    --SetPayload("") -- Peso da garra vazia

    -- 1.4 Reset de Variáveis de Estado (Globais)
    current_layer = 3
    current_row = 1
    current_col = 1
    total_boxes_done = 0

    -- 1.6 Movimento para Home
    -- Posição segura: Alta, recolhida, longe de colisões
    local home_pos = P7
    MovJ(home_pos)

    print("Sistema Inicializado. Aguardando caixas...")
end

-- =========================================================
-- 3. GERENCIAMENTO DE PALETE CHEIO
-- =========================================================
function finish_pallet()
    print("--- PALETE CHEIO ---")

    -- 2.1 Mover para Segurança (Sobe Z)
    local safe_pose = GetPose()
    local safe_height = 400
    safe_pose["pose"][3] = safe_pose["pose"][3] + safe_height

    MovL(safe_pose)

    -- 2.2 Vai para o Home (Longe da área de troca)
    local home_pos = P7
    MovJ(home_pos)

    -- 2.3 Sinalização para o Operador
    print("Aguardando operador trocar o palete (Pressione Botão DI 1)...")
end

-- =========================================================
-- 4. CÁLCULO DE POSIÇÃO (MATEMÁTICA)
-- =========================================================
function get_drop_position(col, row, layer)
    -- Fórmula Matemática aplicada
    -- Calcula offset relativo ao canto do palete
    local offset_x = (col - 1) * (box_length + gap) + (box_length / 2)
    local offset_y = (row - 1) * (box_width + gap) + (box_width / 2)
    local offset_z = (-layer+3) * box_height

    -- Aplica transformação: Origem Palete + Offset Calculado
    -- Nota: Em produção real, usa-se funções de multiplicação de matrizes/poses
    local target_pos = {
        pose = {
            pallet_frame_drop[1] + offset_x,
            pallet_frame_drop[2] - offset_y,
            pallet_frame_drop[3] + offset_z, -- Z é o topo da caixa colocada
            pallet_frame_drop[4],
            pallet_frame_drop[5],
            pallet_frame_drop[6]
        }
    }
    print(target_pos["pose"])
    return target_pos
end

function get_pick_position(col, row, layer)
    -- Fórmula Matemática aplicada
    -- Calcula offset relativo ao canto do palete
    local offset_x = (col - 1) * (box_length + gap) + (box_length / 2)
    local offset_y = (row - 1) * (box_width + gap) + (box_width / 2)
    local offset_z = (layer - 1) * box_height
 
    -- Aplica transformação: Origem Palete + Offset Calculado
    -- Nota: Em produção real, usa-se funções de multiplicação de matrizes/poses
    local target_pos = {
        pose = {
            pallet_frame_origin[1] + offset_x,
            pallet_frame_origin[2] - offset_y,
            pallet_frame_origin[3] + offset_z + box_height, -- Z é o topo da caixa colocada
            pallet_frame_origin[4],
            pallet_frame_origin[5],
            pallet_frame_origin[6]
        }
    }

    return target_pos
end

-- =========================================================
-- 5. ROTINA DE PICK AND PLACE
-- =========================================================
function process_box()
    -- 1. Aproximação do Picking (Acima da caixa)
    local p_pick = get_pick_position(current_col, current_row, current_layer)
    local approach_pick = get_approach(p_pick)
    MovJ({ pose = approach_pick }, { user = 4, tool = 2, a = 20, v = 20 })

    print("enable vacuum") -- Ativa vácuo (Porta 1 ON)
    MovL(p_pick, { user = 4, tool = 2, a = 20, v = 20 })

    -- 3. Retração (Sobe com a caixa)
    MovL({ pose = approach_pick }, { user = 4, tool = 2, a = 20, v = 20 })
    
    MovJ(P7, { user = 0, tool = 2, a = 20, v = 20 })
    -- Calcula destino no palete
    local p_drop = get_drop_position(current_col, current_row, current_layer)
    local approach_drop = get_approach(p_drop)

    -- 4. Deslocamento e Aproximação
    MovJ({ pose = approach_drop }, { user = 5, tool = 2, a = 20, v = 20 }) -- Movimento articular (rápido) no ar

    -- 5. Posicionamento Fino
    MovL(p_drop, { user = 5, tool = 2, a = 10, v = 10 }) -- Movimento linear para precisão na descida

    -- 6. Liberação
    print("disable vacuum") -- Solta vácuo (Porta 1 OFF)

    -- 7. Saída Segura
    MovL({ pose = approach_drop }, { user = 5, tool = 2, a = 10, v = 10 })
    MovJ(P7, { user = 0, tool = 2, a = 20, v = 20 })
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

-- =========================================================
-- ARQUIVO: main.lua
-- DESCRIÇÃO: Loop principal de controle da paletização
-- =========================================================


function main()
    -- 1. Executa a rotina de inicialização e segurança
    initialize_robot()

    print("--- Início do Ciclo Automático ---")

    -- 2. Loop Infinito de Produção
    while true do
        print("Caixa detectada. Iniciando processo...")
            
        -- A. Executa ciclo completo (Pick & Place)
        process_box() 
        
        -- B. Atualiza contadores (coluna, linha, camada)
        update_counters()
              
        -- C. Feedback visual
        print(string.format("Caixa depositada. Camada: %d, Linha: %d, Coluna: %d", current_layer, current_row, current_col))

        -- D. Verifica se o palete está completo
        if current_layer == 0 then
            --finish_pallet()
            break
        end
    end
    print("-----FIM-----")
end

main()