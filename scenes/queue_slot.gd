extends Panel
 
signal completed(item, node)
 
var recipe : Recipe:
	set(value):
		# Assigns recipe to this queue slot and updates UI
		recipe = value
 
		if value == null:
			return
		$TextureRect.texture = value.icon
		cook_time = value.cook_time
 
var cook_time : float:
	set(value):
		# Sets total cook time and updates progress bar
		cook_time = value
		$ProgressBar.max_value = value
 
var time : float = 0:
	set(value):
		# Tracks elapsed time for cooking
		time = value
		$ProgressBar.value = value
 
 
func _physics_process(delta):
	# Updates cooking progress each frame
	if time >= 0 and get_index() == 0:
		time += delta
	if time > cook_time:
		completed.emit(recipe, self)
 
 
func _on_cancel_pressed():
	# Cancels recipe and refunds ingredients
	for key in recipe.ingredients:
		Inventory.add_item(key, recipe.ingredients[key])
	queue_free()
