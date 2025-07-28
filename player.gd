extends CharacterBody2D

const SPEED = 200
const JUMP_FORCE = -400
const GRAVITY = 1000

@onready var anim_sprite = $Visual/Movement
@onready var anim_player = $Visual/AnimationPlayer
@onready var visuals = $Visual

var swinging = false

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	# Handle swing
	if Input.is_action_just_pressed("swing") and is_on_floor() and not swinging:
		swinging = true
		anim_player.play("swing")  # Play swing animation from AnimationPlayer
		return  # Skip other movement this frame

	# Reset swinging flag after animation is done
	if swinging and not anim_player.is_playing():
		swinging = false

	# Move input
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	# Apply gravity
	velocity.y += GRAVITY * delta

	# Jump
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_FORCE

	# Horizontal movement
	velocity.x = direction.x * SPEED
	move_and_slide()

	# Flip sprite and tool
	if direction.x != 0:
		var facing_right = direction.x > 0
		visuals.scale.x = -1 if facing_right else 1 #the character sprite face left by default

	# Animation control
	if not is_on_floor():
		anim_sprite.play("jump")
	elif direction.x != 0:
		anim_sprite.play("walk")
	else:
		anim_sprite.play("idle")
