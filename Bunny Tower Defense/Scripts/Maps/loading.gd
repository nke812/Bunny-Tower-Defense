extends Node2D

@onready var loading = $ProgressBar
@export var ProxCena: String = "res://Scenes/Mapas/Map_1.tscn"
var progress: Array[float] = []

func _ready():
   ResourceLoader.load_threaded_request(ProxCena)

func _process(delta):
    var percentagem = ResourceLoader.load_threaded_get_status(ProxCena, progress)
    
    match percentagem:
        ResourceLoader.THREAD_LOAD_IN_PROGRESS:
            var pct_barra = progress[0] * 100
            loading.value = pct_barra
        ResourceLoader.THREAD_LOAD_LOADED:
            var cena = ResourceLoader.load_threaded_get(ProxCena)
            get_tree().change_scene_to_packed(cena)
