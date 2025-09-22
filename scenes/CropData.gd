extends BlockData1
class_name CropData
 
@export var duration : float
 
func growth_index(time : float):
	# Returns which growth stage index the crop is at
	var stage_index : int = int( (time/duration) * (atlas_coords.size() - 1) )
	return stage_index
