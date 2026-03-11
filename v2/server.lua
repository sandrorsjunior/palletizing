
local ip = "192.168.5.1" 
local port = 50000 


local err, socket = TCPCreate(true, ip, port)

if err == 0 then
    print("Servidor TCP criado na porta " .. port)

    local conn_result = TCPStart(socket, 0)
    
    if conn_result == 0 then
        print("Cliente conectado! Iniciando transmissao (1000ms)...")
        
        while true do
            
            local pose = GetPose() 
            local x = pose[1]
            local y = pose[2]
            local z = pose[3]
            
            
            local msg = string.format("X: %.2f, Y: %.2f, Z: %.2f\n", x, y, z)
            
            
            local write_err = TCPWrite(socket, msg, 0)
            
            
            if write_err ~= 0 then
                print("Conexao perdida ou erro ao enviar dados.")
                break 
            end
            
            
            Sleep(1000)
        end
    else
        print("Falha na conexao.")
    end
    
    
    TCPDestroy(socket)
    print("Servidor TCP encerrado.")
else
    print("Falha ao criar rede TCP.")
end