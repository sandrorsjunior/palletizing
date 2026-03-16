# Sistema de Paletização Automatizado - Dobot CR20A

Este projeto consiste em um sistema de paletização automatizado desenvolvido em **Lua**, projetado para operar com o robô colaborativo **Dobot CR20A**. O script gerencia a lógica de "Pick and Place" (pega e coloca), calculando automaticamente as posições de depósito com base nas dimensões da caixa e na configuração do palete.

## 🚀 Funcionalidades

- **Cálculo Dinâmico de Posições**: Calcula a posição exata de cada caixa iterando sobre colunas, linhas e camadas, utilizando as dimensões reais da caixa.
- **Abordagem Suave (Soft Approach)**: Lógica implementada para posições de aproximação, garantindo que o robô não colida com caixas adjacentes.
- **Desenvolvimento Modular**: Divisão de regras de negócio, configurações e loop principal na pasta `src/`, facilitando a manutenção e testes.
- **Build Automatizado**: Script em Python (`build.py`) que compila os múltiplos arquivos Lua em um único script que pode ser diretamente injetado no DobotStudioPro.
- **Monitoramento de Coordenadas TCP/IP**: Sistema Servidor/Cliente que transmite as coordenadas `X`, `Y` e `Z` atuais do robô via rede.

## 📂 Estrutura do Projeto

```text
v2/
├── src/
│   ├── setting.lua      # Configurações de palete, dimensões de caixas e offsets.
│   ├── controller.lua   # Regras matemáticas, rotações e cálculos de trajetória.
│   └── main.lua         # Lógica principal, rotinas de MovJ, MovL e controle da garra.
├── util/
│   ├── build.py         # Script Python para concatenar e formatar o código-fonte Lua.
│   └── build/           # Diretório gerado automaticamente contendo os códigos finais compilados.
├── libs/
│   └── inspect.lua      # Biblioteca Lua para inspeção de tabelas (usada para debug).
├── server.lua           # Script TCP para rodar no robô e enviar poses em tempo real.
└── client.py            # Script Python cliente para monitorar as coordenadas.
```

## 🛠️ Como Utilizar

### 1. Configurando os Parâmetros
Todas as configurações físicas devem ser ajustadas no arquivo `src/setting.lua`. Nele você pode definir as dimensões da caixa e o comportamento do palete:

```lua
-- 1. Dimensões da Caixa (mm)
box_length = 300
box_width = 250
box_height = 210

-- 2. Configuração do Palete
pallet_rows = 2 -- Caixas no eixo Y
pallet_cols = 2 -- Caixas no eixo X
max_layers = 3
```

### 2. Realizando o Build do Projeto
A controladora do robô tipicamente espera um script unificado. Para unificar as configurações, a inteligência da controladora e o loop principal, utilize o utilitário de build:

```bash
cd util
python build.py
```
*Este comando criará uma pasta `build/` contendo o `main.lua` pronto para o robô.*

### 3. Execução no Robô
1. Abra o **DobotStudioPro** (ou software equivalente do Dobot CR20A).
2. Importe ou copie o código gerado em `util/build/main.lua`.
3. Certifique-se de que os pontos iniciais (ex: `home_pos`) estão fisicamente livres.
4. Inicie o programa.

### 4. Monitoramento Remoto (Opcional)
Caso deseje monitorar o TCP do robô em tempo real:
1. Embarque e execute o script `server.lua` paralelamente no robô.
2. No seu computador local (conectado à mesma rede), inicie o cliente em Python:
   ```bash
   python client.py
   ```
3. As posições atuais do robô serão impressas continuamente no seu terminal.

## ⚙️ Pré-requisitos

- **Hardware:** Robô colaborativo Dobot CR20A.
- **Python:** Versão 3.6 ou superior (para execução do `build.py` e `client.py`).
- **Rede:** Acesso via IP (`192.168.5.1`) para a comunicação TCP.

---
*Desenvolvido para fins de aprendizagem*