extends KinematicBody2D

var ball = load("res://Scenes/ball.tscn") 
var can_fire = true
var fire_direction = 1

var direction = -1
var velocity = Vector2.ZERO
var platform_end = false

var hit = false
var health = 100000

const SPEED = 0
const GRAVITY = 100
const ATTACK_DISTANCE = 500
const BALL_SPEED = 1000
const FIRE_RATE = 1

onready var Baba = get_node("Sprite")
onready var walk = get_node("walk_sound")
onready var jump = get_node("jump_sound")
onready var fall = get_node("fall_sound")

func _ready():
	pass

func _process(_delta):
	
	raycast_check()
		
	raycast_check()
		
	velocity.x = direction * SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2.UP)
	update_animations()
	
func raycast_check():
	
	$RayCast2D.cast_to.x = ATTACK_DISTANCE * direction
	$RayCast2D2.cast_to.x = ATTACK_DISTANCE * direction 
	
	if $RayCast2D.is_colliding() and can_fire:
		var ball_instance = ball.instance()
		ball_instance.name = "enemy_ball"
		ball_instance.set_collision_mask_bit(4, false) 
		ball_instance.position = $BallPoint.get_global_position()
		ball_instance.apply_impulse(Vector2(), Vector2(BALL_SPEED * fire_direction, 0))
		get_tree().get_root().add_child(ball_instance)
		can_fire = false
		yield(get_tree().create_timer(FIRE_RATE), "timeout")
		can_fire = true
		
		
	if $RayCast2D2.is_colliding() and can_fire:
		var ball_instance = ball.instance()
		ball_instance.name = "enemy_ball"
		ball_instance.set_collision_mask_bit(4, false) 
		ball_instance.position = $BallPoint.get_global_position()
		ball_instance.apply_impulse(Vector2(), Vector2(BALL_SPEED * fire_direction, 0))
		get_tree().get_root().add_child(ball_instance)
		can_fire = false
		yield(get_tree().create_timer(FIRE_RATE), "timeout")
		can_fire = true
func update_animations():
	if damage_and_dead_animations():
		return
	if is_on_floor():
		if direction == 1: 
			Baba.flip_h = false 
			if not walk.playing:
				walk.play()
			Baba.play("Idle")
		elif direction == -1: 
			Baba.flip_h = true 
			if not walk.playing:
				walk.play()
			Baba.play("Idle") 
		else:
			Baba.play("Idle") 
	set_sprite_offset()
	

func set_sprite_offset():
	if Baba.flip_h == true and Baba.offset.x > 0:
		Baba.offset *= -1
		fire_direction = -1
		$BallPoint.position.x = -50
	
	if Baba.flip_h == false and Baba.offset.x < 0:
		Baba.offset *= -1
		fire_direction = 1
		$BallPoint.position.x = 50

func damage_and_dead_animations()-> bool:
	
	if hit == true:
		Baba.play("Dead")
		if Baba.frame == 0:
			return true
		else:
			hit = false

	if health == 0:
		if is_on_floor():
			Baba.play("Dead")
			if Baba.frame == 7:
				self.queue_free()
				return true
			else:
				return true
	return false
func _on_VisibilityNotifier2D_screen_entered():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		if self.name == e.name:
			e.get_node("HUD_enemy").show_health(true)
		else:
			e.get_node("HUD_enemy").show_health(false)

func _on_VisibilityNotifier2D_screen_exited():
	$HUD_enemy.show_health(false)
