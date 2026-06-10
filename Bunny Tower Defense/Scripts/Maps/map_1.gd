extends Node2D

func _process(_delta: float) -> void :

    # Puxa a lista dos inimigos normais e a lista dos bosses separadamente
    var normais = get_tree().get_nodes_in_group("Ghostlings")
    var bosses = get_tree().get_nodes_in_group("Bosses")

    var all_ghoztlings = normais + bosses
    
    

    for ghostling in all_ghoztlings:

        var o_pai = ghostling.get_parent()

        if o_pai is PathFollow2D:

            if o_pai.progress_ratio >= 0.72 and o_pai.progress_ratio <= 0.805:
                ghostling.modulate.a = 0.1

                ghostling.set_deferred("collision_layer", 0)
                ghostling.set_deferred("collision_mask", 0)
            else:
                ghostling.modulate.a = 1.0
                ghostling.set_deferred("collision_layer", 1)
                ghostling.set_deferred("collision_mask", 1)
