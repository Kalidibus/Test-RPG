extends Node3D

const Cells = preload("res://Scenes/Dungeon/Cell.tscn")
const Pillar = preload("res://Scenes/Dungeon/Pillar.tscn")
@export var Map: PackedScene

var cells = []

var mapobj_default = "TileData#36037461163"
var mapobj_pillar = Vector2i(0, 3)

func _ready():
	generate_map()
	if Globals.mappos != null:
		$Player.position = Globals.mappos
		$Player.rotation = Globals.maprotation


func generate_map():
	Map = load("res://Scenes/Dungeon/Map.tscn")
	if not Map is PackedScene: return
	var map = Map.instantiate()
	var tileMap = map.get_tilemap()
	var used_tiles = tileMap.get_used_cells_by_id(0)
	#map.free() # We don't need it now that we have the tile data
	for tile in used_tiles:
		var cell
		
		if tileMap.get_cell_atlas_coords(0, tile) == mapobj_pillar:
			cell = Pillar.instantiate()
		else:
			cell = Cells.instantiate()
		
		add_child(cell)
		cell.position = Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
		cells.append(cell)
	for cell in cells:
		cell.update_faces(used_tiles)
