extends Panel
 
signal selected(recipe, node)
 
var recipe : Recipe:
	set(value):
		# Displays recipe details in slot UI
		recipe = value
		%Name.text = value.name
		%Product.texture = value.icon
		for i in range(value.ingredients.size()):
			var key = value.ingredients.keys()[i]
			%Ingredient.get_child(i).texture = key.icon
			%Ingredient.get_child(i).find_child("Amount").text = str(value.ingredients[key])
 
 
func _on_gui_input(event):
	# Detects left-click to select this recipe
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			selected.emit(recipe, self)
