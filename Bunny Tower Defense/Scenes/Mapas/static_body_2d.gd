extends Node2D

var posicionado = false
var mostrar_range = false
var esta_a_atacar = false

# Renomeado para evitar conflito com a função reservada range() do GDScript
var tamanho_range = Vector2(1.0, 1.0)

var pink_ult = 3

func _ready() -> void:
    anim_idle()

func _process(_delta: float) -> void: 
    if esta_a_atacar:
        return
        
    if not $Timer.is_stopped():
        return

    if pink_ult >= 7:
        verificar_e_atacar_ult()
    else:
        verificar_e_atacar()


# --- ATAQUE NORMAL ---
func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            esta_a_atacar = true
            atacar(corpo)
            break

func atacar(alvo):
    anim_atacar()
    $PINK.play("PreAttack")
    await $PINK.animation_finished
    
    if is_instance_valid(alvo) and alvo.has_method("DMGED"):
        $PINK.play("Attack")
        alvo.DMGED(5)
        
    await $PINK.animation_finished
    anim_idle()
    
    pink_ult += 1
    print("Cargas Ult: ", pink_ult)
    
    $Timer.start()
    esta_a_atacar = false


# --- ATAQUE DA ULT (AoE) ---
func verificar_e_atacar_ult():
    var corpos = $Range.get_overlapping_bodies()
    var tem_alvos = false
    
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            tem_alvos = true
            break
            
    if tem_alvos:
        esta_a_atacar = true
        atacar_ult(corpos)

func atacar_ult(corpos):
    anim_atacar_ult()
    $attackUlt.play()
    $PINK.play("PreAttackUlt")
    await $PINK.animation_finished
    
    $PINK.play("AttackUlt")
    
    for corpo in corpos:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings") and corpo.has_method("DMGED"):
            corpo.DMGED(15)
            
    await $PINK.animation_finished
    anim_idle()
    
    pink_ult = 0 
    
    $Timer.start()
    esta_a_atacar = false


# --- ATAQUE DA ULTRA ULT (AoE) ---
func verificar_e_atacar_ultra_ult():
    var corpos = $Range.get_overlapping_bodies()
    var tem_alvos = false
    
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            tem_alvos = true
            break
            
    if tem_alvos:
        esta_a_atacar = true
        atacar_ultra_ult(corpos)

func atacar_ultra_ult(corpos):
    for corpo in corpos:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings") and corpo.has_method("DMGED"):
            corpo.DMGED(60) 
    
    $Timer.start()
    esta_a_atacar = false


# --- AÇÃO DO BOTÃO ---
func _on_button_pressed() -> void:
    $AnimationPlayer.play("PinkCutscene")
    $"../Map3Music".stop()
    $"MUSICA-FODA-PRA-CRLH".play()
    $Button.disabled = true

    await $"MUSICA-FODA-PRA-CRLH".finished
    $MAGICMEWMEWCUTIE.play()

    await $AnimationPlayer.animation_finished
    $pink.disabled = false


# --- ANIMAÇÕES E POSIÇÕES ---
func anim_idle():
    $Range.monitorable = true
    $Range.monitoring = true
    
    tamanho_range = Vector2(1.0, 1.0)
    $Range.scale = tamanho_range
    $PINK.position = Vector2(0, 0)
    $PINK.play("Idle")
    
func anim_atacar():
    $PINK.position = Vector2(15, -49)
   
func anim_atacar_ult():
    $PINK.position = Vector2(-15, -99)


# --- ANIMAÇÕES CUTSCENE (Call Method Track) ---
func FootSlam():
    $PINK.play("FootSlam")
    $foot.play()

func Kick():
    $PINK.play("Kick")
    $kick.play()

func Laugh():
    $PINK.play("Laugh")
    $laugh.play()

func Push():
    $PINK.play("Push")

func Running():
    $PINK.play("Running")
    $running.play()

func AttackUltraUlt():
    $PINK.play("AttackUltraUlt")
    $laugh.play()
    $PINK.position = Vector2(13, -111)

func Release():
    $attackUlt.play()
    $PINK.play("Release")

func Exploded():
    $PINK.position = Vector2(0, 0)
    $PINK.play("Exploded")
    $running.play()

func ExplodedClean():
    $kick.play()
    $PINK.position = Vector2(0, 0)
    $PINK.play("ExplodedClean")

func EXPLOSION():
    $EXPLOSION.play("default")
    $EXPLOSION/AudioStreamPlayer.play()  
func EXPLOSION2():
    $"../EXPLOSION2".play("default")
    $EXPLOSION/AudioStreamPlayer.play()



# --- CORREÇÃO DA EXPLOSÃO ULTRA ULT ---
func attack_explosion():
    $Range.scale = Vector2(10.0, 10.0)
    
    await get_tree().physics_frame
    
    verificar_e_atacar_ultra_ult()
    attack_explosion_exit()

func attack_explosion_exit():
    $Range.scale = Vector2(1.0, 1.0)


# --- DESENHAR RANGE ---
func _draw() -> void:
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x * $Range.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_pink_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_pink_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()

func _on_ultrault_pressed() -> void:
    $AnimationPlayer.play("UltraUlt")
