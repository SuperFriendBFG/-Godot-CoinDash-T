extends Area2D

var screensize

func _ready(): # Tween VFX Is Here
	$Timer.wait_time = rand_range(3, 8)
	$Timer.start()	
	$Tween.interpolate_property($AnimatedSprite, 'scale', $AnimatedSprite.scale,
								$AnimatedSprite.scale * 3, 0.3, Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, 'modulate', Color(1, 1, 1, 1),
								Color(1, 1, 1, 0), 0.3, Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)

func pickup():
	# basically sends coin to a trash queue to be deleted at the end of the frame
	monitoring = false
	$Tween.start()
	
func _on_Tween_tween_completed(object, key):
	queue_free()

func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()

func _on_Coin_area_entered(area):
	if area.is_in_group("obstables"):
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))