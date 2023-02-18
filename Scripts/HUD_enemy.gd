extends CanvasLayer

func update_health(health):
	$ProgressBar.value = health

func show_health(show):
	$ProgressBar.visible = show
