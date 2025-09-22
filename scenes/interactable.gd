extends Area2D

@export var item : Item1:
	set(value):
		# Sets the interactable item and updates sprite texture
		item = value
		item.node = self
		$Sprite2D.texture = value.icon

var enabled : bool = false:
	set(value):
		# Enables/disables interaction label visibility
		enabled = value
		$Label.visible = value

func _ready():
	# Runs when the node enters the scene
	enabled = false
	name = item.title

func _input(event):
	# Handles pressing E to interact when enabled
	if event is InputEventKey and event.is_pressed() and enabled:
		if event.keycode == KEY_E:
			item.node = self
			if item:
				item.activate()

func _on_body_entered(body):
	# Player enters area, enable interaction
	enabled = true

func _on_body_exited(body):
	# Player leaves area, disable interaction
	enabled = false
	if item:
		item.de_activate()
