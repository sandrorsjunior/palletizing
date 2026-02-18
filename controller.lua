-- =========================================================
-- ARQUIVO: controller.lua
-- DESCRIÇÃO: Lógica de controle, matemática e movimento
-- =========================================================

-- 1. FUNÇÕES AUXILIARES

-- Cria um ponto deslocado em Z para aproximação (Offset)
function get_approach(point, z_offset)
    return {
        x = point.x,
        y = point.y,
        z = point.z + z_offset,
        rx = point.rx,
        ry = point.ry,
        rz = point.rz
    }
end

-- =========================================================
-- 2. INICIALIZAÇÃO DO ROBÔ
-- =========================================================
function initialize_robot()
    print("Inicializando robô...")

    -- 1.1 Configurações de Movimento
    SetVel(50)         -- Velocidade global 50%
    SetAcc(30)         -- Aceleração 30% (suave)
    
    -- 1.2 Configurações de Coordenadas e Ferramenta
    SetTool(1)         -- Usa o TCP calibrado da garra
    SetUser(0)         -- Inicia referenciado na base do robô
    
    -- 1.3 Configuração de Carga (Payload)
    Load(3.5, 0, 0, 50) -- Peso da garra vazia
    
    -- 1.4 Reset de Variáveis de Estado (Globais)
    current_layer = 1
    current_row = 1
    current_col = 1
    total_boxes_done = 0
    
    -- 1.5 Reset de I/O (Segurança)
    DO(1, 0) -- Garante Vácuo DESLIGADO
    DO(2, 0) -- Garante Luz de Alerta DESLIGADA
    
    -- 1.6 Movimento para Home
    -- Posição segura: Alta, recolhida, longe de colisões
    local home_pos = {0, -500, 600, 0, 0, 0} 
    MovJ(home_pos) 
    
    print("Sistema Inicializado. Aguardando caixas...")
end

-- =========================================================
-- 3. GERENCIAMENTO DE PALETE CHEIO
-- =========================================================
function finish_pallet()
    print("--- PALETE CHEIO ---")
    
    -- 2.1 Mover para Segurança (Sobe Z)
    local current_pos = GetPose() 
    local safe_height = 800 
    local safe_z = {
        x = current_pos.x, 
        y = current_pos.y, 
        z = safe_height, 
        r = current_pos.r -- Mantém rotação (para 4 eixos) ou rx,ry,rz
    }
    MovL(safe_z)
    
    -- 2.2 Vai para o Home (Longe da área de troca)
    local home_pos = {0, -500, 600, 0, 0, 0}
    MovJ(home_pos)
    
    -- 2.3 Sinalização para o Operador
    DO(2, 1) -- Liga Torre de Luz (Amarela/Vermelha)
    print("Aguardando operador trocar o palete (Pressione Botão DI 1)...")
    
    -- 2.4 Loop de Bloqueio (Wait for Input)
    -- O robô fica travado aqui até receber sinal na porta DI(1)
    while DI(1) == 0 do -- Assumindo DI(1) como botão de reset
        Sleep(100) -- Verifica a cada 100ms
    end
    
    -- 2.5 Reset para o Próximo Ciclo
    DO(2, 0)          -- Desliga luz de alerta
    current_layer = 1 -- Reinicia contagem
    current_row = 1
    current_col = 1
    
    print("Palete trocado confirmado. Reiniciando ciclo.")
end

-- =========================================================
-- 4. CÁLCULO DE POSIÇÃO (MATEMÁTICA)
-- =========================================================
function get_drop_position(col, row, layer)
    -- Fórmula Matemática aplicada
    -- Calcula offset relativo ao canto do palete
    local offset_x = (col - 1) * (box_length + gap) + (box_length / 2)
    local offset_y = (row - 1) * (box_width + gap) + (box_width / 2)
    local offset_z = (layer - 1) * box_height
    
    -- Aplica transformação: Origem Palete + Offset Calculado
    -- Nota: Em produção real, usa-se funções de multiplicação de matrizes/poses
    local target_pos = {
        x = pallet_frame_origin.x + offset_x,
        y = pallet_frame_origin.y + offset_y,
        z = pallet_frame_origin.z + offset_z + box_height, -- Z é o topo da caixa colocada
        rx = pallet_frame_origin.rx,
        ry = pallet_frame_origin.ry,
        rz = pallet_frame_origin.rz
    }
    
    return target_pos
end

-- =========================================================
-- 5. ROTINA DE PICK AND PLACE
-- =========================================================
function process_box()
    -- 1. Aproximação do Picking (Acima da caixa)
    MovL(get_approach(p_pick, 100)) 
    
    -- 2. Picking (Desce e agarra)
    MovL(p_pick)
    DO(1, 1)   -- Ativa vácuo (Porta 1 ON)
    Sleep(500) -- Tempo para gerar vácuo (ms)
    
    -- Verificação do sensor de vácuo (Opcional, se houver sensor na DI 1)
    -- if DI(1) == 0 then error("Falha na pega") end
    
    -- 3. Retração (Sobe com a caixa)
    MovL(get_approach(p_pick, 200))
    
    -- Calcula destino no palete
    local drop_pos = get_drop_position(current_col, current_row, current_layer)
    local approach_drop = {x=drop_pos.x, y=drop_pos.y, z=drop_pos.z + 200, rx=drop_pos.rx, ry=drop_pos.ry, rz=drop_pos.rz}
    
    -- 4. Deslocamento e Aproximação
    MovJ(approach_drop) -- Movimento articular (rápido) no ar
    
    -- 5. Posicionamento Fino
    MovL(drop_pos) -- Movimento linear para precisão na descida
    
    -- 6. Liberação
    DO(1, 0)   -- Solta vácuo (Porta 1 OFF)
    Sleep(200) -- Tempo para soltar
    
    -- 7. Saída Segura
    MovL(approach_drop)
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
        current_layer = current_layer + 1
    end
    
    total_boxes_done = total_boxes_done + 1
end
