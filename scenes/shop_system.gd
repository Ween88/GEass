extends Control

@export var shop_slot_node : PackedScene = preload("res://scenes/shop_slot.tscn")
@export var shop_items : Array[Item1]
@export var shop_container : VBoxContainer

var gold : int = 0:
	set(value):
		# Updates gold count and displays it in UI
		gold = value
 
		$UI/Currency.text = "Gold : " + str(value)

enum MODE {
	ON,
	OFF
}

var mode : MODE = MODE.OFF:
	set(value):
		# Switches shop mode between ON and OFF
		mode = value
 
		if value == MODE.OFF:
			$UI.hide()
			Inventory.grid.hide()
		elif value == MODE.ON:
			$UI.show()
			Inventory.grid.show()

func _ready():
	# Runs when scene loads; hide shop UI and load items
	$UI.hide()
	load_shop_inventory()

func _input(event):
	# Toggle shop mode with "U" key
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_U:
			if mode == MODE.ON:
				mode = MODE.OFF
			elif mode == MODE.OFF:
				mode = MODE.ON

func sell_item(item : Item1):
	# Adds gold when selling an item
	if item == null:
		return
	gold += item.price

func buy_item(item : Item1):
	# Tries to purchase an item (returns true if successful)
	if item == null:
		return false
 
	if item.price > gold:
		return false
 
	gold -= item.price
	return true

func free_previous_slots():
	# Clears all shop slots
	for slot in shop_container.get_children():
		slot.free()

func load_shop_inventory():
	# Loads available items into shop UI
	for item in shop_items:
		var shop_slot = shop_slot_node.instantiate()
		shop_container.add_child(shop_slot)
		shop_slot.item = item

func set_shop_inventory(list : Array[Item1]):
	# Replaces current shop inventory with new list
	free_previous_slots()
	shop_items = list
	load_shop_inventory()
