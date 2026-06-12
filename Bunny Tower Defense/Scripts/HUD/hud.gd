extends Node2D

@onready var spawner = get_node("../../GhostlingSpawner")
var torre_em_foco = null

var UpgradeLocked = preload("res://Assets/Others/HUD_Assets/LockedUpgrade.png")
var UpgradeCheck = preload("res://Assets/Others/HUD_Assets/UpgradeCarrot.png")
var LastUpgradeCheck = preload("res://Assets/Others/HUD_Assets/UpgradeCrown.png")


@onready var moedas_label = $Moedas
@onready var moedas_barra = $PGB_M

@onready var moedas_atuais = int(moedas_label.text)


func _process(_delta: float) -> void:
    var moedas_atuais_nova = int(moedas_label.text)
    # O DINHEIRO MUDOU?
    if moedas_atuais_nova != moedas_atuais:
        moedas_atuais = moedas_atuais_nova
        
        # 2. Se houver um coelho selecionado, atualiza também os botões de upgrade!
        if torre_em_foco != null:
            atualizar_visual_upgrades()


func take_dmg(dmg):
    $PGB_V.value -= dmg
    if $PGB_V.value == 0:
        $GameOver.visible = true
        $Pause.visible = false


func _on_button_pressed() -> void :
    $UI_Selection/Options.visible = true
    $Pause.visible = false
    get_tree().paused = true


func _on_continue_pressed():
    $"Options".visible = false
    $Pause.visible = true

func _on_options_pressed():
    $PauseMenu.visible = false
    $Options.visible = true



func _on_back_menu_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")



func _on_exit_settings_pressed() -> void :
    $UI_Selection/Options.visible = false
    $Pause.visible = true
    get_tree().paused = false


func _on_restart_pressed() -> void :
    get_tree().paused = false
    get_tree().reload_current_scene()

func _on_start_round_pressed() -> void :
    spawner.iniciar_vaga()


func _on_exit_settings_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    $HUD_Shop/HudBgDown/StatusExtra.text = ""
    
    $HUD_Shop/HudBgDown/ExitShop.disabled = true
    $HUD_Shop/Shop_Appear.play_backwards("Shop_Appear")
    
    await $HUD_Shop/Shop_Appear.animation_finished
    $HUD_Shop/HudBgDown/BunnySel.texture = null
    
    
func abrir_menu_upgrade(torre_clicada):
    torre_em_foco = torre_clicada
    atualizar_visual_upgrades() # Atualiza as cenouras assim que abre

func _on_path_1_pressed() -> void:
    if torre_em_foco != null:
        # O 'if' aqui serve para confirmar: "A torre conseguiu tirar o dinheiro?"
        if torre_em_foco.aplicar_upgrade(1):
            atualizar_visual_upgrades()
            tirar_brilho()
            tirar_preco()
            

func _on_path_2_pressed() -> void:
    if torre_em_foco != null:
        if torre_em_foco.aplicar_upgrade(2):
            atualizar_visual_upgrades()
            tirar_brilho()
            tirar_preco()

func _on_sell_pressed() -> void:
    torre_em_foco.vender_torre()
    _on_exit_settings_button_down()

# Esta é a função "mágica" que vai gerir os teus ícones
func atualizar_visual_upgrades():
    if torre_em_foco == null: return
    
    moedas_atuais = int(moedas_label.text)
    
    
