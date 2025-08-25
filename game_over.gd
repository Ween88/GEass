extends Control

@onready var retry_button = $VBoxContainer/RetryButton
@onready var quit_button = $VBoxContainer/QuitButton

var main_game_scene_path = "res://HealthBar.tscn"

func _ready():
	retry_button.pressed.connect(on_retry_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_retry_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(main_game_scene_path)
	
func on_quit_pressed():
	get_tree().quit()
