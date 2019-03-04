extends Node
# Designer Defined Variables (Coins, Powerups, Playtime)
export (PackedScene) var Coin		# Coins Per Level
export (PackedScene) var Powerup	# Powerups Per Level
export (int) var playtime			# Max Play Time per Level

# establish Main vars (tracked throughout each session)

var level 				# Current Level
var score 				# Current Score
var time_left 			# Time Left (timer on HUD)
var screensize 			# Engine Default Screen Size
var playing = false 	# Global Variable for Playing True | False

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()		# allows us to hide the player until game starts proper

# starts a new game (attach here to add shortcuts / debug)
func new_game():
	playing = true			# Set Playing to True
	level = 1				# Code Controlled Level Select (1-X)
	score = 0				# Reset starting score to 0
	time_left = playtime	# Designer Defined Playtime (Check Level itself)
	
	# Init Player
	$Player.start($PlayerStart.position)	# Spawns Player 
	$Player.show()							# Show Player
	$GameTimer.start()						# Start Game Timer (Count Up)
	
	# calls coin spawner
	spawn_coins()
	
	# Init HUD (Update Score and Time Left)
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

# coin spawner Script
func spawn_coins():
	$LevelSound.play()
	# Rules for Coin Spawning
	for i in range(4 + level): 			# difficulty multiplier / adjustment
		var c = Coin.instance()			# set instance of coin as "c"
		$CoinContainer.add_child(c)		# spawns new coin child for each coin to be spawned
		c.screensize = screensize		# Coin.screensize = screensize
		c.position = Vector2(rand_range(0, screensize.x),	# Set Coin POS to Randomized(X)
		rand_range(0, screensize.y))						# Set Coin POS to Randomized(Y)

# Coin processing
func _process(delta):
	# keep track of current coins remaining
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1 		# Add +1 to Level Count for each new level
		time_left += 5	# Amount of Time added to Each subsequent level		
		spawn_coins()	# Call Spawn_Coins Script
		$PowTimer.wait_time = rand_range(5, 10)		# Powerup Timer is on a Randomized Timer
		$PowTimer.start()							# Start Timer 

# Timer Scripts (Gets Data from GameTimer Node)
func _on_GameTimer_timeout():
	time_left -= 1					# Tick Timer down by -1
	$HUD.update_timer(time_left)	# Update HUD with (time_left)	
	if time_left <= 0:				# If Timer = 0 then Game Over
		game_over()

# matches whether pickup is coin or powerup (Gets Signal from Player Node)
func _on_Player_pickup(type):
	match type: 						# Matches the Type to either Coin or Powerup. Any new Pickup Types go here
		"coin":							# Type: Coin
			score += 2					# Set Score to +1 for Each Coin. (Note: Can be altered)
			$CoinSound.play()			# Play Coin Pickup Sound
			$HUD.update_score(score)	# Update Score on the HUD
		"powerup":							# Type: Powerup
			time_left += 10					# Add +10 to TIme Left
			score +- 5						# Add +5 to Score
			$PowerupSound.play()			# Play PowerUp sound 
			$HUD.update_timer(time_left)	# Update Timer on the HUD
			$HUD.update_score(score)		# Update Score on the HUD

# initiates game_over script when Player is hurt (Signal from Player Node. 1 Life)
func _on_Player_hurt():
	game_over()

# Game_Over Script
func game_over():
	$EndSound.play()					# Trigger EndSound
	playing = false						# Set Gamestate (playing) to False
	$GameTimer.stop()					# Stop GameTimer
	for coin in $CoinContainer.get_children(): 	# For All Coins
		coin.queue_free()						# Delete Coins
	$HUD.show_game_over() 						# Calls Game_Over Script
	$Player.die()								# Calls Die Script
	
# Powerup timer Timeout Script triggers when a PowerUp Times Out (Manages Powerup Respawn)
func _on_PowTimer_timeout():
	var p = Powerup.instance()				# Create a Powerup Instance
	add_child(p)							# Add the Child
	p.screensize = screensize				# Screensize Var for PowerUp
	p.position = Vector2(rand_range(0, screensize.x),	# PowerUp X Position 
						 rand_range(0, screensize.y))	# Powerup Y Position