#/////////// PATH1 ///////////    
    $"HUD_Shop/HudBgDown/Upgrade 1-1".disabled = (torre_em_foco.path1 != 0)
    if torre_em_foco.path1 == 1: 
        $"HUD_Shop/HudBgDown/Upgrade 1-1".texture_disabled = UpgradeCheck
    else:
        if torre_em_foco.path1 == 0:
            var custo_1_1 = torre_em_foco.preços_p1[0]
            
            if moedas_atuais >= custo_1_1:
                $"HUD_Shop/HudBgDown/Upgrade 1-1".texture_normal = preload("res://Assets/Others/UI_Assets/Carrot.png")
            else:
                $"HUD_Shop/HudBgDown/Upgrade 1-1".texture_normal = preload("res://Assets/Others/UI_Assets/CarrotDisabled.png")
                
    
    $"HUD_Shop/HudBgDown/Upgrade 1-2".disabled = (torre_em_foco.path1 != 1)
    if torre_em_foco.path1 >= 2: 
        $"HUD_Shop/HudBgDown/Upgrade 1-2".texture_disabled = UpgradeCheck
    else:
        if torre_em_foco.path1 == 1:
            var custo_1_2 = torre_em_foco.preços_p1[1]
            if moedas_atuais >= custo_1_2:
                $"HUD_Shop/HudBgDown/Upgrade 1-2".texture_normal = preload("res://Assets/Others/UI_Assets/Carrot.png")
            else:
                $"HUD_Shop/HudBgDown/Upgrade 1-2".texture_normal = preload("res://Assets/Others/UI_Assets/CarrotDisabled.png")
        else:
            $"HUD_Shop/HudBgDown/Upgrade 1-2".texture_disabled = UpgradeLocked
    
    
    $"HUD_Shop/HudBgDown/Upgrade 1-3".disabled = (torre_em_foco.path1 != 2)
    if torre_em_foco.path1 >= 3: 
        $"HUD_Shop/HudBgDown/Upgrade 1-3".texture_disabled = UpgradeCheck
    else:
        if torre_em_foco.path1 == 2:
            var custo_1_3 = torre_em_foco.preços_p1[1]
            if moedas_atuais >= custo_1_3:
                $"HUD_Shop/HudBgDown/Upgrade 1-3".texture_normal = preload("res://Assets/Others/UI_Assets/Carrot.png")
            else:
                $"HUD_Shop/HudBgDown/Upgrade 1-3".texture_normal = preload("res://Assets/Others/UI_Assets/CarrotDisabled.png")
        else:
            $"HUD_Shop/HudBgDown/Upgrade 1-3".texture_disabled = UpgradeLocked
    
    
    $"HUD_Shop/HudBgDown/Upgrade 1-4".disabled = (torre_em_foco.path1 != 3)
    if torre_em_foco.path1 >= 4: 
        $"HUD_Shop/HudBgDown/Upgrade 1-4".texture_disabled = LastUpgradeCheck
    else:
        if torre_em_foco.path1 == 3:
            var custo_1_4 = torre_em_foco.preços_p1[1]
            if moedas_atuais >= custo_1_4:
                $"HUD_Shop/HudBgDown/Upgrade 1-4".texture_normal = preload("res://Assets/Others/UI_Assets/Carrot.png")
            else:
                $"HUD_Shop/HudBgDown/Upgrade 1-4".texture_normal = preload("res://Assets/Others/UI_Assets/CarrotDisabled.png")
        else:
            $"HUD_Shop/HudBgDown/Upgrade 1-4".texture_disabled = UpgradeLocked



    #/////////// PATH2 ///////////
    $"HUD_Shop/HudBgDown/Upgrade 2-1".disabled = (torre_em_foco.path2 != 0)
    if torre_em_foco.path2 == 1: 
        $"HUD_Shop/HudBgDown/Upgrade 2-1".texture_disabled = UpgradeCheck
    else:
        if torre_em_foco.path2 == 0:
            var custo_2_1 = torre_em_foco.preços_p2[0]
            
            if moedas_atuais >= custo_2_1:
                $"HUD_Shop/HudBgDown/Upgrade 2-1".texture_normal = preload("res://Assets/Others/UI_Assets/Carrot.png")
            else:
                $"HUD_Shop/HudBgDown/Upgrade 2-1".texture_normal = preload("res://Assets/Others/UI_Assets/CarrotDisabled.png")
    
    
    $"HUD_Shop/HudBgDown/Upgrade 2-2".disabled = (torre_em_foco.path2 != 1)
    if torre_em_foco.path2 >= 2: 
        $"HUD_Shop/HudBgDown/Upgrade 2-2".texture_disabled = UpgradeCheck
    else:
        if torre_em_foco.path2 == 1:
            var custo_2_2 = torre_em_foco.preços_p2[1]
            if moedas_atuais >= custo_2_2:
                $"HUD_Shop/HudBgDown/Upgrade 2-2".texture_normal = preload("res://Assets/Others/UI_Assets/Carrot.png")
            else:
                $"HUD_Shop/HudBgDown/Upgrade 2-2".texture_normal = preload("res://Assets/Others/UI_Assets/CarrotDisabled.png")
        else:
            $"HUD_Shop/HudBgDown/Upgrade 2-2".texture_disabled = UpgradeLocked
    
    
    $"HUD_Shop/HudBgDown/Upgrade 2-3".disabled = (torre_em_foco.path2 != 2)
    if torre_em_foco.path2 >= 3: 
        $"HUD_Shop/HudBgDown/Upgrade 2-3".texture_disabled = UpgradeCheck
    else:
        if torre_em_foco.path2 == 2:
            var custo_2_3 = torre_em_foco.preços_p2[1]
            if moedas_atuais >= custo_2_3:
                $"HUD_Shop/HudBgDown/Upgrade 2-3".texture_normal = preload("res://Assets/Others/UI_Assets/Carrot.png")
            else:
                $"HUD_Shop/HudBgDown/Upgrade 2-3".texture_normal = preload("res://Assets/Others/UI_Assets/CarrotDisabled.png")
        else:
            $"HUD_Shop/HudBgDown/Upgrade 2-3".texture_disabled = UpgradeLocked
    
    
    $"HUD_Shop/HudBgDown/Upgrade 2-4".disabled = (torre_em_foco.path2 != 3)
    if torre_em_foco.path2 >= 4: 
        $"HUD_Shop/HudBgDown/Upgrade 2-4".texture_disabled = LastUpgradeCheck
    else:
        if torre_em_foco.path2 == 3:
            var custo_2_4 = torre_em_foco.preços_p2[1]
            if moedas_atuais >= custo_2_4:
                $"HUD_Shop/HudBgDown/Upgrade 2-4".texture_normal = preload("res://Assets/Others/UI_Assets/Carrot.png")
            else:
                $"HUD_Shop/HudBgDown/Upgrade 2-4".texture_normal = preload("res://Assets/Others/UI_Assets/CarrotDisabled.png")
        else:
            $"HUD_Shop/HudBgDown/Upgrade 2-4".texture_disabled = UpgradeLocked



