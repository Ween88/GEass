extends CharacterBody2D

const SPEED = 200
const JUMP_FORCE = -400
const GRAVITY = 1000

@onready var anim_sprite = $Visual/Movement
@onready var anim_player = $Visual/AnimationPlayer
@onready var visuals = $Visual
@onready var attack_area = $AttackArea
@onready var sfx_jump = $sfx_jump
# Health variables
var health = 100
var max_health = 100
@onready var health_bar = $HealthBar

#Default values
var equipped_weapon = null
var swinging = false
var can_attack = true
var attack_cooldown = 0.5

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
		sfx_jump.play()
	elif direction.x != 0:
		anim_sprite.play("walk")
	else:
		anim_sprite.play("idle")

func equip_weapon(weapon_scene_path):
	# If a weapon is already equipped, remove it first
	if equipped_weapon:
		equipped_weapon.queue_free()

	# Load and instance the new weapon scene
	var weapon_scene = load(weapon_scene_path)
	var new_weapon = weapon_scene.instantiate()

	# Add the new weapon as a child of the WeaponHolder node
	$Visual/WeaponHolder.add_child(new_weapon)
	equipped_weapon = new_weapon

func _input(event):
	#event to equip the weapon on player
	if event.is_action_pressed("equip_sword"):
		equip_weapon("res://Sword.tscn")

	#event to perform attack 
	if event.is_action_pressed("attack"):
		attack()
		
func attack():
	can_attack = false
	anim_player.play("attack")
	get_tree().create_timer(attack_cooldown).timeout.connect(reset_attack)
	
func reset_attack():
	anim_player.play("RESET")
	can_attack = true

# These functions are called by the AnimationPlayer's Method Call Track
func activate_hitbox():
	attack_area.set_deferred("monitoring", true)
	print("Hitbox Activated!")

func deactivate_hitbox():
	attack_area.set_deferred("monitoring", false)
	print("Hitbox Deactivated!")

#This function will called by the enemy when it hit the player
func take_damage(amount):
	
	health -= amount
	health_bar.value = health # Update the health bar
	print("Player took ", amount, " damage! Health remaining: ", health)

	if health <= 0:
		die()
		
func die():
	print("Player has died.")
	queue_free()
