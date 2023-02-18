extends Node


var meteor = load("res://Scenes/meteor.tscn") 

const WORLD_TOP = -1024
const WORLD_LENGTH = 4096 

func _ready():
	global.game_over=false
	if get_tree().get_current_scene().name=="World4":
		get_tree().paused=true
	else :
		$HUD/menu1.hide()
		$HUD.show_message(self.name)
		

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused=true
		$HUD/menu2.show()
	if get_tree().paused==true:
		$HUD/menu1.hide()


func _on_meteorTimer_timeout():
	var meteor_instance = meteor.instance() 
	meteor_instance.position.y = WORLD_TOP 
	meteor_instance.position.x = randi() % WORLD_LENGTH 
	add_child(meteor_instance)


func _on_HUD_basla_oyun():
	$HUD/menu1.hide()
	global.game_over=false
	$HUD.show_message(self.name)
	get_tree().paused = false
	randomize()
	$meteorTimer.start()


func _on_HUD_ayarlar_oyun():
	$HUD/menu3.show()


func _on_HUD_cikis_oyun():
	get_tree().quit()


func _on_HUD_yenidenbasla_oyun():
	$HUD/menu2.hide()
	var _error = get_tree().change_scene("res://Scenes/world4.tscn")


func _on_HUD_devam_oyun():
	$HUD/menu2.hide()
	get_tree().paused = false


func _on_HUD_music_game(value):
	global.music_mute = not value
	var idx = AudioServer.get_bus_index("music")
	AudioServer.set_bus_mute(idx,global.music_mute)


func _on_HUD_sound_game(value):
	global.sound_mute = not value
	var idx = AudioServer.get_bus_index("FX")
	AudioServer.set_bus_mute(idx,global.sound_mute)


func _on_HUD_tamam_ayarlar():
	$HUD/menu3.hide()


func _on_player_game_over():
	global.game_over=true
	$HUD.show_message("Kaybettin")
	$GameOverTimer.start()


func _on_GameOverTimer_timeout():
	var _error = get_tree().reload_current_scene()
