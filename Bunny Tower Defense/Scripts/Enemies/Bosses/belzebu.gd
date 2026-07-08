extends CharacterBody2D

@export var speed = 130
@export var vida = 400
var speed_base = 130


var goo_stun = false


func _physics_process(delta):
    var pf = get_parent() as PathFollow2D
    pf.progress += speed * delta

    if $"..".progress_ratio >= 0.99:
        get_tree().call_group("HP", "take_dmg", 430)

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()
        get_parent().queue_free()

func DMGED(quantidade):
    var moedas = get_tree().current_scene.find_child("Moedas")

    vida -= quantidade
    atualizar_barra()
    $Dmg.play("Dmg")

    
    if vida <= 50 and $Belzebu.texture.resource_path == "res://Assets/Enemies/Bosses/Belzebu.png":
        $Belzebu.texture = preload("res://Assets/Enemies/Bosses/BelzebuDamaged.png")

    if vida <= 0:
        $Death.play()
        $"../Goo_Splash".visible = false
        $HitBoxBoss.set_deferred("disabled", true)
        
        
        var novo_total = int(moedas.text)
        moedas.text = str(novo_total + 550)
        speed = 0
        $"Dmg".play("Dmg")
        $POP.play("default")
        
        await $"Dmg".animation_finished
        $Belzebu.modulate = Color(0.957, 0.478, 0.965, 0.0)
        
        await $POP.animation_finished

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()

        get_parent().queue_free()
        
func atualizar_barra():
    $"../BossHP".value = vida
    
    if $"../BossHP".visible == false:
        $"../BossHP".visible = true
        

func gooey_stun(TimeSlimed: float, cor_ataque: String):
    if goo_stun: return 
    
    goo_stun = true
    $Belzebu/Goo_Splash.visible = true
    $Belzebu/Goo_Splash.play(cor_ataque)
    
    speed = speed_base / 3

    await get_tree().create_timer(TimeSlimed).timeout
    
    if is_instance_valid(self):
        $Belzebu/Goo_Splash.play_backwards(cor_ataque)
        speed = speed_base
        goo_stun = false
