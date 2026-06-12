extends Node2D

var mostrar_range = false
var pronto_para_atacar = false
var focus = false

var valor_torre = 330

var path1 = 0 # Guarda os upgrades de Knockback Distance
var path2 = 0 # Guarda os upgrades de Chain Quantity

var preços_p1 = [250, 600, 2800, 7000]
var preços_p2 = [250, 600, 2800, 7000]

# Valores base do Scrappy (Alinhados com a tua descrição)
var distancias_knockback = [1.0, 3.0, 5.0, 7.5, 10.0]
var alvos_cadeia = [2, 5, 7, 10, 15]

var P1status = "Knockback: " + str(distancias_knockback[0])
var P2status = "Chain Targets: " + str(alvos_cadeia[0])

func _process(delta: float) -> void:
    if focus == true:
        $ArrowStun.visible = true
    else:
        $ArrowStun.visible = false
    
    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    var inimigos_validos = []

    # 1. Filtra apenas quem é inimigo e está vivo
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings") and is_instance_valid(corpo):
            if corpo.has_method("DMGED"):
                inimigos_validos.append(corpo)

    # Se não há inimigos no alcance, cancela
    if inimigos_validos.size() == 0:
        return

    # 2. SISTEMA DE CADEIA: Pega na quantidade permitida pelo Path2
    var quantidade_maxima = alvos_cadeia[path2]
    var alvos_atingidos = []

    for i in range(min(quantidade_maxima, inimigos_validos.size())):
        alvos_atingidos.append(inimigos_validos[i])

    # 3. Dispara contra os alvos selecionados em cadeia
    atacar_em_cadeia(alvos_atingidos)

func atacar_em_cadeia(alvos):
    # Ativa a animação do Scrappy
    $Scrappy/AnimationPlayer.play("scrppy_Attack")
    $Attack.play()
    # Pega na força de empurrão atual baseado no Path1
    var forca_knockback = distancias_knockback[path1]

    # Aplica o efeito a cada inimigo da corrente
    for inimigo in alvos:
        if is_instance_valid(inimigo):
            # Se o teu inimigo tiver uma função para receber empurrão, chama-a:
            if inimigo.has_method("aplicar_knockback"):
                inimigo.aplicar_knockback(forca_knockback)
            
            # Opcional: Se ele também der um pequenino dano elétrico/robótico
            # inimigo.DMGED(5) 

    pronto_para_atacar = false
    $Timer.start()

# --- SISTEMA DE UPGRADES E HUD ---

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.abrir_menu_upgrade(self)
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        # Troca o asset no HUD para o Scrappy
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Scrappy.png")
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        atualizar_valorTorre()
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")


func aplicar_upgrade(caminho):
    var hud = get_tree().get_first_node_in_group("HUD")
    var label_moedas = hud.get_node("Moedas")

    var dinheiro_atual = int(label_moedas.text)

    var lista_precos = preços_p1 if caminho == 1 else preços_p2
    var nivel_atual = path1 if caminho == 1 else path2

    if nivel_atual >= lista_precos.size(): return false

    var custo = lista_precos[nivel_atual]

    if dinheiro_atual >= custo:
        dinheiro_atual -= custo
        label_moedas.text = str(dinheiro_atual)
        
        if caminho == 1:
            path1 += 1
            match path1:
                1:
                    valor_torre += 250
                2:
                    valor_torre += 600
                3:
                    valor_torre += 2800
                4:
                    valor_torre += 7000
                    auraMAISego()
                    
                    #if skin:
                        #$Scrappy.texture = preload("res://Assets/Bunnies/Skins/Paths/scrappy_skin01.png")
                        #$ScrappyHands_Attack.animation = "ScrappySkin01"
                    #else:
                        #$Scrappy.texture = preload("res://Assets/Bunnies/Paths/Scrappy01.png")
                        #$ScrappyHands_Attack.animation = "Scrappy01"
            
            atualizar_valorTorre()
            # Se o Scrappy tiver uma função própria para recalcular status, podes chamá-la aqui
            
            P1status = "Knockback: " + str(distancias_knockback[path1])
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                
        else:
            path2 += 1
            match path2:
                1:
                    valor_torre += 250
                2:
                    valor_torre += 600        
                3:
                    valor_torre += 2800
                4:
                    valor_torre += 7000
                    auraMAISego()
                    
                    #if skin:
                        #$Scrappy.texture = preload("res://Assets/Bunnies/Skins/Paths/scrappy_skin02.png")
                        #$ScrappyHands_Attack.animation = "ScrappySkin02"
                    #else:
                        #$Scrappy.texture = preload("res://Assets/Bunnies/Paths/Scrappy02.png")
                        #$ScrappyHands_Attack.animation = "Scrappy02"
                        
            atualizar_valorTorre()            
            P2status = "Chain Targets: " + str(alvos_cadeia[path2])
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            
        return true # Retorna sucesso para o HUD
    return false # Retorna falha (não tirou dinheiro)

func auraMAISego():
    $Scrappy.modulate = Color(1, 1, 1)
    if has_node("AURA"):
        $AURA.play("default")
    
    var tween = create_tween()
    tween.tween_property($Scrappy, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property($Scrappy, "modulate", Color(1, 1, 1, 1), 0.4)

func _draw() -> void:
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()

func reset_focus():
    focus = false


func atualizar_valorTorre():
    var hud = get_tree().get_first_node_in_group("HUD")
    var valor_torre_60 : int = int(valor_torre * 0.6)
    
    hud.get_node("HUD_Shop/HudBgDown/Control/PanelSell/precoSell").text = str(valor_torre_60)

func vender_torre():
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    var valor_torre_60 : int = int(valor_torre * 0.6)
    
    moedas.text = str(valor_atual + valor_torre_60)
    
    queue_free()
