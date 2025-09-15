extends Resource
class_name Recipe
 
@export var name: String
@export var icon: Texture2D
@export var ingredients : Dictionary[Item1, int]
@export var product : Item1
@export var product_amount : int = 1
@export var cook_time: float = 5.0
