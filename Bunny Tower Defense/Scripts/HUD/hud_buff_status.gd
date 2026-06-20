extends Node2D


func _ready() -> void:
    pass



func _on_area_2d_mouse_entered() -> void:
    $MenuBuffsAnims.play("MenuBuffs")
    await $MenuBuffsAnims.animation_finished

    


func _on_area_2d_mouse_exited() -> void:
    $MenuBuffsAnims.play_backwards("MenuBuffs")
    await $MenuBuffsAnims.animation_finished
