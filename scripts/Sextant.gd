extends Node2D

@export var tile_id: int = 0  # Ensure this ID matches a valid tile in your TileSet

func _ready():
	var tilemaplayer = $TileMapLayer  # Replace with your TileMapLayer node name
	print("here")
	if tilemaplayer == null:
		print("TileMapLayer node not found!")
		return
	
#Red, Blue, Teal, Purple, Yellow, Orange, Green, Pink, Grey, Light Blue, Dark Green, Brown
	# Place a single tile at (0, 0)
	print("here2")
	print(tile_id)
	tilemaplayer.set_cell(Vector2i(0, 0),1,Vector2i(0, 0))
	tilemaplayer.set_cell(Vector2i(1, 0),1,Vector2i(0, 1))
	tilemaplayer.set_cell(Vector2i(2, 0),1,Vector2i(0, 2))
	#tilemaplayer.set_cell(Vector2i(3, 0),0,Vector2i(0, 0))
