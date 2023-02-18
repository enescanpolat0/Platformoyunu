extends RigidBody2D

var main

func _ready():
	
	main = get_tree().get_current_scene()

func _draw():
	
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color.webmaroon)

func _on_ball_body_entered(body):
	
	var is_enemy_ball = self.name.find("enemy_ball", 0) > -1
	var is_player_ball = self.name.find("player_ball", 0) > -1
	var is_enemy = body.name.find("enemy", 0) > -1
	var is_player = body.name.find("player", 0) > -1
	
	
	if is_enemy_ball or is_player_ball:
		queue_free() 
		
		
		if not body.get_node("ball_explosion/explosion_sound").playing:
			body.get_node("ball_explosion/explosion_sound").play()
			
		
		body.get_node("AnimationPlayer").play("hit")
		
		
		body.get_node("ball_explosion").emitting = true
		
		if is_player:
			body.hit = true
			if body.health > 0:
				body.health -= 5
				
				main.get_node("HUD").update_health(body.health) 
		
		if is_enemy:
			body.hit = true
			if body.health > 0: 
				body.health -= 25
				
				body.get_node("HUD_enemy").update_health(body.health) 
				
				var enemies = get_tree().get_nodes_in_group("enemy")
				for e in enemies:
					if body.name == e.name:
						e.get_node("HUD_enemy").show_health(true)
					else:
						e.get_node("HUD_enemy").show_health(false)
