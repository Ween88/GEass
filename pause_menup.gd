extends Control

@onready var resume_button = $VBoxContainer/ResumeButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	# Make sure to connect the signals for your buttons in the Godot editor
	resume_button.pressed.connect(on_resume_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_resume_pressed():
	# Get a reference to the main scene's script (your HealthBar.gd script)
	var main_scene = get_tree().get_root().get_child(0)
	main_scene.unpause_game()
	
func on_quit_pressed():
	get_tree().quit()
