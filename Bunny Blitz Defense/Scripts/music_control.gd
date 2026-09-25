extends HSlider

@export var audio_bus_name: String
@export var icon_nodepath: NodePath

@onready var music_slider = $UI_Selection/Options/MusicControl
@onready var sfx_slider = $UI_Selection/Options/SFXControl

var saved_value: float = 1.0
var audio_bus_id: int

const SAVE_PATH := "user://settings.cfg"

func _ready() -> void:
    min_value = 0.0
    max_value = 1.0
    step = 0.05
    
    audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
    
    if value_changed.is_connected(_on_value_changed):
        value_changed.disconnect(_on_value_changed)
    
    load_settings()
    
    value_changed.connect(_on_value_changed)
    
    _apply_volume(value)
    _atualizar_icone(value)


func _on_value_changed(v: float) -> void:
    _apply_volume(v)
    save_value()
    _atualizar_icone(v)


func _apply_volume(v: float) -> void:
    var db = linear_to_db(v)
    AudioServer.set_bus_volume_db(audio_bus_id, db)


func _atualizar_icone(v: float) -> void:
    if not icon_nodepath.is_empty():
        var btn_icone = get_node_or_null(icon_nodepath)
        if btn_icone:
            btn_icone.disabled = (v < 0.01)


func capture_current() -> void:
    saved_value = value

func save_value() -> void:
    saved_value = value
    save_settings()

func revert() -> void:
    value = saved_value
    _apply_volume(value)

func save_settings() -> void:
    var config = ConfigFile.new()
    
    if FileAccess.file_exists(SAVE_PATH):
        config.load(SAVE_PATH)
    
    config.set_value("audio", audio_bus_name + "_volume", saved_value)
    config.save(SAVE_PATH)


func load_settings() -> void:
    var config = ConfigFile.new()
    var erro = config.load(SAVE_PATH)
    
    if erro == OK:
        saved_value = config.get_value("audio", audio_bus_name + "_volume", 1.0)
    else:
        saved_value = 1.0
    
    value = saved_value
