extends Node2D

@onready var rookie_scene = preload("res://Scenes/Towers/rookie.tscn")
@onready var lucky_scene = preload("res://Scenes/Towers/lucky.tscn")
@onready var slasher_scene = preload("res://Scenes/Towers/slasher.tscn")
@onready var gooey_scene = preload("res://Scenes/Towers/gooey.tscn")
@onready var anarchist_scene = preload("res://Scenes/Towers/anarchist.tscn")
@onready var scrappy_scene = preload("res://Scenes/Towers/scrappy.tscn")
@onready var mystical_scene = preload("res://Scenes/Towers/mystical.tscn")
@onready var ghoulish_scene = preload("res://Scenes/Towers/ghoulish.tscn")


@onready var moedas_label = $"../../Moedas"
@onready var moedas_barra = $"../../PGB_M"

@onready var moedas_atuais = int(moedas_label.text)


var tipo_torre_atual = ""

var temp_tower = null
var local_proibido = false
var custo_da_torre_atual = 0


func _ready() -> void:
    atualizar_loja_botoes()

func _process(_delta: float) -> void:
    var moedas_atuais_nova = int(moedas_label.text)
    
    if moedas_atuais_nova != moedas_atuais:
        moedas_atuais = moedas_atuais_nova
        atualizar_loja_botoes()


    if temp_tower != null:
        temp_tower.global_position = get_global_mouse_position()

        var detector = temp_tower.get_node("HitBox")
        var areas_em_cima = detector.get_overlapping_areas()

        local_proibido = false
        for area in areas_em_cima:
            if area.is_in_group("no_place"):
                local_proibido = true
                break


        if local_proibido:
            temp_tower.modulate = Color(1, 0.2, 0.2, 0.5)
        else:
            temp_tower.modulate = Color(1, 1, 1, 0.5)


        if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
            if not local_proibido:
                largar_torre()
            else:

                temp_tower.queue_free()
                temp_tower = null
                custo_da_torre_atual = 0


