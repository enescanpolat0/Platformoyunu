extends RigidBody2D

var main
var screen_size

const SPEED = 400

func _ready():
	screen_size = get_viewport().size
	main = get_tree().get_current_scene()

func _process(delta):
	position.y += SPEED * delta
	if position.y > screen_size.y:
		queue_free()

func _on_meteor_body_entered(body):
	if body.name == "player":
		queue_free()
		body.hit = true
		
		if not body.get_node("meteor_explosion/explosion_sound").playing:
			body.get_node("meteor_explosion/explosion_sound").play()
			
		body.get_node("AnimationPlayer").play("hit")
		body.get_node("meteor_explosion").emitting = true
		global.shake_amount = 50
		
		if body.health > 0:
			body.health -= 20
			main.get_node("HUD").update_health(body.health)
