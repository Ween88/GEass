extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var quit_button = $VBoxContainer/QuitButton

var game_scene_path = "res://HealthBar.tscn"

func _ready():
	start_button.pressed.connect(on_start_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_start_pressed():
	get_tree().change_scene_to_file(game_scene_path)
	
func on_quit_pressed():
	get_tree().quit()
