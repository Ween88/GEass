extends CharacterBody2D

const SPEED = 200
const JUMP_FORCE = -400
const GRAVITY = 1000

@onready var anim_sprite = $Visual/Movement
@onready var anim_player = $Visual/AnimationPlayer
@onready var visuals = $Visual
@onready var attack_area = $AttackArea
@onready var sfx_jump = $sfx_jump
@onready var sfx_attack = $sfx_attack
@export var knockback_force: float = 300.0
@export var knockback_upward: float = 200.0
@export var knockback_time: float = 0.25

# Health variables
var health = 100
var max_health = 100
@onready var health_bar = $Health/HealthBar
@onready var farm_button = $Teleport/Farm

var farm_scene_path = "res://scenes/test_scene.tscn"

#Default values
var can_attack = true
var attack_cooldown = 0.5
var knockback_timer: float = 0.0
var knockback_dir: int = 0

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if knockback_timer > 0.0:
		knockback_timer -= delta
		move_and_slide()
		return  # skip normal controls while being knocked back

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
		sfx_jump.play()
	elif direction.x != 0:
		anim_sprite.play("walk")
	else:
		anim_sprite.play("idle")

func _input(event):

	#event to perform attack 
	if event.is_action_pressed("attack"):
		attack()
		
func attack():
	can_attack = false
	anim_player.play("attack")
	get_tree().create_timer(attack_cooldown).timeout.connect(reset_attack)
	sfx_attack.play()
	

func reset_attack():
	anim_player.play("RESET")
	can_attack = true

#This function will called by the enemy when it hit the player
func take_damage(amount, from_pos: Vector2):
	
	health -= amount
	health_bar.value = health # Update the health bar
	
	apply_knockback(from_pos) #Apply knockback
	
	print("Player took ", amount, " damage! Health remaining: ", health)

	if health <= 0:
		die()
		
func die():
	var game_over = get_tree().current_scene.get_node("UI/GameOver")
	game_over.visible = true
	get_tree().paused = true
	print("Player has died.")
	#queue_free()
	
func _ready():
	farm_button.pressed.connect(_on_farm_button_pressed)

func _on_farm_button_pressed():
	get_tree().change_scene_to_file(farm_scene_path)
	
func apply_knockback(from_pos: Vector2):
	# Knockback direction is based on attacker's position
	if from_pos.x > global_position.x:
		knockback_dir = -1 # enemy is to the right → push player left
	else:
		knockback_dir = 1    # enemy is to the left → push player right
	knockback_timer = 0.2  # duration of knockback
	velocity.x = knockback_dir * knockback_force
	velocity.y = -knockback_upward
