extends Node2D

var shop_ativa = false

func _process(delta: float) -> void :
    if shop_ativa:
        $"../disable_shop".disabled = false
        $"../disable_shop".visible = true
    else:
        $"../disable_shop".disabled = true
        $"../disable_shop".visible = false

func _on_disable_shop_pressed() -> void :
    $Shop_Appear.play_backwards("Shop_Appear")