#/////// bloqueio do 3 upgrade //////////
    if torre_em_foco.path1 >= 3:
        $"HUD_Shop/HudBgDown/Upgrade 2-3".disabled = true
        $"HUD_Shop/HudBgDown/Upgrade 2-4".disabled = true

    if torre_em_foco.path2 >= 3:
        $"HUD_Shop/HudBgDown/Upgrade 1-3".disabled = true
        $"HUD_Shop/HudBgDown/Upgrade 1-4".disabled = true
        


func _on_texture_button_pressed() -> void:
    if torre_em_foco != null:

        torre_em_foco.mudar_skin()



func mostrar_preco_1_1() -> void:
    if $"HUD_Shop/HudBgDown/Upgrade 1-1".disabled == false and $"HUD_Shop/HudBgDown/Upgrade 1-1".texture_normal.resource_path == "res://Assets/Others/UI_Assets/Carrot.png":
        $"HUD_Shop/HudBgDown/Upgrade 1-1".modulate = Color(1.211, 1.211, 1.211)
        mostrar1()
        
    if $"HUD_Shop/HudBgDown/Upgrade 1-1".texture_normal.resource_path == "res://Assets/Others/UI_Assets/CarrotDisabled.png":
        mostrar1()


func mostrar_preco_1_2() -> void:
    if $"HUD_Shop/HudBgDown/Upgrade 1-2".disabled == false and $"HUD_Shop/HudBgDown/Upgrade 1-2".texture_normal.resource_path == "res://Assets/Others/UI_Assets/Carrot.png":
        $"HUD_Shop/HudBgDown/Upgrade 1-2".modulate = Color(1.211, 1.211, 1.211)
        mostrar1()
    
    if $"HUD_Shop/HudBgDown/Upgrade 1-2".texture_normal.resource_path == "res://Assets/Others/UI_Assets/CarrotDisabled.png":
        mostrar1()


func mostrar_preco_1_3() -> void:
    if $"HUD_Shop/HudBgDown/Upgrade 1-3".disabled == false and $"HUD_Shop/HudBgDown/Upgrade 1-3".texture_normal.resource_path == "res://Assets/Others/UI_Assets/Carrot.png":
        $"HUD_Shop/HudBgDown/Upgrade 1-3".modulate = Color(1.211, 1.211, 1.211)
        mostrar1()

    if $"HUD_Shop/HudBgDown/Upgrade 1-3".texture_normal.resource_path == "res://Assets/Others/UI_Assets/CarrotDisabled.png":
        mostrar1()

func mostrar_preco_1_4() -> void:
    if $"HUD_Shop/HudBgDown/Upgrade 1-4".disabled == false and $"HUD_Shop/HudBgDown/Upgrade 1-4".texture_normal.resource_path == "res://Assets/Others/UI_Assets/Carrot.png":
        $"HUD_Shop/HudBgDown/Upgrade 1-4".modulate = Color(1.211, 1.211, 1.211)
        mostrar1()

    if $"HUD_Shop/HudBgDown/Upgrade 1-4".texture_normal.resource_path == "res://Assets/Others/UI_Assets/CarrotDisabled.png":
        mostrar1()

