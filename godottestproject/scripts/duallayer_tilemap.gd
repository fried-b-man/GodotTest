extends TileMapLayer

@onready var visual_layer: TileMapLayer = $VisualLayer

static var EMPTY_CELL: Vector2i = Vector2i(2,1)
static var NEIGHBORS_DICT: Dictionary = {[0,0,0,0]:[2,1], # Empty
	[0,0,0,1]:[3,1], #lower right
	[0,0,1,0]:[2,2], #upper right
	[0,0,1,1]:[3,2], #right edge
	[0,1,0,0]:[2,2], #lower left
	[0,1,0,1]:[1,2], #lower edge
	[0,1,1,0]:[0,1], #right diag
	[0,1,1,1]:[3,3], #wrap upper left
	[1,0,0,0]:[1,1], #upper left
	[1,0,0,1]:[2,3], #left diag
	[1,0,1,0]:[3,0], #upper edge
	[1,0,1,1]:[0,0], #wrap lower left
	[1,1,0,0]:[1,0], #left edge
	[1,1,0,1]:[0,0], #wrap upper right
	[1,1,1,0]:[1,3], #wrap lower right
	[1,1,1,1]:[0,3]  #full
}

func _ready():
	visual_layer.clear()
	var all_coords:Array = self.get_used_cells() 
	for coord:Vector2i in all_coords:
		place_visual_tile(coord)
		self.set_cell(coord, 0, EMPTY_CELL)

##Takes in collision tile and updates the 4 related visual tiles 
func place_visual_tile(tilePos: Vector2i) -> void:
	for x:int in range(2):
		for y:int in range(2):
			var neighbors:Array = tileNeighbors(tilePos+Vector2i(x,y))
			if neighbors != [0,0,0,0]:
				var tilePlacement:Array = NEIGHBORS_DICT.get(neighbors)
				visual_layer.set_cell(tilePos+Vector2i(x,y), 1, Vector2i(tilePlacement[0],tilePlacement[1]))

##Takes a collision tile coord and returns the 4 affected visual tiles in an array
func tileNeighbors(coord: Vector2i) -> Array:
	var neighbors:Array = [0,0,0,0]
	for i:int in range(4):
		for x:int in range(2):
			for y:int in range(2):
				var neighbor:Vector2i = self.get_cell_atlas_coords(coord-Vector2i(1,1)+Vector2i(x,y))
				if neighbor.y != -1:
					neighbors[i]=1
				else:
					neighbors[i]=0
	return neighbors
	
