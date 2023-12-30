extends Node

# to allow us to choose the Mob scene we want to instance
@export var mob_scene: PackedScene

var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	# connected to Player.hit() signal
	$ScoreTimer.stop()
	$MobTimer.stop()
	print("SCORE: ", score)
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	# The call_group() function calls the named function on every node in a group
	# - in this case we are telling every mob to delete itself (useful when restarting a game)
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D. 
	# The PathFollow2D node will automatically rotate as it follows the path, 
	# so we will use that to select the mob's direction as well as its position. 
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob for how fast each mob will move 
	# (it would be boring if they were all moving at the same speed).
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	# When we spawn a mob, we'll pick a random value between 150.0 and 250.0
	add_child(mob)
	
	
