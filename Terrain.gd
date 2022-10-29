extends Node3D


var CHUNK_SCENE = preload("res://Chunk.tscn")
var player

func _ready():
	player = get_node("/root/World/Player")
	player.lower_terrain.connect(_on_Player_lower_terrain)
	player.raise_terrain.connect(_on_Player_raise_terrain)
	
	for x in range(-G.TERRAIN_SEMI_WIDTH,G.TERRAIN_SEMI_WIDTH):
		for z in range(-G.TERRAIN_SEMI_WIDTH,G.TERRAIN_SEMI_WIDTH):
			var chunk = CHUNK_SCENE.instantiate()
			chunk.init(x * G.CHUNK_WIDTH, z * G.CHUNK_WIDTH)
			add_child(chunk)

func _on_Player_lower_terrain(x,z):
	amend_terrain(x,z,-0.05)
	
func _on_Player_raise_terrain(x,z):
	amend_terrain(x,z,0.05)
	
func get_chunk(x, z):
	for c in get_children():
		if c.POSITION.x == x and c.POSITION.z == z:
			return c

func amend_terrain(x,z,d):
	G.grid_values[str(x,",",z)] += d
	var cx = int(floor(x / G.CHUNK_WIDTH)) * G.CHUNK_WIDTH
	var cz = int(floor(z / G.CHUNK_WIDTH)) * G.CHUNK_WIDTH
	var amend_chunk = get_chunk(cx,cz)
	amend_chunk.update_mesh()
	var rem_x = posmod(x+1,G.CHUNK_WIDTH)
	if rem_x==1:
		amend_chunk = get_chunk(cx-G.CHUNK_WIDTH, cz)
		amend_chunk.update_mesh()
	elif rem_x == G.CHUNK_WIDTH-1:
		amend_chunk = get_chunk(cx+G.CHUNK_WIDTH, cz)
		amend_chunk.update_mesh()
	var rem_z = posmod(z+1,G.CHUNK_WIDTH)
	if rem_z==1:
		amend_chunk = get_chunk(cx, cz-G.CHUNK_WIDTH)
		amend_chunk.update_mesh()
	elif rem_z == G.CHUNK_WIDTH-1:
		amend_chunk = get_chunk(cx, cz+G.CHUNK_WIDTH)
		amend_chunk.update_mesh()
