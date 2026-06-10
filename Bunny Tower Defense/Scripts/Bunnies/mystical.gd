extends Node2D

var posicionado = false
var mostrar_range = false

var focus = false
var skin = false

var path1 = 0
var path2 = 0
var preços_p1 = [650, 1400, 3500, 12000]
var preços_p2 = [650, 1400, 3500, 12000]

var buffs = 0

var P1status = "LV Buff: " + str(path1)
var P2status = "Range: 1"

func _physics_process(_delta):
    
    
    if focus == true:
        $ArrowSupport.visible = true
    else:
        $ArrowSupport.visible = false

func reset_focus():
    focus = false

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true

    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Mystical.png")
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
                    P1status = "LV Buff: " + str(path1)
                    atualizar_torres_no_raio()
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                2: 
                    P1status = "LV Buff: " + str(path1)
                    atualizar_torres_no_raio()
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                3: 
                    P1status = "LV Buff: " + str(path1)
                    atualizar_torres_no_raio()
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                4: 
                    P1status = "LV Buff: " + str(path1)
                    atualizar_torres_no_raio()
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    $Mystical.texture = preload("res://Assets/Bunnies/Paths/Mystical01.png")
                    auraMAISego()
                          
        else:
            path2 += 1
            match path2:
                1: 
                    $Range/CollisionRange.scale = Vector2(1.2, 1.2)
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                2: 
                    $Range/CollisionRange.scale = Vector2(1.5, 1.5)
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                3: 
                    $Range/CollisionRange.scale = Vector2(1.7, 1.7)
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                4: 
                    $Range/CollisionRange.scale = Vector2(2.0, 2.0)
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    $Mystical.texture = preload("res://Assets/Bunnies/Paths/Mystical02.png")
                    auraMAISego()
                
        return true
    return false


func auraMAISego():
    $Mystical.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()


    tween.tween_property($Mystical, "modulate", Color(2, 2, 2, 1), 0.3)
 
    tween.tween_property($Mystical, "modulate", Color(1, 1, 1, 1), 0.4)

func _draw() -> void:
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.0, 0.0, 0.0, 0.302)) # Círculo verde transparente

func _on_button_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()





func _on_range_area_entered(area: Area2D):
    var Bunny = area.get_parent()
    
    # 1. Verifica se é um coelho válido
    if Bunny.is_in_group("Bunnies") and area != self and Bunny != self:
        
        # 2. Descobre onde está o script
        var script_bunny = area if area.has_method("receber_buff_mystical") else Bunny
        
        # 3. Verifica se ele tem a FUNÇÃO e se JÁ ESTÁ NO CHÃO (posicionado == true)
        if script_bunny.has_method("receber_buff_mystical"):
            # 4. Aplica o buff passando o nível atual do upgrade!
            script_bunny.receber_buff_mystical(path1)

          
func atualizar_torres_no_raio() -> void:
    var corpos_no_raio = $Range.get_overlapping_areas()
    for corpo in corpos_no_raio:
        var pai = corpo.get_parent()
        if (corpo.is_in_group("Bunnies") or pai.is_in_group("Bunnies")) and corpo != self and pai != self:
            var bunny_aliado = corpo if corpo.has_method("receber_buff_mystical") else pai
            if bunny_aliado.has_method("receber_buff_mystical"):
                bunny_aliado.receber_buff_mystical(path1)
