extends Node2D

var pronto_para_atacar = false
var mostrar_range = false

var valor_torre = 250

var contagem_ult = 0
var dmg_Slasher = 3

var focus = false
var skin = false 

var path1 = 0
var path2 = 0
var preços_p1 = [400, 1500, 3500, 7500]
var preços_p2 = [400, 1500, 3500, 7500]


var P1status = "Speed ATK: 3s"
var P2status = "Range: 1"

func _ready() -> void:
    verificar_posicao_skin()


func _process(delta: float) -> void :
    $ProgressBar.value = contagem_ult
    $ProgressBar/ProgressBar.value = contagem_ult

    if $Timer.is_stopped():
        pronto_para_atacar = true


    if pronto_para_atacar == true:
        verificar_e_atacar()
        
    if focus == true:
        $ArrowDps.visible = true
    else:
        $ArrowDps.visible = false

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    
    if contagem_ult >= 20:
        # --- ULTIMATE (SUPER GOLPE) ---
        for corpo in corpos:
            if corpo.is_in_group("Ghostlings"):
                atacar(corpo)
                break         
    else:
        for corpo in corpos:
            if corpo.is_in_group("Ghostlings"):
                atacar(corpo)
                break

func atacar(alvo):
    if alvo.has_method("DMGED"):
        $Slasher/AnimationPlayer.play("LuckyAction")
        $SlasherAttackEffect.play()
        
        $SlasherAttack.play()
        $Slash.play()
        
        contagem_ult += 3
        verificar_ult()
     
            
        if contagem_ult >= 20: 
                # Se a contagem subiu muito, dá mais um bónus de dano ao mesmo gajo
            alvo.DMGED(dmg_Slasher * 2) 
            $Slash_Ult.play()
            contagem_ult = 0
            verificar_ult()
            
        else:
            # Ataque básico normal
            alvo.DMGED(dmg_Slasher)

        pronto_para_atacar = false
        $Timer.start()

func verificar_ult():
    if contagem_ult >= 35 or contagem_ult == 0:
        $Slasher/Ult.visible = false
        $Slasher/AppearUlt.play_backwards()
        

    elif contagem_ult > 20:
        if not $Slasher/Ult.visible and not $Slasher/AppearUlt.is_playing():
            $Slasher/AppearUlt.play()
            await $Slasher/AppearUlt.animation_finished
            $Slasher/Ult.visible = true
            $Slasher/Ult.play()


func _draw() -> void :
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_insp_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_insp_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()

func reset_focus():
    focus = false



func mudar_skin():
    skin = !skin
    
    verificar_posicao_skin()
    
    
    var texture = $Slasher.texture.resource_path
    match texture:
        "res://Assets/Bunnies/Animations/SlasherAttackIdle.png":
            $Slasher.texture = preload("res://Assets/Bunnies/Animations/Skins/CanelaAttackIdle.png")
            $SlasherAttack.animation = "SlasherSkin"
            
            
        "res://Assets/Bunnies/Animations/Skins/CanelaAttackIdle.png":
            $Slasher.texture = preload("res://Assets/Bunnies/Animations/SlasherAttackIdle.png")
            $SlasherAttack.animation = "Slasher"
            
            
        "res://Assets/Bunnies/Animations/Paths/Slasher01AttackIdle.png":
            $Slasher.texture = preload("res://Assets/Bunnies/Animations/Skins/Paths/Canela01AttackIdle.png")
            $SlasherAttack.animation = "SlasherSkin01"
            
        "res://Assets/Bunnies/Animations/Skins/Paths/Canela01AttackIdle.png":
            $Slasher.texture = preload("res://Assets/Bunnies/Animations/Paths/Slasher01AttackIdle.png")
            $SlasherAttack.animation = "Slasher01"
            
        "res://Assets/Bunnies/Animations/Paths/Slasher02AttackIdle.png":
            $Slasher.texture = preload("res://Assets/Bunnies/Animations/Skins/Paths/Canela02AttackIdle.png")
            $SlasherAttack.animation = "SlasherSkin02"
            
        "res://Assets/Bunnies/Animations/Skins/Paths/Canela02AttackIdle.png":
            $Slasher.texture = preload("res://Assets/Bunnies/Animations/Paths/Slasher02AttackIdle.png")
            $SlasherAttack.animation = "Slasher02"

