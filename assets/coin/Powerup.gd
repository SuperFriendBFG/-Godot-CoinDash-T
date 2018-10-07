extends Area2D

# used for generating random spawn locations based on x, y grid co-ordinates
var screensize

# init when powerup spawns
func _ready(): 
	# set anim frame to 0 and start
	$AnimatedSprite.frame = 0	
	$AnimatedSprite.play()
	# Tween is a built-in godot FX Still need to learn all the ways it can be used :)
	$Tween.interpolate_property($AnimatedSprite, 'scale', $AnimatedSprite.scale,
								$AnimatedSprite.scale * 3, 0.3, Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, 'modulate', Color(1, 1, 1, 1),
								Color(1, 1, 1, 0), 0.3, Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)

func pickup():
	# basically starts the tween process (VFX) when it is picked up
	monitoring = false
	$Tween.start()
	
# detects when the Tween is completed and then Queues the Powerup for deletion (object and key are generic identifiers for the Tween's properties
func _on_Tween_tween_completed(object, key):
	queue_free()
	
# collision detection for the Powerup
func _on_Powerup_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

# called when Lifetime_timeout signal is received
func _on_Lifetime_timeout():
	queue_free()
