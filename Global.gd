extends Node

const CHUNK_HEIGHT = 32
const CHUNK_WIDTH = 8
const SMOOTH = true
const TERRAIN_SEMI_WIDTH = 2
const WORLD_WIDTH = TERRAIN_SEMI_WIDTH * 2 * CHUNK_WIDTH
var grid_values = {}

func key_vec(vector):
	return str(vector.x,",",vector.z)

func lrp(val0, val1, d):
	return val0 + (val1 - val0) * d