func _on_insp_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Slasher.png")
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
                    $Timer.wait_time = 2.7
                    valor_torre += 400
                    P1status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                2: 
                    $Timer.wait_time = 2.3
                    valor_torre += 1500
                    P1status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                
                3: 
                    $Timer.wait_time = 1.5
                    valor_torre += 3500
                    P1status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                4: 
                    $Timer.wait_time = 0.5
                    valor_torre += 7500
                    P1status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    $Slasher/Ult.animation = "Ult01"
                    $Slasher/AppearUlt.animation = "UltAppear01"
                    verificar_posicao_skin()
                    auraMAISego()
                    
                    if skin:
                        $Slasher.texture = preload("res://Assets/Bunnies/Animations/Skins/Paths/Canela01AttackIdle.png")
                        $SlasherAttack.animation = "SlasherSkin01"
                    else:
                        $Slasher.texture = preload("res://Assets/Bunnies/Animations/Paths/Slasher01AttackIdle.png")
                        $SlasherAttack.animation = "Slasher01"
                        
            atualizar_valorTorre()
        else:
            path2 += 1
            match path2:
                1: 
                    $Range/CollisionRange.scale = Vector2(1.3, 1.3)
                    valor_torre += 400
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                2: 
                    $Range/CollisionRange.scale = Vector2(1.5, 1.5)
                    valor_torre += 1500
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                3: 
                    $Range/CollisionRange.scale = Vector2(1.7, 1.7)
                    valor_torre += 3500
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                4: 
                    $Range/CollisionRange.scale = Vector2(2.0, 2.0)
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    $Slasher/Ult.animation = "Ult02"
                    valor_torre += 7500
                    $Slasher/AppearUlt.animation = "UltAppear02"
                    verificar_posicao_skin()
                    auraMAISego()
                    
                    if skin:
                        $Slasher.texture = preload("res://Assets/Bunnies/Animations/Skins/Paths/Canela02AttackIdle.png")
                        $SlasherAttack.animation = "SlasherSkin02"
                    else:
                        $Slasher.texture = preload("res://Assets/Bunnies/Animations/Paths/Slasher02AttackIdle.png")
                        $SlasherAttack.animation = "Slasher02"
            atualizar_valorTorre()
        return true
    return false
    
func verificar_posicao_skin():
    
    if skin:
        $SlasherAttack.position = Vector2(-78.0, -25.0)
        $Slasher/Ult.position = Vector2(324, 43)
        $Slasher/AppearUlt.position = Vector2(324, 43)
        
        $Slasher/AppearUlt.scale = Vector2(0.68, 0.68)
        $Slasher/Ult.scale = Vector2(0.68, 0.68)
        
    elif skin == false:
        $SlasherAttack.position = Vector2(-6.0, -39.0)
        $Slasher/AppearUlt.position = Vector2(-8, 5)
        $Slasher/Ult.position = Vector2(-8, 5)
        
        $Slasher/AppearUlt.scale = Vector2(1, 1)
        $Slasher/Ult.scale = Vector2(1, 1)
        
func auraMAISego():
    $Slasher.modulate = Color(1, 1, 1)
    $SlasherAttack.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()


    tween.tween_property($Slasher, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.parallel().tween_property($SlasherAttack, "modulate", Color(2, 2, 2, 1), 0.3)
 
    tween.tween_property($Slasher, "modulate", Color(1, 1, 1, 1), 0.4)
    tween.parallel().tween_property($SlasherAttack, "modulate", Color(1, 1, 1, 1), 0.4)

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
