extends Control

@onready var escolha = get_tree().get_first_node_in_group("escolha de mapa")
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

var MapSel = null
var map1 = "res://Scenes/Mapas/Map_1.tscn"
var map2 = "res://Scenes/Mapas/Map_2.tscn"

func _on_start_pressed() -> void :
    $"Select Map/SelMapsMenu".play("SelMapsAnim")

var SettingsUP = false
func _on_settings_pressed() -> void :
    $MainMenu_Left / Buttons / Start.disabled = true

    if SettingsUP == false:
        $Options / Settings_Anim.play("Settings_Anim")
        SettingsUP = true


func _on_exit_menu_pressed() -> void :
    if SettingsUP == true:
        $Options / Settings_Anim.play_backwards("Settings_Anim")
        await $Options / Settings_Anim.animation_finished

        $MainMenu_Left / Buttons / Start.disabled = false

        SettingsUP = false



func _on_settings_mouse_entered() -> void :
    $MainMenu_Left/Settings.modulate = Color(1.211, 1.211, 1.211)

func _on_settings_mouse_exited() -> void :
    $MainMenu_Left / Settings.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_bestiario_mouse_entered() -> void :
    $MainMenu_Left / Bestiario.modulate = Color(1.211, 1.211, 1.211)

func _on_bestiario_mouse_exited() -> void :
    $MainMenu_Left / Bestiario.modulate = Color(1.0, 1.0, 1.0, 1.0)


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
