extends TileMap

enum {
	DIRT = 0,
	FLOWER = 1,
	TRUNK_BASE = 2,
	TRUNK = 3,
	LEAVES = 4,
}

onready var noise = $noise.texture.noise

func _ready():
	randomize()
	noise.seed = randi()%1000
	
	for x in 100:
		var ground = abs(noise.get_noise_2d(x,0) * 60)
		for y in range (ground, 100):
			if noise.get_noise_2d(x,y) > -0.25: 
				set_cell(x,y,DIRT)
				if randi()%2 ==1 and get_cell(x,y-1) == -1:
					set_cell(x,y-1,FLOWER)
				if randi()%5 ==4 and get_cell(x,y-1) == -1:
					create_tree(x,y-1,randi()%4 + 4,true)

func create_tree (x,y,length,new):
	if new:
		for i in length:
			if get_cell(x,y-i) != -1:
				break
				length = 0
	
	if length > 0:
		if new: set_cell(x,y,TRUNK_BASE)
		elif length == 1: set_cell(x,y,LEAVES)
		else: set_cell(x,y,TRUNK)
		create_tree(x,y-1,length-1, false)