func atualizar_loja_botoes() -> void:
    
    #kiss D;
    $ScrollContainer/GridContainer/Rookie_BG_dps.disabled = (moedas_atuais < 115)
    $ScrollContainer/GridContainer/Rookie_BG_dps/Rookie.disabled = (moedas_atuais < 115)
    if $ScrollContainer/GridContainer/Rookie_BG_dps.disabled == true:
        $"ScrollContainer/GridContainer/Rookie_BG_dps/Preço".add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        $"ScrollContainer/GridContainer/Rookie_BG_dps/Preço".add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        $ScrollContainer/GridContainer/Rookie_BG_dps/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")
    else:
        $"ScrollContainer/GridContainer/Rookie_BG_dps/Preço".add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        $"ScrollContainer/GridContainer/Rookie_BG_dps/Preço".add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        $ScrollContainer/GridContainer/Rookie_BG_dps/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTag.png")
        
    $ScrollContainer/GridContainer/Lucky_BG_support.disabled = (moedas_atuais < 750)
    $ScrollContainer/GridContainer/Lucky_BG_support/Lucky.disabled = (moedas_atuais < 750)
    if $ScrollContainer/GridContainer/Lucky_BG_support.disabled == true:
        $ScrollContainer/GridContainer/Lucky_BG_support/Preço.add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        $ScrollContainer/GridContainer/Lucky_BG_support/Preço.add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        $ScrollContainer/GridContainer/Lucky_BG_support/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")
    else:
        $ScrollContainer/GridContainer/Lucky_BG_support/Preço.add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        $ScrollContainer/GridContainer/Lucky_BG_support/Preço.add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        $ScrollContainer/GridContainer/Lucky_BG_support/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTag.png")

    $ScrollContainer/GridContainer/Slasher_BG_dps.disabled = (moedas_atuais < 250)
    $ScrollContainer/GridContainer/Slasher_BG_dps/Slasher.disabled = (moedas_atuais < 250)
    if $ScrollContainer/GridContainer/Slasher_BG_dps.disabled == true:
        $ScrollContainer/GridContainer/Slasher_BG_dps/Preço.add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        $ScrollContainer/GridContainer/Slasher_BG_dps/Preço.add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        $ScrollContainer/GridContainer/Slasher_BG_dps/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")
    else:
        $ScrollContainer/GridContainer/Slasher_BG_dps/Preço.add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        $ScrollContainer/GridContainer/Slasher_BG_dps/Preço.add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        $ScrollContainer/GridContainer/Slasher_BG_dps/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTag.png")

    $ScrollContainer/GridContainer/Gooey_BG_stun.disabled = (moedas_atuais < 225)
    $ScrollContainer/GridContainer/Gooey_BG_stun/Gooey.disabled = (moedas_atuais < 225)
    if $ScrollContainer/GridContainer/Gooey_BG_stun.disabled == true:
        $ScrollContainer/GridContainer/Gooey_BG_stun/Preço.add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        $ScrollContainer/GridContainer/Gooey_BG_stun/Preço.add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        $ScrollContainer/GridContainer/Gooey_BG_stun/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")
    else:
        $ScrollContainer/GridContainer/Gooey_BG_stun/Preço.add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        $ScrollContainer/GridContainer/Gooey_BG_stun/Preço.add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        $ScrollContainer/GridContainer/Gooey_BG_stun/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTag.png")

    $ScrollContainer/GridContainer/Anarchist_BG_dps.disabled = (moedas_atuais < 500)
    $ScrollContainer/GridContainer/Anarchist_BG_dps/Anarchist.disabled = (moedas_atuais < 500)
    if $ScrollContainer/GridContainer/Anarchist_BG_dps.disabled == true:
        $ScrollContainer/GridContainer/Anarchist_BG_dps/Preço.add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        $ScrollContainer/GridContainer/Anarchist_BG_dps/Preço.add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        $ScrollContainer/GridContainer/Anarchist_BG_dps/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")
    else:
        $ScrollContainer/GridContainer/Anarchist_BG_dps/Preço.add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        $ScrollContainer/GridContainer/Anarchist_BG_dps/Preço.add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        $ScrollContainer/GridContainer/Anarchist_BG_dps/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTag.png")
    
    $ScrollContainer/GridContainer/Scrappy_BG_stun.disabled = (moedas_atuais < 330)
    $ScrollContainer/GridContainer/Scrappy_BG_stun/Scrappy.disabled = (moedas_atuais < 330)
    if $ScrollContainer/GridContainer/Scrappy_BG_stun.disabled == true:
        $ScrollContainer/GridContainer/Scrappy_BG_stun/Preço.add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        $ScrollContainer/GridContainer/Scrappy_BG_stun/Preço.add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        $ScrollContainer/GridContainer/Scrappy_BG_stun/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")
    else:
        $ScrollContainer/GridContainer/Scrappy_BG_stun/Preço.add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        $ScrollContainer/GridContainer/Scrappy_BG_stun/Preço.add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        $ScrollContainer/GridContainer/Scrappy_BG_stun/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTag.png")
    
    $ScrollContainer/GridContainer/Mystical_BG_support.disabled = (moedas_atuais < 1400)
    $ScrollContainer/GridContainer/Mystical_BG_support/Mystical.disabled = (moedas_atuais < 1400)
    if $ScrollContainer/GridContainer/Mystical_BG_support.disabled == true:
        $ScrollContainer/GridContainer/Mystical_BG_support/Preço.add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        $ScrollContainer/GridContainer/Mystical_BG_support/Preço.add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        $ScrollContainer/GridContainer/Mystical_BG_support/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")
    else:
        $ScrollContainer/GridContainer/Mystical_BG_support/Preço.add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        $ScrollContainer/GridContainer/Mystical_BG_support/Preço.add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        $ScrollContainer/GridContainer/Mystical_BG_support/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTag.png")
    
    $ScrollContainer/GridContainer/Ghoulish_BG_stun.disabled = (moedas_atuais < 700)
    $ScrollContainer/GridContainer/Ghoulish_BG_stun/Ghoulish.disabled = (moedas_atuais < 700)
    if $ScrollContainer/GridContainer/Ghoulish_BG_stun.disabled == true:
        $ScrollContainer/GridContainer/Ghoulish_BG_stun/Preço.add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        $ScrollContainer/GridContainer/Ghoulish_BG_stun/Preço.add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        $ScrollContainer/GridContainer/Ghoulish_BG_stun/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")
    else:
        $ScrollContainer/GridContainer/Ghoulish_BG_stun/Preço.add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        $ScrollContainer/GridContainer/Ghoulish_BG_stun/Preço.add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        $ScrollContainer/GridContainer/Ghoulish_BG_stun/Sprite2D.texture = preload("res://Assets/Others/HUD_Assets/PriceTag.png")


