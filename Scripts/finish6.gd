extends Area2D

var main
var error
var is_finish

func _ready():
	main = get_tree().get_current_scene()
	pass
	
func _on_finish_body_entered(body):
	if body.name == "player":
		if body.score == 0:
			is_finish = true
			$AnimationPlayer.play("hit")
		else:
			$AnimationPlayer.play("red")

func _on_AnimationPlayer_animation_finished(_anim_name):
	if is_finish:
		queue_free()
		if main.name == "World6":
			error = get_tree().change_scene("res://Scenes/world.tscn")
		else:
			error = get_tree().change_scene("res://Scenes/world6.tscn")
