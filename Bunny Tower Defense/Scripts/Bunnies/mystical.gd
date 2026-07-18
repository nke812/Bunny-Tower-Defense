extends Node2D

@onready var Mystical = $Pega/Mystical

var posicionado = false
var mostrar_range = false

var valor_torre = 1400

var MysticalBuff = false

var focus = false
var skin = false

var path1 = 0
var path2 = 0
var preços_p1 = [650, 1400, 3500, 12000]
var preços_p2 = [650, 1400, 3500, 12000]

var buffs = 0

var P1status = "LVL Buff: " + str(path1)
var P2status = "Range: 1"


# Guarda a lista de coelhos que estão atualmente dentro do raio
var coelhos_no_raio: Array = []

func _ready() -> void:
    posicionado = true
    # Aguarda um frame físico para garantir que as áreas iniciais são detetadas
    await get_tree().physics_frame
    _atualizar_buffs_iniciais()

func _atualizar_buffs_iniciais() -> void:
    # Corre apenas UMA vez no ready para apanhar quem já lá estava
    var areas = $Range.get_overlapping_areas()
    for area in areas:
        _aplicar_buff_a_area(area)

func _on_range_area_entered(area: Area2D) -> void:
    _aplicar_buff_a_area(area)

func _on_range_area_exited(area: Area2D) -> void:
    _remover_buff_de_area(area)

# --- Funções Auxiliares Isoladas ---

func _aplicar_buff_a_area(area: Area2D) -> void:
    var coelho = area.get_parent()
    if coelho and coelho.is_in_group("Bunnies") and coelho != self:
        if not coelhos_no_raio.has(coelho):
            coelhos_no_raio.append(coelho)
        
        coelho.MysticalBuff = true
        if coelho.has_method("receber_buff_mystical"):
            coelho.receber_buff_mystical(path1)

func _remover_buff_de_area(area: Area2D) -> void:
    var coelho = area.get_parent()
    if coelho and coelho.is_in_group("Bunnies"):
        if coelhos_no_raio.has(coelho):
            coelhos_no_raio.erase(coelho)
        
        coelho.MysticalBuff = false
        if coelho.has_method("remover_buff_mystical"):
            coelho.remover_buff_mystical()

# Se precisares de atualizar o buff de toda a gente quando a Mystical faz um upgrade de nível:
func atualizar_nivel_do_buff() -> void:
    for coelho in coelhos_no_raio:
        if is_instance_valid(coelho) and coelho.has_method("receber_buff_mystical"):
            coelho.receber_buff_mystical(path1)
    
    
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
    hud.get_node("HUD_Shop/BuffStatus").visible = false
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Mystical.png")
        atualizar_valorTorre()
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")
    

func mudar_skin():
    skin = !skin
    $SkinChange.play("ChangeSkin")
    
    var texture = Mystical.texture.resource_path
    match texture:
        "res://Assets/Bunnies/Mystical.png":
            Mystical.texture = preload("res://Assets/Bunnies/Skins/Catharsis.png")
            
        "res://Assets/Bunnies/Skins/Catharsis.png":
            Mystical.texture = preload("res://Assets/Bunnies/Mystical.png")
            
        "res://Assets/Bunnies/Paths/Mystical01.png":
            Mystical.texture = preload("res://Assets/Bunnies/Skins/Paths/Catharsis01.png")
            
        "res://Assets/Bunnies/Skins/Paths/Catharsis01.png":
            Mystical.texture = preload("res://Assets/Bunnies/Paths/Mystical01.png")
            
        "res://Assets/Bunnies/Paths/Mystical02.png":
            Mystical.texture = preload("res://Assets/Bunnies/Skins/Paths/Catharsis02.png")
            
        "res://Assets/Bunnies/Skins/Paths/Catharsis02.png":
            Mystical.texture = preload("res://Assets/Bunnies/Paths/Mystical02.png")


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
                    valor_torre += 650
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                2: 
                    P1status = "LV Buff: " + str(path1)
                    atualizar_torres_no_raio()
                    valor_torre += 1400
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                3: 
                    P1status = "LV Buff: " + str(path1)
                    atualizar_torres_no_raio()
                    valor_torre += 3500
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                4: 
                    P1status = "LV Buff: " + str(path1)
                    atualizar_torres_no_raio()
                    valor_torre += 12000
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                    if skin: Mystical.texture = preload("res://Assets/Bunnies/Skins/Paths/Catharsis01.png")
                    else: Mystical.texture = preload("res://Assets/Bunnies/Paths/Mystical01.png")
                    
                    
                    auraMAISego()
            atualizar_valorTorre()              
        else:
            path2 += 1
            match path2:
                1: 
                    $Range/CollisionRange.scale = Vector2(1.2, 1.2)
                    valor_torre += 650
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                2: 
                    $Range/CollisionRange.scale = Vector2(1.5, 1.5)
                    valor_torre += 1400
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                3: 
                    $Range/CollisionRange.scale = Vector2(1.7, 1.7)
                    valor_torre += 3500
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                4: 
                    $Range/CollisionRange.scale = Vector2(2.0, 2.0)
                    valor_torre += 12000
                    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
                    hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
                    
                    if skin: Mystical.texture = preload("res://Assets/Bunnies/Skins/Paths/Catharsis02.png")
                    else: Mystical.texture = preload("res://Assets/Bunnies/Paths/Mystical02.png")
                    
                    auraMAISego()
            atualizar_valorTorre()    
        return true
    return false


func auraMAISego():
    Mystical.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()


    tween.tween_property(Mystical, "modulate", Color(2, 2, 2, 1), 0.3)
 
    tween.tween_property(Mystical, "modulate", Color(1, 1, 1, 1), 0.4)

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

          
func atualizar_torres_no_raio() -> void:
    var corpos_no_raio = $Range.get_overlapping_areas()
    for corpo in corpos_no_raio:
        var pai = corpo.get_parent()
        if (corpo.is_in_group("Bunnies") or pai.is_in_group("Bunnies")) and corpo != self and pai != self:
            var bunny_aliado = corpo if corpo.has_method("receber_buff_mystical") else pai
            if bunny_aliado.has_method("receber_buff_mystical"):
                bunny_aliado.receber_buff_mystical(path1)
                
                
func atualizar_valorTorre():
    var hud = get_tree().get_first_node_in_group("HUD")
    var valor_torre_60 : int = int(valor_torre * 0.6)
    
    hud.get_node("HUD_Shop/HudBgDown/Control/PanelSell/precoSell").text = str(valor_torre_60)

func vender_torre():
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    var valor_torre_60 : int = int(valor_torre * 0.6)
    
    moedas.text = str(valor_atual + valor_torre_60)
    
    desativar_buff()
    queue_free()



func ativar_buff():
    var areas_no_raio = $Range.get_overlapping_areas()
    for area in areas_no_raio:
        var coelho = area.get_parent()
        if coelho and coelho.is_in_group("Bunnies") and coelho != self:
            coelho.MysticalBuff = true
            if coelho.has_method("receber_buff_mystical"):
                coelho.receber_buff_mystical(path1)

func desativar_buff():
    var areas_no_raio = $Range.get_overlapping_areas()
    for area in areas_no_raio:
        var coelho = area.get_parent()
        if coelho and coelho.is_in_group("Bunnies") and coelho != self:
            coelho.MysticalBuff = false
            if coelho.has_method("remover_buff_mystical"):
                coelho.remover_buff_mystical() # Chama a função de limpeza que já tens no Rookie!

func receber_buff_mystical(nivel_mystical):
    pass
