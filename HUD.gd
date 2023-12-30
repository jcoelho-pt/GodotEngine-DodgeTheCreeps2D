extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text):
	# We now want to display a message temporarily, such as "Get Ready"
	
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	# This function is called when the player loses. It will show "Game Over"
	# for 2 seconds, then return to the title screen and, after a brief pause, 
	# show the "Start" button.
	
	show_message("Game Over")
	
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()