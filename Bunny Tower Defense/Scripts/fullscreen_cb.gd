extends CheckBox


func _on_toggled(toggled_on: bool) -> void :
    if toggled_on == true:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _process(delta: float) -> void :
    var modo_atual = DisplayServer.window_get_mode()

    if modo_atual == DisplayServer.WINDOW_MODE_FULLSCREEN:
        button_pressed = true
    else:
        button_pressed = false
