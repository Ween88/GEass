extends Item1
class_name Chest
 
@export var size : int
 
func activate():
	# Called when chest is activated by the player
	print(title +" activated")
	ChestManager.open_chest(self)
 
func de_activate():
	# Called when chest is deactivated (player moves away)
	print(title +" de-activated")
	ChestManager.de_activate()
