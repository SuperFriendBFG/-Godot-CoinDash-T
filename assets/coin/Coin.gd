extends Area2D

var screensize


# Sprite VFX Anim (Tween)
func _ready():
	$Timer.wait_time = rand_range(3, 8) # Randomized Timer to have variation in the animation
	$Timer.start()						# Start Timer
	$Tween.interpolate_property($AnimatedSprite, 'scale', $AnimatedSprite.scale,		# Type of Anim = Scale
								$AnimatedSprite.scale * 3, 0.3, Tween.TRANS_QUAD,		# Set Factors (3 at 0.3 Speed | TRANS QUAD)
								Tween.EASE_IN_OUT)										# Smooth the tween at the end
	$Tween.interpolate_property($AnimatedSprite, 'modulate', Color(1, 1, 1, 1),			# Color Fade (TransParency)
								Color(1, 1, 1, 0), 0.3, Tween.TRANS_QUAD,				# Set Factors (Transp at 0.3 | TRANS QUAD)
								Tween.EASE_IN_OUT)										# Smooth the tween at the end

func pickup():
	monitoring = false	# Ceases Monitoring Coin once picked up / Removed Next Frame
	$Tween.start()		# Starts Tween Anim when Coin despawns
	
func _on_Tween_tween_completed(object, key):	# When Tween Complete
	queue_free()								# Removes Object

func _on_Timer_timeout():						# Level Timer Timeout
	$AnimatedSprite.frame = 0					# Set Sprite Anim frame to 0
	$AnimatedSprite.play()						# Trigger Shiny Anim for Coin

func _on_Coin_area_entered(area):				# Collision Detection for when Coin spawns inside an Obstacle (Impassable by Player)
	if area.is_in_group("obstables"):			# If Coin spawn on Obstacle
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))	# Reset a new X, Y Co-Ord for Respawn
