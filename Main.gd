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
var playing = false

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	# allows us to hide the player until game starts proper
	$Player.hide()

# starts a new game (attach here to add shortcuts / debug)
func new_game():
	# set the "playing" boolean to true
	# sets to designer defined playtime
	# sets to programmer defined start pos
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	# calls coin spawner
	spawn_coins()
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
		$PowerupTimer.wait_time = rand_range(5, 10)
		$PowerupTimer.start()

	# timer processing
func _on_GameTimer_timout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_Player_pickup(type):
	match type:
		"coin":
			score += 1
			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$PowerupSound.play()
			$HUD.update_timer(time_left)

func _on_Player_hurt():
	game_over()

func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()
	
func _on_PowTimer_timeout():
	var p = Powerup.instance()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(rand_range(0, screensize.x),
						 rand_range(0, screensize.y))

