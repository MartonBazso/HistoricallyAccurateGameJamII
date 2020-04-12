extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	#globals.load_game()
	print(globals.current_level) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	if globals.current_level == 0:
		get_tree().change_scene("res://Tutorial.tscn")
	else:
		get_tree().change_scene("res://Level"+str(globals.current_level)+".tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://Credits.tscn") # Replace with function body.


func _on_Controls_pressed():
	get_tree().change_scene("res://Controls.tscn") # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit() # Replace with function body.
