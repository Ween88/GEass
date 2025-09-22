extends CharacterBody2D

func _physics_process(_delta):
	# Handles player movement using arrow/WASD keys
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 100
	move_and_slide()
