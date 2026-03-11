import socket
import struct
import time


ROBOT_IP = "192.168.5.1"
FEEDBACK_PORT = 50000

def read_realtime_data():
    
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.settimeout(5.0)

    try:
        print(f"Conectando à porta de feedback {ROBOT_IP}:{FEEDBACK_PORT}...")
        client_socket.connect((ROBOT_IP, FEEDBACK_PORT))
        print("Conectado! Iniciando a leitura do fluxo de dados...\n")

        
        for i in range(5):
            
            data = client_socket.recv(4096) 
            
            if not data:
                print("Nenhum dado recebido. O robô pode ter encerrado a conexão.")
                break
                
            print(f"--- Pacote {i+1} ---")
            print(f"Tamanho bruto recebido: {len(data)} bytes")
            
            

            try:
                print(data)
            except struct.error as e:
                print(f"Erro ao desempacotar: {e}")

            time.sleep(0.5) 

    except Exception as e:
        print(f"Erro na conexão: {e}")
    finally:
        
        client_socket.close()
        print("\nConexão de leitura encerrada.")

if __name__ == "__main__":
    read_realtime_data()