-- =========================================================
-- ARQUIVO: controller.lua
-- DESCRIÇÃO: Lógica de controle, matemática e movimento
-- =========================================================

-- 1. FUNÇÕES AUXILIARES

-- Cria um ponto deslocado em Z para aproximação (Offset)
function get_approach(point, isRetract)
    local isRetract = isRetract or false
    local z_offset = 100
    if isRetract then
        z_offset = (-current_layer + max_layers) * box_height + box_height + 20
    end
    local point = point["pose"]
    local result = {
        pose = {
          point[1],
          point[2],
          point[3] - z_offset,
          point[4],
          point[5],
          point[6]
        }
    }
    print("----------------get_approach----------------")
    print(result)
    print("-------------------------------------")
    return result
end

-- =========================================================
-- 2. INICIALIZAÇÃO DO ROBÔ
-- =========================================================
function initialize_robot()
    print("Inicializando robô...")

    -- 1.1 Configurações de Movimento
    VelL(40) -- Velocidade global 50%
    AccL(40) -- Aceleração 30% (suave)

    VelJ(40) -- Velocidade global 50%
    AccJ(40) -- Aceleração 30% (suave)

    -- 1.2 Configurações de Coordenadas e Ferramenta
    Tool(2) -- Usa o TCP calibrado da garra
    --User(4) -- Inicia referenciado na base do robô

    -- 1.3 Configuração de Carga (Payload)
    --SetPayload("") -- Peso da garra vazia

    -- 1.4 Reset de Variáveis de Estado (Globais)
    current_layer = max_layers
    current_row = 1
    current_col = 1
    total_boxes_done = 0
    direction = "origin"

    -- 1.6 Movimento para Home
    -- Posição segura: Alta, recolhida, longe de colisões
    MovJ(home_pos)

    print("Sistema Inicializado. Aguardando caixas...")
end

-- =========================================================
-- 3. GERENCIAMENTO DE PALETE CHEIO
-- =========================================================
function finish_pallet()

    MovJ(home_pos)
    
    current_layer = max_layers
    current_row = 1
    current_col = 1
    total_boxes_done = 0
    direction = "destination"

    -- 2.3 Sinalização para o Operador
    print("Aguardando operador trocar o palete (Pressione Botão DI 1)...")
end

-- =========================================================
-- 4. CÁLCULO DE POSIÇÃO (MATEMÁTICA)
-- =========================================================
function get_drop_position(pallet,col, row, layer, turned, teta)
    -- Fórmula Matemática aplicada
    -- Calcula offset relativo ao canto do palete
    local pallet = pallet
    local gap = 25
    local gap_vaccum = 5
    
    local turned = turned or false
    
    local offset_x = (row - 1) * (box_width  + gap) + (box_width / 2) 
    local offset_y = (col - 1) * (box_length  + gap) + (box_length / 2)
    local offset_z = (-layer + max_layers) * box_height  + box_height

    if (math.abs(teta) % 180 ~= 0) then 
      offset_x = (col - 1) * (box_length + gap) + (box_length / 2) 
      offset_y = (row - 1) * (box_width + gap) + (box_width / 2) 
      print("*****")
      print(offset_x)
    end
    
    offset_x = (direction == "destination") and (-1 * offset_x)  or offset_x
    
    -- Aplica transformação: Origem Palete + Offset Calculado
    -- Nota: Em produção real, usa-se funções de multiplicação de matrizes/poses
    local target_pos = {
        pose = {
            pallet["pose"][1] - offset_x,
            pallet["pose"][2] + offset_y,
            pallet["pose"][3] - (offset_z + gap_vaccum), -- Z é o topo da caixa colocada
            pallet["pose"][4],
            pallet["pose"][5],
            pallet["pose"][6] + teta
        }
    }
    print("----------------drop----------------")
    print(target_pos)
    print("-------------------------------------")
    return target_pos
end

function get_pick_position(pallet, col, row, layer, turned, teta)
    -- Fórmula Matemática aplicada
    -- Calcula offset relativo ao canto do palete
    local turned = turned or false
    local offset_vacuum = 10
    local gap = 25
    
    local offset_x = (col - 1) * (box_length+ gap) + (box_length / 2)
    local offset_y = (row - 1) * (box_width+ gap) + (box_width / 2)
    local offset_z = (layer - 1) * box_height - offset_vacuum
    
    if (math.abs(teta) % 180 == 0) then 
      offset_y = (col - 1) * (box_length + gap) + (box_length / 2) 
      offset_x = (row - 1) * (box_width + gap) + (box_width / 2) 
      print("*****")
      print(offset_x)
    end
    
    offset_x = (direction == "destination") and (-1 * offset_x) or offset_x
    
    print("-------**---------pallet-------**----------")
    print(pallet)
    print(pallet["pose"][1])
    print(offset_x)
    print("-------**--------------------**---------")
    -- Aplica transformação: Origem Palete + Offset Calculado
    -- Nota: Em produção real, usa-se funções de multiplicação de matrizes/poses
    local target_pos = {
        pose = {
            pallet["pose"][1] + offset_x,
            pallet["pose"][2] + offset_y,
            pallet["pose"][3] - (offset_z + box_height), -- Z é o topo da caixa colocada
            pallet["pose"][4],
            pallet["pose"][5],
            pallet["pose"][6] + teta
        }
    }
    
    print("-------**---------get pick-------**----------")
    print(target_pos)
    print("-------**--------------------**---------")

    return target_pos
end

