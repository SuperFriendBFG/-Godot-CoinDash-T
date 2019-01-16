extends Node
# adds coin to the inspector (Designer Defined)
export (PackedScene) var Coin
export (PackedScene) var Powerup
# adds playtime to the inspector (Designer Defined)
export (int) var playtime

# establish Main vars (tracked throughout each session)
var level
var score
var time_left
var screensize
# main loop variable
var playing = false

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	# allows us to hide the player until game starts proper
	$Player.hide()

# starts a new game (attach here to add shortcuts / debug)
func new_game():
	# set "playing" state to true, other vars
	playing = true
	level = 1
	score = 0
	# sets the "Designer" defined variable to time_left
	time_left = playtime
	# initiates start function in the Player.gd script
	$Player.start($PlayerStart.position)
	# can show / hide elements in a scene at will...
	$Player.show()
	$GameTimer.start()
	# calls coin spawner
	spawn_coins()
	# update HUD
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

# coin spawner
func spawn_coins():
	$LevelSound.play()
	for i in range(4 + level): # difficulty multiplier / adjustment
		var c = Coin.instance()
		# spawns new coin child for each coin to be spawned
		$CoinContainer.add_child(c)
		c.screensize = screensize
		# set pos (randomized)
		c.position = Vector2(rand_range(0, screensize.x),
		rand_range(0, screensize.y))

# Coin processing
func _process(delta):
	# keep track of current coins remaining
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$PowTimer.wait_time = rand_range(5, 10)
		$PowTimer.start()

# timer processing (Gets Signal from GameTimer Node)
func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

# matches whether pickup is coin or powerup (Gets Signal from Player Node)
func _on_Player_pickup(type):
	match type:
		"coin":
			score += 1
			$CoinSound.play()
			# update Score tally in HUD.gd script
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$PowerupSound.play()
			# update HUD timer in HUD.gd script 
			$HUD.update_timer(time_left)

# initiates game_over when player is hurt (1 life, Gets Signal from Player Node)
func _on_Player_hurt():
	game_over()

# game_over function called by _on_Player_hurt signal
func game_over():
	$EndSound.play()
	# set "playing gamestate to false"
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	# call the show_came_over function in the HUD.gd script
	$HUD.show_game_over()
	# call the die function in the Player.gd script
	$Player.die()
	
# on_PowTimer_timeout signal triggers this function call from the PowTimer node
# Note that the timer is self contained within the Powerup.gd script
func _on_PowTimer_timeout():
	# create self contained variable, based on the Powerup / in a self contained instance
	var p = Powerup.instance()
	add_child(p)
	# determine where the Powerup goes
	p.screensize = screensize
	# give Powerup a position
	p.position = Vector2(rand_range(0, screensize.x),
						 rand_range(0, screensize.y))

