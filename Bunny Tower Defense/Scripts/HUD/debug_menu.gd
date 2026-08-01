extends Node2D

var DebugMenu: bool = false

func _on_seta_pressed() -> void:
    if DebugMenu:
        DebugMenu = false
    else:
        DebugMenu = true
    debug()

func debug():
    if DebugMenu:
        $PanelIntro.play("IntroPanel")
    else:
        $PanelIntro.play_backwards("IntroPanel")





# -----   DEBUG   ----- #
func _on_set_money_pressed() -> void:
    var SetMoney = int($Panel/SpinBoxMoney.value)
    
    $"../HUD/PGB_M".value = SetMoney
    $"../HUD/Moedas".text = str(SetMoney)

func _on_plus_pressed() -> void:
    var SetMoney = int($Panel/SpinBoxMoney.value)
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    
    moedas.text = str(valor_atual + SetMoney)

func _on_minus_pressed() -> void:
    var SetMoney = int($Panel/SpinBoxMoney.value)
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    
    moedas.text = str(valor_atual - SetMoney)
