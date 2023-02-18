extends KinematicBody2D

signal game_over

var ball = load("res://Scenes/ball.tscn") 
var can_fire = true
var fire_direction = 1

var direction = 0
var velocity = Vector2()

var is_jumping = false
var fall_has_played = false

var hit = false
var score = 0
var health = 100

const SPEED = 400
const GRAVITY = 100
const JUMP = 2000
const BULLET_SPEED = 2000
const FIRE_RATE = 0.5

onready var Baba = get_node("Sprite")
onready var walk = get_node("walk_sound")
onready var jump = get_node("jump_sound")
onready var fall = get_node("fall_sound")

func _ready():
	pass
	
func _process(_delta):
	if global.game_over:
		return
	if hit == false:
		global.shake_amount=0
	$Camera2D.set_offset(Vector2(
		rand_range(-2.0,2.0)*global.shake_amount,
		rand_range(-2.0,2.0)*global.shake_amount
	))
	direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
	if Input.is_action_pressed("ui_select"):
		if is_on_floor():
			is_jumping = true
			velocity.y += -JUMP
			
	fire_check()
	
	velocity.x = direction * SPEED
	velocity.y += GRAVITY
	
	if position.y > 5000:
		emit_signal("game_over")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	update_animation()
	
func fire_check():
	
	if Input.is_action_pressed("ui_hit") and can_fire:
		var ball_instance = ball.instance()
		ball_instance.name = "player_ball"
		ball_instance.set_collision_mask_bit(4, true) 
		ball_instance.position = $BallPoint.get_global_position()
		ball_instance.apply_impulse(Vector2(), Vector2(BULLET_SPEED * fire_direction, 0))
		get_tree().get_root().add_child(ball_instance)
		can_fire = false
		yield(get_tree().create_timer(FIRE_RATE), "timeout")
		can_fire = true
	
func update_animation():
	if damage_and_dead_animations():
		return
	if is_on_floor():
		is_jumping = false
		fall_has_played = false
		if direction == 1: 
			Baba.flip_h = false 
			if not walk.playing:
				walk.play()
			Baba.play("Walk")
		elif direction == -1: 
			Baba.flip_h = true 
			if not walk.playing:
				walk.play()
			Baba.play("Walk") 
		else:
			Baba.play("Idle") 
	else:
		if direction == 1:
			Baba.flip_h = false
		elif direction == -1:
			Baba.flip_h = true
		
		if Input.is_action_pressed("ui_select"):
			if not jump.playing:
				jump.play()
			Baba.play("Jump")
		elif not is_jumping:
			if not fall.playing:
				if not fall_has_played:
						fall.play()
						fall_has_played = true
			Baba.play("Fall")
			
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
	
	if health <= 0 and is_on_floor():
			Baba.play("Dead")
			if Baba.frame == 7:
				emit_signal("game_over")
				return true
			else:
				return true
	return false
