function get_drop_position(col, row, layer)
    -- 5.3 Fórmula Matemática aplicada
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


function process_box()
    -- 1. Aproximação do Picking (Acima da caixa)
    movel(get_approach(p_pick, 100)) 
    
    -- 2. Picking (Desce e agarra)
    movel(p_pick)
    set_digital_out(1, true) -- Ativa vácuo
    sleep(0.5) -- Tempo para gerar vácuo
    if not get_digital_in(1) then error("Falha na pega") end
    
    -- 3. Retração (Sobe com a caixa)
    movel(get_approach(p_pick, 200))
    
    -- Calcula destino no palete
    local drop_pos = get_drop_position(current_col, current_row, current_layer)
    local approach_drop = {x=drop_pos.x, y=drop_pos.y, z=drop_pos.z + 200, rx=drop_pos.rx, ry=drop_pos.ry, rz=drop_pos.rz}
    
    -- 4. Deslocamento e Aproximação
    movej(approach_drop) -- Movimento articular (rápido) no ar
    
    -- 5. Posicionamento Fino
    movel(drop_pos) -- Movimento linear para precisão na descida
    
    -- 6. Liberação
    set_digital_out(1, false) -- Solta vácuo
    sleep(0.2)
    
    -- 7. Saída Segura
    movel(approach_drop)
end

function update_counters()
    current_col = current_col + 1
    
    if current_col > pallet_cols then
        current_col = 1
        current_row = current_row + 1
    end
    
    if current_row > pallet_rows then
        current_row = 1
        current_layer = current_layer + 1
        -- Aqui pode-se adicionar lógica para rotacionar padrão (intertravamento)
    end
end


