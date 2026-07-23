extends Node2D
#
#func _ready():
    ## Verifica se existe um save para carregar ao entrar no mapa
    #if SaveManager.tem_save():
        #carregar_torres_do_save()
#
#func carregar_torres_do_save():
    #var dados = SaveManager.carregar_jogo()
    #var torres_guardadas = dados.get("torres", [])
    #
    #for t_data in torres_guardadas:
        ## 1. Carrega a cena da torre (ex: "res://Scenes/Towers/rookie.tscn")
        #var cena_torre = load(t_data["tipo"])
        #if cena_torre:
            #var nova_torre = cena_torre.instantiate()
            #
            ## 2. Define a posição exata guardada no JSON
            #nova_torre.global_position = Vector2(t_data["pos_x"], t_data["pos_y"])
            #
            ## 3. Restaura os níveis dos upgrades
            #nova_torre.path1 = t_data.get("path1_nivel", 0)
            #nova_torre.path2 = t_data.get("path2_nivel", 0)
            #
            ## 4. Se tiveres uma função na torre para atualizar o visual/stats pós-upgrade:
            #if nova_torre.has_method("aplicar_upgrades_carregados"):
                #nova_torre.aplicar_upgrades_carregados()
                #
            ## 5. Adiciona a torre de volta à árvore de cenas do mapa atual
            #add_child(nova_torre)
            #print("Torre reposta no mapa: ", t_data["tipo"])
