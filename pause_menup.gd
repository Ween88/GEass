extends Control

@onready var resume_button = $VBoxContainer/ResumeButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	resume_button.pressed.connect(on_resume_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_resume_pressed():
	get_tree().paused = false
	# This frees the menu node and removes it from the scene tree.
	queue_free()
	
func on_quit_pressed():
	get_tree().quit()
