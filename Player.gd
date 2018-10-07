# includes
extends Area2D
# node signals (called in funcs)
signal pickup
signal hurt
# export allows programmers to decide which variables to expose to the Inspector on the right (To allow Level Designers to modify)
export (int) var speed
# establish common vars, including velocity and screen size
var velocity = Vector2()
var screensize = Vector2(480, 720)

# ensure normalized velocity regardless of screen size
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func _process(delta):
	# call get_input for Normalized Values
	get_input()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	# change anim based on player direction
	if velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		# flip sprite when turning
		$AnimatedSprite.flip_h = velocity.x < 0
#		This code block doesn't work. Attempted to solve the problem of the sprite always facing right when moving up/down
#		
#		if Input.is_action_pressed("ui_up", "ui_left"):
#			$AnimatedSprite.flip.h = velocity.x < 0
#		elif Input.is_action_pressed("ui_down", "ui_left"):
#			$AnimatedSprite.flip.h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"

# called when game starts 
func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"
	
# called on player death / failure
func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)
	
# called when player enteres defined "area"
func _on_Player_area_entered( area ):
	# we defined groups in editor, can be used to categorize with is_in_group() statement
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup", "coin")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		# call the die function
		die()
