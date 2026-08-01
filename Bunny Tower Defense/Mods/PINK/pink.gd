extends Node2D

var posicionado = false
var mostrar_range = false
var esta_a_atacar = false # A nossa trava de segurança

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
            esta_a_atacar = true # FECHA A PORTA imediatamente
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


# --- ANIMAÇÕES E POSIÇÕES ---
func anim_idle():
    $PINK.position = Vector2(0, 0)
    $PINK.play("Idle")
    
func anim_atacar():
    $PINK.position = Vector2(15.0, -49.0)
   
func anim_atacar_ult():
    $PINK.position = Vector2(-15, -99)