func mostrar_preco_2_1() -> void:
    if $"HUD_Shop/HudBgDown/Upgrade 2-1".disabled == false and $"HUD_Shop/HudBgDown/Upgrade 2-1".texture_normal.resource_path == "res://Assets/Others/UI_Assets/Carrot.png":
        $"HUD_Shop/HudBgDown/Upgrade 2-1".modulate = Color(1.211, 1.211, 1.211)
        mostrar2()

    if $"HUD_Shop/HudBgDown/Upgrade 2-1".texture_normal.resource_path == "res://Assets/Others/UI_Assets/CarrotDisabled.png":
        mostrar2()
        
func mostrar_preco_2_2() -> void:
    if $"HUD_Shop/HudBgDown/Upgrade 2-2".disabled == false and $"HUD_Shop/HudBgDown/Upgrade 2-2".texture_normal.resource_path == "res://Assets/Others/UI_Assets/Carrot.png":
        $"HUD_Shop/HudBgDown/Upgrade 2-2".modulate = Color(1.211, 1.211, 1.211)
        mostrar2()

    if $"HUD_Shop/HudBgDown/Upgrade 2-2".texture_normal.resource_path == "res://Assets/Others/UI_Assets/CarrotDisabled.png":
        mostrar2()
        
func mostrar_preco_2_3() -> void:
    if $"HUD_Shop/HudBgDown/Upgrade 2-3".disabled == false and $"HUD_Shop/HudBgDown/Upgrade 2-3".texture_normal.resource_path == "res://Assets/Others/UI_Assets/Carrot.png":
        $"HUD_Shop/HudBgDown/Upgrade 2-3".modulate = Color(1.211, 1.211, 1.211)
        mostrar2()
        
    if $"HUD_Shop/HudBgDown/Upgrade 2-3".texture_normal.resource_path == "res://Assets/Others/UI_Assets/CarrotDisabled.png":
        mostrar2()

func mostrar_preco_2_4() -> void:
    if $"HUD_Shop/HudBgDown/Upgrade 2-4".disabled == false and $"HUD_Shop/HudBgDown/Upgrade 2-4".texture_normal.resource_path == "res://Assets/Others/UI_Assets/Carrot.png":
        $"HUD_Shop/HudBgDown/Upgrade 2-4".modulate = Color(1.211, 1.211, 1.211)
        mostrar2()

    if $"HUD_Shop/HudBgDown/Upgrade 2-4".texture_normal.resource_path == "res://Assets/Others/UI_Assets/CarrotDisabled.png":
        mostrar2()
        

var tween_preco: Tween

func mostrar1():
    var label_preco = $HUD_Shop/HudBgDown/LabelCusto
    if torre_em_foco.path1 < torre_em_foco.preços_p1.size():
        var proximo_custo = torre_em_foco.preços_p1[torre_em_foco.path1]
        label_preco.text = str(proximo_custo) + " 🥕"
        
        # Ativa o Fade In suave
        fade_label_preco(label_preco, 1.0)
            
func mostrar2():
    var label_preco = $HUD_Shop/HudBgDown/LabelCusto
    if torre_em_foco.path2 < torre_em_foco.preços_p2.size():
        var proximo_custo = torre_em_foco.preços_p2[torre_em_foco.path2]
        label_preco.text = str(proximo_custo) + " 🥕"
        
        # Ativa o Fade In suave
        fade_label_preco(label_preco, 1.0)

func tirar_preco() -> void:
    tirar_brilho() 
    var label_preco = $HUD_Shop/HudBgDown/LabelCusto
    
    fade_label_preco(label_preco, 0.0)


func fade_label_preco(label: Label, valor_alvo: float):
    if tween_preco and tween_preco.is_running():
        tween_preco.kill()
    
    tween_preco = create_tween()
    tween_preco.tween_property(label, "modulate:a", valor_alvo, 0.2).set_trans(Tween.TRANS_SINE)


func tirar_brilho():
    var botoes = [$"HUD_Shop/HudBgDown/Upgrade 1-1", $"HUD_Shop/HudBgDown/Upgrade 1-2", $"HUD_Shop/HudBgDown/Upgrade 1-3", $"HUD_Shop/HudBgDown/Upgrade 1-4", $"HUD_Shop/HudBgDown/Upgrade 2-1", $"HUD_Shop/HudBgDown/Upgrade 2-2", $"HUD_Shop/HudBgDown/Upgrade 2-3", $"HUD_Shop/HudBgDown/Upgrade 2-4"]
    
    for botao in botoes:
        if botao :
            botao.modulate = Color(1.0, 1.0, 1.0)


