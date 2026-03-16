import os
import re
import shutil

def format_project():
    """
    Formata o projeto Lua criando um diretório de build com os arquivos
    concatenados e limpos.
    """
    # Define os caminhos do projeto
    # Assume que o script está na raiz do projeto e os fontes estão em 'src'
    src_dir = "../src"
    build_dir = "build"

    # --- Caminhos dos arquivos ---
    controller_path = os.path.join(src_dir, "controller.lua")
    main_lua_path = os.path.join(src_dir, "main.lua")
    setting_path = os.path.join(src_dir, "setting.lua")

    # Verifica se o diretório de origem e os arquivos existem
    if not os.path.isdir(src_dir):
        print(f"Erro: O diretório de origem '{src_dir}' não foi encontrado.")
        print("Por favor, crie uma pasta 'src' e mova 'controller.lua', 'main.lua', e 'setting.lua' para dentro dela.")
        return

    required_files = [controller_path, main_lua_path, setting_path]
    for f_path in required_files:
        if not os.path.exists(f_path):
            print(f"Erro: Arquivo de origem não encontrado em '{f_path}'.")
            return

    # 1. Cria o diretório de build
    print(f"Criando o diretório de build em '{build_dir}'...")
    os.makedirs(build_dir, exist_ok=True)

    # 2. Copia setting.lua para build/gobal_setting.lua
    build_setting_path = os.path.join(build_dir, "gobal_setting.lua") # Mantendo o nome solicitado
    print(f"Copiando '{setting_path}' para '{build_setting_path}'...")
    shutil.copy(setting_path, build_setting_path)

    # 3. Concatena controller.lua e main.lua
    build_main_path = os.path.join(build_dir, "main.lua")
    print(f"Processando e concatenando arquivos em '{build_main_path}'...")

    # Lê controller.lua
    with open(controller_path, 'r', encoding='utf-8') as f:
        controller_content = f.read()

    # Lê main.lua
    with open(main_lua_path, 'r', encoding='utf-8') as f:
        main_content = f.read()

    # Remove as declarações 'require' usando regex para remover a linha inteira
    controller_content = re.sub(r'^\s*require\("setting"\)\s*?$', '', controller_content, flags=re.MULTILINE)
    main_content = re.sub(r'^\s*require\("controller"\)\s*?$', '', main_content, flags=re.MULTILINE)
    main_content = re.sub(r'^\s*require\("setting"\)\s*?$', '', main_content, flags=re.MULTILINE)

    # Comentários estilizados para separação
    controller_header = "--[[\n    <============== CONTROLLER ===============>\n]]\n\n"
    main_header = "\n--[[\n    <================== MAIN ===================>\n]]\n\n"

    # Concatena os conteúdos, usando .strip() para remover espaços em branco extras
    final_main_content = (
        controller_header +
        controller_content.strip() +
        main_header +
        main_content.strip()
    )

    # Escreve o arquivo main.lua final
    with open(build_main_path, 'w', encoding='utf-8') as f:
        f.write(final_main_content)

    print("\nFormatação do projeto concluída!")
    print(f"Os arquivos de build estão localizados no diretório '{build_dir}'.")

if __name__ == "__main__":
    format_project()