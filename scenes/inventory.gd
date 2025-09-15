extends Control
 
var current_scene
var inventory : Dictionary = {
	"grid" : {},
	"hotbar" : {}
}
 
@export var hotbar : HBoxContainer
@export var grid : GridContainer
 
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			grid.visible = !grid.visible
 
func add_item(item : Item1, amount : int = 1):
	for slot in hotbar.get_children():
		if slot.item == null:
			slot.item = item
			slot.set_amount(amount)
			return
		elif slot.item == item:
			slot.add_amount(5)
			return
 
	for slot in grid.get_children():
		if slot.item == null:
			slot.item = item
			slot.set_amount(amount)
			return
		elif slot.item == item:
			slot.add_amount(5)
			return
	
	print("Full Inventory")
 
func _on_hotbar_equip(item):
	if current_scene != null:
		current_scene.currently_equipped = item
 
func use_stackable_item():
	hotbar.update()
	hotbar.use_current()
