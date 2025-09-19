extends Area2D

@export var item : Item1:
	set(value):
		item = value
		item.node = self
		$Sprite2D.texture = value.icon

var enabled : bool = false:
	set(value):
		enabled = value
		$Label.visible = value

func _ready():
	enabled = false
	name = item.title

func _input(event):
	if event is InputEventKey and event.is_pressed() and enabled:
		if event.keycode == KEY_E:
			item.node = self
			if item:
				item.activate()

func _on_body_entered(body):
	enabled = true

func _on_body_exited(body):
	enabled = false
	if item:
		item.de_activate()
