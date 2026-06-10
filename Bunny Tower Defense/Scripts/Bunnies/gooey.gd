extends Node2D

var mostrar_range = false
var pronto_para_atacar = false
var TimeSlimed = 3.0

var focus = false
var skin = false

var Goo_Color = "Green_Goo"

var path1 = 0
var path2 = 0
var preços_p1 = [250, 600, 2800, 7000]
var preços_p2 = [250, 600, 2800, 7000]

var P1status = "Stun Time: " + str(TimeSlimed)
var P2status = "Speed ATK: 2.5s"

func _process(delta: float) -> void :
    
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
    var alvo_final = null
    var primeiro_fantasma = null

    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            # Guardamos o primeiro fantasma que aparecer, caso todos estejam stunados
            if primeiro_fantasma == null:
                primeiro_fantasma = corpo
            
            # Se acharmos um que NÃO está stunado, ESSE é o alvo ideal
            if not corpo.goo_stun:
                alvo_final = corpo
                break 

    # Se não achou ninguém limpo, mas existe algum fantasma na área...
    if alvo_final == null and primeiro_fantasma != null:
        alvo_final = primeiro_fantasma

    # Só ataca se realmente encontrou um fantasma
    if alvo_final != null:
        atacar(alvo_final)

# No atacar(alvo) do Gooey
func atacar(alvo):
    if alvo.has_method("gooey_stun"):
        $Gooey/AnimationPlayer.play("Gooey_Attack")
        
        # Enviamos o TimeSlimed E a Goo_Color deste coelho específico
        alvo.gooey_stun(TimeSlimed, Goo_Color)
        
        pronto_para_atacar = false
        $Timer.start()


func _draw() -> void :
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

func mudar_skin():
    skin = !skin
    
    var path = $Gooey.texture.resource_path
    match path:
        "res://Assets/Bunnies/Gooey.png":
            $Gooey.texture = load("res://Assets/Bunnies/Skins/Void.png")
            Goo_Color = "Void_Goo"
            
        "res://Assets/Bunnies/Skins/Void.png":
            $Gooey.texture = load("res://Assets/Bunnies/Gooey.png")
            Goo_Color = "Green_Goo"
            
        "res://Assets/Bunnies/Paths/Gooey01.png":
            $Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void01.png")
            Goo_Color = "Void_Goo"
            
        "res://Assets/Bunnies/Skins/Paths/Void01.png":
            $Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey01.png")
            Goo_Color = "Blue_Goo"
            
        "res://Assets/Bunnies/Paths/Gooey02.png":
            $Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void02.png")
            Goo_Color = "Void_Goo"
            
        "res://Assets/Bunnies/Skins/Paths/Void02.png":
            $Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey02.png")
            Goo_Color = "Purple_Goo"

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Gooey.png")
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")
    

func aplicar_upgrade(caminho):
    var hud = get_tree().get_first_node_in_group("HUD")
    var label_moedas = hud.get_node("Moedas")

# 1. Transformar o texto da Label em número para poder fazer contas
    var dinheiro_atual = int(label_moedas.text)

# 2. Definir o custo baseado na Array e no nível atual
    var lista_precos = preços_p1 if caminho == 1 else preços_p2
    var nivel_atual = path1 if caminho == 1 else path2

    if nivel_atual >= lista_precos.size(): return false

    var custo = lista_precos[nivel_atual]

# 3. A VERIFICAÇÃO E SUBTRAÇÃO
    if dinheiro_atual >= custo:
    # TIRA O DINHEIRO DO NÚMERO QUE LEMOS
        dinheiro_atual -= custo
    
    # ATUALIZA A LABEL COM O NOVO VALOR (Transformando de volta para texto)
        label_moedas.text = str(dinheiro_atual)
    
    # Continua com a lógica do upgrade...
        
        # 4. Aumenta o nível e aplica o match (dano, skin, etc.)
        if caminho == 1:
            path1 += 1
            match path1:
                1: 
                    TimeSlimed = 3.5
                    P1status = "Stun Time: " + str(TimeSlimed)
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                2: 
                    TimeSlimed = 4.2
                    P1status = "Stun Time: " + str(TimeSlimed)
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                3: 
                    TimeSlimed = 5.0
                    P1status = "Stun Time: " + str(TimeSlimed)
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                4: 
                    TimeSlimed = 8.0
                    P1status = "Stun Time: " + str(TimeSlimed)
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    auraMAISego()
                    
                    if skin:
                        $Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void01.png")
                        Goo_Color = "Void_Goo"
                    else:
                        $Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey01.png")
                        Goo_Color = "Blue_Goo"
        else:
            path2 += 1
            match path2:
                1: 
                    $Timer.wait_time = 2.1
                    
                    P2status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                2: 
                    $Timer.wait_time = 1.7
                    
                    P2status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                3: 
                    $Timer.wait_time = 1.3
                    
                    P2status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                4: 
                    $Timer.wait_time = 0.5
                    
                    P2status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    auraMAISego()
                    
                    if skin:
                        $Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void02.png")
                        Goo_Color = "Void_Goo"
                    else:
                        $Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey02.png")
                        Goo_Color = "Purple_Goo"
            
        return true
    return false
            
            
func auraMAISego():
    $Gooey.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()


    tween.tween_property($Gooey, "modulate", Color(2, 2, 2, 1), 0.3)
 
    tween.tween_property($Gooey, "modulate", Color(1, 1, 1, 1), 0.4)
