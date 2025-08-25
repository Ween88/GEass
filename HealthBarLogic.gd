extends Node2D

@onready var health_bar = $CanvasLayer/HealthBar
@onready var heal_button = $CanvasLayer/TabBarBackground/heal
@onready var hurt_button = $CanvasLayer/TabBarBackground2/hurt

var game_over_scene = "res://game_over.tscn"
var hp = 10

func _ready():
	health_bar.max_value = 10
	health_bar.value = hp

	heal_button.pressed.connect(heal_pressed)
	hurt_button.pressed.connect(hurt_pressed)

func heal_pressed():
	hp += 1
	if hp > health_bar.max_value:
		hp = health_bar.max_value
	health_bar.value = hp
	print("Healed! HP:", hp)

func hurt_pressed():
	hp -= 1
	if hp < 0:
		hp = 0
	health_bar.value = hp
	print("Hurt! HP:", hp)
	if hp == 0:
		print("You are defeated!")
		get_tree().change_scene_to_file(game_over_scene)
