extends Node3D
@tool
	
var CHUNK_SCENE = preload("res://Chunk.tscn")
const TERRAIN_SEMI_WIDTH = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-TERRAIN_SEMI_WIDTH,TERRAIN_SEMI_WIDTH):
		for z in range(-TERRAIN_SEMI_WIDTH,TERRAIN_SEMI_WIDTH):
			var chunk = CHUNK_SCENE.instantiate()
			chunk.POSITION = Vector3(
				x * G.CHUNK_WIDTH,
				-G.CHUNK_HEIGHT/2.0,
				z * G.CHUNK_WIDTH)
			add_child(chunk)
