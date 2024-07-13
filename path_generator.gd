class_name PathGenerator
extends Node

var path_raw: Array[Vector2i]
var path_block_type: Array[int]
var path_temp_container: Vector2i

var loop_counter: int = 0

enum TYPE {HORI, VERT, UP, DOWN, RIGHT}

func _ready() -> void:
	pass


func generate_path_raw_coord(_grid_size: Vector2i) -> Array[Vector2i]:
	
	path_raw.clear()
	
	var grid_length: int = _grid_size.x
	var grid_height: int = _grid_size.y
	var x: int = 0
	var y: int = int(grid_height / 2)
	
	path_temp_container = Vector2i(x, y)
	path_raw.append(path_temp_container)
	
	while x < grid_length - 1:
		
		var randomizer: int = randi_range(0, 2) # 0, 1, 2
		loop_counter += 1
		# 0 straight
		# 1 down
		# 2 up
		if randomizer == 0 or x == 0 or x == (grid_length - 2):
			x = x + 1
		elif randomizer == 1 and y < grid_height - 2:
			if not Vector2i(x, y+1) in path_raw:
				if not Vector2i(x-1, y+1) in path_raw:
					y = y + 1
		elif randomizer == 2 and y > 2:
			if not Vector2i(x, y-1) in path_raw:
				if not Vector2i(x-1, y-1) in path_raw:
					y = y - 1

		path_temp_container = Vector2i(x, y)

		if path_temp_container in path_raw:
			pass
		else:
			path_raw.append(path_temp_container)

	return path_raw


func generate_path_block_type(_path_raw: Array[Vector2i]) -> Array:
	
	path_block_type.clear()
	var array_size: int = len(_path_raw)
	
	for i in len(_path_raw):
		if i != 0 or i != (array_size-1):
			print(_path_raw[i-1], _path_raw[i])
		# First and last block
		if i == 0 or i == (array_size - 1):
			path_block_type.append(TYPE.HORI)
		# Straight horizantal
		elif _path_raw[i].y == _path_raw[i-1].y:
			if _path_raw[i].y == _path_raw[i+1].y:
				path_block_type.append(TYPE.HORI)
		# Straight vertical
		elif _path_raw[i].x == _path_raw[i-1].x:
			if _path_raw[i].x == _path_raw[i+1].x:
				path_block_type.append(TYPE.VERT)
		elif _path_raw[i].x > _path_raw[i-1].x:
			if _path_raw[i].x == _path_raw[i+1].x:
				path_block_type.append(TYPE.UP)
	
	return path_block_type