-- modify the home position to mach with the taget poit but in a different z point
function move_safe_plane(pallet, angle_z, point)
    --local safe_ref = box_height * max_layers + 3 * box_height
    local result = {
        pose = {
            point[1],
            point[2],
            P11["pose"][3], -- Z é o topo da caixa colocada
            0,
            0,
            angle_z
        }
    }
    print("----------------safe_plane----------------")
    print(result)
    print("-------------------------------------")

    return result
end

-- =========================================================
-- 5. ROTINA DE PICK AND PLACE
-- =========================================================
function process_box(start)
    local start = start or "origin"
    local frame_origin = P8 
    local frame_destination = P9
    local user_origin = 4
    local user_destination = 5
    local teta_pick = 90
    local teta_drop = 180
    if start == "destination" then
      frame_origin = P9
      frame_destination = P8
      user_origin = 5
      user_destination = 4
      local temp = teta_pick
      teta_pick = teta_drop
      teta_drop = temp
    end
    print(teta_pick)
    print(teta_drop)
    print("---------set up----------------")
      print("frame_origin:")
      print(frame_origin)
      print("frame_destination:")
      print(frame_destination)
    print("-------------------------------")

    -- 1. Aproximação do Picking (Acima da caixa)
    local p_pick = get_pick_position(frame_origin, current_col, current_row, current_layer, turned_pick, teta_pick)
    MovL(move_safe_plane(frame_origin, teta_pick, p_pick["pose"]), {user = user_origin, tool = 2 })
    --MovL(P11, {tool = 2 })
    MovL(get_approach(p_pick, false), {user = user_origin,tool = 2 })

    Wait(500)
    DO(14, ON)
    MovL(p_pick, {user = user_origin, tool = 2, a = 10, v = 10 })
    Wait(300)
    -- 3. Retração (Sobe com a caixa)
    MovJ(get_approach(p_pick, true), {user = user_origin, tool = 2 })

    MovJ(home_pos, {user = 0, tool = 2 })
    -- Calcula destino no palete
    local p_drop = get_drop_position(frame_destination, current_col, current_row, current_layer, turned_drop, teta_drop)
    local approach_drop = get_approach(p_drop)

    -- 4. Deslocamento e Aproximação
    MovJ(move_safe_plane(frame_destination,teta_drop,p_drop["pose"]), {user = user_destination, tool = 2 })
    --MovL(P12, {tool = 2 })
    MovL(get_approach(p_drop, false), {user = user_destination, tool = 2 }) -- Movimento articular (rápido) no ar

    -- 5. Posicionamento Fino
    MovL(p_drop, {user = user_destination, tool = 2, a = 10, v = 10 }) -- Movimento linear para precisão na descida

    -- 6. Liberação
    Wait(500)
    DO(14, OFF)
    Wait(900)

    -- 7. Saída Segura
    MovL(get_approach(p_drop, true), {user = user_destination, tool = 2 })
    MovJ(home_pos, {user = 0, tool = 2, a = 20, v = 20 })
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
        print("--- direction main: ---")
        print(direction)
        process_box(direction)

        -- B. Atualiza contadores (coluna, linha, camada)
        update_counters()

        -- C. Feedback visual
        print(string.format("Caixa depositada. Camada: %d, Linha: %d, Coluna: %d", current_layer, current_row,
            current_col))

        -- D. Verifica se o palete está completo
        if current_layer == 0 then
            finish_pallet()
            --break
        end
    end
    print("-----FIM-----")
end

main()

--[[
direction = "destiantion"
--MovJ(home_pos, {user = 0, tool = 2 })
    -- Calcula destino no palete
    local p_drop = get_pick_position(P9, 1, 1, 1, true)

    -- 4. Deslocamento e Aproximação
    MovJ(move_safe_plane(P9,p_drop["pose"][6],p_drop["pose"]), {user = 5, tool = 2 })
    

MovJ(P1)
local p_drop1 = get_drop_position(1, 1, 3,true)
local approach_drop = get_approach(p_drop1)
print("----------------safe_plane----------------")
print(move_safe_plane("drop",p_drop1["pose"][6]))
print("-------------------------------------")
print("----------------drop1----------------")
print(p_drop1)
print("-------------------------------------")
MovJ(move_safe_plane("drop",p_drop1["pose"][6]), { user = 5, tool = 2, a = 20, v = 20 })
MovJ({ pose = get_approach(p_drop1, false) }, { user = 5, tool = 2, a = 25, v = 25 })

local p_drop2 = get_drop_position(1, 2, 3,true)
print("----------------drop1----------------")
print(p_drop2)
print("-------------------------------------")
MovJ({ pose = get_approach(p_drop2, false) }, { user = 5, tool = 2, a = 25, v = 25 })

]]


--[[
MovJ(P1)
local p_pick1 = get_pick_position(1, 1, 3, true)
print("----------------safe_plane----------------")
print(move_safe_plane("origin",p_pick1["pose"][6]))
print("-------------------------------------")

print("----------------pick1----------------")
print(p_pick1)
print("-------------------------------------")
MovJ(move_safe_plane("origin",p_pick1["pose"][6]), { user = 4, tool = 2, a = 25, v = 25 })
MovJ({ pose = get_approach(p_pick1, false) }, { user = 4, tool = 2, a = 25, v = 25 })

p_pick2 = get_pick_position(1, 2, 3,true)
print("----------------pick2----------------")
print(p_pick2)
print("-------------------------------------")

MovJ({ pose = get_approach(p_pick2, false) }, { user = 4, tool = 2, a = 25, v = 25 })

]]