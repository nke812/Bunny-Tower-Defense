extends Node

const SAVE_PATH = "user://player.cfg"

var BunnyCoins: int = 500

var autoplay: bool = false
var CorruptedVisible: bool = false

var ScrappyUnlocked: bool = false
var GhoulishUnlocked: bool = false
var MysticalUnlocked: bool = false
var CorruptedUnlocked: bool = false

var bunyUnlocked: bool = false
var CanelaUnlocked: bool = false
var CatharsisUnlocked: bool = false
var VoidUnlocked: bool = false
var ZeRonUnlocked: bool = false

func _ready() -> void:
    carregar_dados()

func carregar_dados() -> void:
    var config = ConfigFile.new()
    var erro = config.load(SAVE_PATH)

    if erro != OK:
        guardar_dados()
        return
        
    BunnyCoins = config.get_value("Player", "Bunny Coins", 500)
    
    autoplay = config.get_value("Jogo", "autoplay", false)
    CorruptedVisible = config.get_value("Segredos", "CorruptedVisible", false)
    
    ScrappyUnlocked = config.get_value("Bunnies", "Scrappy", false)
    GhoulishUnlocked = config.get_value("Bunnies", "Ghoulish", false)
    MysticalUnlocked = config.get_value("Bunnies", "Mystical", false)
    CorruptedUnlocked = config.get_value("Bunnies", "Corrupted", false)
    
    bunyUnlocked = config.get_value("Skins", "buny", false)
    CanelaUnlocked = config.get_value("Skins", "Canela", false)
    CatharsisUnlocked = config.get_value("Skins", "Catharsis", false)
    VoidUnlocked = config.get_value("Skins", "Void", false)
    ZeRonUnlocked = config.get_value("Skins", "Zé Ron", false)
    
func guardar_dados() -> void:
    var config = ConfigFile.new()
    
    config.set_value("Player", "Bunny Coins", BunnyCoins)
    
    config.set_value("Jogo", "autoplay", autoplay)
    config.set_value("Segredos", "CorruptedVisible", CorruptedVisible)
    
    config.set_value("Bunnies", "Scrappy", ScrappyUnlocked)
    config.set_value("Bunnies", "Ghoulish", GhoulishUnlocked)
    config.set_value("Bunnies", "Mystical", MysticalUnlocked)
    config.set_value("Bunnies", "Corrupted", CorruptedUnlocked)
    
    config.set_value("Skins", "buny", bunyUnlocked)
    config.set_value("Skins", "Canela", CanelaUnlocked)
    config.set_value("Skins", "Catharsis", CatharsisUnlocked)
    config.set_value("Skins", "Void", VoidUnlocked)
    config.set_value("Skins", "Zé Ron", ZeRonUnlocked)
    
    config.save(SAVE_PATH)

func unlock_corrupted() -> void:
    CorruptedVisible = true
    guardar_dados()


#-----   RESET   -----
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("Reset"):
        reset_save()

func reset_save() -> void:
    if Input.is_action_just_pressed("Reset"):
        BunnyCoins = 500
        autoplay = false
        CorruptedVisible = false
        ScrappyUnlocked = false
        GhoulishUnlocked = false
        MysticalUnlocked = false
        CorruptedUnlocked = false
        bunyUnlocked = false
        CanelaUnlocked = false
        CatharsisUnlocked = false
        VoidUnlocked = false
        ZeRonUnlocked = false
        
        guardar_dados()
        get_tree().reload_current_scene()
