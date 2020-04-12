extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
signal restart_pressed
signal next_pressed
export(String) var fasz = "asdasdad"

func _ready():
	pass

func set_text(var text):
	$Label.text = text

func next_lvl_button_on(var win):
	$VBoxContainer/Next.visible = win
	$VBoxContainer/Restart.visible = !win

func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_Next_pressed():
	globals.current_level += 1
	globals.save_game()
	if globals.current_level == 10:
		get_tree().change_scene("res://FinishScreen.tscn")
	else:
		get_tree().change_scene("res://Level"+str(globals.current_level)+".tscn")

