extends Node2D

var mostrar_range = false
var pronto_para_atacar = false
var pente_de_balas = 5
var balas = pente_de_balas

var dmg_Anarchist = 2
var posicionado = false

#var skin = false

var focus = false

var path1 = 0
var path2 = 0
var preços_p1 = [1200, 3000, 7000, 10000]
var preços_p2 = [1200, 3000, 7000, 10000]

var P1status = "Damage: " + str(dmg_Anarchist)
var P2status = "Reload Speed: 3s"
var StatusExtra = str(balas)


func _process(delta: float) -> void :
    var spawner = get_tree().get_first_node_in_group("spawner")
    var hud = get_tree().get_first_node_in_group("HUD")
    
    if balas <= 0:
        hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = "Recarregando..."
        if spawner.ronda_a_decorrer:
            $Reload.paused = false
            if $Reload.is_stopped():
                $Reload.start()
                pronto_para_atacar = false
        else:
            $Reload.paused = true

    $ProgressBar.max_value = $Reload.wait_time
    $ProgressBar.value = $Reload.wait_time - $Reload.time_left
    $ProgressBar.visible = balas <= 0
    
    if focus == true:
        $ArrowDps.visible = true

    else:
        $ArrowDps.visible = false



    if $Timer.is_stopped() and $Reload.is_stopped() and balas > 0 and spawner.ronda_a_decorrer:
        pronto_para_atacar = true
    else:
        pronto_para_atacar = false

    if pronto_para_atacar:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            atacar(corpo)
        break

func atacar(alvo):
    var texture = $Anarchist.texture.resource_path
    var hud = get_tree().get_first_node_in_group("HUD")
    
    if alvo.has_method("DMGED"):
        $Anarchist/AnimationPlayer.play("Anarchist_Attack")
        $Shot.play()
        
        match texture:
            "res://Assets/Bunnies/Animations/AnarchistAttackIdle.png": $Anarchist_Animations.play("Attack")
            "res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png": $Anarchist_Animations.play("Attack01")
            "res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png": $Anarchist_Animations.play("Attack02")
            
        
        alvo.DMGED(dmg_Anarchist)
        pronto_para_atacar = false
        
        balas -= 1
        hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        $Timer.start()

func _on_reload_timeout() -> void :
    var texture = $Anarchist.texture.resource_path
    var hud = get_tree().get_first_node_in_group("HUD")
    
    balas = pente_de_balas
    hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
    $Reload2.play()
    
    match texture:
        "res://Assets/Bunnies/Animations/AnarchistAttackIdle.png": $Anarchist_Animations.play("Reload")
        "res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png": $Anarchist_Animations.play("Reload01")
        "res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png": $Anarchist_Animations.play("Reload02")
    
    
    pronto_para_atacar = false


func receber_buff_mystical(mystical):
    if posicionado:
        match mystical:
            0: 
                pente_de_balas += 1
            1: 
                pente_de_balas += 1
            2: 
                pente_de_balas += 1
            3: 
                pente_de_balas += 1
            4: 
                pente_de_balas += 1



func _draw() -> void :
    if mostrar_range:
        var shape = $Range / CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range / CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()
    
func reset_focus():
    var hud = get_tree().get_first_node_in_group("HUD")
    hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = ""
    hud.get_node("HUD_Shop/HudBgDown/AmmunitionIcon").visible = false
    focus = false

