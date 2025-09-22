extends Panel

@export var item : Item1 = null:
	set(value):
		# Assigns item to slot and updates icon/amount
		item = value
		
		if get_parent().has_method("update"):
			get_parent().update()
		
		if value == null:
			$Icon.texture = null
			$Amount.text = ""
			return
		
		$Icon.texture = value.icon

@export var amount : int = 0:
	set(value):
		# Sets item quantity and clears item if <= 0
		amount = value
		$Amount.text = str(value)
		if amount <= 0:
			item = null

func set_amount(value : int):
	# Manually sets item quantity
	amount = value

func add_amount(value : int):
	# Adds more items to slot
	amount += value

func _can_drop_data(_at_psition, data):
	# Checks if drag-and-drop data is valid (must be Item1)
	if "item" in data:
		return is_instance_of(data.item, Item1)
	return false

func _drop_data(_at_position, data):
	# Handles drag-and-drop item swapping/stacking
	if item == data.item:
		amount += data.amount
		data.amount = 0
	else:
		var temp = item
		item = data.item
		data.item = temp
		
		temp = amount
		amount = data.amount
		data.amount = temp
	
	if get_parent().has_method("update"):
		get_parent().update()
	if data.get_parent().has_method("update"):
		data.get_parent().update()
	
	if get_parent().name == "ChestInventory":
		ChestManager.set_item()
	if data.get_parent().name == "ChestInventory":
		ChestManager.set_item()

func _get_drag_data(_at_position):
	# Creates preview when dragging an item
	if item:
		var preview_texture = TextureRect.new()
		
		preview_texture.texture = item.icon
		preview_texture.size = Vector2(16,16)
		preview_texture.position = -Vector2(8,8)
		
		var preview = Control.new()
		preview.add_child(preview_texture)
		set_drag_preview(preview)
	
	return self

func _on_gui_input(event):
	# Right-click on slot when shop is ON to sell item
	if event is InputEventMouseButton and Shop.mode == Shop.MODE.ON:
		if event.is_pressed()and event.button_index == MOUSE_BUTTON_RIGHT:
			Shop.sell_item(item)
			if item:
				amount -= 1
