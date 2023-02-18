extends CanvasLayer
signal basla_oyun
signal devam_oyun
signal yenidenbasla_oyun
signal cikis_oyun
signal ayarlar_oyun
signal tamam_ayarlar
signal music_game(value)
signal sound_game(value)

func show_message(text):
	$Msg.text = text
	$Msg.show()
	$MsgTimer.start()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_health(health):
	$ProgressBar.value = health

func _on_MsgTimer_timeout():
	$Msg.hide()


func _on_baslangic_pressed():
	emit_signal("basla_oyun")


func _on_ayar_pressed():
	emit_signal("ayarlar_oyun")


func _on_cikis_pressed():
	emit_signal("cikis_oyun")


func _on_devam_pressed():
	emit_signal("devam_oyun")


func _on_yenidenbasla_pressed():
	emit_signal("yenidenbasla_oyun")


func _on_tamam_pressed():
	emit_signal("tamam_ayarlar")



func _on_musiccheckbox_toggled(button_pressed):
	emit_signal("music_game",button_pressed)


func _on_soundcheckbox_toggled(button_pressed):
	emit_signal("sound_game",button_pressed)

