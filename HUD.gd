extends CanvasLayer

signal start_game

func _input(event):
	if $StartButton.visible and event.is_action_pressed("ui_select"):
		$StartButton.emit_signal("pressed")
# update the score
func update_score(value):
	# can call a special UI node called Margincontainer, accessing two HUD elements
	$MarginContainer/ScoreLabel.text = str(value)
# update the timer
func update_timer(value):
	# can call a special UI node called Margincontainer, accessing two HUD elements
	$MarginContainer/TimeLabel.text = str(value)
	
# display message (text)
func show_message(text):
	# Node.property / Node.function
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
# hide messages after timeout
func _on_MessageTimer_timeout():
	# Node.property / Node.function
	$MessageLabel.hide()
	
# start button function
func _on_StartButton_pressed():
	# Node.property / Node.function
	$StartButton.hide()
	$MessageLabel.hide()
	# button sends a signal to Main.gd triggering the new_game function
	emit_signal("start_game")

# init game over HUD
func show_game_over():
	# initiates the show_message function with the "Game Over" string
	show_message("Game Over")
	# holds the Game Over mssage unter MessageTimer (Node Contained in the HUD Scene) cycles
	yield($MessageTimer, "timeout")
	# after timeout, return to "New Game" type state with all the fixings
	$StartButton.show()
	$MessageLabel.text = "Coin Dash!"
	$MessageLabel.show()

