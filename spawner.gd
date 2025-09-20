extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_limit: int = 4
@export var spawn_cooldown: float = 3.0

var active_enemies: Array = []
var spawn_points: Array = []

func _ready():
	print("Spawner ready!")
	print("Enemy scene assigned? ", enemy_scene)

	# Collect all Marker2D spawn points
	spawn_points = get_children().filter(func(c): return c is Marker2D)
	print("Spawn points found: ", spawn_points.size())

	if spawn_points.is_empty():
		push_warning("⚠ No Marker2D spawn points found under EnemySpawner!")
	else:
		spawn_enemy()

func spawn_enemy():
	if not enemy_scene:
		push_warning("⚠ No enemy_scene assigned to EnemySpawner!")
		return

	# Clean up invalid enemies
	active_enemies = active_enemies.filter(func(e): return is_instance_valid(e))

	if active_enemies.size() < spawn_limit and spawn_points.size() > 0:
		var spawn_point: Marker2D = spawn_points[randi() % spawn_points.size()]
		var enemy = enemy_scene.instantiate()
		enemy.global_position = spawn_point.global_position
		enemy.add_to_group("enemies")

		var root = get_tree().current_scene
		root.add_child(enemy)
		enemy.global_position = spawn_point.global_position
		print("Adding enemy to:", get_parent())

		active_enemies.append(enemy)
		print("✅ Spawned enemy at ", spawn_point.global_position)

	# Respawn timer
	var timer := get_tree().create_timer(spawn_cooldown)
	timer.timeout.connect(spawn_enemy)