func _on_extra_speed_pressed() -> void:
    $UI_Selection/ExtraSpeed.visible = false
    $UI_Selection/NormalSpeed.visible = true
    Engine.time_scale = 2.0


func _on_normal_speed_pressed() -> void:
    $UI_Selection/ExtraSpeed.visible = true
    $UI_Selection/NormalSpeed.visible = false
    Engine.time_scale = 1.0


func _on_start_round_mouse_entered() -> void:
    if $UI_Selection/StartRound.disabled == false: $UI_Selection/StartRound.modulate = Color(1.211, 1.211, 1.211)
func _on_start_round_mouse_exited() -> void:
    $UI_Selection/StartRound.modulate = Color(1.0, 1.0, 1.0)

func _on_extra_speed_mouse_entered() -> void:
    if $UI_Selection/ExtraSpeed.disabled == false: $UI_Selection/ExtraSpeed.modulate = Color(1.211, 1.211, 1.211)
func _on_extra_speed_mouse_exited() -> void:
    $UI_Selection/ExtraSpeed.modulate = Color(1.0, 1.0, 1.0)
    
func _on_normal_speed_mouse_entered() -> void:
    if $UI_Selection/NormalSpeed.disabled == false: $UI_Selection/NormalSpeed.modulate = Color(1.211, 1.211, 1.211)
func _on_normal_speed_mouse_exited() -> void:
    $UI_Selection/NormalSpeed.modulate = Color(1.0, 1.0, 1.0)


func _on_music_icon_pressed() -> void:
    var slider_sfx = $UI_Selection/Options/MusicControl
    var icon = $UI_Selection/Options/MusicControl/MusicIcon.texture_normal.resource_path
    
    $UI_Selection/Options/Click_AnimMusic.play("click")
    match icon:
        "res://Assets/Others/UI_Assets/Music.png":
            slider_sfx.value = 0
        "res://Assets/Others/UI_Assets/MusicMute.png":
            slider_sfx.value = 100
    
func _on_sfx_icon_pressed() -> void:
    var slider_sfx = $UI_Selection/Options/SFXControl
    var icon = $UI_Selection/Options/SFXControl/SFXIcon.texture_normal.resource_path
    
    $UI_Selection/Options/Click_AnimSFX.play("click")
    match icon:
        "res://Assets/Others/UI_Assets/Audio.png":
            slider_sfx.value = 0
        "res://Assets/Others/UI_Assets/AudioMute.png":
            slider_sfx.value = 100     

func _on_music_control_value_changed(value: float) -> void: 
    if $UI_Selection/Options/MusicControl.value >= 0.01:
        $UI_Selection/Options/MusicControl/MusicIcon.texture_normal = preload("res://Assets/Others/UI_Assets/Music.png")
    else:
        $UI_Selection/Options/MusicControl/MusicIcon.texture_normal = preload("res://Assets/Others/UI_Assets/MusicMute.png")
        
func _on_sfx_control_value_changed(value: float) -> void:
    if $UI_Selection/Options/SFXControl.value >= 0.01:
        $UI_Selection/Options/SFXControl/SFXIcon.texture_normal = preload("res://Assets/Others/UI_Assets/Audio.png")
    else:
        $UI_Selection/Options/SFXControl/SFXIcon.texture_normal = preload("res://Assets/Others/UI_Assets/AudioMute.png")


func _on_auto_play_pressed() -> void:
    var script_spawner = get_tree().get_first_node_in_group("spawner")
    
    if script_spawner:
        # Inverte o valor: se era true vira false, se era false vira true
        script_spawner.autoplay = !script_spawner.autoplay
        print("Autoplay atualizado: ", script_spawner.autoplay)













func _on_button_2_pressed() -> void:
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    
    moedas.text = str(valor_atual - 50)


func MAIS_50kk() -> void:
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    
    moedas.text = str(valor_atual + 50)


func _on_bt_nsell_mouse_entered() -> void:
    $HUD_Shop/HudBgDown/Control/BTNsell/Anim_Sell.play("new_animation")
    await $HUD_Shop/HudBgDown/Control/BTNsell/Anim_Sell.animation_finished


func _on_bt_nsell_mouse_exited() -> void:
    $HUD_Shop/HudBgDown/Control/BTNsell/Anim_Sell.play_backwards("new_animation")
    await $HUD_Shop/HudBgDown/Control/BTNsell/Anim_Sell.animation_finished
