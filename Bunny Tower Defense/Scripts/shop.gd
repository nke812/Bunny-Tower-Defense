extends Node2D



func test_btn() -> void:
    $Lunie.play("default")
    $LunieHand.play("default")
    
    await $LunieHand.animation_finished
    await get_tree().create_timer(1.0).timeout
    
    $LunieHand.play("backwards")


func Voltar_Menu() -> void:
    get_tree().change_scene_to_file("res://Scenes/loading_Menu.tscn")
    
