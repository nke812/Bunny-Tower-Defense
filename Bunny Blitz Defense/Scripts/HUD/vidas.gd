extends Label

func _process(delta: float) -> void :
    var valor_V = $"."
    var PGB_V = $"../PGB_V"

    valor_V.text = str(snapped(PGB_V.value, 0))

    if PGB_V.value <= 15:
        $"../HeartBroke".visible = true
        $"../Heart".visible = false
    else:
        $"../HeartBroke".visible = false
        $"../Heart".visible = true
