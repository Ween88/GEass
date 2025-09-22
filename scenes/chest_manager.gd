extends Control
 
@export var inventory : GridContainer
@onready var slot_node : PackedScene = preload("res://scenes/slot.tscn")

var storage : Dictionary
var current_chest = null

func open_chest(chest : Chest):
	# Opens the chest UI and loads its stored inventory
	current_chest = chest.node
	if current_chest == null:
		return
	if current_chest.name not in storage:
		storage[current_chest.name] = {"position" : current_chest.position,
										"inventory" : get_item()}
	
	clear_inventory()
	add_empty_slots(chest)
	set_slot_item()

func clear_inventory():
	# Clears all slots in the inventory UI
	for slot in inventory.get_children():
		slot.free()

func add_empty_slots(chest : Chest):
	# Creates empty slot nodes based on chest size
	inventory.columns = int(sqrt(chest.size))
	for i in range(chest.size):
		var slot = slot_node.instantiate()
		inventory.add_child(slot)

func de_activate():
	# Closes the chest and clears its slots
	clear_inventory()
	current_chest = null

func get_item():
	# Retrieves current items from chest slots
	var items = {}
	for slot in inventory.get_children():
		if "item" in slot:
			if slot.item != null:
				items[slot.get_index()] = { "item" : slot.item,
											"amount" : slot.amount}
	print(items)
	return items

func set_item():
	# Saves items back to the storage dictionary
	if current_chest == null:
		return
 
	storage[current_chest.name] = {"position" : current_chest.position,
									"inventory" : get_item()}
	print(storage)

func set_slot_item():
	# Loads stored items into the chest UI slots
	var items = storage[current_chest.name]["inventory"]
	for index in items:
		inventory.get_child(index).item = items[index]["item"]
		inventory.get_child(index).amount = items[index]["amount"]
