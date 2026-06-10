extends Label

func _ready() -> void :
    var valor_M = $"."
    var PGB_M = $"../PGB_M"

    valor_M.text = str(snapped(PGB_M.value, 0))
