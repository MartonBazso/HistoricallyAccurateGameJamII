extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_level = 0
#    lvl nbr: [time, npc]
var dictionary = {
		0: [30.0, 4.0],
		1: [30.0, 5.0],
		2: [30.0, 6.0],
		3: [45.0, 7.0],
		4: [30.0, 10.0],
		5: [80.0, 5.0],
		6: [90.0, 5.0],
		7: [90.0, 6.0],
		8: [100.0, 6.0],
		9: [120.0, 6.0],
	}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_string(to_json(get_params()))
	save_game.close()
	return save_game.get_path_absolute()

func get_params():
	var save_dict = {
	    "current_level" : current_level
	}
	return save_dict


func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
	    return 
	
	save_game.open("user://savegame.save", File.READ)
	while !save_game.eof_reached():
		var saved_file = parse_json(save_game.get_line())
		for i in saved_file.keys():
			set(i, saved_file[i])
	save_game.close()