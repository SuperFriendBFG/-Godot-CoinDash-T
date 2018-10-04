extends CanvasLayer

signal start_game

func _input(event):
	if $StartButton.visible and event.is_action_pressed("ui_select"):
		$StartButton.emit_signal("pressed")
# update the score
func update_score(value):
	$MarginContainer/ScoreLabel.text = str(value)
#update the timer
func update_timer(value):
	$MarginContainer/TimeLabel.text = str(value)
	
# display message (text)
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
# hide messages after timeout
func _on_MessageTimer_timeout():
	$MessageLabel.hide()
	
# start button function
func _on_StartButton_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	emit_signal("start_game")

# init game over HUD
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$StartButton.show()
	$MessageLabel.text = "Coin Dash!"
	$MessageLabel.show()

