extends Area2D

@export var damage = 20

func _on_body_entered(body):
	# This checks if the collided body has a "take_damage" method
	# and calls it.
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()

# A function to enable/disable the hitbox
func set_hitbox_active(active):
	$CollisionShape2D.disabled = not active
