extends CharacterBody2D

@export var speed: float = 60.0
@export var chase_speed: float = 120.0
@export var gravity: float = 800.0
@export var detection_range: float = 200.0
@export var step_hop: float = 150.0
@export var knockback_force: float = 300.0
@export var knockback_upward: float = 200.0
@export var knockback_time: float = 0.25

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_ground_front: RayCast2D = $RayCast_GroundFront
@onready var ray_wall_front: RayCast2D = $RayCast_WallFront
@onready var ray_step_front: RayCast2D = $RayCast_StepFront
@onready var attack_area = $EnemyAttackArea

var direction: int = -1  # -1 = left, 1 = right
var is_chasing: bool = false
var player: Node2D
var health = 100
var damage = 15
var knockback_timer: float = 0.0

# Attack variables
var can_attack = true
var attack_cooldown = 1.0

# Store original offsets to avoid cumulative errors
var _ray_ground_front_abs_x: float
var _ray_wall_front_abs_x: float
var _ray_step_front_abs_x: float
var _ray_wall_target_abs_x: float
var _ray_step_target_abs_x: float

func _ready():
	player = get_parent().get_node_or_null("Player")

	# Store initial absolute values for correct flipping
	_ray_ground_front_abs_x = abs(ray_ground_front.position.x)
	_ray_wall_front_abs_x = abs(ray_wall_front.position.x)
	_ray_step_front_abs_x = abs(ray_step_front.position.x)

	_ray_wall_target_abs_x = abs(ray_wall_front.target_position.x)
	_ray_step_target_abs_x = abs(ray_step_front.target_position.x)

	_apply_direction()

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if knockback_timer > 0.0:
		knockback_timer -= delta
		move_and_slide()
		return # Skip chase/patrol logic while in knockback

	# --- Player Detection & Chase ---
	if player and global_position.distance_to(player.global_position) < detection_range:
		is_chasing = true
		_set_direction(1 if player.global_position.x > global_position.x else -1)
	else:
		is_chasing = false

	# --- Patrol Behavior ---
	if not is_chasing:
		if not ray_ground_front.is_colliding() or ray_wall_front.is_colliding():
			_set_direction(-direction)

	# --- Step-up Detection ---
	if ray_step_front.is_colliding() and is_on_floor():
		velocity.y = -step_hop

	# --- Movement ---
	velocity.x = (chase_speed if is_chasing else speed) * direction
	move_and_slide()

	# --- Animation ---
	anim_sprite.play("walk")

# --- Direction Management ---
func _set_direction(new_dir: int):
	if new_dir != direction:
		direction = new_dir
		_apply_direction()

func _apply_direction():
	anim_sprite.flip_h = (direction > 0)

	# Flip RayCast positions
	ray_ground_front.position.x = direction * _ray_ground_front_abs_x
	ray_wall_front.position.x = direction * _ray_wall_front_abs_x
	ray_step_front.position.x = direction * _ray_step_front_abs_x

	# Flip RayCast target points
	ray_wall_front.target_position.x = direction * _ray_wall_target_abs_x
	ray_step_front.target_position.x = direction * _ray_step_target_abs_x

func take_damage(amount, from_pos: Vector2):
	health -= amount
	
	apply_knockback(from_pos) #Apply knockback
	
	print("Enemy took ", amount, " damage! Health remaining: ", health)
	
	#Check if health has dropped to or below zero
	if health <= 0:
		die()

func die():
	print("The enemy die.")
	
	#Removes the enemy node from the scene tree
	queue_free()
	
func attack():
	can_attack = false
	print("Enemy is attacking!")
	# Start the attack cooldown
	get_tree().create_timer(attack_cooldown).timeout.connect(reset_attack_cooldown)
	
func reset_attack_cooldown():
	can_attack = true
	
	
func apply_knockback(from_pos: Vector2):
	var dir = -1 if from_pos.x > global_position.x else 1
	velocity.x = dir * knockback_force
	velocity.y = -knockback_upward
	knockback_timer = knockback_time
