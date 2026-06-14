extends Node2D


@onready var Ghostling = preload("res://Scenes/Enemies/Ghostling/ghostling.tscn")
@onready var Ghazt = preload("res://Scenes/Enemies/Ghostling/ghazt.tscn")
@onready var Ghoul = preload("res://Scenes/Enemies/Ghostling/ghoul.tscn")
@onready var Ghaztling = preload("res://Scenes/Enemies/Ghostling/ghaztling.tscn")


@onready var Enhanced_Ghaztling = preload("res://Scenes/Enemies/Ghostling/enhanced_ghaztling.tscn")
@onready var Enhanced_Ghoul = preload("res://Scenes/Enemies/Ghostling/enhanced_ghoul.tscn")
@onready var Unholy_Phantasm = preload("res://Scenes/Enemies/Ghostling/unholy_phantasm.tscn")
@onready var Brute = preload("res://Scenes/Enemies/Ghostling/brute.tscn")


@onready var Leviathan = preload("res://Scenes/Enemies/Bosses/Leviathan.tscn")



@onready var Undead_Ghostling = preload("res://Scenes/Enemies/Ghostling/undead_ghostling.tscn")

var rodada_atual = 1
var inimigos_vivos = 0
var vaga_atual = []
var ronda_a_decorrer = false

var autoplay = false


func _process(_delta):
    var botao_start = get_tree().get_first_node_in_group("start_button")

    if botao_start:
        if inimigos_vivos > 0 or not $Timer.is_stopped():
            botao_start.disabled = true
        else:
            botao_start.disabled = false

func iniciar_vaga():
    ronda_a_decorrer = true
    

    match rodada_atual:
        # --- FASE 1: O GRUPO BÁSICO (Rondas 1-10) ---
        
        1: 
            $"../StarRound".play()
            #vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
            vaga_atual = [Leviathan]
            #vaga_atual = [Ghostling]
        
        2: vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghazt, Ghazt, Ghostling, Ghostling, Ghazt, Ghazt]
        3: vaga_atual = [Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt]
        4: vaga_atual = [Ghostling, Ghoul, Ghostling, Ghoul, Ghostling, Ghoul, Ghostling, Ghoul]
        5: vaga_atual = [Ghazt, Ghazt, Ghoul, Ghostling, Ghostling, Ghoul, Ghazt, Ghazt]
        6: vaga_atual = [Ghazt, Ghazt, Ghazt, Ghaztling, Ghazt, Ghazt, Ghazt, Ghaztling]
        7: vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
        8: vaga_atual = [Ghaztling, Ghazt, Ghazt, Ghaztling, Ghazt, Ghazt, Ghaztling, Ghazt, Ghazt]
        9: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghostling, Ghostling, Ghostling, Ghostling, Ghoul, Ghoul]
        10: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]

        # --- FASE 2: HORDAS MISTAS E QUANTIDADE (Rondas 11-25) ---
        11: vaga_atual = [Ghazt, Ghazt, Ghostling, Ghostling, Ghazt, Ghazt, Ghostling, Ghostling, Ghoul, Ghoul, Ghoul]
        12: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghostling, Ghostling, Ghostling, Ghaztling, Ghaztling, Ghaztling, Ghostling, Ghostling]
        13: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul]
        14: vaga_atual = [Ghazt, Ghaztling, Ghazt, Ghaztling, Ghazt, Ghaztling, Ghazt, Ghaztling, Ghazt, Ghaztling, Ghazt, Ghaztling]
        15: vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
        16: vaga_atual = [Ghoul, Ghoul, Ghaztling, Ghaztling, Ghoul, Ghoul, Ghaztling, Ghaztling, Ghoul, Ghoul, Ghaztling, Ghaztling]
        17: vaga_atual = [Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt]
        18: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]
        19: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghazt, Ghazt, Ghazt, Ghazt, Ghostling, Ghostling, Ghostling, Ghostling]
        20: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]
        21: vaga_atual = [Ghazt, Ghostling, Ghazt, Ghostling, Ghoul, Ghostling, Ghoul, Ghostling, Ghaztling, Ghostling, Ghaztling, Ghostling]
        22: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul]
        23: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
        24: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghazt, Ghazt, Ghazt, Ghostling, Ghostling, Ghostling, Ghaztling, Ghaztling, Ghaztling]
        25: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]

        # --- FASE 3: INTRODUÇÃO LENTA DE ELITES (Rondas 26-37) ---
        26: vaga_atual = [Enhanced_Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul] # Apenas 1 melhorado
        27: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Enhanced_Ghaztling]
        28: vaga_atual = [Enhanced_Ghoul, Ghoul, Ghoul, Enhanced_Ghoul, Ghoul, Ghoul, Ghoul]
        29: vaga_atual = [Unholy_Phantasm, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
        30: vaga_atual = [Enhanced_Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Enhanced_Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]
        31: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul]
        32: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]
        33: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]
        34: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul]
        35: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Ghostling, Ghostling, Ghostling, Ghostling]
        36: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling]
        37: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul]

        # --- FASE 4: O APOCALIPSE DOS BRUTES (Rondas 38-50) ---
        38: vaga_atual = [Brute, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Ghoul, Ghoul, Ghoul, Ghoul]
        39: vaga_atual = [Brute, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]
        40: vaga_atual = [Brute, Brute, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        41: vaga_atual = [Brute, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul]
        42: vaga_atual = [Brute, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling]
        43: vaga_atual = [Brute, Brute, Brute, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul]
        44: vaga_atual = [Brute, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        45: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul]
        46: vaga_atual = [Brute, Brute, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        47: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute]
        48: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Brute, Brute]
        49: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling]
        50: vaga_atual = [Leviathan]

    $Timer.start()


func _on_timer_timeout():
    if vaga_atual.size() > 0:

        var cena_do_inimigo = vaga_atual.pop_front()

        var novo_fantasma = cena_do_inimigo.instantiate()
        get_node("../Path2D").add_child(novo_fantasma)

        inimigos_vivos += 1
    else:
        $Timer.stop()


func inimigo_morreu():
    
    
    inimigos_vivos -= 1

    if inimigos_vivos < 0:
        inimigos_vivos = 0

    print("Inimigos no mapa: ", inimigos_vivos)

    if vaga_atual.size() == 0 and inimigos_vivos == 0 and ronda_a_decorrer:
        ronda_a_decorrer = false
        

        rodada_atual += 1
        atualizar_contador_rondas()
        
        if autoplay == true:

            iniciar_vaga()

        var moedas_no = get_tree().current_scene.find_child("Moedas")
        if moedas_no:
            moedas_no.text = str(int(moedas_no.text) + 50 + rodada_atual + 75)

func atualizar_contador_rondas() -> void :
    var contador_no = get_tree().get_first_node_in_group("Round_Counter")
    contador_no.text = str(rodada_atual)
