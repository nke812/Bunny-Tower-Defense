extends Node2D

@onready var Anarchist = $Pega/Node2D/Anarchist
@onready var AnarchistHands = $Pega/Node2D/Anarchist_Animations

var mostrar_range = false
var pronto_para_atacar = false

var balas_extras = 0
var pente_de_balas = 5 + balas_extras
var balas = pente_de_balas

var dmg_Anarchist = 2

var MysticalBuff = false

var posicionado = false

var valor_torre = 500

var focus = false

var path1 = 0
var path2 = 0
var preços_p1 = [500, 1300, 2000, 4550]
var preços_p2 = [500, 1300, 2000, 4550]

var P1status = "Damage: " + str(dmg_Anarchist)
var P2status = "Reload Speed: 3s"
var BuffStatus1 = "Mag: +0"
var BuffStatus2 = "ATK Speed: +0s"

var StatusExtra = str(balas)


func _process(delta: float) -> void :
    var spawner = get_tree().get_first_node_in_group("spawner")
    var hud = get_tree().get_first_node_in_group("HUD")
    
    if balas <= 0:
        if focus:
            hud.get_node("HUD_Shop/HudBgDown/AmmunitionIcon").texture = preload("res://Assets/Others/UI_Assets/AmmunitionIconReloading.png")
            hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = "..."
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
    var texture = Anarchist.texture.resource_path
    var hud = get_tree().get_first_node_in_group("HUD")
    
    if alvo.has_method("DMGED"):
        $Pega/Node2D/Anarchist/AnimationPlayer.play("AttackAnarchist")
        $Shot.play()
        
        match texture:
            "res://Assets/Bunnies/Animations/AnarchistAttackIdle.png": AnarchistHands.play("Attack")
            "res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png": AnarchistHands.play("Attack01")
            "res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png": AnarchistHands.play("Attack02")
            
        
        alvo.DMGED(dmg_Anarchist)
        pronto_para_atacar = false
        balas -= 1
        
        if focus:
            hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        $Timer.start()

func _on_reload_timeout() -> void :
    var texture = Anarchist.texture.resource_path
    var hud = get_tree().get_first_node_in_group("HUD")
    
    balas = pente_de_balas
    if focus:
        hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
    $Reload2.play()
    
    match texture:
        "res://Assets/Bunnies/Animations/AnarchistAttackIdle.png": AnarchistHands.play("Reload")
        "res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png": AnarchistHands.play("Reload01")
        "res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png": AnarchistHands.play("Reload02")
    
    
    pronto_para_atacar = false


func receber_buff_mystical(mystical):
    var hud = get_tree().get_first_node_in_group("HUD")
    var atk_speed_percent = 0
    
    if posicionado and MysticalBuff == true:
        match mystical:
            0: 
                balas_extras = 1
                $Timer.wait_time = 1.3
                atk_speed_percent = 1.3
            1: 
                balas_extras = 2
                $Timer.wait_time = 1.1
                atk_speed_percent = 1.1
            2: 
                balas_extras = 3
                $Timer.wait_time = 1.0
                atk_speed_percent = 1.0
            3: 
                balas_extras = 4
                $Timer.wait_time = 0.8
                atk_speed_percent = 0.8
            4: 
                balas_extras = 5
                $Timer.wait_time = 0.7
                atk_speed_percent = 0.7
    else:
        balas_extras = 0
        $Timer.wait_time = 1.5
        atk_speed_percent = 0

    
    pente_de_balas = 5 + int(balas_extras)
    balas = pente_de_balas
    
    BuffStatus1 = "Pente: +" + str(balas_extras)
    BuffStatus2 = "Atk Speed: " + str(atk_speed_percent) + "s"
    
    if focus and hud:
        hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
        hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)

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
    
    hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = false
    hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = false
    
    focus = false

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    var hud = get_tree().get_first_node_in_group("HUD")
    hud.get_node("HUD_Shop/BuffStatus").visible = false
    focus = true
    
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        hud.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        hud.get_node("HUD_Shop/HudBgDown/AmmunitionIcon").visible = true
        
        hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
        hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Anarchist.png")
        atualizar_valorTorre()
        
        if MysticalBuff == true:
            hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
            hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
            hud.get_node("HUD_Shop/BuffStatus").visible = true
        
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
                    dmg_Anarchist = 4
                    pente_de_balas += 2
                    valor_torre += 500
                2: 
                    dmg_Anarchist = 7
                    pente_de_balas += 2
                    valor_torre += 1300
                    
                3: 
                    dmg_Anarchist = 12
                    pente_de_balas += 2
                    valor_torre += 2000
                    
                4: 
                    dmg_Anarchist = 17
                    pente_de_balas += 5
                    valor_torre += 4550
                
                    auraMAISego()
                    Anarchist.texture = preload("res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png")
                    AnarchistHands.animation = "Attack01"
                        
            P1status = "Damage: " + str(dmg_Anarchist)
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
            atualizar_valorTorre()
        else:
            path2 += 1
            match path2:
                1: 
                    $Reload.wait_time = 2.5
                    pente_de_balas += 2
                    valor_torre += 500
                    
                2: 
                    $Reload.wait_time = 2.1
                    pente_de_balas += 2
                    valor_torre += 1300
                    
                3: 
                    $Reload.wait_time = 1.7
                    pente_de_balas += 2
                    valor_torre += 2000
                4: 
                    $Reload.wait_time = 1.0
                    pente_de_balas += 5
                    valor_torre += 4550
                    
                    auraMAISego()
                    Anarchist.texture = preload("res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png")
                    AnarchistHands.animation = "Attack02"
                    
            atualizar_valorTorre()
            P2status = "Reload Speed: " + str($Reload.wait_time) + "s"
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        return true
    return false
    
func auraMAISego():
    Anarchist.modulate = Color(1, 1, 1)
    AnarchistHands.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()


    tween.tween_property(Anarchist, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.parallel().tween_property(AnarchistHands, "modulate", Color(2, 2, 2, 1), 0.3)
 
    tween.tween_property(Anarchist, "modulate", Color(1, 1, 1, 1), 0.4)
    tween.parallel().tween_property(AnarchistHands, "modulate", Color(1, 1, 1, 1), 0.4)


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
