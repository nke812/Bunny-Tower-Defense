extends Node2D

func _on_disable_shop_pressed() -> void :
    $Shop_Appear.play_backwards("Shop_Appear")
