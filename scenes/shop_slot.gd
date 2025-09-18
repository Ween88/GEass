extends Panel
 
@export var item : Item1:
	set(value):
		item = value
		$Icon.texture = value.icon
		$Price.text = "$ " + str(value.price)
 
 
func _on_gui_input(event):
	if event is InputEventMouseButton and Shop.mode == Shop.MODE.ON:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			if Shop.buy_item(item):
				Inventory.add_item(item, 1)
