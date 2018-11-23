extends Node
var current_scene = null
var current_scene_path = ""

var level = -1
var players_lifes = [4,4,4,4]
var levels = ["level0", "level1","level2","level3","level4","level5","level6"]
const MAX_STAGE = 200
var stage = 1
var screen_size = Vector2(1280, 720)
const SAVE_PATH = "user://g2018_savegame.save"
var levels_states = {}
var erast = true

func _ready():
	var root = get_tree().get_root()
	print(OS.get_user_data_dir())
	
	current_scene = root.get_child( root.get_child_count() -1 )
	load_game()
#	save_game()


func check_lock(level_id):
	if levels_states.has(str(level_id)):
		return levels_states[str(level_id)]
		
	return -INF


func next_level():
	if levels_states.has(str(level)):
		levels_states[str(level)] = 1
	level += 1
	if level > levels.size() - 1:
		level = 0
	else:
		if levels_states.has(str(level)):
			levels_states[str(level)] = 0
	save_game()
	print("next level")
	goto_scene("res://scenes/main.tscn")

func set_level(value):
	level = value
	if level > levels.size() - 1:
		level = 0

func reload_current():
	if current_scene_path != "":
		goto_scene(current_scene_path)


func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
	if (current_scene != null):
		current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	current_scene_path = path

func _input(event):
	if Input.is_action_just_pressed("full_scr"):
		OS.window_fullscreen = !OS.window_fullscreen

func create_default_locks():
	levels_states.clear()
	for i in range(MAX_STAGE):
		levels_states[str(i)] = -1
	levels_states["0"] = 0

func save_game():
	var savegame = File.new()
	savegame.open(SAVE_PATH, File.WRITE)
	for i in range(MAX_STAGE):
		if levels_states.has(str(i)):
			savegame.store_line(to_json( {str(i) : levels_states[str(i)]}))
		else:
			savegame.store_line(to_json( {str(i) : -1}))
	savegame.close()

# Завантаження гри
func load_game():
	var save_file = File.new()
	if !save_file.file_exists(SAVE_PATH) or erast:
		create_default_locks()
		erast = false
		save_game()
		print("new")
		return null
	save_file.open(SAVE_PATH, File.READ)
#	levels_states = parse_json(save_file.get_as_text())
	while not save_file.eof_reached():
		var current_line = parse_json(save_file.get_line())
		if current_line != null:
#			print(current_line.keys()[0] + " " + str(int(current_line.values()[0])))
			levels_states[current_line.keys()[0]] = int(current_line.values()[0])
# First we need to create the object and add it to the tree and set its position.
