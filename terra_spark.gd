extends Node2D
 
@export var block : Dictionary[String, BlockData]
@onready var ground = $Ground
@export var player : CharacterBody2D
 
var broken_tiles_health : Dictionary
var current_block = "soil"
var distance : float = INF

var inventory = {
	"soil" : 0,
	"stone" : 0,
	"sand" : 0,
	"iron" : 0,
	"gold" : 0,
	"crystal" : 0,
	"diamond" : 0,
	"cactus" : 0,
	"sugarcane" : 0,
	"pumpkin" : 0,
	"trunk" : 0,
	"leave" : 0,
	"dungeonblock" : 0
}
	
func _physics_process(_delta):
	# Continuously measure distance from player to mouse position
	if player:
		distance = (get_global_mouse_position() - player.global_position).length()

func _input(event):
	# Handles block breaking and placing
	if event is InputEventMouseButton and event.pressed:
		var tile_pos = get_snapped_position(get_global_mouse_position())
		
		if event.button_index == MOUSE_BUTTON_LEFT and distance < 100:
			print(ground.get_cell_atlas_coords(tile_pos))
			var data = ground.get_cell_tile_data(tile_pos)
			var tile_name
			if data:
				tile_name = data.get_custom_data("tile_name")
				print(tile_name)
				print(block[tile_name].health)
				take_damage(tile_name, tile_pos)
		
		if is_placeable(event):
			ground.set_cell(tile_pos, block[current_block].source1, block[current_block].atlas_coords[0])

	if event is InputEventKey:
		switch_block(event)
	
func get_snapped_position(global_pos: Vector2) -> Vector2i:
	# Converts mouse global position to tilemap grid position
	var local_pos = ground.to_local(global_pos)
	var tile_pos = ground.local_to_map(local_pos)
	return tile_pos

func take_damage (tile_name : StringName, tile_pos : Vector2i, amount : float = 1):
	# Reduces block health and removes or updates tile
	if tile_pos not in broken_tiles_health:
		broken_tiles_health[tile_pos] = block[tile_name].health - amount
	else:
		broken_tiles_health[tile_pos] -= amount
		
	print(broken_tiles_health[tile_pos])
	
	var difference = block[tile_name].health - broken_tiles_health[tile_pos]
	var next_tile : Vector2i
	
	if difference >= block[tile_name].health:
		ground.erase_cell(tile_pos)
		broken_tiles_health.erase(tile_pos)
		if tile_name in inventory:
			inventory[tile_name] += 1
		else:
			inventory[tile_name] = 1
	elif difference< block[tile_name].atlas_coords.size():
		next_tile = block[tile_name].atlas_coords[difference]
		ground.set_cell(tile_pos, block[tile_name].source1, next_tile)
		
	print(broken_tiles_health)
	
func switch_block(event):
	# Switch between block types using keys 1–0 and Q
	if event.keycode == KEY_1 and event.pressed:
		current_block = "soil"
	if event.keycode == KEY_2 and event.pressed:
		current_block = "stone"
	if event.keycode == KEY_3 and event.pressed:
		current_block = "sand"
	if event.keycode == KEY_4 and event.pressed:
		current_block = "iron"
	if event.keycode == KEY_5 and event.pressed:
		current_block = "gold"
	if event.keycode == KEY_6 and event.pressed:
		current_block = "crystal"
	if event.keycode == KEY_7 and event.pressed:
		current_block = "diamond"
	if event.keycode == KEY_8 and event.pressed:
		current_block = "cactus"
	if event.keycode == KEY_9 and event.pressed:
		current_block = "trunk"
	if event.keycode == KEY_0 and event.pressed:
		current_block = "pumpkin"
	if event.keycode == KEY_Q and event.pressed:
		current_block = "sugarcane"

func is_placeable(event) -> bool:
	# Only allow placing if conditions are met
	return event.button_index == MOUSE_BUTTON_RIGHT and distance < 150 and distance > 100 and inventory[current_block] > 0
	
var pause_menu_scene := preload("res://pause_menu.tscn")
var pause_menu: Control = null

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		toggle_pause()
		
func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		if pause_menu and is_instance_valid(pause_menu):
			pause_menu.queue_free()
			pause_menu = null
	else:
		get_tree().paused = true
		pause_menu = pause_menu_scene.instantiate()
		get_tree().current_scene.add_child(pause_menu)
		
