extends Node

const SAVE_PATH = "user://PlayerSettings.cfg"

var autoplay: bool = false

func _ready():
    autoplay = load_PlayerSettings()

func load_PlayerSettings() -> bool:
    var config = ConfigFile.new()
    var erro = config.load(SAVE_PATH)

    var estado_salvo = config.get_value("Jogo", "autoplay", false)

    if erro != OK:
        save_PlayerSettings(false)
        return false
    return estado_salvo

func save_PlayerSettings(valor: bool) -> void:
    var config = ConfigFile.new()
    config.load(SAVE_PATH)
    
    config.set_value("Jogo", "autoplay", valor) 
    config.save(SAVE_PATH)

    autoplay = valor
