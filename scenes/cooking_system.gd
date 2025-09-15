extends Control
 
@onready var recipe_slot_node : PackedScene = preload("res://scenes/recipe_slot.tscn")
@onready var queue_slot_node : PackedScene = preload("res://scenes/queue_slot.tscn")
 
@export var recipes : Array[Recipe]:
	set(value):
		recipes = value
 
		if recipe_container:
			free_slots()
			load_recipes()
 
@export var recipe_container : VBoxContainer
@export var queue : VBoxContainer
 
var selected_recipe : Recipe
var selected_rect : Rect2
 
func _ready():
	free_slots()
	load_recipes()
 
func _draw():
	draw_rect(selected_rect, Color.WHITE, false, 1)
 
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_TAB:
			visible = !visible
 
func load_recipes():
	for recipe in recipes:
		var recipe_slot = recipe_slot_node.instantiate()
		recipe_container.add_child(recipe_slot)
		recipe_slot.recipe = recipe
		recipe_slot.selected.connect(selection)
 
func free_slots():
	for slot in recipe_container.get_children():
		slot.free()
 
func selection(item : Recipe, node : Panel):
	selected_recipe = item
	selected_rect = Rect2(node.global_position, node.size)
	queue_redraw()
	print(item.name)
 
func queue_item(item : Recipe):
	if item == null:
		return
 
	var queue_slot = queue_slot_node.instantiate()
	queue.add_child(queue_slot)
	queue_slot.recipe = item
	queue_slot.completed.connect(finished_cooking)
 
 
func _on_create_pressed():
	if not selected_recipe:
		return
 
	if not Inventory.check_ingredients(selected_recipe.ingredients):
		print("Not Enough Items")
		return
 
	Inventory.use_ingredients(selected_recipe.ingredients)
 
	queue_item(selected_recipe)
 
func finished_cooking(item: Recipe, node : Panel):
	if item == null:
		return
 
	Inventory.add_item(item.product, item.product_amount)
	node.queue_free()
	print(item.name +" added.")
