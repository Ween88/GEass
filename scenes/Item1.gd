extends Resource
class_name Item1
 
@export var title : String
@export var icon : Texture2D
@export var price : int = 1

var node = null

func activate():
	# Base activate method (to be overridden by child classes)
	pass

func de_activate():
	# Base deactivate method (to be overridden by child classes)
	pass