#func mudar_skin():
    #skin = !skin
    #
    #var texture = $Rookie.texture.resource_path
    #match texture:
        #"res://Assets/Bunnies/Animations/RookieAttackIdle.png":
            #$Rookie.texture = preload("res://Assets/Bunnies/Skins/buny.png")
            #$RookieHands_Attack.animation = "RookieSkin"
            #
        #"res://Assets/Bunnies/Skins/buny.png":
            #$Rookie.texture = preload("res://Assets/Bunnies/Animations/RookieAttackIdle.png")
            #$RookieHands_Attack.animation = "Rookie"
            #
        #"res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png":
            #$Rookie.texture = preload("res://Assets/Bunnies/Skins/Paths/buny01.png")
            #$RookieHands_Attack.animation = "RookieSkin01"
            #
        #"res://Assets/Bunnies/Skins/Paths/buny01.png":
            #$Rookie.texture = preload("res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png")
            #$RookieHands_Attack.animation = "Rookie01"
            #
        #"res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png":
            #$Rookie.texture = preload("res://Assets/Bunnies/Skins/Paths/buny02.png")
            #$RookieHands_Attack.animation = "RookieSkin02"
            #
        #"res://Assets/Bunnies/Skins/Paths/buny02.png":
            #$Rookie.texture = preload("res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png")
            #$RookieHands_Attack.animation = "Rookie02"

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    var hud = get_tree().get_first_node_in_group("HUD")
    
    focus = true
    
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        hud.get_node("HUD_Shop/HudBgDown/AmmunitionIcon").visible = true
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Anarchist.png")
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

    if dinheiro_atual >= custo:
        dinheiro_atual -= custo
    
        label_moedas.text = str(dinheiro_atual)
    
        if caminho == 1:
            path1 += 1
            match path1:
                1: 
                    dmg_Anarchist = 4
                    pente_de_balas += 2
                    P1status = "Damage: " + str(dmg_Anarchist)
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                2: 
                    dmg_Anarchist = 7
                    pente_de_balas += 2
                    P1status = "Damage: " + str(dmg_Anarchist)
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                3: 
                    dmg_Anarchist = 10
                    pente_de_balas += 2
                    P1status = "Damage: " + str(dmg_Anarchist)
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                4: 
                    dmg_Anarchist = 17
                    pente_de_balas += 5
                    P1status = "Damage: " + str(dmg_Anarchist)
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                
                    auraMAISego()
                    $Anarchist.texture = preload("res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png")
                    $Anarchist_Animations.animation = "Attack01"
                    
                    #if skin:
                        #$Rookie.texture = preload("res://Assets/Bunnies/Skins/Paths/buny01.png")
                        #$RookieHands_Attack.animation = "RookieSkin01"
                    #else:
                        #$Rookie.texture = preload("res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png")
                        #$RookieHands_Attack.animation = "Rookie01"
        else:
            path2 += 1
            match path2:
                1: 
                    $Reload.wait_time = 0.8
                    pente_de_balas += 2
                    P2status = "Reload Speed: " + str($Reload.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                2: 
                    $Reload.wait_time = 0.6
                    pente_de_balas += 2
                    P2status = "Reload Speed: " + str($Reload.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                3: 
                    $Reload.wait_time = 0.4
                    pente_de_balas += 2
                    P2status = "Reload Speed: " + str($Reload.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                4: 
                    $Reload.wait_time = 0.2
                    pente_de_balas += 5
                    P2status = "Reload Speed: " + str($Reload.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                    auraMAISego()
                    $Anarchist.texture = preload("res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png")
                    $Anarchist_Animations.animation = "Attack02"
                    
                    
                    #if skin:
                        #$Rookie.texture = preload("res://Assets/Bunnies/Skins/Paths/buny02.png")
                        #$RookieHands_Attack.animation = "RookieSkin02"
                    #else:
                        #$Rookie.texture = preload("res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png")
                        #$RookieHands_Attack.animation = "Rookie02"
            
        return true
    return false
    
func auraMAISego():
    $Anarchist.modulate = Color(1, 1, 1)
    $Anarchist_Animations.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()


    tween.tween_property($Anarchist, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.parallel().tween_property($Anarchist_Animations, "modulate", Color(2, 2, 2, 1), 0.3)
 
    tween.tween_property($Anarchist, "modulate", Color(1, 1, 1, 1), 0.4)
    tween.parallel().tween_property($Anarchist_Animations, "modulate", Color(1, 1, 1, 1), 0.4)
