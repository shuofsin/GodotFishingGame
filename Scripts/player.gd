extends CharacterBody2D


const SPEED = 100

# Fisherman are of the sea, not the sky 
const JUMP_VELOCITY = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Get animation controller
@onready var animated_sprite = $AnimatedSprite2D

# Get game manager
@onready var game_manager = $"../Game Manager"

# Get messenger label
@onready var messenger = $"../Game Manager/messenger"

#state controller 
var state = "movement"

#position checker 
var barrel = false

#got fish? checker
var caught_fish = false
var lost_fish = false
var num_fish = 0

func _physics_process(delta):
	# movement state
	if state == "movement": 
		#check for fish
		if caught_fish == true: 
			game_manager.add_fish()
			caught_fish = false
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
	#
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and barrel:
			velocity.y = JUMP_VELOCITY
			state = "throw_hook"

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		
		# Handle animations 
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")
		
		if direction > 0:
			animated_sprite.flip_h = false
			animated_sprite.offset.x = 0
		elif direction < 0:
			animated_sprite.flip_h = true  
			animated_sprite.offset.x = -16
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		messenger.text = "Press space to fish!"
		lost_fish = false
		animated_sprite.offset.y = 0
	elif state == "throw_hook":
		animated_sprite.play("throw_hook")
		if animated_sprite.frame == 6:
			state = "fish"
		animated_sprite.offset.y = 1
	elif state == "fish":
		if lost_fish == false: 
			messenger.text = "Now hold it..."
		else: 
			messenger.text = "Too slow..."
		animated_sprite.play("fish")
		if Input.is_action_just_pressed("ui_accept"):
			state = "pull_hook"
		var found_fish = randi() % 500 + 1
		if (found_fish % 500 == 0):
			state = "found_fish"
		animated_sprite.offset.y = 1
	elif state == "pull_hook":
		animated_sprite.offset.y = 1
		if caught_fish == false: 
			animated_sprite.play("pull_hook")
		else:
			animated_sprite.play("pull_hook_fish")
		if animated_sprite.frame == 6:
			state = "movement"
	elif state == "found_fish":
		animated_sprite.play("found_fish")
		animated_sprite.offset.y = 1
		messenger.text = "It's on the hook!"
		if Input.is_action_just_pressed("ui_accept"):
			state = "pull_hook"
			caught_fish = true
			messenger.text = "You caught a fish!"
		var found_fish = randi() % 100 + 1
		if (found_fish % 100 == 0):
			lost_fish = true
			state = "fish"

	move_and_slide()
