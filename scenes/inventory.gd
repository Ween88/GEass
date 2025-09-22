extends Control
 
var current_scene
 
@export var hotbar : HBoxContainer
@export var grid : GridContainer
 
var inventory : Dictionary = {}
 
func _ready():
	# Hide inventory grid on start
	grid.hide()
 
func _input(event):
	# Toggle inventory grid with ESC key
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			grid.visible = !grid.visible
 
func _on_hotbar_equip(item):
	# Update current scene’s equipped item
	if current_scene != null:
		current_scene.currently_equipped = item
 
func use_stackable_item():
	# Use item in hotbar (decrease amount)
	hotbar.update()
	hotbar.use_current()
 
func add_item(item : Item1, amount : int = 1):
	# Add an item to hotbar first, then grid
	for slot in hotbar.get_children():
		if slot.item == null:
			slot.item = item
			slot.set_amount(amount)
			inventory_map(item, amount)
			return
		elif slot.item == item:
			slot.add_amount(amount)
			inventory_map(item, amount)
			return
 
	for slot in grid.get_children():
		if slot.item == null:
			slot.item = item
			slot.set_amount(amount)
			inventory_map(item, amount)
			return
		elif slot.item == item:
			slot.add_amount(amount)
			inventory_map(item, amount)
			return
 
	print("Full Inventory")
 
func inventory_map(item : Item1, amount : int):
	# Track items inside dictionary
	if inventory.has(item):
		inventory[item] += amount
		return
 
	inventory[item] = amount
 
func check_ingredients(ingredients : Dictionary[Item1, int]):
	# Verify if enough ingredients exist
	for key in ingredients:
		if inventory[key] < ingredients[key]:
			return false
	return true
 
func remove_item(item : Item1, amount : int = 1):
	# Remove items from hotbar or grid
	for slot in hotbar.get_children():
		if slot.item == item:
			slot.amount -= amount
			return
 
	for slot in grid.get_children():
		if slot.item == item:
			slot.amount -= amount
			return
 
func use_ingredients(ingredients : Dictionary[Item1, int]):
	# Deduct required ingredients from inventory
	for key in ingredients:
		inventory[key] -= ingredients[key]
		remove_item(key, ingredients[key])
