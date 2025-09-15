extends Control
 
var current_scene
 
@export var hotbar : HBoxContainer
@export var grid : GridContainer
 
var inventory : Dictionary = {}
 
func _ready():
	grid.hide()
 
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			grid.visible = !grid.visible
 
func _on_hotbar_equip(item):
	if current_scene != null:
		current_scene.currently_equipped = item
 
func use_stackable_item():
	hotbar.update()
	hotbar.use_current()
 
func add_item(item : Item1, amount : int = 1):
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
	if inventory.has(item):
		inventory[item] += amount
		return
 
	inventory[item] = amount
 
func check_ingredients(ingredients : Dictionary[Item1, int]):
	for key in ingredients:
		if inventory[key] < ingredients[key]:
			return false
	return true
 
func remove_item(item : Item1, amount : int = 1):
	for slot in hotbar.get_children():
		if slot.item == item:
			slot.amount -= amount
			return
 
	for slot in grid.get_children():
		if slot.item == item:
			slot.amount -= amount
			return
 
func use_ingredients(ingredients : Dictionary[Item1, int]):
	for key in ingredients:
		inventory[key] -= ingredients[key]
		remove_item(key, ingredients[key])
