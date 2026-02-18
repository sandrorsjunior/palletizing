-- =========================================================
-- ARQUIVO: main.lua
-- DESCRIÇÃO: Loop principal de controle da paletização
-- =========================================================

require("setting")
require("controller")

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
        if current_layer > max_layers then
            finish_pallet()
        end
    end
end