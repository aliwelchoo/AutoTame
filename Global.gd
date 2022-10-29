extends Node

const CHUNK_HEIGHT = 64
const CHUNK_WIDTH = 16
const SMOOTH = true
var grid_values = {}

func key_vec(vector):
	return str(vector.x,",",vector.y,",",vector.z)
