extends Area2D

@export var damage = 15

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("players"):
		if body.has_method("take_damage"):
			#Call the take_damage method on body that was hit
			body.take_damage(damage)
		
			#Prevent hitting the same enemy multiple times with single attack
			monitoring = false
