#extends Node
#
#const SAVE_PATH = "user://save_game.json"
#
#func guardar_jogo(dados_jogador: Dictionary, torres: Array) -> void:
    #var dados_completos = {
        #"jogador": dados_jogador,
        #"torres": torres
    #}
    #
    #var ficheiro = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    #if ficheiro:
        #var json_string = JSON.stringify(dados_completos, "\t")
        #ficheiro.store_string(json_string)
        #ficheiro.close()
#
#func carregar_jogo() -> Dictionary:
    #if not FileAccess.file_exists(SAVE_PATH):
        #return {} # Retorna vazio se não houver save
        #
    #var ficheiro = FileAccess.open(SAVE_PATH, FileAccess.READ)
    #if ficheiro:
        #var json_string = ficheiro.get_as_text()
        #ficheiro.close()
        #
        #var json = JSON.new()
        #var erro = json.parse(json_string)
        #if erro == OK:
            #return json.get_data()
            #
    #return {}
#
#func tem_save() -> bool:
    #return FileAccess.file_exists(SAVE_PATH)


#OK o save ta a guardar (/home/nke812/.local/share/godot/app_userdata/Bunny_Tower_Defense/)
#mas n sei pq ele ta a por o rookie (o unico funcional com saves) está a spawnar todos bugados (nos Upgrades)
#e tbm um pouco mais a cima, n sei oq é mas suponho q ele n esteja a carregar o script? sla
