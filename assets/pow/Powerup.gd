extends Area2D

var screensize # Get Screensize Var for scriptes

# init when powerup spawns
func _ready(): 
	$AnimatedSprite.frame = 0	# Set Sprite Anim Frame to 0 (for looping)
	$AnimatedSprite.play()		# Trigger Sprite Anim Start
	# Tween is a built-in godot FX Still need to learn all the ways it can be used :)
	$Tween.interpolate_property($AnimatedSprite, 'scale', $AnimatedSprite.scale,	# Scaling using Tween
								$AnimatedSprite.scale * 3, 0.3, Tween.TRANS_QUAD,	# Scale Factor
								Tween.EASE_IN_OUT)									# Ease Out of Scale Anim (Smoothness)
	$Tween.interpolate_property($AnimatedSprite, 'modulate', Color(1, 1, 1, 1),		# Transparency using Tween
								Color(1, 1, 1, 0), 0.3, Tween.TRANS_QUAD,			# Trans Factor
								Tween.EASE_IN_OUT)									# Easy Out of Scale Anim (Smoothness)

func pickup():
	monitoring = false		# Tags for removal when picked up
	$Tween.start()			# Starts Tween Anim when picked up
	
# detects when the Tween is completed and then Queues the Powerup for deletion (object and key are generic identifiers for the Tween's properties
func _on_Tween_tween_completed(object, key):
	queue_free()
	
func _on_Powerup_area_entered(area): 	# Collision Detection in case PowerUp spawns inside a Cactus
	if area.is_in_group("obstacles"):	# Define group "Obstacles" - Impassable by Player
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))	# Redefined Position (NewPos)

func _on_Lifetime_timeout(): # PowerUps have limited LifeTime, this gets called when that timer runs out
	queue_free()
