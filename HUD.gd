extends CanvasLayer

signal start_game

func _input(event):
	if $StartButton.visible and event.is_action_pressed("ui_select"):
		$StartButton.emit_signal("pressed")

func update_score(value):							# Score Update Routine for MarginContainer
	$MarginContainer/ScoreLabel.text = str(value)	# Set Value as String for Display on HUD
func update_timer(value):							# Timer Update Routine for MarginContainer
	$MarginContainer/TimeLabel.text = str(value)	# Set Value as string for Display on HUD
	
func show_message(text):							# Displays a Message (Text Param)
	$MessageLabel.text = text						# Variable Est
	$MessageLabel.show()							# Show Message
	$MessageTimer.start()							# Starts timer
	
func _on_MessageTimer_timeout():					# Message Timeout (Hides After X Time)
	$MessageLabel.hide()
	
func _on_StartButton_pressed():						# Calls Engine Function for Start Button Press
	$StartButton.hide()								# Hides the Start Button
	$MessageLabel.hide()							# Hides the MessageLabel
	emit_signal("start_game")						# Signal Emitter for Start Game

func show_game_over():								# Game Over Script
	show_message("Game Over")						# Displays a Game Over Message
	yield($MessageTimer, "timeout")					# Adds MessageTimer for GameOver

	$StartButton.show()								# Add Start Button (To Restart Game)
	$MessageLabel.text = "Coin Dash!"				# Title Message is Back
	$MessageLabel.show()							# Show Title Screen

