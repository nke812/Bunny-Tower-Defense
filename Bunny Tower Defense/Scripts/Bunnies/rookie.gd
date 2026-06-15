extends Node2D

var skin = false

var valor_torre = 115

var MysticalBuff = false
var posicionado = false

var mostrar_range = false
var pronto_para_atacar = false

var dmg_Mystical = 0
var dmg_Rookie = 1
var dmg_total = dmg_Rookie + dmg_Mystical

var focus = false

var path1 = 0
var path2 = 0
var preços_p1 = [140, 425, 2400, 5500]
var preços_p2 = [140, 425, 2400, 5500]

var P1status = "Damage: " + str(dmg_Rookie)
var P2status = "Speed ATK: 1s"


func _process(delta: float) -> void: 
    if focus == true:
        $ArrowDps.visible = true
    else:
        $ArrowDps.visible = false

    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar == true:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            atacar(corpo)
        break

func atacar(alvo):
    if alvo.has_method("DMGED"):
        $Node2D/Rookie/AnimationPlayer.play("RookieAttack")
        $Node2D/RookieHands_Attack.play()
        
        var sons_hit = [$Hit, $Hit2, $Hit3]
        var som_sorteado = sons_hit[randi() % sons_hit.size()]
        som_sorteado.play()
        
        alvo.DMGED(dmg_total)
        pronto_para_atacar = false
        $Timer.start()

func receber_buff_mystical(mystical):
    var dmg_buff = 0
    var scale_buff = Vector2(1.0, 1.0) 
    
    match mystical:
        0: 
            dmg_buff = 0
            scale_buff = Vector2(1.1, 1.1)
        1: 
            dmg_buff = 1
            scale_buff = Vector2(1.2, 1.2)
        2: 
            dmg_buff = 2
            scale_buff = Vector2(1.3, 1.3)
        3: 
            dmg_buff = 3
            scale_buff = Vector2(1.4, 1.4)
        4: 
            dmg_buff = 4
            scale_buff = Vector2(1.5, 1.5)
    
    
    if dmg_buff > dmg_Mystical:
        dmg_Mystical = dmg_buff
        $Range/CollisionRange.scale = scale_buff
        
        atualizar_dmg()
        P1status = "Damage: " + str(dmg_total)
        
        var hud = get_tree().get_first_node_in_group("HUD")
        if hud and focus == true:
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        
func _draw() -> void :
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()

func reset_focus():
    focus = false

func mudar_skin():
    skin = !skin
    $SkinChange.play("ChangeSkin")
    
    
    var texture = $Node2D/Rookie.texture.resource_path
    match texture:
        "res://Assets/Bunnies/Animations/RookieAttackIdle.png":
            $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Skins/buny.png")
            $Node2D/RookieHands_Attack.animation = "RookieSkin"
            
        "res://Assets/Bunnies/Skins/buny.png":
            $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Animations/RookieAttackIdle.png")
            $Node2D/RookieHands_Attack.animation = "Rookie"
            
        "res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png":
            $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Skins/Paths/buny01.png")
            $Node2D/RookieHands_Attack.animation = "RookieSkin01"
            
        "res://Assets/Bunnies/Skins/Paths/buny01.png":
            $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png")
            $Node2D/RookieHands_Attack.animation = "Rookie01"
            
        "res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png":
            $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Skins/Paths/buny02.png")
            $Node2D/RookieHands_Attack.animation = "RookieSkin02"
            
        "res://Assets/Bunnies/Skins/Paths/buny02.png":
            $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png")
            $Node2D/RookieHands_Attack.animation = "Rookie02"

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Rookie.png")
        atualizar_valorTorre()
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
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
                    dmg_Rookie = 2
                    valor_torre += 140
                2: 
                    dmg_Rookie = 3
                    valor_torre += 425
                3: 
                    dmg_Rookie = 5
                    valor_torre += 2400
                4: 
                    dmg_Rookie = 8
                    valor_torre += 5500
                    auraMAISego()
                    
                    if skin:
                        $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Skins/Paths/buny01.png")
                        $Node2D/RookieHands_Attack.animation = "RookieSkin01"
                    else:
                        $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png")
                        $Node2D/RookieHands_Attack.animation = "Rookie01"
            
            atualizar_valorTorre()
            atualizar_dmg()    
            P1status = "Damage: " + str(dmg_total)
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                
        else:
            path2 += 1
            match path2:
                1: 
                    $Timer.wait_time = 0.8
                    valor_torre += 140
                2: 
                    $Timer.wait_time = 0.6
                    valor_torre += 425        
                3:
                    $Timer.wait_time = 0.4
                    valor_torre += 2400
                4: 
                    $Timer.wait_time = 0.2
                    valor_torre += 5500
                    auraMAISego()
                    
                    if skin:
                        $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Skins/Paths/buny02.png")
                        $Node2D/RookieHands_Attack.animation = "RookieSkin02"
                    else:
                        $Node2D/Rookie.texture = preload("res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png")
                        $Node2D/RookieHands_Attack.animation = "Rookie02"
                        
            atualizar_valorTorre()            
            P2status = "Speed ATK: " + str($Timer.wait_time) + "s"
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            
        return true # Retorna sucesso para o HUD
    return false # Retorna falha (não tirou dinheiro)
    
    
func atualizar_dmg():
    dmg_total = dmg_Rookie + dmg_Mystical
    
func auraMAISego():
    $Node2D/Rookie.modulate = Color(1, 1, 1)
    $Node2D/RookieHands_Attack.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()


    tween.tween_property($Node2D/Rookie, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.parallel().tween_property($Node2D/RookieHands_Attack, "modulate", Color(2, 2, 2, 1), 0.3)
 
    tween.tween_property($Node2D/Rookie, "modulate", Color(1, 1, 1, 1), 0.4)
    tween.parallel().tween_property($Node2D/RookieHands_Attack, "modulate", Color(1, 1, 1, 1), 0.4)




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
