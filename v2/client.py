import socket

# 1. Configurações de Rede (Devem coincidir com o servidor Lua)
ROBOT_IP = "192.168.5.1"
PORT = 50000

def connect_to_robot():
    # 2. Criação do socket TCP (IPv4, TCP)
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    try:
        print(f"Tentando conectar ao servidor do robô em {ROBOT_IP}:{PORT}...")
        
        # 3. Estabelece a conexão
        client_socket.connect((ROBOT_IP, PORT))
        print("Conectado com sucesso! Aguardando coordenadas...\n")
        print("-" * 40)

        # 4. Loop de leitura contínua
        while True:
            data = client_socket.recv(1024)
            
            if not data:
                print("\nO servidor do robô encerrou a conexão.")
                break
            
            coordenadas = data.decode('utf-8').strip()
            
            print(f"Posição Atual -> {coordenadas}")

    except ConnectionRefusedError:
        print("\nErro: Conexão recusada.")
        print("Verifique se o script Lua já está em execução no DobotStudioPro antes de rodar o Python.")
    except KeyboardInterrupt:
        print("\n\nLeitura interrompida manualmente pelo usuário.")
    except Exception as e:
        print(f"\nErro inesperado na comunicação: {e}")
    finally:
        client_socket.close()
        print("-" * 40)
        print("Cliente TCP encerrado.")

if __name__ == "__main__":
    connect_to_robot()