extends Area2D

signal hit # this defines a custom signal called "hit" that we will have our player emit (send out) when it collides with an enemy. 


# Using the export keyword on the first variable speed allows us to set its value in the Inspector.
@export var speed = 400 # How fast the player will move (pixels/sec)

var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# hide() # the player will be hidden when the game starts


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# We start by setting the velocity to (0, 0) - by default, the player should not be moving. 
	# Then we check each input and add/subtract from the velocity to obtain a total direction. 
	# For example, if you hold right and down at the same time, the resulting velocity vector will be (1, 1). 
	# (0,0).---------> X
	#      |
	#      |
	#      |
	#    Y |
	#
	# In this case, since we're adding a horizontal and a vertical movement, the player would move faster diagonally 
	# than if it just moved horizontally.
	# 
	# We can prevent that if we normalize the velocity, which means we set its length to 1, 
	# then multiply by the desired speed. This means no more fast diagonal movement.
	
	var velocity = Vector2.ZERO # The player's movement vector - velocity = (0,0)
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # normalize the velocity, which means we set its length to 1
		print("velocity: ", velocity)
		$AnimatedSprite2D.play()  # $ is shorthand for get_node(). So in the code above, $AnimatedSprite2D.play() is the same as get_node("AnimatedSprite2D").play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) # use clamp() to prevent it from leaving the screen. Clamping a value means restricting it to a given range. 
	print("position: ", position)
	
	# The delta parameter in the _process() function refers to the frame length - the amount of time that the previous frame took to complete. 
	# Using this value ensures that your movement will remain consistent even if the frame rate changes.

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	# Each time an enemy hits the player, the signal is going to be emitted. 
	# We need to disable the player's collision so that we don't trigger the hit signal more than once.
	# Disabling the area's collision shape can cause an error if it happens in the middle of the engine's collision processing. 
	# Using set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	

