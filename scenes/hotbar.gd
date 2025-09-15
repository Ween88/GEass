extends HBoxContainer
 
var currently_equipped : Item1:
	set(value):
		currently_equipped = value
		equip.emit(value)
 
signal equip(item : Item1)
 
var index = 0:
	set(value):
		index = value
 
		if index >= get_child_count():
			index = 0
		elif index < 0:
			index = get_child_count() - 1
		queue_redraw()
		currently_equipped = get_child(index).item
 
func _draw():
	draw_rect(Rect2( get_child(index).position, get_child(index).size), Color.WHITE, false, 1)
 
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			index -= 1
			print(index)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			index += 1
			print(index)
 
func update():
	currently_equipped = get_child(index).item
	#index = index
 
func use_current():
	get_child(index).amount -= 1
