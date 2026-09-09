extends Node2D

var corrupted = false

# ----- Items da Loja ----- #

var skins = [
    {"nome": "Void", "preco": 2750, "textura": load("res://Assets/Bunnies/Skins/Void.png")},
    {"nome": "Canela", "preco": 2000, "textura": load("res://Assets/Bunnies/Skins/Canela.png")},
    {"nome": "Buny", "preco": 1010, "textura": load("res://Assets/Bunnies/Skins/buny.png")},
    {"nome": "ZeRon", "preco": 2550, "textura": load("res://Assets/Bunnies/Skins/ZeRon.png")},
    {"nome": "Catharsis", "preco": 2870, "textura": load("res://Assets/Bunnies/Skins/Catharsis.png")},
    {"nome": "Delirium", "preco": 3000, "textura": load("res://Assets/Bunnies/Skins/Delirium.png")}
]


var bunnies = [
    {"nome": "Scrappy", "preco": 4900, "textura": load("res://Assets/Bunnies/Scrappy.png")},
    {"nome": "Ghoulish", "preco": 5750, "textura": load("res://Assets/Bunnies/Ghoulish.png")},
    {"nome": "Mystical", "preco": 8790, "textura": load("res://Assets/Bunnies/Mystical.png")},
]

# ------------------------- #

@onready var ItemShop = $PanelItemShop/ItemShop

var lunie_anim: bool = false

var ItemShopCount: int = 0
var ItemSection: bool = false

func _ready() -> void:
    SaveManager.carregar_dados()
    $BunnyCoins/Price.text = str(SaveManager.BunnyCoins)
    
    if SaveManager.CorruptedVisible == true:
        bunnies.append({
            "nome": "Corrupted", 
            "preco": 6650, 
            "textura": load("")
        })
        $Items/CorruptedCore.visible = false
        
    $ColorRect/FadeOut.play("FadeOut")
    
    $ShopSFX.play()
    verificar_item_shop()


func verificar_item_shop():
    if not ItemSection:
        var item = skins[ItemShopCount]
        ItemShop.texture_normal = item.textura
        $PanelItemShop/PriceTag/Price.text = str(item.preco)
        
        $PanelItemShop/Corrupted.visible = false
    else:
        var item = bunnies[ItemShopCount]
        ItemShop.texture_normal = item.textura
        $PanelItemShop/PriceTag/Price.text = str(item.preco)
        
        $PanelItemShop/Corrupted.visible = (item.nome == "Corrupted")


func _on_item_shop_pressed() -> void:
    var item_atual = bunnies[ItemShopCount] if ItemSection else skins[ItemShopCount]
    var preco = item_atual.preco
    
    if SaveManager.BunnyCoins >= preco:
        var saldo_antigo = SaveManager.BunnyCoins
        $ItemBuy.play()
        SaveManager.BunnyCoins -= preco
        SaveManager.guardar_dados()
        
        atualizar_moedas_com_animacao(saldo_antigo, SaveManager.BunnyCoins)
        
        if not ItemSection:
            var item = skins[ItemShopCount]
            match item.nome:
                "Void": SaveManager.VoidUnlocked = true
                "Canela": SaveManager.CanelaUnlocked = true
                "Buny": SaveManager.bunyUnlocked = true
                "ZeRon": SaveManager.ZeRonUnlocked = true
                "Catharsis": SaveManager.CatharsisUnlocked = true
        else:
            var item = bunnies[ItemShopCount]
            match item.nome:
                "Scrappy": SaveManager.ScrappyUnlocked = true
                "Ghoulish": SaveManager.GhoulishUnlocked = true
                "Mystical": SaveManager.MysticalUnlocked = true
                "Corrupted": SaveManager.CorruptedUnlocked = true
            
        
        SaveManager.guardar_dados()
        
    else:
        button_no_money()
        return
    
    if lunie_anim:
        return
        
    lunie_anim = true
    
    $Lunie.play("default")
    $LunieHand.play("default")
    
    await $LunieHand.animation_finished
    await get_tree().create_timer(1.0).timeout
    
    $LunieHand.play("backwards")
    
    await $LunieHand.animation_finished
    
    lunie_anim = false 

func button_no_money() -> void:
    $ItemRefuse.play()
    if lunie_anim:
        return
        
    lunie_anim = true
    
    $Lunie.play("default")
    $Lunie/NoMoney.play("NoMoney")
    
    await $Lunie/NoMoney.animation_finished
    await get_tree().create_timer(1.0).timeout
    
    $Lunie/NoMoney.play_backwards("NoMoney")
    
    await $Lunie/NoMoney.animation_finished
    
    lunie_anim = false


func atualizar_moedas_com_animacao(saldo_antigo: int, saldo_novo: int) -> void:
    var tween = create_tween()

    tween.tween_method(
        _mudar_texto_label, 
        saldo_antigo, 
        saldo_novo, 
        0.5
    ).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _mudar_texto_label(valor: int) -> void:
    $BunnyCoins/Price.text = str(valor)
    
func Voltar_Menu() -> void:
    get_tree().change_scene_to_file("res://Scenes/loading_Menu.tscn")



                # ---------- BOTÕES DE SELEÇÃO ---------- #
                
func Item_shop_anterior() -> void:
    ItemShopCount -= 1
    
    if ItemShopCount < 0:
        if ItemSection:
            ItemShopCount = bunnies.size() - 1
        else:
            ItemShopCount = skins.size() - 1
    
    $PanelItemShop/ItemShop/ChangeItemShop.play("ChangeItemShop")
    verificar_item_shop()

func Item_shop_seguinte() -> void:
    ItemShopCount += 1
    
    if ItemSection:
        if ItemShopCount >= bunnies.size():
            ItemShopCount = 0
    else:
        if ItemShopCount >= skins.size(): 
            ItemShopCount = 0
    
    $PanelItemShop/ItemShop/ChangeItemShop.play("ChangeItemShop")
    verificar_item_shop()


func change_section() -> void:
    $PanelItemShop/ItemShop/ChangeItemShop.play("ChangeItemShop")
    ItemShopCount = 0

    if ItemSection: 
        ItemSection = false
        $ChangeSection.texture_normal = load("res://Assets/Others/Others/GameIcon.png")
    else: 
        ItemSection = true    
        $ChangeSection.texture_normal = load("res://Assets/Others/HUD_Assets/Skin.png")
    verificar_item_shop()


func _on_corrupted_core_pressed() -> void:
    $Items/CorruptedCore/CorruptedCore.disabled = true
    var corruption = randi_range(1, 1)
    
    if corruption == 1:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        $Items/CorruptedCore/CorruptedCoreSFX.pitch_scale = 0.03
        $Items/CorruptedCore/CorruptedCoreSFX.bus = "Master"
        $Items/CorruptedCore/CorruptedCoreSFX.volume_db = 8.0
        $Items/CorruptedCore/CorruptedCoreSFX.play()
        $ShopMusic.stop()
        $___.visible = true
        $___/CorruptedFaceAppear.play("CorruptedFaceAppear")

        
        await $Items/CorruptedCore/CorruptedCoreSFX.finished
        SaveManager.unlock_corrupted()
        
        get_tree().quit()
    else:
        $Items/CorruptedCore/CorruptedCoreSFX.pitch_scale = 1.0
        $Items/CorruptedCore/CorruptedCoreGone.play("CorruptedCore")
        $Items/CorruptedCore/CorruptedCoreSFX.play()
