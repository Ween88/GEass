extends Item1
class_name Chest
 
@export var size : int
 
func activate():
	print(title +" activated")
	ChestManager.open_chest(self)
 
func de_activate():
	print(title +" de-activated")
	ChestManager.de_activate()
