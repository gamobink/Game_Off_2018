extends Node2D
const cell_size = 64
const world_size = 128
var world = []
var halfs = true
var tilemap = null

func _ready():
	tilemap = $level/level
	for x in range(world_size):
		world.append([])
		for y in range(world_size):
			world[x].append(null)

func map_to_world(cell):
	var h = 0
	if halfs:
		h = cell_size / 2
	var pos = Vector2(cell.x * cell_size + h, cell.y * cell_size + h)
	return pos

func world_to_map(pos):
	pos = pos + Vector2(cell_size/4, cell_size/4)
	var cell = Vector2(int(pos.x / cell_size), int(pos.y / cell_size))
	return cell

func current_cell(pos):
	var cell_pos = world_to_map(pos)
	var cell = tilemap.get_cell(cell_pos.x, cell_pos.y)
	$ui/last_dir.text = str(cell) + " " + str(cell_pos) 
	return cell

func is_cell_vacant(player):
	var direction = player.direction
	var grid_pos = world_to_map(player.position) + direction
	for x in range(2):
		for y in range(2):
			if (grid_pos.x + x - 1) < 0 or (grid_pos.x + x - 1) >= world.size():
				return false
			if (grid_pos.y + y - 1) < 0 or (grid_pos.y + y - 1) >= world[0].size():
				return false
			var cell = world[grid_pos.x + x - 1][grid_pos.y + y - 1]
			if cell != null:
				if cell.get_ref() != player:
					return false
	return true

func remove_player(player):
	var grid_pos = world_to_map(player.position)
	for x in range(world_size):
		for y in range(world_size):
			if world[x][y]:
				if world[x][y].get_ref() == player:
					world[x][y] = null

func update_player_pos(player):
	remove_player(player)
	var grid_pos = world_to_map(player.position)
	var new_grid_pos = grid_pos + player.direction
	for x in range(2):
		for y in range(2):
			world[new_grid_pos.x + x - 1][new_grid_pos.y + y - 1] = weakref(player)
	var target_pos = map_to_world(new_grid_pos) 
	return target_pos
	return true