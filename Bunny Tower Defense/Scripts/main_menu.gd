extends Control

@onready var escolha = get_tree().get_first_node_in_group("escolha de mapa")
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

@onready var botao_continuar = $MainMenu_Left/Buttons/Continue

var MapSel = null
var map1 = "res://Scenes/Mapas/Map_1.tscn"
var map2 = "res://Scenes/Mapas/Map_2.tscn"


func _on_start_pressed() -> void :
    $"Select Map/SelMapsMenu".play("SelMapsAnim")
    $MainMenu_Left/Buttons/Voltar.disabled = true
    $MainMenu_Left/Buttons/Bestiario.disabled = true
    
var SettingsUP = false
func _on_settings_pressed() -> void :
    $MainMenu_Left/Buttons/Start.disabled = true

    if SettingsUP == false:
        $Options/SettingsAnim.play("settings")
        SettingsUP = true


func _on_exit_menu_pressed() -> void :
    if SettingsUP == true:
        $Options/SettingsAnim.play_backwards("settings")
        await $Options/SettingsAnim.animation_finished

        $MainMenu_Left/Buttons/Start.disabled = false

        SettingsUP = false



func _on_settings_mouse_entered() -> void :
    $MainMenu_Left/Settings.modulate = Color(1.211, 1.211, 1.211)
    $MainMenu_Left/Buttons/Settings/AnimationPlayer.play("settings")

func _on_settings_mouse_exited() -> void :
    $MainMenu_Left / Settings.modulate = Color(1.0, 1.0, 1.0, 1.0)
    $MainMenu_Left/Buttons/Settings/AnimationPlayer.play_backwards("settings")


func _on_bestiario_mouse_entered() -> void :
    if $MainMenu_Left/Buttons/Bestiario:
        $MainMenu_Left / Bestiario.modulate = Color(1.211, 1.211, 1.211)
        $MainMenu_Left/Buttons/Bestiario/AnimationPlayer.play("definiçoes")

func _on_bestiario_mouse_exited() -> void :
    $MainMenu_Left / Bestiario.modulate = Color(1.0, 1.0, 1.0, 1.0)
    $MainMenu_Left/Buttons/Bestiario/AnimationPlayer.play_backwards("definiçoes")


func _on_achievements_mouse_entered() -> void :
    $MainMenu_Left / Achievements.modulate = Color(1.211, 1.211, 1.211)

func _on_achievements_mouse_exited() -> void :
    $MainMenu_Left / Achievements.modulate = Color(1.0, 1.0, 1.0, 1.0)




func _on_exit_pressed() -> void :
    $MainMenu_Left / Buttons / BIG_Start.disabled = true
    $MainMenu_Left / Buttons / Voltar.disabled = true
    $StartGame_Sound.play()
    $Camera2D / MenuGoLeft.play("MenuGoLeft")

    await $Camera2D/MenuGoLeft.animation_finished
    $MainMenu_Left/Buttons/BIG_Start.disabled = false
    $MainMenu_Left/Buttons/Voltar.disabled = false

func _on_voltar_pressed() -> void :
    $Camera2D/MenuGoLeft.play_backwards("MenuGoLeft")

    
func _on_exit_menu_map_pressed() -> void:
    $"Select Map/SelMapsMenu".play_backwards("SelMapsAnim")
    $MainMenu_Left/Buttons/Voltar.disabled = false
    $MainMenu_Left/Buttons/Bestiario.disabled = false


func _on_easter_egg_pressed() -> void :
    $"MainMenu_Left/SillyBunny/easter egg".disabled = true
    $MainMenu_Left/SillyBunny/Squeaky.play()

    $MainMenu_Left/SillyBunny/AnimationPlayer.play("Squeaky")
    await $MainMenu_Left/SillyBunny/AnimationPlayer.animation_finished

    $"MainMenu_Left/SillyBunny/easter egg".disabled = false

func _on_grass_lands_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/loading.tscn")


func _on_glimmer_road_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/loading2.tscn")


func _on_grass_lands_mouse_entered() -> void:
    $"Select Map/GrassLands".modulate = Color(1.211, 1.211, 1.211)
func _on_grass_lands_mouse_exited() -> void:
    $"Select Map/GrassLands".modulate = Color(1.0, 1.0, 1.0, 1.0)
func _on_glimmer_road_mouse_entered() -> void:
    $"Select Map/GlimmerRoad".modulate = Color(1.211, 1.211, 1.211)
func _on_glimmer_road_mouse_exited() -> void:
    $"Select Map/GlimmerRoad".modulate = Color(1.0, 1.0, 1.0, 1.0)



func _on_glimmer_road_button_down() -> void:
    $"Select Map/GlimmerRoad".modulate = Color(0.632, 0.632, 0.632, 1.0)

func _on_grass_lands_button_down() -> void:
    $"Select Map/GrassLands".modulate = Color(0.632, 0.632, 0.632, 1.0)


func _on_music_icon_pressed() -> void:
    var slider_sfx = $Options/MusicControl
    var icon = $Options/MusicControl/MusicIcon.texture_normal.resource_path
    
    $Options/Click_AnimMusic.play("click")
    match icon:
        "res://Assets/Others/UI_Assets/Music.png":
            slider_sfx.value = 0
        "res://Assets/Others/UI_Assets/MusicMute.png":
            slider_sfx.value = 100
    
func _on_sfx_icon_pressed() -> void:
    var slider_sfx = $Options/SFXControl
    var icon = $Options/SFXControl/SFXIcon.texture_normal.resource_path
    
    $Options/Click_AnimSFX.play("click")
    match icon:
        "res://Assets/Others/UI_Assets/Audio.png":
            slider_sfx.value = 0
        "res://Assets/Others/UI_Assets/AudioMute.png":
            slider_sfx.value = 100     

func _on_music_control_value_changed(value: float) -> void: 
    if $Options/MusicControl.value >= 0.01:
        $Options/MusicControl/MusicIcon.texture_normal = preload("res://Assets/Others/UI_Assets/Music.png")
    else:
        $Options/MusicControl/MusicIcon.texture_normal = preload("res://Assets/Others/UI_Assets/MusicMute.png")
        
func _on_sfx_control_value_changed(value: float) -> void:
    if $Options/SFXControl.value >= 0.01:
        $Options/SFXControl/SFXIcon.texture_normal = preload("res://Assets/Others/UI_Assets/Audio.png")
    else:
        $Options/SFXControl/SFXIcon.texture_normal = preload("res://Assets/Others/UI_Assets/AudioMute.png")

    


func _on_continue_pressed() -> void:
    if not SaveManager.tem_save():
        return
        
    var dados = SaveManager.carregar_jogo()
    var info_jogador = dados.get("jogador", {})
    
    # 1. Descobrir qual era o mapa guardado (com um mapa predefinido de segurança caso esteja vazio)
    var caminho_mapa = info_jogador.get("mapa_atual", "res://cenas/mapas/mapa_padrao.tscn")
    
    # 2. Mudar para a cena do mapa guardado
    get_tree().change_scene_to_file(caminho_mapa)
    
    # Nota importante: Como mudar de cena é instantâneo mas a árvore demora um frame a carregar, 
    # deves colocar a parte de recriar as torres e as moedas num script dentro do próprio mapa (no _ready()),
    # lendo novamente o SaveManager assim que o mapa arrancar!
