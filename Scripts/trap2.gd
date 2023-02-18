extends Area2D

var main

func _ready():
	
	main = get_tree().get_current_scene()

func _on_mush_body_entered(body):
	if body.name == "player":
		$AnimationPlayer.play("hit")
		if body.health>0:
			body.health -=15
			main.get_node("HUD").update_health(body.health)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