func _on_rookie_button_down() -> void :
    if temp_tower == null and moedas_atuais >= 115:
        temp_tower = rookie_scene.instantiate()
        custo_da_torre_atual = 115
        configurar_torre_temp()

func _on_slasher_button_down() -> void :
    if temp_tower == null and moedas_atuais >= 250:
        temp_tower = slasher_scene.instantiate()
        custo_da_torre_atual = 250
        configurar_torre_temp()

func _on_lucky_button_down() -> void :
    if temp_tower == null and moedas_atuais >= 750:
        tipo_torre_atual = "lucky"
        temp_tower = lucky_scene.instantiate()
        custo_da_torre_atual = 750
        configurar_torre_temp()

func _on_gooey_button_down() -> void :
    if temp_tower == null and moedas_atuais >= 225:
        tipo_torre_atual = "gooey"
        temp_tower = gooey_scene.instantiate()
        custo_da_torre_atual = 225
        configurar_torre_temp()

func _on_anarchist_button_down() -> void :
    if temp_tower == null and moedas_atuais >= 500:
        tipo_torre_atual = "anarchist"
        temp_tower = anarchist_scene.instantiate()
        custo_da_torre_atual = 500
        configurar_torre_temp()

func _on_scrappy_button_down() -> void:
    if temp_tower == null and moedas_atuais >= 330:
        tipo_torre_atual = "scrapy"
        temp_tower = scrappy_scene.instantiate()
        custo_da_torre_atual = 330
        configurar_torre_temp()
        
func _on_mystical_button_down() -> void:
    if temp_tower == null and moedas_atuais >= 1400:
        tipo_torre_atual = "mystical"
        temp_tower = mystical_scene.instantiate()
        custo_da_torre_atual = 1400
        configurar_torre_temp()

func _on_ghoulish_button_down() -> void:
    if temp_tower == null and moedas_atuais >= 700:
        tipo_torre_atual = "ghoulish"
        temp_tower = ghoulish_scene.instantiate()
        custo_da_torre_atual = 700
        configurar_torre_temp()

func configurar_torre_temp():
    temp_tower.modulate.a = 0.5
    temp_tower.process_mode = Node.PROCESS_MODE_ALWAYS

    var range_node = temp_tower.get_node("Range")
    range_node.monitoring = false
    range_node.monitorable = false

    get_tree().current_scene.add_child(temp_tower)

func largar_torre():
    $TowerPlace.play()
    if "posicionado" in temp_tower:
        temp_tower.posicionado = true

    if temp_tower:
        if moedas_atuais >= custo_da_torre_atual:
            temp_tower.get_node("Shadow").visible = true
            temp_tower.modulate.a = 1.0
            temp_tower.process_mode = Node.PROCESS_MODE_INHERIT


            var range_node = temp_tower.get_node("Range")
            range_node.monitoring = true
            range_node.monitorable = true


            var novas_moedas = moedas_atuais - custo_da_torre_atual
            moedas_label.text = str(novas_moedas)
            moedas_barra.value = novas_moedas

            range_node.get_node("CollisionRange").visible = true


            temp_tower = null
            custo_da_torre_atual = 0
            
        else:
            temp_tower.queue_free()
            temp_tower = null
            custo_da_torre_atual = 0
